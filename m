Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC99B32B5B8
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383213AbhCCHTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835992AbhCBTfl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LVRBRDbTpPZ2b08Pnf/jdl9e7mGbsfBHlrg7GFyk1mw=;
        b=g06EDNE7Oai+1Q+ws9d1i5a65e2SzN8y/chBzYVA+mSi+Djcmm/IHIjRCxWWX5lxq+W9tq
        3qvKBbmi+W/3L51M3T5xn6lR5TD6KXLSCq9Z8pPOcGl9kakGBPKVcJfbbPpdj2X93z7aOi
        /8v+lgB8tPvQ+IclVZBwVu/0Us6FKso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-MHWR4WVlNHmF_4egu0ezeg-1; Tue, 02 Mar 2021 14:33:53 -0500
X-MC-Unique: MHWR4WVlNHmF_4egu0ezeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2132B801976;
        Tue,  2 Mar 2021 19:33:52 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E3236F99F;
        Tue,  2 Mar 2021 19:33:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 13/23] KVM: SVM: Pass struct kvm_vcpu to exit handlers (and many, many other places)
Date:   Tue,  2 Mar 2021 14:33:33 -0500
Message-Id: <20210302193343.313318-14-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Refactor the svm_exit_handlers API to pass @vcpu instead of @svm to
allow directly invoking common x86 exit handlers (in a future patch).
Opportunistically convert an absurd number of instances of 'svm->vcpu'
to direct uses of 'vcpu' to avoid pointless casting.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205005750.3841462-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c   |  24 +-
 arch/x86/kvm/svm/nested.c | 126 ++++-----
 arch/x86/kvm/svm/sev.c    |  27 +-
 arch/x86/kvm/svm/svm.c    | 563 +++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.h    |  14 +-
 5 files changed, 384 insertions(+), 370 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 78bdcfac4e40..cd0285f15a68 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -270,7 +270,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
 		return -EINVAL;
 
-	if (!svm->vcpu.arch.apic->regs)
+	if (!vcpu->arch.apic->regs)
 		return -EINVAL;
 
 	if (kvm_apicv_activated(vcpu->kvm)) {
@@ -281,7 +281,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	svm->avic_backing_page = virt_to_page(svm->vcpu.arch.apic->regs);
+	svm->avic_backing_page = virt_to_page(vcpu->arch.apic->regs);
 
 	/* Setting AVIC backing page address in the phy APIC ID table */
 	entry = avic_get_physical_id_entry(vcpu, id);
@@ -315,15 +315,16 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	}
 }
 
-int avic_incomplete_ipi_interception(struct vcpu_svm *svm)
+int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
 	u32 index = svm->vmcb->control.exit_info_2 & 0xFF;
-	struct kvm_lapic *apic = svm->vcpu.arch.apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	trace_kvm_avic_incomplete_ipi(svm->vcpu.vcpu_id, icrh, icrl, id, index);
+	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
 
 	switch (id) {
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
@@ -347,11 +348,11 @@ int avic_incomplete_ipi_interception(struct vcpu_svm *svm)
 		 * set the appropriate IRR bits on the valid target
 		 * vcpus. So, we just need to kick the appropriate vcpu.
 		 */
-		avic_kick_target_vcpus(svm->vcpu.kvm, apic, icrl, icrh);
+		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
 		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
-			  index, svm->vcpu.vcpu_id, icrh, icrl);
+			  index, vcpu->vcpu_id, icrh, icrl);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
@@ -539,8 +540,9 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
 	return ret;
 }
 
-int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
+int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret = 0;
 	u32 offset = svm->vmcb->control.exit_info_1 &
 		     AVIC_UNACCEL_ACCESS_OFFSET_MASK;
@@ -550,7 +552,7 @@ int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 		     AVIC_UNACCEL_ACCESS_WRITE_MASK;
 	bool trap = is_avic_unaccelerated_access_trap(offset);
 
-	trace_kvm_avic_unaccelerated_access(svm->vcpu.vcpu_id, offset,
+	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
 					    trap, write, vector);
 	if (trap) {
 		/* Handling Trap */
@@ -558,7 +560,7 @@ int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 		ret = avic_unaccel_trap_write(svm);
 	} else {
 		/* Handling Fault */
-		ret = kvm_emulate_instruction(&svm->vcpu, 0);
+		ret = kvm_emulate_instruction(vcpu, 0);
 	}
 
 	return ret;
@@ -572,7 +574,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	if (!avic || !irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
-	ret = avic_init_backing_page(&svm->vcpu);
+	ret = avic_init_backing_page(vcpu);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 03a06f959bc8..7ed49d8cef5e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,11 +247,9 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
-static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
+static bool nested_vmcb_check_cr3_cr4(struct kvm_vcpu *vcpu,
 				      struct vmcb_save_area *save)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-
 	/*
 	 * These checks are also performed by KVM_SET_SREGS,
 	 * except that EFER.LMA is not checked by SVM against
@@ -271,7 +269,7 @@ static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool nested_vmcb_valid_sregs(struct vcpu_svm *svm,
+static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 				    struct vmcb_save_area *save)
 {
 	if (CC(!(save->efer & EFER_SVME)))
@@ -284,18 +282,18 @@ static bool nested_vmcb_valid_sregs(struct vcpu_svm *svm,
 	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
 		return false;
 
-	if (!nested_vmcb_check_cr3_cr4(svm, save))
+	if (!nested_vmcb_check_cr3_cr4(vcpu, save))
 		return false;
 
-	if (CC(!kvm_valid_efer(&svm->vcpu, save->efer)))
+	if (CC(!kvm_valid_efer(vcpu, save->efer)))
 		return false;
 
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
 {
-	if (!nested_vmcb_valid_sregs(svm, &vmcb12->save))
+	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save))
 		return false;
 
 	return nested_vmcb_check_controls(&vmcb12->control);
@@ -514,9 +512,10 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
-int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			 struct vmcb *vmcb12)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
@@ -550,42 +549,43 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
 		return ret;
 
 	if (!npt_enabled)
-		svm->vcpu.arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
+		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
 
 	svm_set_gif(svm, true);
 
 	return 0;
 }
 
-int nested_svm_vmrun(struct vcpu_svm *svm)
+int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
 	struct vmcb *vmcb12;
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
-	if (is_smm(&svm->vcpu)) {
-		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	if (is_smm(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
 	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
 	if (ret == -EINVAL) {
-		kvm_inject_gp(&svm->vcpu, 0);
+		kvm_inject_gp(vcpu, 0);
 		return 1;
 	} else if (ret) {
-		return kvm_skip_emulated_instruction(&svm->vcpu);
+		return kvm_skip_emulated_instruction(vcpu);
 	}
 
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+	ret = kvm_skip_emulated_instruction(vcpu);
 
 	vmcb12 = map.hva;
 
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	if (!nested_vmcb_checks(svm, vmcb12)) {
+	if (!nested_vmcb_checks(vcpu, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -595,25 +595,25 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 
 	/* Clear internal status */
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
 
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
 	 */
-	svm->vmcb01.ptr->save.efer   = svm->vcpu.arch.efer;
-	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	svm->vmcb01.ptr->save.cr4    = svm->vcpu.arch.cr4;
-	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(&svm->vcpu);
-	svm->vmcb01.ptr->save.rip    = kvm_rip_read(&svm->vcpu);
+	svm->vmcb01.ptr->save.efer   = vcpu->arch.efer;
+	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(vcpu);
+	svm->vmcb01.ptr->save.cr4    = vcpu->arch.cr4;
+	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(vcpu);
+	svm->vmcb01.ptr->save.rip    = kvm_rip_read(vcpu);
 
 	if (!npt_enabled)
-		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(&svm->vcpu);
+		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(vcpu);
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(svm, vmcb12_gpa, vmcb12))
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12))
 		goto out_exit_err;
 
 	if (nested_svm_vmrun_msrpm(svm))
