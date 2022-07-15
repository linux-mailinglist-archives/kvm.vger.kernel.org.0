Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40F3576864
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiGOUoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiGOUn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DBA89EA1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p7-20020a25d807000000b0066e36989a90so4631428ybg.8
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1am3e01XUoctA5+wg8St7eCmYAJJajq/LWithLXLeQs=;
        b=NSWMsBZB1VEPWsaaZv2kgdrQUrIMWpStx0JyYNotHeEBrpLti0TUxADdy1nSKrO+M9
         DwCwPcTfwJbAEFJm2dmj/rISfPh5TM5S4+y27z8O+6K8jw3uPcJWsidXOOdnKlkDdJsj
         o9b7hBd+2DHxugI2V7uCJar5kHcADqIrbtb6RXMNbCw+1iObi3zG15cFFza5BhJr4LY6
         g00iLVoq9ip4NzOHCZdjXTgzDXgIj8k72gDYABuYgTmpAZoJtowefh6A2oe+JzLLsHbd
         ojVDZ5pjdELUxuHNqWoDDJXoGCEhjiFtlZRb0VkuqrWc7Jd6EDgGgHT0TqiCHfHcEhtO
         KCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1am3e01XUoctA5+wg8St7eCmYAJJajq/LWithLXLeQs=;
        b=DQIv2kRhSKwkIBZ5J7n1Ya6NRG3uxiErTyf4rXdKTOob2A3tEH7iCbTQPQYdg5zZUB
         +H/QFlLE2aldhQ8rMHatLyOiu+xUw22IWjGgAeKnVwvGNld4w3YVb1NCiNcsncqc8yrP
         IqV0v0soKnZxozD1lz+JtEqnNHekkWwdjvt9ki5fF4LUhSqhC67o7Kld6I5D+S6I2+/K
         ynGHKz9hyo1gbZeDZy7dZj/TyvsVOEKHKhg1iwMobCVzlo99j6Vud1QkV+C4DzPFW7LJ
         1LZu0Qhacvik80pS1jZzn2GYP5FttOH0EKzPUEuvm2RsbqO+yVotxAfJMXVPCelv+mq4
         /5Qw==
X-Gm-Message-State: AJIora9nIyg/aef869zvDj9+D8T+Gq1Nn4UuzJF5dggGPnOJbtPxdDh9
        qYYbHM/e9rq7B/BNWaKeBMFYljoe9V0=
X-Google-Smtp-Source: AGRyM1vHyVI3RVFsn7BO4V2yKjxrS3cErMBZpsUYt7tzBGEz/3jYXnlq0aB7UaspcyVT/DD4PUSU0geI4jo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af07:0:b0:31d:a33b:df2c with SMTP id
 n7-20020a81af07000000b0031da33bdf2cmr18608404ywh.32.1657917774466; Fri, 15
 Jul 2022 13:42:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:14 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 12/24] KVM: x86: Make kvm_queued_exception a properly
 named, visible struct
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the definition of "struct kvm_queued_exception" out of kvm_vcpu_arch
in anticipation of adding a second instance in kvm_vcpu_arch to handle
exceptions that occur when vectoring an injected exception and are
morphed to VM-Exit instead of leading to #DF.

Opportunistically take advantage of the churn to rename "nr" to "vector".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 23 +++++-----
 arch/x86/kvm/svm/nested.c       | 45 ++++++++++---------
 arch/x86/kvm/svm/svm.c          | 14 +++---
 arch/x86/kvm/vmx/nested.c       | 42 +++++++++--------
 arch/x86/kvm/vmx/vmx.c          | 20 ++++-----
 arch/x86/kvm/x86.c              | 80 ++++++++++++++++-----------------
 arch/x86/kvm/x86.h              |  3 +-
 7 files changed, 111 insertions(+), 116 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dbb9eab979d4..0a6a05e25f24 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -639,6 +639,17 @@ struct kvm_vcpu_xen {
 	struct timer_list poll_timer;
 };
 
