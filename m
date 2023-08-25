Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D4C787D40
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 03:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbjHYBg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbjHYBgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 21:36:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C238A10F4
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:36:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c0aaf4caaaso5628225ad.2
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692927389; x=1693532189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qFwlnRwlA9Pcgw83ghVUTUpUbTL5c6TrSmvpVeQlOSI=;
        b=rWMUp4+UZRDxcj/FmsFEl9Bny446asZs1yvFuXoyswCWJ9T/5fx5ZBm6RATp0dIw94
         7vzK3yywp2QNRfP369DeuJKXr4U8PoQm+LM2wni4hix132hGgb4LRDsydTHr0P7nqhN8
         MQoEsgyvE4gf3lYfqxwsSavu1HQzHoADCSBAJzxo1EjyLU4y8bLSHENPp9FfnduKmgXk
         wPpceH6jOlj6T11Azu71IqDuLVlq/LS+0OTpQfOWOxRHTa2ql5HHLQlH0pFWREhnqKFf
         UDTBHugVZjmByVpL3j/z1o28RbfipAuo4SgE4kBnalJWus3tLh8Rj9TBhS7QleDj66Va
         mX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692927389; x=1693532189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFwlnRwlA9Pcgw83ghVUTUpUbTL5c6TrSmvpVeQlOSI=;
        b=BnjfMAxEH48x7g5mtpxYjAL3Wm2IaMjOHSEqI8RZhNmjUKGq/yJ0/w8X9kop1kdfK6
         U4Ge887UZK2NqJ0yP0lEIzY7str3sv2ecM0Rxsd2kRTfDTigvi50OsEskU8ETPDgTn6l
         wodMwyV5W071oIH61vKkrvbd7YHovO1SWcqAI1RxVZ3Ws7bUtjirk5W1xLu2r1Mvo9bK
         WLSnCCyatTfqR3FWJFkzgFSBAIV3EzInsY5VrVPiY3wCfz4aJRsFBT0edTDmg4jEwTDt
         nHdJk0D25dGENdJTNWL8LJS8f+tMmmJvMyZdUbFWg6i3fFadcvMS/Rw3wMaOgpPkCd6m
         Qtkw==
X-Gm-Message-State: AOJu0Yz2NsFC99ZQPZdNl0k32jpfZx6cPAdq/jN322vivE+jkOof+SzK
        nK9fTQQcpExFmo0pCrBrYMwWp2VyVcU=
X-Google-Smtp-Source: AGHT+IH23uzGSC9Jib75RQ5v6ZuRbT3wj68jmFazJGmVBmw7Q73pT1lRHeuBZrNPglxYSWdNsE2nvNGUc8M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f683:b0:1bb:e7ce:17d9 with SMTP id
 l3-20020a170902f68300b001bbe7ce17d9mr7003860plg.6.1692927389308; Thu, 24 Aug
 2023 18:36:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 18:36:20 -0700
In-Reply-To: <20230825013621.2845700-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825013621.2845700-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825013621.2845700-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: x86: Refactor can_emulate_instruction() return to
 be more expressive
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor and rename can_emulate_instruction() to allow vendor code to
return more than true/false, e.g. to explicitly differentiate between
"retry", "fault", and "unhandleable".  For now, just do the plumbing, a
future patch will expand SVM's implementation to signal outright failure
if KVM attempts EMULTYPE_SKIP on an SEV guest.

No functional change intended (or rather, none that are visible to the
guest or userspace).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  4 ++--
 arch/x86/kvm/svm/svm.c             | 31 ++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.c             | 12 ++++++------
 arch/x86/kvm/x86.c                 | 15 +++++++++------
 5 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..ac01552316e1 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,7 +125,7 @@ KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
 KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
 KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
 KVM_X86_OP(get_msr_feature)
-KVM_X86_OP(can_emulate_instruction)
+KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9f57aa33798b..4760e60fad44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1734,8 +1734,8 @@ struct kvm_x86_ops {
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
-	bool (*can_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
-					void *insn, int insn_len);
+	int (*check_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
+					 void *insn, int insn_len);
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b21253c9ceb4..39ce680013c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -364,8 +364,8 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
 
 }
-static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
-					void *insn, int insn_len);
+static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					 void *insn, int insn_len);
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 					   bool commit_side_effects)
@@ -391,7 +391,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 		 * right thing and treats "can't emulate" as outright failure
 		 * for EMULTYPE_SKIP.
 		 */
-		if (!svm_can_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0))
+		if (svm_check_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0) != X86EMUL_CONTINUE)
 			return 0;
 
 		if (unlikely(!commit_side_effects))
