Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A9576866
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiGOUol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiGOUoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:44:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850018AB3C
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u12-20020a170902e5cc00b0016c20d40ec1so2607891plf.10
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DW1hsPDHd7Z6x9mNvbp/fkM8fLMwnqSq/Zrqb3GbuRs=;
        b=aC9y4rdup3wE6AZdG8v2cEpi5+bzG5DrDjNz7m4Xjty6yhKLCmN0PM1KnCI6zrg8MH
         /yAo5yenU6oiCuTI+CET5k/ag8nk4//G0az5JC5pk3DEbVgGc7qCAW8LgpPm+VYwrhKh
         BpBP9UTMEKSWYMGvIZwUwEnurstwFLCBTJiG+vUE01dICJWQcs9iJhucqXO8cqCANiSt
         tQqZ5mxch7mk70U64L7Dj+DeF0xjofNJPZFIWTSwaxm7AWsHSWqcsGWPZFoEv0UOPgLI
         lFQXRrXbf+udbkH3E/VEPVTAbceZ8v3Rje3BxmBzguIJl1JlmuOmY8IJgStkNG5hQP4L
         xjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DW1hsPDHd7Z6x9mNvbp/fkM8fLMwnqSq/Zrqb3GbuRs=;
        b=Y2JQMflu7yabRh2xjyHjlFfW+gzlGHcBTDswC0JpwlOFPAMxC6qGE7YQNadDTxaWxF
         GJSpcX7iuzcujdDOi3JF+Bl62ZsYdw3NkXokTGM1bEY0F5EbD4WbsOGUiOCb463U7b+8
         ShVdWcsamItI5li0oYen8ybEbObctdLWSP7L+e8WaNh2Pa0JWNbnp+E9+kEPgFHsOM1O
         wK62xcpRfU+SqcasfPjupuvcKaAbM5RxDS0jbqUYTnvOJAPfZa4dZFvmqzw1y7jnfHpI
         z8959gfqTfcjgYvwLrYXN02KUSPm8Yt4PUP0a7NmBl3Cifvm4P69AnIZN8oV9naj6fyA
         pvLw==
X-Gm-Message-State: AJIora8VNOVZHsJt+N+spEqCmC4tXQib92mBwuGfnPgiBtkxbH9YbT6m
        aWt+xjS7ps1Kscth6sWE6RdHL2o2O8s=