@@ -630,7 +630,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	nested_svm_vmexit(svm);
 
 out:
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
@@ -653,26 +653,27 @@ void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 
 int nested_svm_vmexit(struct vcpu_svm *svm)
 {
-	int rc;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb12;
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
+	int rc;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
+	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
+			kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
 	vmcb12 = map.hva;
 
 	/* Exit Guest-Mode */
-	leave_guest_mode(&svm->vcpu);
+	leave_guest_mode(vcpu);
 	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
-	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
 	/* in case we halted in L2 */
 	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -686,14 +687,14 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.gdtr   = vmcb->save.gdtr;
 	vmcb12->save.idtr   = vmcb->save.idtr;
 	vmcb12->save.efer   = svm->vcpu.arch.efer;
-	vmcb12->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	vmcb12->save.cr3    = kvm_read_cr3(&svm->vcpu);
+	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
+	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
 	vmcb12->save.cr2    = vmcb->save.cr2;
 	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
-	vmcb12->save.rflags = kvm_get_rflags(&svm->vcpu);
-	vmcb12->save.rip    = kvm_rip_read(&svm->vcpu);
-	vmcb12->save.rsp    = kvm_rsp_read(&svm->vcpu);
-	vmcb12->save.rax    = kvm_rax_read(&svm->vcpu);
+	vmcb12->save.rflags = kvm_get_rflags(vcpu);
+	vmcb12->save.rip    = kvm_rip_read(vcpu);
+	vmcb12->save.rsp    = kvm_rsp_read(vcpu);
+	vmcb12->save.rax    = kvm_rax_read(vcpu);
 	vmcb12->save.dr7    = vmcb->save.dr7;
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
 	vmcb12->save.cpl    = vmcb->save.cpl;
@@ -742,13 +743,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
-	kvm_set_rflags(&svm->vcpu, svm->vmcb->save.rflags);
-	svm_set_efer(&svm->vcpu, svm->vmcb->save.efer);
-	svm_set_cr0(&svm->vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
-	svm_set_cr4(&svm->vcpu, svm->vmcb->save.cr4);
-	kvm_rax_write(&svm->vcpu, svm->vmcb->save.rax);
-	kvm_rsp_write(&svm->vcpu, svm->vmcb->save.rsp);
-	kvm_rip_write(&svm->vcpu, svm->vmcb->save.rip);
+	kvm_set_rflags(vcpu, svm->vmcb->save.rflags);
+	svm_set_efer(vcpu, svm->vmcb->save.efer);
+	svm_set_cr0(vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(vcpu, svm->vmcb->save.cr4);
+	kvm_rax_write(vcpu, svm->vmcb->save.rax);
+	kvm_rsp_write(vcpu, svm->vmcb->save.rsp);
+	kvm_rip_write(vcpu, svm->vmcb->save.rip);
 
 	svm->vcpu.arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(&svm->vcpu);
@@ -760,11 +761,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
-	nested_svm_uninit_mmu_context(&svm->vcpu);
+	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(&svm->vcpu, svm->vmcb->save.cr3, false);
+	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false);
 	if (rc)
 		return 1;
 
@@ -773,8 +774,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * doesn't end up in L1.
 	 */
 	svm->vcpu.arch.nmi_injected = false;
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
 
 	return 0;
 }
@@ -824,17 +825,19 @@ void svm_free_nested(struct vcpu_svm *svm)
  */
 void svm_leave_nested(struct vcpu_svm *svm)
 {
-	if (is_guest_mode(&svm->vcpu)) {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	if (is_guest_mode(vcpu)) {
 		svm->nested.nested_run_pending = 0;
-		leave_guest_mode(&svm->vcpu);
+		leave_guest_mode(vcpu);
 
 		svm_switch_vmcb(svm, &svm->nested.vmcb02);
 
-		nested_svm_uninit_mmu_context(&svm->vcpu);
+		nested_svm_uninit_mmu_context(vcpu);
 		vmcb_mark_all_dirty(svm->vmcb);
 	}
 
-	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 }
 
 static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
@@ -943,16 +946,15 @@ int nested_svm_exit_handled(struct vcpu_svm *svm)
 	return vmexit;
 }
 
-int nested_svm_check_permissions(struct vcpu_svm *svm)
+int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
 {
-	if (!(svm->vcpu.arch.efer & EFER_SVME) ||
-	    !is_paging(&svm->vcpu)) {
-		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	if (!(vcpu->arch.efer & EFER_SVME) || !is_paging(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	if (svm->vmcb->save.cpl) {
-		kvm_inject_gp(&svm->vcpu, 0);
+	if (to_svm(vcpu)->vmcb->save.cpl) {
+		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
@@ -1263,7 +1265,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_valid_sregs(svm, save))
+	    !nested_vmcb_valid_sregs(vcpu, save))
 		goto out_free;
 
 	/*
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 874ea309279f..83e00e524513 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1849,7 +1849,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		vcpu->arch.regs[VCPU_REGS_RAX] = cpuid_fn;
 		vcpu->arch.regs[VCPU_REGS_RCX] = 0;
 
-		ret = svm_invoke_exit_handler(svm, SVM_EXIT_CPUID);
+		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_CPUID);
 		if (!ret) {
 			ret = -EINVAL;
 			break;
@@ -1899,8 +1899,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	return ret;
 }
 
-int sev_handle_vmgexit(struct vcpu_svm *svm)
+int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_gpa, exit_code;
 	struct ghcb *ghcb;
@@ -1912,13 +1913,13 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 		return sev_handle_vmgexit_msr_protocol(svm);
 
 	if (!ghcb_gpa) {
-		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB gpa is not set\n");
+		vcpu_unimpl(vcpu, "vmgexit: GHCB gpa is not set\n");
 		return -EINVAL;
 	}
 
-	if (kvm_vcpu_map(&svm->vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
+	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
 		/* Unable to map GHCB from guest */
-		vcpu_unimpl(&svm->vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
+		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
 			    ghcb_gpa);
 		return -EINVAL;
 	}
@@ -1926,7 +1927,7 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	svm->ghcb = svm->ghcb_map.hva;
 	ghcb = svm->ghcb_map.hva;
 
-	trace_kvm_vmgexit_enter(svm->vcpu.vcpu_id, ghcb);
+	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
@@ -1944,7 +1945,7 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
 			break;
 
-		ret = kvm_sev_es_mmio_read(&svm->vcpu,
+		ret = kvm_sev_es_mmio_read(vcpu,
 					   control->exit_info_1,
 					   control->exit_info_2,
 					   svm->ghcb_sa);
@@ -1953,19 +1954,19 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
 			break;
 
-		ret = kvm_sev_es_mmio_write(&svm->vcpu,
+		ret = kvm_sev_es_mmio_write(vcpu,
 					    control->exit_info_1,
 					    control->exit_info_2,
 					    svm->ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
-		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
+		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
-		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
-		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 
 		switch (control->exit_info_1) {
 		case 0:
@@ -1990,12 +1991,12 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 		break;
 	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
-		vcpu_unimpl(&svm->vcpu,
+		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 			    control->exit_info_1, control->exit_info_2);
 		break;
 	default:
-		ret = svm_invoke_exit_handler(svm, exit_code);
+		ret = svm_invoke_exit_handler(vcpu, exit_code);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 968d1a1f2927..c2626babe575 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -283,7 +283,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			 * In this case we will return to the nested guest
 			 * as soon as we leave SMM.
 			 */
-			if (!is_smm(&svm->vcpu))
+			if (!is_smm(vcpu))
 				svm_free_nested(svm);
 
 		} else {
@@ -367,10 +367,10 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 	bool has_error_code = vcpu->arch.exception.has_error_code;
 	u32 error_code = vcpu->arch.exception.error_code;
 
-	kvm_deliver_exception_payload(&svm->vcpu);
+	kvm_deliver_exception_payload(vcpu);
 
 	if (nr == BP_VECTOR && !nrips) {
-		unsigned long rip, old_rip = kvm_rip_read(&svm->vcpu);
+		unsigned long rip, old_rip = kvm_rip_read(vcpu);
 
 		/*
 		 * For guest debugging where we have to reinject #BP if some
@@ -379,8 +379,8 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 * raises a fault that is not intercepted. Still better than
 		 * failing in all cases.
 		 */
-		(void)skip_emulated_instruction(&svm->vcpu);
-		rip = kvm_rip_read(&svm->vcpu);
+		(void)skip_emulated_instruction(vcpu);
+		rip = kvm_rip_read(vcpu);
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
 	}
@@ -1112,12 +1112,13 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 	}
 }
 
-static void init_vmcb(struct vcpu_svm *svm)
+static void init_vmcb(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
-	svm->vcpu.arch.hflags = 0;
+	vcpu->arch.hflags = 0;
 
 	svm_set_intercept(svm, INTERCEPT_CR0_READ);
 	svm_set_intercept(svm, INTERCEPT_CR3_READ);
@@ -1125,7 +1126,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
 	svm_set_intercept(svm, INTERCEPT_CR3_WRITE);
 	svm_set_intercept(svm, INTERCEPT_CR4_WRITE);
-	if (!kvm_vcpu_apicv_active(&svm->vcpu))
+	if (!kvm_vcpu_apicv_active(vcpu))
 		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	set_dr_intercepts(svm);
@@ -1169,12 +1170,12 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, INTERCEPT_RDPRU);
 	svm_set_intercept(svm, INTERCEPT_RSM);
 
-	if (!kvm_mwait_in_guest(svm->vcpu.kvm)) {
+	if (!kvm_mwait_in_guest(vcpu->kvm)) {
 		svm_set_intercept(svm, INTERCEPT_MONITOR);
 		svm_set_intercept(svm, INTERCEPT_MWAIT);
 	}
 
-	if (!kvm_hlt_in_guest(svm->vcpu.kvm))
+	if (!kvm_hlt_in_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_HLT);
 
 	control->iopm_base_pa = __sme_set(iopm_base);
@@ -1200,18 +1201,18 @@ static void init_vmcb(struct vcpu_svm *svm)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
-	svm_set_efer(&svm->vcpu, 0);
+	svm_set_efer(vcpu, 0);
 	save->dr6 = 0xffff0ff0;
-	kvm_set_rflags(&svm->vcpu, X86_EFLAGS_FIXED);
+	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	save->rip = 0x0000fff0;
-	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
+	vcpu->arch.regs[VCPU_REGS_RIP] = save->rip;
 
 	/*
 	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
 	 * It also updates the guest-visible cr0 value.
 	 */
-	svm_set_cr0(&svm->vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
-	kvm_mmu_reset_context(&svm->vcpu);
+	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
+	kvm_mmu_reset_context(vcpu);
 
 	save->cr4 = X86_CR4_PAE;
 	/* rdx = ?? */
@@ -1223,7 +1224,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		clr_exception_intercept(svm, PF_VECTOR);
 		svm_clr_intercept(svm, INTERCEPT_CR3_READ);
 		svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
-		save->g_pat = svm->vcpu.arch.pat;
+		save->g_pat = vcpu->arch.pat;
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
@@ -1231,9 +1232,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = 0;
-	svm->vcpu.arch.hflags = 0;
+	vcpu->arch.hflags = 0;
 
-	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
+	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -1244,7 +1245,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm_check_invpcid(svm);
 
-	if (kvm_vcpu_apicv_active(&svm->vcpu))
+	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm);
 
 	/*
@@ -1263,11 +1264,11 @@ static void init_vmcb(struct vcpu_svm *svm)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
-	if (sev_guest(svm->vcpu.kvm)) {
+	if (sev_guest(vcpu->kvm)) {
 		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
 		clr_exception_intercept(svm, UD_VECTOR);
 
-		if (sev_es_guest(svm->vcpu.kvm)) {
+		if (sev_es_guest(vcpu->kvm)) {
 			/* Perform SEV-ES specific VMCB updates */
 			sev_es_init_vmcb(svm);
 		}
@@ -1289,12 +1290,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->virt_spec_ctrl = 0;
 
 	if (!init_event) {
-		svm->vcpu.arch.apic_base = APIC_DEFAULT_PHYS_BASE |
-					   MSR_IA32_APICBASE_ENABLE;
-		if (kvm_vcpu_is_reset_bsp(&svm->vcpu))
-			svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
+		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
+				       MSR_IA32_APICBASE_ENABLE;
+		if (kvm_vcpu_is_reset_bsp(vcpu))
+			vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
 	}
-	init_vmcb(svm);
+	init_vmcb(vcpu);
 
 	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, false);
 	kvm_rdx_write(vcpu, eax);
@@ -1333,7 +1334,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!vmcb01_page)
 		goto out;
 
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	if (sev_es_guest(vcpu->kvm)) {
 		/*
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
@@ -1378,12 +1379,12 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->guest_state_loaded = false;
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
-	init_vmcb(svm);
+	init_vmcb(vcpu);
 
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
-	if (sev_es_guest(svm->vcpu.kvm))
+	if (sev_es_guest(vcpu->kvm))
 		/* Perform SEV-ES specific VMCB creation updates */
 		sev_es_create_vcpu(svm);
 
@@ -1446,7 +1447,7 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
 	 */
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	if (sev_es_guest(vcpu->kvm)) {
 		sev_es_prepare_guest_switch(svm, vcpu->cpu);
 	} else {
 		vmsave(__sme_page_pa(sd->save_area));
@@ -1756,7 +1757,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	 * SEV-ES guests must always keep the CR intercepts cleared. CR
 	 * tracking is done using the CR write traps.
 	 */
-	if (sev_es_guest(svm->vcpu.kvm))
+	if (sev_es_guest(vcpu->kvm))
 		return;
 
 	if (hcr0 == cr0) {
@@ -1767,7 +1768,6 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		svm_set_intercept(svm, INTERCEPT_CR0_READ);
 		svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
 	}
-
 }
 
 static bool svm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1895,39 +1895,43 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
 
-static int pf_interception(struct vcpu_svm *svm)
+static int pf_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
-	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,
+	return kvm_handle_page_fault(vcpu, error_code, fault_address,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
 			svm->vmcb->control.insn_len);
 }
 
-static int npf_interception(struct vcpu_svm *svm)
+static int npf_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(fault_address, error_code);
-	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code,
+	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
 			svm->vmcb->control.insn_len);
 }
 
-static int db_interception(struct vcpu_svm *svm)
+static int db_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = svm->vcpu.run;
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_run *kvm_run = vcpu->run;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!(svm->vcpu.guest_debug &
+	if (!(vcpu->guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
 		u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;
-		kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
+		kvm_queue_exception_p(vcpu, DB_VECTOR, payload);
 		return 1;
 	}
 
@@ -1937,7 +1941,7 @@ static int db_interception(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
 
-	if (svm->vcpu.guest_debug &
+	if (vcpu->guest_debug &
 	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.dr6 = svm->vmcb->save.dr6;
@@ -1951,9 +1955,10 @@ static int db_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int bp_interception(struct vcpu_svm *svm)
+static int bp_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = svm->vcpu.run;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_run *kvm_run = vcpu->run;
 
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
 	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
@@ -1961,14 +1966,14 @@ static int bp_interception(struct vcpu_svm *svm)
 	return 0;
 }
 
-static int ud_interception(struct vcpu_svm *svm)
+static int ud_interception(struct kvm_vcpu *vcpu)
 {
-	return handle_ud(&svm->vcpu);
+	return handle_ud(vcpu);
 }
 
-static int ac_interception(struct vcpu_svm *svm)
+static int ac_interception(struct kvm_vcpu *vcpu)
 {
-	kvm_queue_exception_e(&svm->vcpu, AC_VECTOR, 0);
+	kvm_queue_exception_e(vcpu, AC_VECTOR, 0);
 	return 1;
 }
 
@@ -2011,7 +2016,7 @@ static bool is_erratum_383(void)
 	return true;
 }
 
-static void svm_handle_mce(struct vcpu_svm *svm)
+static void svm_handle_mce(struct kvm_vcpu *vcpu)
 {
 	if (is_erratum_383()) {
 		/*
@@ -2020,7 +2025,7 @@ static void svm_handle_mce(struct vcpu_svm *svm)
 		 */
 		pr_err("KVM: Guest triggered AMD Erratum 383\n");
 
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, &svm->vcpu);
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 		return;
 	}
@@ -2032,20 +2037,21 @@ static void svm_handle_mce(struct vcpu_svm *svm)
 	kvm_machine_check();
 }
 
-static int mc_interception(struct vcpu_svm *svm)
+static int mc_interception(struct kvm_vcpu *vcpu)
 {
 	return 1;
 }
 
-static int shutdown_interception(struct vcpu_svm *svm)
+static int shutdown_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = svm->vcpu.run;
+	struct kvm_run *kvm_run = vcpu->run;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
 	 * The VM save area has already been encrypted so it
 	 * cannot be reinitialized - just terminate.
 	 */
-	if (sev_es_guest(svm->vcpu.kvm))
+	if (sev_es_guest(vcpu->kvm))
 		return -EINVAL;
 
 	/*
@@ -2053,20 +2059,20 @@ static int shutdown_interception(struct vcpu_svm *svm)
 	 * so reinitialize it.
 	 */
 	clear_page(svm->vmcb);
-	init_vmcb(svm);
+	init_vmcb(vcpu);
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
 	return 0;
 }
 
-static int io_interception(struct vcpu_svm *svm)
+static int io_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 io_info = svm->vmcb->control.exit_info_1; /* address size bug? */
 	int size, in, string;
 	unsigned port;
 
-	++svm->vcpu.stat.io_exits;
+	++vcpu->stat.io_exits;
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	port = io_info >> 16;
@@ -2081,93 +2087,95 @@ static int io_interception(struct vcpu_svm *svm)
 
 	svm->next_rip = svm->vmcb->control.exit_info_2;
 
-	return kvm_fast_pio(&svm->vcpu, size, port, in);
+	return kvm_fast_pio(vcpu, size, port, in);
 }
 
-static int nmi_interception(struct vcpu_svm *svm)
+static int nmi_interception(struct kvm_vcpu *vcpu)
 {
 	return 1;
 }
 
-static int intr_interception(struct vcpu_svm *svm)
+static int intr_interception(struct kvm_vcpu *vcpu)
 {
-	++svm->vcpu.stat.irq_exits;
+	++vcpu->stat.irq_exits;
 	return 1;
 }
 
-static int nop_on_interception(struct vcpu_svm *svm)
+static int nop_on_interception(struct kvm_vcpu *vcpu)
 {
 	return 1;
 }
 
-static int halt_interception(struct vcpu_svm *svm)
+static int halt_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_halt(&svm->vcpu);
+	return kvm_emulate_halt(vcpu);
 }
 
-static int vmmcall_interception(struct vcpu_svm *svm)
+static int vmmcall_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_hypercall(&svm->vcpu);
+	return kvm_emulate_hypercall(vcpu);
 }
 
