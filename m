Return-Path: <kvm+bounces-58246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9154DB8B7FF
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51E781661AD
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A6B2EE61C;
	Fri, 19 Sep 2025 22:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f2hXGLwU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2252EC0AE
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321220; cv=none; b=Cp6o5WuY3iRzZSBNBXqJ57x7Xpc55fAeGhf98lDxruZztStYOAL4/iE3sjhq6zo70ec4iv1GLpfzuq6AFVcuEDrjP39d8djB0JMidqAuemFd2OJVsLzbrF9sCIT8fIvpJg7LyJEeU3HjBuRoNsOMCKDUQIL1ZcdcddwwPacgx2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321220; c=relaxed/simple;
	bh=Tpg2UM0UvnKI0EcEqQuDVNWgIEpvwyrxg6cQAn7ER8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nLS8vRP5Gz67/6TgEudQi8a/rF8fev34NLuECSvnVWV/PVSn2pn/EDNCHazPxdSO1yCLvKFpiBkKI3PvWqFwwcjyvaRUKJT9so4eM90pkJ/R7YJ/f+rXecnVZovi+BMNthvN2aGu9fAo55T8AhWDrASNXRRL4IlrAXmzKPVjVcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f2hXGLwU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-268149e1c28so29774625ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321218; x=1758926018; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IAfbQv0zL/PVgzn0UmAWoXWN2DzfV7FmZQyvK2wocFE=;
        b=f2hXGLwUz5AkHoHzvb78MpA0EOZMwE4XFN9pZzii5/WXX+3k34KbshX4rLPbgFAK2L
         9q9Nn6LXceUbjsc2ioRvvBFUKM9uQAsN7OZCyrAkdfJwLtPRVcOuv9dSMIa2+BpauT0v
         nvzRNxgK8qXCeCi56idmZB9SDYVDYTGzKp3Ba9H/Y6L4wAUUYx5vnDPvXBJ5XeOLe03R
         mcqWJG4oJxp+kgJ8zVtCAsYoZHykZ1jUktCqVGK/xFzq4jBZiT26VLZlYrhkOC9UA216
         kxsFM4ebXZmCg4KNRbpDbpUni9tiTpT+bqFad68VJnxPDHeXsun8xiG+b9OF9kNADjxv
         nBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321218; x=1758926018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IAfbQv0zL/PVgzn0UmAWoXWN2DzfV7FmZQyvK2wocFE=;
        b=NhTM+4Dt2oULDVpYVDK4VxC+In4AO1pOKwrssZMzKvB47tONSzAlNpq+WK/Fnwfe7g
         nSJOSkTEZGX9lxaN61JQ0bmCH1vc/8RTphnEPNUomawbiYJ8cE2fUSMIHZjgcarHLRTO
         wh+3T12gKzlVzl96hiC8HxWLMbLBuc3rU79i0lj3ajnVQlDYzn3Y0/5KJkYLLku/tXED
         OHj45R2QvgUZsjnZVKrH7TnUbhtycM8EkuNE7NTJZbgwCK92DoXHHTZ58ybSu5pSU++c
         BPnj3Ngq71FKIiHnhQ5GzM9mLgd2JuFfjNpGtQR24mjHq21XLKgwCCLRzA/TDRK+AkBS
         xp+g==
X-Gm-Message-State: AOJu0YwoaNq7OxmY1kriqhQx4WnwQwBSIRbSt5w9DUL2+3Op396m2KYS
	C37jSFxnNjyXJjJa/an3/tmxFkTs36mW6UTqMVqAY1WV8qH45tJNV3lpxwSWWaX8b+dxwLCYaap
	0Q0q5Sw==
