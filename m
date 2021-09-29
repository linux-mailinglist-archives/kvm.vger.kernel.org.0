Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E646941C25E
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 12:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbhI2KN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 06:13:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:28996 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245380AbhI2KN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 06:13:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="247430451"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="247430451"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 03:12:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="707211688"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.154])
  by fmsmga006.fm.intel.com with ESMTP; 29 Sep 2021 03:12:15 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 1/2] KVM: nVMX: Use INVALID_GPA for pointers used in nVMX.
Date:   Thu, 30 Sep 2021 01:51:53 +0800
Message-Id: <20210929175154.11396-2-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
References: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up nested.c and vmx.c by using INVALID_GPA instead of "-1ull",
to denote an invalid address in nested VMX. Affected addresses are
the ones of VMXON region, current VMCS, VMCS link pointer, virtual-
APIC page, ENCLS-exiting bitmap, and IO bitmap etc.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 60 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.c    |  4 +--
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..25cf76c7fee8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -191,7 +191,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
 	 * failValid writes the error number to the current VMCS, which
 	 * can't be done if there isn't a current VMCS.
 	 */
-	if (vmx->nested.current_vmptr == -1ull &&
+	if (vmx->nested.current_vmptr == INVALID_GPA &&
 	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		return nested_vmx_failInvalid(vcpu);
 
@@ -218,7 +218,7 @@ static inline u64 vmx_control_msr(u32 low, u32 high)
 static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
-	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
 	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
@@ -292,7 +292,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.smm.vmxon = false;
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.current_vmptr = -1ull;
+	vmx->nested.current_vmptr = INVALID_GPA;
 	if (enable_shadow_vmcs) {
 		vmx_disable_shadow_vmcs(vmx);
 		vmcs_clear(vmx->vmcs01.shadow_vmcs);
@@ -672,7 +672,7 @@ static void nested_cache_shadow_vmcs12(struct kvm_vcpu *vcpu,
 	struct vmcs12 *shadow;
 
 	if (!nested_cpu_has_shadow_vmcs(vmcs12) ||
-	    vmcs12->vmcs_link_pointer == -1ull)
+	    vmcs12->vmcs_link_pointer == INVALID_GPA)
 		return;
 
 	shadow = get_shadow_vmcs12(vcpu);
@@ -690,7 +690,7 @@ static void nested_flush_cached_shadow_vmcs12(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!nested_cpu_has_shadow_vmcs(vmcs12) ||
-	    vmcs12->vmcs_link_pointer == -1ull)
+	    vmcs12->vmcs_link_pointer == INVALID_GPA)
 		return;
 
 	kvm_write_guest(vmx->vcpu.kvm, vmcs12->vmcs_link_pointer,
@@ -1957,7 +1957,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	}
 
 	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
-		vmx->nested.current_vmptr = -1ull;
+		vmx->nested.current_vmptr = INVALID_GPA;
 
 		nested_release_evmcs(vcpu);
 
@@ -2141,7 +2141,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	}
 
 	if (cpu_has_vmx_encls_vmexit())
-		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
+		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
 
 	/*
 	 * Set the MSR load/store lists to match L0's settings.  Only the
@@ -2160,7 +2160,7 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 {
 	prepare_vmcs02_constant_state(vmx);
 
-	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
 
 	if (enable_vpid) {
 		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
@@ -2907,7 +2907,7 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 	struct vmcs12 *shadow;
 	struct kvm_host_map map;
 
-	if (vmcs12->vmcs_link_pointer == -1ull)
+	if (vmcs12->vmcs_link_pointer == INVALID_GPA)
 		return 0;
 
 	if (CC(!page_address_valid(vcpu, vmcs12->vmcs_link_pointer)))
@@ -3174,7 +3174,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR to
 			 * force VM-Entry to fail.
 			 */
-			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, -1ull);
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, INVALID_GPA);
 		}
 	}
 
@@ -3485,7 +3485,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	}
 
 	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
-	       vmx->nested.current_vmptr == -1ull))
+	       vmx->nested.current_vmptr == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
 
 	vmcs12 = get_vmcs12(vcpu);
@@ -4938,7 +4938,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->nested.current_vmptr == -1ull)
+	if (vmx->nested.current_vmptr == INVALID_GPA)
 		return;
 
 	copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
@@ -4958,7 +4958,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 
 	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 
-	vmx->nested.current_vmptr = -1ull;
+	vmx->nested.current_vmptr = INVALID_GPA;
 }
 
 /* Emulate the VMXOFF instruction */
@@ -5053,12 +5053,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/*
-	 * In VMX non-root operation, when the VMCS-link pointer is -1ull,
+	 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
 	 * any VMREAD sets the ALU flags for VMfailInvalid.
 	 */