X-Google-Smtp-Source: AGRyM1uXlfLhbwxpmbUkg0IaZmEvCr2ufgJWDbuk6W+PQZWbEq7P+mBNeQY2/Vpk6EVEZYtlmriKKOuCvTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:9a07:b0:16c:39bc:876 with SMTP id
 v7-20020a1709029a0700b0016c39bc0876mr15171944plp.42.1657917785912; Fri, 15
 Jul 2022 13:43:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:21 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 19/24] KVM: x86: Morph pending exceptions to pending
 VM-Exits at queue time
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Morph pending exceptions to pending VM-Exits (due to interception) when
the exception is queued instead of waiting until nested events are
checked at VM-Entry.  This fixes a longstanding bug where KVM fails to
handle an exception that occurs during delivery of a previous exception,
KVM (L0) and L1 both want to intercept the exception (e.g. #PF for shadow
paging), and KVM determines that the exception is in the guest's domain,
i.e. queues the new exception for L2.  Deferring the interception check
causes KVM to esclate various combinations of injected+pending exceptions
to double fault (#DF) without consulting L1's interception desires, and
ends up injecting a spurious #DF into L2.

KVM has fudged around the issue for #PF by special casing emulated #PF
injection for shadow paging, but the underlying issue is not unique to
shadow paging in L0, e.g. if KVM is intercepting #PF because the guest
has a smaller maxphyaddr and L1 (but not L0) is using shadow paging.
Other exceptions are affected as well, e.g. if KVM is intercepting #GP
for one of SVM's workaround or for the VMware backdoor emulation stuff.
The other cases have gone unnoticed because the #DF is spurious if and
only if L1 resolves the exception, e.g. KVM's goofs go unnoticed if L1
would have injected #DF anyways.

The hack-a-fix has also led to ugly code, e.g. bailing from the emulator
if #PF injection forced a nested VM-Exit and the emulator finds itself
back in L1.  Allowing for direct-to-VM-Exit queueing also neatly solves
the async #PF in L2 mess; no need to set a magic flag and token, simply
queue a #PF nested VM-Exit.

Deal with event migration by flagging that a pending exception was queued
by userspace and check for interception at the next KVM_RUN, e.g. so that
KVM does the right thing regardless of the order in which userspace
restores nested state vs. event state.

When "getting" events from userspace, simply drop any pending excpetion
that is destined to be intercepted if there is also an injected exception
to be migrated.  Ideally, KVM would migrate both events, but that would
require new ABI, and practically speaking losing the event is unlikely to
be noticed, let alone fatal.  The injected exception is captured, RIP
still points at the original faulting instruction, etc...  So either the
injection on the target will trigger the same intercepted exception, or
the source of the intercepted exception was transient and/or
non-deterministic, thus dropping it is ok-ish.

Fixes: a04aead144fd ("KVM: nSVM: fix running nested guests when npt=0")
Fixes: feaf0c7dc473 ("KVM: nVMX: Do not generate #DF if #PF happens during exception delivery into L2")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  12 ++-
 arch/x86/kvm/svm/nested.c       |  41 +++-----
 arch/x86/kvm/vmx/nested.c       | 109 ++++++++++------------
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/x86.c              | 159 ++++++++++++++++++++++----------
 arch/x86/kvm/x86.h              |   7 ++
 6 files changed, 187 insertions(+), 147 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a6a05e25f24..6bcbffb42420 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -647,7 +647,6 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
-	u8 nested_apf;
 };
 
 struct kvm_vcpu_arch {
@@ -748,8 +747,12 @@ struct kvm_vcpu_arch {
 
 	u8 event_exit_inst_len;
 
+	bool exception_from_userspace;
+
 	/* Exceptions to be injected to the guest. */
 	struct kvm_queued_exception exception;
+	/* Exception VM-Exits to be synthesized to L1. */
+	struct kvm_queued_exception exception_vmexit;
 
 	struct kvm_queued_interrupt {
 		bool injected;
@@ -860,7 +863,6 @@ struct kvm_vcpu_arch {
 		u32 id;
 		bool send_user_only;
 		u32 host_apf_flags;
-		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
 	} apf;
@@ -1636,9 +1638,9 @@ struct kvm_x86_ops {
 
 struct kvm_x86_nested_ops {
 	void (*leave_nested)(struct kvm_vcpu *vcpu);
+	bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
+				    u32 error_code);
 	int (*check_events)(struct kvm_vcpu *vcpu);
-	bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
-					     struct x86_exception *fault);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
@@ -1865,7 +1867,7 @@ void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long pay
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
-bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f5676c2679d0..0a8ee5f28319 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -55,28 +55,6 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }
 
-static bool nested_svm_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
-						    struct x86_exception *fault)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb = svm->vmcb;
-
- 	WARN_ON(!is_guest_mode(vcpu));
-
-	if (vmcb12_is_intercept(&svm->nested.ctl,
-				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-	    !WARN_ON_ONCE(svm->nested.nested_run_pending)) {
-	     	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
-		vmcb->control.exit_code_hi = 0;
-		vmcb->control.exit_info_1 = fault->error_code;
-		vmcb->control.exit_info_2 = fault->address;
-		nested_svm_vmexit(svm);
-		return true;
-	}
-
-	return false;
-}
-
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1302,16 +1280,17 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool nested_exit_on_exception(struct vcpu_svm *svm)
+static bool nested_svm_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector,
+					   u32 error_code)
 {
-	unsigned int vector = svm->vcpu.arch.exception.vector;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	return (svm->nested.ctl.intercepts[INTERCEPT_EXCEPTION] & BIT(vector));
 }
 
 static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