-static int vmload_interception(struct vcpu_svm *svm)
+static int vmload_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb12;
 	struct kvm_host_map map;
 	int ret;
 
-	if (nested_svm_check_permissions(svm))
+	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
 	if (ret) {
 		if (ret == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
+			kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
 	vmcb12 = map.hva;
 
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+	ret = kvm_skip_emulated_instruction(vcpu);
 
 	nested_svm_vmloadsave(vmcb12, svm->vmcb);
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
 
-static int vmsave_interception(struct vcpu_svm *svm)
+static int vmsave_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb12;
 	struct kvm_host_map map;
 	int ret;
 
-	if (nested_svm_check_permissions(svm))
+	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
 	if (ret) {
 		if (ret == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
+			kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
 	vmcb12 = map.hva;
 
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+	ret = kvm_skip_emulated_instruction(vcpu);
 
 	nested_svm_vmloadsave(svm->vmcb, vmcb12);
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
 
-static int vmrun_interception(struct vcpu_svm *svm)
+static int vmrun_interception(struct kvm_vcpu *vcpu)
 {
-	if (nested_svm_check_permissions(svm))
+	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	return nested_svm_vmrun(svm);
+	return nested_svm_vmrun(vcpu);
 }
 
 enum {
@@ -2206,7 +2214,7 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 		[SVM_INSTR_VMLOAD] = SVM_EXIT_VMLOAD,
 		[SVM_INSTR_VMSAVE] = SVM_EXIT_VMSAVE,
 	};
-	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
+	int (*const svm_instr_handlers[])(struct kvm_vcpu *vcpu) = {
 		[SVM_INSTR_VMRUN] = vmrun_interception,
 		[SVM_INSTR_VMLOAD] = vmload_interception,
 		[SVM_INSTR_VMSAVE] = vmsave_interception,
@@ -2225,7 +2233,7 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 			return ret;
 		return 1;
 	}
-	return svm_instr_handlers[opcode](svm);
+	return svm_instr_handlers[opcode](vcpu);
 }
 
 /*
@@ -2236,9 +2244,9 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
  *      regions (e.g. SMM memory on host).
  *   2) VMware backdoor
  */
-static int gp_interception(struct vcpu_svm *svm)
+static int gp_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 error_code = svm->vmcb->control.exit_info_1;
 	int opcode;
 
@@ -2303,73 +2311,72 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 	}
 }
 
-static int stgi_interception(struct vcpu_svm *svm)
+static int stgi_interception(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	if (nested_svm_check_permissions(svm))
+	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
-	svm_set_gif(svm, true);
+	ret = kvm_skip_emulated_instruction(vcpu);
+	svm_set_gif(to_svm(vcpu), true);
 	return ret;
 }
 
-static int clgi_interception(struct vcpu_svm *svm)
+static int clgi_interception(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	if (nested_svm_check_permissions(svm))
+	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
-	svm_set_gif(svm, false);
+	ret = kvm_skip_emulated_instruction(vcpu);
+	svm_set_gif(to_svm(vcpu), false);
 	return ret;
 }
 
-static int invlpga_interception(struct vcpu_svm *svm)
+static int invlpga_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-
-	trace_kvm_invlpga(svm->vmcb->save.rip, kvm_rcx_read(&svm->vcpu),
-			  kvm_rax_read(&svm->vcpu));
+	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, kvm_rcx_read(vcpu),
+			  kvm_rax_read(vcpu));
 
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
-	kvm_mmu_invlpg(vcpu, kvm_rax_read(&svm->vcpu));
+	kvm_mmu_invlpg(vcpu, kvm_rax_read(vcpu));
 
