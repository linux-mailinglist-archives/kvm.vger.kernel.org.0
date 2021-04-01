Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527D63517FC
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhDARnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:43:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234880AbhDARlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knfdMCa1MstgqSIgKLls10HrkX8OH4puDPVxVyz+xv4=;
        b=M0KGD9kbi83J3cyijvJ7ncovnZGLeiV0qUR1wXlwbgB5cfejm3EMnM6ffzDRnesl0cHWwb
        2ZTam5aYevPz6IAWL5nfbuPGUMLUSQzZ5oN3VXZelzxiiuM4TTs2h5lvSUgazoBjhfiyaj
        aMzhTNeBlBdhV7F3Ij4UxSrVdjDcMgI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-NjTE-OFMNim1T-X1-53wvA-1; Thu, 01 Apr 2021 10:39:38 -0400
X-MC-Unique: NjTE-OFMNim1T-X1-53wvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A30108B5D76;
        Thu,  1 Apr 2021 14:38:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2847A5D9CA;
        Thu,  1 Apr 2021 14:38:29 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/4] KVM: x86: correctly merge pending and injected exception
Date:   Thu,  1 Apr 2021 17:38:16 +0300
Message-Id: <20210401143817.1030695-4-mlevitsk@redhat.com>
In-Reply-To: <20210401143817.1030695-1-mlevitsk@redhat.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the pending and the injected exceptions to co-exist
when they are raised.

Add 'kvm_deliver_pending_exception' function which 'merges' the pending
and injected exception or delivers a VM exit with both for a case when
the L1 intercepts the pending exception.

The later is done by vendor code using new nested callback
'deliver_exception_as_vmexit'

