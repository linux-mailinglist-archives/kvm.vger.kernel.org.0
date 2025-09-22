Return-Path: <kvm+bounces-58411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4DAB93298
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F57C444437
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0836031A555;
	Mon, 22 Sep 2025 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pOBeXDpm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA93164C1
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758571463; cv=none; b=BuUiPS7ehb7M4P383r55P0GDaK8rP1FPeLJfaTwIE5SJbtPmUwecpw1y1Fesp/9Fg+DPYsd/nPUCpyskRT8qTt4VG2HUS7rSQ0ov+Af3QcqXLbqCb43VyVAfE3ndd4yLH6NdS2ehZtJADRtV1PJk8pvY5xDmDuWMP6T+TNogUHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758571463; c=relaxed/simple;
	bh=mGxoGYOUnloHBRoWisM0PLt4IQ6SxjGCx8WXassUJIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ExuaoMU8iJ429PXwZpxGaOOjNQQ6sQk1AOLFKauJeiXrRtN5W0AkfeBzgsQbUD8dCwFiJ785H/l3Ys+FRSIJD/4G3xy1teZHbBmSzvi9bU3XOep+e0716YTvP9SG/3Ykm0k9x364+musgwcK8cevbCG6+Zl99VCDSpBZ2BRgjrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pOBeXDpm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb864fe90so7630659a91.3
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 13:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758571460; x=1759176260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TWCJajFwmPVox9XPXHQlrmJ82Q85uEzbjIoGGe1fqFo=;
        b=pOBeXDpmNWYOmTJJRdb7vQyb2WeqUzPVfkFGTXnZ1FEIKvyTkwmhwqwkzIXVkoCp+B
         b1HXBL17fVc5rQi8jVlb9vAs+rLJHhFAAPa7oR+ScdsTZ4eH3EUDf61zfkno7FnTinxv
         Aza8pXpquiFXFOy4u1uonPbgUXOuEm6Z+5Br/HMiS11pF1V9beyV5Cp5fAg7K5yM3JEi
         aJnE1moDvqFmjU4KsLxtvZcBXl1t/+uNsn+bNjGlD2aGJyJ4GbFz1/fk70WbxrGKFiLG
         9KddJLto+3gR13smP+4RhOCpcick+JzdOy6n0FyIkwXQ8n1D8uvYd9yP1aYUFGQUWiCz
         d2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758571460; x=1759176260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWCJajFwmPVox9XPXHQlrmJ82Q85uEzbjIoGGe1fqFo=;
        b=wvzH827AtsrjLlsylBpPMfEF8BBvWpccolzFaWa6J/rJ+PmNgwNhw9gfRH/+IzvYAX
         ONTQa7wpsvJMqdVf7faCVPDpBD2up+H7X5JBUGVZyNbGC+3GRoIBG2L16Ax6PtMQuhR1
         z4l5lPG97ul9DbcYpkUW5Of/aWG/KJ3tc9GF1AIXmgpFoWNbu3CmSJYwiBDY3qRHXwvK
         3C8bnidF+Y8m4HzezueX6R6QxkfJuDzrXI+iSHybidX13g4MG2J0zuWPucX2zNlviUq1
         OXBdexJCHvAgtjDOBGr9sLebpiR03DJ4+o0LNCzdH1mptMAAJlBoOTUduearpFBXhOxC
         FqJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi5OzOxmXH617TlKjEGhMsw1K6CO/Z3mPkibmeF3mlzszPPWVsu/HdO5wTly3WR+c43HE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfoagTipqb4VJ4dlzKNJGfcAS9jfbJnDc7CAlhldKw/P/MYdgF
	sn4Fhfy3UzrUKY+OnBV2OUxQbYyvQCjBo9/49/y+plbsR4F6HCJI29pimULOtwXDNSjzQxWUJZ8
	2LFe8Eg==
