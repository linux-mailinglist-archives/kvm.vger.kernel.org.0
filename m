Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D298A3517E5
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhDARnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234802AbhDARkQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:40:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XiHNsvGFXmmRVmD21Ex022DO567amJajR26yw0JMmc=;
        b=h0XyYj8rgAdxfY7Rj1WuM55PO6v1PNoPf3XT03PRWk3f+W/P1pmgaCjlaQGgfsM1IPPQ+4
        p5vO7fbKiHocC1d5Yf4cYTd/zakuqbmiry5MTh5iYkZaChW7rBEmR8Ofk3B9S0NKNKDMsv
        YuloO6/aM18CqkETpyBpVSd3xtWEnPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-QXjyG--EO8ejpzJD8TYfHg-1; Thu, 01 Apr 2021 10:39:31 -0400
X-MC-Unique: QXjyG--EO8ejpzJD8TYfHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE710884DA6;
        Thu,  1 Apr 2021 14:38:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DFF15D9CA;
        Thu,  1 Apr 2021 14:38:26 +0000 (UTC)
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
Subject: [PATCH 2/4] KVM: x86: separate pending and injected exception
Date:   Thu,  1 Apr 2021 17:38:15 +0300
Message-Id: <20210401143817.1030695-3-mlevitsk@redhat.com>
In-Reply-To: <20210401143817.1030695-1-mlevitsk@redhat.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use 'pending_exception' and 'injected_exception' fields
to store the pending and the injected exceptions.

After this patch still only one is active, but
in the next patch both could co-exist in some cases.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  25 ++++--
 arch/x86/kvm/svm/nested.c       |  26 +++---
 arch/x86/kvm/svm/svm.c          |   6 +-
 arch/x86/kvm/vmx/nested.c       |  36 ++++----
 arch/x86/kvm/vmx/vmx.c          |  12 +--
 arch/x86/kvm/x86.c              | 145 ++++++++++++++++++--------------
 arch/x86/kvm/x86.h              |   6 +-
 7 files changed, 143 insertions(+), 113 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6..3b2fd276e8d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -547,6 +547,14 @@ struct kvm_vcpu_xen {
 	u64 runstate_times[4];
 };
 
