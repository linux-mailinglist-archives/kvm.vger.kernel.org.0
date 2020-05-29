Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426231E823A
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgE2Pjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:39:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52351 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727804AbgE2Pjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EuKk4mgMylLibLHKS+ma3qEqrxhS8E9+QMvFumkXPb4=;
        b=MQjJz9tGeAoyZk9XZkr9rSuTz67N1KGnK38ewO3ejBG4B50qCF1Qx2tclZtkjUxxXzpBJV
        o1V8+Dl3YvdiK7JyKGr+lHwnFMXR3NBqEi44UD+qjT4J1ydXxrKv3IVyaxwNySv818VKgU
        QrH33SdRtcwzKLION846J3ZHJ7z09Dc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-wejpi3foNZWduFQYwwfhFQ-1; Fri, 29 May 2020 11:39:37 -0400
X-MC-Unique: wejpi3foNZWduFQYwwfhFQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 998BA80183C;
        Fri, 29 May 2020 15:39:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40D745D9D5;
        Fri, 29 May 2020 15:39:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 02/30] KVM: x86: enable event window in inject_pending_event
Date:   Fri, 29 May 2020 11:39:06 -0400
Message-Id: <20200529153934.11694-3-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

This patch moves the opening of the interrupt window inside
inject_pending_event.  This consolidates the check for pending
interrupt/NMI/SMI in one place, and makes KVM's usage of immediate
exits more consistent, extending it beyond just nested virtualization.

There are two functional changes here.  They only affect corner cases,
but overall they simplify the inject_pending_event.

- re-injection of still-pending events will also use req_immediate_exit
instead of using interrupt-window intercepts.  This should have no impact
on performance on Intel since it simply replaces an interrupt-window
or NMI-window exit for a preemption-timer exit.  On AMD, which has no
equivalent of the preemption time, it may incur some overhead but an
actual effect on performance should only be visible in pathological cases.

- kvm_arch_interrupt_allowed and kvm_vcpu_has_events will return true
if an interrupt, NMI or SMI is blocked by nested_run_pending.  This
makes sense because entering the VM will allow it to make progress
and deliver the event.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   8 +--
 arch/x86/kvm/svm/svm.c          |  24 +++----
 arch/x86/kvm/vmx/vmx.c          |  20 +++---
 arch/x86/kvm/x86.c              | 117 ++++++++++++++++++--------------
 4 files changed, 92 insertions(+), 77 deletions(-)

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
index d877a0f70cac..5da494847a2f 100644
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
index 4e76e30b661c..b3a41645e157 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4551,14 +4551,14 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
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
@@ -4573,17 +4573,17 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
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
@@ -7757,11 +7757,11 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
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
 
@@ -7799,9 +7799,9 @@ static int vmx_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
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
index 77b9b4e66673..0ee828f60d05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7714,7 +7714,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static int inject_pending_event(struct kvm_vcpu *vcpu)
+static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
 	bool can_inject = true;
@@ -7760,8 +7760,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	 */
 	if (is_guest_mode(vcpu)) {
 		r = kvm_x86_ops.nested_ops->check_events(vcpu);
-		if (r != 0)
-			return r;
+		if (r < 0)
+			goto busy;
 	}
 
 	/* try to inject new event if pending */
@@ -7799,27 +7799,69 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		can_inject = false;
 	}
 
-	/* Finish re-injection before considering new events */
-	if (!can_inject)
-		return 0;
+	/*
+	 * Finally, inject interrupt events.  If an event cannot be injected
+	 * due to architectural conditions (e.g. IF=0) a window-open exit
+	 * will re-request KVM_REQ_EVENT.  Sometimes however an event is pending
+	 * and can architecturally be injected, but we cannot do it right now:
+	 * an interrupt could have arrived just now and we have to inject it
+	 * as a vmexit, or there could already an event in the queue, which is
+	 * indicated by can_inject.  In that case we request an immediate exit
+	 * in order to make progress and get back here for another iteration.
+	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
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
+		} else
+			kvm_x86_ops.enable_smi_window(vcpu);
+	}
+
+	if (vcpu->arch.nmi_pending) {
+		r = can_inject ? kvm_x86_ops.nmi_allowed(vcpu, true) : -EBUSY;
+		if (r < 0)
+			goto busy;
+		if (r) {
+			--vcpu->arch.nmi_pending;
+			vcpu->arch.nmi_injected = true;
+			kvm_x86_ops.set_nmi(vcpu);
+			can_inject = false;
+			WARN_ON(kvm_x86_ops.nmi_allowed(vcpu, true) < 0);
+		}
+		if (vcpu->arch.nmi_pending)
+			kvm_x86_ops.enable_nmi_window(vcpu);
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
+	if (kvm_cpu_has_injectable_intr(vcpu)) {
+		r = can_inject ? kvm_x86_ops.interrupt_allowed(vcpu, true) : -EBUSY;
+		if (r < 0)
+			goto busy;
+		if (r) {
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
+			kvm_x86_ops.set_irq(vcpu);
+			WARN_ON(kvm_x86_ops.interrupt_allowed(vcpu, true) < 0);
+		}
+		if (kvm_cpu_has_injectable_intr(vcpu))
+			kvm_x86_ops.enable_irq_window(vcpu);
 	}
 
-	return 0;
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
@@ -8357,36 +8399,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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