@@ -4698,15 +4698,15 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
-static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
-					void *insn, int insn_len)
+static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					 void *insn, int insn_len)
 {
 	bool smep, smap, is_user;
 	u64 error_code;
 
 	/* Emulation is always possible when KVM has access to all guest state. */
 	if (!sev_guest(vcpu->kvm))
-		return true;
+		return X86EMUL_CONTINUE;
 
 	/* #UD and #GP should never be intercepted for SEV guests. */
 	WARN_ON_ONCE(emul_type & (EMULTYPE_TRAP_UD |
@@ -4718,14 +4718,14 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * to guest register state.
 	 */
 	if (sev_es_guest(vcpu->kvm))
-		return false;
+		return X86EMUL_RETRY_INSTR;
 
 	/*
 	 * Emulation is possible if the instruction is already decoded, e.g.
 	 * when completing I/O after returning from userspace.
 	 */
 	if (emul_type & EMULTYPE_NO_DECODE)
-		return true;
+		return X86EMUL_CONTINUE;
 
 	/*
 	 * Emulation is possible for SEV guests if and only if a prefilled
@@ -4751,9 +4751,11 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * success (and in practice it will work the vast majority of the time).
 	 */
 	if (unlikely(!insn)) {
-		if (!(emul_type & EMULTYPE_SKIP))
-			kvm_queue_exception(vcpu, UD_VECTOR);
-		return false;
+		if (emul_type & EMULTYPE_SKIP)
+			return X86EMUL_RETRY_INSTR;
+
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return X86EMUL_PROPAGATE_FAULT;
 	}
 
 	/*
@@ -4764,7 +4766,7 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * table used to translate CS:RIP resides in emulated MMIO.
 	 */
 	if (likely(insn_len))
-		return true;
+		return X86EMUL_CONTINUE;
 
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
@@ -4822,6 +4824,7 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 			kvm_inject_gp(vcpu, 0);
 		else
 			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return X86EMUL_PROPAGATE_FAULT;
 	}
 
 resume_guest:
@@ -4839,7 +4842,7 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * doesn't explicitly define "ignored", i.e. doing nothing and letting
 	 * the guest spin is technically "ignoring" the access.
 	 */
-	return false;
+	return X86EMUL_RETRY_INSTR;
 }
 
 static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
@@ -4998,7 +5001,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
 
-	.can_emulate_instruction = svm_can_emulate_instruction,
+	.check_emulate_instruction = svm_check_emulate_instruction,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6849f780dba..2d4a80c406cb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1642,8 +1642,8 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
-					void *insn, int insn_len)
+static int vmx_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					 void *insn, int insn_len)
 {
 	/*
 	 * Emulation of instructions in SGX enclaves is impossible as RIP does
@@ -1654,9 +1654,9 @@ static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 */
 	if (to_vmx(vcpu)->exit_reason.enclave_mode) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
-		return false;
+		return X86EMUL_PROPAGATE_FAULT;
 	}
-	return true;
+	return X86EMUL_CONTINUE;
 }
 
 static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
@@ -5770,7 +5770,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa;
 
-	if (!vmx_can_emulate_instruction(vcpu, EMULTYPE_PF, NULL, 0))
+	if (vmx_check_emulate_instruction(vcpu, EMULTYPE_PF, NULL, 0))
 		return 1;
 
 	/*
@@ -8317,7 +8317,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.enable_smi_window = vmx_enable_smi_window,
 #endif
 
-	.can_emulate_instruction = vmx_can_emulate_instruction,
+	.check_emulate_instruction = vmx_check_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4a939471df1..f897d582d560 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7458,11 +7458,11 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
-static int kvm_can_emulate_insn(struct kvm_vcpu *vcpu, int emul_type,
-				void *insn, int insn_len)
+static int kvm_check_emulate_insn(struct kvm_vcpu *vcpu, int emul_type,
+				  void *insn, int insn_len)
 {
-	return static_call(kvm_x86_can_emulate_instruction)(vcpu, emul_type,
-							    insn, insn_len);
+	return static_call(kvm_x86_check_emulate_instruction)(vcpu, emul_type,
+							      insn, insn_len);
 }
 
 int handle_ud(struct kvm_vcpu *vcpu)
@@ -7472,8 +7472,10 @@ int handle_ud(struct kvm_vcpu *vcpu)
 	int emul_type = EMULTYPE_TRAP_UD;
 	char sig[5]; /* ud2; .ascii "kvm" */
 	struct x86_exception e;
+	int r;
 
-	if (unlikely(!kvm_can_emulate_insn(vcpu, emul_type, NULL, 0)))
+	r = kvm_check_emulate_insn(vcpu, emul_type, NULL, 0);
+	if (r != X86EMUL_CONTINUE)
 		return 1;
 
 	if (fep_flags &&
@@ -8855,7 +8857,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	bool writeback = true;
 
-	if (unlikely(!kvm_can_emulate_insn(vcpu, emulation_type, insn, insn_len)))
+	r = kvm_check_emulate_insn(vcpu, emulation_type, insn, insn_len);
+	if (r != X86EMUL_CONTINUE)
 		return 1;
 
 	vcpu->arch.l1tf_flush_l1d = true;
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