+struct kvm_queued_exception {
+	bool pending;
+	bool injected;
+	bool has_error_code;
+	u8 vector;
+	u32 error_code;
+	unsigned long payload;
+	bool has_payload;
+	u8 nested_apf;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -737,16 +748,8 @@ struct kvm_vcpu_arch {
 
 	u8 event_exit_inst_len;
 
-	struct kvm_queued_exception {
-		bool pending;
-		bool injected;
-		bool has_error_code;
-		u8 nr;
-		u32 error_code;
-		unsigned long payload;
-		bool has_payload;
-		u8 nested_apf;
-	} exception;
+	/* Exceptions to be injected to the guest. */
+	struct kvm_queued_exception exception;
 
 	struct kvm_queued_interrupt {
 		bool injected;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index adf4120b05d9..f4cc12ee21d1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -467,7 +467,7 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 	unsigned int nr;
 
 	if (vcpu->arch.exception.injected) {
-		nr = vcpu->arch.exception.nr;
+		nr = vcpu->arch.exception.vector;
 		exit_int_info = nr | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
 
 		if (vcpu->arch.exception.has_error_code) {
@@ -1304,42 +1304,43 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
 
 static bool nested_exit_on_exception(struct vcpu_svm *svm)
 {
-	unsigned int nr = svm->vcpu.arch.exception.nr;
+	unsigned int vector = svm->vcpu.arch.exception.vector;
 
-	return (svm->nested.ctl.intercepts[INTERCEPT_EXCEPTION] & BIT(nr));
+	return (svm->nested.ctl.intercepts[INTERCEPT_EXCEPTION] & BIT(vector));
 }
 
-static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
+static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 {
-	unsigned int nr = svm->vcpu.arch.exception.nr;
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
-	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
+	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + ex->vector;
 	vmcb->control.exit_code_hi = 0;
 
-	if (svm->vcpu.arch.exception.has_error_code)
-		vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
+	if (ex->has_error_code)
+		vmcb->control.exit_info_1 = ex->error_code;
 
 	/*
 	 * EXITINFO2 is undefined for all exception intercepts other
 	 * than #PF.
 	 */
-	if (nr == PF_VECTOR) {
-		if (svm->vcpu.arch.exception.nested_apf)
-			vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
-		else if (svm->vcpu.arch.exception.has_payload)
-			vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
+	if (ex->vector == PF_VECTOR) {
+		if (ex->has_payload)
+			vmcb->control.exit_info_2 = ex->payload;
 		else
-			vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
-	} else if (nr == DB_VECTOR) {
+			vmcb->control.exit_info_2 = vcpu->arch.cr2;
+	} else if (ex->vector == DB_VECTOR) {
 		/* See inject_pending_event.  */
-		kvm_deliver_exception_payload(&svm->vcpu);
-		if (svm->vcpu.arch.dr7 & DR7_GD) {
-			svm->vcpu.arch.dr7 &= ~DR7_GD;
-			kvm_update_dr7(&svm->vcpu);
+		kvm_deliver_exception_payload(vcpu, ex);
+
+		if (vcpu->arch.dr7 & DR7_GD) {
+			vcpu->arch.dr7 &= ~DR7_GD;
+			kvm_update_dr7(vcpu);
 		}
-	} else
-		WARN_ON(svm->vcpu.arch.exception.has_payload);
+	} else {
+		WARN_ON(ex->has_payload);
+	}
 
 	nested_svm_vmexit(svm);
 }
@@ -1377,7 +1378,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
                         return -EBUSY;
 		if (!nested_exit_on_exception(svm))
 			return 0;
-		nested_svm_inject_exception_vmexit(svm);
+		nested_svm_inject_exception_vmexit(vcpu);
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a254d3b9926c..a336517b563e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -454,22 +454,20 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 
 static void svm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_error_code = vcpu->arch.exception.has_error_code;
-	u32 error_code = vcpu->arch.exception.error_code;
 
-	kvm_deliver_exception_payload(vcpu);
+	kvm_deliver_exception_payload(vcpu, ex);
 
-	if (kvm_exception_is_soft(nr) &&
+	if (kvm_exception_is_soft(ex->vector) &&
 	    svm_update_soft_interrupt_rip(vcpu))
 		return;
 
-	svm->vmcb->control.event_inj = nr
+	svm->vmcb->control.event_inj = ex->vector
 		| SVM_EVTINJ_VALID
-		| (has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
+		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
 		| SVM_EVTINJ_TYPE_EXEPT;
-	svm->vmcb->control.event_inj_err = error_code;
+	svm->vmcb->control.event_inj_err = ex->error_code;
 }
 
 static void svm_init_erratum_383(void)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a85f31cee149..42eccdcc2a4b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -446,29 +446,27 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
  */
 static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit_qual)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	unsigned int nr = vcpu->arch.exception.nr;
-	bool has_payload = vcpu->arch.exception.has_payload;
-	unsigned long payload = vcpu->arch.exception.payload;
 
-	if (nr == PF_VECTOR) {
-		if (vcpu->arch.exception.nested_apf) {
+	if (ex->vector == PF_VECTOR) {
+		if (ex->nested_apf) {
 			*exit_qual = vcpu->arch.apf.nested_apf_token;
 			return 1;
 		}
-		if (nested_vmx_is_page_fault_vmexit(vmcs12,
-						    vcpu->arch.exception.error_code)) {
-			*exit_qual = has_payload ? payload : vcpu->arch.cr2;
+		if (nested_vmx_is_page_fault_vmexit(vmcs12, ex->error_code)) {
+			*exit_qual = ex->has_payload ? ex->payload : vcpu->arch.cr2;
 			return 1;
 		}
-	} else if (vmcs12->exception_bitmap & (1u << nr)) {
-		if (nr == DB_VECTOR) {
-			if (!has_payload) {
-				payload = vcpu->arch.dr6;
-				payload &= ~DR6_BT;
-				payload ^= DR6_ACTIVE_LOW;
+	} else if (vmcs12->exception_bitmap & (1u << ex->vector)) {
+		if (ex->vector == DB_VECTOR) {
+			if (ex->has_payload) {
+				*exit_qual = ex->payload;
+			} else {
+				*exit_qual = vcpu->arch.dr6;
+				*exit_qual &= ~DR6_BT;
+				*exit_qual ^= DR6_ACTIVE_LOW;
 			}
-			*exit_qual = payload;
 		} else
 			*exit_qual = 0;
 		return 1;
@@ -3713,7 +3711,7 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	     is_double_fault(exit_intr_info))) {
 		vmcs12->idt_vectoring_info_field = 0;
 	} else if (vcpu->arch.exception.injected) {
-		nr = vcpu->arch.exception.nr;
+		nr = vcpu->arch.exception.vector;
 		idt_vectoring = nr | VECTORING_INFO_VALID_MASK;
 
 		if (kvm_exception_is_soft(nr)) {
@@ -3817,11 +3815,11 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 					       unsigned long exit_qual)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+	u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	unsigned int nr = vcpu->arch.exception.nr;
-	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
-	if (vcpu->arch.exception.has_error_code) {
+	if (ex->has_error_code) {
 		/*
 		 * Intel CPUs will never generate an error code with bits 31:16
 		 * set, and more importantly VMX disallows setting bits 31:16
@@ -3829,11 +3827,11 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 		 * mimic hardware and avoid inducing failure on nested VM-Entry
 		 * if L1 chooses to inject the exception back to L2.
 		 */
-		vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
+		vmcs12->vm_exit_intr_error_code = (u16)ex->error_code;
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
-	if (kvm_exception_is_soft(nr))
+	if (kvm_exception_is_soft(ex->vector))
 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
 	else
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
@@ -3864,7 +3862,7 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->arch.exception.pending ||
-	    vcpu->arch.exception.nr != DB_VECTOR)
+	    vcpu->arch.exception.vector != DB_VECTOR)
 		return 0;
 
 	/* General Detect #DBs are always fault-like. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 34d3f29bfa50..7d3abe2a206a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1585,7 +1585,7 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
 	    (!vcpu->arch.exception.pending ||
-	     vcpu->arch.exception.nr == DB_VECTOR))
+	     vcpu->arch.exception.vector == DB_VECTOR))
 		vmx->nested.mtf_pending = true;
 	else
 		vmx->nested.mtf_pending = false;
@@ -1612,15 +1612,13 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 
 static void vmx_inject_exception(struct kvm_vcpu *vcpu)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+	u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_error_code = vcpu->arch.exception.has_error_code;
-	u32 error_code = vcpu->arch.exception.error_code;
-	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
-	kvm_deliver_exception_payload(vcpu);
+	kvm_deliver_exception_payload(vcpu, ex);
 
-	if (has_error_code) {
+	if (ex->has_error_code) {
 		/*
 		 * Despite the error code being architecturally defined as 32
 		 * bits, and the VMCS field being 32 bits, Intel CPUs and thus
@@ -1630,21 +1628,21 @@ static void vmx_inject_exception(struct kvm_vcpu *vcpu)
 		 * the upper bits to avoid VM-Fail, losing information that
 		 * does't really exist is preferable to killing the VM.
 		 */
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)ex->error_code);
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
 	if (vmx->rmode.vm86_active) {
 		int inc_eip = 0;
-		if (kvm_exception_is_soft(nr))
+		if (kvm_exception_is_soft(ex->vector))
 			inc_eip = vcpu->arch.event_exit_inst_len;
-		kvm_inject_realmode_interrupt(vcpu, nr, inc_eip);
+		kvm_inject_realmode_interrupt(vcpu, ex->vector, inc_eip);
 		return;
 	}
 
 	WARN_ON_ONCE(vmx->emulation_required);
 
-	if (kvm_exception_is_soft(nr)) {
+	if (kvm_exception_is_soft(ex->vector)) {
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 			     vmx->vcpu.arch.event_exit_inst_len);
 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dbf95dc53c66..c4f758edf353 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -557,16 +557,13 @@ static int exception_type(int vector)
 	return EXCPT_FAULT;
 }
 
-void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
+void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
+				   struct kvm_queued_exception *ex)
 {
-	unsigned nr = vcpu->arch.exception.nr;
-	bool has_payload = vcpu->arch.exception.has_payload;
-	unsigned long payload = vcpu->arch.exception.payload;
-
-	if (!has_payload)
+	if (!ex->has_payload)
 		return;
 
-	switch (nr) {
+	switch (ex->vector) {
 	case DB_VECTOR:
 		/*
 		 * "Certain debug exceptions may clear bit 0-3.  The
@@ -591,8 +588,8 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * So they need to be flipped for DR6.
 		 */
 		vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
-		vcpu->arch.dr6 |= payload;
-		vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;
+		vcpu->arch.dr6 |= ex->payload;
+		vcpu->arch.dr6 ^= ex->payload & DR6_ACTIVE_LOW;
 
 		/*
 		 * The #DB payload is defined as compatible with the 'pending
@@ -603,12 +600,12 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		vcpu->arch.dr6 &= ~BIT(12);
 		break;
 	case PF_VECTOR:
-		vcpu->arch.cr2 = payload;
+		vcpu->arch.cr2 = ex->payload;
 		break;
 	}
 
-	vcpu->arch.exception.has_payload = false;
-	vcpu->arch.exception.payload = 0;
+	ex->has_payload = false;
+	ex->payload = 0;
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
@@ -647,17 +644,18 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 			vcpu->arch.exception.injected = false;
 		}
 		vcpu->arch.exception.has_error_code = has_error;
-		vcpu->arch.exception.nr = nr;
+		vcpu->arch.exception.vector = nr;
 		vcpu->arch.exception.error_code = error_code;
 		vcpu->arch.exception.has_payload = has_payload;
 		vcpu->arch.exception.payload = payload;
 		if (!is_guest_mode(vcpu))
-			kvm_deliver_exception_payload(vcpu);
+			kvm_deliver_exception_payload(vcpu,
+						      &vcpu->arch.exception);
 		return;
 	}
 
 	/* to check exception */
-	prev_nr = vcpu->arch.exception.nr;
+	prev_nr = vcpu->arch.exception.vector;
 	if (prev_nr == DF_VECTOR) {
 		/* triple fault -> shutdown */
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -675,7 +673,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		vcpu->arch.exception.pending = true;
 		vcpu->arch.exception.injected = false;
 		vcpu->arch.exception.has_error_code = true;
-		vcpu->arch.exception.nr = DF_VECTOR;
+		vcpu->arch.exception.vector = DF_VECTOR;
 		vcpu->arch.exception.error_code = 0;
 		vcpu->arch.exception.has_payload = false;
 		vcpu->arch.exception.payload = 0;
@@ -5000,25 +4998,24 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 					       struct kvm_vcpu_events *events)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+
 	process_nmi(vcpu);
 
 	if (kvm_check_request(KVM_REQ_SMI, vcpu))
 		process_smi(vcpu);
 
 	/*
-	 * In guest mode, payload delivery should be deferred,
-	 * so that the L1 hypervisor can intercept #PF before
-	 * CR2 is modified (or intercept #DB before DR6 is
-	 * modified under nVMX). Unless the per-VM capability,
-	 * KVM_CAP_EXCEPTION_PAYLOAD, is set, we may not defer the delivery of
-	 * an exception payload and handle after a KVM_GET_VCPU_EVENTS. Since we
-	 * opportunistically defer the exception payload, deliver it if the
-	 * capability hasn't been requested before processing a
-	 * KVM_GET_VCPU_EVENTS.
+	 * In guest mode, payload delivery should be deferred if the exception
+	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
+	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
+	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
+	 * propagate the payload and so it cannot be safely deferred.  Deliver
+	 * the payload if the capability hasn't been requested.
 	 */
 	if (!vcpu->kvm->arch.exception_payload_enabled &&
-	    vcpu->arch.exception.pending && vcpu->arch.exception.has_payload)
-		kvm_deliver_exception_payload(vcpu);
+	    ex->pending && ex->has_payload)
+		kvm_deliver_exception_payload(vcpu, ex);
 
 	/*
 	 * The API doesn't provide the instruction length for software
@@ -5026,26 +5023,25 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	 * isn't advanced, we should expect to encounter the exception
 	 * again.
 	 */
-	if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
+	if (kvm_exception_is_soft(ex->vector)) {
 		events->exception.injected = 0;
 		events->exception.pending = 0;
 	} else {
-		events->exception.injected = vcpu->arch.exception.injected;
-		events->exception.pending = vcpu->arch.exception.pending;
+		events->exception.injected = ex->injected;
+		events->exception.pending = ex->pending;
 		/*
 		 * For ABI compatibility, deliberately conflate
 		 * pending and injected exceptions when
 		 * KVM_CAP_EXCEPTION_PAYLOAD isn't enabled.
 		 */
 		if (!vcpu->kvm->arch.exception_payload_enabled)
-			events->exception.injected |=
-				vcpu->arch.exception.pending;
+			events->exception.injected |= ex->pending;
 	}
-	events->exception.nr = vcpu->arch.exception.nr;
-	events->exception.has_error_code = vcpu->arch.exception.has_error_code;
-	events->exception.error_code = vcpu->arch.exception.error_code;
-	events->exception_has_payload = vcpu->arch.exception.has_payload;
-	events->exception_payload = vcpu->arch.exception.payload;
+	events->exception.nr = ex->vector;
+	events->exception.has_error_code = ex->has_error_code;
+	events->exception.error_code = ex->error_code;
+	events->exception_has_payload = ex->has_payload;
+	events->exception_payload = ex->payload;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -5117,7 +5113,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	process_nmi(vcpu);
 	vcpu->arch.exception.injected = events->exception.injected;
 	vcpu->arch.exception.pending = events->exception.pending;
-	vcpu->arch.exception.nr = events->exception.nr;
+	vcpu->arch.exception.vector = events->exception.nr;
 	vcpu->arch.exception.has_error_code = events->exception.has_error_code;
 	vcpu->arch.exception.error_code = events->exception.error_code;
 	vcpu->arch.exception.has_payload = events->exception_has_payload;
@@ -9652,7 +9648,7 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
-	trace_kvm_inj_exception(vcpu->arch.exception.nr,
+	trace_kvm_inj_exception(vcpu->arch.exception.vector,
 				vcpu->arch.exception.has_error_code,
 				vcpu->arch.exception.error_code,
 				vcpu->arch.exception.injected);
@@ -9724,12 +9720,12 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 		 * describe the behavior of General Detect #DBs, which are
 		 * fault-like.  They do _not_ set RF, a la code breakpoints.
 		 */
-		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
+		if (exception_type(vcpu->arch.exception.vector) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
 
-		if (vcpu->arch.exception.nr == DB_VECTOR) {
-			kvm_deliver_exception_payload(vcpu);
+		if (vcpu->arch.exception.vector == DB_VECTOR) {
+			kvm_deliver_exception_payload(vcpu, &vcpu->arch.exception);
 			if (vcpu->arch.dr7 & DR7_GD) {
 				vcpu->arch.dr7 &= ~DR7_GD;
 				kvm_update_dr7(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 501b884b8cc4..dc2af0146220 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -286,7 +286,8 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu,
 
 int handle_ud(struct kvm_vcpu *vcpu);
 
-void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu);
+void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
+				   struct kvm_queued_exception *ex);
 
 void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu);
 u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
-- 
2.37.0.170.g444d1eabd0-goog