+struct kvm_queued_exception {
+	bool valid;
+	u8 nr;
+	bool has_error_code;
+	u32 error_code;
+};
+
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -645,16 +653,15 @@ struct kvm_vcpu_arch {
 
 	u8 event_exit_inst_len;
 
-	struct kvm_queued_exception {
-		bool pending;
-		bool injected;
-		bool has_error_code;
-		u8 nr;
-		u32 error_code;
-		unsigned long payload;
-		bool has_payload;
+	struct kvm_queued_exception pending_exception;
+
+	struct kvm_exception_payload {
+		bool valid;
+		unsigned long value;
 		u8 nested_apf;
-	} exception;
+	} exception_payload;
+
+	struct kvm_queued_exception injected_exception;
 
 	struct kvm_queued_interrupt {
 		bool injected;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 34a37b2bd486..7adad9b6dcad 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -349,14 +349,14 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 	u32 exit_int_info = 0;
 	unsigned int nr;
 
-	if (vcpu->arch.exception.injected) {
-		nr = vcpu->arch.exception.nr;
+	if (vcpu->arch.injected_exception.valid) {
+		nr = vcpu->arch.injected_exception.nr;
 		exit_int_info = nr | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
 
-		if (vcpu->arch.exception.has_error_code) {
+		if (vcpu->arch.injected_exception.has_error_code) {
 			exit_int_info |= SVM_EVTINJ_VALID_ERR;
 			vmcb12->control.exit_int_info_err =
-				vcpu->arch.exception.error_code;
+				vcpu->arch.injected_exception.error_code;
 		}
 
 	} else if (vcpu->arch.nmi_injected) {
@@ -1000,30 +1000,30 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
 
 static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
-	unsigned int nr = svm->vcpu.arch.exception.nr;
+	unsigned int nr = svm->vcpu.arch.pending_exception.nr;
 
 	return (svm->nested.ctl.intercepts[INTERCEPT_EXCEPTION] & BIT(nr));
 }
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 {
-	unsigned int nr = svm->vcpu.arch.exception.nr;
+	unsigned int nr = svm->vcpu.arch.pending_exception.nr;
 
 	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
 	svm->vmcb->control.exit_code_hi = 0;
 
-	if (svm->vcpu.arch.exception.has_error_code)
-		svm->vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
+	if (svm->vcpu.arch.pending_exception.has_error_code)
+		svm->vmcb->control.exit_info_1 = svm->vcpu.arch.pending_exception.error_code;
 
 	/*
 	 * EXITINFO2 is undefined for all exception intercepts other
 	 * than #PF.
 	 */
 	if (nr == PF_VECTOR) {
-		if (svm->vcpu.arch.exception.nested_apf)
+		if (svm->vcpu.arch.exception_payload.nested_apf)
 			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
-		else if (svm->vcpu.arch.exception.has_payload)
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
+		else if (svm->vcpu.arch.exception_payload.valid)
+			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception_payload.value;
 		else
 			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 	} else if (nr == DB_VECTOR) {
@@ -1034,7 +1034,7 @@ static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 			kvm_update_dr7(&svm->vcpu);
 		}
 	} else
-		WARN_ON(svm->vcpu.arch.exception.has_payload);
+		WARN_ON(svm->vcpu.arch.exception_payload.valid);
 
 	nested_svm_vmexit(svm);
 }
@@ -1061,7 +1061,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.exception.pending) {
+	if (vcpu->arch.pending_exception.valid) {
 		/*
 		 * Only a pending nested run can block a pending exception.
 		 * Otherwise an injected NMI/interrupt should either be
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..90b541138c5a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -359,9 +359,9 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_error_code = vcpu->arch.exception.has_error_code;
-	u32 error_code = vcpu->arch.exception.error_code;
+	unsigned int nr = vcpu->arch.injected_exception.nr;
+	bool has_error_code = vcpu->arch.injected_exception.has_error_code;
+	u32 error_code = vcpu->arch.injected_exception.error_code;
 
 	kvm_deliver_exception_payload(vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c3ba842fc07f..5d54fecff9a7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -388,17 +388,17 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
 static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit_qual)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	unsigned int nr = vcpu->arch.exception.nr;
-	bool has_payload = vcpu->arch.exception.has_payload;
-	unsigned long payload = vcpu->arch.exception.payload;
+	unsigned int nr = vcpu->arch.pending_exception.nr;
+	bool has_payload = vcpu->arch.exception_payload.valid;
+	unsigned long payload = vcpu->arch.exception_payload.value;
 
 	if (nr == PF_VECTOR) {
-		if (vcpu->arch.exception.nested_apf) {
+		if (vcpu->arch.exception_payload.nested_apf) {
 			*exit_qual = vcpu->arch.apf.nested_apf_token;
 			return 1;
 		}
 		if (nested_vmx_is_page_fault_vmexit(vmcs12,
-						    vcpu->arch.exception.error_code)) {
+						    vcpu->arch.pending_exception.error_code)) {
 			*exit_qual = has_payload ? payload : vcpu->arch.cr2;
 			return 1;
 		}
@@ -3617,8 +3617,8 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	u32 idt_vectoring;
 	unsigned int nr;
 
-	if (vcpu->arch.exception.injected) {
-		nr = vcpu->arch.exception.nr;
+	if (vcpu->arch.injected_exception.valid) {
+		nr = vcpu->arch.injected_exception.nr;
 		idt_vectoring = nr | VECTORING_INFO_VALID_MASK;
 
 		if (kvm_exception_is_soft(nr)) {
@@ -3628,10 +3628,10 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 		} else
 			idt_vectoring |= INTR_TYPE_HARD_EXCEPTION;
 
-		if (vcpu->arch.exception.has_error_code) {
+		if (vcpu->arch.injected_exception.has_error_code) {
 			idt_vectoring |= VECTORING_INFO_DELIVER_CODE_MASK;
 			vmcs12->idt_vectoring_error_code =
-				vcpu->arch.exception.error_code;
+				vcpu->arch.injected_exception.error_code;
 		}
 
 		vmcs12->idt_vectoring_info_field = idt_vectoring;
@@ -3712,11 +3712,11 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 					       unsigned long exit_qual)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	unsigned int nr = vcpu->arch.exception.nr;
+	unsigned int nr = vcpu->arch.pending_exception.nr;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
-	if (vcpu->arch.exception.has_error_code) {
-		vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
+	if (vcpu->arch.pending_exception.has_error_code) {
+		vmcs12->vm_exit_intr_error_code = vcpu->arch.pending_exception.error_code;
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
@@ -3740,9 +3740,9 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
  */
 static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.exception.pending &&
-			vcpu->arch.exception.nr == DB_VECTOR &&
-			vcpu->arch.exception.payload;
+	return vcpu->arch.pending_exception.valid &&
+			vcpu->arch.pending_exception.nr == DB_VECTOR &&
+			vcpu->arch.exception_payload.value;
 }
 
 /*
@@ -3756,7 +3756,7 @@ static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 {
 	if (vmx_pending_dbg_trap(vcpu))
 		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-			    vcpu->arch.exception.payload);
+			    vcpu->arch.exception_payload.value);
 }
 
 static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
@@ -3813,7 +3813,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * while delivering the pending exception.
 	 */
 
-	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
+	if (vcpu->arch.pending_exception.valid && !vmx_pending_dbg_trap(vcpu)) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
@@ -3830,7 +3830,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.exception.pending) {
+	if (vcpu->arch.pending_exception.valid) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8a4a548e96b..a9b241d2b271 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1648,8 +1648,8 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * vmx_check_nested_events().
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
-	    (!vcpu->arch.exception.pending ||
-	     vcpu->arch.exception.nr == DB_VECTOR))
+	    (!vcpu->arch.pending_exception.valid ||
+	     vcpu->arch.pending_exception.nr == DB_VECTOR))
 		vmx->nested.mtf_pending = true;
 	else
 		vmx->nested.mtf_pending = false;
@@ -1677,9 +1677,9 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_error_code = vcpu->arch.exception.has_error_code;
-	u32 error_code = vcpu->arch.exception.error_code;
+	unsigned int nr = vcpu->arch.injected_exception.nr;
+	bool has_error_code = vcpu->arch.injected_exception.has_error_code;
+	u32 error_code = vcpu->arch.injected_exception.error_code;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
 	kvm_deliver_exception_payload(vcpu);
@@ -5397,7 +5397,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 			return 0;
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
-		    vcpu->arch.exception.pending) {
+		    vcpu->arch.pending_exception.valid) {
 			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 			vcpu->run->internal.suberror =
 						KVM_INTERNAL_ERROR_EMULATION;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d95f90a048..493d87b0c2d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -481,9 +481,9 @@ static int exception_type(int vector)
 
 void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 {
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_payload = vcpu->arch.exception.has_payload;
-	unsigned long payload = vcpu->arch.exception.payload;
+	unsigned int nr = vcpu->arch.pending_exception.nr;
+	bool has_payload = vcpu->arch.exception_payload.valid;
+	unsigned long payload = vcpu->arch.exception_payload.value;
 
 	if (!has_payload)
 		return;
@@ -529,8 +529,8 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	vcpu->arch.exception.has_payload = false;
-	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception_payload.valid = false;
+	vcpu->arch.exception_payload.value = 0;
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
@@ -543,7 +543,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
+	if (!vcpu->arch.pending_exception.valid && !vcpu->arch.injected_exception.valid) {
 	queue:
 		if (reinject) {
 			/*
@@ -554,8 +554,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 			 * and the guest shouldn't proceed far enough to
 			 * need reinjection.
 			 */
-			WARN_ON_ONCE(vcpu->arch.exception.pending);
-			vcpu->arch.exception.injected = true;
+			WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
 			if (WARN_ON_ONCE(has_payload)) {
 				/*
 				 * A reinjected event has already
@@ -564,22 +563,29 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 				has_payload = false;
 				payload = 0;
 			}
+
+			vcpu->arch.injected_exception.valid = true;
+			vcpu->arch.injected_exception.has_error_code = has_error;
+			vcpu->arch.injected_exception.nr = nr;
+			vcpu->arch.injected_exception.error_code = error_code;
+
 		} else {
-			vcpu->arch.exception.pending = true;
-			vcpu->arch.exception.injected = false;
+			vcpu->arch.pending_exception.valid = true;
+			vcpu->arch.injected_exception.valid = false;
+			vcpu->arch.pending_exception.has_error_code = has_error;
+			vcpu->arch.pending_exception.nr = nr;
+			vcpu->arch.pending_exception.error_code = error_code;
 		}
-		vcpu->arch.exception.has_error_code = has_error;
-		vcpu->arch.exception.nr = nr;
-		vcpu->arch.exception.error_code = error_code;
-		vcpu->arch.exception.has_payload = has_payload;
-		vcpu->arch.exception.payload = payload;
+
+		vcpu->arch.exception_payload.valid = has_payload;
+		vcpu->arch.exception_payload.value = payload;
 		if (!is_guest_mode(vcpu))
 			kvm_deliver_exception_payload(vcpu);
 		return;
 	}
 
 	/* to check exception */
-	prev_nr = vcpu->arch.exception.nr;
+	prev_nr = vcpu->arch.injected_exception.nr;
 	if (prev_nr == DF_VECTOR) {
 		/* triple fault -> shutdown */
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -594,13 +600,14 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		 * exception.pending = true so that the double fault
 		 * can trigger a nested vmexit.
 		 */
-		vcpu->arch.exception.pending = true;
-		vcpu->arch.exception.injected = false;
-		vcpu->arch.exception.has_error_code = true;
-		vcpu->arch.exception.nr = DF_VECTOR;
-		vcpu->arch.exception.error_code = 0;
-		vcpu->arch.exception.has_payload = false;
-		vcpu->arch.exception.payload = 0;
+		vcpu->arch.pending_exception.valid = true;
+		vcpu->arch.injected_exception.valid = false;
+		vcpu->arch.pending_exception.has_error_code = true;
+		vcpu->arch.pending_exception.nr = DF_VECTOR;
+		vcpu->arch.pending_exception.error_code = 0;
+
+		vcpu->arch.exception_payload.valid = false;
+		vcpu->arch.exception_payload.value = 0;
 	} else
 		/* replace previous exception with a new one in a hope
 		   that instruction re-execution will regenerate lost
@@ -648,9 +655,9 @@ EXPORT_SYMBOL_GPL(kvm_complete_insn_gp);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
 	++vcpu->stat.pf_guest;
-	vcpu->arch.exception.nested_apf =
+	vcpu->arch.exception_payload.nested_apf =
 		is_guest_mode(vcpu) && fault->async_page_fault;
-	if (vcpu->arch.exception.nested_apf) {
+	if (vcpu->arch.exception_payload.nested_apf) {
 		vcpu->arch.apf.nested_apf_token = fault->address;
 		kvm_queue_exception_e(vcpu, PF_VECTOR, fault->error_code);
 	} else {
@@ -4269,6 +4276,7 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 					       struct kvm_vcpu_events *events)
 {
+	struct kvm_queued_exception *exc;
 	process_nmi(vcpu);
 
 	if (kvm_check_request(KVM_REQ_SMI, vcpu))
@@ -4286,21 +4294,27 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	 * KVM_GET_VCPU_EVENTS.
 	 */
 	if (!vcpu->kvm->arch.exception_payload_enabled &&
-	    vcpu->arch.exception.pending && vcpu->arch.exception.has_payload)
+	    vcpu->arch.pending_exception.valid && vcpu->arch.exception_payload.valid)
 		kvm_deliver_exception_payload(vcpu);
 
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid &&
+		     vcpu->arch.injected_exception.valid);
+
+	exc = vcpu->arch.pending_exception.valid ? &vcpu->arch.pending_exception :
+						   &vcpu->arch.injected_exception;
+
 	/*
 	 * The API doesn't provide the instruction length for software
 	 * exceptions, so don't report them. As long as the guest RIP
 	 * isn't advanced, we should expect to encounter the exception
 	 * again.
 	 */
-	if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
+	if (kvm_exception_is_soft(exc->nr)) {
 		events->exception.injected = 0;
 		events->exception.pending = 0;
 	} else {
-		events->exception.injected = vcpu->arch.exception.injected;
-		events->exception.pending = vcpu->arch.exception.pending;
+		events->exception.injected = vcpu->arch.injected_exception.valid;
+		events->exception.pending = vcpu->arch.pending_exception.valid;
 		/*
 		 * For ABI compatibility, deliberately conflate
 		 * pending and injected exceptions when
@@ -4308,13 +4322,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		 */
 		if (!vcpu->kvm->arch.exception_payload_enabled)
 			events->exception.injected |=
-				vcpu->arch.exception.pending;
+				vcpu->arch.pending_exception.valid;
 	}
-	events->exception.nr = vcpu->arch.exception.nr;
-	events->exception.has_error_code = vcpu->arch.exception.has_error_code;
-	events->exception.error_code = vcpu->arch.exception.error_code;
-	events->exception_has_payload = vcpu->arch.exception.has_payload;
-	events->exception_payload = vcpu->arch.exception.payload;
+	events->exception.nr = exc->nr;
+	events->exception.has_error_code = exc->has_error_code;
+	events->exception.error_code = exc->error_code;
+
+	events->exception_has_payload = vcpu->arch.exception_payload.valid;
+	events->exception_payload = vcpu->arch.exception_payload.value;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -4349,6 +4364,8 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu);
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
 {
+	struct kvm_queued_exception *exc;
+
 	if (events->flags & ~(KVM_VCPUEVENT_VALID_NMI_PENDING
 			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			      | KVM_VCPUEVENT_VALID_SHADOW
@@ -4368,6 +4385,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		events->exception_has_payload = 0;
 	}
 
+	exc = events->exception.pending ? &vcpu->arch.pending_exception :
+					  &vcpu->arch.injected_exception;
+
+	vcpu->arch.pending_exception.valid = false;
+	vcpu->arch.injected_exception.valid = false;
+
 	if ((events->exception.injected || events->exception.pending) &&
 	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
 		return -EINVAL;
@@ -4379,13 +4402,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	process_nmi(vcpu);
-	vcpu->arch.exception.injected = events->exception.injected;
-	vcpu->arch.exception.pending = events->exception.pending;
-	vcpu->arch.exception.nr = events->exception.nr;
-	vcpu->arch.exception.has_error_code = events->exception.has_error_code;
-	vcpu->arch.exception.error_code = events->exception.error_code;
-	vcpu->arch.exception.has_payload = events->exception_has_payload;
-	vcpu->arch.exception.payload = events->exception_payload;
+
+	exc->nr = events->exception.nr;
+	exc->has_error_code = events->exception.has_error_code;
+	exc->error_code = events->exception.error_code;
+
+	vcpu->arch.exception_payload.valid = events->exception_has_payload;
+	vcpu->arch.exception_payload.value = events->exception_payload;
 
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -8378,8 +8401,8 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
-		vcpu->arch.exception.error_code = false;
+	if (vcpu->arch.injected_exception.error_code && !is_protmode(vcpu))
+		vcpu->arch.injected_exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
 }
 
@@ -8390,7 +8413,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 
 	/* try to reinject previous events if any */
 
-	if (vcpu->arch.exception.injected) {
+	if (vcpu->arch.injected_exception.valid) {
 		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
@@ -8408,7 +8431,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 * serviced prior to recognizing any new events in order to
 	 * fully complete the previous instruction.
 	 */
-	else if (!vcpu->arch.exception.pending) {
+	else if (!vcpu->arch.pending_exception.valid) {
 		if (vcpu->arch.nmi_injected) {
 			static_call(kvm_x86_set_nmi)(vcpu);
 			can_inject = false;
@@ -8418,8 +8441,8 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		}
 	}
 
-	WARN_ON_ONCE(vcpu->arch.exception.injected &&
-		     vcpu->arch.exception.pending);
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid &&
+		     vcpu->arch.injected_exception.valid);
 
 	/*
 	 * Call check_nested_events() even if we reinjected a previous event
@@ -8434,19 +8457,19 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	}
 
 	/* try to inject new event if pending */
-	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
+	if (vcpu->arch.pending_exception.valid) {
+		trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
+					vcpu->arch.pending_exception.has_error_code,
+					vcpu->arch.pending_exception.error_code);
 
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
+		vcpu->arch.injected_exception = vcpu->arch.pending_exception;
+		vcpu->arch.pending_exception.valid = false;
 
-		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
+		if (exception_type(vcpu->arch.injected_exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
 
-		if (vcpu->arch.exception.nr == DB_VECTOR) {
+		if (vcpu->arch.injected_exception.nr == DB_VECTOR) {
 			kvm_deliver_exception_payload(vcpu);
 			if (vcpu->arch.dr7 & DR7_GD) {
 				vcpu->arch.dr7 &= ~DR7_GD;
@@ -8515,7 +8538,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
 		*req_immediate_exit = true;
 
-	WARN_ON(vcpu->arch.exception.pending);
+	WARN_ON(vcpu->arch.pending_exception.valid);
 	return;
 
 busy:
@@ -9624,7 +9647,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_rip_write(vcpu, regs->rip);
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
 
-	vcpu->arch.exception.pending = false;
+	vcpu->arch.pending_exception.valid = false;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
@@ -9910,7 +9933,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
 		r = -EBUSY;
-		if (vcpu->arch.exception.pending)
+		if (vcpu->arch.pending_exception.valid)
 			goto out;
 		if (dbg->control & KVM_GUESTDBG_INJECT_DB)
 			kvm_queue_exception(vcpu, DB_VECTOR);
@@ -10991,7 +11014,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.pv.pv_unhalted)
 		return true;
 
-	if (vcpu->arch.exception.pending)
+	if (vcpu->arch.pending_exception.valid)
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
@@ -11231,7 +11254,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 {
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
-		     vcpu->arch.exception.pending))
+		     vcpu->arch.pending_exception.valid))
 		return false;
 
 	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index daccf20fbcd5..21d62387f5e6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -60,8 +60,8 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.exception.pending = false;
-	vcpu->arch.exception.injected = false;
+	vcpu->arch.pending_exception.valid = false;
+	vcpu->arch.injected_exception.valid = false;
 }
 
 static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector,
@@ -79,7 +79,7 @@ static inline void kvm_clear_interrupt_queue(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_event_needs_reinjection(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.exception.injected || vcpu->arch.interrupt.injected ||
+	return vcpu->arch.injected_exception.valid || vcpu->arch.interrupt.injected ||
 		vcpu->arch.nmi_injected;
 }
 
-- 
2.26.2

