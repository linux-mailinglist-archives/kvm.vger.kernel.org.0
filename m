Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA032B5A5
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382136AbhCCHTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835970AbhCBTfc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHJTxUhlLesdBCiNoacQ5XmeW2PWty/Fl6t4yVWsjlo=;
        b=cSQmnVLX4QPTwuwGHl36UBGVXtj7giyp1RZ+4HKOmABJ+TlCNDnosR4icU8L90Lyt/fEbG
        eyAuqgcA3YJ4n5HEnpQ6O0poDA62vADNBvzcJ833KefzOfh1gYneEtezjyUTVXuYygJcwW
        mfcMqXfFdeOX1CU1qC0C35o0Z+ci/74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-p5t82bjmO-6mIhIQFTvdnw-1; Tue, 02 Mar 2021 14:33:46 -0500
X-MC-Unique: p5t82bjmO-6mIhIQFTvdnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D0F218B613D;
        Tue,  2 Mar 2021 19:33:45 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9CF860BFA;
        Tue,  2 Mar 2021 19:33:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Cathy Avery <cavery@redhat.com>
Subject: [PATCH 01/23] KVM: SVM: Use a separate vmcb for the nested L2 guest
Date:   Tue,  2 Mar 2021 14:33:21 -0500
Message-Id: <20210302193343.313318-2-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Avery <cavery@redhat.com>

svm->vmcb will now point to a separate vmcb for L1 (not nested) or L2
(nested).

The main advantages are removing get_host_vmcb and hsave, in favor of
concepts that are shared with VMX.

We don't need anymore to stash the L1 registers in hsave while L2
runs, but we need to copy the VMLOAD/VMSAVE registers from VMCB01 to
VMCB02 and back.  This more or less has the same cost, but code-wise
nested_svm_vmloadsave can be reused.

This patch omits several optimizations that are possible:

- for simplicity there is some wholesale copying of vmcb.control areas
which can go away.

- we should be able to better use the VMCB01 and VMCB02 clean bits.

- another possibility is to always use VMCB01 for VMLOAD and VMSAVE,
thus avoiding the copy of VMLOAD/VMSAVE registers from VMCB01 to
VMCB02 and back.

Tested:
kvm-unit-tests
kvm self tests
Loaded fedora nested guest on fedora

Signed-off-by: Cathy Avery <cavery@redhat.com>
Message-Id: <20201011184818.3609-3-cavery@redhat.com>
[Fix conflicts; keep VMCB02 G_PAT up to date whenever guest writes the
 PAT MSR; do not copy CR4 over from VMCB01 as it is not needed anymore; add
 a few more comments. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 160 +++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c    |  49 +++++++++---
 arch/x86/kvm/svm/svm.h    |  31 ++++----
 3 files changed, 135 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 35891d9a1099..3bbb4acdf956 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -92,12 +92,12 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *hsave = svm->nested.hsave;
 
 	WARN_ON(mmu_is_nested(vcpu));
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
-	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, hsave->save.cr4, hsave->save.efer,
+	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01.ptr->save.cr4,
+				svm->vmcb01.ptr->save.efer,
 				svm->nested.ctl.nested_cr3);
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
@@ -123,7 +123,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		return;
 
 	c = &svm->vmcb->control;
-	h = &svm->nested.hsave->control;
+	h = &svm->vmcb01.ptr->control;
 	g = &svm->nested.ctl;
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
@@ -386,8 +386,19 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
+void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
+{
+	if (!svm->nested.vmcb02.ptr)
+		return;
+
+	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
+	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
+}
+
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
+	nested_vmcb02_compute_g_pat(svm);
+
 	/* Load the nested guest state */
 	svm->vmcb->save.es = vmcb12->save.es;
 	svm->vmcb->save.cs = vmcb12->save.cs;
@@ -417,6 +428,9 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
 
+	/* FIXME: go through each field one by one.  */
+	svm->nested.vmcb02.ptr->control = svm->vmcb01.ptr->control;
+
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(&svm->vcpu);
 
@@ -425,7 +439,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 
 	svm->vmcb->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & ~mask) |
