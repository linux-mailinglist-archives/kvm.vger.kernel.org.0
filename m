Return-Path: <kvm+bounces-48920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A92B2AD469A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 564403A756A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD362949F1;
	Tue, 10 Jun 2025 23:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K76Kca1r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E965C28C851
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597620; cv=none; b=WWZxKXauSgr/05DdzQ/7eEYWfgDXSEzvmrWaWkgdpfmsi3g1c86Hn2ucN5kSwzzdbWnS0Oa6MGV9cX3yDs7AeJd6OxjiT2gIYTJlSqaJoR36viQStoLSPXAVEgSG/zLQSQ607RG1LtnYXilgSy0MHi4m5b8pVdv+/MjKBP+Kn5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597620; c=relaxed/simple;
	bh=/GrueF4/4VzX9HvePqDLJQotf6MibkUeriiIghERhAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pB9UDGm4yJ2S9cz+Q+r2IkKMpsf6Vik6RT1FKzwcTgKBuQUS7TFPHLrCllvX0qguyUMACVNxV8HoLtdMGBpc/qUHYMu7dImzSd3OiusAMTjHTXwGKLMvMnjspmgAXNhhjE65UbTgfSu+q+MXj9SQAyN4MwLgNB2hBLXrIrWa3i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K76Kca1r; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235196dfc50so2351675ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597618; x=1750202418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZD2zb4VRV90wfolGMekjxO+vJFvmvxscHZ+rJPfgPeU=;
        b=K76Kca1ra+uwmpJYsFEENYhCcz0NowI7WZWMtLeP68sthCz36eTL2Vgsw3HB1NsutB
         uHfFWL2j/iL5k2lDRHl1/0Mb4S6hKpXZ4jBOrK50M8rvQCsqobZ454lg2FlJ0VN0A1Bv
         im4hdfnoTIkoM1JqcOlany/47RZK/TVCmhI/pj7aX/yQ3/QHfsuexjFBHOd1Iic+hT15
         JbrdEGc6siY+8vAjxHVLuzmb2+HGMpO46DLbO9keXzZ7Zrm7SQJiqK4+z0adAGGVQYXC
         wa7AhNVGaH1Z1bGFmIzRstf5DugNg1PKsc9I5VAfaZaV2AlPKKa1tee9yfCkYZsESuob
         jBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597618; x=1750202418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZD2zb4VRV90wfolGMekjxO+vJFvmvxscHZ+rJPfgPeU=;
        b=PmHdOkaUu+8ChPeRwdP23nTxPkT2b/WT/ms47R9qcgEzkVFWRJClnNmyzEodTXe6N/
         r8EAyBGI+Wv7TmsuEkLDbZq/rWbom+i104kQSG+izIpGfg3tpkYbPM/+aNfI0UKUs+9D
         SpCmPE9JrKLh477eS2lG2Mbs7D1JMpJws8xTiFwg6Fr0BYNtyKr1T05Y8Ns++V3wHAOJ
         8eX/EQNaM+q0/k1OsJG023LMerQL24X0Qseny0FO24kNkZfCKz2eunIZF2M+NqwiY+Qx
         leHwXLmi5QjJCBXW5kcEi5E8XjA5iJuQAVKhcpeXTbnQa256WuauGoBB0nJgYvA8YZk+
         8DDA==
X-Gm-Message-State: AOJu0YysiOfdfDeKx5w+f9Sgges/ZWTNPGjGH2w6XaT6T2ncDzKa5IRj
	kDx00xLL8wLzEXd0Z7VCQp6GaEnW7t4qCagq5Kcb+JzSwCd6ws5/OAaj74tCr9KrZs9zvYMLfhx
	Sd22iuw==
X-Google-Smtp-Source: AGHT+IEaqCAdZAzPWEw+OpJegnHgNVKOWzrYf9ueLpyQqeg013/p+WjHffoVHQu35bujuPyEWye3Pd4Ouvw=
X-Received: from pjbos11.prod.google.com ([2002:a17:90b:1ccb:b0:311:4201:4021])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:948:b0:234:5ea1:6041
 with SMTP id d9443c01a7336-236416ba5f4mr16534565ad.10.1749597618154; Tue, 10
 Jun 2025 16:20:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:05 -0700
In-Reply-To: <20250610232010.162191-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-4-seanjc@google.com>
Subject: [PATCH v6 3/8] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new
 KVM_RUN flag
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Instruct vendor code to load the guest's DR6 into hardware via a new
KVM_RUN flag, and remove kvm_x86_ops.set_dr6(), whose sole purpose was to
load vcpu->arch.dr6 into hardware when DR6 can be read/written directly
by the guest.

Note, TDX already WARNs on any run_flag being set, i.e. will yell if KVM
thinks DR6 needs to be reloaded.  TDX vCPUs force KVM_DEBUGREG_AUTO_SWITCH
and never clear the flag, i.e. should never observe KVM_RUN_LOAD_GUEST_DR6.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             | 10 ++++++----
 arch/x86/kvm/vmx/main.c            |  9 ---------
 arch/x86/kvm/vmx/vmx.c             |  9 +++------
 arch/x86/kvm/x86.c                 |  2 +-
 6 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..9e0c37ea267e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -49,7 +49,6 @@ KVM_X86_OP(set_idt)
 KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
-KVM_X86_OP(set_dr6)
 KVM_X86_OP(set_dr7)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3b5871ebd7e4..3d6325369a4b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1675,6 +1675,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
+	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
 };
 
 struct kvm_x86_ops {
@@ -1727,7 +1728,6 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
-	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 00d78090de3d..171e5be16802 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4451,10 +4451,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
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
@@ -5265,7 +5268,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
-	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fef3e3803707..c85cbce6d2f6 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -489,14 +489,6 @@ static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 	vmx_set_gdt(vcpu, dt);
 }
 
-static void vt_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	if (is_td_vcpu(vcpu))
-		return;
-
-	vmx_set_dr6(vcpu, val);
-}
-
 static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	if (is_td_vcpu(vcpu))
@@ -943,7 +935,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_idt = vt_op(set_idt),
 	.get_gdt = vt_op(get_gdt),
 	.set_gdt = vt_op(set_gdt),
-	.set_dr6 = vt_op(set_dr6),
 	.set_dr7 = vt_op(set_dr7),
 	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
 	.cache_reg = vt_op(cache_reg),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e66f5ffa8716..49bf58ca9ffd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5604,12 +5604,6 @@ void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
-void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
-{
-	lockdep_assert_irqs_disabled();
-	set_debugreg(vcpu->arch.dr6, 6);
-}
-
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
@@ -7364,6 +7358,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
+	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
+		set_debugreg(vcpu->arch.dr6, 6);
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d4a51b263d6b..6742eb556d91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11046,7 +11046,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
+			run_flags |= KVM_RUN_LOAD_GUEST_DR6;
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}
-- 
2.50.0.rc0.642.g800a2b2222-goog


