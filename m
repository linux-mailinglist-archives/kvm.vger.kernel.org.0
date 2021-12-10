Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10B24701B5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241916AbhLJNjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238651AbhLJNjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:17 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28224C061746;
        Fri, 10 Dec 2021 05:35:42 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x131so8450074pfc.12;
        Fri, 10 Dec 2021 05:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcEqlkXHP9ZzLk/utvAQtDlFTfoDwMaXmTyTNp2RW9I=;
        b=gIN4mBzOXNdl47BcUn6/kWzetMKmNO37uPrfXEN9FB9+1nivhPMy8hACPT79+A5tzS
         asYGcFoNa3aX/CnD+Hru4VdxQHKlKh7bjN8E50LuIJ+eeKRVtyDOMMrYlx/Wj16ylLXW
         RsGvEmXYyM7/JkrKVzXrUF9ew6f8saPQi800829zEZH4PBWFl3fXLedMMlgokAko983J
         qBgYKFQMSIoMoPCcsv3Y2rgWnVZK85Jz9MREO/MLy2O49tivExq10Wiu8WqYiSlYjbE8
         ltaHD2aKsBObr2zYKbVsSVsHFiHt2Or/4mIPPo6atATrLyvug7SFxu9bIVZWZV9+Zlha
         qPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcEqlkXHP9ZzLk/utvAQtDlFTfoDwMaXmTyTNp2RW9I=;
        b=sD7ap0o3UY4EAFK7Fin34xO5ayKt2FZQoEJ2+6AnpOpDhlG59U9zuiGlkVHpkjmdyG
         3cBEsJ4ZJvL46JMMMkpd2Urma/GtZi3vcjpFOHv8/EhxnOF+buH6Vxdhb3Pfyh8bDGpS
         bxnJhz5tHLJ7vB3V5gR/ufQYvqHqdm+tzHAHKSg/losSUOey7jfQuMIAc43xiWSWUH2Y
         dbOntrbHmxIYc0K8TjYnx+WRH/PBY7ePQkozXoeIgbN6LDviKzD151He8jhsUxS/XYNV
         BFwfOzugzbKuknJwl9JTiHYgMD4S8GxQ90lpAs+9/CegnMln4jgNTmSYHCNiNVq2kOtk
         Eg5w==
X-Gm-Message-State: AOAM532olYYhaf17rRmf1OU4XEzmkpZ2C6Rdn/tuyCoyvjbOWOgWr92b
        l5ioTjO7HBvkHbMSpQ3BmUU=
X-Google-Smtp-Source: ABdhPJxuZaNGIN95dCiHAXWHkP95vlsiDL5IBP2MIHc9GoX97W62pOVO+YEeY/5Ka7SWWflCU5PmXw==
X-Received: by 2002:a63:d3:: with SMTP id 202mr5206843pga.502.1639143341609;
        Fri, 10 Dec 2021 05:35:41 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:35:41 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 00/17] KVM: x86/pmu: Add *basic* support to enable guest PEBS via DS
Date:   Fri, 10 Dec 2021 21:35:08 +0800
Message-Id: <20211210133525.46465-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

It's said that Lingshan's plate is pretty full and as requested by Paolo [*],
a new rebased version is here. I'm looking forward to maintaining this
feature in an upstream manner, which may reduce the learning burden
for some newcomers at Intel virt team.

[*] https://lore.kernel.org/kvm/95bf3dca-c6d1-02c8-40b6-8bb29a3a7a36@redhat.com/

Please note that we need at least one diff to make the feature work
the next time the kvm/queue tree is merged with the tip/perf/core tree:

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 3490a1bb78e9..cee135fd6da0 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2851,7 +2851,7 @@ static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
 	struct perf_event *event = NULL;
 	int bit;
 
-	if (!unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest()))
+	if (!unlikely(perf_guest_state()))
 		return;
 
 	if (!x86_pmu.pebs_vmx || !x86_pmu.pebs_active ||
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0fb222fe1b1d..cc648e474748 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	 * woken up. So we should wake it, but this is impossible from
 	 * NMI context. Do it from irq work instead.
 	 */
-	if (in_pmi && !kvm_is_in_guest())
+	if (in_pmi && !kvm_arch_pmi_in_guest(vcpu))
 		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 	else
 		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);

Signed-off-by: Like Xu <likexu@tencent.com>

---

The guest Precise Event Based Sampling (PEBS) feature can provide an
architectural state of the instruction executed after the guest instruction
that exactly caused the event. It needs new hardware facility only available
on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
feature for KVM guests on ICX.

We can use PEBS feature on the Linux guest like native:

   # echo 0 > /proc/sys/kernel/watchdog (on the host)
   # perf record -e instructions:ppp ./br_instr a
   # perf record -c 100000 -e instructions:pp ./br_instr a

To emulate guest PEBS facility for the above perf usages,
we need to implement 2 code paths:

1) Fast path

This is when the host assigned physical PMC has an identical index as the
virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
This path is used in most common use cases.

2) Slow path

