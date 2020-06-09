Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1211F321C
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 03:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgFIB4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 21:56:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:53926 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgFIB4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 21:56:08 -0400
IronPort-SDR: JHcyhO/3m2nGyZjtjBcI+SYwiI1uk4NXysBs/l88sYDPz1/y2hzXwSFWy9Glw2giDKNQl7O3Sm
 byz/I/ykzdpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 18:56:07 -0700
IronPort-SDR: PgR7H+/r10o+UHFp4bMpZMT7Lfs8UvfXoFBE09iEk7o7Rp7FfIRkdZG8U6dt8jGXfv9+93YFPA
 tmP7YDWhmqaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,490,1583222400"; 
   d="scan'208";a="288665884"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 08 Jun 2020 18:56:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Wrap VM-Fail valid path in generic VM-Fail helper
Date:   Mon,  8 Jun 2020 18:56:07 -0700
Message-Id: <20200609015607.6994-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add nested_vmx_fail() to wrap VM-Fail paths that _may_ result in VM-Fail
Valid to make it clear at the call sites that the Valid flavor isn't
guaranteed.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 77 ++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcb50724be38..f45a36e5c863 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -171,15 +171,6 @@ static int nested_vmx_failInvalid(struct kvm_vcpu *vcpu)
 static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 				u32 vm_instruction_error)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	/*
-	 * failValid writes the error number to the current VMCS, which
-	 * can't be done if there isn't a current VMCS.
-	 */
-	if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
-		return nested_vmx_failInvalid(vcpu);
-
 	vmx_set_rflags(vcpu, (vmx_get_rflags(vcpu)
 			& ~(X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF |
 			    X86_EFLAGS_SF | X86_EFLAGS_OF))
@@ -192,6 +183,20 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
+static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * failValid writes the error number to the current VMCS, which
+	 * can't be done if there isn't a current VMCS.
+	 */
+	if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
+		return nested_vmx_failInvalid(vcpu);
+
+	return nested_vmx_failValid(vcpu, vm_instruction_error);
+}
+
 static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
 {
 	/* TODO: not to reset guest simply here. */
@@ -3456,19 +3461,18 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * when using the merged vmcs02.
 	 */
 	if (interrupt_shadow & KVM_X86_SHADOW_INT_MOV_SS)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS);
+		return nested_vmx_fail(vcpu, VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS);
 
 	if (vmcs12->launch_state == launch)
-		return nested_vmx_failValid(vcpu,
+		return nested_vmx_fail(vcpu,
 			launch ? VMXERR_VMLAUNCH_NONCLEAR_VMCS
 			       : VMXERR_VMRESUME_NONLAUNCHED_VMCS);
 
 	if (nested_vmx_check_controls(vcpu, vmcs12))
-		return nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 
 	if (nested_vmx_check_host_state(vcpu, vmcs12))
-		return nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 
 	/*
 	 * We're finally done with prerequisite checking, and can start with
@@ -3517,7 +3521,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (status == NVMX_VMENTRY_VMEXIT)
 		return 1;
 	WARN_ON_ONCE(status != NVMX_VMENTRY_VMFAIL);
-	return nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+	return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 }
 
 /*
@@ -4460,7 +4464,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	 * flag and the VM-instruction error field of the VMCS
 	 * accordingly, and skip the emulated instruction.
 	 */
-	(void)nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+	(void)nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 
 	/*
 	 * Restore L1's host state to KVM's software model.  We're here
@@ -4760,8 +4764,7 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 	}
 
 	if (vmx->nested.vmxon)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
+		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
 
 	if ((vmx->msr_ia32_feature_control & VMXON_NEEDED_FEATURES)
 			!= VMXON_NEEDED_FEATURES) {
@@ -4852,12 +4855,10 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 		return r;
 
 	if (!page_address_valid(vcpu, vmptr))
-		return nested_vmx_failValid(vcpu,
-			VMXERR_VMCLEAR_INVALID_ADDRESS);
+		return nested_vmx_fail(vcpu, VMXERR_VMCLEAR_INVALID_ADDRESS);
 
 	if (vmptr == vmx->nested.vmxon_ptr)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_VMCLEAR_VMXON_POINTER);
+		return nested_vmx_fail(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
 
 	/*
 	 * When Enlightened VMEntry is enabled on the calling CPU we treat
@@ -4927,8 +4928,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
 		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
@@ -5031,8 +5031,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 	/*
 	 * If the vCPU supports "VMWRITE to any supported field in the
@@ -5040,8 +5039,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 */
 	if (vmcs_field_readonly(field) &&
 	    !nested_cpu_has_vmwrite_any_field(vcpu))
-		return nested_vmx_failValid(vcpu,
-			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
+		return nested_vmx_fail(vcpu, VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
 
 	/*
 	 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
@@ -5116,12 +5114,10 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		return r;
 
 	if (!page_address_valid(vcpu, vmptr))
-		return nested_vmx_failValid(vcpu,
-			VMXERR_VMPTRLD_INVALID_ADDRESS);
+		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_INVALID_ADDRESS);
 
 	if (vmptr == vmx->nested.vmxon_ptr)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_VMPTRLD_VMXON_POINTER);
+		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
 
 	/* Forbid normal VMPTRLD if Enlightened version was used */
 	if (vmx->nested.hv_evmcs)
@@ -5138,7 +5134,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 			 * given physical address won't match the required
 			 * VMCS12_REVISION identifier.
 			 */
-			return nested_vmx_failValid(vcpu,
+			return nested_vmx_fail(vcpu,
 				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
 		}
 
@@ -5148,7 +5144,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		    (new_vmcs12->hdr.shadow_vmcs &&
 		     !nested_cpu_has_vmx_shadow_vmcs(vcpu))) {
 			kvm_vcpu_unmap(vcpu, &map, false);
-			return nested_vmx_failValid(vcpu,
+			return nested_vmx_fail(vcpu,
 				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
 		}
 
@@ -5233,8 +5229,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
 	if (type >= 32 || !(types & (1 << type)))
-		return nested_vmx_failValid(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 	/* According to the Intel VMX instruction reference, the memory
 	 * operand is read even if it isn't needed (e.g., for type==global)
@@ -5255,7 +5250,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	switch (type) {
 	case VMX_EPT_EXTENT_CONTEXT:
 		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
-			return nested_vmx_failValid(vcpu,
+			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 		roots_to_free = 0;
@@ -5315,7 +5310,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
 
 	if (type >= 32 || !(types & (1 << type)))
-		return nested_vmx_failValid(vcpu,
+		return nested_vmx_fail(vcpu,
 			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 	/* according to the intel vmx instruction reference, the memory
@@ -5329,7 +5324,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return vmx_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.vpid >> 16)
-		return nested_vmx_failValid(vcpu,
+		return nested_vmx_fail(vcpu,
 			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 	vpid02 = nested_get_vpid02(vcpu);
@@ -5337,14 +5332,14 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
 		if (!operand.vpid ||
 		    is_noncanonical_address(operand.gla, vcpu))
-			return nested_vmx_failValid(vcpu,
+			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 		vpid_sync_vcpu_addr(vpid02, operand.gla);
 		break;
 	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
 	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
 		if (!operand.vpid)
-			return nested_vmx_failValid(vcpu,
+			return nested_vmx_fail(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 		vpid_sync_context(vpid02);
 		break;
-- 
2.26.0

