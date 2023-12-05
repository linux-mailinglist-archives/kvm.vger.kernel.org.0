Return-Path: <kvm+bounces-3495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 020E180509F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A32AC1F2152C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6505789D;
	Tue,  5 Dec 2023 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWv/KoII"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C381FEA
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWqNoTTTC+ruau0SV06IrneP6ukIZeKdY+JeinCI5K8=;
	b=IWv/KoIIAKolEGnipefdQqiC6mPGg3WeFXfwjJt2V1y0+yjhAo6j5ReE5l70rdNrdLbMMr
	g7AdAWSRq2ceBOl/omTUXBJP+ZqqDqYKyAVy/zy9pJvX9QSfBhw0Xvugj28e1GOgeanSGM
	0qgr/Yen9f9PXMZHzeJx1ZYHIX2bigM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-lUF45r5VOQmbGOUSNraISA-1; Tue,
 05 Dec 2023 05:36:46 -0500
X-MC-Unique: lUF45r5VOQmbGOUSNraISA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 079EE29ABA12;
	Tue,  5 Dec 2023 10:36:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 395EE2026D66;
	Tue,  5 Dec 2023 10:36:45 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 13/16] KVM: nVMX: hyper-v: Introduce nested_vmx_is_evmptr12_{valid,set}() helpers
Date: Tue,  5 Dec 2023 11:36:27 +0100
Message-ID: <20231205103630.1391318-14-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

In order to get rid of raw 'vmx->nested.hv_evmcs_vmptr' accesses when
!CONFIG_KVM_HYPERV, introduce a pair of helpers:

nested_vmx_is_evmptr12_valid() to check that eVMPTR points to a valid
address.

nested_vmx_is_evmptr12_valid() to check that eVMPTR either points to a
valid address or is in 'pending' port-migration state (meaning it is
supposed to be valid but the exact address wasn't acquired from guest's
memory yet).

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/hyperv.h | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++-------------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 3 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 0e90ef4efe34..71e90a16f183 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -22,6 +22,21 @@ static inline bool evmptr_is_valid(u64 evmptr)
 	return evmptr != EVMPTR_INVALID && evmptr != EVMPTR_MAP_PENDING;
 }
 
+static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
+{
+	return evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
+}
+
+static inline bool evmptr_is_set(u64 evmptr)
+{
+	return evmptr != EVMPTR_INVALID;
+}
+
+static inline bool nested_vmx_is_evmptr12_set(struct vcpu_vmx *vmx)
+{
+	return evmptr_is_set(vmx->nested.hv_evmcs_vmptr);
+}
+
 static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -45,6 +60,21 @@ static inline bool evmptr_is_valid(u64 evmptr)
 {
 	return false;
 }
+
+static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
+{
+	return false;
+}
+
+static inline bool evmptr_is_set(u64 evmptr)
+{
+	return false;
+}
+
+static inline bool nested_vmx_is_evmptr12_set(struct vcpu_vmx *vmx)
+{
+	return false;
+}
 #endif
 
 #endif /* __KVM_X86_VMX_HYPERV_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 01a94d290c12..0507174750e0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -179,7 +179,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
 	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
 	 * fields and thus must be synced.
 	 */
-	if (to_vmx(vcpu)->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
+	if (nested_vmx_is_evmptr12_set(to_vmx(vcpu)))
 		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -194,7 +194,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
 	 * can't be done if there isn't a current VMCS.
 	 */
 	if (vmx->nested.current_vmptr == INVALID_GPA &&
-	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	    !nested_vmx_is_evmptr12_valid(vmx))
 		return nested_vmx_failInvalid(vcpu);
 
 	return nested_vmx_failValid(vcpu, vm_instruction_error);
@@ -230,7 +230,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+	if (nested_vmx_is_evmptr12_valid(vmx)) {
 		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
 		vmx->nested.hv_evmcs = NULL;
 	}
@@ -2123,7 +2123,7 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	if (nested_vmx_is_evmptr12_valid(vmx))
 		copy_vmcs12_to_enlightened(vmx);
 	else
 		copy_vmcs12_to_shadow(vmx);
@@ -2277,7 +2277,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	u32 exec_control;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
-	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx))
 		prepare_vmcs02_early_rare(vmx, vmcs12);
 
 	/*
@@ -2572,11 +2572,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool load_guest_pdptrs_vmcs12 = false;
 
-	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
 		prepare_vmcs02_rare(vmx, vmcs12);
 		vmx->nested.dirty_vmcs12 = false;
 
-		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) ||
+		load_guest_pdptrs_vmcs12 = !nested_vmx_is_evmptr12_valid(vmx) ||
 			!(vmx->nested.hv_evmcs->hv_clean_fields &
 			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
@@ -2699,7 +2699,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * bits when it changes a field in eVMCS. Mark all fields as clean
 	 * here.
 	 */
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	if (nested_vmx_is_evmptr12_valid(vmx))
 		vmx->nested.hv_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
@@ -3579,7 +3579,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason.full;
-	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	if (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
 }
@@ -3610,7 +3610,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
+	if (CC(!nested_vmx_is_evmptr12_valid(vmx) &&
 	       vmx->nested.current_vmptr == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
 
@@ -3625,7 +3625,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (CC(vmcs12->hdr.shadow_vmcs))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+	if (nested_vmx_is_evmptr12_valid(vmx)) {
 		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
@@ -4370,11 +4370,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	if (nested_vmx_is_evmptr12_valid(vmx))
 		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare =
-		!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
+		!nested_vmx_is_evmptr12_valid(vmx);
 
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
@@ -4897,7 +4897,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	}
 
 	if ((vm_exit_reason != -1) &&
-	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
+	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
@@ -5390,7 +5390,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
+	if (!nested_vmx_is_evmptr12_valid(vmx)) {
 		/*
 		 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
 		 * any VMREAD sets the ALU flags for VMfailInvalid.
@@ -5616,7 +5616,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
 
 	/* Forbid normal VMPTRLD if Enlightened version was used */
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+	if (nested_vmx_is_evmptr12_valid(vmx))
 		return 1;
 
 	if (vmx->nested.current_vmptr != vmptr) {
@@ -5679,7 +5679,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (unlikely(evmptr_is_valid(to_vmx(vcpu)->nested.hv_evmcs_vmptr)))
+	if (unlikely(nested_vmx_is_evmptr12_valid(to_vmx(vcpu))))
 		return 1;
 
 	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
@@ -6467,7 +6467,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
 			/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
-			if (vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
+			if (nested_vmx_is_evmptr12_set(vmx))
 				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
 
 			if (is_guest_mode(vcpu) &&
@@ -6523,7 +6523,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	} else  {
 		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
 		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
-			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+			if (nested_vmx_is_evmptr12_valid(vmx))
 				/*
 				 * L1 hypervisor is not obliged to keep eVMCS
 				 * clean fields data always up-to-date while
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b0f2e26c1aea..cce4e2aa30fb 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -58,7 +58,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 
 	/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
 	return vmx->nested.current_vmptr != -1ull ||
-		vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID;
+		nested_vmx_is_evmptr12_set(vmx);
 }
 
 static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
-- 
2.43.0