This is when the host assigned physical PMC has a different index from the
virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In this case,
KVM needs to rewrite the PEBS records to change the applicable counter indexes
to the virtual PMC indexes, which would otherwise contain the physical counter
index written by PEBS facility, and switch the counter reset values to the
offset corresponding to the physical counter indexes in the DS data structure.

The previous version [0] enables both fast path and slow path, which seems
a bit more complex as the first step. In this patchset, we want to start with
the fast path to get the basic guest PEBS enabled while keeping the slow path
disabled. More focused discussion on the slow path [1] is planned to be put to
another patchset in the next step.

Compared to later versions in subsequent steps, the functionality to support
host-guest PEBS both enabled and the functionality to emulate guest PEBS when
the counter is cross-mapped are missing in this patch set
(neither of these are typical scenarios).

With the basic support, the guest can retrieve the correct PEBS information from
its own PEBS records on the Ice Lake servers. And we expect it should work when
migrating to another Ice Lake and no regression about host perf is expected.

Here are the results of pebs test from guest/host for same workload:

perf report on guest:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1473377250 # Overhead  Command   Shared Object      Symbol
   57.74%  br_instr  br_instr           [.] lfsr_cond
   41.40%  br_instr  br_instr           [.] cmp_end
    0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire

perf report on host:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1462721386 # Overhead  Command   Shared Object     Symbol
   57.90%  br_instr  br_instr          [.] lfsr_cond
   41.95%  br_instr  br_instr          [.] cmp_end
    0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
    Conclusion: the profiling results on the guest are similar tothat on the host.

A minimum guest kernel version may be v5.4 or a backport version support
Icelake server PEBS.

Please check more details in each commit and feel free to comment.

Previous:
https://lore.kernel.org/kvm/20210806133802.3528-1-lingshan.zhu@intel.com/

[0]
https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
[1]
https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/

V10->V11:
- Merge perf_guest_info_callbacks static_call to the tip/perf/core;
- Keep use perf_guest_cbs in the kvm/queue context before merge window;
- Fix MSR_IA32_MISC_ENABLE_EMON bit (Liu XiangDong);
- Rebase "Reprogram PEBS event to emulate guest PEBS counter" patch;

V9->V10:
- improve readability in core.c(Peter Z)
- reuse guest_pebs_idxs(Liu XiangDong)

V8 -> V9 Changelog:
-fix a brackets error in xen_guest_state()

V7 -> V8 Changelog:
- fix coding style, add {} for single statement of multiple lines(Peter Z)
- fix coding style in xen_guest_state() (Boris Ostrovsky)
- s/pmu/kvm_pmu/ in intel_guest_get_msrs() (Peter Z)
- put lower cost branch in the first place for x86_pmu_handle_guest_pebs() (Peter Z)

V6 -> V7 Changelog:
- Fix conditions order and call x86_pmu_handle_guest_pebs() unconditionally; (PeterZ)
- Add a new patch to make all that perf_guest_cbs stuff suck less; (PeterZ)
- Document IA32_MISC_ENABLE[7] that that behavior matches bare metal; (Sean & Venkatesh)
- Update commit message for fixed counter mask refactoring;(PeterZ)
- Clarifying comments about {.host and .guest} for intel_guest_get_msrs(); (PeterZ)
- Add pebs_capable to store valid PEBS_COUNTER_MASK value; (PeterZ)
- Add more comments for perf's precise_ip field; (Andi & PeterZ)
- Refactor perf_overflow_handler_t and make it more legible; (PeterZ)
- Use "(unsigned long)cpuc->ds" instead of __this_cpu_read(cpu_hw_events.ds); (PeterZ)
- Keep using "(struct kvm_pmu *)data" to follow K&R; (Andi)

Like Xu (16):
  perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
  perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
  perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
  KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
  KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
  KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
  KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
  KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
  KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
  KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
  KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
  KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
  KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
  KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
  KVM: x86/cpuid: Refactor host/guest CPU model consistency check
  KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64

Peter Zijlstra (Intel) (1):
  x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value

 arch/x86/events/core.c            |   5 +-
 arch/x86/events/intel/core.c      | 157 +++++++++++++++++++++++++-----
 arch/x86/events/perf_event.h      |   6 +-
 arch/x86/include/asm/kvm_host.h   |  16 +++
 arch/x86/include/asm/msr-index.h  |   6 ++
 arch/x86/include/asm/perf_event.h |   5 +-
 arch/x86/kvm/cpuid.c              |  26 ++---
 arch/x86/kvm/cpuid.h              |   5 +
 arch/x86/kvm/pmu.c                |  52 +++++++---
 arch/x86/kvm/pmu.h                |  38 ++++++++
 arch/x86/kvm/vmx/capabilities.h   |  26 +++--
 arch/x86/kvm/vmx/pmu_intel.c      | 116 ++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c            |  24 ++++-
 arch/x86/kvm/vmx/vmx.h            |   2 +-
 arch/x86/kvm/x86.c                |  30 ++++--
 15 files changed, 410 insertions(+), 104 deletions(-)

-- 
2.33.1

