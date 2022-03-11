Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6729C4D5901
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiCKDa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346041AbiCKD36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:58 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5057CF47F6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:35 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id c7-20020a17090a674700b001beef0afd32so4529827pjm.2
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XalHmACPaVogRsmGuyX2dRrnQsx96NVwsDAjrfZuVog=;
        b=N3MkpEnnRpeTMoP1TqPa/V0g+AyGv/rtQstfL9UljvE7oGRw735eBz2Y9uHfeTfJIt
         t5JGh0hDLVBFCF7DdtlYVADpG3RZ3cTeQyJ2Kr8z92BfFmGD49czCZPkijNT3LF7p0M5
         JkTRjmD1DsJNzETqVGxX0FXUkhkzThr+IwqFAGi59/un0TSllyDOlNCJXa9bhNtsyvSz
         u0gyz4OuZSz46XKLKRcD63Nuez3SZuuSAiqBZ4wYewOoO6S2Mn3ExczrkhHxJq/2PzQT
         iQ1L0oHsTTvVne1ID5cw+IwQFv+aH/Q6ZKNaDV5XqxbIg67A04/r7gi1ou6p/y9aXFFw
         5cSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XalHmACPaVogRsmGuyX2dRrnQsx96NVwsDAjrfZuVog=;
        b=radMnlENARO84ypRxG2UZhsppNnwUCDkdkSFVhUan+FFgo4boaUr20Ptvnnb/Fuy23
         9Rd5YM2AdfcuKBFNThUuNIA19mVmhC7wjqO8zKWtvGy3s4rZF43wkxm8lARcO0NiUV2Y
         jMMcuUXh4KGIBYNDWtd/PvyVUE6OjL8AXfqp+VLmoiTcVfQCBPnUzhN27TY34W2j+WqH
         MtOVP/z1nH/wFNZN0WUG1ZLjN01C2Uwcn+V05KdCKrNv/Ph3pFCHC7MW3jy1b39DVD2B
         b0xWi90PUv44Nvm6FTZ9KuBWy/OtaMBN+vFNvp2ESJU3npMQ5Udwh6/3Za20SOTjCfqk
         fGMA==
X-Gm-Message-State: AOAM533CV3lUEkCZqNdAC76FrPszbG9maNDPsZQIavPpT55apY8ZQnpj
        1Hd0h9q2BarRblHij1yAJ6NRLeHLOKs=
X-Google-Smtp-Source: ABdhPJz9qCbjDxwbihwa4xlN0T4W7Oe0XDZbCIaX1TyJKoOjbvwdzW9C9YcvLWX1oEy14qbxYyeL/tWosIc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b96:b0:4f3:c0f6:5c47 with SMTP id
 g22-20020a056a000b9600b004f3c0f65c47mr8236942pfj.69.1646969314761; Thu, 10
 Mar 2022 19:28:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:58 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 18/21] KVM: x86: Morph pending exceptions to pending VM-Exits
 at queue time
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Opportunistically add a gigantic comment above vmx_check_nested_events()
to document the priorities of all known events on Intel CPUs.  Kudos to
Jim Mattson for doing the hard work of collecting and interpreting the
priorities from various locations throughtout the SDM (because putting
them all in one place in the SDM would be too easy).

