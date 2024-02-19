Return-Path: <kvm+bounces-9040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3ED859DA8
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E0C6B22414
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00A34503B;
	Mon, 19 Feb 2024 07:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eBjXNDgF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155FE41C7A;
	Mon, 19 Feb 2024 07:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328881; cv=none; b=D2Tkp+fk+yl3sAxQ+5Vb6atSorC+phX8yrdJsYrZoZ6ON4Kuuol0LqL192x4Dejk4MHDhn7ScruF5la/FWo69ezq0lb6q2spAqLkSeCqVb+fo+tO1ec+eAz7cQ3mZdoQj4S2W7h/rDYm+SdMZwwPj+yLJVQQ7u1uulw31lVd/w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328881; c=relaxed/simple;
	bh=7BaBpJwT/sD2IyfBYcZweX9LwIqZGDL72eD5AtTEaCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwyFHZ+tmLiilBMIVlEPuAy1uEIuAxTuSU11XzGAkc6tpeTQQXyqFMVJQYjSKULwnTfCnJjRcwV1cXfi+YI/AxDmKjYc5hvhqfUiJceBU4/aj6VrEs/zkz/CaO2fwKViL2xD8B75P7ziS2lLKO0v3RIoya3MDFHoirSg4jw8PkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eBjXNDgF; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328880; x=1739864880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7BaBpJwT/sD2IyfBYcZweX9LwIqZGDL72eD5AtTEaCU=;
  b=eBjXNDgFsbPS5dCKlTusIAFT45XVymJ4Jh2RqdmdJZGAVigQTWpVkFtv
   jOg1JEm2WWaXQQsewNnBRT19VtwW3Cdic1JuGw7JwAkhDFpqK8prj7kU3
   538Zcc6cZeUbOmZZJdQWVpozPVgB3CNVsiCSLBOeunsTPNZOZrWhfV3uj
   mF1Dx9IEoVKPKFkFNUa/X/H+IP5b4KV3MqNrrQEVfHLIsEwHzBWzNQjOt
   VsgUdsMQIpuH6QTua/znJy9n5PrtxnJUZjU9dpJsiOt7hBXZDlt6oN1kL
   RraQsyURJQ3aIsgt6HVOCpyYKTk2/FdnBijtfnahn3NUSeHUnb1LOFCNA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535168"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535168"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966139"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966139"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 27/27] KVM: x86: Don't emulate instructions guarded by CET
Date: Sun, 18 Feb 2024 23:47:33 -0800
Message-ID: <20240219074733.122080-28-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't emulate the branch instructions, e.g., CALL/RET/JMP etc., when CET
is active in guest, return KVM_INTERNAL_ERROR_EMULATION to userspace to
handle it.

KVM doesn't emulate CPU behaviors to check CET protected stuffs while
emulating guest instructions, instead it stops emulation on detecting
the instructions in process are CET protected. By doing so, it can avoid
generating bogus #CP in guest and preventing CET protected execution flow
subversion from guest side.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/emulate.c | 46 ++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8ccc17eb78ca..c18616d24ac9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,8 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
+#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4100,9 +4102,11 @@ static const struct opcode group4[] = {
 static const struct opcode group5[] = {
 	F(DstMem | SrcNone | Lock,		em_inc),
 	F(DstMem | SrcNone | Lock,		em_dec),
-	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
-	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
-	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk,
+	em_call_near_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk,
+	em_call_far),
+	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
 	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
 	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
 };
@@ -4364,11 +4368,11 @@ static const struct opcode opcode_table[256] = {
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
@@ -4384,7 +4388,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4403,7 +4407,8 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
+	em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4434,8 +4439,9 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
-	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
+	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
+	em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4973,6 +4979,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
 
+	if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
+		u64 u_cet, s_cet;
+		bool stop_em;
+
+		if (ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet) ||
+		    ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet))
+			return EMULATION_FAILED;
+
+		stop_em = ((u_cet & CET_SHSTK_EN) || (s_cet & CET_SHSTK_EN)) &&
+			  (opcode.flags & ShadowStack);
+
+		stop_em |= ((u_cet & CET_ENDBR_EN) || (s_cet & CET_ENDBR_EN)) &&
+			   (opcode.flags & IndirBrnTrk);
+
+		if (stop_em)
+			return EMULATION_FAILED;
+	}
+
 	ctxt->execute = opcode.u.execute;
 
 	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
-- 
2.43.0