-	return kvm_skip_emulated_instruction(&svm->vcpu);
+	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static int skinit_interception(struct vcpu_svm *svm)
+static int skinit_interception(struct kvm_vcpu *vcpu)
 {
-	trace_kvm_skinit(svm->vmcb->save.rip, kvm_rax_read(&svm->vcpu));
+	trace_kvm_skinit(to_svm(vcpu)->vmcb->save.rip, kvm_rax_read(vcpu));
 
-	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	kvm_queue_exception(vcpu, UD_VECTOR);
 	return 1;
 }
 
-static int wbinvd_interception(struct vcpu_svm *svm)
+static int wbinvd_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_wbinvd(&svm->vcpu);
+	return kvm_emulate_wbinvd(vcpu);
 }
 
-static int xsetbv_interception(struct vcpu_svm *svm)
+static int xsetbv_interception(struct kvm_vcpu *vcpu)
 {
-	u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
-	u32 index = kvm_rcx_read(&svm->vcpu);
+	u64 new_bv = kvm_read_edx_eax(vcpu);
+	u32 index = kvm_rcx_read(vcpu);
 
-	int err = kvm_set_xcr(&svm->vcpu, index, new_bv);
-	return kvm_complete_insn_gp(&svm->vcpu, err);
+	int err = kvm_set_xcr(vcpu, index, new_bv);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static int rdpru_interception(struct vcpu_svm *svm)
+static int rdpru_interception(struct kvm_vcpu *vcpu)
 {
-	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	kvm_queue_exception(vcpu, UD_VECTOR);
 	return 1;
 }
 
-static int task_switch_interception(struct vcpu_svm *svm)
+static int task_switch_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u16 tss_selector;
 	int reason;
 	int int_type = svm->vmcb->control.exit_int_info &
@@ -2398,7 +2405,7 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	if (reason == TASK_SWITCH_GATE) {
 		switch (type) {
 		case SVM_EXITINTINFO_TYPE_NMI:
-			svm->vcpu.arch.nmi_injected = false;
+			vcpu->arch.nmi_injected = false;
 			break;
 		case SVM_EXITINTINFO_TYPE_EXEPT:
 			if (svm->vmcb->control.exit_info_2 &
@@ -2407,10 +2414,10 @@ static int task_switch_interception(struct vcpu_svm *svm)
 				error_code =
 					(u32)svm->vmcb->control.exit_info_2;
 			}
-			kvm_clear_exception_queue(&svm->vcpu);
+			kvm_clear_exception_queue(vcpu);
 			break;
 		case SVM_EXITINTINFO_TYPE_INTR:
-			kvm_clear_interrupt_queue(&svm->vcpu);
+			kvm_clear_interrupt_queue(vcpu);
 			break;
 		default:
 			break;
@@ -2421,77 +2428,80 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (!skip_emulated_instruction(&svm->vcpu))
+		if (!skip_emulated_instruction(vcpu))
 			return 0;
 	}
 
 	if (int_type != SVM_EXITINTINFO_TYPE_SOFT)
 		int_vec = -1;
 
-	return kvm_task_switch(&svm->vcpu, tss_selector, int_vec, reason,
+	return kvm_task_switch(vcpu, tss_selector, int_vec, reason,
 			       has_error_code, error_code);
 }
 
-static int cpuid_interception(struct vcpu_svm *svm)
+static int cpuid_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_cpuid(&svm->vcpu);
+	return kvm_emulate_cpuid(vcpu);
 }
 
-static int iret_interception(struct vcpu_svm *svm)
+static int iret_interception(struct kvm_vcpu *vcpu)
 {
-	++svm->vcpu.stat.nmi_window_exits;
-	svm->vcpu.arch.hflags |= HF_IRET_MASK;
-	if (!sev_es_guest(svm->vcpu.kvm)) {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	++vcpu->stat.nmi_window_exits;
+	vcpu->arch.hflags |= HF_IRET_MASK;
+	if (!sev_es_guest(vcpu->kvm)) {
 		svm_clr_intercept(svm, INTERCEPT_IRET);
-		svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
+		svm->nmi_iret_rip = kvm_rip_read(vcpu);
 	}
-	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	return 1;
 }
 
-static int invd_interception(struct vcpu_svm *svm)
+static int invd_interception(struct kvm_vcpu *vcpu)
 {
 	/* Treat an INVD instruction as a NOP and just skip it. */
-	return kvm_skip_emulated_instruction(&svm->vcpu);
+	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static int invlpg_interception(struct vcpu_svm *svm)
+static int invlpg_interception(struct kvm_vcpu *vcpu)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return kvm_emulate_instruction(&svm->vcpu, 0);
+		return kvm_emulate_instruction(vcpu, 0);
 
-	kvm_mmu_invlpg(&svm->vcpu, svm->vmcb->control.exit_info_1);
-	return kvm_skip_emulated_instruction(&svm->vcpu);
+	kvm_mmu_invlpg(vcpu, to_svm(vcpu)->vmcb->control.exit_info_1);
+	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static int emulate_on_interception(struct vcpu_svm *svm)
+static int emulate_on_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_instruction(&svm->vcpu, 0);
+	return kvm_emulate_instruction(vcpu, 0);
 }
 
-static int rsm_interception(struct vcpu_svm *svm)
+static int rsm_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_instruction_from_buffer(&svm->vcpu, rsm_ins_bytes, 2);
+	return kvm_emulate_instruction_from_buffer(vcpu, rsm_ins_bytes, 2);
 }
 
-static int rdpmc_interception(struct vcpu_svm *svm)
+static int rdpmc_interception(struct kvm_vcpu *vcpu)
 {
 	int err;
 
 	if (!nrips)
-		return emulate_on_interception(svm);
+		return emulate_on_interception(vcpu);
 
-	err = kvm_rdpmc(&svm->vcpu);
-	return kvm_complete_insn_gp(&svm->vcpu, err);
+	err = kvm_rdpmc(vcpu);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
+static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
 					    unsigned long val)
 {
-	unsigned long cr0 = svm->vcpu.arch.cr0;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long cr0 = vcpu->arch.cr0;
 	bool ret = false;
 
-	if (!is_guest_mode(&svm->vcpu) ||
+	if (!is_guest_mode(vcpu) ||
 	    (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0))))
 		return false;
 
@@ -2508,17 +2518,18 @@ static bool check_selective_cr0_intercepted(struct vcpu_svm *svm,
 
 #define CR_VALID (1ULL << 63)
 
-static int cr_interception(struct vcpu_svm *svm)
+static int cr_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int reg, cr;
 	unsigned long val;
 	int err;
 
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return emulate_on_interception(svm);
+		return emulate_on_interception(vcpu);
 
 	if (unlikely((svm->vmcb->control.exit_info_1 & CR_VALID) == 0))
-		return emulate_on_interception(svm);
+		return emulate_on_interception(vcpu);
 
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	if (svm->vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE)
@@ -2529,61 +2540,61 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
-			if (!check_selective_cr0_intercepted(svm, val))
-				err = kvm_set_cr0(&svm->vcpu, val);
+			if (!check_selective_cr0_intercepted(vcpu, val))
+				err = kvm_set_cr0(vcpu, val);
 			else
 				return 1;
 
 			break;
 		case 3:
-			err = kvm_set_cr3(&svm->vcpu, val);
+			err = kvm_set_cr3(vcpu, val);
 			break;
 		case 4:
-			err = kvm_set_cr4(&svm->vcpu, val);
+			err = kvm_set_cr4(vcpu, val);
 			break;
 		case 8:
-			err = kvm_set_cr8(&svm->vcpu, val);
+			err = kvm_set_cr8(vcpu, val);
 			break;
 		default:
 			WARN(1, "unhandled write to CR%d", cr);
-			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+			kvm_queue_exception(vcpu, UD_VECTOR);
 			return 1;
 		}
 	} else { /* mov from cr */
 		switch (cr) {
 		case 0:
-			val = kvm_read_cr0(&svm->vcpu);
+			val = kvm_read_cr0(vcpu);
 			break;
 		case 2:
-			val = svm->vcpu.arch.cr2;
+			val = vcpu->arch.cr2;
 			break;
 		case 3:
-			val = kvm_read_cr3(&svm->vcpu);
+			val = kvm_read_cr3(vcpu);
 			break;
 		case 4:
-			val = kvm_read_cr4(&svm->vcpu);
+			val = kvm_read_cr4(vcpu);
 			break;
 		case 8:
-			val = kvm_get_cr8(&svm->vcpu);
+			val = kvm_get_cr8(vcpu);
 			break;
 		default:
 			WARN(1, "unhandled read from CR%d", cr);
-			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+			kvm_queue_exception(vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_write(vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
-	return kvm_complete_insn_gp(&svm->vcpu, err);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static int cr_trap(struct vcpu_svm *svm)
+static int cr_trap(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long old_value, new_value;
 	unsigned int cr;
 	int ret = 0;
@@ -2605,7 +2616,7 @@ static int cr_trap(struct vcpu_svm *svm)
 		kvm_post_set_cr4(vcpu, old_value, new_value);
 		break;
 	case 8:
-		ret = kvm_set_cr8(&svm->vcpu, new_value);
+		ret = kvm_set_cr8(vcpu, new_value);
 		break;
 	default:
 		WARN(1, "unhandled CR%d write trap", cr);
@@ -2616,57 +2627,57 @@ static int cr_trap(struct vcpu_svm *svm)
 	return kvm_complete_insn_gp(vcpu, ret);
 }
 
-static int dr_interception(struct vcpu_svm *svm)
+static int dr_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	int reg, dr;
 	unsigned long val;
 	int err = 0;
 
-	if (svm->vcpu.guest_debug == 0) {
+	if (vcpu->guest_debug == 0) {
 		/*
 		 * No more DR vmexits; force a reload of the debug registers
 		 * and reenter on this instruction.  The next vmexit will
 		 * retrieve the full state of the debug registers.
 		 */
 		clr_dr_intercepts(svm);
-		svm->vcpu.arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
+		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
 		return 1;
 	}
 
 	if (!boot_cpu_has(X86_FEATURE_DECODEASSISTS))
-		return emulate_on_interception(svm);
+		return emulate_on_interception(vcpu);
 
 	reg = svm->vmcb->control.exit_info_1 & SVM_EXITINFO_REG_MASK;
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
-		err = kvm_set_dr(&svm->vcpu, dr, val);
+		val = kvm_register_read(vcpu, reg);
+		err = kvm_set_dr(vcpu, dr, val);
 	} else {
-		kvm_get_dr(&svm->vcpu, dr, &val);
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_get_dr(vcpu, dr, &val);
+		kvm_register_write(vcpu, reg, val);
 	}
 
-	return kvm_complete_insn_gp(&svm->vcpu, err);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
-static int cr8_write_interception(struct vcpu_svm *svm)
+static int cr8_write_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *kvm_run = svm->vcpu.run;
 	int r;
 
-	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
+	u8 cr8_prev = kvm_get_cr8(vcpu);
 	/* instruction emulation calls kvm_set_cr8() */
-	r = cr_interception(svm);
-	if (lapic_in_kernel(&svm->vcpu))
+	r = cr_interception(vcpu);
+	if (lapic_in_kernel(vcpu))
 		return r;
-	if (cr8_prev <= kvm_get_cr8(&svm->vcpu))
+	if (cr8_prev <= kvm_get_cr8(vcpu))
 		return r;
-	kvm_run->exit_reason = KVM_EXIT_SET_TPR;
+	vcpu->run->exit_reason = KVM_EXIT_SET_TPR;
 	return 0;
 }
 
-static int efer_trap(struct vcpu_svm *svm)
+static int efer_trap(struct kvm_vcpu *vcpu)
 {
 	struct msr_data msr_info;
 	int ret;
@@ -2679,10 +2690,10 @@ static int efer_trap(struct vcpu_svm *svm)
 	 */
 	msr_info.host_initiated = false;
 	msr_info.index = MSR_EFER;
-	msr_info.data = svm->vmcb->control.exit_info_1 & ~EFER_SVME;
-	ret = kvm_set_msr_common(&svm->vcpu, &msr_info);
+	msr_info.data = to_svm(vcpu)->vmcb->control.exit_info_1 & ~EFER_SVME;
+	ret = kvm_set_msr_common(vcpu, &msr_info);
 
-	return kvm_complete_insn_gp(&svm->vcpu, ret);
+	return kvm_complete_insn_gp(vcpu, ret);
 }
 
 static int svm_get_msr_feature(struct kvm_msr_entry *msr)
@@ -2808,8 +2819,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!sev_es_guest(svm->vcpu.kvm) || !err)
-		return kvm_complete_insn_gp(&svm->vcpu, err);
+	if (!sev_es_guest(vcpu->kvm) || !err)
+		return kvm_complete_insn_gp(vcpu, err);
 
 	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
 	ghcb_set_sw_exit_info_2(svm->ghcb,
@@ -2819,9 +2830,9 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	return 1;
 }
 
-static int rdmsr_interception(struct vcpu_svm *svm)
+static int rdmsr_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_rdmsr(&svm->vcpu);
+	return kvm_emulate_rdmsr(vcpu);
 }
 
 static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
@@ -3007,38 +3018,37 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return 0;
 }
 
