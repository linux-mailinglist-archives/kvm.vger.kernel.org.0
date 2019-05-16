Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837BF20143
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 10:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfEPI0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 04:26:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:22098 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbfEPI0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 04:26:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 01:26:48 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.102])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2019 01:26:45 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 3/6] KVM: VMX: Dymamic allocate Intel PT configuration state
Date:   Thu, 16 May 2019 16:25:11 +0800
Message-Id: <1557995114-21629-4-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
References: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch change the Intel PT configuration state
to structure pointer so that we only need to allocate
the state buffer when Intel PT working in HOST_GUEST
mode.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/nested.c |   2 +-
 arch/x86/kvm/vmx/vmx.c    | 202 +++++++++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    |   6 +-
 3 files changed, 121 insertions(+), 89 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e8d5c61..349be88 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4201,7 +4201,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	vmx->nested.vmxon = true;
 
 	if (pt_mode == PT_MODE_HOST_GUEST) {
-		vmx->pt_desc.guest_ctx.rtit_ctl = 0;
+		vmx->pt_desc->guest_ctx->rtit_ctl = 0;
 		pt_update_intercept_for_msr(vmx);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4234e40e..4595230 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1009,11 +1009,11 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
 	 * Save host state before VM entry.
 	 */
-	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host_ctx.rtit_ctl);
-	if (vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) {
+	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc->host_ctx->rtit_ctl);
+	if (vmx->pt_desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) {
 		wrmsrl(MSR_IA32_RTIT_CTL, 0);
-		pt_save_msr(&vmx->pt_desc.host_ctx, vmx->pt_desc.addr_range);
-		pt_load_msr(&vmx->pt_desc.guest_ctx, vmx->pt_desc.addr_range);
+		pt_save_msr(vmx->pt_desc->host_ctx, vmx->pt_desc->addr_range);
+		pt_load_msr(vmx->pt_desc->guest_ctx, vmx->pt_desc->addr_range);
 	}
 }
 
@@ -1022,13 +1022,35 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	if (pt_mode == PT_MODE_SYSTEM)
 		return;
 
-	if (vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) {
-		pt_save_msr(&vmx->pt_desc.guest_ctx, vmx->pt_desc.addr_range);
-		pt_load_msr(&vmx->pt_desc.host_ctx, vmx->pt_desc.addr_range);
+	if (vmx->pt_desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) {
+		pt_save_msr(vmx->pt_desc->guest_ctx, vmx->pt_desc->addr_range);
+		pt_load_msr(vmx->pt_desc->host_ctx, vmx->pt_desc->addr_range);
 	}
 
 	/* Reload host state (IA32_RTIT_CTL will be cleared on VM exit). */
-	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host_ctx.rtit_ctl);
+	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc->host_ctx->rtit_ctl);
+}
+
+static int pt_init(struct vcpu_vmx *vmx)
+{
+	u32 pt_state_sz = sizeof(struct pt_state) + sizeof(u64) *
+		intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2;
+
+	vmx->pt_desc = kzalloc(sizeof(struct pt_desc) + pt_state_sz * 2,
+		GFP_KERNEL_ACCOUNT);
+	if (!vmx->pt_desc)
+		return -ENOMEM;
+
+	vmx->pt_desc->host_ctx = (struct pt_state *)(vmx->pt_desc + 1);
+	vmx->pt_desc->guest_ctx = (void *)vmx->pt_desc->host_ctx + pt_state_sz;
+
+	return 0;
+}
+
+static void pt_uninit(struct vcpu_vmx *vmx)
+{
+	if (pt_mode == PT_MODE_HOST_GUEST)
+		kfree(vmx->pt_desc);
 }
 
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -1391,15 +1413,16 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 * Any MSR write that attempts to change bits marked reserved will
 	 * case a #GP fault.
 	 */
-	if (data & vmx->pt_desc.ctl_bitmask)
+	if (data & vmx->pt_desc->ctl_bitmask)
 		return 1;
 
 	/*
 	 * Any attempt to modify IA32_RTIT_CTL while TraceEn is set will
 	 * result in a #GP unless the same write also clears TraceEn.
 	 */
-	if ((vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) &&
-		((vmx->pt_desc.guest_ctx.rtit_ctl ^ data) & ~RTIT_CTL_TRACEEN))
+	if ((vmx->pt_desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN) &&
+		((vmx->pt_desc->guest_ctx->rtit_ctl ^ data) &
+						~RTIT_CTL_TRACEEN))
 		return 1;
 
 	/*
@@ -1409,7 +1432,7 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 */
 	if ((data & RTIT_CTL_TRACEEN) && !(data & RTIT_CTL_TOPA) &&
 		!(data & RTIT_CTL_FABRIC_EN) &&
-		!intel_pt_validate_cap(vmx->pt_desc.caps,
+		!intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_single_range_output))
 		return 1;
 
