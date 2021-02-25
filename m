Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6C32529F
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhBYPn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 10:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232746AbhBYPni (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 10:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614267729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=78uOJ39WvMWT8RyHTA+Sces89b77hWOIaC25PmJOzXo=;
        b=iYSlIi2uf1pOwcWAUEo2cW463uFSMzfWJTjepXmNV02H4tLYmU5ahn90/WGvVbd+qLYf+Z
        nEBdpNO9TwkCuRZKvjsUAfsyXJ3Vq5CqqwOuTiHs5Btq44kK5Uc6xuUZJYjH7odpPpvFhU
        51puIRwUeNajxijKJs8KvulUSPJaqL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-voXP22NeOMajNsgqkEeXFA-1; Thu, 25 Feb 2021 10:42:00 -0500
X-MC-Unique: voXP22NeOMajNsgqkEeXFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCCAF107ACE6;
        Thu, 25 Feb 2021 15:41:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 440865B4A0;
        Thu, 25 Feb 2021 15:41:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/4] kvm: WIP separation of injected and pending exception
Date:   Thu, 25 Feb 2021 17:41:35 +0200
Message-Id: <20210225154135.405125-5-mlevitsk@redhat.com>
In-Reply-To: <20210225154135.405125-1-mlevitsk@redhat.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  23 +-
 arch/x86/include/uapi/asm/kvm.h |  14 +-
 arch/x86/kvm/svm/nested.c       |  62 +++---
 arch/x86/kvm/svm/svm.c          |   8 +-
 arch/x86/kvm/vmx/nested.c       | 114 +++++-----
 arch/x86/kvm/vmx/vmx.c          |  14 +-
 arch/x86/kvm/x86.c              | 370 +++++++++++++++++++-------------
 arch/x86/kvm/x86.h              |   6 +-
 include/uapi/linux/kvm.h        |   1 +
 9 files changed, 367 insertions(+), 245 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4aa48fb55361d..190e245aa6670 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -637,16 +637,22 @@ struct kvm_vcpu_arch {
 
 	u8 event_exit_inst_len;
 
-	struct kvm_queued_exception {
-		bool pending;
-		bool injected;
+	struct kvm_pending_exception {
+		bool valid;
 		bool has_error_code;
 		u8 nr;
 		u32 error_code;
 		unsigned long payload;
 		bool has_payload;
 		u8 nested_apf;
-	} exception;
+	} pending_exception;
+
+	struct kvm_queued_exception {
+		bool valid;
+		bool has_error_code;
+		u8 nr;
+		u32 error_code;
+	} injected_exception;
 
 	struct kvm_queued_interrupt {
 		bool injected;
@@ -1018,6 +1024,7 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool exception_separate_injected_pending;
 
 	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
 	u32 user_space_msr_mask;
@@ -1351,6 +1358,14 @@ struct kvm_x86_ops {
 
 struct kvm_x86_nested_ops {
 	int (*check_events)(struct kvm_vcpu *vcpu);
+
+	/*
+	 * return value: 0 - delivered vm exit, 1 - exception not intercepted,
+	 * negative - failure
+	 * */
+
+	int (*deliver_exception)(struct kvm_vcpu *vcpu);
+
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a3022c8af82b..9556e420e8ecb 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -345,9 +345,17 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u8 reserved[27];
-	__u8 exception_has_payload;
-	__u64 exception_payload;
+
+	__u8 reserved[20];
+
+	struct {
+		__u32 error_code;
+		__u8 nr;
+		__u8 pad;
+		__u8 has_error_code;
+		__u8 has_payload;
+		__u64 payload;
+	} pending_exception;
 };
 
 /* for KVM_GET/SET_DEBUGREGS */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c82abce0ea0c..9df01b6e2e091 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -315,15 +315,16 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
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
+		vcpu->arch.injected_exception.valid = false;
 
 	} else if (vcpu->arch.nmi_injected) {
 		exit_int_info = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
@@ -923,30 +924,30 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
 
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
+		if (svm->vcpu.arch.pending_exception.nested_apf)
 			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
-		else if (svm->vcpu.arch.exception.has_payload)
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
+		else if (svm->vcpu.arch.pending_exception.has_payload)
+			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.pending_exception.payload;
 		else
 			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 	} else if (nr == DB_VECTOR) {
@@ -957,7 +958,7 @@ static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 			kvm_update_dr7(&svm->vcpu);
 		}
 	} else
-		WARN_ON(svm->vcpu.arch.exception.has_payload);
+		WARN_ON(svm->vcpu.arch.pending_exception.has_payload);
 
 	nested_svm_vmexit(svm);
 }