X-Google-Smtp-Source: AGHT+IGgnEd9An0oTTkKddH6r2SKIE+nBXhRDnlLzXh4X8cUqKGkuYGhcAUT8W0ACXO6gS760WwfruKphHY=
X-Received: from plss12.prod.google.com ([2002:a17:902:c64c:b0:260:3d:8a7c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:298c:b0:249:f16:f086
 with SMTP id d9443c01a7336-269ba534e93mr62799945ad.42.1758321218046; Fri, 19
 Sep 2025 15:33:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:25 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-19-seanjc@google.com>
Subject: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected by
 CET features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
affected by Shadow Stacks and/or Indirect Branch Tracking when said
features are enabled in the guest, as fully emulating CET would require
significant complexity for no practical benefit (KVM shouldn't need to
emulate branch instructions on modern hosts).  Simply doing nothing isn't
an option as that would allow a malicious entity to subvert CET
protections via the emulator.

To detect instructions that are subject to IBT or affect IBT state, use
the existing IsBranch flag along with the source operand type to detect
indirect branches, and the existing NearBranch flag to detect far branches
(which can affect IBT state even if the branch itself is direct).

For Shadow Stacks, explicitly track instructions that directly affect the
current SSP, as KVM's emulator doesn't have existing flags that can be
used to precisely detect such instructions.  Alternatively, the em_xxx()
helpers could directly check for ShadowStack interactions, but using a
dedicated flag is arguably easier to audit, and allows for handling both
IBT and SHSTK in one fell swoop.

Note!  On far transfers, do NOT consult the current privilege level and
instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
can be in play for the target privilege level, i.e. checking the current
privilege could get a false negative, and KVM doesn't know the target
privilege level until emulation gets under way.

Note #2, FAR JMP from 64-bit mode to compatibility mode interacts with
the current SSP, but only to ensure SSP[63:32] == 0.  Don't tag FAR JMP
as SHSTK, which would be rather confusing and would result in FAR JMP
being rejected unnecessarily the vast majority of the time (ignoring that
it's unlikely to ever be emulated).  A future commit will add the #GP(0)
check for the specific FAR JMP scenario.

Note #3, task switches also modify SSP and so need to be rejected.  That
too will be addressed in a future commit.

Suggested-by: Chao Gao <chao.gao@intel.com>
Originally-by: Yang Weijiang <weijiang.yang@intel.com>
Cc: Mathias Krause <minipli@grsecurity.net>
Cc: John Allen <john.allen@amd.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 114 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 100 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 23929151a5b8..dc0249929cbf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,7 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -660,6 +661,57 @@ static inline bool emul_is_noncanonical_address(u64 la,
 	return !ctxt->ops->is_canonical_addr(ctxt, la, flags);
 }
 
+static bool is_shstk_instruction(u64 flags)
+{
+	return flags & ShadowStack;
+}
+
+static bool is_ibt_instruction(u64 flags)
+{
+	if (!(flags & IsBranch))
+		return false;
+
+	/*
+	 * Far transfers can affect IBT state even if the branch itself is
+	 * direct, e.g. when changing privilege levels and loading a conforming
+	 * code segment.  For simplicity, treat all far branches as affecting
+	 * IBT.  False positives are acceptable (emulating far branches on an
+	 * IBT-capable CPU won't happen in practice), while false negatives
+	 * could impact guest security.
+	 *
+	 * Note, this also handles SYCALL and SYSENTER.
+	 */
+	if (!(flags & NearBranch))
+		return true;
+
+	switch (flags & (OpMask << SrcShift)) {
+	case SrcReg:
+	case SrcMem:
+	case SrcMem16:
+	case SrcMem32:
+		return true;
+	case SrcMemFAddr:
+	case SrcImmFAddr:
+		/* Far branches should be handled above. */
+		WARN_ON_ONCE(1);
+		return true;
+	case SrcNone:
+	case SrcImm:
+	case SrcImmByte:
+	/*
+	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
+	 * and RET instructions.  ENTER isn't a branch and RET FAR is handled
+	 * by the NearBranch check above.  RET itself isn't an indirect branch.
+	 */
+	case SrcImmU16:
+		return false;
+	default:
+		WARN_ONCE(1, "Unexpected Src operand '%llx' on branch",
+			  (flags & (OpMask << SrcShift)));
+		return false;
+	}
+}
+
 /*
  * x86 defines three classes of vector instructions: explicitly
  * aligned, explicitly unaligned, and the rest, which change behaviour
@@ -4068,9 +4120,9 @@ static const struct opcode group4[] = {
 static const struct opcode group5[] = {
 	F(DstMem | SrcNone | Lock,		em_inc),
 	F(DstMem | SrcNone | Lock,		em_dec),
-	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
-	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
-	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+	I(SrcMem | NearBranch | IsBranch | ShadowStack, em_call_near_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack, em_call_far),
+	I(SrcMem | NearBranch | IsBranch, em_jmp_abs),
 	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
 	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
 };
@@ -4304,7 +4356,7 @@ static const struct opcode opcode_table[256] = {
 	DI(SrcAcc | DstReg, pause), X7(D(SrcAcc | DstReg)),
 	/* 0x98 - 0x9F */
 	D(DstAcc | SrcNone), I(ImplicitOps | SrcAcc, em_cwd),
-	I(SrcImmFAddr | No64 | IsBranch, em_call_far), N,
+	I(SrcImmFAddr | No64 | IsBranch | ShadowStack, em_call_far), N,
 	II(ImplicitOps | Stack, em_pushf, pushf),
 	II(ImplicitOps | Stack, em_popf, popf),
 	I(ImplicitOps, em_sahf), I(ImplicitOps, em_lahf),
@@ -4324,19 +4376,19 @@ static const struct opcode opcode_table[256] = {
 	X8(I(DstReg | SrcImm64 | Mov, em_mov)),
 	/* 0xC0 - 0xC7 */
 	G(ByteOp | Src2ImmByte, group2), G(Src2ImmByte, group2),
-	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch, em_ret_near_imm),
-	I(ImplicitOps | NearBranch | IsBranch, em_ret),
+	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch | ShadowStack, em_ret_near_imm),
+	I(ImplicitOps | NearBranch | IsBranch | ShadowStack, em_ret),
 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2ES, em_lseg),
 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
 	G(ByteOp, group11), G(0, group11),
 	/* 0xC8 - 0xCF */
 	I(Stack | SrcImmU16 | Src2ImmByte, em_enter),
 	I(Stack, em_leave),
-	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
-	I(ImplicitOps | IsBranch, em_ret_far),
-	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
+	I(ImplicitOps | SrcImmU16 | IsBranch | ShadowStack, em_ret_far_imm),
+	I(ImplicitOps | IsBranch | ShadowStack, em_ret_far),
+	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | ShadowStack, intn),
 	D(ImplicitOps | No64 | IsBranch),
