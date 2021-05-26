Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D4D3918A0
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhEZNWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:22:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231911AbhEZNWI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAq8BwOIs0uxejOf2eZGzgC2G9vH+on2/VT6UV6rqcw=;
        b=WUGjmMwutYd6z8jIkLAT206Mjzuxfb8qNJSkZgI+B17RkrfnnF8gY5ASmF4rAxOucjf67Q
        w0avL4Cm97jdMVStW1WaGFuagBftjJb0Pzn3xr4nSpC9vAtaIY1ZwMRAN8QMe9fvn7VOcR
        zUifoiG3tNnaxM0PH4H5n9sFCOPf9r8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-UXVEJAYWNjKKbBE53EGZzA-1; Wed, 26 May 2021 09:20:34 -0400
X-MC-Unique: UXVEJAYWNjKKbBE53EGZzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B559107ACCA;
        Wed, 26 May 2021 13:20:33 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CD895D9C6;
        Wed, 26 May 2021 13:20:30 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/11] KVM: nVMX: Use '-1' in 'hv_evmcs_vmptr' to indicate that eVMCS is not in use
Date:   Wed, 26 May 2021 15:20:16 +0200
Message-Id: <20210526132026.270394-2-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of checking 'vmx->nested.hv_evmcs' use '-1' in
'vmx->nested.hv_evmcs_vmptr' to indicate 'evmcs is not in use' state. This
matches how we check 'vmx->nested.current_vmptr'. Introduce EVMPTR_INVALID
and evmptr_is_valid() and use it instead of raw '-1' check as a preparation
to adding other 'special' values.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  |  3 +++
 arch/x86/kvm/vmx/evmcs.h  |  7 +++++
 arch/x86/kvm/vmx/nested.c | 55 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  1 +
 5 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 41f24661af04..896b2a50b4aa 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -319,6 +319,9 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
 	if (unlikely(!assist_page.enlighten_vmentry))
 		return false;
 
+	if (unlikely(!evmptr_is_valid(assist_page.current_nested_vmcs)))
+		return false;
+
 	*evmcs_gpa = assist_page.current_nested_vmcs;
 
 	return true;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index bd41d9462355..47f802f71f6a 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -197,6 +197,13 @@ static inline void evmcs_load(u64 phys_addr) {}
 static inline void evmcs_touch_msr_bitmap(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
+#define EVMPTR_INVALID (-1ULL)
+
+static inline bool evmptr_is_valid(u64 evmptr)
+{
+	return evmptr != EVMPTR_INVALID;
+}
+
 enum nested_evmptrld_status {
 	EVMPTRLD_DISABLED,
 	EVMPTRLD_SUCCEEDED,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..74ff3fd56ce5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -187,7 +187,8 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
 	 * failValid writes the error number to the current VMCS, which
 	 * can't be done if there isn't a current VMCS.
 	 */
-	if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
+	if (vmx->nested.current_vmptr == -1ull &&
+	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		return nested_vmx_failInvalid(vcpu);
 
 	return nested_vmx_failValid(vcpu, vm_instruction_error);
@@ -221,12 +222,12 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx->nested.hv_evmcs)
-		return;
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
+		vmx->nested.hv_evmcs = NULL;
+	}
 
-	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
-	vmx->nested.hv_evmcs_vmptr = 0;
-	vmx->nested.hv_evmcs = NULL;
+	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 }
 
 static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
@@ -1982,10 +1983,8 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
 		return EVMPTRLD_DISABLED;
 
-	if (unlikely(!vmx->nested.hv_evmcs ||
-		     evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
-		if (!vmx->nested.hv_evmcs)
-			vmx->nested.current_vmptr = -1ull;
+	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
+		vmx->nested.current_vmptr = -1ull;
 
 		nested_release_evmcs(vcpu);
 
@@ -2056,7 +2055,7 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->nested.hv_evmcs) {
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
 		copy_vmcs12_to_enlightened(vmx);
 		/* All fields are clean */
 		vmx->nested.hv_evmcs->hv_clean_fields |=
@@ -2208,7 +2207,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	u32 exec_control;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
-	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
+	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		prepare_vmcs02_early_rare(vmx, vmcs12);
 
 	/*
@@ -2491,15 +2490,14 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
 	bool load_guest_pdptrs_vmcs12 = false;
 
-	if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
+	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
 		prepare_vmcs02_rare(vmx, vmcs12);
 		vmx->nested.dirty_vmcs12 = false;
 
-		load_guest_pdptrs_vmcs12 = !hv_evmcs ||
-			!(hv_evmcs->hv_clean_fields &
+		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) ||
+			!(vmx->nested.hv_evmcs->hv_clean_fields &
 			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
@@ -3093,7 +3091,8 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	 * L2 was running), map it here to make sure vmcs12 changes are
 	 * properly reflected.
 	 */
-	if (vmx->nested.enlightened_vmcs_enabled && !vmx->nested.hv_evmcs) {
+	if (vmx->nested.enlightened_vmcs_enabled &&
+	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
 		enum nested_evmptrld_status evmptrld_status =
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
 
@@ -3437,7 +3436,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
-	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
+	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
 }
@@ -3467,7 +3466,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 	}
 
-	if (CC(!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull))
+	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
+	       vmx->nested.current_vmptr == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
 	vmcs12 = get_vmcs12(vcpu);
@@ -3481,7 +3481,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (CC(vmcs12->hdr.shadow_vmcs))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (vmx->nested.hv_evmcs) {
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
 		copy_enlightened_to_vmcs12(vmx);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
@@ -4032,10 +4032,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->nested.hv_evmcs)
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
-	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = !vmx->nested.hv_evmcs;
+	vmx->nested.need_sync_vmcs02_to_vmcs12_rare =
+		!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
 
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
@@ -4532,7 +4533,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	}
 
 	if ((vm_exit_reason != -1) &&
-	    (enable_shadow_vmcs || vmx->nested.hv_evmcs))
+	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
@@ -5228,7 +5229,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
 
 	/* Forbid normal VMPTRLD if Enlightened version was used */
-	if (vmx->nested.hv_evmcs)
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		return 1;
 
 	if (vmx->nested.current_vmptr != vmptr) {
@@ -5284,7 +5285,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (unlikely(to_vmx(vcpu)->nested.hv_evmcs))
+	if (unlikely(evmptr_is_valid(to_vmx(vcpu)->nested.hv_evmcs_vmptr)))
 		return 1;
 
 	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
@@ -6056,7 +6057,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (vmx_has_valid_vmcs12(vcpu)) {
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
-			if (vmx->nested.hv_evmcs)
+			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
 
 			if (is_guest_mode(vcpu) &&
@@ -6112,7 +6113,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	} else  {
 		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
 		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
-			if (vmx->nested.hv_evmcs)
+			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 				copy_enlightened_to_vmcs12(vmx);
 			else if (enable_shadow_vmcs)
 				copy_shadow_to_vmcs12(vmx);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 184418baeb3c..c4397e83614d 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -63,7 +63,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 	 * have vmcs12 if it is true.
 	 */
 	return is_guest_mode(vcpu) || vmx->nested.current_vmptr != -1ull ||
-		vmx->nested.hv_evmcs;
+		evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
 }
 
 static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..042deaa20d35 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6941,6 +6941,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = -1ull;
+	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
-- 
2.31.1

