----------------------------------------------------------------------------------------------------
-- Script:      cpu_nop_brk.lua
-- Description: CPU test.  Sanity test for NOP instructions, BRK instructions, and querying the PC.
----------------------------------------------------------------------------------------------------
dofile("../scripts/inc/nesdbg.lua")

local results = {}

local testTbl =
{
  -- Test 1
  { code     = { Ops.BRK },
    pcOffset = 1 },

  -- Test 2
  { code     = { Ops.NOP, Ops.BRK },
    pcOffset = 2 },

  -- Test 3
  { code     = { Ops.NOP, Ops.NOP, Ops.BRK },
    pcOffset = 3 },

  -- Test 4
  { code     = { Ops.NOP, Ops.NOP, Ops.BRK, Ops.NOP, Ops.NOP },
    pcOffset = 3 },

  -- Test 5
  { code     = { Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.BRK },
    pcOffset = 8 },

  -- Test 6
  { code     = { Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.BRK,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP },
    pcOffset = 8 },

  -- Test 7
  { code     = { Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.BRK,
                 Ops.BRK, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.BRK },
    pcOffset = 48 },

  -- Test 7
  { code     = { Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP,
                 Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.NOP, Ops.BRK },
    pcOffset = 456 },
}

for subTestIdx = 1, #testTbl do
  local curTest = testTbl[subTestIdx]

  local startPc = GetPc()

  nesdbg.CpuMemWr(startPc, #curTest.code, curTest.code)

  nesdbg.DbgRun()
  nesdbg.WaitForBrk()

  local endPc = GetPc()

  if ((startPc + curTest.pcOffset) == endPc) then
    results[subTestIdx] = ScriptResult.Pass
  else
    results[subTestIdx] = ScriptResult.Fail
  end

  ReportSubTestResult(subTestIdx, results[subTestIdx])
end

return ComputeOverallResult(results)