@@ -1417,19 +1440,19 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 * MTCFreq, CycThresh and PSBFreq encodings check, any MSR write that
 	 * utilize encodings marked reserved will casue a #GP fault.
 	 */
-	value = intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc_periods);
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc) &&
+	value = intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_mtc_periods);
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_mtc) &&
 			!test_bit((data & RTIT_CTL_MTC_RANGE) >>
 			RTIT_CTL_MTC_RANGE_OFFSET, &value))
 		return 1;
-	value = intel_pt_validate_cap(vmx->pt_desc.caps,
+	value = intel_pt_validate_cap(vmx->pt_desc->caps,
 						PT_CAP_cycle_thresholds);
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_psb_cyc) &&
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_psb_cyc) &&
 			!test_bit((data & RTIT_CTL_CYC_THRESH) >>
 			RTIT_CTL_CYC_THRESH_OFFSET, &value))
 		return 1;
-	value = intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_psb_periods);
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_psb_cyc) &&
+	value = intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_psb_periods);
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_psb_cyc) &&
 			!test_bit((data & RTIT_CTL_PSB_FREQ) >>
 			RTIT_CTL_PSB_FREQ_OFFSET, &value))
 		return 1;
@@ -1439,16 +1462,16 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 * cause a #GP fault.
 	 */
 	value = (data & RTIT_CTL_ADDR0) >> RTIT_CTL_ADDR0_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 1)) || (value > 2))
+	if ((value && (vmx->pt_desc->addr_range < 1)) || (value > 2))
 		return 1;
 	value = (data & RTIT_CTL_ADDR1) >> RTIT_CTL_ADDR1_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 2)) || (value > 2))
+	if ((value && (vmx->pt_desc->addr_range < 2)) || (value > 2))
 		return 1;
 	value = (data & RTIT_CTL_ADDR2) >> RTIT_CTL_ADDR2_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 3)) || (value > 2))
+	if ((value && (vmx->pt_desc->addr_range < 3)) || (value > 2))
 		return 1;
 	value = (data & RTIT_CTL_ADDR3) >> RTIT_CTL_ADDR3_OFFSET;
-	if ((value && (vmx->pt_desc.addr_range < 4)) || (value > 2))
+	if ((value && (vmx->pt_desc->addr_range < 4)) || (value > 2))
 		return 1;
 
 	return 0;
@@ -1721,45 +1744,46 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
-		msr_info->data = vmx->pt_desc.guest_ctx.rtit_ctl;
+		msr_info->data = vmx->pt_desc->guest_ctx->rtit_ctl;
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
-		msr_info->data = vmx->pt_desc.guest_ctx.rtit_status;
+		msr_info->data = vmx->pt_desc->guest_ctx->rtit_status;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			!intel_pt_validate_cap(vmx->pt_desc.caps,
+			!intel_pt_validate_cap(vmx->pt_desc->caps,
 						PT_CAP_cr3_filtering))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest_ctx.rtit_cr3_match;
+		msr_info->data = vmx->pt_desc->guest_ctx->rtit_cr3_match;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(!intel_pt_validate_cap(vmx->pt_desc.caps,
+			(!intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_topa_output) &&
-			 !intel_pt_validate_cap(vmx->pt_desc.caps,
+			 !intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_single_range_output)))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest_ctx.rtit_output_base;
+		msr_info->data = vmx->pt_desc->guest_ctx->rtit_output_base;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(!intel_pt_validate_cap(vmx->pt_desc.caps,
+			(!intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_topa_output) &&
-			 !intel_pt_validate_cap(vmx->pt_desc.caps,
+			 !intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_single_range_output)))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest_ctx.rtit_output_mask;
+		msr_info->data =
+			vmx->pt_desc->guest_ctx->rtit_output_mask | 0x7f;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
+			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest_ctx.rtit_addrx_ab[index];
+		msr_info->data = vmx->pt_desc->guest_ctx->rtit_addrx_ab[index];
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
@@ -1946,53 +1970,58 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->nested.vmxon)
 			return 1;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, data);
-		vmx->pt_desc.guest_ctx.rtit_ctl = data;
+		vmx->pt_desc->guest_ctx->rtit_ctl = data;
 		pt_update_intercept_for_msr(vmx);
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
+			(vmx->pt_desc->guest_ctx->rtit_ctl &
+					RTIT_CTL_TRACEEN) ||
 			(data & MSR_IA32_RTIT_STATUS_MASK))
 			return 1;