Fixes: a04aead144fd ("KVM: nSVM: fix running nested guests when npt=0")
Fixes: feaf0c7dc473 ("KVM: nVMX: Do not generate #DF if #PF happens during exception delivery into L2")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  10 +-
 arch/x86/kvm/svm/nested.c       |  39 ++----
 arch/x86/kvm/vmx/nested.c       | 223 +++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/x86.c              | 142 +++++++++++++++-----
 arch/x86/kvm/x86.h              |   7 +
 6 files changed, 288 insertions(+), 139 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 478e2fef0062..b5a9c0cbb21c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -623,7 +623,6 @@ struct kvm_queued_exception {
 	u32 error_code;
 	unsigned long payload;
 	bool has_payload;
-	u8 nested_apf;
 };
 
 struct kvm_vcpu_arch {
@@ -724,8 +723,12 @@ struct kvm_vcpu_arch {
 
 	u8 event_exit_inst_len;
 
+	bool exception_from_userspace;
+
 	/* Exceptions to be injected to the guest. */
 	struct kvm_queued_exception exception;
+	/* Exception VM-Exits to be synthesized to L1. */
+	struct kvm_queued_exception exception_vmexit;
 
 	struct kvm_queued_interrupt {
 		bool injected;
@@ -836,7 +839,6 @@ struct kvm_vcpu_arch {
 		u32 id;
 		bool send_user_only;
 		u32 host_apf_flags;
-		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
 	} apf;
@@ -1500,6 +1502,8 @@ struct kvm_x86_ops {
 
 struct kvm_x86_nested_ops {
 	void (*leave_nested)(struct kvm_vcpu *vcpu);
+	bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
+				    u32 error_code);
 	int (*check_events)(struct kvm_vcpu *vcpu);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
@@ -1754,7 +1758,7 @@ void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long pay
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
-bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 60df9d4d19b5..ddef8fd8a9e6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -54,24 +54,6 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }
 
-static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
-{
-       struct vcpu_svm *svm = to_svm(vcpu);
-       WARN_ON(!is_guest_mode(vcpu));
-
-	if (vmcb12_is_intercept(&svm->nested.ctl,
-				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-	    !svm->nested.nested_run_pending) {
-               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
-               svm->vmcb->control.exit_code_hi = 0;
-               svm->vmcb->control.exit_info_1 = fault->error_code;
-               svm->vmcb->control.exit_info_2 = fault->address;
-               nested_svm_vmexit(svm);
-       } else {
-               kvm_inject_page_fault(vcpu, fault);
-       }
-}
-
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -680,9 +662,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (ret)
 		return ret;
 
-	if (!npt_enabled)
-		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
-
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -1152,16 +1131,17 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
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
 
 	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + ex->vector;
@@ -1222,15 +1202,19 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
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
@@ -1567,6 +1551,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.leave_nested = svm_leave_nested,
+	.is_exception_vmexit = nested_svm_is_exception_vmexit,
 	.check_events = svm_check_nested_events,
 	.triple_fault = nested_svm_triple_fault,
 	.get_nested_state_pages = svm_get_nested_state_pages,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 01cf579c0260..99ee0a1c3a4b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -438,60 +438,22 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
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
-
-static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
-		struct x86_exception *fault)
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
-		!to_vmx(vcpu)->nested.nested_run_pending) {
-		vmcs12->vm_exit_intr_error_code = fault->error_code;
-		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
-				  PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
-				  INTR_INFO_DELIVER_CODE_MASK | INTR_INFO_VALID_MASK,
-				  fault->address);
-	} else {
-		kvm_inject_page_fault(vcpu, fault);
-	}
+	return (vmcs12->exception_bitmap & (1u << vector));
 }
 
 static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
@@ -2612,9 +2574,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 	}
 
-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
@@ -3798,12 +3757,24 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
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
@@ -3845,14 +3816,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
  * from the emulator (because such #DBs are fault-like and thus don't trigger
  * actions that fire on instruction retire).
  */
-static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
+static unsigned long vmx_get_pending_dbg_trap(struct kvm_queued_exception *ex)
 {
-	if (!vcpu->arch.exception.pending ||
-	    vcpu->arch.exception.vector != DB_VECTOR)
+	if (!ex->pending || ex->vector != DB_VECTOR)
 		return 0;
 
 	/* General Detect #DBs are always fault-like. */
-	return vcpu->arch.exception.payload & ~DR6_BD;
+	return ex->payload & ~DR6_BD;
+}
+
+/*
+ * Returns true if there's a pending #DB exception that is lower priority than
+ * a pending Monitor Trap Flag VM-Exit.  TSS T-flag #DBs are not emulated by
+ * KVM, but could theoretically be injected by userspace.  Note, this code is
+ * imperfect, see above.
+ */
+static bool vmx_is_low_priority_db_trap(struct kvm_queued_exception *ex)
+{
+	return vmx_get_pending_dbg_trap(ex) & ~DR6_BT;
 }
 
 /*
@@ -3864,8 +3845,9 @@ static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
  */
 static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 {
-	unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
+	unsigned long pending_dbg;
 
+	pending_dbg = vmx_get_pending_dbg_trap(&vcpu->arch.exception);
 	if (pending_dbg)
 		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
 }