-		(svm->nested.hsave->control.int_ctl & mask);
+		(svm->vmcb01.ptr->control.int_ctl & mask);
 
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
@@ -468,7 +482,13 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
 
 
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
+
+	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
+
+	nested_svm_vmloadsave(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 	load_nested_vmcb_control(svm, &vmcb12->control);
+
+	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_prepare_vmcb_control(svm);
 	nested_prepare_vmcb_save(svm, vmcb12);
 
@@ -489,8 +509,6 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	int ret;
 	struct vmcb *vmcb12;
-	struct vmcb *hsave = svm->nested.hsave;
-	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
@@ -529,28 +547,17 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
 	/*
-	 * Save the old vmcb, so we don't need to pick what we save, but can
-	 * restore everything when a VMEXIT occurs
+	 * Since vmcb01 is not in use, we can use it to store some of the L1
+	 * state.
 	 */
-	hsave->save.es     = vmcb->save.es;
-	hsave->save.cs     = vmcb->save.cs;
-	hsave->save.ss     = vmcb->save.ss;
-	hsave->save.ds     = vmcb->save.ds;
-	hsave->save.gdtr   = vmcb->save.gdtr;
-	hsave->save.idtr   = vmcb->save.idtr;
-	hsave->save.efer   = svm->vcpu.arch.efer;
-	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	hsave->save.cr4    = svm->vcpu.arch.cr4;
-	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
-	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
-	hsave->save.rsp    = vmcb->save.rsp;
-	hsave->save.rax    = vmcb->save.rax;
-	if (npt_enabled)
-		hsave->save.cr3    = vmcb->save.cr3;
-	else
-		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
-
-	copy_vmcb_control_area(&hsave->control, &vmcb->control);
+	svm->vmcb01.ptr->save.efer   = svm->vcpu.arch.efer;
+	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(&svm->vcpu);
+	svm->vmcb01.ptr->save.cr4    = svm->vcpu.arch.cr4;
+	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(&svm->vcpu);
+	svm->vmcb01.ptr->save.rip    = kvm_rip_read(&svm->vcpu);
+
+	if (!npt_enabled)
+		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(&svm->vcpu);
 
 	svm->nested.nested_run_pending = 1;
 
@@ -596,7 +603,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	int rc;
 	struct vmcb *vmcb12;
-	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 
@@ -662,35 +668,35 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
-	/* Restore the original control entries */
-	copy_vmcb_control_area(&vmcb->control, &hsave->control);
+	nested_svm_vmloadsave(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
+
+	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	/* On vmexit the  GIF is set to false */
+	/*
+	 * On vmexit the  GIF is set to false and
+	 * no event can be injected in L1.
+	 */
 	svm_set_gif(svm, false);
+	svm->vmcb->control.exit_int_info = 0;
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset;
 
 	svm->nested.ctl.nested_cr3 = 0;
 
-	/* Restore selected save entries */
-	svm->vmcb->save.es = hsave->save.es;
-	svm->vmcb->save.cs = hsave->save.cs;
-	svm->vmcb->save.ss = hsave->save.ss;
-	svm->vmcb->save.ds = hsave->save.ds;
-	svm->vmcb->save.gdtr = hsave->save.gdtr;
-	svm->vmcb->save.idtr = hsave->save.idtr;
-	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
-	kvm_set_rflags(&svm->vcpu, hsave->save.rflags | X86_EFLAGS_FIXED);
-	svm_set_efer(&svm->vcpu, hsave->save.efer);
-	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
-	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
-	kvm_rax_write(&svm->vcpu, hsave->save.rax);
-	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
-	kvm_rip_write(&svm->vcpu, hsave->save.rip);
-	svm->vmcb->save.dr7 = DR7_FIXED_1;
-	svm->vmcb->save.cpl = 0;
-	svm->vmcb->control.exit_int_info = 0;
+	/*
+	 * Restore processor state that had been saved in vmcb01
+	 */
+	kvm_set_rflags(&svm->vcpu, svm->vmcb->save.rflags | X86_EFLAGS_FIXED);
+	svm_set_efer(&svm->vcpu, svm->vmcb->save.efer);
+	svm_set_cr0(&svm->vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(&svm->vcpu, svm->vmcb->save.cr4);
+	kvm_rax_write(&svm->vcpu, svm->vmcb->save.rax);
+	kvm_rsp_write(&svm->vcpu, svm->vmcb->save.rsp);
+	kvm_rip_write(&svm->vcpu, svm->vmcb->save.rip);
+
+	svm->vcpu.arch.dr7 = DR7_FIXED_1;
+	kvm_update_dr7(&svm->vcpu);
 
 	vmcb_mark_all_dirty(svm->vmcb);
 
@@ -705,13 +711,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
 
-	rc = nested_svm_load_cr3(&svm->vcpu, hsave->save.cr3, false);
+	rc = nested_svm_load_cr3(&svm->vcpu, svm->vmcb->save.cr3, false);
 	if (rc)
 		return 1;
 
-	if (npt_enabled)
-		svm->vmcb->save.cr3 = hsave->save.cr3;
-
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
 	 * doesn't end up in L1.
@@ -725,26 +728,27 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 int svm_allocate_nested(struct vcpu_svm *svm)
 {
-	struct page *hsave_page;
+	struct page *vmcb02_page;
 
 	if (svm->nested.initialized)
 		return 0;
 
-	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!hsave_page)
+	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!vmcb02_page)
 		return -ENOMEM;
-	svm->nested.hsave = page_address(hsave_page);
+	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
+	svm->nested.vmcb02.pa = __sme_set(page_to_pfn(vmcb02_page) << PAGE_SHIFT);
 
 	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->nested.msrpm)
-		goto err_free_hsave;
+		goto err_free_vmcb02;
 	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
 
 	svm->nested.initialized = true;
 	return 0;
 
-err_free_hsave:
-	__free_page(hsave_page);
+err_free_vmcb02:
+	__free_page(vmcb02_page);
 	return -ENOMEM;
 }
 
