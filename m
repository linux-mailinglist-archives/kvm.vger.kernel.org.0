Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B9774B28
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjHHUmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjHHUls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:41:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAE78DCCF;
        Tue,  8 Aug 2023 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691515897; x=1723051897;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eqRRMLl2kIoz0ZwHwY02c6d7SX45/i2Q/jssTnU7/tA=;
  b=JmKkWqIA0/GVc8tGbrgwAMTXe8xpEcUH9BPs/q6KFqCy17gspPRcU9tt
   gHlw+wnwJLuV7Fodg4OpAbUUhbXXGYvgMawZB0jgDcA5Yvy5kLOug2/46
   Drnu0Y0q0WoBxUaHzPyD1X1+sRwWPtSCjrzGb6T3B+DJhtF7PTnp0DAs+
   gZWErGyyoNJ6gj0lgdg63WDAHo1C4HC6xV4LEY9DsD2E8TGRdiRL/2+Uu
   fvoc+gNnp7IbctTqsqUp1GU48AF/HESn37ajJl7Ww8s83XJwCv6n/Rwyu
   Wc8soxrGVCoNx0rTaLysemGQZFFmuVcUK4eW6ONkxk2b+0ej9NFqagzDG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434581748"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="434581748"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 23:25:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734376741"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734376741"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga007.fm.intel.com with ESMTP; 07 Aug 2023 23:25:07 -0700
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
Subject: [PATCH RFV v2 00/13] Enable fixed counter 3 and topdown perf metrics for vPMU
Date:   Tue,  8 Aug 2023 14:30:58 +0800
Message-Id: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

         26,525.25 msec task-clock                       #    1.000 CPUs utilized
                 9      context-switches                 #    0.339 /sec
                 2      cpu-migrations                   #    0.075 /sec
                51      page-faults                      #    1.923 /sec
   125,330,033,745      cycles                           #    4.725 GHz
   238,172,965,287      instructions                     #    1.90  insn per cycle
    44,904,300,430      branches                         #    1.693 G/sec
        69,299,003      branch-misses                    #    0.15% of all branches
   751,979,445,222      TOPDOWN.SLOTS                    #     59.2 %  tma_backend_bound
                                                  #     38.0 %  tma_retiring
                                                  #      0.8 %  tma_bad_speculation
                                                  #      1.9 %  tma_frontend_bound
   286,047,083,084      topdown-retiring
    14,744,695,003      topdown-fe-bound
   445,289,789,131      topdown-be-bound
     5,897,878,000      topdown-bad-spec
       138,674,397      INT_MISC.UOP_DROPPING            #    5.228 M/sec

      26.528600835 seconds time elapsed

      26.527849000 seconds user
       0.000000000 seconds sys

Guest outputs:

  Performance counter stats for '/home/pnp/foo/foo':

         29,051.43 msec task-clock                       #    1.000 CPUs utilized
                10      context-switches                 #    0.344 /sec
                 0      cpu-migrations                   #    0.000 /sec
                51      page-faults                      #    1.756 /sec
   125,337,801,996      cycles                           #    4.314 GHz
   238,139,676,030      instructions                     #    1.90  insn per cycle
    44,897,906,380      branches                         #    1.545 G/sec
        69,402,326      branch-misses                    #    0.15% of all branches
   752,022,710,490      TOPDOWN.SLOTS                    #     58.4 %  tma_backend_bound
                                                  #     37.6 %  tma_retiring
                                                  #      1.2 %  tma_bad_speculation
                                                  #      2.7 %  tma_frontend_bound
   283,114,432,184      topdown-retiring
    20,643,760,680      topdown-fe-bound
   439,417,191,619      topdown-be-bound
     8,847,326,005      topdown-bad-spec
       138,873,309      INT_MISC.UOP_DROPPING            #    4.780 M/sec

      29.058833449 seconds time elapsed

      29.048761000 seconds user
       0.004003000 seconds sys