-static int wrmsr_interception(struct vcpu_svm *svm)
+static int wrmsr_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_emulate_wrmsr(&svm->vcpu);
+	return kvm_emulate_wrmsr(vcpu);
 }
 
-static int msr_interception(struct vcpu_svm *svm)
+static int msr_interception(struct kvm_vcpu *vcpu)
 {
-	if (svm->vmcb->control.exit_info_1)
-		return wrmsr_interception(svm);
+	if (to_svm(vcpu)->vmcb->control.exit_info_1)
+		return wrmsr_interception(vcpu);
 	else
-		return rdmsr_interception(svm);
+		return rdmsr_interception(vcpu);
 }
 
-static int interrupt_window_interception(struct vcpu_svm *svm)
+static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 {
-	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
-	svm_clear_vintr(svm);
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+	svm_clear_vintr(to_svm(vcpu));
 
 	/*
 	 * For AVIC, the only reason to end up here is ExtINTs.
 	 * In this case AVIC was temporarily disabled for
 	 * requesting the IRQ window and we have to re-enable it.
 	 */
-	svm_toggle_avic_for_irq_window(&svm->vcpu, true);
+	svm_toggle_avic_for_irq_window(vcpu, true);
 
-	++svm->vcpu.stat.irq_window_exits;
+	++vcpu->stat.irq_window_exits;
 	return 1;
 }
 
