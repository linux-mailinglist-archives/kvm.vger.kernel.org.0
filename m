Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411BD183F00
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgCMCSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:18:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgCMCSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:18:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:18:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743728"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:18:42 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v9 00/10] Guest Last Branch Recording Enabling
Date:   Fri, 13 Mar 2020 10:16:06 +0800
Message-Id: <20200313021616.112322-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Please help review your interesting parts in this stable version,
e.g. the first four patches involve the perf event subsystem
and the fifth patch concerns the KVM userspace interface.

---

The last branch recording (LBR) is a performance monitor unit (PMU)
feature on Intel processors that records a running trace of the most
recent branches taken by the processor in the LBR stack. This patch
series is going to enable this feature for plenty of KVM guests.

The userspace could configure whether it's enabled or not for each
guest via vm_ioctl KVM_CAP_X86_GUEST_LBR. As a first step, a guest
could only enable LBR feature if its cpu model is the same as the
host since the LBR feature is still one of model specific features.
The record format defined in bits [0,5] of IA32_PERF_CAPABILITIES
and cpuid PDCM bit is also exposed to the guest when it's enabled.

If it's enabled on the guest, the guest LBR driver would accesses the
LBR MSR (including IA32_DEBUGCTLMSR and stack MSRs) as host does.
The first guest access on the LBR related MSRs is always interceptible.
The KVM trap would create a special LBR event (called guest LBR event)
which enables the callstack mode and none of hardware counter is bound.
The host perf would enable and schedule this event as usual. 

Guest's first access to a LBR-related msr gets trapped to KVM, which
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

You may check more details in each commit message.

---

LBR testcase:
echo 1 > /proc/sys/kernel/watchdog
echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
echo 5000 > /proc/sys/kernel/perf_event_max_sample_rate
echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
./perf record -b ./br_instr a

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

---

v8->v9 Changelog:
- using guest_lbr_constraint to create guest LBR event without hw counter;
  (please check perf changes in patch 0003)
- rename 'cpuc->vcpu_lbr' to 'cpuc->guest_lbr_enabled';
  (please check host LBR changes in patch 0004)
- replace 'pmu->lbr_used' mechanism with lazy release kvm_pmu_lbr_cleanup();
- refactor IA32_PERF_CAPABILITIES trap via get_perf_capabilities();
- refactor kvm_pmu_lbr_enable() with kvm_pmu_lbr_setup();
- simplify model-specific LBR functionality check;
- rename x86_perf_get_lbr_stack to x86_perf_get_lbr;
- rename intel_pmu_lbr_confirm() to kvm_pmu_availability_check(); 

Previous:
https://lore.kernel.org/lkml/1565075774-26671-1-git-send-email-wei.w.wang@intel.com/

Like Xu (7):
  perf/x86/lbr: Add interface to get basic information about LBR stack
  perf/x86: Add constraint to create guest LBR event without hw counter
  perf/x86: Keep LBR stack unchanged on the host for guest LBR event
  KVM: x86: Add KVM_CAP_X86_GUEST_LBR interface to dis/enable LBR
    feature
  KVM: x86/pmu: Add LBR feature emulation via guest LBR event
  KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
  KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES to guest for LBR record
    format

Wei Wang (3):
  perf/x86: Fix msr variable type for the LBR msrs
  KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
  KVM: x86: Remove the common trap handler of the MSR_IA32_DEBUGCTLMSR

 Documentation/virt/kvm/api.rst    |  28 +++
 arch/x86/events/core.c            |   9 +-
 arch/x86/events/intel/core.c      |  29 +++
 arch/x86/events/intel/lbr.c       |  55 +++++-
 arch/x86/events/perf_event.h      |  21 ++-
 arch/x86/include/asm/kvm_host.h   |   7 +
 arch/x86/include/asm/perf_event.h |  24 ++-
 arch/x86/kvm/cpuid.c              |   3 +-
 arch/x86/kvm/pmu.c                |  28 ++-
 arch/x86/kvm/pmu.h                |  26 ++-
 arch/x86/kvm/pmu_amd.c            |   7 +-
 arch/x86/kvm/vmx/pmu_intel.c      | 291 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c            |   4 +-
 arch/x86/kvm/vmx/vmx.h            |   2 +
 arch/x86/kvm/x86.c                |  42 +++--
 include/linux/perf_event.h        |   7 +
 include/uapi/linux/kvm.h          |   1 +
 kernel/events/core.c              |   7 -
 tools/include/uapi/linux/kvm.h    |   1 +
 19 files changed, 540 insertions(+), 52 deletions(-)

-- 
2.21.1