-		vmx->pt_desc.guest_ctx.rtit_status = data;
+		vmx->pt_desc->guest_ctx->rtit_status = data;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
-			!intel_pt_validate_cap(vmx->pt_desc.caps,
+			(vmx->pt_desc->guest_ctx->rtit_ctl &
+						RTIT_CTL_TRACEEN) ||
+			!intel_pt_validate_cap(vmx->pt_desc->caps,
 						PT_CAP_cr3_filtering))
 			return 1;
-		vmx->pt_desc.guest_ctx.rtit_cr3_match = data;
+		vmx->pt_desc->guest_ctx->rtit_cr3_match = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
-			(!intel_pt_validate_cap(vmx->pt_desc.caps,
+			(vmx->pt_desc->guest_ctx->rtit_ctl &
+						RTIT_CTL_TRACEEN) ||
+			(!intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_topa_output) &&
-			 !intel_pt_validate_cap(vmx->pt_desc.caps,
+			 !intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_single_range_output)) ||
 			(data & MSR_IA32_RTIT_OUTPUT_BASE_MASK))
 			return 1;
-		vmx->pt_desc.guest_ctx.rtit_output_base = data;
+		vmx->pt_desc->guest_ctx->rtit_output_base = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
-			(!intel_pt_validate_cap(vmx->pt_desc.caps,
+			(vmx->pt_desc->guest_ctx->rtit_ctl &
+						RTIT_CTL_TRACEEN) ||
+			(!intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_topa_output) &&
-			 !intel_pt_validate_cap(vmx->pt_desc.caps,
+			 !intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_single_range_output)))
 			return 1;
-		vmx->pt_desc.guest_ctx.rtit_output_mask = data;
+		vmx->pt_desc->guest_ctx->rtit_output_mask = data;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
-			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
+			(vmx->pt_desc->guest_ctx->rtit_ctl &
+						RTIT_CTL_TRACEEN) ||
+			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc->caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
-		vmx->pt_desc.guest_ctx.rtit_addrx_ab[index] = data;
+		vmx->pt_desc->guest_ctx->rtit_addrx_ab[index] = data;
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
@@ -3581,7 +3610,7 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 {
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	bool flag = !(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN);
+	bool flag = !(vmx->pt_desc->guest_ctx->rtit_ctl & RTIT_CTL_TRACEEN);
 	u32 i;
 
 	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_STATUS,
@@ -3592,12 +3621,9 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 							MSR_TYPE_RW, flag);
 	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
 							MSR_TYPE_RW, flag);
-	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
-		vmx_set_intercept_for_msr(msr_bitmap,
-			MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
+	for (i = 0; i < vmx->pt_desc->addr_range * 2; i++)
 		vmx_set_intercept_for_msr(msr_bitmap,
-			MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
-	}
+			MSR_IA32_RTIT_ADDR0_A + i, MSR_TYPE_RW, flag);
 }
 
 static bool vmx_get_enable_apicv(struct kvm_vcpu *vcpu)
@@ -4092,12 +4118,8 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
 
-	if (pt_mode == PT_MODE_HOST_GUEST) {
-		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
-		/* Bit[6~0] are forced to 1, writes are ignored. */
-		vmx->pt_desc.guest_ctx.rtit_output_mask = 0x7F;
+	if (pt_mode == PT_MODE_HOST_GUEST)
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
-	}
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -6544,6 +6566,8 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
+	if (pt_mode == PT_MODE_HOST_GUEST)
+		pt_uninit(vmx);
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -6592,12 +6616,18 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			goto uninit_vcpu;
 	}
 
+	if (pt_mode == PT_MODE_HOST_GUEST) {
+		err = pt_init(vmx);
+		if (err)
+			goto free_pml;
+	}
+
 	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
 		     > PAGE_SIZE);
 
 	if (!vmx->guest_msrs)
-		goto free_pml;
+		goto free_pt;
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
 	if (err < 0)
@@ -6659,6 +6689,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 free_msrs:
 	kfree(vmx->guest_msrs);
+free_pt:
+	pt_uninit(vmx);
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 uninit_vcpu:
@@ -6866,63 +6898,63 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		best = kvm_find_cpuid_entry(vcpu, 0x14, i);
 		if (!best)
 			return;