-static int pause_interception(struct vcpu_svm *svm)
+static int pause_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool in_kernel;
 
 	/*
@@ -3046,7 +3056,7 @@ static int pause_interception(struct vcpu_svm *svm)
 	 * vcpu->arch.preempted_in_kernel can never be true.  Just
 	 * set in_kernel to false as well.
 	 */
-	in_kernel = !sev_es_guest(svm->vcpu.kvm) && svm_get_cpl(vcpu) == 0;
+	in_kernel = !sev_es_guest(vcpu->kvm) && svm_get_cpl(vcpu) == 0;
 
 	if (!kvm_pause_in_guest(vcpu->kvm))
 		grow_ple_window(vcpu);
@@ -3055,26 +3065,26 @@ static int pause_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int nop_interception(struct vcpu_svm *svm)
+static int nop_interception(struct kvm_vcpu *vcpu)
 {
-	return kvm_skip_emulated_instruction(&(svm->vcpu));
+	return kvm_skip_emulated_instruction(vcpu);
 }
 
-static int monitor_interception(struct vcpu_svm *svm)
+static int monitor_interception(struct kvm_vcpu *vcpu)
 {
 	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
-	return nop_interception(svm);
+	return nop_interception(vcpu);
 }
 
-static int mwait_interception(struct vcpu_svm *svm)
+static int mwait_interception(struct kvm_vcpu *vcpu)
 {
 	printk_once(KERN_WARNING "kvm: MWAIT instruction emulated as NOP!\n");
-	return nop_interception(svm);
+	return nop_interception(vcpu);
 }
 
