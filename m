Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4FB20141
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 10:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfEPI0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 04:26:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:22098 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfEPI0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 04:26:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 01:26:44 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.102])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2019 01:26:42 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 2/6] KVM: VMX: Reuse the pt_state structure for PT context
Date:   Thu, 16 May 2019 16:25:10 +0800
Message-Id: <1557995114-21629-3-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
References: <1557995114-21629-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the previous pt_ctx structure and use pt_state
to save the PT configuration because they are saved
the same things.
Add *_ctx postfix to different with the upcoming
host and guest fpu pointer for PT state.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 96 +++++++++++++++++++++--------------------------
 arch/x86/kvm/vmx/vmx.h    | 16 +-------
 3 files changed, 46 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f4b1ae4..e8d5c61 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4201,7 +4201,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	vmx->nested.vmxon = true;
 
 	if (pt_mode == PT_MODE_HOST_GUEST) {
-		vmx->pt_desc.guest.ctl = 0;
+		vmx->pt_desc.guest_ctx.rtit_ctl = 0;
 		pt_update_intercept_for_msr(vmx);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0db7ded..4234e40e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -976,32 +976,28 @@ static unsigned long segment_base(u16 selector)
 }
 #endif
 
-static inline void pt_load_msr(struct pt_ctx *ctx, u32 addr_range)
+static inline void pt_load_msr(struct pt_state *ctx, u32 addr_range)
 {
 	u32 i;
 
-	wrmsrl(MSR_IA32_RTIT_STATUS, ctx->status);
-	wrmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
-	wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
-	wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
-	for (i = 0; i < addr_range; i++) {
-		wrmsrl(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
-		wrmsrl(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
-	}
+	wrmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->rtit_output_base);
+	wrmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->rtit_output_mask);
+	wrmsrl(MSR_IA32_RTIT_STATUS, ctx->rtit_status);
+	wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->rtit_cr3_match);
+	for (i = 0; i < addr_range * 2; i++)
+		wrmsrl(MSR_IA32_RTIT_ADDR0_A + i, ctx->rtit_addrx_ab[i]);
 }
 
-static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
+static inline void pt_save_msr(struct pt_state *ctx, u32 addr_range)
 {
 	u32 i;
 
-	rdmsrl(MSR_IA32_RTIT_STATUS, ctx->status);
-	rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
-	rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
-	rdmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
-	for (i = 0; i < addr_range; i++) {
-		rdmsrl(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
-		rdmsrl(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
-	}
+	rdmsrl(MSR_IA32_RTIT_OUTPUT_BASE, ctx->rtit_output_base);
+	rdmsrl(MSR_IA32_RTIT_OUTPUT_MASK, ctx->rtit_output_mask);
+	rdmsrl(MSR_IA32_RTIT_STATUS, ctx->rtit_status);
+	rdmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->rtit_cr3_match);
+	for (i = 0; i < addr_range; i++)
+		rdmsrl(MSR_IA32_RTIT_ADDR0_A + i, ctx->rtit_addrx_ab[i]);
 }
 
 static void pt_guest_enter(struct vcpu_vmx *vmx)
@@ -1013,11 +1009,11 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
 	 * Save host state before VM entry.
 	 */
-	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
-	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
+	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host_ctx.rtit_ctl);
+	if (vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) {
 		wrmsrl(MSR_IA32_RTIT_CTL, 0);
-		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
-		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
+		pt_save_msr(&vmx->pt_desc.host_ctx, vmx->pt_desc.addr_range);
+		pt_load_msr(&vmx->pt_desc.guest_ctx, vmx->pt_desc.addr_range);
 	}
 }
 
@@ -1026,13 +1022,13 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	if (pt_mode == PT_MODE_SYSTEM)
 		return;
 
-	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
-		pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
-		pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
+	if (vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) {
+		pt_save_msr(&vmx->pt_desc.guest_ctx, vmx->pt_desc.addr_range);
+		pt_load_msr(&vmx->pt_desc.host_ctx, vmx->pt_desc.addr_range);
 	}
 
 	/* Reload host state (IA32_RTIT_CTL will be cleared on VM exit). */
-	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host_ctx.rtit_ctl);
 }
 
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -1402,8 +1398,8 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 * Any attempt to modify IA32_RTIT_CTL while TraceEn is set will
 	 * result in a #GP unless the same write also clears TraceEn.
 	 */
