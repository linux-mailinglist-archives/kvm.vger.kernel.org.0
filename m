Return-Path: <kvm+bounces-8044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A46F84A783
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:35:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C94C1C27307
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 21:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402CF84FCC;
	Mon,  5 Feb 2024 19:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qCyIX7ob"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807D484051
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707162802; cv=none; b=Y1U+QloB+MgnjPz/jz7ZdBHN8B7HyHC3NO7toGxPB8hTfcij5UmI4sxErikAkBE7db06t4LclMII+p1dX7vjzy2P8rnwKQBW9Ih9NAhjBF8E03vuu87jgTnUFTIFHDEtWsMg85YDJUZTztJ19Z0HGvrs6xo441oi3Lw3F1gmeVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707162802; c=relaxed/simple;
	bh=jZRv8itKaPnOpEu+wwWpRGtxcnj8s2QUKv+eAKP5POw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DTT6/EdstIFb+isHXqn/P6Xh3tzRe5YQc7y/iDqJvOmCrOT/FSGWtnl0ByTQ/l5Yp7M8qzxchbWV/CQG67fYweHykGHF0wn8krFYls44SQzwRPEC9jrWDqqdVZ+d7ESUCZAh3ctTJ41ZRdJt5ckNJDLK1pLWAPlnpFq7A7wtl8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qCyIX7ob; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6040f058d3fso106077417b3.3
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 11:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707162799; x=1707767599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mR0JyUctXntX6xrlSqqa1F9irdK0t/gq0bkhIw77qws=;
        b=qCyIX7obVhO+pIwLQIUCOQaAvA7O650ljYI8lLLWltPqLrG39aSC/hl9lNVyjOYCOH
         b3Y8V6tdyaXc907//RfPDU6G7SmJnVWzHCSgXmCq/iNz4ruJuZp86f8FzKlbxUGnHbh/
         Y/Qxb2g/8R0UrOLapu/YoUJmUdq96rgIFNVSXfPKB7u7M34NwdngpQ2MMe3byixHdL+z
         QyqiKurotwC93mFFz0YAajBH4Qjz5rA+DNtyUYlWHwmRnlEvR66BO8i+5N9GDKyoVH1i
         PN5PBY80zE2TVuqigbRk2F0qNzVQb04POhMAmdSjAkrdKHJkBv5lD+Hl8nmQXVeOLrm7
         /rBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707162799; x=1707767599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mR0JyUctXntX6xrlSqqa1F9irdK0t/gq0bkhIw77qws=;
        b=Dr/rcfXdzpr19+Cpl5ml0UOF0D5uokA7LrpkcnV7kGomxEH1vAoNXOGxz8EnzouCWp
         KUU+fTFJ0SABABkDujae7/ujJqDXdgt/pN4pEh18nMK3OfXhYd65R2E8wvmT14p1cw/7
         vjyK5wD5CN853Y3x9pwil8BHx8I/fTK+ZsO8zqAH3CTUIfa1OUGavpGSDdGHlwSzKb7q
         zbnyZadQSi3gAunV00ITz6fM86fEDoylifCsyVTZM/e9S0RTNkvvQ+Xav51FlaxIkEMx
         GmiyVgFxX0oF9tilFbXUtodkqa3ya/v9WRd7gVBaDU+mwnx1yshPCMDS3EulyHphzaUu
         vuIw==
X-Gm-Message-State: AOJu0Yzo5AHDFHIEH2/cTqn2QT4VkYTuZ3fl/YfJmDSJmlIzFTGw2lzA
	cT0d2uVJ84kuFJALDzBfSVpCPEKutXiZ1yEzVXk+Dl+XY6Ljgz7ULdxc/FbAzzRwjBBPI3FyhVG
	Wqw==
X-Google-Smtp-Source: AGHT+IHD2z+BfZZPmCwQp1UHaG5MZacGl5kLBqTQGuOOCsv953ZbL7QURzJUrT4EgpWKQoP1ShleUAqaGVc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9ad6:0:b0:5fc:d439:4936 with SMTP id
 r205-20020a819ad6000000b005fcd4394936mr121812ywg.8.1707162799558; Mon, 05 Feb
 2024 11:53:19 -0800 (PST)
