Return-Path: <kvm+bounces-8494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8534984FF6A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:08:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45B40283001
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DFC2E40E;
	Fri,  9 Feb 2024 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iV3pRkWz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47BB33CD5
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516478; cv=none; b=KIY2SJ2ILwqAkNht/hEdf++rze0yR3lP4eE2oWsz6aVrBEbRT3GpnM51m8WH+OTVps2gKT1cARCMdWaace97ilsMqEL6jg43ldl7nO8i0UmP//eYcRMpB6QxCqu9M9qRzWeZVGMdvFav8lbcwPOO4ewUtT9prQHBUgsFuRKiYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516478; c=relaxed/simple;
	bh=tE+i5lckoNKi5LZ+zGcYRN1t8CsZXHHGefdI5PfmogI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B+s79yuxjHuhOZwF9rfe2YKr2tQXKFC5Co7Y1xMAHjajZ9EHhRdIP2AF3XII8dRmGEVkvwZJXWOuk4VrgxvqpVWUXj30B995KJqNWSaxp3rjUNqXD0WQqBCk04XIeTgQTUjY0A9zYA15elRh5oVpzuGP9wBWqMcnYpkihDGM0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iV3pRkWz; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6dd65194396so2781697b3a.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707516476; x=1708121276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5iZonwpCcwElOpqVQkLRvEEz2rVwQoo1oJ2WukMR1A=;
        b=iV3pRkWzjlWhe4rHpFOiBX0l03uV4aOOWm0UaKQHif4Nkdup2G8PLIKcwQhCk9AEdr
         LaGG424y8o99rC3dr3vxhSOoR/peI4yeFeX1+s49V29JXxlifwHTNtW7mqYxukR/u9cR
         ldhpY+WTIQQB1j0hq3K+yaAu54ckmO2EeegdjhgR5YTqj9nP/cSLNjL21LHx0qV4U/rv
         uc4GaQDmD2hS9pqAIC1SbLs+g2T2YacGYNoyU7VZ2wodnaDKfFdSCZ9cpukBFQiwxORx
         FquKcQb3fGyBMneR5BpQZSYdubjMd3tWrbtAD9x76Afrc+z4oL4mRuTgqU+mzTM1DqNn
         q5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707516476; x=1708121276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q5iZonwpCcwElOpqVQkLRvEEz2rVwQoo1oJ2WukMR1A=;
        b=g/UaoVTaR6MKDYOL27Z9oZlYUB/WMom+NgiEH2DQMRTQWCXG7ifxm8EKUh8xK7Pmi+
         PqZTCvilCCqP/+ysVehOR1OwBAPvCMU6cJrWxPNOx2v32hR7JSn770CXChnNOJuQJf3H
         OW6lEt+T0+hoMG0atc5erZPYDpfnxU07cMKepXYfsb+UGJ1WseEa01+i3qQPpWWSyZhM
         N32IuPCM0Aswc99AMDYCqMrt2+GeLzSOwu6IY/lAOkLUj+tuTTnlTna00BxxX3BCgldO
         vrzACrx1kFLAvkF2vbq2D/ns7aicl7+wr8HOAVdC7zM5R1mX5oHZCYbqQY4Rl3CbR5AU
         TNCA==
X-Gm-Message-State: AOJu0YzO+WazD2+BWIB4VEQkkuaDlcy5RhBT+G6coXj2gTjTZR/Qb8MD
	Hx7sNTIfSi9Tjx2Dp3KfFPKUCOud3epmjyd8ymtF7VjkWWEQ01+7stxSIaL0kFIh28BhIGaCodS
	cdw==
X-Google-Smtp-Source: AGHT+IGEgW+nTH2s535ufAqGd1V+CP08RNOpdVFrmQ5xwVg9mYOBqWc8ji4I09q+8NDBwLwA1FBJzHbTbYI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:928b:b0:6e0:2d2c:d2ec with SMTP id
 jw11-20020a056a00928b00b006e02d2cd2ecmr21618pfb.0.1707516476036; Fri, 09 Feb
 2024 14:07:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:07:51 -0800
