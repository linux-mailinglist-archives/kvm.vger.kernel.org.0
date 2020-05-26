Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E491E2883
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389099AbgEZRXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20118 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388949AbgEZRXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DpU/qQ+IfwTDQRM2tlFSMSJuKRfpad0oHHAo38pWV4=;
        b=LhfpeB1Y8y0ysVH4rdxQKoXDnTM7FxfvseDS1k2ViDDE5N56VmI8DX50q11DtTaQ9yJ9ml
        Nqf5d+F1bI18V46yfgfYBrGAUXYTlbt4l5VEm8feOo6kSSMlhuTvJ7FP2cdTRIDHdSRMUk
        kwTgKypyPYIq0z2XVGK5miVOm3lfYSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-vj8EChm2OMucmuemUr96VA-1; Tue, 26 May 2020 13:23:12 -0400
X-MC-Unique: vj8EChm2OMucmuemUr96VA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEF9E80183C;
        Tue, 26 May 2020 17:23:10 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5606D10013DB;
        Tue, 26 May 2020 17:23:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 02/28] KVM: x86: enable event window in inject_pending_event
Date:   Tue, 26 May 2020 13:22:42 -0400
Message-Id: <20200526172308.111575-3-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case an interrupt arrives after nested.check_events but before the
call to kvm_cpu_has_injectable_intr, we could end up enabling the interrupt
window even if the interrupt is actually going to be a vmexit.  This is
useless rather than harmful, but it really complicates reasoning about
SVM's handling of the VINTR intercept.  We'd like to never bother with
the VINTR intercept if V_INTR_MASKING=1 && INTERCEPT_INTR=1, because in
that case there is no interrupt window and we can just exit the nested
guest whenever we want.

As a first step, this patch moves the opening of the interrupt
window inside inject_pending_event.  This consolidates the check for
pending interrupt/NMI/SMI in one place, removing the repeated call to
kvm_cpu_has_injectable_intr.

The main functional change here is that re-injection of still-pending
events will also use req_immediate_exit instead of using interrupt-window
intercepts.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   8 +--
 arch/x86/kvm/svm/svm.c          |  24 +++----
 arch/x86/kvm/vmx/vmx.c          |  20 +++---
 arch/x86/kvm/x86.c              | 112 +++++++++++++++++---------------
 4 files changed, 87 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db261da578f3..7707bd4b0593 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1136,8 +1136,8 @@ struct kvm_x86_ops {
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
-	bool (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
-	bool (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
+	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
+	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
@@ -1234,10 +1234,10 @@ struct kvm_x86_ops {
 
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
-	bool (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
+	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
-	int (*enable_smi_window)(struct kvm_vcpu *vcpu);
+	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9987f6fe9d88..9ac9963405b5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3053,15 +3053,15 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static bool svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (svm->nested.nested_run_pending)
-		return false;
+		return -EBUSY;
 
 	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
-		return false;
+		return -EBUSY;
 
 	return !svm_nmi_blocked(vcpu);
 }
@@ -3112,18 +3112,18 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK);
 }
 
-static bool svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (svm->nested.nested_run_pending)
-		return false;
+		return -EBUSY;
 
 	/*
 	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
 	 * e.g. if the IRQ arrived asynchronously after checking nested events.
 	 */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
-		return false;
+		return -EBUSY;
 
 	return !svm_interrupt_blocked(vcpu);
 }
@@ -3793,15 +3793,15 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 	return is_smm(vcpu);
 }
 
-static bool svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (svm->nested.nested_run_pending)
-		return false;
+		return -EBUSY;
 
 	/* An SMI must not be injected into L2 if it's supposed to VM-Exit.  */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_smi(svm))
-		return false;
+		return -EBUSY;
 
 	return !svm_smi_blocked(vcpu);
 }
@@ -3848,7 +3848,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static int enable_smi_window(struct kvm_vcpu *vcpu)
+static void enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3856,9 +3856,9 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
 		if (vgif_enabled(svm))
 			set_intercept(svm, INTERCEPT_STGI);
 		/* STGI will cause a vm exit */
-		return 1;
+	} else {
+		/* We must be in SMM; RSM will cause a vmexit anyway.  */
 	}
-	return 0;
 }
 
 static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 55712dd86baf..aedc46407b1f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4552,14 +4552,14 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 		 GUEST_INTR_STATE_NMI));
 }
 
-static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+static int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
-		return false;
+		return -EBUSY;
 
 	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(vcpu))
-		return false;
+		return -EBUSY;
 
 	return !vmx_nmi_blocked(vcpu);
 }
@@ -4574,17 +4574,17 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
-static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
-		return false;
+		return -EBUSY;
 
        /*
         * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
         * e.g. if the IRQ arrived asynchronously after checking nested events.
         */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
-		return false;
+		return -EBUSY;
 
 	return !vmx_interrupt_blocked(vcpu);
 }
@@ -7755,11 +7755,11 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 			~FEAT_CTL_LMCE_ENABLED;
 }
 
-static bool vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
 	if (to_vmx(vcpu)->nested.nested_run_pending)
-		return false;
+		return -EBUSY;
 	return !is_smm(vcpu);
 }
 
@@ -7797,9 +7797,9 @@ static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	return 0;
 }
 
