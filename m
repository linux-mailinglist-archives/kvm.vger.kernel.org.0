Return-Path: <kvm+bounces-55287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D06B2FAC7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750C417ECF5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9BB34F473;
	Thu, 21 Aug 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aVSHa1Dx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B4E34321D;
	Thu, 21 Aug 2025 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783129; cv=none; b=bCzOChZCbyp5goKmKBiNUnrr4xgqPhgnOL0wDDuQg8F/VmRfjGHb+bwhtkEG6NldOOS6S+Bi9+Fv8Y0+82iB9nRVZUfiP7u0z3mYmQknakxz4wDRtymcIgA5dQXLjB2hX39AtqM67KmuR/+r3o7ivDkZmQSXCWtsBohcpoLpNO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783129; c=relaxed/simple;
	bh=ik6x/Xx9UFsVaiaO0szvF715FVxMRj4m2V+kEZefuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4AIaooNMeyALu++My5IogOKEmvGpEXKf8nLveseXXmTAs6r7rW7124UBXpqpGyhc7Jv4Z0HpE4es3amsRsdxUN0FkIPGfl5/3rJ1g7c3v1IsQ3HCQBouOrS7r7SRohJx6mOTB3DAnNvf4z+e5j9IZKxOBJt5j5AYMCdqwcm+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aVSHa1Dx; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783127; x=1787319127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ik6x/Xx9UFsVaiaO0szvF715FVxMRj4m2V+kEZefuFc=;
  b=aVSHa1DxwpWboroth0ahteOYY6ehxGKUlwIAQ6eikiiiuLRKcZlIrOnk
   tqOWxq3jBG8PVbiqwcVp13frG8w7K8Y8S1sw5ebBxWCv7xCcAfxI897ys
   OBtkLruAfIbXD1zC5prBQQp5QfN5h2DX1OyDSe1LOemYwDNXYH5Kvakbz
   lta/lrh14g47DdJ8HWiXYKY/rG0wg/ujiVQE46HQr6gn0jwi6/FbXVLvh
   lcj+e5SR/gaSd3Fes4QIG1fXElh8YsvsuElRws0xQD/Ff/B3QyRdTlMmS
   jWwcQ/87lt1VaeC17vYHswA62cdjSsWGjaqYyRc5lj7bdE8mtrk+s2FRA
   g==;
X-CSE-ConnectionGUID: v8/evtwhRFeWdj3PrP9GdA==
X-CSE-MsgGUID: CffTU5nOTrKrLo5qdEy6Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446158"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446158"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: 2Awju9O4SHOaPpDTzMEj+g==
X-CSE-MsgGUID: 0SgYnvidQkW2q9KKz4Sqmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285424"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:51 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 14/21] KVM: x86: Don't emulate instructions guarded by CET
Date: Thu, 21 Aug 2025 06:30:48 -0700
Message-ID: <20250821133132.72322-15-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

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
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/emulate.c | 46 ++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 542d3664afa3..97a4d1e69583 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,8 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
+#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4068,9 +4070,11 @@ static const struct opcode group4[] = {
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
@@ -4332,11 +4336,11 @@ static const struct opcode opcode_table[256] = {
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
@@ -4352,7 +4356,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4371,7 +4375,8 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk,
+	em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4402,8 +4407,9 @@ static const struct opcode twobyte_table[256] = {
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
@@ -4941,6 +4947,24 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
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
2.47.3


