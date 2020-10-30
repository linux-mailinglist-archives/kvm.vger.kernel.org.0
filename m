Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6D729FC57
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgJ3D4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:56:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:4238 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3D4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:56:37 -0400
IronPort-SDR: VMKVo7krnmGnC7XUZ5Kju+u3ot9aU9S2Uk7etFtpcivip6eXdgiLF4UtLS8CB9D9HJCPJ24pEW
 sRaUpeukVntw==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685723"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685723"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:56:37 -0700
IronPort-SDR: ASIsZXV24m2E6Y7pyH77ueexEcpNMS1k/QUGq5WkeYD+FjYebJAFlzH9BEKYA5Oiqb/AisT5wA
 Eha1MyJVNo3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770378"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:33 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v13 00/10] Guest Last Branch Recording Enabling
Date:   Fri, 30 Oct 2020 11:52:10 +0800
Message-Id: <20201030035220.102403-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

PMU features matter.  Please help review this rebased version for the
next kernel release and with this patch set, the following error will be
gone forever and cloud developers can better understand their
programs with less profiling overhead:

  $ perf record -b lbr ${WORKLOAD}
  or $ perf record --call-graph lbr ${WORKLOAD}
  Error:
  cycles: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

We already have host perf support to implement guest LBR, please
check more details in each commit and feel free to test and comment.

v12->v13 Changelog:
- remove perf patches since they're merged already;
- add a minor patch to refactor MSR_IA32_DEBUGCTLMSR set/get handler;
- add a minor patch to expose vmx_set_intercept_for_msr();
- add a minor patch to adjust features visibility via IA32_PERF_CAPABILITIES;
- spilt the big patch to three pieces (0004-0006) for better understanding and review;
- make the LBR_FMT exposure patch as the last step to enable guest LBR;

Previous:
https://lore.kernel.org/kvm/20200613080958.132489-1-like.xu@linux.intel.com/

---

The last branch recording (LBR) is a performance monitor unit (PMU)
feature on Intel processors that records a running trace of the most
recent branches taken by the processor in the LBR stack. This patch
series is going to enable this feature for plenty of KVM guests.

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

Like Xu (10):
  KVM: x86: Move common set/get handler of MSR_IA32_DEBUGCTLMSR to VMX
  KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static and expose it
  KVM: x86/pmu: Use IA32_PERF_CAPABILITIES to adjust features visibility
  KVM: vmx/pmu: Clear PMU_CAP_LBR_FMT when guest LBR is disabled
  KVM: vmx/pmu: Create a guest LBR event when vcpu sets DEBUGCTLMSR_LBR
  KVM: vmx/pmu: Pass-through LBR msrs to when the guest LBR event is ACTIVE
  KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
  KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
  KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES
  KVM: vmx/pmu: Release guest LBR event via lazy release mechanism

 arch/x86/kvm/pmu.c              |  12 +-
 arch/x86/kvm/pmu.h              |   5 +
 arch/x86/kvm/vmx/capabilities.h |  22 ++-
 arch/x86/kvm/vmx/pmu_intel.c    | 292 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  52 +++++-
 arch/x86/kvm/vmx/vmx.h          |  28 +++
 arch/x86/kvm/x86.c              |  15 +-
 7 files changed, 400 insertions(+), 26 deletions(-)

-- 
2.21.3