@@ -1379,15 +1358,19 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.exception.pending) {
+	if (vcpu->arch.exception_vmexit.pending) {
 		if (block_nested_exceptions)
                         return -EBUSY;
-		if (!nested_exit_on_exception(svm))
-			return 0;
 		nested_svm_inject_exception_vmexit(vcpu);
 		return 0;
 	}
 
+	if (vcpu->arch.exception.pending) {
+		if (block_nested_exceptions)
+			return -EBUSY;
+		return 0;
+	}
+
 	if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
@@ -1725,8 +1708,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.leave_nested = svm_leave_nested,
+	.is_exception_vmexit = nested_svm_is_exception_vmexit,
 	.check_events = svm_check_nested_events,
-	.handle_page_fault_workaround = nested_svm_handle_page_fault_workaround,
 	.triple_fault = nested_svm_triple_fault,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 981f98ef96f1..5a6ba62dcd49 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -439,59 +439,22 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
 	return inequality ^ bit;
 }
 
-
-/*
- * KVM wants to inject page-faults which it got to the guest. This function
- * checks whether in a nested guest, we need to inject them to L1 or L2.
- */
-static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit_qual)
-{
-	struct kvm_queued_exception *ex = &vcpu->arch.exception;
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-
-	if (ex->vector == PF_VECTOR) {
-		if (ex->nested_apf) {
-			*exit_qual = vcpu->arch.apf.nested_apf_token;
-			return 1;
-		}
-		if (nested_vmx_is_page_fault_vmexit(vmcs12, ex->error_code)) {
-			*exit_qual = ex->has_payload ? ex->payload : vcpu->arch.cr2;
-			return 1;
-		}
-	} else if (vmcs12->exception_bitmap & (1u << ex->vector)) {
-		if (ex->vector == DB_VECTOR) {
-			if (ex->has_payload) {
-				*exit_qual = ex->payload;
-			} else {
-				*exit_qual = vcpu->arch.dr6;
-				*exit_qual &= ~DR6_BT;
-				*exit_qual ^= DR6_ACTIVE_LOW;
-			}
-		} else
-			*exit_qual = 0;
-		return 1;
-	}
-
-	return 0;
-}
-
-static bool nested_vmx_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
-						    struct x86_exception *fault)
+static bool nested_vmx_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector,
+					   u32 error_code)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
-	WARN_ON(!is_guest_mode(vcpu));
+	/*
+	 * Drop bits 31:16 of the error code when performing the #PF mask+match
+	 * check.  All VMCS fields involved are 32 bits, but Intel CPUs never
+	 * set bits 31:16 and VMX disallows setting bits 31:16 in the injected
+	 * error code.  Including the to-be-dropped bits in the check might
+	 * result in an "impossible" or missed exit from L1's perspective.
+	 */
+	if (vector == PF_VECTOR)
+		return nested_vmx_is_page_fault_vmexit(vmcs12, (u16)error_code);
 
-	if (nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
-	    !WARN_ON_ONCE(to_vmx(vcpu)->nested.nested_run_pending)) {
-		vmcs12->vm_exit_intr_error_code = fault->error_code;
-		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
-				  PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
-				  INTR_INFO_DELIVER_CODE_MASK | INTR_INFO_VALID_MASK,
-				  fault->address);
-		return true;
-	}
-	return false;
+	return (vmcs12->exception_bitmap & (1u << vector));
 }
 
 static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
@@ -3812,12 +3775,24 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	return -ENXIO;
 }
 
