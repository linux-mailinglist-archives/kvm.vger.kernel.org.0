Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9A1D2A1E
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgENIbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:12077 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgENIbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:17 -0400
IronPort-SDR: 02XFEZLVyI27FuKIx1QIQrtczQXVcW89DVUxTR8icEeDRjXDGAOU/oJrfmd19G4hzAS/hX1Sau
 1erzp7CzY4rw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:09 -0700
IronPort-SDR: ui5pev/3O5s9inemVpVoBPby6R+/hUPU/HyUpfcEzVlSXyj9LgkREi4cA8Cg5iAoBltOeesObj
 odan99aHHgYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341539902"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:05 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 00/11] Guest Last Branch Recording Enabling
Date:   Thu, 14 May 2020 16:30:43 +0800
Message-Id: <20200514083054.62538-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,
Would you mind acking the host perf patches if it looks good to you ?

Hi Paolo,
Please help review the KVM proposal changes in this stable version.

Now, we can use upstream QEMU w/ '-cpu host' to test this feature, and
disable it by clearing the LBR format bits in the IA32_PERF_CAPABILITIES.

v10->v11 Changelog:
- add '.config = INTEL_FIXED_VLBR_EVENT' to the guest LBR event config;
- rewrite is_guest_lbr_event() with 'config == INTEL_FIXED_VLBR_EVENT';
- emit pr_warn() on the host when guest LBR is temporarily unavailable;
- drop the KVM_CAP_X86_GUEST_LBR patch;
- rewrite MSR_IA32_PERF_CAPABILITIES patch LBR record format;
- split 'kvm_pmu->lbr_already_available' into a separate patch;
- split 'pmu_ops->availability_check' into a separate patch;
- comments and naming refinement, misc;

You may check more details in each commit.

Previous:
https://lore.kernel.org/kvm/20200423081412.164863-1-like.xu@linux.intel.com/

---

The last branch recording (LBR) is a performance monitor unit (PMU)
feature on Intel processors that records a running trace of the most
recent branches taken by the processor in the LBR stack. This patch
series is going to enable this feature for plenty of KVM guests.

The userspace could configure whether it's enabled or not for each
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

Like Xu (9):
  perf/x86/core: Refactor hw->idx checks and cleanup
  perf/x86/lbr: Add interface to get basic information about LBR stack
  perf/x86: Add constraint to create guest LBR event without hw counter
  perf/x86: Keep LBR stack unchanged in host context for guest LBR event
  KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES for LBR record format
  KVM: x86/pmu: Emulate LBR feature via guest LBR event
  KVM: x86/pmu: Release guest LBR event via vPMU lazy release mechanism
  KVM: x86/pmu: Check guest LBR availability in case host reclaims them
  KVM: x86/pmu: Reduce the overhead of LBR passthrough or cancellation

Wei Wang (2):
  perf/x86: Fix variable types for LBR registers
  KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in

 arch/x86/events/core.c            |  26 ++-
 arch/x86/events/intel/core.c      | 105 ++++++----
 arch/x86/events/intel/lbr.c       |  56 +++++-
 arch/x86/events/perf_event.h      |  12 +-
 arch/x86/include/asm/kvm_host.h   |  13 ++
 arch/x86/include/asm/perf_event.h |  34 +++-
 arch/x86/kvm/cpuid.c              |   2 +-
 arch/x86/kvm/pmu.c                |  19 +-
 arch/x86/kvm/pmu.h                |  15 +-
 arch/x86/kvm/svm/pmu.c            |   7 +-
 arch/x86/kvm/vmx/capabilities.h   |  15 ++
 arch/x86/kvm/vmx/pmu_intel.c      | 320 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c            |  12 +-
 arch/x86/kvm/vmx/vmx.h            |   2 +
 arch/x86/kvm/x86.c                |  18 +-
 15 files changed, 564 insertions(+), 92 deletions(-)

-- 
2.21.3

