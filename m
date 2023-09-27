Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448497AF9B5
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjI0Et5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjI0EtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:49:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570E1117F6;
        Tue, 26 Sep 2023 20:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695785024; x=1727321024;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hx6gC1qpUUarpPXth+POxObmv3y6cRCzbhRQZaA+gIE=;
  b=EZDJivMgxlfRU0cGHpR/n7M5Ol4Il5X9PNZ5Lr+9NNt9Z4osOYrLv+oX
   XkirXVf6pQrnzHadUB856dNJATVdhf64/lTT5o/uw2SSXiV4PFNRr5fxx
   zq/2xLPVsSZIAW5OZIpagG7/6Lic7z78jj2yIr/E14Bu5kVk78J6j6Ei0
   JEYqaTTpCfL0iWAF7pRw7yQ3qW+QFycVlyn69QbSHrCEjg2fhTpmc0ZuI
   YpPWUlFnZ4I1ZO4vdOy8TG0yfytqGCgD1oN9y3FuXVjm+IippTRDdnfdM
   BZzTxwo+J6VJlPPQ8e4VoHe1R7gbbaWE6qdySyYwSwyZoZaPsH/HdpunM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="366780689"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="366780689"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 20:23:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="864636912"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="864636912"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2023 20:23:38 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v4 00/13] Enable fixed counter 3 and topdown perf metrics for vPMU
Date:   Wed, 27 Sep 2023 11:31:11 +0800
Message-Id: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a RFC patchset to enable Intel PMU fixed counter 3 and topdown
perf metrics feature for KVM vPMU.

The TopDown Microarchitecture Analysis (TMA) Method is a structured
analysis methodology to identify critical performance bottlenecks in
out-of-order processors. The details about topdown metrics support on
Intel processors can be found in section "Performance Metrics" of Intel's
SDM Volume 3[1]. Kernel enabling code has also been merged, see
patchset[2] to learn more about the feature.

The TMA method is quite powerful and efficient to help developers to
identify the performance bottleneck in the program. The TMA method has
been integrated into multiple performance analysis tools, such as perf,
Vtune. Developers can leverage TMA method to analyze their program's
performance bottleneck easily with these tools and improve their program's
performance. TMA method is becoming the most widely used performance
analysis method on x86 platform. Currently the TMA method has been
supported fairly well on Native, but it's still not supported in Guest
environment. Since the environment difference between Host and Guest,
even same program may show different performance bottleneck between Guest
and Host. Obviously, the most straightforward and best method to
profiling Guest performance bottleneck is to run the TMA method in Guest
directly. So supporting topdown perf metrics in Guest becomes a real and
important requirement and we hope this patchset can mitigate this gap.

Like Xu posted a patch series to support guest Topdown[3], the patchset
creates a group of topdown metric events in KVM by binding to fixed counter
3 to obtain hardware values and the guest value of PERF_METRICS MSR is
assembled based on the count of grouped metric events.

This patchset improves Like's proposal, it leverages mature vPMU PMC
emulation framework and current perf topdown metric handling logic to
support guest topdown metrics feature.

In current perf logic, an events group is required to handle the topdown
metrics profiling, and the events group couples a slots event which
acts events group leader and multiple metric events. To coordinate with
the perf topdown metrics handing logic and reduce the code changes in
KVM, we choose to follow current mature vPMU PMC emulation framework. The
only difference is that we need to create a events group for fixed
counter 3 and manipulate FIXED_CTR3 and PERF_METRICS MSRS together
instead of a single event and only manipulating FIXED_CTR3 MSR.

When guest writes PERF_METRICS MSR at first, KVM would create an event
group which couples a slots event and a virtual metrics event. In this
event group, slots event claims the fixed counter 3 HW resource and acts
as group leader which is required by perf system. The virtual metrics
event claims the PERF_METRICS MSR. This event group is just like the perf
metrics events group on host and is scheduled by host perf system.

In this proposal, the count of slots event is calculated and emulated
on host and returned to guest just like other normal counters, but there
is a difference for the metrics event processing. KVM doesn't calculate
the real count of topdown metrics, it just stores the raw data of
PERF_METRICS MSR and directly returnthe stored raw data to guest. Thus,
guest can get the real HW PERF_METRICS data and guarantee the calculation
accuracy of topdown metrics.

Comparing with Like's patchset, this proposal brings two benefits.

1. Reduce the created perf events number
   Like's patchset needs to create 4 (Ice Lake) or 8 (Sapphire Rapids)
   metric events, whereas this patchset only needs to create 1 metric
   event.

2. Increase the accuracy of metric calculation
   Like's patchset needs to do twice metric count conversion. The first
   conversion happens on perf system, perf topdown metrics handling
   logic reads the metric percentage from PERF_METRICS MSR and times with
   elapsed slots count and obtains the metric count. The second conversion
   happens on KVM, KVM needs to convert the metric count back to metric
   percentage by using metric count divide elapsed slots again and then
   assembles the 4 or 8 metric percentage values to the virtual
   PERF_METRICS MSR and return to Guest at last. Considering each metric
   percentage in PERF_METRICS MSR is represented with only 8 bits, the
   twice conversions (once multiplication and once division) definitely
   cause accuracy loss in theory. Since this patchset directly returns
   the raw data of PERF_METRICS MSR to guest, it won't have any accuracy
   loss.