-	if (vmx->nested.current_vmptr == -1ull ||
+	if (vmx->nested.current_vmptr == INVALID_GPA ||
 	    (is_guest_mode(vcpu) &&
-	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
+	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
 
 	/* Decode instruction info and find the field to read */
@@ -5145,12 +5145,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/*
-	 * In VMX non-root operation, when the VMCS-link pointer is -1ull,
+	 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
 	 * any VMWRITE sets the ALU flags for VMfailInvalid.
 	 */
-	if (vmx->nested.current_vmptr == -1ull ||
+	if (vmx->nested.current_vmptr == INVALID_GPA ||
 	    (is_guest_mode(vcpu) &&
-	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
+	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
 
 	if (instr_info & BIT(10))
@@ -5601,7 +5601,7 @@ bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 	gpa_t bitmap, last_bitmap;
 	u8 b;
 
-	last_bitmap = (gpa_t)-1;
+	last_bitmap = INVALID_GPA;
 	b = -1;
 
 	while (size > 0) {
@@ -6070,8 +6070,8 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		.format = KVM_STATE_NESTED_FORMAT_VMX,
 		.size = sizeof(kvm_state),
 		.hdr.vmx.flags = 0,
-		.hdr.vmx.vmxon_pa = -1ull,
-		.hdr.vmx.vmcs12_pa = -1ull,
+		.hdr.vmx.vmxon_pa = INVALID_GPA,
+		.hdr.vmx.vmcs12_pa = INVALID_GPA,
 		.hdr.vmx.preemption_timer_deadline = 0,
 	};
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
@@ -6097,7 +6097,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 			if (is_guest_mode(vcpu) &&
 			    nested_cpu_has_shadow_vmcs(vmcs12) &&
-			    vmcs12->vmcs_link_pointer != -1ull)
+			    vmcs12->vmcs_link_pointer != INVALID_GPA)
 				kvm_state.size += sizeof(user_vmx_nested_state->shadow_vmcs12);
 		}
 
@@ -6173,7 +6173,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
-	    vmcs12->vmcs_link_pointer != -1ull) {
+	    vmcs12->vmcs_link_pointer != INVALID_GPA) {
 		if (copy_to_user(user_vmx_nested_state->shadow_vmcs12,
 				 get_shadow_vmcs12(vcpu), VMCS12_SIZE))
 			return -EFAULT;
@@ -6208,11 +6208,11 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_VMX)
 		return -EINVAL;
 
-	if (kvm_state->hdr.vmx.vmxon_pa == -1ull) {
+	if (kvm_state->hdr.vmx.vmxon_pa == INVALID_GPA) {
 		if (kvm_state->hdr.vmx.smm.flags)
 			return -EINVAL;
 
-		if (kvm_state->hdr.vmx.vmcs12_pa != -1ull)
+		if (kvm_state->hdr.vmx.vmcs12_pa != INVALID_GPA)
 			return -EINVAL;
 
 		/*
@@ -6266,7 +6266,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	vmx_leave_nested(vcpu);
 
-	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
+	if (kvm_state->hdr.vmx.vmxon_pa == INVALID_GPA)
 		return 0;
 
 	vmx->nested.vmxon_ptr = kvm_state->hdr.vmx.vmxon_pa;
@@ -6279,13 +6279,13 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		/* See vmx_has_valid_vmcs12.  */
 		if ((kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE) ||
 		    (kvm_state->flags & KVM_STATE_NESTED_EVMCS) ||
-		    (kvm_state->hdr.vmx.vmcs12_pa != -1ull))
+		    (kvm_state->hdr.vmx.vmcs12_pa != INVALID_GPA))
 			return -EINVAL;
 		else
 			return 0;
 	}
 
-	if (kvm_state->hdr.vmx.vmcs12_pa != -1ull) {
+	if (kvm_state->hdr.vmx.vmcs12_pa != INVALID_GPA) {
 		if (kvm_state->hdr.vmx.vmcs12_pa == kvm_state->hdr.vmx.vmxon_pa ||
 		    !page_address_valid(vcpu, kvm_state->hdr.vmx.vmcs12_pa))
 			return -EINVAL;
@@ -6330,7 +6330,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
-	    vmcs12->vmcs_link_pointer != -1ull) {
+	    vmcs12->vmcs_link_pointer != INVALID_GPA) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
 
 		if (kvm_state->size <
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..047992eb4b20 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4339,7 +4339,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_msr_bitmap())
 		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
 
-	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
+	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA); /* 22.3.1.5 */
 
 	/* Control */
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
@@ -6887,7 +6887,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
 	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.current_vmptr = -1ull;
+	vmx->nested.current_vmptr = INVALID_GPA;
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
-- 
2.25.1