Date: Mon, 5 Feb 2024 11:53:17 -0800
In-Reply-To: <20240203124522.592778-3-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203124522.592778-1-minipli@grsecurity.net> <20240203124522.592778-3-minipli@grsecurity.net>
Message-ID: <ZcE8rXJiXFS6OFRR@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 03, 2024, Mathias Krause wrote:
> Take 'dr6' from the arch part directly as already done for 'dr7'.
> There's no need to take the clunky route via kvm_get_dr().
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/x86.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 13ec948f3241..0f958dcf8458 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5504,12 +5504,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  					     struct kvm_debugregs *dbgregs)
>  {
> -	unsigned long val;
> -
>  	memset(dbgregs, 0, sizeof(*dbgregs));
>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
> -	kvm_get_dr(vcpu, 6, &val);
> -	dbgregs->dr6 = val;
> +	dbgregs->dr6 = vcpu->arch.dr6;

Blech, kvm_get_dr() is so dumb, it takes an out parameter despite have a void
return.  I would rather fix that wart and go the other direction, i.e. make dr7
go through kvm_get_dr().  This obviously isn't a fast path, so the extra CALL+RET
is a non-issue.  And if we wanted to fix that, e.g. for other paths that are
slightly less slow, we should do so for all reads (and writes) to dr6 and dr7,
e.g. provide dedicated APIs like we do for GPRs.

Alternatively, I would probably be ok just open coding all direct reads and writes
to dr6 and dr7.  IIRC, at one point KVM was doing something meaningful in kvm_get_dr()
for DR7 (which probably contributed to the weird API), but that's no longer the
case.

Actually, it probably makes sense to do both, i.e. do the below, and then open
code all direct accesses.  I think the odds of us needing wrappers around reading
and writing guest DR6 and DR7 are quite low and there are enough existing open coded
accesses that forcing them to convert would be awkward.

I'll send a small two patch series.

---
Subject: [PATCH] KVM: x86: Make kvm_get_dr() return a value, not use an out
 parameter

TODO: writeme

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/emulate.c          | 17 ++++-------------
 arch/x86/kvm/kvm_emulate.h      |  2 +-
 arch/x86/kvm/smm.c              | 15 ++++-----------
 arch/x86/kvm/svm/svm.c          |  7 ++-----
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 +----
 arch/x86/kvm/x86.c              | 20 ++++++++------------
 8 files changed, 22 insertions(+), 48 deletions(-)

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
index dc3d95fdca7d..f5a30d3a44a1 100644
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
+	smram->dr7 = kvm_get_dr(vcpu, 7);;
 
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
index c339d9f95b4b..b2357009bbbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1399,21 +1399,21 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 }
 EXPORT_SYMBOL_GPL(kvm_set_dr);
 
-void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
+unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr)
 {
 	size_t size = ARRAY_SIZE(vcpu->arch.db);
 
 	switch (dr) {
 	case 0 ... 3:
-		*val = vcpu->arch.db[array_index_nospec(dr, size)];
+		return vcpu->arch.db[array_index_nospec(dr, size)];
 		break;
 	case 4:
 	case 6:
-		*val = vcpu->arch.dr6;
+		return vcpu->arch.dr6;
 		break;
 	case 5:
 	default: /* 7 */
-		*val = vcpu->arch.dr7;
+		return vcpu->arch.dr7;
 		break;
 	}
 }
@@ -5510,13 +5510,10 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 					     struct kvm_debugregs *dbgregs)
 {
-	unsigned long val;
-
 	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
-	kvm_get_dr(vcpu, 6, &val);
-	dbgregs->dr6 = val;
-	dbgregs->dr7 = vcpu->arch.dr7;
+	dbgregs->dr6 = kvm_get_dr(vcpu, 6);
+	dbgregs->dr7 = kvm_get_dr(vcpu, 7);
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
@@ -8165,10 +8162,9 @@ static void emulator_wbinvd(struct x86_emulate_ctxt *ctxt)
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

base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
-- 


