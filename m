Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D005229FC61
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgJ3D4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:56:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:4238 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgJ3D4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:56:52 -0400
IronPort-SDR: 9fwAP+22l30c4OJzHFk/N2DrDmFptYcZMIzXaIgCX9AZWIiptJXTi7TQU6OE+sGjzpTvIYi9kj
 kfRG61+tcmpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685744"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685744"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:56:51 -0700
IronPort-SDR: P8VMoTiKEHpLsKI4TUzX0eXzJl3kXGRK/ikG/TLl95B6t9MbkrUQw3vZ+BFBawBucEteg9GsQq
 pI6oKm4qJ01w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770438"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:48 -0700
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
Subject: [PATCH RESEND v13 05/10] KVM: vmx/pmu: Create a guest LBR event when vcpu sets DEBUGCTLMSR_LBR
Date:   Fri, 30 Oct 2020 11:52:15 +0800
Message-Id: <20201030035220.102403-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201030035220.102403-1-like.xu@linux.intel.com>
References: <20201030035220.102403-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vcpu sets DEBUGCTLMSR_LBR in the MSR_IA32_DEBUGCTLMSR, the KVM handler
would create a guest LBR event which enables the callstack mode and none of
hardware counter is assigned. The host perf would schedule and enable this
event as usual but in an exclusive way.

The guest LBR event will be released when the vPMU is reset but soon,
the lazy release mechanism would be applied to this event like a vPMC.

Adding vcpu_supported_debugctl() to throw #GP for DEBUGCTLMSR_LBR
based on per-guest LBR setting.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  7 +++-
 arch/x86/kvm/vmx/pmu_intel.c    | 61 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 31 +++++++++++------
 arch/x86/kvm/vmx/vmx.h          | 10 ++++++
 4 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index db1178a66d93..62aa7a701ebb 100644
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
index b9fde795dd96..e0d30ec398bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1926,7 +1926,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = 0;
+		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
 	default:
 	find_uret_msr:
@@ -1951,6 +1951,16 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
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
@@ -2006,18 +2016,17 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		if (!data) {
-			/* We support the non-activated case already */
-			return 0;
-		} else if (data & ~vmx_supported_debugctl()) {
-			/*
-			 * Values other than LBR and BTF are vendor-specific,
-			 * thus reserved and should throw a #GP.
-			 */
+		if (data & ~vcpu_supported_debugctl(vcpu))
 			return 1;
+		if (data & DEBUGCTLMSR_BTF) {
+			vcpu_unimpl(vcpu, "%s: BTF in MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
+				__func__, data);
+			data &= ~DEBUGCTLMSR_BTF;
 		}
-		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-			    __func__, data);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
+		    (data & DEBUGCTLMSR_LBR))
+			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e2d542bbca50..2ee0fa524fe8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -76,9 +76,19 @@ struct pt_desc {
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