The kvm_deliver_pending_exception is called after each VM exit,
and prior to VM entry which ensures that during userspace VM exits,
only injected exception can be in a raised state.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   9 ++
 arch/x86/kvm/svm/nested.c       |  27 ++--
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/nested.c       |  58 ++++----
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              | 233 ++++++++++++++++++--------------
 6 files changed, 181 insertions(+), 150 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3b2fd276e8d5..a9b9cd030d9a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1346,6 +1346,15 @@ struct kvm_x86_ops {
 
 struct kvm_x86_nested_ops {
 	int (*check_events)(struct kvm_vcpu *vcpu);
+
+	/*
+	 * Deliver a pending exception as a VM exit if the L1 intercepts it.
+	 * Returns -EBUSY if L1 does intercept the exception but,
+	 * it is not possible to deliver it right now.
+	 * (for example when nested run is pending)
+	 */
+	int (*deliver_exception_as_vmexit)(struct kvm_vcpu *vcpu);
+
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7adad9b6dcad..ff745d59ffcf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1061,21 +1061,6 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.pending_exception.valid) {
-		/*
-		 * Only a pending nested run can block a pending exception.
-		 * Otherwise an injected NMI/interrupt should either be
-		 * lost or delivered to the nested hypervisor in the EXITINTINFO
-		 * vmcb field, while delivering the pending exception.
-		 */
-		if (svm->nested.nested_run_pending)
-                        return -EBUSY;
-		if (!nested_exit_on_exception(svm))
-			return 0;
-		nested_svm_inject_exception_vmexit(svm);
-		return 0;
-	}
-
 	if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
@@ -1107,6 +1092,17 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int svm_deliver_nested_exception_as_vmexit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (svm->nested.nested_run_pending)
+		return -EBUSY;
+	if (nested_exit_on_exception(svm))
+		nested_svm_inject_exception_vmexit(svm);
+	return 0;
+}
+
 int nested_svm_exit_special(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
@@ -1321,6 +1317,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
 	.triple_fault = nested_svm_triple_fault,
+	.deliver_exception_as_vmexit = svm_deliver_nested_exception_as_vmexit,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 90b541138c5a..b89e48574c39 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -363,7 +363,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 	bool has_error_code = vcpu->arch.injected_exception.has_error_code;
 	u32 error_code = vcpu->arch.injected_exception.error_code;
 
-	kvm_deliver_exception_payload(vcpu);
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
 
 	if (nr == BP_VECTOR && !nrips) {
 		unsigned long rip, old_rip = kvm_rip_read(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5d54fecff9a7..1c09b132c55c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3768,7 +3768,6 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
 	bool mtf_pending = vmx->nested.mtf_pending;
@@ -3804,41 +3803,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	/*
-	 * Process any exceptions that are not debug traps before MTF.
-	 *
-	 * Note that only a pending nested run can block a pending exception.
-	 * Otherwise an injected NMI/interrupt should either be
-	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
-	 * while delivering the pending exception.
-	 */
-
-	if (vcpu->arch.pending_exception.valid && !vmx_pending_dbg_trap(vcpu)) {
-		if (vmx->nested.nested_run_pending)
-			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
-	}
-
 	if (mtf_pending) {
 		if (block_nested_events)
 			return -EBUSY;
+
 		nested_vmx_update_pending_dbg(vcpu);
 		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
 		return 0;
 	}
 
-	if (vcpu->arch.pending_exception.valid) {
-		if (vmx->nested.nested_run_pending)
-			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
-	}
-
 	if (nested_vmx_preemption_timer_pending(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
@@ -3884,6 +3857,34 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int nested_vmx_deliver_exception_as_vmexit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long exit_qual;
+
+	if (vmx->nested.nested_run_pending)
+		return -EBUSY;
+
+	if (vmx->nested.mtf_pending && vmx_pending_dbg_trap(vcpu)) {
+		/*
+		 * A pending monitor trap takes precedence over pending
+		 * debug exception which is 'stashed' into
+		 * 'GUEST_PENDING_DBG_EXCEPTIONS'
+		 */
+
+		nested_vmx_update_pending_dbg(vcpu);
+		vmx->nested.mtf_pending = false;
+		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
+		return 0;
+	}
+	if (vcpu->arch.pending_exception.valid) {
+		if (nested_vmx_check_exception(vcpu, &exit_qual))
+			nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
+		return 0;
+	}
+	return 0;
+}
+
 static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
 {
 	ktime_t remaining =
@@ -6603,6 +6604,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
 	.check_events = vmx_check_nested_events,
+	.deliver_exception_as_vmexit = nested_vmx_deliver_exception_as_vmexit,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a9b241d2b271..fc6bc40d47b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1682,7 +1682,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	u32 error_code = vcpu->arch.injected_exception.error_code;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
-	kvm_deliver_exception_payload(vcpu);
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
 
 	if (has_error_code) {
 		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 493d87b0c2d5..a363204f37be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -535,86 +535,30 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
-		unsigned nr, bool has_error, u32 error_code,
-	        bool has_payload, unsigned long payload, bool reinject)
+				   unsigned int nr, bool has_error, u32 error_code,
+				   bool has_payload, unsigned long payload,
+				   bool reinject)
 {
-	u32 prev_nr;
-	int class1, class2;
-
+	struct kvm_queued_exception *exc;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-	if (!vcpu->arch.pending_exception.valid && !vcpu->arch.injected_exception.valid) {
-	queue:
-		if (reinject) {
-			/*
-			 * On vmentry, vcpu->arch.exception.pending is only
-			 * true if an event injection was blocked by
-			 * nested_run_pending.  In that case, however,
-			 * vcpu_enter_guest requests an immediate exit,
-			 * and the guest shouldn't proceed far enough to
-			 * need reinjection.
-			 */
-			WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
-			if (WARN_ON_ONCE(has_payload)) {
-				/*
-				 * A reinjected event has already
-				 * delivered its payload.
-				 */
-				has_payload = false;
-				payload = 0;
-			}
-
-			vcpu->arch.injected_exception.valid = true;
-			vcpu->arch.injected_exception.has_error_code = has_error;
-			vcpu->arch.injected_exception.nr = nr;
-			vcpu->arch.injected_exception.error_code = error_code;
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
+	WARN_ON_ONCE(reinject && vcpu->arch.injected_exception.valid);
 
-		} else {
-			vcpu->arch.pending_exception.valid = true;
-			vcpu->arch.injected_exception.valid = false;
-			vcpu->arch.pending_exception.has_error_code = has_error;
-			vcpu->arch.pending_exception.nr = nr;
-			vcpu->arch.pending_exception.error_code = error_code;
-		}
-
-		vcpu->arch.exception_payload.valid = has_payload;
-		vcpu->arch.exception_payload.value = payload;
-		if (!is_guest_mode(vcpu))
-			kvm_deliver_exception_payload(vcpu);
-		return;
-	}
-
-	/* to check exception */
-	prev_nr = vcpu->arch.injected_exception.nr;
-	if (prev_nr == DF_VECTOR) {
-		/* triple fault -> shutdown */
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
-		return;
-	}
-	class1 = exception_class(prev_nr);
-	class2 = exception_class(nr);
-	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
-		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
-		/*
-		 * Generate double fault per SDM Table 5-5.  Set
-		 * exception.pending = true so that the double fault
-		 * can trigger a nested vmexit.
-		 */
-		vcpu->arch.pending_exception.valid = true;
-		vcpu->arch.injected_exception.valid = false;
-		vcpu->arch.pending_exception.has_error_code = true;
-		vcpu->arch.pending_exception.nr = DF_VECTOR;
-		vcpu->arch.pending_exception.error_code = 0;
+	exc = reinject ? &vcpu->arch.injected_exception :
+			 &vcpu->arch.pending_exception;
+	exc->valid = true;
+	exc->nr = nr;
+	exc->has_error_code = has_error;
+	exc->error_code = error_code;
 
-		vcpu->arch.exception_payload.valid = false;
-		vcpu->arch.exception_payload.value = 0;
-	} else
-		/* replace previous exception with a new one in a hope
-		   that instruction re-execution will regenerate lost
-		   exception */
-		goto queue;
+	// re-injected exception has its payload already delivered
+	WARN_ON_ONCE(reinject && has_payload);
+	vcpu->arch.exception_payload.valid = has_payload;
+	vcpu->arch.exception_payload.value = payload;
 }
 
+
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
 	kvm_multiple_exception(vcpu, nr, false, 0, false, 0, false);
@@ -641,6 +585,95 @@ static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 			       true, payload, false);
 }
 
+static int kvm_do_deliver_pending_exception(struct kvm_vcpu *vcpu)
+{
+	int class1, class2, ret;
+
+	/* try to deliver current pending exception as VM exit */
+	if (is_guest_mode(vcpu)) {
+		ret = kvm_x86_ops.nested_ops->deliver_exception_as_vmexit(vcpu);
+		if (ret || !vcpu->arch.pending_exception.valid)
+			return ret;
+	}
+
+	/* No injected exception, so just deliver the payload and inject it */
+	if (!vcpu->arch.injected_exception.valid) {
+		trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
+					vcpu->arch.pending_exception.has_error_code,
+					vcpu->arch.pending_exception.error_code);
+queue:
+		/* Intel SDM 17.3.1.1 */
+		if (exception_type(vcpu->arch.pending_exception.nr) == EXCPT_FAULT)
+			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
+					     X86_EFLAGS_RF);
+
+		kvm_deliver_exception_payload(vcpu);
+
+		/* Intel SDM 17.2.4
+		 * The processor clears the GD flag upon entering to the
+		 * debug exception handler, to allow the handler access
+		 * to the debug registers.
+		 */
+		if (vcpu->arch.pending_exception.nr == DB_VECTOR) {
+			if (vcpu->arch.dr7 & DR7_GD) {
+				vcpu->arch.dr7 &= ~DR7_GD;
+				kvm_update_dr7(vcpu);
+			}
+		}
+
+		if (vcpu->arch.pending_exception.error_code && !is_protmode(vcpu))
+			vcpu->arch.pending_exception.error_code = false;
+
+		vcpu->arch.injected_exception = vcpu->arch.pending_exception;
+		vcpu->arch.pending_exception.valid = false;
+		return 0;
+	}
+
+	/* Convert a pending exception and an injected #DF to a triple fault*/
+	if (vcpu->arch.injected_exception.nr == DF_VECTOR) {
+		/* triple fault -> shutdown */
+		vcpu->arch.injected_exception.valid = false;
+		vcpu->arch.pending_exception.valid = false;
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 0;
+	}
+
+	class1 = exception_class(vcpu->arch.injected_exception.nr);
+	class2 = exception_class(vcpu->arch.pending_exception.nr);
+
+	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
+		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
+
+		/* Generate double fault per SDM Table 5-5. */
+		vcpu->arch.injected_exception.valid = false;
+		vcpu->arch.pending_exception.valid = true;
+		vcpu->arch.pending_exception.has_error_code = true;
+		vcpu->arch.pending_exception.nr = DF_VECTOR;
+		vcpu->arch.pending_exception.error_code = 0;
+		vcpu->arch.exception_payload.valid = false;
+	} else
+		/* Drop the injected exception and replace it with the pending one*/
+		goto queue;
+
+	return 0;
+}
+
+static int kvm_deliver_pending_exception(struct kvm_vcpu *vcpu)
+{
+	int ret = 0;
+
+	if (!vcpu->arch.pending_exception.valid)
+		return ret;
+
+	ret = kvm_do_deliver_pending_exception(vcpu);
+
+	if (ret || !vcpu->arch.pending_exception.valid)
+		return ret;
+
+	WARN_ON_ONCE(vcpu->arch.pending_exception.nr != DF_VECTOR);
+	return kvm_do_deliver_pending_exception(vcpu);
+}
+
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err)
 {
 	if (err)
@@ -4297,6 +4330,12 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	    vcpu->arch.pending_exception.valid && vcpu->arch.exception_payload.valid)
 		kvm_deliver_exception_payload(vcpu);
 