@@ -1023,20 +1024,6 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.exception.pending) {
-		/*
-		 * Only pending nested run can block an pending exception
-		 * Otherwise an injected NMI/interrupt should either be
-		 * lost or delivered to the nested hypervisor in EXITINTINFO
-		 * */
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
@@ -1063,7 +1050,29 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		nested_svm_intr(svm);
 		return 0;
 	}
+	return 0;
+}
+
+int svm_deliver_nested_exception(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * Only pending exception can cause vm exit.
+	 * Injected exception are either already started delivery
+	 * or came from nested EVENTINJ which doesn't check intercepts
+	 */
+
+	if (!vcpu->arch.pending_exception.valid)
+		return 1;
+
+	if(svm->nested.nested_run_pending)
+		return -EBUSY;
+
+	if (!nested_exit_on_exception(svm))
+		return 1;
 
+	nested_svm_inject_exception_vmexit(svm);
 	return 0;
 }
 
@@ -1302,6 +1311,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
+	.deliver_exception = svm_deliver_nested_exception,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cdbbda37b9419..0a1857f5fe55e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -363,11 +363,11 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_error_code = vcpu->arch.exception.has_error_code;
-	u32 error_code = vcpu->arch.exception.error_code;
+	unsigned nr = vcpu->arch.injected_exception.nr;
+	bool has_error_code = vcpu->arch.injected_exception.has_error_code;
+	u32 error_code = vcpu->arch.injected_exception.error_code;
 
