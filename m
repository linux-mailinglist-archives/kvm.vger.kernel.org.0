Return-Path: <kvm+bounces-52534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D70B06676
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36525564957
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6C72BE648;
	Tue, 15 Jul 2025 19:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TwVZ9USH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7C7464
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752606403; cv=none; b=NjWeCSQCNiUEXhnJ3WHttZPN6J8D23czEMqEAtdiVFNV/iWSknKrJnfc7jcB3CpI3K1TqyZ0Y5b6WZJpOz7LdnO1uc44a3jypNCeBOHV9x2MXCQTrfDHr+JpnZlaMYhUOFTMMoWq9r3D3VKYJSzG8mWR5QlMebvJRt/spCOWMzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752606403; c=relaxed/simple;
	bh=GTxT5dw0PVj8wMRhtSSRP76xX5fd2Cpp5r+28okB0A4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=p5xYiIO9QmC/q96cCykJNaWHTtiXamq3z4iOQ4pCOhyGGy4j/qjOZ1cuL+rfaToFofk+bHhB7dxNU7sUhtf7RPfr/Q/knnrpc/RlBNYvB5BUg0fwlHvUqeJ+nRRsOycf5VFokI0N4a00igsrIox5Xq5TdDV1AzAvLZGoHe4QG60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TwVZ9USH; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31bd4c3359so3284705a12.3
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 12:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752606401; x=1753211201; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9kM4hEAGClBPbwwJM/o6yebUkYu5yQUZuXR772mje4=;
        b=TwVZ9USH407tctEVAuc5brOp8akW+dyi/NaU6eVkg9cP/6AX89XqUd8nfq6kVWvWOZ
         aerIMVeQs+mcwXwzm2l96JhaSRkDMXqrH5Hjf8BFBbsDZMagyECurpPF/EMFoEgFZVBQ
         PDzc2ZSSvH519BLXvzlXBYQVDwi04LBThe9cYZbcZHA98yCW/YP+TDvTUkEEou0zf1eO
         Wys5VIYLjj4Cboy9mY8prDZXdw5uLE9LVGjk1T3IVAEbMXyOoZO8vdoBOfJXDUg4pLUg
         Xpra7HCMxHTUHyR4s6J62kk/Wxk50ApaPjAl11yfPWxr8c1XJ0t4P3E1SHcQFHaQaBPJ
         RIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752606401; x=1753211201;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9kM4hEAGClBPbwwJM/o6yebUkYu5yQUZuXR772mje4=;
        b=nqBxuCmiLbrwvZxIrw6db5F3kW4Fdned1ikge4DImBgBnXUSX6nd226dpe+j/j7VpE
         0Z5gpMNx5S+7fNClul7RgWCSxNnqyHw2K2L4D1POIKASLN2vRJ41176jBl3LXEuW+Ncq
         vrTPrBURFGMPp9/u2X4wTTZ82S+pwzpk2Xo48TaEi65GPgeUoiuNVGufyk3iDKIT4+Ld
         hsRAU9FCxf32KcY2mW3wwy3sK/e7rE5GTRzJyl/COXrPRLHbjp4TCPq1CGBu7oz1reea
         Lb68cIDdnhTZBuxSPE6E1Tu3ej7jQDml4WaDEcXSVpSTSvSt7bFwjgfX1TRjAzOH28CV
         0Z6g==
X-Gm-Message-State: AOJu0YxVJtY5dPJwpq88HgYnTzGkJhtuMOAdo2HNGIkj+uK4eKSvZtI8
	2k6g+a5owwcx7x6U43zXzE2kkKVVwvlRiW/dk73MsgIHbeVFqKAVZZMnbqA5rqboX73mZE/oyKL
	HUWTu8Q==