@@ -756,8 +760,8 @@ void svm_free_nested(struct vcpu_svm *svm)
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 
-	__free_page(virt_to_page(svm->nested.hsave));
-	svm->nested.hsave = NULL;
+	__free_page(virt_to_page(svm->nested.vmcb02.ptr));
+	svm->nested.vmcb02.ptr = NULL;
 
 	svm->nested.initialized = false;
 }
@@ -768,12 +772,11 @@ void svm_free_nested(struct vcpu_svm *svm)
 void svm_leave_nested(struct vcpu_svm *svm)
 {
 	if (is_guest_mode(&svm->vcpu)) {
-		struct vmcb *hsave = svm->nested.hsave;
-		struct vmcb *vmcb = svm->vmcb;
-
 		svm->nested.nested_run_pending = 0;
 		leave_guest_mode(&svm->vcpu);
-		copy_vmcb_control_area(&vmcb->control, &hsave->control);
+
+		svm_switch_vmcb(svm, &svm->nested.vmcb02);
+
 		nested_svm_uninit_mmu_context(&svm->vcpu);
 		vmcb_mark_all_dirty(svm->vmcb);
 	}
@@ -1056,8 +1059,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 
-		if (get_host_vmcb(svm)->control.intercepts[INTERCEPT_EXCEPTION] &
-				excp_bits)
+		if (svm->vmcb01.ptr->control.intercepts[INTERCEPT_EXCEPTION] &
+		    excp_bits)
 			return NESTED_EXIT_HOST;
 		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
 			 svm->vcpu.arch.apf.host_apf_flags)
@@ -1121,10 +1124,9 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
 			 sizeof(user_vmcb->control)))
 		return -EFAULT;
-	if (copy_to_user(&user_vmcb->save, &svm->nested.hsave->save,
+	if (copy_to_user(&user_vmcb->save, &svm->vmcb01.ptr->save,
 			 sizeof(user_vmcb->save)))
 		return -EFAULT;
-
 out:
 	return kvm_state.size;
 }
@@ -1134,7 +1136,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state *kvm_state)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb __user *user_vmcb = (struct vmcb __user *)
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area *ctl;
@@ -1211,20 +1212,23 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	/*
-	 * All checks done, we can enter guest mode.  L1 control fields
-	 * come from the nested save state.  Guest state is already
-	 * in the registers, the save area of the nested state instead
-	 * contains saved L1 state.
+	 * All checks done, we can enter guest mode. Userspace provides
+	 * vmcb12.control, which will be combined with L1 and stored into
+	 * vmcb02, and the L1 save state which we store in vmcb01.
+	 * L2 registers if needed are moved from the current VMCB to VMCB02.
 	 */
 
 	svm->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
-	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
-	hsave->save = *save;
-
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
+	if (svm->current_vmcb == &svm->vmcb01)
+		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
+	svm->vmcb01.ptr->save = *save;
 	load_nested_vmcb_control(svm, ctl);
+
+	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+
 	nested_prepare_vmcb_control(svm);
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c636021b066b..1d24129496d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1083,8 +1083,8 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	if (is_guest_mode(vcpu)) {
 		/* Write L1's TSC offset.  */
 		g_tsc_offset = svm->vmcb->control.tsc_offset -
-			       svm->nested.hsave->control.tsc_offset;
-		svm->nested.hsave->control.tsc_offset = offset;
+			       svm->vmcb01.ptr->control.tsc_offset;
+		svm->vmcb01.ptr->control.tsc_offset = offset;
 	}
 
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
@@ -1303,10 +1303,31 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
 }
 