-static int invpcid_interception(struct vcpu_svm *svm)
+static int invpcid_interception(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long type;
 	gva_t gva;
 
@@ -3099,7 +3109,7 @@ static int invpcid_interception(struct vcpu_svm *svm)
 	return kvm_handle_invpcid(vcpu, type, gva);
 }
 
-static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
+static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
 	[SVM_EXIT_READ_CR4]			= cr_interception,
@@ -3310,24 +3320,24 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 	return -EINVAL;
 }
 
-int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-	if (svm_handle_invalid_exit(&svm->vcpu, exit_code))
+	if (svm_handle_invalid_exit(vcpu, exit_code))
 		return 0;
 
 #ifdef CONFIG_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
-		return msr_interception(svm);
+		return msr_interception(vcpu);
 	else if (exit_code == SVM_EXIT_VINTR)
-		return interrupt_window_interception(svm);
+		return interrupt_window_interception(vcpu);
 	else if (exit_code == SVM_EXIT_INTR)
-		return intr_interception(svm);
+		return intr_interception(vcpu);
 	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(svm);
+		return halt_interception(vcpu);
 	else if (exit_code == SVM_EXIT_NPF)
-		return npf_interception(svm);
+		return npf_interception(vcpu);
 #endif
-	return svm_exit_handlers[exit_code](svm);
+	return svm_exit_handlers[exit_code](vcpu);
 }
 
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
@@ -3396,7 +3406,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	return svm_invoke_exit_handler(svm, exit_code);
+	return svm_invoke_exit_handler(vcpu, exit_code);
 }
 
 static void reload_tss(struct kvm_vcpu *vcpu)
@@ -3407,9 +3417,10 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 	load_TR_desc();
 }
 
-static void pre_svm_run(struct vcpu_svm *svm)
+static void pre_svm_run(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, svm->vcpu.cpu);
+	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
 	 * If the previous vmrun of the vmcb occurred on
@@ -3417,14 +3428,14 @@ static void pre_svm_run(struct vcpu_svm *svm)
 	 * and assign a new asid.
 	*/
 
-        if (unlikely(svm->current_vmcb->cpu != svm->vcpu.cpu)) {
+	if (unlikely(svm->current_vmcb->cpu != vcpu->cpu)) {
 		svm->current_vmcb->asid_generation = 0;
 		vmcb_mark_all_dirty(svm->vmcb);
-		svm->current_vmcb->cpu = svm->vcpu.cpu;
+		svm->current_vmcb->cpu = vcpu->cpu;
         }
 
-	if (sev_guest(svm->vcpu.kvm))
-		return pre_sev_run(svm, svm->vcpu.cpu);
+	if (sev_guest(vcpu->kvm))
+		return pre_sev_run(svm, vcpu->cpu);
 
 	/* FIXME: handle wraparound of asid_generation */
 	if (svm->current_vmcb->asid_generation != sd->asid_generation)
@@ -3437,7 +3448,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	if (!sev_es_guest(svm->vcpu.kvm))
+	if (!sev_es_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
@@ -3491,7 +3502,7 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 		return false;
 
 	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
-	      (svm->vcpu.arch.hflags & HF_NMI_MASK);
+	      (vcpu->arch.hflags & HF_NMI_MASK);
 
 	return ret;
 }
@@ -3511,9 +3522,7 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	return !!(svm->vcpu.arch.hflags & HF_NMI_MASK);
+	return !!(vcpu->arch.hflags & HF_NMI_MASK);
 }
 
 static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
@@ -3521,12 +3530,12 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (masked) {
-		svm->vcpu.arch.hflags |= HF_NMI_MASK;
-		if (!sev_es_guest(svm->vcpu.kvm))
+		vcpu->arch.hflags |= HF_NMI_MASK;
+		if (!sev_es_guest(vcpu->kvm))
 			svm_set_intercept(svm, INTERCEPT_IRET);
 	} else {
-		svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
-		if (!sev_es_guest(svm->vcpu.kvm))
+		vcpu->arch.hflags &= ~HF_NMI_MASK;
+		if (!sev_es_guest(vcpu->kvm))
 			svm_clr_intercept(svm, INTERCEPT_IRET);
 	}
 }