In-Reply-To: <20240209220752.388160-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209220752.388160-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209220752.388160-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Make kvm_get_dr() return a value, not use an
 out parameter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Convert kvm_get_dr()'s output parameter to a return value, and clean up
most of the mess that was created by forcing callers to provide a pointer.

No functional change intended.

Acked-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/emulate.c          | 17 ++++-------------
 arch/x86/kvm/kvm_emulate.h      |  2 +-
 arch/x86/kvm/smm.c              | 15 ++++-----------
 arch/x86/kvm/svm/svm.c          |  7 ++-----
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 +----
 arch/x86/kvm/x86.c              | 20 +++++++-------------
 8 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad5319a503f0..464fa2197748 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2046,7 +2046,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
-void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
+unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 695ab5b6055c..33444627fcf4 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3011,7 +3011,7 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 		ret = em_push(ctxt);
 	}
 
-	ops->get_dr(ctxt, 7, &dr7);
+	dr7 = ops->get_dr(ctxt, 7);
 	ops->set_dr(ctxt, 7, dr7 & ~(DR_LOCAL_ENABLE_MASK | DR_LOCAL_SLOWDOWN));
 
 	return ret;
@@ -3866,15 +3866,6 @@ static int check_cr_access(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
-{
-	unsigned long dr7;
-
-	ctxt->ops->get_dr(ctxt, 7, &dr7);
-
-	return dr7 & DR7_GD;
-}
-
 static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 {
 	int dr = ctxt->modrm_reg;
@@ -3887,10 +3878,10 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 	if ((cr4 & X86_CR4_DE) && (dr == 4 || dr == 5))
 		return emulate_ud(ctxt);
 
-	if (check_dr7_gd(ctxt)) {
+	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD) {
 		ulong dr6;
 
-		ctxt->ops->get_dr(ctxt, 6, &dr6);
+		dr6 = ctxt->ops->get_dr(ctxt, 6);
 		dr6 &= ~DR_TRAP_BITS;
 		dr6 |= DR6_BD | DR6_ACTIVE_LOW;
 		ctxt->ops->set_dr(ctxt, 6, dr6);
@@ -5449,7 +5440,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		ctxt->dst.val = ops->get_cr(ctxt, ctxt->modrm_reg);
 		break;
 	case 0x21: /* mov from dr to reg */
-		ops->get_dr(ctxt, ctxt->modrm_reg, &ctxt->dst.val);
+		ctxt->dst.val = ops->get_dr(ctxt, ctxt->modrm_reg);
 		break;
 	case 0x40 ... 0x4f:	/* cmov */
 		if (test_cc(ctxt->b, ctxt->eflags))
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 4351149484fb..5382646162a3 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -203,7 +203,7 @@ struct x86_emulate_ops {
 	ulong (*get_cr)(struct x86_emulate_ctxt *ctxt, int cr);
 	int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
 	int (*cpl)(struct x86_emulate_ctxt *ctxt);
-	void (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong *dest);
+	ulong (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr);
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
 	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index dc3d95fdca7d..19a7a0a31953 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -184,7 +184,6 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
 				    struct kvm_smram_state_32 *smram)
 {
 	struct desc_ptr dt;
-	unsigned long val;
 	int i;
 
 	smram->cr0     = kvm_read_cr0(vcpu);
@@ -195,10 +194,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
 	for (i = 0; i < 8; i++)
 		smram->gprs[i] = kvm_register_read_raw(vcpu, i);
 
-	kvm_get_dr(vcpu, 6, &val);
-	smram->dr6     = (u32)val;
-	kvm_get_dr(vcpu, 7, &val);
-	smram->dr7     = (u32)val;
+	smram->dr6     = (u32)kvm_get_dr(vcpu, 6);
+	smram->dr7     = (u32)kvm_get_dr(vcpu, 7);
 
 	enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG_TR);
 	enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_SREG_LDTR);
@@ -231,7 +228,6 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 				    struct kvm_smram_state_64 *smram)
 {
 	struct desc_ptr dt;
-	unsigned long val;
 	int i;
 
 	for (i = 0; i < 16; i++)
@@ -240,11 +236,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	smram->rip    = kvm_rip_read(vcpu);
 	smram->rflags = kvm_get_rflags(vcpu);
 
-
-	kvm_get_dr(vcpu, 6, &val);
-	smram->dr6 = val;
-	kvm_get_dr(vcpu, 7, &val);
-	smram->dr7 = val;
+	smram->dr6 = kvm_get_dr(vcpu, 6);
+	smram->dr7 = kvm_get_dr(vcpu, 7);
 
 	smram->cr0 = kvm_read_cr0(vcpu);
 	smram->cr3 = kvm_read_cr3(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..dda91f7cd71b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2735,7 +2735,6 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int reg, dr;
-	unsigned long val;
 	int err = 0;
 
 	/*
@@ -2763,11 +2762,9 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		val = kvm_register_read(vcpu, reg);
-		err = kvm_set_dr(vcpu, dr, val);
+		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
 	} else {
-		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
 	}
 
 	return kvm_complete_insn_gp(vcpu, err);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 994e014f8a50..28d1088a1770 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4433,7 +4433,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
-		kvm_get_dr(vcpu, 7, (unsigned long *)&vmcs12->guest_dr7);
+		vmcs12->guest_dr7 = kvm_get_dr(vcpu, 7);
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e262bc2ba4e5..aa47433d0c9b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5566,10 +5566,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 
 	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
 	if (exit_qualification & TYPE_MOV_FROM_DR) {
-		unsigned long val;
-
-		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
 		err = 0;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b66c45e7f6f8..bfffc13f91e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1399,22 +1399,19 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 }
 EXPORT_SYMBOL_GPL(kvm_set_dr);
 
-void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
+unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr)
 {
 	size_t size = ARRAY_SIZE(vcpu->arch.db);
 
 	switch (dr) {
 	case 0 ... 3:
-		*val = vcpu->arch.db[array_index_nospec(dr, size)];
-		break;
+		return vcpu->arch.db[array_index_nospec(dr, size)];
 	case 4:
 	case 6:
-		*val = vcpu->arch.dr6;
-		break;
+		return vcpu->arch.dr6;
 	case 5:
 	default: /* 7 */
-		*val = vcpu->arch.dr7;
-		break;
+		return vcpu->arch.dr7;
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_get_dr);
@@ -5505,7 +5502,6 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 					     struct kvm_debugregs *dbgregs)
 {
-	unsigned long val;
 	unsigned int i;
 
 	memset(dbgregs, 0, sizeof(*dbgregs));
@@ -5514,8 +5510,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
 		dbgregs->db[i] = vcpu->arch.db[i];
 
-	kvm_get_dr(vcpu, 6, &val);
-	dbgregs->dr6 = val;
+	dbgregs->dr6 = kvm_get_dr(vcpu, 6);
 	dbgregs->dr7 = vcpu->arch.dr7;
 }
 
@@ -8169,10 +8164,9 @@ static void emulator_wbinvd(struct x86_emulate_ctxt *ctxt)
 	kvm_emulate_wbinvd_noskip(emul_to_vcpu(ctxt));
 }
 
-static void emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
-			    unsigned long *dest)
+static unsigned long emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr)
 {
-	kvm_get_dr(emul_to_vcpu(ctxt), dr, dest);
+	return kvm_get_dr(emul_to_vcpu(ctxt), dr);
 }
 
 static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
-- 
2.43.0.687.g38aa6559b0-goog


