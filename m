Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56BD22E0BE
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGZPe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:34:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgGZPe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:34:58 -0400
IronPort-SDR: GIO2vyVe1KeBQCLPyv3oHzGlB2aZdD89CBeGaVb7JTSZtmBIboOcInrp/VGwQpJ2ZUJf0JD4oI
 yy21G1wGNemQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890978"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890978"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:34:57 -0700
IronPort-SDR: 3PmFzGiBlUdPPk9qvrMFCzyPJxxSHmetrlw4x6PU8KpDPD2RFRnHAC6Oo3F8wx170G+0SnDKHX
 bx7zfQ7OOyVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177578"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:34:54 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v13 05/10] KVM: vmx/pmu: Create a guest LBR event when vcpu sets DEBUGCTLMSR_LBR
Date:   Sun, 26 Jul 2020 23:32:24 +0800
Message-Id: <20200726153229.27149-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vcpu sets DEBUGCTLMSR_LBR in the MSR_IA32_DEBUGCTLMSR, the KVM handler
would create a guest LBR event which enables the callstack mode and none of
hardware counter is assigned. The host perf would schedule and enable this
event as usual but in an exclusive way.

The guest LBR event will be released when the vPMU is reset but soon,
the lazy release mechanism would be applied to this event like a vPMC.

Adding vcpu_supported_debugctl() to throw #GP per per-guest setting.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  7 +++-
 arch/x86/kvm/vmx/pmu_intel.c    | 61 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 27 ++++++++++++---
 arch/x86/kvm/vmx/vmx.h          | 10 ++++++
 4 files changed, 99 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d818081f37e1..26e77c6edcda 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -381,7 +381,12 @@ static inline u64 vmx_get_perf_capabilities(void)
 
 static inline u64 vmx_supported_debugctl(void)
 {
-	return DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF;
+	u64 debugctl = DEBUGCTLMSR_BTF;
+
+	if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
+		debugctl |= DEBUGCTLMSR_LBR;
+
+	return debugctl;
 }
 
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 91212fe5ec56..db1d78ddabac 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -235,6 +235,65 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+
+	if (lbr_desc->event) {
+		perf_event_release_kernel(lbr_desc->event);
+		lbr_desc->event = NULL;
+		vcpu_to_pmu(vcpu)->event_count--;
+	}
+}
+
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	struct perf_event *event;
+
+	/*
+	 * The perf_event_attr is constructed in the minimum efficient way:
+	 * - set 'pinned = true' to make it task pinned so that if another
+	 *   cpu pinned event reclaims LBR, the event->oncpu will be set to -1;
+	 * - set '.exclude_host = true' to record guest branches behavior;
+	 *
+	 * - set '.config = INTEL_FIXED_VLBR_EVENT' to indicates host perf
+	 *   schedule the event without a real HW counter but a fake one;
+	 *   check is_guest_lbr_event() and __intel_get_event_constraints();
+	 *
+	 * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and
+	 *   'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+	 *   PERF_SAMPLE_BRANCH_USER' to configure it as a LBR callstack
+	 *   event, which helps KVM to save/restore guest LBR records
+	 *   during host context switches and reduces quite a lot overhead,
+	 *   check branch_user_callstack() and intel_pmu_lbr_sched_task();
+	 */
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_RAW,
+		.size = sizeof(attr),
+		.config = INTEL_FIXED_VLBR_EVENT,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.pinned = true,
+		.exclude_host = true,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+					PERF_SAMPLE_BRANCH_USER,
+	};
+
+	if (unlikely(lbr_desc->event))
+		return 0;
+
+	event = perf_event_create_kernel_counter(&attr, -1,
+						current, NULL, NULL);
+	if (IS_ERR(event)) {
+		pr_debug_ratelimited("%s: failed %ld\n",
+					__func__, PTR_ERR(event));
+		return -ENOENT;
+	}
+	lbr_desc->event = event;
+	vcpu_to_pmu(vcpu)->event_count++;
+	return 0;
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -441,6 +500,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
 		vmx_get_perf_capabilities() : 0;
 	lbr_desc->records.nr = 0;
+	lbr_desc->event = NULL;
 }
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
@@ -465,6 +525,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
+	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 162c668d58f5..1204dc730e4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1957,8 +1957,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		goto find_shared_msr;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = 0;
-		break;
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		return 0;
 	default:
 	find_shared_msr:
 		msr = find_msr_entry(vmx, msr_info->index);
@@ -1982,6 +1982,16 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
+static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
+{
+	u64 debugctl = vmx_supported_debugctl();
+
+	if (!intel_pmu_lbr_is_enabled(vcpu))
+		debugctl &= ~DEBUGCTLMSR_LBR;
+
+	return debugctl;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2037,10 +2047,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		if (data & ~vmx_supported_debugctl())
+		if (data & ~vcpu_supported_debugctl(vcpu))
 			return 1;
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
+		if (data & DEBUGCTLMSR_BTF) {
+			vcpu_unimpl(vcpu, "%s: BTF in MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+				__func__, data);
+			data &= ~DEBUGCTLMSR_BTF;
+		}
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
+		    (data & DEBUGCTLMSR_LBR))
+			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c24d89ea70c5..eef8eaaec031 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -98,9 +98,19 @@ struct pt_desc {
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
 	struct x86_pmu_lbr records;
+
+	/*
+	 * Emulate LBR feature via passthrough LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * The records may be inaccurate if the host reclaims the LBR.
+	 */
+	struct perf_event *event;
 };
 
 /*
-- 
2.21.3