@@ -3539,7 +3548,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	if (sev_es_guest(vcpu->kvm)) {
 		/*
 		 * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
 		 * bit to determine the state of the IF flag.
@@ -3608,8 +3617,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if ((svm->vcpu.arch.hflags & (HF_NMI_MASK | HF_IRET_MASK))
-	    == HF_NMI_MASK)
+	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
 	if (!gif_set(svm)) {
@@ -3688,8 +3696,9 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
 }
 
-static void svm_complete_interrupts(struct vcpu_svm *svm)
+static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 vector;
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
@@ -3701,28 +3710,28 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	 * If we've made progress since setting HF_IRET_MASK, we've
 	 * executed an IRET and can allow NMI injection.
 	 */
-	if ((svm->vcpu.arch.hflags & HF_IRET_MASK) &&
-	    (sev_es_guest(svm->vcpu.kvm) ||
-	     kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip)) {
-		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
-		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	if ((vcpu->arch.hflags & HF_IRET_MASK) &&
+	    (sev_es_guest(vcpu->kvm) ||
+	     kvm_rip_read(vcpu) != svm->nmi_iret_rip)) {
+		vcpu->arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
 
-	svm->vcpu.arch.nmi_injected = false;
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
+	vcpu->arch.nmi_injected = false;
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
 
 	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
 		return;
 
-	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
 	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
 
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
-		svm->vcpu.arch.nmi_injected = true;
+		vcpu->arch.nmi_injected = true;
 		break;
 	case SVM_EXITINTINFO_TYPE_EXEPT:
 		/*
@@ -3738,21 +3747,20 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 		 */
 		if (kvm_exception_is_soft(vector)) {
 			if (vector == BP_VECTOR && int3_injected &&
-			    kvm_is_linear_rip(&svm->vcpu, svm->int3_rip))
-				kvm_rip_write(&svm->vcpu,
-					      kvm_rip_read(&svm->vcpu) -
-					      int3_injected);
+			    kvm_is_linear_rip(vcpu, svm->int3_rip))
+				kvm_rip_write(vcpu,
+					      kvm_rip_read(vcpu) - int3_injected);
 			break;
 		}
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
-			kvm_requeue_exception_e(&svm->vcpu, vector, err);
+			kvm_requeue_exception_e(vcpu, vector, err);
 
 		} else
-			kvm_requeue_exception(&svm->vcpu, vector);
+			kvm_requeue_exception(vcpu, vector);
 		break;
 	case SVM_EXITINTINFO_TYPE_INTR:
-		kvm_queue_interrupt(&svm->vcpu, vector, false);
+		kvm_queue_interrupt(vcpu, vector, false);
 		break;
 	default:
 		break;
@@ -3767,7 +3775,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	control->exit_int_info = control->event_inj;
 	control->exit_int_info_err = control->event_inj_err;
 	control->event_inj = 0;
-	svm_complete_interrupts(svm);
+	svm_complete_interrupts(vcpu);
 }
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
@@ -3779,9 +3787,10 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
-static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
-					struct vcpu_svm *svm)
+static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	/*
 	 * VMENTER enables interrupts (host state), but the kernel state is
 	 * interrupts disabled when this is invoked. Also tell RCU about
@@ -3802,12 +3811,12 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(svm->vmcb_pa);
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
+		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&vcpu->arch.regs);
 
 		vmload(__sme_page_pa(sd->save_area));
 	}
@@ -3858,7 +3867,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		smp_send_reschedule(vcpu->cpu);
 	}
 
-	pre_svm_run(svm);
+	pre_svm_run(vcpu);
 
 	sync_lapic_to_cr8(vcpu);
 
@@ -3872,7 +3881,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
 	 * of a #DB.
 	 */
-	if (unlikely(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
+	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
 		svm_set_dr6(svm, vcpu->arch.dr6);
 	else
 		svm_set_dr6(svm, DR6_ACTIVE_LOW);
@@ -3890,7 +3899,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	svm_vcpu_enter_exit(vcpu, svm);
+	svm_vcpu_enter_exit(vcpu);
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
@@ -3910,12 +3919,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
-	if (!sev_es_guest(svm->vcpu.kvm))
+	if (!sev_es_guest(vcpu->kvm))
 		reload_tss(vcpu);
 
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	if (!sev_es_guest(svm->vcpu.kvm)) {
+	if (!sev_es_guest(vcpu->kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
 		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
 		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
@@ -3923,7 +3932,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-		kvm_before_interrupt(&svm->vcpu);
+		kvm_before_interrupt(vcpu);
 
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
@@ -3931,12 +3940,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	/* Any pending NMI will happen here */
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-		kvm_after_interrupt(&svm->vcpu);
+		kvm_after_interrupt(vcpu);
 
 	sync_cr8_to_lapic(vcpu);
 
 	svm->next_rip = 0;
-	if (is_guest_mode(&svm->vcpu)) {
+	if (is_guest_mode(vcpu)) {
 		nested_sync_control_from_vmcb02(svm);
 		svm->nested.nested_run_pending = 0;
 	}
@@ -3946,7 +3955,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* if exit due to PF check for async PF */
 	if (svm->vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR)
-		svm->vcpu.arch.apf.host_apf_flags =
+		vcpu->arch.apf.host_apf_flags =
 			kvm_read_and_reset_apf_flags();
 
 	if (npt_enabled) {
@@ -3960,9 +3969,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(svm->vmcb->control.exit_code ==
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
-		svm_handle_mce(svm);
+		svm_handle_mce(vcpu);
 
-	svm_complete_interrupts(svm);
+	svm_complete_interrupts(vcpu);
 
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
@@ -4061,7 +4070,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Update nrips enabled cache */
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
-			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
+			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
 
 	/* Check again if INVPCID interception if required */
 	svm_check_invpcid(svm);
@@ -4362,15 +4371,15 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 			if (!(saved_efer & EFER_SVME))
 				return 1;
 
-			if (kvm_vcpu_map(&svm->vcpu,
+			if (kvm_vcpu_map(vcpu,
 					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 				return 1;
 
 			if (svm_allocate_nested(svm))
 				return 1;
 
-			ret = enter_svm_guest_mode(svm, vmcb12_gpa, map.hva);
-			kvm_vcpu_unmap(&svm->vcpu, &map, true);
+			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, map.hva);
+			kvm_vcpu_unmap(vcpu, &map, true);
 		}
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 86f2fbb84307..fbbb26dd0f73 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -405,7 +405,7 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
-int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
+int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write);
 
@@ -437,15 +437,15 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
-int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa, struct vmcb *vmcb12);
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, struct vmcb *vmcb12);
 void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
-int nested_svm_vmrun(struct vcpu_svm *svm);
+int nested_svm_vmrun(struct kvm_vcpu *vcpu);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
 int nested_svm_exit_handled(struct vcpu_svm *svm);
-int nested_svm_check_permissions(struct vcpu_svm *svm);
+int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
@@ -492,8 +492,8 @@ void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
 void avic_init_vmcb(struct vcpu_svm *svm);
 void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
-int avic_incomplete_ipi_interception(struct vcpu_svm *svm);
-int avic_unaccelerated_access_interception(struct vcpu_svm *svm);
+int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
+int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
@@ -566,7 +566,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
-int sev_handle_vmgexit(struct vcpu_svm *svm);
+int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
-- 
2.26.2


