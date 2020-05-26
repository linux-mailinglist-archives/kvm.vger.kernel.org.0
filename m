Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D0C1E28B5
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389226AbgEZRZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57068 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389079AbgEZRXU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sK2BMQtWr0T7kZsZpmxmgtWNh6D1Ig8gl0biRr+IJtQ=;
        b=eaMH+6TcjU31A++6La0i8P1PCYeP48xRhw9Gk5xYPyU7Yzt9AMeuEa4bDSUHM/DZmTQs/b
        wDNXEuXXrLRto0j71DkMs5aUibfytAV7sTGtm3mD/iNJtH20zNidiBPItXQnloPxYLj8rJ
        Ob/Sj8ZUPGZffIlPlrzeoA80GdiKnNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-WDzh-98mN-CAOrZw4m6rKQ-1; Tue, 26 May 2020 13:23:12 -0400
X-MC-Unique: WDzh-98mN-CAOrZw4m6rKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A172E107ACCA;
        Tue, 26 May 2020 17:23:11 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1747310013DB;
        Tue, 26 May 2020 17:23:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 03/28] KVM: nSVM: inject exceptions via svm_check_nested_events
Date:   Tue, 26 May 2020 13:22:43 -0400
Message-Id: <20200526172308.111575-4-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows exceptions injected by the emulator to be properly delivered
as vmexits.  The code also becomes simpler, because we can just let all
L0-intercepted exceptions go through the usual path.  In particular, our
emulation of the VMX #DB exit qualification is very much simplified,
because the vmexit injection path can use kvm_deliver_exception_payload
to update DR6.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/svm/nested.c       | 136 +++++++++++++-------------------
 arch/x86/kvm/svm/svm.c          |   9 ---
 arch/x86/kvm/svm/svm.h          |   1 +
 arch/x86/kvm/x86.c              |  13 +--
 5 files changed, 58 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7707bd4b0593..e6f2e1a2dab6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1495,6 +1495,8 @@ void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
+void kvm_update_dr7(struct kvm_vcpu *vcpu);
+
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d544cce4f964..87fc5879dfaa 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -111,6 +111,8 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested;
 
+	svm->nested.host_intercept_exceptions = h->intercept_exceptions;
+
 	c->intercept_cr = h->intercept_cr;
 	c->intercept_dr = h->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions;
@@ -616,50 +618,6 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
 }
 
-/* DB exceptions for our internal use must not cause vmexit */
-static int nested_svm_intercept_db(struct vcpu_svm *svm)
-{
-	unsigned long dr6 = svm->vmcb->save.dr6;
-
-	/* Always catch it and pass it to userspace if debugging.  */
-	if (svm->vcpu.guest_debug &
-	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
-		return NESTED_EXIT_HOST;
-
-	/* if we're not singlestepping, it's not ours */
-	if (!svm->nmi_singlestep)
-		goto reflected_db;
-
-	/* if it's not a singlestep exception, it's not ours */
-	if (!(dr6 & DR6_BS))
-		goto reflected_db;
-
-	/* if the guest is singlestepping, it should get the vmexit */
-	if (svm->nmi_singlestep_guest_rflags & X86_EFLAGS_TF) {
-		disable_nmi_singlestep(svm);
-		goto reflected_db;
-	}
-
-	/* it's ours, the nested hypervisor must not see this one */
-	return NESTED_EXIT_HOST;
-
-reflected_db:
-	/*
-	 * Synchronize guest DR6 here just like in kvm_deliver_exception_payload;
-	 * it will be moved into the nested VMCB by nested_svm_vmexit.  Once
-	 * exceptions will be moved to svm_check_nested_events, all this stuff
-	 * will just go away and we could just return NESTED_EXIT_HOST
-	 * unconditionally.  db_interception will queue the exception, which
-	 * will be processed by svm_check_nested_events if a nested vmexit is
-	 * required, and we will just use kvm_deliver_exception_payload to copy
-	 * the payload to DR6 before vmexit.
-	 */
-	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
-	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
-	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;
-	return NESTED_EXIT_DONE;
-}
-
 static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 {
 	unsigned port, size, iopm_len;
@@ -710,20 +668,12 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		break;
 	}
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
-		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
-		if (svm->nested.intercept_exceptions & excp_bits) {
-			if (exit_code == SVM_EXIT_EXCP_BASE + DB_VECTOR)
-				vmexit = nested_svm_intercept_db(svm);
-			else if (exit_code == SVM_EXIT_EXCP_BASE + BP_VECTOR &&
-				 svm->vcpu.guest_debug & KVM_GUESTDBG_USE_SW_BP)
-				vmexit = NESTED_EXIT_HOST;
-			else
-				vmexit = NESTED_EXIT_DONE;
-		}
-		/* async page fault always cause vmexit */
-		else if ((exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR) &&
-			 svm->vcpu.arch.exception.nested_apf != 0)
-			vmexit = NESTED_EXIT_DONE;
+		/*
+		 * Host-intercepted exceptions have been checked already in
+		 * nested_svm_exit_special.  There is nothing to do here,
+		 * the vmexit is injected by svm_check_nested_events.
+		 */
+		vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_ERR: {
@@ -768,35 +718,45 @@ int nested_svm_check_permissions(struct vcpu_svm *svm)
 	return 0;
 }
 
-int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
-			       bool has_error_code, u32 error_code)
+static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
-	int vmexit;
+	unsigned int nr = svm->vcpu.arch.exception.nr;
 