-static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
-					       unsigned long exit_qual)
+static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 {
-	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 	u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	unsigned long exit_qual;
+
+	if (ex->has_payload) {
+		exit_qual = ex->payload;
+	} else if (ex->vector == PF_VECTOR) {
+		exit_qual = vcpu->arch.cr2;
+	} else if (ex->vector == DB_VECTOR) {
+		exit_qual = vcpu->arch.dr6;
+		exit_qual &= ~DR6_BT;
+		exit_qual ^= DR6_ACTIVE_LOW;
+	} else {
+		exit_qual = 0;
+	}
 
 	if (ex->has_error_code) {
 		/*
@@ -3988,7 +3963,6 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qual;
 	/*
 	 * Only a pending nested run blocks a pending exception.  If there is a
 	 * previously injected event, the pending exception occurred while said
@@ -4042,14 +4016,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * across SMI/RSM as it should; that needs to be addressed in order to
 	 * prioritize SMI over MTF and trap-like #DBs.
 	 */
+	if (vcpu->arch.exception_vmexit.pending &&
+	    !vmx_is_low_priority_db_trap(&vcpu->arch.exception_vmexit)) {
+		if (block_nested_exceptions)
+			return -EBUSY;
+
+		nested_vmx_inject_exception_vmexit(vcpu);
+		return 0;
+	}
+
 	if (vcpu->arch.exception.pending &&
 	    !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
 		if (block_nested_exceptions)
 			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
+		goto no_vmexit;
 	}
 
 	if (vmx->nested.mtf_pending) {
@@ -4060,13 +4040,18 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+	if (vcpu->arch.exception_vmexit.pending) {
+		if (block_nested_exceptions)
+			return -EBUSY;
+
+		nested_vmx_inject_exception_vmexit(vcpu);
+		return 0;
+	}
+
 	if (vcpu->arch.exception.pending) {
 		if (block_nested_exceptions)
 			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
+		goto no_vmexit;
 	}
 
 	if (nested_vmx_preemption_timer_pending(vcpu)) {
@@ -6952,8 +6937,8 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
+	.is_exception_vmexit = nested_vmx_is_exception_vmexit,
 	.check_events = vmx_check_nested_events,
-	.handle_page_fault_workaround = nested_vmx_handle_page_fault_workaround,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7d3abe2a206a..5302b046110f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1585,7 +1585,9 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
 	    (!vcpu->arch.exception.pending ||
-	     vcpu->arch.exception.vector == DB_VECTOR))
+	     vcpu->arch.exception.vector == DB_VECTOR) &&
+	    (!vcpu->arch.exception_vmexit.pending ||
+	     vcpu->arch.exception_vmexit.vector == DB_VECTOR))
 		vmx->nested.mtf_pending = true;
 	else
 		vmx->nested.mtf_pending = false;
@@ -5637,7 +5639,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	return vmx->emulation_required && !vmx->rmode.vm86_active &&
-	       (vcpu->arch.exception.pending || vcpu->arch.exception.injected);
+	       (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected);
 }
 
 static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 795c799fc767..9be2fdf834ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -609,6 +609,21 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
 
+static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vector,
+				       bool has_error_code, u32 error_code,
+				       bool has_payload, unsigned long payload)
+{
+	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
+
+	ex->vector = vector;
+	ex->injected = false;
+	ex->pending = true;
+	ex->has_error_code = has_error_code;
+	ex->error_code = error_code;
+	ex->has_payload = has_payload;
+	ex->payload = payload;
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 	        bool has_payload, unsigned long payload, bool reinject)
@@ -618,18 +633,31 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
+	/*
+	 * If the exception is destined for L2 and isn't being reinjected,
+	 * morph it to a VM-Exit if L1 wants to intercept the exception.  A
+	 * previously injected exception is not checked because it was checked
+	 * when it was original queued, and re-checking is incorrect if _L1_
+	 * injected the exception, in which case it's exempt from interception.
+	 */
+	if (!reinject && is_guest_mode(vcpu) &&
+	    kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, nr, error_code)) {
+		kvm_queue_exception_vmexit(vcpu, nr, has_error, error_code,
+					   has_payload, payload);
+		return;
+	}
+
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
 		if (reinject) {
 			/*
-			 * On vmentry, vcpu->arch.exception.pending is only
-			 * true if an event injection was blocked by
-			 * nested_run_pending.  In that case, however,
-			 * vcpu_enter_guest requests an immediate exit,
-			 * and the guest shouldn't proceed far enough to
-			 * need reinjection.
+			 * On VM-Entry, an exception can be pending if and only
+			 * if event injection was blocked by nested_run_pending.
+			 * In that case, however, vcpu_enter_guest() requests an
+			 * immediate exit, and the guest shouldn't proceed far
+			 * enough to need reinjection.
 			 */
-			WARN_ON_ONCE(vcpu->arch.exception.pending);
+			WARN_ON_ONCE(kvm_is_exception_pending(vcpu));
 			vcpu->arch.exception.injected = true;
 			if (WARN_ON_ONCE(has_payload)) {
 				/*
@@ -732,20 +760,22 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
 	++vcpu->stat.pf_guest;
-	vcpu->arch.exception.nested_apf =
-		is_guest_mode(vcpu) && fault->async_page_fault;
-	if (vcpu->arch.exception.nested_apf) {
-		vcpu->arch.apf.nested_apf_token = fault->address;
-		kvm_queue_exception_e(vcpu, PF_VECTOR, fault->error_code);
-	} else {
+
+	/*
+	 * Async #PF in L2 is always forwarded to L1 as a VM-Exit regardless of
+	 * whether or not L1 wants to intercept "regular" #PF.
+	 */
+	if (is_guest_mode(vcpu) && fault->async_page_fault)
+		kvm_queue_exception_vmexit(vcpu, PF_VECTOR,
+					   true, fault->error_code,
+					   true, fault->address);
+	else
 		kvm_queue_exception_e_p(vcpu, PF_VECTOR, fault->error_code,
 					fault->address);
-	}
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
-/* Returns true if the page fault was immediately morphed into a VM-Exit. */
-bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
 	struct kvm_mmu *fault_mmu;
@@ -763,26 +793,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
 				       fault_mmu->root.hpa);
 
