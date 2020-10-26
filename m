Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88DB299421
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788166AbgJZRmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:42:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1788146AbgJZRme (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 13:42:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603734150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u4xVzWo5FFL+WdsHq5+QV8kAGWkVhjv57N4NpnQdzOs=;
        b=YmPLN3LUUnWtKw71OdoJvaxlYR+VchaxtSCaUn5Sni+VWaOLaceQb24ngfls8Pniw2GwGK
        Z/uVPFnN0/eScVr+vQCd1FQscPXG4OWRrYsSiTOKuCsHm7XIB+6BOb2xsn8jKhb/O1RLyj
        zgX+fk5iNCSt9w+0jDVMKvVNOkmpN24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-jcuqTyg6PC-ZaCL1coJf_g-1; Mon, 26 Oct 2020 13:42:26 -0400
X-MC-Unique: jcuqTyg6PC-ZaCL1coJf_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 186741800D4A;
        Mon, 26 Oct 2020 17:42:25 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6268562A0B;
        Mon, 26 Oct 2020 17:42:24 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com,
        sean.j.christopherson@intel.com
Subject: [PATCH v3 2/2] KVM: SVM: Use a separate vmcb for the nested L2 guest
Date:   Mon, 26 Oct 2020 13:42:22 -0400
Message-Id: <20201026174222.21811-3-cavery@redhat.com>
In-Reply-To: <20201026174222.21811-1-cavery@redhat.com>
References: <20201026174222.21811-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb ( nested ).

Issues:

1) There is some wholesale copying of vmcb.save and vmcb.contol
   areas which will need to be refined.

Tested:
kvm-unit-tests
kvm self tests
Loaded fedora nested guest on fedora

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 125 ++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.c    |  42 +++++++------
 arch/x86/kvm/svm/svm.h    |  49 ++++-----------
 3 files changed, 94 insertions(+), 122 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e90bc436f584..3acab2bf99a5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -75,12 +75,12 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *hsave = svm->nested.hsave;
 
 	WARN_ON(mmu_is_nested(vcpu));
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
-	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, hsave->save.cr4, hsave->save.efer,
+	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01->save.cr4,
+				svm->vmcb01->save.efer,
 				svm->nested.ctl.nested_cr3);
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
@@ -105,7 +105,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		return;
 
 	c = &svm->vmcb->control;
-	h = &svm->nested.hsave->control;
+	h = &svm->vmcb01->control;
 	g = &svm->nested.ctl;
 
 	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
@@ -403,7 +403,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 
 	svm->vmcb->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & ~mask) |
-		(svm->nested.hsave->control.int_ctl & mask);
+		(svm->vmcb01->control.int_ctl & mask);
 
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
@@ -426,12 +426,29 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	vmcb_mark_all_dirty(svm->vmcb);
 }
 
+static void svm_switch_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb, unsigned long vmcb_pa)
+{
+	if (svm->vmcb == vmcb)
+		return;
+
+	svm->vmcb = vmcb;
+	svm->vmcb_pa = vmcb_pa;
+}
+
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb)
 {
 	int ret;
 
 	svm->nested.vmcb = vmcb_gpa;
+
+	WARN_ON(svm->vmcb == svm->nested.vmcb02);
+
+	svm->nested.vmcb02->control = svm->vmcb01->control;
+	svm->nested.vmcb02->save.cr4 = svm->vmcb01->save.cr4;
+
+	nested_svm_vmloadsave(svm->vmcb01, svm->nested.vmcb02);
+	svm_switch_vmcb(svm, svm->nested.vmcb02, svm->nested.vmcb02_pa);
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
 	nested_prepare_vmcb_save(svm, nested_vmcb);
 	nested_prepare_vmcb_control(svm);
@@ -450,8 +467,6 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	int ret;
 	struct vmcb *nested_vmcb;
-	struct vmcb *hsave = svm->nested.hsave;
-	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 	u64 vmcb_gpa;
 
@@ -496,29 +511,14 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
-	/*
-	 * Save the old vmcb, so we don't need to pick what we save, but can
-	 * restore everything when a VMEXIT occurs
-	 */
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
+	svm->vmcb01->save.efer   = svm->vcpu.arch.efer;
+	svm->vmcb01->save.cr0    = kvm_read_cr0(&svm->vcpu);
+	svm->vmcb01->save.cr4    = svm->vcpu.arch.cr4;
+	svm->vmcb01->save.rflags = kvm_get_rflags(&svm->vcpu);
+	svm->vmcb01->save.rip    = kvm_rip_read(&svm->vcpu);
+
+	if (!npt_enabled)
+		svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);
 
 	svm->nested.nested_run_pending = 1;
 
@@ -564,7 +564,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	int rc;
 	struct vmcb *nested_vmcb;
-	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 
@@ -628,8 +627,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
-	/* Restore the original control entries */
-	copy_vmcb_control_area(&vmcb->control, &hsave->control);
+	nested_svm_vmloadsave(svm->nested.vmcb02, svm->vmcb01);
+	svm_switch_vmcb(svm, svm->vmcb01, svm->vmcb01_pa);
 
 	/* On vmexit the  GIF is set to false */
 	svm_set_gif(svm, false);
