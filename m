Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C919830A125
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBAFS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:18:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:9252 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhBAFSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:18:54 -0500
IronPort-SDR: /22J0W/X7AnvGjl7xJXZg+C2R/ruTftzSe7Z3psmdF4NBpsm2NGP8297b5Z3JmSPWlE848eMZO
 PIE2qw1pQUGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401823"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401823"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:08 -0800
IronPort-SDR: Dd8+6vNNpkn8FCHCUllE9b5q2m+/PL4s4k/XiV6zG4y7jfOSoM7u8G+Ozc8yaFhoTsPq5g4+Z9
 D5FLk+bZZbwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694252"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:04 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 00/11] KVM: x86/pmu: Guest Last Branch Recording Enabling
Date:   Mon,  1 Feb 2021 13:10:28 +0800
Message-Id: <20210201051039.255478-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi geniuses,

Please help review this new version which enables the guest LBR.

We already upstreamed the guest LBR support in the host perf, please
check more details in each commit and feel free to test and comment.

QEMU part: https://lore.kernel.org/qemu-devel/20210201045453.240258-1-like.xu@linux.intel.com
kvm-unit-tests: https://lore.kernel.org/kvm/20210201045751.243231-1-like.xu@linux.intel.com

v13-v14 Changelog:
- Rewrite crud about vcpu->arch.perf_capabilities;
- Add PERF_CAPABILITIES testcases to tools/testing/selftests/kvm;
- Add basic LBR testcases to the kvm-unit-tests (w/ QEMU patches);
- Apply rewritten commit log from Paolo;
- Queued the first patch "KVM: x86: Move common set/get handler ...";
- Rename 'already_passthrough' to 'msr_passthrough';
- Check the values of MSR_IA32_PERF_CAPABILITIES early;
- Call kvm_x86_ops.pmu_ops->cleanup() always and drop extra_cleanup;
- Use INTEL_PMC_IDX_FIXED_VLBR directly;
- Fix a bug in the vmx_get_perf_capabilities();

Previous:
https://lore.kernel.org/kvm/20210108013704.134985-1-like.xu@linux.intel.com/

---

The last branch recording (LBR) is a performance monitor unit (PMU)
feature on Intel processors that records a running trace of the most
recent branches taken by the processor in the LBR stack. This patch
series is going to enable this feature for plenty of KVM guests.

with this patch set, the following error will be gone forever and cloud
developers can better understand their programs with less profiling overhead:

  $ perf record -b lbr ${WORKLOAD}
  or $ perf record --call-graph lbr ${WORKLOAD}
  Error:
  cycles: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

The user space could configure whether it's enabled or not for each
guest via MSR_IA32_PERF_CAPABILITIES msr. As a first step, a guest
could only enable LBR feature if its cpu model is the same as the
host since the LBR feature is still one of model specific features.

If it's enabled on the guest, the guest LBR driver would accesses the
LBR MSR (including IA32_DEBUGCTLMSR and records MSRs) as host does.
The first guest access on the LBR related MSRs is always interceptible.
The KVM trap would create a special LBR event (called guest LBR event)
which enables the callstack mode and none of hardware counter is assigned.
The host perf would enable and schedule this event as usual. 

Guest's first access to a LBR registers gets trapped to KVM, which
creates a guest LBR perf event. It's a regular LBR perf event which gets
the LBR facility assigned from the perf subsystem. Once that succeeds,
the LBR stack msrs are passed through to the guest for efficient accesses.
However, if another host LBR event comes in and takes over the LBR
facility, the LBR msrs will be made interceptible, and guest following
accesses to the LBR msrs will be trapped and meaningless. 

Because saving/restoring tens of LBR MSRs (e.g. 32 LBR stack entries) in
VMX transition brings too excessive overhead to frequent vmx transition
itself, the guest LBR event would help save/restore the LBR stack msrs
during the context switching with the help of native LBR event callstack
mechanism, including LBR_SELECT msr.

If the guest no longer accesses the LBR-related MSRs within a scheduling
time slice and the LBR enable bit is unset, vPMU would release its guest
LBR event as a normal event of a unused vPMC and the pass-through
state of the LBR stack msrs would be canceled.

---

LBR testcase:
echo 1 > /proc/sys/kernel/watchdog
echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
echo 5000 > /proc/sys/kernel/perf_event_max_sample_rate
echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
perf record -b ./br_instr a
(perf record --call-graph lbr ./br_instr a)

- Perf report on the host:
Samples: 72K of event 'cycles', Event count (approx.): 72512
Overhead  Command   Source Shared Object           Source Symbol                           Target Symbol                           Basic Block Cycles
  12.12%  br_instr  br_instr                       [.] cmp_end                             [.] lfsr_cond                           1
  11.05%  br_instr  br_instr                       [.] lfsr_cond                           [.] cmp_end                             5
   8.81%  br_instr  br_instr                       [.] lfsr_cond                           [.] cmp_end                             4
   5.04%  br_instr  br_instr                       [.] cmp_end                             [.] lfsr_cond                           20
   4.92%  br_instr  br_instr                       [.] lfsr_cond                           [.] cmp_end                             6
   4.88%  br_instr  br_instr                       [.] cmp_end                             [.] lfsr_cond                           6
   4.58%  br_instr  br_instr                       [.] cmp_end                             [.] lfsr_cond                           5

- Perf report on the guest:
Samples: 92K of event 'cycles', Event count (approx.): 92544
Overhead  Command   Source Shared Object  Source Symbol                                   Target Symbol                                   Basic Block Cycles
  12.03%  br_instr  br_instr              [.] cmp_end                                     [.] lfsr_cond                                   1
  11.09%  br_instr  br_instr              [.] lfsr_cond                                   [.] cmp_end                                     5
   8.57%  br_instr  br_instr              [.] lfsr_cond                                   [.] cmp_end                                     4
   5.08%  br_instr  br_instr              [.] lfsr_cond                                   [.] cmp_end                                     6
   5.06%  br_instr  br_instr              [.] cmp_end                                     [.] lfsr_cond                                   20
   4.87%  br_instr  br_instr              [.] cmp_end                                     [.] lfsr_cond                                   6
   4.70%  br_instr  br_instr              [.] cmp_end                                     [.] lfsr_cond                                   5

Conclusion: the profiling results on the guest are similar to that on the host.

Like Xu (11):
  KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static
  KVM: x86/pmu: Set up IA32_PERF_CAPABILITIES if PDCM bit is available
  KVM: vmx/pmu: Add PMU_CAP_LBR_FMT check when guest LBR is enabled
  KVM: vmx/pmu: Expose DEBUGCTLMSR_LBR in the MSR_IA32_DEBUGCTLMSR
  KVM: vmx/pmu: Create a guest LBR event when vcpu sets DEBUGCTLMSR_LBR
  KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE
  KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
  KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
  KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
  KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES
  selftests: kvm/x86: add test for pmu msr MSR_IA32_PERF_CAPABILITIES

 arch/x86/kvm/pmu.c                            |   8 +-
 arch/x86/kvm/pmu.h                            |   2 +
 arch/x86/kvm/vmx/capabilities.h               |  19 +-
 arch/x86/kvm/vmx/pmu_intel.c                  | 281 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c                        |  55 +++-
 arch/x86/kvm/vmx/vmx.h                        |  28 ++
 arch/x86/kvm/x86.c                            |   2 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  | 149 ++++++++++
 10 files changed, 524 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c

-- 
2.29.2