@@ -3876,11 +3858,93 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
+/*
+ * Per the Intel SDM's table "Priority Among Concurrent Events", with minor
+ * edits to fill in missing examples, e.g. #DB due to split-lock accesses,
+ * and less minor edits to splice in the priority of VMX Non-Root specific
+ * events, e.g. MTF and NMI/INTR-window exiting.
+ *
+ * 1 Hardware Reset and Machine Checks
+ *	- RESET
+ *	- Machine Check
+ *
+ * 2 Trap on Task Switch
+ *	- T flag in TSS is set (on task switch)
+ *
+ * 3 External Hardware Interventions
+ *	- FLUSH
+ *	- STOPCLK
+ *	- SMI
+ *	- INIT
+ *
+ * 3.5 Monitor Trap Flag (MTF) VM-exit[1]
+ *
+ * 4 Traps on Previous Instruction
+ *	- Breakpoints
+ *	- Trap-class Debug Exceptions (#DB due to TF flag set, data/I-O
+ *	  breakpoint, or #DB due to a split-lock access)
+ *
+ * 4.3	VMX-preemption timer expired VM-exit
+ *
+ * 4.6	NMI-window exiting VM-exit[2]
+ *
+ * 5 Nonmaskable Interrupts (NMI)
+ *
+ * 5.5 Interrupt-window exiting VM-exit and Virtual-interrupt delivery
+ *
+ * 6 Maskable Hardware Interrupts
+ *
+ * 7 Code Breakpoint Fault
+ *
+ * 8 Faults from Fetching Next Instruction
+ *	- Code-Segment Limit Violation
+ *	- Code Page Fault
+ *	- Control protection exception (missing ENDBRANCH at target of indirect
+ *					call or jump)
+ *
+ * 9 Faults from Decoding Next Instruction
+ *	- Instruction length > 15 bytes
+ *	- Invalid Opcode
+ *	- Coprocessor Not Available
+ *
+ *10 Faults on Executing Instruction
+ *	- Overflow
+ *	- Bound error
+ *	- Invalid TSS
+ *	- Segment Not Present
+ *	- Stack fault
+ *	- General Protection
+ *	- Data Page Fault
+ *	- Alignment Check
+ *	- x86 FPU Floating-point exception
+ *	- SIMD floating-point exception
+ *	- Virtualization exception
+ *	- Control protection exception
+ *
+ * [1] Per the "Monitor Trap Flag" section: System-management interrupts (SMIs),
+ *     INIT signals, and higher priority events take priority over MTF VM exits.
+ *     MTF VM exits take priority over debug-trap exceptions and lower priority
+ *     events.
+ *
+ * [2] Debug-trap exceptions and higher priority events take priority over VM exits
+ *     caused by the VMX-preemption timer.  VM exits caused by the VMX-preemption
+ *     timer take priority over VM exits caused by the "NMI-window exiting"
+ *     VM-execution control and lower priority events.
+ *
+ * [3] Debug-trap exceptions and higher priority events take priority over VM exits
+ *     caused by "NMI-window exiting".  VM exits caused by this control take
+ *     priority over non-maskable interrupts (NMIs) and lower priority events.
+ *
+ * [4] Virtual-interrupt delivery has the same priority as that of VM exits due to
+ *     the 1-setting of the "interrupt-window exiting" VM-execution control.  Thus,
+ *     non-maskable interrupts (NMIs) and higher priority events take priority over
+ *     delivery of a virtual interrupt; delivery of a virtual interrupt takes
+ *     priority over external interrupts and lower priority events.
+ */
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qual;
 	/*
 	 * Only a pending nested run blocks a pending exception.  If there is a
 	 * previously injected event, the pending exception occurred while said
@@ -3918,19 +3982,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		/* Fallthrough, the SIPI is completely ignored. */
 	}
 