@@ -640,19 +639,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->nested.ctl.nested_cr3 = 0;
 
 	/* Restore selected save entries */
-	svm->vmcb->save.es = hsave->save.es;
-	svm->vmcb->save.cs = hsave->save.cs;
-	svm->vmcb->save.ss = hsave->save.ss;
-	svm->vmcb->save.ds = hsave->save.ds;
-	svm->vmcb->save.gdtr = hsave->save.gdtr;
-	svm->vmcb->save.idtr = hsave->save.idtr;
-	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
-	svm_set_efer(&svm->vcpu, hsave->save.efer);
-	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
-	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
-	kvm_rax_write(&svm->vcpu, hsave->save.rax);
-	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
-	kvm_rip_write(&svm->vcpu, hsave->save.rip);
+	kvm_set_rflags(&svm->vcpu, svm->vmcb->save.rflags);
+	svm_set_efer(&svm->vcpu, svm->vmcb->save.efer);
+	svm_set_cr0(&svm->vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(&svm->vcpu, svm->vmcb->save.cr4);
+	kvm_rax_write(&svm->vcpu, svm->vmcb->save.rax);
+	kvm_rsp_write(&svm->vcpu, svm->vmcb->save.rsp);
+	kvm_rip_write(&svm->vcpu, svm->vmcb->save.rip);
 	svm->vmcb->save.dr7 = 0;
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
@@ -670,13 +663,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
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
@@ -694,12 +684,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 void svm_leave_nested(struct vcpu_svm *svm)
 {
 	if (is_guest_mode(&svm->vcpu)) {
-		struct vmcb *hsave = svm->nested.hsave;
-		struct vmcb *vmcb = svm->vmcb;
-
 		svm->nested.nested_run_pending = 0;
 		leave_guest_mode(&svm->vcpu);
-		copy_vmcb_control_area(&vmcb->control, &hsave->control);
+		svm_switch_vmcb(svm, svm->vmcb01, svm->vmcb01_pa);
 		nested_svm_uninit_mmu_context(&svm->vcpu);
 	}
 }
@@ -982,7 +969,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 
-		if (get_host_vmcb(svm)->control.intercept_exceptions & excp_bits)
+		if (svm->vmcb01->control.intercept_exceptions & excp_bits)
 			return NESTED_EXIT_HOST;
 		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
 			 svm->vcpu.arch.apf.host_apf_flags)
@@ -1046,10 +1033,9 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
 			 sizeof(user_vmcb->control)))
 		return -EFAULT;
-	if (copy_to_user(&user_vmcb->save, &svm->nested.hsave->save,
+	if (copy_to_user(&user_vmcb->save, &svm->vmcb01->save,
 			 sizeof(user_vmcb->save)))
 		return -EFAULT;
-
 out:
 	return kvm_state.size;
 }
@@ -1059,7 +1045,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state *kvm_state)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb __user *user_vmcb = (struct vmcb __user *)
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area ctl;
@@ -1088,10 +1073,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return -EINVAL;
 
-	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
-		svm_leave_nested(svm);
+	/* If in L2 force to L1 */
+
+	svm_leave_nested(svm);
+
+	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		goto out_set_gif;
-	}
 
 	if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
 		return -EINVAL;
@@ -1121,16 +1108,20 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save.cr0 & X86_CR0_PG))
 		return -EINVAL;
 
+	svm->nested.vmcb02->control = svm->vmcb01->control;
+	svm->nested.vmcb02->save = svm->vmcb01->save;
+	svm->vmcb01->save = save;
+
+	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
+	svm_switch_vmcb(svm, svm->nested.vmcb02, svm->nested.vmcb02_pa);
+
 	/*
-	 * All checks done, we can enter guest mode.  L1 control fields
-	 * come from the nested save state.  Guest state is already
-	 * in the registers, the save area of the nested state instead
-	 * contains saved L1 state.
+	 * All checks done, we can enter guest mode. L2 control fields will
+	 * be the result of a combination of L1 and userspace indicated
+	 * L12.control. The save area of L1 vmcb now contains the userspace
+	 * indicated L1.save.
 	 */
-	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
-	hsave->save = save;
 
-	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
 	load_nested_vmcb_control(svm, &ctl);
 	nested_prepare_vmcb_control(svm);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 83b4f56883f8..a5f69d27927a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -971,8 +971,8 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	if (is_guest_mode(vcpu)) {
 		/* Write L1's TSC offset.  */
 		g_tsc_offset = svm->vmcb->control.tsc_offset -
-			       svm->nested.hsave->control.tsc_offset;
-		svm->nested.hsave->control.tsc_offset = offset;
+			       svm->vmcb01->control.tsc_offset;
+		svm->vmcb01->control.tsc_offset = offset;
 	}
 
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
@@ -1097,6 +1097,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = svm->vcpu.arch.pat;
+		svm->nested.vmcb02->save.g_pat = svm->vcpu.arch.pat;
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
@@ -1172,9 +1173,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
-	struct page *page;
+	struct page *vmcb01_page;
+	struct page *vmcb02_page;
 	struct page *msrpm_pages;