-	/*
-	 * A workaround for KVM's bad exception handling.  If KVM injected an
-	 * exception into L2, and L2 encountered a #PF while vectoring the
-	 * injected exception, manually check to see if L1 wants to intercept
-	 * #PF, otherwise queuing the #PF will lead to #DF or a lost exception.
-	 * In all other cases, defer the check to nested_ops->check_events(),
-	 * which will correctly handle priority (this does not).  Note, other
-	 * exceptions, e.g. #GP, are theoretically affected, #PF is simply the
-	 * most problematic, e.g. when L0 and L1 are both intercepting #PF for
-	 * shadow paging.
-	 *
-	 * TODO: Rewrite exception handling to track injected and pending
-	 *       (VM-Exit) exceptions separately.
-	 */
-	if (unlikely(vcpu->arch.exception.injected && is_guest_mode(vcpu)) &&
-	    kvm_x86_ops.nested_ops->handle_page_fault_workaround(vcpu, fault))
-		return true;
-
 	fault_mmu->inject_page_fault(vcpu, fault);
-	return false;
 }
 EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
 
@@ -4820,7 +4831,7 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 	return (kvm_arch_interrupt_allowed(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu) &&
 		!kvm_event_needs_reinjection(vcpu) &&
-		!vcpu->arch.exception.pending);
+		!kvm_is_exception_pending(vcpu));
 }
 
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
@@ -4995,13 +5006,27 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 					       struct kvm_vcpu_events *events)
 {
-	struct kvm_queued_exception *ex = &vcpu->arch.exception;
+	struct kvm_queued_exception *ex;
 
 	process_nmi(vcpu);
 
 	if (kvm_check_request(KVM_REQ_SMI, vcpu))
 		process_smi(vcpu);
 
+	/*
+	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
+	 * the only time there can be two queued exceptions is if there's a
+	 * non-exiting _injected_ exception, and a pending exiting exception.
+	 * In that case, ignore the VM-Exiting exception as it's an extension
+	 * of the injected exception.
+	 */
+	if (vcpu->arch.exception_vmexit.pending &&
+	    !vcpu->arch.exception.pending &&
+	    !vcpu->arch.exception.injected)
+		ex = &vcpu->arch.exception_vmexit;
+	else
+		ex = &vcpu->arch.exception;
+
 	/*
 	 * In guest mode, payload delivery should be deferred if the exception
 	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
@@ -5108,6 +5133,19 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	process_nmi(vcpu);
+
+	/*
+	 * Flag that userspace is stuffing an exception, the next KVM_RUN will
+	 * morph the exception to a VM-Exit if appropriate.  Do this only for
+	 * pending exceptions, already-injected exceptions are not subject to
+	 * intercpetion.  Note, userspace that conflates pending and injected
+	 * is hosed, and will incorrectly convert an injected exception into a
+	 * pending exception, which in turn may cause a spurious VM-Exit.
+	 */
+	vcpu->arch.exception_from_userspace = events->exception.pending;
+
+	vcpu->arch.exception_vmexit.pending = false;
+
 	vcpu->arch.exception.injected = events->exception.injected;
 	vcpu->arch.exception.pending = events->exception.pending;
 	vcpu->arch.exception.vector = events->exception.nr;
@@ -8130,18 +8168,17 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	}
 }
 