+	/*
+	 * Currently we merge the pending and the injected exceptions
+	 * after each VM exit, which can fail only when nested run is pending,
+	 * in which case only injected (from us or L1) exception is possible.
+	 */
+
 	WARN_ON_ONCE(vcpu->arch.pending_exception.valid &&
 		     vcpu->arch.injected_exception.valid);
 
@@ -8401,8 +8440,6 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.injected_exception.error_code && !is_protmode(vcpu))
-		vcpu->arch.injected_exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
 }
 
@@ -8411,8 +8448,13 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	int r;
 	bool can_inject = true;
 
-	/* try to reinject previous events if any */
+	r = kvm_deliver_pending_exception(vcpu);
+	if (r < 0)
+		goto busy;
+
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
 
+	/* try to reinject previous events if any */
 	if (vcpu->arch.injected_exception.valid) {
 		kvm_inject_exception(vcpu);
 		can_inject = false;
@@ -8431,7 +8473,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 * serviced prior to recognizing any new events in order to
 	 * fully complete the previous instruction.
 	 */
-	else if (!vcpu->arch.pending_exception.valid) {
+	else {
 		if (vcpu->arch.nmi_injected) {
 			static_call(kvm_x86_set_nmi)(vcpu);
 			can_inject = false;
@@ -8441,9 +8483,6 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		}
 	}
 
-	WARN_ON_ONCE(vcpu->arch.pending_exception.valid &&
-		     vcpu->arch.injected_exception.valid);
-
 	/*
 	 * Call check_nested_events() even if we reinjected a previous event
 	 * in order for caller to determine if it should require immediate-exit
@@ -8456,30 +8495,6 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			goto busy;
 	}
 
-	/* try to inject new event if pending */
-	if (vcpu->arch.pending_exception.valid) {
-		trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
-					vcpu->arch.pending_exception.has_error_code,
-					vcpu->arch.pending_exception.error_code);
-
-		vcpu->arch.injected_exception = vcpu->arch.pending_exception;
-		vcpu->arch.pending_exception.valid = false;
-
-		if (exception_type(vcpu->arch.injected_exception.nr) == EXCPT_FAULT)
-			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
-					     X86_EFLAGS_RF);
-
-		if (vcpu->arch.injected_exception.nr == DB_VECTOR) {
-			kvm_deliver_exception_payload(vcpu);
-			if (vcpu->arch.dr7 & DR7_GD) {
-				vcpu->arch.dr7 &= ~DR7_GD;
-				kvm_update_dr7(vcpu);
-			}
-		}
-
-		kvm_inject_exception(vcpu);
-		can_inject = false;
-	}
 
 	/*
 	 * Finally, inject interrupt events.  If an event cannot be injected
@@ -9270,6 +9285,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_lapic_sync_from_vapic(vcpu);
 
 	r = static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath);
+
+	/*
+	 * Deliver the pending exception so that the state of having a pending
+	 * and an injected exception is not visible to the userspace.
+	 */
+
+	kvm_deliver_pending_exception(vcpu);
+
 	return r;
 
 cancel_injection:
@@ -11014,7 +11037,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.pv.pv_unhalted)
 		return true;
 
-	if (vcpu->arch.pending_exception.valid)
+	if (vcpu->arch.pending_exception.valid || vcpu->arch.injected_exception.valid)
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
-- 
2.26.2

