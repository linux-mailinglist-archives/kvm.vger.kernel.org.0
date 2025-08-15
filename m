Return-Path: <kvm+bounces-54740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7100B273EE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33FCC3B088D
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7700821E08D;
	Fri, 15 Aug 2025 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ak3PZNyt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EB1219E8F
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217574; cv=none; b=Z/l+OsHPuII0gwaE/rDAaQl3BVHDal/QAcWO0o04OvUA1gj7UuvaRRWevjHW7nlILJfKe8suwaPeoDyNcq9Vlunw264tuoWS6qEW3X7QgNcftrNmm8ysHy+CamLHro1yk44RgTYX9/F1ImmBE8BXMyGTpF/rR46YhaT8PbKFpUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217574; c=relaxed/simple;
	bh=G0NDwdIsj2ihwhmwFEESAYrV0+xgoRspOIEsyi/reJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RQ/Zlo8dlOClUe5RSF6kVzO6BFaegv5KegzKnlUQWodFx9Lu3a6F2B2/RbPBLM7UNEnW5J5W1PjxXbcIe4y0W54742tf+rvADMl4r1ZGJXey1FLEjm86JuzHhQlcrfaB9MsHfQOpgJztlTrYXpfGUOY69V8Snau6o5kanAcuInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ak3PZNyt; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471751e03aso914514a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217572; x=1755822372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1NmwxF8lRbh39Vs4VzCJzcU0jFcojuDEO3hNXRHfjBo=;
        b=Ak3PZNytJKQVCSZF7Y/bA2TlSsYzuK7b0RmyUBczC5BMBFa3ozcYzHJVovHoeioFWW
         lsT84Afg/J3nmwq0Wc/0CA6iKzCTTRatYuqxPIaDbNqfKHQZSdIE1LzQuwHwkdZcjWJm
         VoAl0RTw+6opHnjBsUHIIfhfMhhD+1dmvI12xgrqptleTMAvSUh59JQFsQe4qsfuDLsG
         MiYsCgQavge8Gxwqv+gsWtOwlAWkdxwo5bVgAHEJAGFsqzISrwPQiPf9VU+IbnQnag2A
         gb/y4G8EazzBGGtNYvJegTCKqFyNWfxnK/4TGhQuVyacWGTPFc8qmi66LF4X48D5VZZp
         WWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217572; x=1755822372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NmwxF8lRbh39Vs4VzCJzcU0jFcojuDEO3hNXRHfjBo=;
        b=G7bBAjDEfbZgmBU76gebzWsBiImsmFnxn1/lUrdy8E1GEE8ZC7i+pUVwrjCgZK5B3/
         4wdhnKaGF5ABqMTQCCFKA43/Hr/Yf5oS+Jteln2pJpyxW9DlNI/wnS5afvsJ0EUDwHMX
         Gg90aQFunHwdgBjhf4rmNKRH6csejNO4obF4rVV63OG13IJQh0sG90oa8ITcNHl8pY9q
         Wc0dz2SyzwsOLELlVB95ms4XNQjhRD3vUkphyrvuK+ht7IUfBG047hIacEiLnpPVwvNB
         +oqEbN3tn1DHmib55qFz6eRkwjYHmmeZJST1aKsmtzdk6oCo+S8d/bLIzg4hqF4e2xX4
         QhVg==
X-Gm-Message-State: AOJu0Yw6pVeoQWZex3kr4oijT7I+BKhGrF3+hQAqkihnDjAQzGhr+/Ev
	yt5EXMxfvbEKMqqtfyyIwpexT/ehEHhPvSu3yEUVDDn2HVJUnesc/Qu+HjwWfkZmJ5enxZAks72
	lgy/83w==
X-Google-Smtp-Source: AGHT+IH2BIHh4aF3U2IC72sjj70AoxLnpMAEq15LWoYKP66FH7E3+j4ib0fRj/VB4ZEYKYDvyceF1SCk+u8=
X-Received: from pjyp16.prod.google.com ([2002:a17:90a:e710:b0:31c:160d:e3be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5450:b0:323:284a:5c3f
 with SMTP id 98e67ed59e1d1-32341e0f372mr363134a91.8.1755217572354; Thu, 14
 Aug 2025 17:26:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:35 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-16-seanjc@google.com>
Subject: [PATCH 6.6.y 15/20] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of
 a new KVM_RUN flag
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 80c64c7afea1da6a93ebe88d3d29d8a60377ef80 ]

Instruct vendor code to load the guest's DR6 into hardware via a new
KVM_RUN flag, and remove kvm_x86_ops.set_dr6(), whose sole purpose was to
load vcpu->arch.dr6 into hardware when DR6 can be read/written directly
by the guest.

Note, TDX already WARNs on any run_flag being set, i.e. will yell if KVM
thinks DR6 needs to be reloaded.  TDX vCPUs force KVM_DEBUGREG_AUTO_SWITCH
and never clear the flag, i.e. should never observe KVM_RUN_LOAD_GUEST_DR6.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250610232010.162191-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: account for lack of vmx/main.c]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c             | 10 +++-------
 arch/x86/kvm/x86.c                 |  2 +-
 5 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8fe6667d945f..a0a4fc684e63 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -48,7 +48,6 @@ KVM_X86_OP(set_idt)
 KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
-KVM_X86_OP(set_dr6)
 KVM_X86_OP(set_dr7)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa6d04cd9ee6..7373b22c02a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1552,6 +1552,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
 };
 
 struct kvm_x86_ops {
@@ -1600,7 +1601,6 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
-	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 61e5e261cde2..abff6d45ae33 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4241,10 +4241,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
 
 	/*
-	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
-	 * of a #DB.
+	 * Run with all-zero DR6 unless the guest can write DR6 freely, so that
+	 * KVM can get the exact cause of a #DB.  Note, loading guest DR6 from
+	 * KVM's snapshot is only necessary when DR accesses won't exit.
 	 */
-	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
+	if (unlikely(run_flags & KVM_RUN_LOAD_GUEST_DR6))
+		svm_set_dr6(vcpu, vcpu->arch.dr6);
+	else if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
 
 	clgi();
@@ -5021,7 +5024,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
-	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 065aac2f4bce..08ca218ee858 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5616,12 +5616,6 @@ static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	lockdep_assert_irqs_disabled();
-	set_debugreg(vcpu->arch.dr6, 6);
-}
-
 static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
@@ -7392,6 +7386,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
+	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
+		set_debugreg(vcpu->arch.dr6, 6);
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
@@ -8337,7 +8334,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
-	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 342e666a0d13..07207d8126b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10772,7 +10772,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-			static_call(kvm_x86_set_dr6)(vcpu, vcpu->arch.dr6);
+			run_flags |= KVM_RUN_LOAD_GUEST_DR6;
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}
-- 
2.51.0.rc1.163.g2494970778-goog