+void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
+{
+	svm->current_vmcb = target_vmcb;
+	svm->vmcb = target_vmcb->ptr;
+	svm->vmcb_pa = target_vmcb->pa;
+
+	/*
+	* Workaround: we don't yet track the ASID generation
+	* that was active the last time target_vmcb was run.
+	*/
+
+	svm->asid_generation = 0;
+
+	/*
+	* Workaround: we don't yet track the physical CPU that
+	* target_vmcb has run on.
+	*/
+
+	vmcb_mark_all_dirty(svm->vmcb);
+}
+
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
-	struct page *vmcb_page;
+	struct page *vmcb01_page;
 	struct page *vmsa_page = NULL;
 	int err;
 
@@ -1314,8 +1335,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!vmcb_page)
+	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!vmcb01_page)
 		goto out;
 
 	if (sev_es_guest(svm->vcpu.kvm)) {
@@ -1354,14 +1375,16 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
-	svm->vmcb = page_address(vmcb_page);
-	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
+	svm->vmcb01.ptr = page_address(vmcb01_page);
+	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 
 	if (vmsa_page)
 		svm->vmsa = page_address(vmsa_page);
 
 	svm->asid_generation = 0;
 	svm->guest_state_loaded = false;
+
+	svm_switch_vmcb(svm, &svm->vmcb01);
 	init_vmcb(svm);
 
 	svm_init_osvw(vcpu);
@@ -1377,7 +1400,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (vmsa_page)
 		__free_page(vmsa_page);
 error_free_vmcb_page:
-	__free_page(vmcb_page);
+	__free_page(vmcb01_page);
 out:
 	return err;
 }
@@ -1405,7 +1428,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	sev_free_vcpu(vcpu);
 
-	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
+	__free_page(pfn_to_page(__sme_clr(svm->vmcb01.pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 }
 
@@ -1562,7 +1585,7 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 	/* Drop int_ctl fields related to VINTR injection.  */
 	svm->vmcb->control.int_ctl &= mask;
 	if (is_guest_mode(&svm->vcpu)) {
-		svm->nested.hsave->control.int_ctl &= mask;
+		svm->vmcb01.ptr->control.int_ctl &= mask;
 
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
@@ -2859,7 +2882,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
 			return 1;
 		vcpu->arch.pat = data;
-		svm->vmcb->save.g_pat = data;
+		svm->vmcb01.ptr->save.g_pat = data;
+		if (is_guest_mode(vcpu))
+			nested_vmcb02_compute_g_pat(svm);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 		break;
 	case MSR_IA32_SPEC_CTRL:
@@ -3534,7 +3559,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	} else if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
-		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
+		    ? !(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..818b37388d8c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -81,8 +81,13 @@ struct kvm_svm {
 
 struct kvm_vcpu;
 
+struct kvm_vmcb_info {
+	struct vmcb *ptr;
+	unsigned long pa;
+};
+
 struct svm_nested_state {
-	struct vmcb *hsave;
+	struct kvm_vmcb_info vmcb02;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb12_gpa;
@@ -104,6 +109,8 @@ struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
 	unsigned long vmcb_pa;
+	struct kvm_vmcb_info vmcb01;
+	struct kvm_vmcb_info *current_vmcb;
 	struct svm_cpu_data *svm_data;
 	u32 asid;
 	uint64_t asid_generation;
@@ -244,14 +251,6 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_svm, vcpu);
 }
 
-static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
-{
-	if (is_guest_mode(&svm->vcpu))
-		return svm->nested.hsave;
-	else
-		return svm->vmcb;
-}
-
 static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
 {
 	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
@@ -272,7 +271,7 @@ static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
 
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	if (!sev_es_guest(svm->vcpu.kvm)) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
@@ -299,7 +298,7 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 
 static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
@@ -314,7 +313,7 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	WARN_ON_ONCE(bit >= 32);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
@@ -324,7 +323,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 
 static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	WARN_ON_ONCE(bit >= 32);
 	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
@@ -334,7 +333,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb_set_intercept(&vmcb->control, bit);
 
@@ -343,7 +342,7 @@ static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb_clr_intercept(&vmcb->control, bit);
 
@@ -451,6 +450,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
+void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
+void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
-- 
2.26.2


