Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5290C63C8A1
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiK2TlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiK2Tkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B98062E4
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztV2NkJ9fzkBSStJHJoXJSpsO1jLyNUEDLKWsHdAan8=;
        b=O/HGwd491S+ho5ZM81/P+Fp3Azfpn6KaNaxAgSpvY4VN4tUCvvVyHNonQccabU149sEFZD
        uPArLXdLwN1tyorkXb+2VBNJrHj+ZEtdllzTp2mIi7SUrmpWYJ8zDvd+74r23Mbv/KeC80
        pmvv1677We1HOUZS6F/r9YX3h8wH0Pk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-b3cAepYqMuyaQIwk2L2AsQ-1; Tue, 29 Nov 2022 14:37:44 -0500
X-MC-Unique: b3cAepYqMuyaQIwk2L2AsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A7511C06ED8;
        Tue, 29 Nov 2022 19:37:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F6A82028DC1;
        Tue, 29 Nov 2022 19:37:39 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 05/11] KVM: x86: emulator: stop using raw host flags
Date:   Tue, 29 Nov 2022 21:37:11 +0200
Message-Id: <20221129193717.513824-6-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of re-defining the H_FLAGS bits, just expose the 'in_smm'
and the 'in_guest_mode' host flags using emulator callbacks.

Also while at it, garbage collect the recently removed host flags.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/emulate.c          | 11 +++++------
 arch/x86/kvm/kvm_emulate.h      |  7 ++-----
 arch/x86/kvm/smm.c              |  2 --
 arch/x86/kvm/x86.c              | 14 +++++++++-----
 5 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9208ad7a6bd004..684a5519812fb2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2052,11 +2052,11 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
-#define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
+#define HF_GUEST_MASK		(1 << 0) /* VCPU is in guest-mode */
 
 #ifdef CONFIG_KVM_SMM
-#define HF_SMM_MASK		(1 << 6)
-#define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
+#define HF_SMM_MASK		(1 << 1)
+#define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
 # define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5cc3efa0e21c17..d869131f84ffb3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2309,7 +2309,7 @@ static int em_lseg(struct x86_emulate_ctxt *ctxt)
 
 static int em_rsm(struct x86_emulate_ctxt *ctxt)
 {
-	if ((ctxt->ops->get_hflags(ctxt) & X86EMUL_SMM_MASK) == 0)
+	if (!ctxt->ops->in_smm(ctxt))
 		return emulate_ud(ctxt);
 
 	if (ctxt->ops->leave_smm(ctxt))
@@ -5132,7 +5132,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	const struct x86_emulate_ops *ops = ctxt->ops;
 	int rc = X86EMUL_CONTINUE;
 	int saved_dst_type = ctxt->dst.type;
-	unsigned emul_flags;
+	bool in_guest_mode = ctxt->ops->in_guest_mode(ctxt);
 
 	ctxt->mem_read.pos = 0;
 
@@ -5147,7 +5147,6 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		goto done;
 	}
 
-	emul_flags = ctxt->ops->get_hflags(ctxt);
 	if (unlikely(ctxt->d &
 		     (No64|Undefined|Sse|Mmx|Intercept|CheckPerm|Priv|Prot|String))) {
 		if ((ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) ||
@@ -5181,7 +5180,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 				fetch_possible_mmx_operand(&ctxt->dst);
 		}
 
-		if (unlikely(emul_flags & X86EMUL_GUEST_MASK) && ctxt->intercept) {
+		if (unlikely(in_guest_mode) && ctxt->intercept) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_PRE_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -5210,7 +5209,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 				goto done;
 		}
 
-		if (unlikely(emul_flags & X86EMUL_GUEST_MASK) && (ctxt->d & Intercept)) {
+		if (unlikely(in_guest_mode) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_POST_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -5264,7 +5263,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 special_insn:
 
-	if (unlikely(emul_flags & X86EMUL_GUEST_MASK) && (ctxt->d & Intercept)) {
+	if (unlikely(in_guest_mode) && (ctxt->d & Intercept)) {
 		rc = emulator_check_intercept(ctxt, ctxt->intercept,
 					      X86_ICPT_POST_MEMACCESS);
 		if (rc != X86EMUL_CONTINUE)
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 2d9662be833378..dd0203fbb27543 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -220,7 +220,8 @@ struct x86_emulate_ops {
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
-	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
+	bool (*in_smm)(struct x86_emulate_ctxt *ctxt);
+	bool (*in_guest_mode)(struct x86_emulate_ctxt *ctxt);
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
@@ -275,10 +276,6 @@ enum x86emul_mode {
 	X86EMUL_MODE_PROT64,	/* 64-bit (long) mode.    */
 };
 
-/* These match some of the HF_* flags defined in kvm_host.h  */
-#define X86EMUL_GUEST_MASK           (1 << 5) /* VCPU is in guest-mode */
-#define X86EMUL_SMM_MASK             (1 << 6)
-
 /*
  * fastop functions are declared as taking a never-defined fastop parameter,
  * so they can't be called from C directly.
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index a9c1c2af8d94c2..a3a94edd2f0bc9 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -110,8 +110,6 @@ static void check_smram_offsets(void)
 
 void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
-	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
-
 	trace_kvm_smm_transition(vcpu->vcpu_id, vcpu->arch.smbase, entering_smm);
 
 	if (entering_smm) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f18f579ebde81c..85d2a12c214dda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8138,9 +8138,14 @@ static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
 	static_call(kvm_x86_set_nmi_mask)(emul_to_vcpu(ctxt), masked);
 }
 
-static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
+static bool emulator_in_smm(struct x86_emulate_ctxt *ctxt)
 {
-	return emul_to_vcpu(ctxt)->arch.hflags;
+	return emul_to_vcpu(ctxt)->arch.hflags & HF_SMM_MASK;
+}
+
+static bool emulator_in_guest_mode(struct x86_emulate_ctxt *ctxt)
+{
+	return emul_to_vcpu(ctxt)->arch.hflags & HF_GUEST_MASK;
 }
 
 #ifndef CONFIG_KVM_SMM
@@ -8209,7 +8214,8 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
 	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
-	.get_hflags          = emulator_get_hflags,
+	.in_smm              = emulator_in_smm,
+	.in_guest_mode       = emulator_in_guest_mode,
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
@@ -8281,8 +8287,6 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 		     (cs_l && is_long_mode(vcpu))	? X86EMUL_MODE_PROT64 :
 		     cs_db				? X86EMUL_MODE_PROT32 :
 							  X86EMUL_MODE_PROT16;
-	BUILD_BUG_ON(HF_GUEST_MASK != X86EMUL_GUEST_MASK);
-
 	ctxt->interruptibility = 0;
 	ctxt->have_exception = false;
 	ctxt->exception.vector = -1;
-- 
2.26.3