-		vmx->pt_desc.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM] = best->eax;
-		vmx->pt_desc.caps[CPUID_EBX + i*PT_CPUID_REGS_NUM] = best->ebx;
-		vmx->pt_desc.caps[CPUID_ECX + i*PT_CPUID_REGS_NUM] = best->ecx;
-		vmx->pt_desc.caps[CPUID_EDX + i*PT_CPUID_REGS_NUM] = best->edx;
+		vmx->pt_desc->caps[CPUID_EAX + i*PT_CPUID_REGS_NUM] = best->eax;
+		vmx->pt_desc->caps[CPUID_EBX + i*PT_CPUID_REGS_NUM] = best->ebx;
+		vmx->pt_desc->caps[CPUID_ECX + i*PT_CPUID_REGS_NUM] = best->ecx;
+		vmx->pt_desc->caps[CPUID_EDX + i*PT_CPUID_REGS_NUM] = best->edx;
 	}
 
 	/* Get the number of configurable Address Ranges for filtering */
-	vmx->pt_desc.addr_range = intel_pt_validate_cap(vmx->pt_desc.caps,
+	vmx->pt_desc->addr_range = intel_pt_validate_cap(vmx->pt_desc->caps,
 						PT_CAP_num_address_ranges);
 
 	/* Initialize and clear the no dependency bits */
-	vmx->pt_desc.ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
+	vmx->pt_desc->ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
 			RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC);
 
 	/*
 	 * If CPUID.(EAX=14H,ECX=0):EBX[0]=1 CR3Filter can be set otherwise
 	 * will inject an #GP
 	 */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_cr3_filtering))
-		vmx->pt_desc.ctl_bitmask &= ~RTIT_CTL_CR3EN;
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_cr3_filtering))
+		vmx->pt_desc->ctl_bitmask &= ~RTIT_CTL_CR3EN;
 
 	/*
 	 * If CPUID.(EAX=14H,ECX=0):EBX[1]=1 CYCEn, CycThresh and
 	 * PSBFreq can be set
 	 */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_psb_cyc))
-		vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_CYCLEACC |
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_psb_cyc))
+		vmx->pt_desc->ctl_bitmask &= ~(RTIT_CTL_CYCLEACC |
 				RTIT_CTL_CYC_THRESH | RTIT_CTL_PSB_FREQ);
 
 	/*
 	 * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn BranchEn and
 	 * MTCFreq can be set
 	 */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc))
-		vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_mtc))
+		vmx->pt_desc->ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
 				RTIT_CTL_BRANCH_EN | RTIT_CTL_MTC_RANGE);
 
 	/* If CPUID.(EAX=14H,ECX=0):EBX[4]=1 FUPonPTW and PTWEn can be set */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_ptwrite))
-		vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_FUP_ON_PTW |
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_ptwrite))
+		vmx->pt_desc->ctl_bitmask &= ~(RTIT_CTL_FUP_ON_PTW |
 							RTIT_CTL_PTW_EN);
 
 	/* If CPUID.(EAX=14H,ECX=0):EBX[5]=1 PwrEvEn can be set */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_power_event_trace))
-		vmx->pt_desc.ctl_bitmask &= ~RTIT_CTL_PWR_EVT_EN;
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_power_event_trace))
+		vmx->pt_desc->ctl_bitmask &= ~RTIT_CTL_PWR_EVT_EN;
 
 	/* If CPUID.(EAX=14H,ECX=0):ECX[0]=1 ToPA can be set */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_topa_output))
-		vmx->pt_desc.ctl_bitmask &= ~RTIT_CTL_TOPA;
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_topa_output))
+		vmx->pt_desc->ctl_bitmask &= ~RTIT_CTL_TOPA;
 
 	/* If CPUID.(EAX=14H,ECX=0):ECX[3]=1 FabircEn can be set */
-	if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_output_subsys))
-		vmx->pt_desc.ctl_bitmask &= ~RTIT_CTL_FABRIC_EN;
+	if (intel_pt_validate_cap(vmx->pt_desc->caps, PT_CAP_output_subsys))
+		vmx->pt_desc->ctl_bitmask &= ~RTIT_CTL_FABRIC_EN;
 
 	/* unmask address range configure area */
-	for (i = 0; i < vmx->pt_desc.addr_range; i++)
-		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
+	for (i = 0; i < vmx->pt_desc->addr_range; i++)
+		vmx->pt_desc->ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 11ad856..283f69d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -69,8 +69,8 @@ struct pt_desc {
 	u64 ctl_bitmask;
 	u32 addr_range;
 	u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
-	struct pt_state host_ctx;
-	struct pt_state guest_ctx;
+	struct pt_state *host_ctx;
+	struct pt_state *guest_ctx;
 };
 
 /*
@@ -259,7 +259,7 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control_valid_bits;
 	u64 ept_pointer;
 
-	struct pt_desc pt_desc;
+	struct pt_desc *pt_desc;
 };
 
 enum ept_pointers_status {
-- 
1.8.3.1