-	if (!is_guest_mode(&svm->vcpu))
-		return 0;
+	return (svm->nested.intercept_exceptions & (1 << nr));
+}
 
-	vmexit = nested_svm_intercept(svm);
-	if (vmexit != NESTED_EXIT_DONE)
-		return 0;
+static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
+{
+	unsigned int nr = svm->vcpu.arch.exception.nr;
 
 	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
 	svm->vmcb->control.exit_code_hi = 0;
-	svm->vmcb->control.exit_info_1 = error_code;
+
+	if (svm->vcpu.arch.exception.has_error_code)
+		svm->vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
 
 	/*
 	 * EXITINFO2 is undefined for all exception intercepts other
 	 * than #PF.
 	 */
-	if (svm->vcpu.arch.exception.nested_apf)
-		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
-	else if (svm->vcpu.arch.exception.has_payload)
-		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
-	else
-		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+	if (nr == PF_VECTOR) {
+		if (svm->vcpu.arch.exception.nested_apf)
+			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
+		else if (svm->vcpu.arch.exception.has_payload)
+			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
+		else
+			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+	} else if (nr == DB_VECTOR) {
+		/* See inject_pending_event.  */
+		kvm_deliver_exception_payload(&svm->vcpu);
+		if (svm->vcpu.arch.dr7 & DR7_GD) {
+			svm->vcpu.arch.dr7 &= ~DR7_GD;
+			kvm_update_dr7(&svm->vcpu);
+		}
+	} else
+		WARN_ON(svm->vcpu.arch.exception.has_payload);
 
-	svm->nested.exit_required = true;
-	return vmexit;
+	nested_svm_vmexit(svm);
 }
 
 static void nested_svm_smi(struct vcpu_svm *svm)
@@ -835,6 +795,15 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required ||
 		svm->nested.nested_run_pending;
 
+	if (vcpu->arch.exception.pending) {
+		if (block_nested_events)
+                        return -EBUSY;
+		if (!nested_exit_on_exception(svm))
+			return 0;
+		nested_svm_inject_exception_vmexit(svm);
+		return 0;
+	}
+
 	if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
@@ -872,18 +841,19 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	switch (exit_code) {
 	case SVM_EXIT_INTR:
 	case SVM_EXIT_NMI:
-	case SVM_EXIT_EXCP_BASE + MC_VECTOR:
-		return NESTED_EXIT_HOST;
 	case SVM_EXIT_NPF:
-		/* For now we are always handling NPFs when using them */
-		if (npt_enabled)
+		return NESTED_EXIT_HOST;
+	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
+		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
+
+		if (get_host_vmcb(svm)->control.intercept_exceptions & excp_bits)
 			return NESTED_EXIT_HOST;
-		break;
-	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
-		/* Trap async PF even if not shadowing */
-		if (!npt_enabled || svm->vcpu.arch.apf.host_apf_reason)
+		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
+			 svm->vcpu.arch.apf.host_apf_reason)
+			/* Trap async PF even if not shadowing */
 			return NESTED_EXIT_HOST;
 		break;
+	}
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9ac9963405b5..251c457820a1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -331,17 +331,8 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
 	bool has_error_code = vcpu->arch.exception.has_error_code;
-	bool reinject = vcpu->arch.exception.injected;
 	u32 error_code = vcpu->arch.exception.error_code;
 
-	/*
-	 * If we are within a nested VM we'd better #VMEXIT and let the guest
-	 * handle the exception
-	 */
-	if (!reinject &&
-	    nested_svm_check_exception(svm, nr, has_error_code, error_code))
-		return;
-
 	kvm_deliver_exception_payload(&svm->vcpu);
 
 	if (nr == BP_VECTOR && !nrips) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5cc559ab862d..8342032291fc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -86,6 +86,7 @@ struct nested_state {
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb;
+	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
 	u32 *msrpm;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 192238841cac..e03543488d37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1072,7 +1072,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void kvm_update_dr7(struct kvm_vcpu *vcpu)
+void kvm_update_dr7(struct kvm_vcpu *vcpu)
 {
 	unsigned long dr7;
 
@@ -1085,6 +1085,7 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 	if (dr7 & DR7_BP_EN_MASK)
 		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
 }
+EXPORT_SYMBOL_GPL(kvm_update_dr7);
 
 static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 {
@@ -7774,16 +7775,6 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 					     X86_EFLAGS_RF);
 
 		if (vcpu->arch.exception.nr == DB_VECTOR) {
-			/*
-			 * This code assumes that nSVM doesn't use
-			 * check_nested_events(). If it does, the
-			 * DR6/DR7 changes should happen before L1
-			 * gets a #VMEXIT for an intercepted #DB in
-			 * L2.  (Under VMX, on the other hand, the
-			 * DR6/DR7 changes should not happen in the
-			 * event of a VM-exit to L1 for an intercepted
-			 * #DB in L2.)
-			 */
 			kvm_deliver_exception_payload(vcpu);
 			if (vcpu->arch.dr7 & DR7_GD) {
 				vcpu->arch.dr7 &= ~DR7_GD;
-- 
2.26.2