X-Google-Smtp-Source: AGHT+IEtLu3IltyKnd9He5AU8onY3HoWiXSlUQXFXe8yo8ra+bKkkSjTE9Qujh7X66ORNUpkJig2qpfrNws=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:32e:e4e6:ecfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d0b:b0:32e:18b2:5a45
 with SMTP id 98e67ed59e1d1-332a92decfcmr206298a91.5.1758571460593; Mon, 22
 Sep 2025 13:04:20 -0700 (PDT)
Date: Mon, 22 Sep 2025 13:04:19 -0700
In-Reply-To: <aNEkrlv1bdoRitoU@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-19-seanjc@google.com>
 <aNEkrlv1bdoRitoU@intel.com>
Message-ID: <aNGrwzoYRC_a6d5D@google.com>
Subject: Re: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected
 by CET features
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 22, 2025, Chao Gao wrote:
> >+static bool is_ibt_instruction(u64 flags)
> >+{
> >+	if (!(flags & IsBranch))
> >+		return false;
> >+
> >+	/*
> >+	 * Far transfers can affect IBT state even if the branch itself is
> >+	 * direct, e.g. when changing privilege levels and loading a conforming
> >+	 * code segment.  For simplicity, treat all far branches as affecting
> >+	 * IBT.  False positives are acceptable (emulating far branches on an
> >+	 * IBT-capable CPU won't happen in practice), while false negatives
> >+	 * could impact guest security.
> >+	 *
> >+	 * Note, this also handles SYCALL and SYSENTER.
> >+	 */
> >+	if (!(flags & NearBranch))
> >+		return true;
> >+
> >+	switch (flags & (OpMask << SrcShift)) {
> 
> nit: maybe use SrcMask here.
> 
> #define SrcMask     (OpMask << SrcShift)

Fixed.  No idea how I missed that macro.

> >+	case SrcReg:
> >+	case SrcMem:
> >+	case SrcMem16:
> >+	case SrcMem32:
> >+		return true;
> >+	case SrcMemFAddr:
> >+	case SrcImmFAddr:
> >+		/* Far branches should be handled above. */
> >+		WARN_ON_ONCE(1);
> >+		return true;
> >+	case SrcNone:
> >+	case SrcImm:
> >+	case SrcImmByte:
> >+	/*
> >+	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
> >+	 * and RET instructions.  ENTER isn't a branch and RET FAR is handled
> >+	 * by the NearBranch check above.  RET itself isn't an indirect branch.
> >+	 */
> 
> RET FAR isn't affected by IBT, right?

Correct, AFAICT RET FAR doesn't have any interactions with IBT.

> So it is a false positive in the above NearBranch check. I am not asking you
> to fix it - just want to ensure it is intended.

Intended, but wrong.  Specifically, this isn't true for FAR RET or IRET:

  Far transfers can affect IBT state even if the branch itself is direct

(IRET #GPs on return to vm86, but KVM doesn't emulate IRET if CR0.PE=1, so that's
 a moot point)

While it's tempting to sweep this under the rug, it's easy enough to handle with
a short allow-list.  I can't imagine it'll ever matter, e.g. the odds of a guest
enabling IBT _and_ doing a FAR RET without a previous FAR CALL _and_ triggering
emulation on the FAR RET would be... impressive.

This is what I have applied.  It passes both negative and positive testcases for
FAR RET and IRET (I didn't try to encode SYSEXIT; though that's be a "fun" way to
implement usermode support in KUT :-D)

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:25 -0700
Subject: [PATCH] KVM: x86: Don't emulate instructions affected by CET features

Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
affected by Shadow Stacks and/or Indirect Branch Tracking when said
features are enabled in the guest, as fully emulating CET would require
significant complexity for no practical benefit (KVM shouldn't need to
emulate branch instructions on modern hosts).  Simply doing nothing isn't
an option as that would allow a malicious entity to subvert CET
protections via the emulator.

To detect instructions that are subject to IBT or affect IBT state, use
the existing IsBranch flag along with the source operand type to detect
indirect branches, and the existing NearBranch flag to detect far JMPs
and CALLs, all of which are effectively indirect.  Explicitly check for
emulation of IRET, FAR RET (IMM), and SYSEXIT (the ret-like far branches)
instead of adding another flag, e.g. IsRet, as it's unlikely the emulator
will ever need to check for return-like instructions outside of this one
specific flow.  Use an allow-list instead of a deny-list because (a) it's
a shorter list and (b) so that a missed entry gets a false positive, not a
false negative (i.e. reject emulation instead of clobbering CET state).

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
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://lore.kernel.org/r/20250919223258.1604852-19-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 117 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 103 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 23929151a5b8..a7683dc18405 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,7 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4068,9 +4069,9 @@ static const struct opcode group4[] = {
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
@@ -4304,7 +4305,7 @@ static const struct opcode opcode_table[256] = {
 	DI(SrcAcc | DstReg, pause), X7(D(SrcAcc | DstReg)),
 	/* 0x98 - 0x9F */
 	D(DstAcc | SrcNone), I(ImplicitOps | SrcAcc, em_cwd),
-	I(SrcImmFAddr | No64 | IsBranch, em_call_far), N,
+	I(SrcImmFAddr | No64 | IsBranch | ShadowStack, em_call_far), N,
 	II(ImplicitOps | Stack, em_pushf, pushf),
 	II(ImplicitOps | Stack, em_popf, popf),
 	I(ImplicitOps, em_sahf), I(ImplicitOps, em_lahf),
@@ -4324,19 +4325,19 @@ static const struct opcode opcode_table[256] = {
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
@@ -4352,7 +4353,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4371,7 +4372,7 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4402,8 +4403,8 @@ static const struct opcode twobyte_table[256] = {
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
@@ -4514,6 +4515,60 @@ static const struct opcode opcode_map_0f_38[256] = {
 #undef I2bvIP
 #undef I6ALU
 
+static bool is_shstk_instruction(struct x86_emulate_ctxt *ctxt)
+{
+	return ctxt->d & ShadowStack;
+}
+
+static bool is_ibt_instruction(struct x86_emulate_ctxt *ctxt)
+{
+	u64 flags = ctxt->d;
+
+	if (!(flags & IsBranch))
+		return false;
+
+	/*
+	 * All far JMPs and CALLs (including SYSCALL, SYSENTER, and INTn) are
+	 * indirect and thus affect IBT state.  All far RETs (including SYSEXIT
+	 * and IRET) are protected via Shadow Stacks and thus don't affect IBT
+	 * state.  IRET #GPs when returning to virtual-8086 and IBT or SHSTK is
+	 * enabled, but that should be handled by IRET emulation (in the very
+	 * unlikely scenario that KVM adds support for fully emulating IRET).
+	 */
+	if (!(flags & NearBranch))
+		return ctxt->execute != em_iret &&
+		       ctxt->execute != em_ret_far &&
+		       ctxt->execute != em_ret_far_imm &&
+		       ctxt->execute != em_sysexit;
+
+	switch (flags & SrcMask) {
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
+			  flags & SrcMask);
+		return false;
+	}
+}
+
 static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
 {
 	unsigned size;
@@ -4943,6 +4998,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 
 	ctxt->execute = opcode.u.execute;
 
+	/*
+	 * Reject emulation if KVM might need to emulate shadow stack updates
+	 * and/or indirect branch tracking enforcement, which the emulator
+	 * doesn't support.
+	 */
+	if ((is_ibt_instruction(ctxt) || is_shstk_instruction(ctxt)) &&
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
+		if ((u_cet | s_cet) & CET_SHSTK_EN && is_shstk_instruction(ctxt))
+			return EMULATION_FAILED;
+
+		if ((u_cet | s_cet) & CET_ENDBR_EN && is_ibt_instruction(ctxt))
+			return EMULATION_FAILED;
+	}
+
 	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
 	    likely(!(ctxt->d & EmulateOnUD)))
 		return EMULATION_FAILED;

base-commit: 88539a6a25bc7a7ed96952775152e0c3331fdcaf
--