-static int enable_smi_window(struct kvm_vcpu *vcpu)
+static void enable_smi_window(struct kvm_vcpu *vcpu)
 {
-	return 0;
+	/* RSM will cause a vmexit anyway.  */
 }
 
 static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 064a7ea0e671..192238841cac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7710,7 +7710,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static int inject_pending_event(struct kvm_vcpu *vcpu)
+static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
 	bool can_inject = true;
@@ -7756,8 +7756,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	 */
 	if (is_guest_mode(vcpu)) {
 		r = kvm_x86_ops.nested_ops->check_events(vcpu);
-		if (r != 0)
-			return r;
+		if (r < 0)
+			goto busy;
 	}
 
 	/* try to inject new event if pending */
@@ -7795,27 +7795,64 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		can_inject = false;
 	}
 
-	/* Finish re-injection before considering new events */
-	if (!can_inject)
-		return 0;
+	/*
+	 * Finally, either inject the event or enable window-open exits.
+	 * If an event is pending but cannot be injected right now (for
+	 * example if it just arrived and we have to inject it as a
+	 * vmexit), then we request an immediate exit.  This is indicated
+	 * by a -EBUSY return value from kvm_x86_ops.*_allowed.
+	 */
+	if (vcpu->arch.smi_pending) {
+		r = can_inject ? kvm_x86_ops.smi_allowed(vcpu, true) : -EBUSY;
+		if (r < 0)
+			goto busy;
+		if (r) {
+			vcpu->arch.smi_pending = false;
+			++vcpu->arch.smi_count;
+			enter_smm(vcpu);
+			can_inject = false;
+		} else {
+			kvm_x86_ops.enable_smi_window(vcpu);
+		}
+	}
 
-	if (vcpu->arch.smi_pending &&
-	    kvm_x86_ops.smi_allowed(vcpu, true)) {
-		vcpu->arch.smi_pending = false;
-		++vcpu->arch.smi_count;
-		enter_smm(vcpu);
-	} else if (vcpu->arch.nmi_pending &&
-		   kvm_x86_ops.nmi_allowed(vcpu, true)) {
-		--vcpu->arch.nmi_pending;
-		vcpu->arch.nmi_injected = true;
-		kvm_x86_ops.set_nmi(vcpu);
-	} else if (kvm_cpu_has_injectable_intr(vcpu) &&
-		   kvm_x86_ops.interrupt_allowed(vcpu, true)) {
-		kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-		kvm_x86_ops.set_irq(vcpu);
+	if (vcpu->arch.nmi_pending) {
+		r = can_inject ? kvm_x86_ops.nmi_allowed(vcpu, true) : -EBUSY;
+		if (r < 0)
+			goto busy;
+		if (r) {
+			--vcpu->arch.nmi_pending;
+			vcpu->arch.nmi_injected = true;
+			kvm_x86_ops.set_nmi(vcpu);
+			can_inject = false;
+		} else {
+			kvm_x86_ops.enable_nmi_window(vcpu);
+		}
 	}
 
-	return 0;
+	if (kvm_cpu_has_injectable_intr(vcpu)) {
+		r = can_inject ? kvm_x86_ops.interrupt_allowed(vcpu, true) : -EBUSY;
+		if (r < 0)
+			goto busy;
+		if (r) {
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
+			kvm_x86_ops.set_irq(vcpu);
+		} else {
+			kvm_x86_ops.enable_irq_window(vcpu);
+		}
+	}
+
+	if (is_guest_mode(vcpu) &&
+	    kvm_x86_ops.nested_ops->hv_timer_pending &&
+	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+		*req_immediate_exit = true;
+
+	WARN_ON(vcpu->arch.exception.pending);
+	return;
+
+busy:
+	*req_immediate_exit = true;
+	return;
 }
 
 static void process_nmi(struct kvm_vcpu *vcpu)
@@ -8353,36 +8390,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		if (inject_pending_event(vcpu) != 0)
-			req_immediate_exit = true;
-		else {
-			/* Enable SMI/NMI/IRQ window open exits if needed.
-			 *
-			 * SMIs have three cases:
-			 * 1) They can be nested, and then there is nothing to
-			 *    do here because RSM will cause a vmexit anyway.
-			 * 2) There is an ISA-specific reason why SMI cannot be
-			 *    injected, and the moment when this changes can be
-			 *    intercepted.
-			 * 3) Or the SMI can be pending because
-			 *    inject_pending_event has completed the injection
-			 *    of an IRQ or NMI from the previous vmexit, and
-			 *    then we request an immediate exit to inject the
-			 *    SMI.
-			 */
-			if (vcpu->arch.smi_pending && !is_smm(vcpu))
-				if (!kvm_x86_ops.enable_smi_window(vcpu))
-					req_immediate_exit = true;
-			if (vcpu->arch.nmi_pending)
-				kvm_x86_ops.enable_nmi_window(vcpu);
-			if (kvm_cpu_has_injectable_intr(vcpu) || req_int_win)
-				kvm_x86_ops.enable_irq_window(vcpu);
-			if (is_guest_mode(vcpu) &&
-			    kvm_x86_ops.nested_ops->hv_timer_pending &&
-			    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
-				req_immediate_exit = true;
-			WARN_ON(vcpu->arch.exception.pending);
-		}
+		inject_pending_event(vcpu, &req_immediate_exit);
+		if (req_int_win)
+			kvm_x86_ops.enable_irq_window(vcpu);
 
 		if (kvm_lapic_enabled(vcpu)) {
 			update_cr8_intercept(vcpu);
-- 
2.26.2