-	kvm_deliver_exception_payload(vcpu);
+	WARN_ON(vcpu->arch.pending_exception.valid);
 
 	if (nr == BP_VECTOR && !nrips) {
 		unsigned long rip, old_rip = kvm_rip_read(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 20ed1a351b2d9..be9c4e449aafd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -388,17 +388,19 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
 static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit_qual)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	unsigned int nr = vcpu->arch.exception.nr;
-	bool has_payload = vcpu->arch.exception.has_payload;
-	unsigned long payload = vcpu->arch.exception.payload;
+	unsigned int nr = vcpu->arch.pending_exception.nr;
+	bool has_payload = vcpu->arch.pending_exception.has_payload;
+	unsigned long payload = vcpu->arch.pending_exception.payload;
+
+	/* injected exception doesn't need checking here */
 
 	if (nr == PF_VECTOR) {
-		if (vcpu->arch.exception.nested_apf) {
+		if (vcpu->arch.pending_exception.nested_apf) {
 			*exit_qual = vcpu->arch.apf.nested_apf_token;
 			return 1;
 		}
 		if (nested_vmx_is_page_fault_vmexit(vmcs12,
-						    vcpu->arch.exception.error_code)) {
+						    vcpu->arch.pending_exception.error_code)) {
 			*exit_qual = has_payload ? payload : vcpu->arch.cr2;
 			return 1;
 		}
@@ -3621,8 +3623,8 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	u32 idt_vectoring;
 	unsigned int nr;
 
-	if (vcpu->arch.exception.injected) {
-		nr = vcpu->arch.exception.nr;
+	if (vcpu->arch.injected_exception.valid) {
+		nr = vcpu->arch.injected_exception.nr;
 		idt_vectoring = nr | VECTORING_INFO_VALID_MASK;
 
 		if (kvm_exception_is_soft(nr)) {
@@ -3632,10 +3634,10 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
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
@@ -3716,11 +3718,11 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
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
 
@@ -3744,9 +3746,9 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
  */
 static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.exception.pending &&
-			vcpu->arch.exception.nr == DB_VECTOR &&
-			vcpu->arch.exception.payload;
+	return vcpu->arch.pending_exception.valid &&
+			vcpu->arch.pending_exception.nr == DB_VECTOR &&
+			vcpu->arch.pending_exception.payload;
 }
 
 /*
@@ -3760,7 +3762,7 @@ static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 {
 	if (vmx_pending_dbg_trap(vcpu))
 		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-			    vcpu->arch.exception.payload);
+			    vcpu->arch.pending_exception.payload);
 }
 
 static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
@@ -3772,10 +3774,8 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
-	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	/*
@@ -3808,39 +3808,6 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	/*
-	 * Process any exceptions that are not debug traps before MTF.
-	 *
-	 * Note that only pending nested run can block an pending exception
-	 * Otherwise an injected NMI/interrupt should either be
-	 * lost or delivered to the nested hypervisor in EXITINTINFO
-	 */
-
-	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
-		if (vmx->nested.nested_run_pending)
-			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
-	}
-
-	if (mtf_pending) {
-		if (block_nested_events)
-			return -EBUSY;
-		nested_vmx_update_pending_dbg(vcpu);
-		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
-		return 0;
-	}
-
-	if (vcpu->arch.exception.pending) {
-		if (vmx->nested.nested_run_pending)
-			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
-	}
 
 	if (nested_vmx_preemption_timer_pending(vcpu)) {
 		if (block_nested_events)
@@ -3887,6 +3854,50 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int nested_vmx_deliver_nested_exception(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long exit_qual;
+
+
+	if (!vcpu->arch.pending_exception.valid && !vmx->nested.mtf_pending)
+		return 1;
+
+	if(vmx->nested.nested_run_pending)
+		return -EBUSY;
+
+	/*
+	 * Process any exceptions that are not debug traps before MTF.
+	 *
+	 * Note that only pending nested run can block an pending exception
+	 * Otherwise an injected NMI/interrupt should either be
+	 * lost or delivered to the nested hypervisor in EXITINTINFO
+	 */
+
+	if (vcpu->arch.pending_exception.valid && !vmx_pending_dbg_trap(vcpu)) {
+		if (!nested_vmx_check_exception(vcpu, &exit_qual))
+			goto no_vmexit;
+		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
+		return 0;
+	}
+
+	if (vmx->nested.mtf_pending) {
+		/* TODO: check this */
+		nested_vmx_update_pending_dbg(vcpu);
+		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
+		return 0;
+	}
+
+	if (vcpu->arch.pending_exception.valid) {
+		if (!nested_vmx_check_exception(vcpu, &exit_qual))
+			goto no_vmexit;
+		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
+		return 0;
+	}
+no_vmexit:
+	return 1;
+}
+
 static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
 {
 	ktime_t remaining =
@@ -6598,6 +6609,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
 	.check_events = vmx_check_nested_events,
+	.deliver_exception = nested_vmx_deliver_nested_exception,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2714d22228de..d480bd48d786f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1630,8 +1630,8 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
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
@@ -1659,12 +1659,12 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_error_code = vcpu->arch.exception.has_error_code;
-	u32 error_code = vcpu->arch.exception.error_code;
+	unsigned nr = vcpu->arch.injected_exception.nr;
+	bool has_error_code = vcpu->arch.injected_exception.has_error_code;
+	u32 error_code = vcpu->arch.injected_exception.error_code;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
-	kvm_deliver_exception_payload(vcpu);
+	WARN_ON(vcpu->arch.pending_exception.valid);
 
 	if (has_error_code) {
 		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
@@ -5400,7 +5400,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 			return 0;
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
-		    vcpu->arch.exception.pending) {
+		    vcpu->arch.pending_exception.valid) {
 			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 			vcpu->run->internal.suberror =
 						KVM_INTERNAL_ERROR_EMULATION;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9d814a0b5e4f..eec62c0dafc36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -480,9 +480,9 @@ static int exception_type(int vector)
 
 void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 {
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_payload = vcpu->arch.exception.has_payload;
-	unsigned long payload = vcpu->arch.exception.payload;
+	unsigned nr = vcpu->arch.pending_exception.nr;
+	bool has_payload = vcpu->arch.pending_exception.has_payload;
+	unsigned long payload = vcpu->arch.pending_exception.payload;
 
 	if (!has_payload)
 		return;
@@ -528,83 +528,130 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	vcpu->arch.exception.has_payload = false;
-	vcpu->arch.exception.payload = 0;
+	vcpu->arch.pending_exception.has_payload = false;
+	vcpu->arch.pending_exception.payload = 0;
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
-static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
-		unsigned nr, bool has_error, u32 error_code,
-	        bool has_payload, unsigned long payload, bool reinject)
+
+/*
+ * Delivers exception payload and converts/merges current pending
+ * exception with injected exception (if any) and writes
+ * result to injected exception
+ */
+int kvm_deliver_pending_exception(struct kvm_vcpu *vcpu)
 {
-	u32 prev_nr;
-	int class1, class2;
+	while (vcpu->arch.pending_exception.valid) {
+		u32 prev_nr;
+		int class1, class2;
 
-	kvm_make_request(KVM_REQ_EVENT, vcpu);
+		/* try to deliver current pending exception as VM exit */
+		if (is_guest_mode(vcpu)) {
+			int ret = kvm_x86_ops.nested_ops->deliver_exception(vcpu);
+			if (ret <= 0)
+				return ret;
+		}
 
-	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
-	queue:
-		if (reinject) {
-			/*
-			 * On vmentry, vcpu->arch.exception.pending is only
-			 * true if an event injection was blocked by
-			 * nested_run_pending.  In that case, however,
-			 * vcpu_enter_guest requests an immediate exit,
-			 * and the guest shouldn't proceed far enough to
-			 * need reinjection.
+		/* No injected exception, so just deliver the payload and inject it */
+		if (!vcpu->arch.injected_exception.valid) {
+
+			trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
+						vcpu->arch.pending_exception.has_error_code,
+						vcpu->arch.pending_exception.error_code);
+
+			/* Intel SDM 17.3.1.1 */
+			if (exception_type(vcpu->arch.pending_exception.nr) == EXCPT_FAULT)
+				__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
+						     X86_EFLAGS_RF);
+
+			kvm_deliver_exception_payload(vcpu);
+
+			/* Intel SDM 17.2.4
+			 * The processor clears the GD flag upon entering to the
+			 * debug exception handler, to allow the handler access
+			 * to the debug registers.
 			 */
-			WARN_ON_ONCE(vcpu->arch.exception.pending);
-			vcpu->arch.exception.injected = true;
-			if (WARN_ON_ONCE(has_payload)) {
-				/*
-				 * A reinjected event has already
-				 * delivered its payload.
-				 */
-				has_payload = false;
-				payload = 0;
+			if (vcpu->arch.pending_exception.nr == DB_VECTOR) {
+				if (vcpu->arch.dr7 & DR7_GD) {
+					vcpu->arch.dr7 &= ~DR7_GD;
+					kvm_update_dr7(vcpu);
+				}
 			}
-		} else {
-			vcpu->arch.exception.pending = true;
-			vcpu->arch.exception.injected = false;
+
+			if (vcpu->arch.pending_exception.error_code && !is_protmode(vcpu))
+				vcpu->arch.pending_exception.error_code = false;
+
+			vcpu->arch.pending_exception.valid = false;
+			vcpu->arch.injected_exception.valid = true;
+			vcpu->arch.injected_exception.has_error_code = vcpu->arch.pending_exception.has_error_code;
+			vcpu->arch.injected_exception.nr = vcpu->arch.pending_exception.nr;
+			vcpu->arch.injected_exception.error_code = vcpu->arch.pending_exception.error_code;
+			return 0;
+		}
+
+		/* Convert both pending and injected exception to triple fault*/
+		prev_nr = vcpu->arch.injected_exception.nr;
+		if (prev_nr == DF_VECTOR) {
+			/* triple fault -> shutdown */
+			vcpu->arch.injected_exception.valid = false;
+			vcpu->arch.pending_exception.valid = false;
+
+			/* TODO - make KVM_REQ_TRIPLE_FAULT inject vmexit when guest intercepts it */
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+			break;
+		}
+
+		class1 = exception_class(prev_nr);
+		class2 = exception_class(vcpu->arch.pending_exception.nr);
+
+		vcpu->arch.injected_exception.valid = false;
+
+		if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
+			|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
+			/* Generate double fault per SDM Table 5-5. */
+			vcpu->arch.pending_exception.has_error_code = true;
+			vcpu->arch.pending_exception.nr = DF_VECTOR;
+			vcpu->arch.pending_exception.error_code = 0;
+			vcpu->arch.pending_exception.has_payload = false;
 		}
-		vcpu->arch.exception.has_error_code = has_error;
-		vcpu->arch.exception.nr = nr;
-		vcpu->arch.exception.error_code = error_code;
-		vcpu->arch.exception.has_payload = has_payload;
-		vcpu->arch.exception.payload = payload;
-		if (!is_guest_mode(vcpu))
-			kvm_deliver_exception_payload(vcpu);
-		return;
 	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_deliver_pending_exception);
 
-	/* to check exception */
-	prev_nr = vcpu->arch.exception.nr;
-	if (prev_nr == DF_VECTOR) {
-		/* triple fault -> shutdown */
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
-		return;
+static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
+	        unsigned nr, bool has_error, u32 error_code,
+	        bool has_payload, unsigned long payload, bool reinject)
+{
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	if (reinject) {
+		// exceptions are re-injected right after VM exit,
+		// before we are able to generate another
+		// pending exception
+		if (WARN_ON_ONCE(vcpu->arch.pending_exception.valid))
+			return;
+		// it is not possible to inject more that one exception
+		if (WARN_ON_ONCE(vcpu->arch.injected_exception.valid))
+			return;
+		vcpu->arch.injected_exception.valid = true;
+		vcpu->arch.injected_exception.nr = nr;
+		vcpu->arch.injected_exception.has_error_code = has_error;
+		vcpu->arch.injected_exception.error_code = error_code;
+
+		// re-injected exception has its payload already delivered
+		WARN_ON_ONCE(has_payload);
+	} else {
+		// can't have more that one pending exception
+		if (WARN_ON_ONCE(vcpu->arch.pending_exception.valid))
+			return;
+		vcpu->arch.pending_exception.valid = true;
+		vcpu->arch.pending_exception.nr = nr;
+		vcpu->arch.pending_exception.has_error_code = has_error;
+		vcpu->arch.pending_exception.error_code = error_code;
+		vcpu->arch.pending_exception.has_payload = has_payload;
+		vcpu->arch.pending_exception.payload = payload;
 	}
-	class1 = exception_class(prev_nr);
-	class2 = exception_class(nr);
-	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
-		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
-		/*
-		 * Generate double fault per SDM Table 5-5.  Set
-		 * exception.pending = true so that the double fault
-		 * can trigger a nested vmexit.
-		 */
-		vcpu->arch.exception.pending = true;
-		vcpu->arch.exception.injected = false;
-		vcpu->arch.exception.has_error_code = true;
-		vcpu->arch.exception.nr = DF_VECTOR;
-		vcpu->arch.exception.error_code = 0;
-		vcpu->arch.exception.has_payload = false;
-		vcpu->arch.exception.payload = 0;
-	} else
-		/* replace previous exception with a new one in a hope
-		   that instruction re-execution will regenerate lost
-		   exception */
-		goto queue;
 }
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
@@ -647,9 +694,9 @@ EXPORT_SYMBOL_GPL(kvm_complete_insn_gp);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
 	++vcpu->stat.pf_guest;
-	vcpu->arch.exception.nested_apf =
+	vcpu->arch.pending_exception.nested_apf =
 		is_guest_mode(vcpu) && fault->async_page_fault;
-	if (vcpu->arch.exception.nested_apf) {
+	if (vcpu->arch.pending_exception.nested_apf) {
 		vcpu->arch.apf.nested_apf_token = fault->address;
 		kvm_queue_exception_e(vcpu, PF_VECTOR, fault->error_code);
 	} else {
@@ -4267,47 +4314,69 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	if (kvm_check_request(KVM_REQ_SMI, vcpu))
 		process_smi(vcpu);
 
+	events->exception.injected = 0;
+	events->exception.pending = 0;
+	events->pending_exception.has_payload = 0;
+	events->pending_exception.payload = 0;
+
+	/* In unlikely case when we have both pending and injected exception and userspace didn't enable
+	 * KVM_CAP_EXCEPTION_INJECTED_PENDING deliver the pending exception now
+	 */
+	if (!vcpu->kvm->arch.exception_separate_injected_pending) {
+		if (vcpu->arch.pending_exception.valid && vcpu->arch.injected_exception.valid)
+			if (kvm_deliver_pending_exception(vcpu) < 0)
+				/* in case the delivery fails, we
+				 * forget about the injected exception */
+				vcpu->arch.injected_exception.valid = false;
+	}
+
 	/*
-	 * In guest mode, payload delivery should be deferred,
-	 * so that the L1 hypervisor can intercept #PF before
-	 * CR2 is modified (or intercept #DB before DR6 is
-	 * modified under nVMX). Unless the per-VM capability,
+	 * Unless the per-VM capability,
 	 * KVM_CAP_EXCEPTION_PAYLOAD, is set, we may not defer the delivery of
 	 * an exception payload and handle after a KVM_GET_VCPU_EVENTS. Since we
 	 * opportunistically defer the exception payload, deliver it if the
 	 * capability hasn't been requested before processing a
 	 * KVM_GET_VCPU_EVENTS.
 	 */
+
 	if (!vcpu->kvm->arch.exception_payload_enabled &&
-	    vcpu->arch.exception.pending && vcpu->arch.exception.has_payload)
+	    vcpu->arch.pending_exception.valid && vcpu->arch.pending_exception.valid)
 		kvm_deliver_exception_payload(vcpu);
 
+	if (vcpu->arch.pending_exception.valid &&
+	    !kvm_exception_is_soft(vcpu->arch.pending_exception.nr)) {
+
+		events->exception.pending = true;
+		events->pending_exception.has_payload = vcpu->arch.pending_exception.has_payload;
+		events->pending_exception.payload = vcpu->arch.pending_exception.payload;
+
+		/* TODO: this code looks ugly */
+		if (vcpu->kvm->arch.exception_separate_injected_pending) {
+			events->pending_exception.has_error_code = vcpu->arch.pending_exception.has_error_code;
+			events->pending_exception.error_code = vcpu->arch.pending_exception.error_code;
+			events->pending_exception.nr = vcpu->arch.pending_exception.nr;
+		} else {
+			events->exception.has_error_code = vcpu->arch.pending_exception.has_error_code;
+			events->exception.error_code = vcpu->arch.pending_exception.error_code;
+			events->exception.nr = vcpu->arch.pending_exception.nr;
+		}
+	}
+
+	if (vcpu->arch.injected_exception.valid &&
+	    !kvm_exception_is_soft(vcpu->arch.injected_exception.nr)) {
+		events->exception.injected = true;
+		events->exception.nr = vcpu->arch.injected_exception.nr;
+		events->exception.has_error_code = vcpu->arch.injected_exception.has_error_code;
+		events->exception.error_code = vcpu->arch.injected_exception.error_code;
+	}
+
 	/*
-	 * The API doesn't provide the instruction length for software
-	 * exceptions, so don't report them. As long as the guest RIP
-	 * isn't advanced, we should expect to encounter the exception
-	 * again.
+	 * For ABI compatibility, deliberately conflate
+	 * pending and injected exceptions when
+	 * KVM_CAP_EXCEPTION_PAYLOAD isn't enabled.
 	 */
-	if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
-		events->exception.injected = 0;
-		events->exception.pending = 0;
-	} else {
-		events->exception.injected = vcpu->arch.exception.injected;
-		events->exception.pending = vcpu->arch.exception.pending;
-		/*
-		 * For ABI compatibility, deliberately conflate
-		 * pending and injected exceptions when
-		 * KVM_CAP_EXCEPTION_PAYLOAD isn't enabled.
-		 */
-		if (!vcpu->kvm->arch.exception_payload_enabled)
-			events->exception.injected |=
-				vcpu->arch.exception.pending;
-	}
-	events->exception.nr = vcpu->arch.exception.nr;
-	events->exception.has_error_code = vcpu->arch.exception.has_error_code;
-	events->exception.error_code = vcpu->arch.exception.error_code;
-	events->exception_has_payload = vcpu->arch.exception.has_payload;
-	events->exception_payload = vcpu->arch.exception.payload;
+	if (!vcpu->kvm->arch.exception_payload_enabled)
+		events->exception.injected |= vcpu->arch.pending_exception.valid;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -4339,6 +4408,11 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 static void kvm_smm_changed(struct kvm_vcpu *vcpu);
 
+static bool is_valid_exception(int nr)
+{
+	return nr < 32 && nr != NMI_VECTOR;
+}
+
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
 {
@@ -4355,16 +4429,21 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		if (events->exception.pending)
 			events->exception.injected = 0;
 		else
-			events->exception_has_payload = 0;
+			events->pending_exception.has_payload = 0;
 	} else {
 		events->exception.pending = 0;
-		events->exception_has_payload = 0;
+		events->pending_exception.has_payload = 0;
 	}
 
 	if ((events->exception.injected || events->exception.pending) &&
-	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
+	    (!is_valid_exception(events->exception.nr)))
 		return -EINVAL;
 
+	if (vcpu->kvm->arch.exception_separate_injected_pending)
+		if (events->exception.pending &&
+		    !is_valid_exception(events->pending_exception.nr))
+			return -EINVAL;
+
 	/* INITs are latched while in SMM */
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM &&
 	    (events->smi.smm || events->smi.pending) &&
@@ -4372,13 +4451,30 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
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
+	if (events->exception.injected) {
+		vcpu->arch.injected_exception.valid = true;
+		vcpu->arch.injected_exception.nr = events->exception.nr;
+		vcpu->arch.injected_exception.has_error_code = events->exception.has_error_code;
+		vcpu->arch.injected_exception.error_code = events->exception.error_code;
+	}
+
+	if (events->exception.pending) {
+		vcpu->arch.pending_exception.valid = true;
+
+		if (vcpu->kvm->arch.exception_separate_injected_pending) {
+			vcpu->arch.pending_exception.nr = events->pending_exception.nr;
+			vcpu->arch.pending_exception.has_error_code = events->pending_exception.has_error_code;
+			vcpu->arch.pending_exception.error_code = events->pending_exception.error_code;
+		} else {
+			vcpu->arch.pending_exception.nr = events->exception.nr;
+			vcpu->arch.pending_exception.has_error_code = events->exception.has_error_code;
+			vcpu->arch.pending_exception.error_code = events->exception.error_code;
+		}
+
+		vcpu->arch.pending_exception.has_payload = events->pending_exception.has_payload;
+		vcpu->arch.pending_exception.payload = events->pending_exception.payload;
+	}
 
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -5347,6 +5443,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_EXCEPTION_INJECTED_PENDING:
+		kvm->arch.exception_separate_injected_pending = cap->args[0];
+		r = 0;
+		break;
+
 	case KVM_CAP_X86_USER_SPACE_MSR:
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
@@ -8345,8 +8446,6 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
-		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
 }
 
@@ -8355,9 +8454,14 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	int r;
 	bool can_inject = true;
 
-	/* try to reinject previous events if any */
+	r = kvm_deliver_pending_exception(vcpu);
+	if (r < 0)
+		goto busy;
+
+	WARN_ON_ONCE(vcpu->arch.pending_exception.valid);
 
-	if (vcpu->arch.exception.injected) {
+	/* try to reinject previous events if any */
+	if (vcpu->arch.injected_exception.valid) {
 		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
@@ -8375,7 +8479,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	 * serviced prior to recognizing any new events in order to
 	 * fully complete the previous instruction.
 	 */
-	else if (!vcpu->arch.exception.pending) {
+	else {
 		if (vcpu->arch.nmi_injected) {
 			static_call(kvm_x86_set_nmi)(vcpu);
 			can_inject = false;
@@ -8385,9 +8489,6 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		}
 	}
 
-	WARN_ON_ONCE(vcpu->arch.exception.injected &&
-		     vcpu->arch.exception.pending);
-
 	/*
 	 * Call check_nested_events() even if we reinjected a previous event
 	 * in order for caller to determine if it should require immediate-exit
@@ -8400,31 +8501,6 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			goto busy;
 	}
 
-	/* try to inject new event if pending */
-	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
-
-		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
-			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
-					     X86_EFLAGS_RF);
-
-		if (vcpu->arch.exception.nr == DB_VECTOR) {
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
-
 	/*
 	 * Finally, inject interrupt events.  If an event cannot be injected
 	 * due to architectural conditions (e.g. IF=0) a window-open exit
@@ -8482,7 +8558,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
 		*req_immediate_exit = true;
 
-	WARN_ON(vcpu->arch.exception.pending);
+	WARN_ON(vcpu->arch.pending_exception.valid);
 	return;
 
 busy:
@@ -9584,7 +9660,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_rip_write(vcpu, regs->rip);
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
 
-	vcpu->arch.exception.pending = false;
+	vcpu->arch.pending_exception.valid = false;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
@@ -9870,7 +9946,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
 		r = -EBUSY;
-		if (vcpu->arch.exception.pending)
+		if (vcpu->arch.pending_exception.valid)
 			goto out;
 		if (dbg->control & KVM_GUESTDBG_INJECT_DB)
 			kvm_queue_exception(vcpu, DB_VECTOR);
@@ -10931,7 +11007,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.pv.pv_unhalted)
 		return true;
 
-	if (vcpu->arch.exception.pending)
+	if (vcpu->arch.pending_exception.valid || vcpu->arch.injected_exception.valid)
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
@@ -11171,7 +11247,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 {
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
-		     vcpu->arch.exception.pending))
+		     vcpu->arch.pending_exception.valid))
 		return false;
 
 	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ee6e01067884d..e3848072c5bdb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -58,8 +58,8 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.exception.pending = false;
-	vcpu->arch.exception.injected = false;
+	vcpu->arch.pending_exception.valid = false;
+	vcpu->arch.injected_exception.valid = false;
 }
 
 static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector,
@@ -77,7 +77,7 @@ static inline void kvm_clear_interrupt_queue(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_event_needs_reinjection(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.exception.injected || vcpu->arch.interrupt.injected ||
+	return vcpu->arch.injected_exception.valid || vcpu->arch.interrupt.injected ||
 		vcpu->arch.nmi_injected;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 63f8f6e956487..d913a46d36b04 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1077,6 +1077,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
+#define KVM_CAP_EXCEPTION_INJECTED_PENDING 194
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.26.2