-	if ((vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) &&
-		((vmx->pt_desc.guest.ctl ^ data) & ~RTIT_CTL_TRACEEN))
+	if ((vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) &&
+		((vmx->pt_desc.guest_ctx.rtit_ctl ^ data) & ~RTIT_CTL_TRACEEN))
 		return 1;
 
 	/*
@@ -1725,19 +1721,19 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
-		msr_info->data = vmx->pt_desc.guest.ctl;
+		msr_info->data = vmx->pt_desc.guest_ctx.rtit_ctl;
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
-		msr_info->data = vmx->pt_desc.guest.status;
+		msr_info->data = vmx->pt_desc.guest_ctx.rtit_status;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
 			!intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_cr3_filtering))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest.cr3_match;
+		msr_info->data = vmx->pt_desc.guest_ctx.rtit_cr3_match;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
@@ -1746,7 +1742,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_single_range_output)))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest.output_base;
+		msr_info->data = vmx->pt_desc.guest_ctx.rtit_output_base;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
@@ -1755,7 +1751,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_single_range_output)))
 			return 1;
-		msr_info->data = vmx->pt_desc.guest.output_mask;
+		msr_info->data = vmx->pt_desc.guest_ctx.rtit_output_mask;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
@@ -1763,10 +1759,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
-		if (index % 2)
-			msr_info->data = vmx->pt_desc.guest.addr_b[index / 2];
-		else
-			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
+		msr_info->data = vmx->pt_desc.guest_ctx.rtit_addrx_ab[index];
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
@@ -1953,56 +1946,53 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->nested.vmxon)
 			return 1;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, data);
-		vmx->pt_desc.guest.ctl = data;
+		vmx->pt_desc.guest_ctx.rtit_ctl = data;
 		pt_update_intercept_for_msr(vmx);
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
+			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
 			(data & MSR_IA32_RTIT_STATUS_MASK))
 			return 1;
-		vmx->pt_desc.guest.status = data;
+		vmx->pt_desc.guest_ctx.rtit_status = data;
 		break;
 	case MSR_IA32_RTIT_CR3_MATCH:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
+			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
 			!intel_pt_validate_cap(vmx->pt_desc.caps,
 						PT_CAP_cr3_filtering))
 			return 1;
-		vmx->pt_desc.guest.cr3_match = data;
+		vmx->pt_desc.guest_ctx.rtit_cr3_match = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
+			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_single_range_output)) ||
 			(data & MSR_IA32_RTIT_OUTPUT_BASE_MASK))
 			return 1;
-		vmx->pt_desc.guest.output_base = data;
+		vmx->pt_desc.guest_ctx.rtit_output_base = data;
 		break;
 	case MSR_IA32_RTIT_OUTPUT_MASK:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
+			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
 			(!intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_topa_output) &&
 			 !intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_single_range_output)))
 			return 1;
-		vmx->pt_desc.guest.output_mask = data;
+		vmx->pt_desc.guest_ctx.rtit_output_mask = data;
 		break;
 	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
-			(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
+			(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN) ||
 			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
 					PT_CAP_num_address_ranges)))
 			return 1;
-		if (index % 2)
-			vmx->pt_desc.guest.addr_b[index / 2] = data;
-		else
-			vmx->pt_desc.guest.addr_a[index / 2] = data;
+		vmx->pt_desc.guest_ctx.rtit_addrx_ab[index] = data;
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
@@ -3591,7 +3581,7 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
 {
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	bool flag = !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
+	bool flag = !(vmx->pt_desc.guest_ctx.rtit_ctl & RTIT_CTL_TRACEEN);
 	u32 i;
 
 	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_STATUS,
@@ -4105,7 +4095,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	if (pt_mode == PT_MODE_HOST_GUEST) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
 		/* Bit[6~0] are forced to 1, writes are ignored. */
-		vmx->pt_desc.guest.output_mask = 0x7F;
+		vmx->pt_desc.guest_ctx.rtit_output_mask = 0x7F;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 63d37cc..11ad856 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -65,24 +65,12 @@ struct pi_desc {
 	u32 rsvd[6];
 } __aligned(64);
 
-#define RTIT_ADDR_RANGE		4
-
-struct pt_ctx {
-	u64 ctl;
-	u64 status;
-	u64 output_base;
-	u64 output_mask;
-	u64 cr3_match;
-	u64 addr_a[RTIT_ADDR_RANGE];
-	u64 addr_b[RTIT_ADDR_RANGE];
-};
-
 struct pt_desc {
 	u64 ctl_bitmask;
 	u32 addr_range;
 	u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
-	struct pt_ctx host;
-	struct pt_ctx guest;
+	struct pt_state host_ctx;
+	struct pt_state guest_ctx;
 };
 
 /*
-- 
1.8.3.1