-	struct page *hsave_page;
 	struct page *nested_msrpm_pages;
 	int err;
 
@@ -1182,8 +1183,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!page)
+	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!vmcb01_page)
 		goto out;
 
 	msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
@@ -1194,8 +1195,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!nested_msrpm_pages)
 		goto free_page2;
 
-	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!hsave_page)
+	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!vmcb02_page)
 		goto free_page3;
 
 	err = avic_init_vcpu(svm);
@@ -1208,8 +1209,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (irqchip_in_kernel(vcpu->kvm) && kvm_apicv_activated(vcpu->kvm))
 		svm->avic_is_running = true;
 
-	svm->nested.hsave = page_address(hsave_page);
-	clear_page(svm->nested.hsave);
+	svm->nested.vmcb02 = page_address(vmcb02_page);
+	clear_page(svm->nested.vmcb02);
+	svm->nested.vmcb02_pa = __sme_set(page_to_pfn(vmcb02_page) << PAGE_SHIFT);
 
 	svm->msrpm = page_address(msrpm_pages);
 	svm_vcpu_init_msrpm(svm->msrpm);
@@ -1217,9 +1219,11 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
 	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
-	svm->vmcb = page_address(page);
+	svm->vmcb = svm->vmcb01 = page_address(vmcb01_page);
 	clear_page(svm->vmcb);
-	svm->vmcb_pa = __sme_set(page_to_pfn(page) << PAGE_SHIFT);
+	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
+	svm->vmcb01_pa = svm->vmcb_pa;
+
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
@@ -1229,13 +1233,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	return 0;
 
 free_page4:
-	__free_page(hsave_page);
+	__free_page(vmcb02_page);
 free_page3:
 	__free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
 free_page2:
 	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
 free_page1:
-	__free_page(page);
+	__free_page(vmcb01_page);
 out:
 	return err;
 }
@@ -1257,11 +1261,11 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	 * svm_vcpu_load(). So, ensure that no logical CPU has this
 	 * vmcb page recorded as its current vmcb.
 	 */
-	svm_clear_current_vmcb(svm->vmcb);
 
-	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
+	svm_clear_current_vmcb(svm->vmcb);
+	__free_page(pfn_to_page(__sme_clr(svm->vmcb01_pa) >> PAGE_SHIFT));
+	__free_page(pfn_to_page(__sme_clr(svm->nested.vmcb02_pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
-	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 }
 
@@ -1394,7 +1398,7 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 	/* Drop int_ctl fields related to VINTR injection.  */
 	svm->vmcb->control.int_ctl &= mask;
 	if (is_guest_mode(&svm->vcpu)) {
-		svm->nested.hsave->control.int_ctl &= mask;
+		svm->vmcb01->control.int_ctl &= mask;
 
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
@@ -3145,7 +3149,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
-		    ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
+		    ? !(svm->vmcb01->save.rflags & X86_EFLAGS_IF)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 22832362bced..b3b6150fdf97 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -82,7 +82,8 @@ struct kvm_svm {
 struct kvm_vcpu;
 
 struct svm_nested_state {
-	struct vmcb *hsave;
+	struct vmcb *vmcb02;
+	unsigned long vmcb02_pa;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb;
@@ -103,6 +104,8 @@ struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
 	unsigned long vmcb_pa;
+	struct vmcb *vmcb01;
+	unsigned long vmcb01_pa;
 	struct svm_cpu_data *svm_data;
 	u32 asid;
 	uint64_t asid_generation;
@@ -208,44 +211,28 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
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
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept_cr |= (1U << bit);
+	svm->vmcb01->control.intercept_cr |= (1U << bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept_cr &= ~(1U << bit);
+	svm->vmcb01->control.intercept_cr &= ~(1U << bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	return vmcb->control.intercept_cr & (1U << bit);
+	return svm->vmcb01->control.intercept_cr & (1U << bit);
 }
 
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
+	svm->vmcb01->control.intercept_dr = (1 << INTERCEPT_DR0_READ)
 		| (1 << INTERCEPT_DR1_READ)
 		| (1 << INTERCEPT_DR2_READ)
 		| (1 << INTERCEPT_DR3_READ)
@@ -267,45 +254,35 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 
 static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept_dr = 0;
+	svm->vmcb01->control.intercept_dr = 0;
 
 	recalc_intercepts(svm);
 }
 
 static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept_exceptions |= (1U << bit);
+	svm->vmcb01->control.intercept_exceptions |= (1U << bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept_exceptions &= ~(1U << bit);
+	svm->vmcb01->control.intercept_exceptions &= ~(1U << bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept |= (1ULL << bit);
+	svm->vmcb01->control.intercept |= (1ULL << bit);
 
 	recalc_intercepts(svm);
 }
 
 static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
-
-	vmcb->control.intercept &= ~(1ULL << bit);
+	svm->vmcb01->control.intercept &= ~(1ULL << bit);
 
 	recalc_intercepts(svm);
 }
-- 
2.20.1