-	II(ImplicitOps | IsBranch, em_iret, iret),
+	II(ImplicitOps | IsBranch | ShadowStack, em_iret, iret),
 	/* 0xD0 - 0xD7 */
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
@@ -4352,7 +4404,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4371,7 +4423,7 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4402,8 +4454,8 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
-	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
+	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack, em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4941,6 +4993,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
 
+	/*
+	 * Reject emulation if KVM might need to emulate shadow stack updates
+	 * and/or indirect branch tracking enforcement, which the emulator
+	 * doesn't support.
+	 */
+	if ((is_ibt_instruction(ctxt->d) || is_shstk_instruction(ctxt->d)) &&
+	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
+		u64 u_cet = 0, s_cet = 0;
+
+		/*
+		 * Check both User and Supervisor on far transfers as inter-
+		 * privilege level transfers are impacted by CET at the target
+		 * privilege level, and that is not known at this time.  The
+		 * the expectation is that the guest will not require emulation
+		 * of any CET-affected instructions at any privilege level.
+		 */
+		if (!(ctxt->d & NearBranch))
+			u_cet = s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
+		else if (ctxt->ops->cpl(ctxt) == 3)
+			u_cet = CET_SHSTK_EN | CET_ENDBR_EN;
+		else
+			s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
+
+		if ((u_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet)) ||
+		    (s_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet)))
+			return EMULATION_FAILED;
+
+		if ((u_cet | s_cet) & CET_SHSTK_EN && is_shstk_instruction(ctxt->d))
+			return EMULATION_FAILED;
+
+		if ((u_cet | s_cet) & CET_ENDBR_EN && is_ibt_instruction(ctxt->d))
+			return EMULATION_FAILED;
+	}
+
 	ctxt->execute = opcode.u.execute;
 
 	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
-- 
2.51.0.470.ga7dc726c21-goog