X-Google-Smtp-Source: AGHT+IEc17k2iTydYcoJ2I0zd3TiRSQ3d/97yuv9VPah2k9SyTYKAouwm4LkyHCYGU53am0RO8rvezKZvso=
X-Received: from pgbct3.prod.google.com ([2002:a05:6a02:2103:b0:b2e:c392:14f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2381:b0:234:d10d:9f9f
 with SMTP id d9443c01a7336-23e24fe30bfmr1577835ad.40.1752606401066; Tue, 15
 Jul 2025 12:06:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 15 Jul 2025 12:06:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715190638.1899116-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Don't (re)check L1 intercepts when completing
 userspace I/O
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When completing emulation of instruction that generated a userspace exit
for I/O, don't recheck L1 intercepts as KVM has already finished that
phase of instruction execution, i.e. has already committed to allowing L2
to perform I/O.  If L1 (or host userspace) modifies the I/O permission
bitmaps during the exit to userspace,  KVM will treat the access as being
intercepted despite already having emulated the I/O access.

Pivot on EMULTYPE_NO_DECODE to detect that KVM is completing emulation.
Of the three users of EMULTYPE_NO_DECODE, only complete_emulated_io() (the
intended "recipient") can reach the code in question.  gp_interception()'s
use is mutually exclusive with is_guest_mode(), and
complete_emulated_insn_gp() unconditionally pairs EMULTYPE_NO_DECODE with
EMULTYPE_SKIP.

The bad behavior was detected by a syzkaller program that toggles port I/O
interception during the userspace I/O exit, ultimately resulting in a WARN
on vcpu->arch.pio.count being non-zero due to KVM no completing emulation
of the I/O instruction.

  WARNING: CPU: 23 PID: 1083 at arch/x86/kvm/x86.c:8039 emulator_pio_in_out+0x154/0x170 [kvm]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 23 UID: 1000 PID: 1083 Comm: repro Not tainted 6.16.0-rc5-c1610d2d66b1-next-vm #74 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:emulator_pio_in_out+0x154/0x170 [kvm]
  PKRU: 55555554
  Call Trace:
   <TASK>
   kvm_fast_pio+0xd6/0x1d0 [kvm]
   vmx_handle_exit+0x149/0x610 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xda8/0x1ac0 [kvm]
   kvm_vcpu_ioctl+0x244/0x8c0 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0x5d/0xc60
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Fixes: 8a76d7f25f8f ("KVM: x86: Add x86 callback for intercept check")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     |  9 ++++-----
 arch/x86/kvm/kvm_emulate.h |  3 +--
 arch/x86/kvm/x86.c         | 15 ++++++++-------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1349e278cd2a..542d3664afa3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5107,12 +5107,11 @@ void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 	ctxt->mem_read.end = 0;
 }
 
-int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
+int x86_emulate_insn(struct x86_emulate_ctxt *ctxt, bool check_intercepts)
 {
 	const struct x86_emulate_ops *ops = ctxt->ops;
 	int rc = X86EMUL_CONTINUE;
 	int saved_dst_type = ctxt->dst.type;
-	bool is_guest_mode = ctxt->ops->is_guest_mode(ctxt);
 
 	ctxt->mem_read.pos = 0;
 
@@ -5160,7 +5159,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 				fetch_possible_mmx_operand(&ctxt->dst);
 		}
 
-		if (unlikely(is_guest_mode) && ctxt->intercept) {
+		if (unlikely(check_intercepts) && ctxt->intercept) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_PRE_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -5189,7 +5188,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 				goto done;
 		}
 
-		if (unlikely(is_guest_mode) && (ctxt->d & Intercept)) {
+		if (unlikely(check_intercepts) && (ctxt->d & Intercept)) {
 			rc = emulator_check_intercept(ctxt, ctxt->intercept,
 						      X86_ICPT_POST_EXCEPT);
 			if (rc != X86EMUL_CONTINUE)
@@ -5243,7 +5242,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 
 special_insn:
 
-	if (unlikely(is_guest_mode) && (ctxt->d & Intercept)) {
+	if (unlikely(check_intercepts) && (ctxt->d & Intercept)) {
 		rc = emulator_check_intercept(ctxt, ctxt->intercept,
 					      X86_ICPT_POST_MEMACCESS);
 		if (rc != X86EMUL_CONTINUE)
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c1df5acfacaf..7b5ddb787a25 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -235,7 +235,6 @@ struct x86_emulate_ops {
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
 	bool (*is_smm)(struct x86_emulate_ctxt *ctxt);
-	bool (*is_guest_mode)(struct x86_emulate_ctxt *ctxt);
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
@@ -521,7 +520,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
 void init_decode_cache(struct x86_emulate_ctxt *ctxt);
-int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
+int x86_emulate_insn(struct x86_emulate_ctxt *ctxt, bool check_intercepts);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
 			 u16 tss_selector, int idt_index, int reason,
 			 bool has_error_code, u32 error_code);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index de51dbd85a58..44ef3492bfd2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8609,11 +8609,6 @@ static bool emulator_is_smm(struct x86_emulate_ctxt *ctxt)
 	return is_smm(emul_to_vcpu(ctxt));
 }
 
-static bool emulator_is_guest_mode(struct x86_emulate_ctxt *ctxt)
-{
-	return is_guest_mode(emul_to_vcpu(ctxt));
-}
-
 #ifndef CONFIG_KVM_SMM
 static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 {
@@ -8697,7 +8692,6 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_cpuid_is_intel_compatible = emulator_guest_cpuid_is_intel_compatible,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.is_smm              = emulator_is_smm,
-	.is_guest_mode       = emulator_is_guest_mode,
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
@@ -9282,7 +9276,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = 0;
 	}
 
-	r = x86_emulate_insn(ctxt);
+	/*
+	 * Check L1's instruction intercepts when emulating instructions for
+	 * L2, unless KVM is re-emulating a previously decoded instruction,
+	 * e.g. to complete userspace I/O, in which case KVM has already
+	 * checked the intercepts.
+	 */
+	r = x86_emulate_insn(ctxt, is_guest_mode(vcpu) &&
+				   !(emulation_type & EMULTYPE_NO_DECODE));
 
 	if (r == EMULATION_INTERCEPTED)
 		return 1;

base-commit: 4578a747f3c7950be3feb93c2db32eb597a3e55b
-- 
2.50.0.727.gbf7dc18ff4-goog


