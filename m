Return-Path: <kvm+bounces-57461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E838FB55A20
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A390AAE1CC9
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7DF2D73B8;
	Fri, 12 Sep 2025 23:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CUWMp0P8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7942D8DDD
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719439; cv=none; b=EaYHgy9xok3frtNjJ8kmbni9OolvacisxzOGmaEMVcA+D/ofvMmaUXdXL/IIf0RVvRtA1XtAKEeJ779VMwux+2UkBgnjZSEsy6lsaSfHlxdLVbVJVazMOlgoUotZguqipS7phgQ5DyDqWpbtWBraNv5fkLqXGmkBeXUzfV/2skE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719439; c=relaxed/simple;
	bh=ILXfpfV4QAISRnV8e08RSSs6sGm5wnidBw8119awsVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G92MgXAwhgWnEzLkOQFzBG41AQUz4vIu4iYvW1SrurgNDS9hRJbheBt2Elcz6SGiKYKbptLGcykgX8dqy9WAQ6IIWj06/AxBvRNjAlnElQICFSHjeBZ6cAUioHat4EZOxVzqdJ4abf0snVzLANpwPudfdK5MjRfCdSApG8FLkZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CUWMp0P8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329ee69e7deso2264572a91.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719437; x=1758324237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MyQK1G16g10u/8gI0kNUwXWT1Z6XDzESkZjB4MN61kQ=;
        b=CUWMp0P8UNeswSLGAAHi/rWf5jJlpbmdMTYO/2oa9gri76CovYPvBabYFfMdt9FSIp
         tCjhCp1EQRrLcEskQMfdJAQxmr9MiFf89Sb51mBHswW45xtgcNz+g5T+mj7ZHvwVUmvI
         wyg9/Iy5YR1LN7K7TvK7A4XX8vnE73W0SBRmVJL30GKXoXKRxJfhUaqDxt7IUcCXngXu
         jMHyk0TcWtnIblhD/AlCO8Qyinlm7fh6F4Bxv7tx6au8v9ZpuxnrYb114DmHc6N84GD4
         BsnmcN+HPbw1kZ8j8os9m4dlLuBiR4FarIAumlTSuUzUvnCfJMXR7+76L1B6UsikVvYx
         WVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719437; x=1758324237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MyQK1G16g10u/8gI0kNUwXWT1Z6XDzESkZjB4MN61kQ=;
        b=S8JvjdGOlC7VUb42P57ben4XLI3KEYMSPZAJ2K681KrrjiVRTu5D1AqtHJ8B2Yqiw5
         A2hECzNEnGRIscARGPPma88O8sGw8VHBPkt7tlAfi4QebVnGKsh+nZB6yP4uZ3rdbaj4
         VLJmbO+uF0ON9fF4R+gLEm+f/YtMI8boc1YU7557EX0d/v7QfuM0igKI5bfK7usoTJO7
         RMEkCKXcg/5Uz++zyKAZeZw4Ax0wQcrvqDfisPVGD1155lvaaC9ld3wzcUNUN4r4scWv
         Z/yGOHrHfqOU+kAWiflTsEq9qI95vwZZPuBZi0Ta97KXb8+oVL47ZdQv+1b3AwKqVe3B
         S6iQ==
X-Gm-Message-State: AOJu0YzpQHmlW/w9gw59T0lp0wugdCEnac3a3Xpm/9jjOS5bYocd0b4A
	bGc8PR5uVSjc63svOj7aHusOD10Wr0egJSVUv1O3olwZeA8B3/bIgLwIl04OyHK1L1+F683EYPM
	wfxV4DA==
X-Google-Smtp-Source: AGHT+IG6GcTiV7HVnjqEMd+9l08/0Yz70KsOAVdaxZ4QoMr05MUtXou6SXFQ9Lwz421uIY2R6Rx9X0xDUVM=
X-Received: from pjbss7.prod.google.com ([2002:a17:90b:2ec7:b0:312:e266:f849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3890:b0:32b:958a:51d4
 with SMTP id 98e67ed59e1d1-32de4f96c48mr4718716a91.28.1757719436765; Fri, 12
 Sep 2025 16:23:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:56 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-19-seanjc@google.com>
Subject: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected by
 CET features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
affected by Shadow Stacks and/or Indirect Branch Tracking when said
features are enabled in the guest, as fully emulating CET would require
significant complexity for no practical benefit (KVM shouldn't need to
emulate branch instructions on modern hosts).  Simply doing nothing isn't
an option as that would allow a malicious entity to subvert CET
protections via the emulator.

Note!  On far transfers, do NOT consult the current privilege level and
instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
can be in play for the target privilege level, i.e. checking the current
privilege could get a false negative, and KVM doesn't know the target
privilege level until emulation gets under way.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Cc: Mathias Krause <minipli@grsecurity.net>
Cc: John Allen <john.allen@amd.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 58 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 542d3664afa3..e4be54a677b0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,8 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
+#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4068,9 +4070,9 @@ static const struct opcode group4[] = {
 static const struct opcode group5[] = {
 	F(DstMem | SrcNone | Lock,		em_inc),
 	F(DstMem | SrcNone | Lock,		em_dec),
-	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
-	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
-	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk, em_call_near_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk, em_call_far),
+	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
 	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
 	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
 };
@@ -4332,11 +4334,11 @@ static const struct opcode opcode_table[256] = {
 	/* 0xC8 - 0xCF */
 	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
 	I(Stack | IsBranch, em_leave),
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
@@ -4352,7 +4354,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4371,7 +4373,7 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4402,8 +4404,8 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
-	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
+	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk, em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4941,6 +4943,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
 
+	/*
+	 * Reject emulation if KVM might need to emulate shadow stack updates
+	 * and/or indirect branch tracking enforcement, which the emulator
+	 * doesn't support.
+	 */
+	if (opcode.flags & (ShadowStack | IndirBrnTrk) &&
+	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
+		u64 u_cet = 0, s_cet = 0;
+
+		/*
+		 * Check both User and Supervisor on far transfers as inter-
+		 * privilege level transfers are impacted by CET at the target
+		 * privilege levels, and that is not known at this time.  The
+		 * the expectation is that the guest will not require emulation
+		 * of any CET-affected instructions at any privilege level.
+		 */
+		if (!(opcode.flags & NearBranch))
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
+		if ((u_cet | s_cet) & CET_SHSTK_EN && opcode.flags & ShadowStack)
+			return EMULATION_FAILED;
+
+		if ((u_cet | s_cet) & CET_ENDBR_EN && opcode.flags & IndirBrnTrk)
+			return EMULATION_FAILED;
+	}
+
 	ctxt->execute = opcode.u.execute;
 
 	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
-- 
2.51.0.384.g4c02a37b29-goog