The patchset is rebased on latest kvm-x86/next branch and it is tested
on both Host and Guest (SPR Platform) with below perf commands. The 'foo'
is a backend-bound benchmark. We can see the output of perf commands are
quite close between host and guest.

1. perf stat ./foo

Host outputs:

 Performance counter stats for '/home/sdp/work/foo/foo':

         33,485.69 msec task-clock                       #    1.000 CPUs utilized
                44      context-switches                 #    1.314 /sec
                 0      cpu-migrations                   #    0.000 /sec
                50      page-faults                      #    1.493 /sec
   125,321,811,275      cycles                           #    3.743 GHz
   238,142,619,081      instructions                     #    1.90  insn per cycle
    44,898,337,778      branches                         #    1.341 G/sec
        69,302,880      branch-misses                    #    0.15% of all branches
                        TopdownL1                 #     59.2 %  tma_backend_bound
                                                  #      0.8 %  tma_bad_speculation
                                                  #      1.9 %  tma_frontend_bound
                                                  #     38.0 %  tma_retiring
                        TopdownL2                 #      0.8 %  tma_branch_mispredicts
                                                  #     51.8 %  tma_core_bound
                                                  #      0.8 %  tma_fetch_bandwidth
                                                  #      1.2 %  tma_fetch_latency
                                                  #      8.6 %  tma_heavy_operations
                                                  #     29.4 %  tma_light_operations
                                                  #      0.0 %  tma_machine_clears
                                                  #      7.5 %  tma_memory_bound

      33.490329445 seconds time elapsed

      33.483624000 seconds user
       0.003999000 seconds sys

Guest outputs:

 Performance counter stats for '/home/pnp/foo/foo':

         33,753.35 msec task-clock                       #    1.000 CPUs utilized
                12      context-switches                 #    0.356 /sec
                 0      cpu-migrations                   #    0.000 /sec
                51      page-faults                      #    1.511 /sec
   125,598,628,777      cycles                           #    3.721 GHz
   238,420,589,003      instructions                     #    1.90  insn per cycle
    44,952,453,723      branches                         #    1.332 G/sec
        69,450,137      branch-misses                    #    0.15% of all branches
                        TopdownL1                 #     58.0 %  tma_backend_bound
                                                  #      1.2 %  tma_bad_speculation
                                                  #      3.1 %  tma_frontend_bound
                                                  #     37.6 %  tma_retiring
                        TopdownL2                 #      1.2 %  tma_branch_mispredicts
                                                  #     49.4 %  tma_core_bound
                                                  #      1.2 %  tma_fetch_bandwidth
                                                  #      1.9 %  tma_fetch_latency
                                                  #      8.2 %  tma_heavy_operations
                                                  #     29.4 %  tma_light_operations
                                                  #      0.0 %  tma_machine_clears
                                                  #      8.6 %  tma_memory_bound

      33.763389325 seconds time elapsed

      33.748767000 seconds user
       0.008005000 seconds sys

2. perf stat -e slots ./foo

Host outputs:

 Performance counter stats for '/home/sdp/work/foo/foo':

   713,234,232,102      slots

      31.786272154 seconds time elapsed

      31.782986000 seconds user
       0.003999000 seconds sys

Guest outputs:

 Performance counter stats for '/home/pnp/foo/foo':

   714,054,317,454      slots

      32.279685600 seconds time elapsed

      32.275457000 seconds user
       0.004002000 seconds sys

3.
echo 0 > /proc/sys/kernel/nmi_watchdog
echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
echo 100000 > /proc/sys/kernel/perf_event_max_sample_rate
echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
perf record -e slots ./foo && perf report

Host outputs:

# Total Lost Samples: 0
#
# Samples: 129K of event 'slots'
# Event count (approx.): 716048770762
#
# Overhead  Command  Shared Object     Symbol
# ........  .......  ................  ...................................
#
    74.50%  foo      libc.so.6         [.] random
     7.25%  foo      libc.so.6         [.] random_r
     7.22%  foo      foo               [.] qux
     5.45%  foo      foo               [.] main
     1.86%  foo      foo               [.] random@plt
     1.80%  foo      foo               [.] foo
     1.78%  foo      foo               [.] bar
     0.02%  foo      [kernel.vmlinux]  [k] perf_adjust_freq_unthr_context
     0.02%  foo      [kernel.vmlinux]  [k] timekeeping_advance
     0.02%  foo      [kernel.vmlinux]  [k] _raw_spin_lock_irqsave
     0.01%  foo      [kernel.vmlinux]  [k] __wake_up_common
     0.01%  foo      [kernel.vmlinux]  [k] call_function_single_prep_ipi

Guest outputs:

# Total Lost Samples: 0
#
# Samples: 6K of event 'slots'
# Event count (approx.): 19515232625
#
# Overhead  Command  Shared Object     Symbol
# ........  .......  ................  ..................................
#
    75.02%  foo      libc.so.6         [.] __random
     7.07%  foo      libc.so.6         [.] __random_r
     7.03%  foo      foo               [.] qux
     5.21%  foo      foo               [.] main
     2.01%  foo      foo               [.] foo
     1.85%  foo      foo               [.] bar
     1.79%  foo      foo               [.] random@plt
     0.02%  foo      [kernel.vmlinux]  [k] task_mm_cid_work
     0.00%  foo      [kernel.vmlinux]  [k] lock_acquire
     0.00%  perf-ex  [kernel.vmlinux]  [k] perf_adjust_freq_unthr_context
     0.00%  foo      [kernel.vmlinux]  [k] native_write_msr
     0.00%  perf-ex  [kernel.vmlinux]  [k] native_write_msr

To support the guest topdown metrics feature, we have to do several
fundamental changes for perf system and vPMU code, we tried to avoid
these changes AMAP, but it seems it's inevitable. If you have any idea,
please suggest.

The fundamental changes:
1. Add *group_leader for perf_event_create_group_kernel_counters()
   Add an argument *group_leader for perf_event_create_group_kernel_counters()
so group events can be created from kernel space.
2. perf/core: Add new function perf_event_topdown_metrics()
   Add a new API to update topdown metrics values
3. perf/x86/intel: Handle KVM virtual metrics event in perf system
   Add virtual metrics event processing logic in topdown metrics
processing code
4. KVM: x86/pmu: Extend pmc_reprogram_counter() to create group events
   Extend pmc_reprogram_counter() to be capable to create group events
instead of just single event

References:
[1]: Intel 64 and IA-32 Architectures Software Developer Manual
 Combined Volumes: 1, 2A, 2B, 2C, 2D, 3A, 3B, 3C, 3D, and 4
https://cdrdv2.intel.com/v1/dl/getContent/671200
[2]: perf/x86/intel: Support TopDown metrics on Ice Lake
https://lwn.net/ml/linux-kernel/20191203141212.7704-1-kan.liang@linux.intel.com/
[3]: KVM: x86/pmu: Enable Fixed Counter3 and Topdown Perf Metrics
https://lwn.net/ml/linux-kernel/20221212125844.41157-1-likexu@tencent.com/

Changelog:
v3 -> v4:
  * Fix building error on riscv.
  * Rebase this patchset to latest kvm-x86 code (v6.6-rc2+)
v2 -> v3:
  * Add an argument in perf_event_create_group_kernel_counters() to
    create group events instead of introducing a new function.
  * Warning fix.

Dapeng Mi (13):
  KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
  KVM: x86/pmu: Support PMU fixed counter 3
  perf/core: Add function perf_event_group_leader_check()
  perf/core: Add function perf_event_move_group()
  perf/core: Add *group_leader for
    perf_event_create_group_kernel_counters()
  perf/x86: Fix typos and inconsistent indents in perf_event header
  perf/x86: Add constraint for guest perf metrics event
  perf/core: Add new function perf_event_topdown_metrics()
  perf/x86/intel: Handle KVM virtual metrics event in perf system
  KVM: x86/pmu: Extend pmc_reprogram_counter() to create group events
  KVM: x86/pmu: Support topdown perf metrics feature
  KVM: x86/pmu: Handle PERF_METRICS overflow
  KVM: x86/pmu: Expose Topdown in MSR_IA32_PERF_CAPABILITIES

 arch/arm64/kvm/pmu-emul.c                 |   2 +-
 arch/riscv/kvm/vcpu_pmu.c                 |   2 +-
 arch/x86/events/intel/core.c              |  74 ++++--
 arch/x86/events/perf_event.h              |  10 +-
 arch/x86/include/asm/kvm_host.h           |  19 +-
 arch/x86/include/asm/perf_event.h         |  21 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |   4 +-
 arch/x86/kvm/pmu.c                        | 141 ++++++++--
 arch/x86/kvm/pmu.h                        |  50 +++-
 arch/x86/kvm/svm/pmu.c                    |   2 +
 arch/x86/kvm/vmx/capabilities.h           |   1 +
 arch/x86/kvm/vmx/pmu_intel.c              |  71 ++++-
 arch/x86/kvm/vmx/vmx.c                    |   2 +
 arch/x86/kvm/vmx/vmx.h                    |   5 +
 arch/x86/kvm/x86.c                        |   5 +-
 include/linux/perf_event.h                |  14 +
 kernel/events/core.c                      | 304 ++++++++++++++--------
 kernel/events/hw_breakpoint.c             |   4 +-
 kernel/events/hw_breakpoint_test.c        |   2 +-
 kernel/watchdog_perf.c                    |   2 +-
 20 files changed, 574 insertions(+), 161 deletions(-)


base-commit: 5804c19b80bf625c6a9925317f845e497434d6d3
-- 
2.34.1