-	/*
-	 * Process exceptions that are higher priority than Monitor Trap Flag:
-	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
-	 * could theoretically come in from userspace), and ICEBP (INT1).
-	 */
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
-	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
+	    !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
 		if (block_nested_exceptions)
 			return -EBUSY;
-		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-			goto no_vmexit;
-		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
-		return 0;
+		goto no_vmexit;
 	}
 
 	if (vmx->nested.mtf_pending) {
@@ -3941,13 +4006,18 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
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
@@ -6828,6 +6898,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
+	.is_exception_vmexit = nested_vmx_is_exception_vmexit,
 	.check_events = vmx_check_nested_events,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9f9b601fd6f6..0420bc6d418a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1577,7 +1577,9 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
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
@@ -5479,7 +5481,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	return vmx->emulation_required && !vmx->rmode.vm86_active &&
-	       vcpu->arch.exception.pending;
+	       kvm_is_exception_pending(vcpu);
 }
 
 static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 327a935712fb..bb1bd332d535 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -615,6 +615,21 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
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
@@ -624,18 +639,31 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
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
@@ -738,19 +766,22 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
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
 
-bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
+void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
 	struct kvm_mmu *fault_mmu;
@@ -769,7 +800,6 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				       fault_mmu->root.hpa);
 
 	fault_mmu->inject_page_fault(vcpu, fault);
-	return fault->nested_page_fault;
 }
 EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
 
@@ -4692,7 +4722,7 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 	return (kvm_arch_interrupt_allowed(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu) &&
 		!kvm_event_needs_reinjection(vcpu) &&
-		!vcpu->arch.exception.pending);
+		!kvm_is_exception_pending(vcpu));
 }
 
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
@@ -4821,13 +4851,27 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
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
@@ -4929,6 +4973,19 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
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
@@ -7825,18 +7882,17 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
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
@@ -8449,8 +8505,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	if (ctxt->have_exception) {
 		r = 1;
-		if (inject_emulated_exception(vcpu))
-			return r;
+		inject_emulated_exception(vcpu);
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
 			/* FIXME: return into emulator if single-stepping.  */
@@ -9348,7 +9403,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	 */
 	if (vcpu->arch.exception.injected)
 		kvm_inject_exception(vcpu);
-	else if (vcpu->arch.exception.pending)
+	else if (kvm_is_exception_pending(vcpu))
 		; /* see above */
 	else if (vcpu->arch.nmi_injected)
 		static_call(kvm_x86_inject_nmi)(vcpu);
@@ -9375,6 +9430,14 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
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
@@ -9477,7 +9540,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
 		*req_immediate_exit = true;
 
-	WARN_ON(vcpu->arch.exception.pending);
+	WARN_ON(kvm_is_exception_pending(vcpu));
 	return 0;
 
 out:
@@ -10349,8 +10412,8 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 /* Called within kvm->srcu read side.  */
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
-	int r;
 	struct kvm *kvm = vcpu->kvm;
+	int r;
 
 	vcpu->arch.l1tf_flush_l1d = true;
 
@@ -10486,6 +10549,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
 	struct kvm *kvm = vcpu->kvm;
 	int r;
@@ -10545,6 +10609,21 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
@@ -10649,6 +10728,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
 
 	vcpu->arch.exception.pending = false;
+	vcpu->arch.exception_vmexit.pending = false;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
@@ -11013,7 +11093,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
 		r = -EBUSY;
-		if (vcpu->arch.exception.pending)
+		if (kvm_is_exception_pending(vcpu))
 			goto out;
 		if (dbg->control & KVM_GUESTDBG_INJECT_DB)
 			kvm_queue_exception(vcpu, DB_VECTOR);
@@ -12147,7 +12227,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.pv.pv_unhalted)
 		return true;
 
-	if (vcpu->arch.exception.pending)
+	if (kvm_is_exception_pending(vcpu))
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
@@ -12414,7 +12494,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 {
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
-		     vcpu->arch.exception.pending))
+		     kvm_is_exception_pending(vcpu)))
 		return false;
 
 	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d8b44913aa62..3be9ccd6492e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -61,10 +61,17 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
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
2.35.1.723.g4982287a31-goog