2. perf stat -e slots ./foo

Host outputs:

 Performance counter stats for '/home/sdp/work/foo/foo':

   713,292,346,950      slots

      25.472861484 seconds time elapsed

      25.470978000 seconds user
       0.000000000 seconds sys

Guest outputs:

 Performance counter stats for '/home/pnp/foo/foo':

   713,286,331,824      slots

      25.264007882 seconds time elapsed

      25.259790000 seconds user
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
# Samples: 109K of event 'slots'
# Event count (approx.): 715723903347
#
# Overhead  Command  Shared Object     Symbol
# ........  .......  ................  ..................................
#
    74.83%  foo      libc.so.6         [.] __random
     7.22%  foo      foo               [.] qux
     7.07%  foo      libc.so.6         [.] __random_r
     5.40%  foo      foo               [.] main
     1.82%  foo      foo               [.] bar
     1.75%  foo      foo               [.] random@plt
     1.73%  foo      foo               [.] foo
     0.02%  foo      [kernel.vmlinux]  [k] arch_asym_cpu_priority


Guest outputs:

# Total Lost Samples: 0
#
# Samples: 7K of event 'slots'
# Event count (approx.): 24532005986
#
# Overhead  Command  Shared Object     Symbol
# ........  .......  ................  ....................
#
    75.21%  foo      libc.so.6         [.] __random
     7.19%  foo      libc.so.6         [.] __random_r
     7.12%  foo      foo               [.] qux
     5.21%  foo      foo               [.] main
     1.90%  foo      foo               [.] foo
     1.81%  foo      foo               [.] bar
     1.56%  foo      foo               [.] random@plt
     0.00%  perf-ex  [kernel.vmlinux]  [k] native_write_msr


To support the guest topdown metrics feature, we have to do several
fundamental changes for perf system and vPMU code, we tried to avoid
these changes AMAP, but it seems it's inevitable. If you have any idea,
please suggest.

The fundamental changes:
1. perf/core: Add function perf_event_create_group_kernel_counters()
   Add a new API to create group events from kernel space
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

Dapeng Mi (13):
  KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
  KVM: x86/pmu: Support PMU fixed counter 3
  perf/core: Add function perf_event_group_leader_check()
  perf/core: Add function perf_event_move_group()
  perf/core: Add function perf_event_create_group_kernel_counters()
  perf/x86: Fix typos and inconsistent indents in perf_event header
  perf/x86: Add constraint for guest perf metrics event
  perf/core: Add new function perf_event_topdown_metrics()
  perf/x86/intel: Handle KVM virtual metrics event in perf system
  KVM: x86/pmu: Extend pmc_reprogram_counter() to create group events
  KVM: x86/pmu: Support topdown perf metrics feature
  KVM: x86/pmu: Handle PERF_METRICS overflow
  KVM: x86/pmu: Expose Topdown in MSR_IA32_PERF_CAPABILITIES

 arch/x86/events/intel/core.c      |  72 +++++--
 arch/x86/events/perf_event.h      |  10 +-
 arch/x86/include/asm/kvm_host.h   |  19 +-
 arch/x86/include/asm/perf_event.h |  21 +-
 arch/x86/kvm/pmu.c                | 142 +++++++++++--
 arch/x86/kvm/pmu.h                |  50 ++++-
 arch/x86/kvm/svm/pmu.c            |   2 +
 arch/x86/kvm/vmx/capabilities.h   |   1 +
 arch/x86/kvm/vmx/pmu_intel.c      |  67 ++++++
 arch/x86/kvm/vmx/vmx.c            |   2 +
 arch/x86/kvm/vmx/vmx.h            |   5 +
 arch/x86/kvm/x86.c                |   5 +-
 include/linux/perf_event.h        |  19 ++
 kernel/events/core.c              | 326 ++++++++++++++++++++----------
 14 files changed, 590 insertions(+), 151 deletions(-)


base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.34.1