-static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
+static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
 	if (ctxt->exception.vector == PF_VECTOR)
-		return kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
-
-	if (ctxt->exception.error_code_valid)
+		kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
+	else if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
 				      ctxt->exception.error_code);
 	else
 		kvm_queue_exception(vcpu, ctxt->exception.vector);
-	return false;
 }
 
 static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)
@@ -8754,8 +8791,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	if (ctxt->have_exception) {
 		r = 1;
-		if (inject_emulated_exception(vcpu))
-			return r;
+		inject_emulated_exception(vcpu);
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
 			/* FIXME: return into emulator if single-stepping.  */
@@ -9695,7 +9731,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	 */
 	if (vcpu->arch.exception.injected)
 		kvm_inject_exception(vcpu);
-	else if (vcpu->arch.exception.pending)
+	else if (kvm_is_exception_pending(vcpu))
 		; /* see above */
 	else if (vcpu->arch.nmi_injected)
 		static_call(kvm_x86_inject_nmi)(vcpu);
@@ -9722,6 +9758,14 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	if (r < 0)
 		goto out;
 
+	/*
+	 * A pending exception VM-Exit should either result in nested VM-Exit
+	 * or force an immediate re-entry and exit to/from L2, and exception
+	 * VM-Exits cannot be injected (flag should _never_ be set).
+	 */
+	WARN_ON_ONCE(vcpu->arch.exception_vmexit.injected ||
+		     vcpu->arch.exception_vmexit.pending);
+
 	/*
 	 * New events, other than exceptions, cannot be injected if KVM needs
 	 * to re-inject a previous event.  See above comments on re-injecting
@@ -9821,7 +9865,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
 		*req_immediate_exit = true;
 
-	WARN_ON(vcpu->arch.exception.pending);
+	WARN_ON(kvm_is_exception_pending(vcpu));
 	return 0;
 
 out:
@@ -10839,6 +10883,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
 	int r;
 
@@ -10897,6 +10942,21 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	/*
+	 * If userspace set a pending exception and L2 is active, convert it to
+	 * a pending VM-Exit if L1 wants to intercept the exception.
+	 */
+	if (vcpu->arch.exception_from_userspace && is_guest_mode(vcpu) &&
+	    kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, ex->vector,
+							ex->error_code)) {
+		kvm_queue_exception_vmexit(vcpu, ex->vector,
+					   ex->has_error_code, ex->error_code,
+					   ex->has_payload, ex->payload);
+		ex->injected = false;
+		ex->pending = false;
+	}
+	vcpu->arch.exception_from_userspace = false;
+
 	if (unlikely(vcpu->arch.complete_userspace_io)) {
 		int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
 		vcpu->arch.complete_userspace_io = NULL;
@@ -11003,6 +11063,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
 
 	vcpu->arch.exception.pending = false;
+	vcpu->arch.exception_vmexit.pending = false;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
@@ -11370,7 +11431,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
 		r = -EBUSY;
-		if (vcpu->arch.exception.pending)
+		if (kvm_is_exception_pending(vcpu))
 			goto out;
 		if (dbg->control & KVM_GUESTDBG_INJECT_DB)
 			kvm_queue_exception(vcpu, DB_VECTOR);
@@ -12554,7 +12615,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.pv.pv_unhalted)
 		return true;
 
-	if (vcpu->arch.exception.pending)
+	if (kvm_is_exception_pending(vcpu))
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
@@ -12809,7 +12870,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 {
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
-		     vcpu->arch.exception.pending))
+		     kvm_is_exception_pending(vcpu)))
 		return false;
 
 	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dc2af0146220..eee259e387d3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -82,10 +82,17 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
+static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.exception.pending ||
+	       vcpu->arch.exception_vmexit.pending;
+}
+
 static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exception.pending = false;
 	vcpu->arch.exception.injected = false;
+	vcpu->arch.exception_vmexit.pending = false;
 }
 
 static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector,
-- 
2.37.0.170.g444d1eabd0-goog

