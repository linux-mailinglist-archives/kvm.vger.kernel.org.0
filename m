Return-Path: <kvm+bounces-6776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2D1839F8C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B89B1C22BFA
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3684F203;
	Wed, 24 Jan 2024 02:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSXHSVNq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60842C69B;
	Wed, 24 Jan 2024 02:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064173; cv=none; b=APp/7gek0pGzFMcOUhZ5P67vqSzYDPYcb59y9BMBljM2AQclc0fz+wtq0aRmPSi9U/o/YEjumTxxmsZfkyhsh1vx9YMEQF7uPPXsDM8lQnuJ5BQ6SKTDPZd65Acet+fY37iwtzy49ip6eSOp0PUhAMaRH0Kw4c6cuCY1Q8ejC+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064173; c=relaxed/simple;
	bh=UwRtvVNhqC9a4CUwgibiSghyasJhQAcBvz9o6nhR8wU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=naZyBYLth+/LAvOk3HS71kHwHwT6eRbJua3cV7pLdpFx9wAlflt+PWt7Tkg+e2Lvz8mfgCQRIxv6xTKDhyKmDAYrNo9AdbYwY8LgZYbFU/S2wBbrvEekORl2YxRrl2anL+I5dYyI9BH/fJ8wC8n/K1UosPZ9K5z+CwRxSJe5EZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSXHSVNq; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064171; x=1737600171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UwRtvVNhqC9a4CUwgibiSghyasJhQAcBvz9o6nhR8wU=;
  b=CSXHSVNq7Y5/fnoT+ZxQSv2cOsDsoqnXwePOoYu9WpBy7fi57rkZ34oE
   0V6bN/J3Q8TlJVo1AHK7YWfkLN1Noyz3tetksL6TuqSJVEIUozZO8ZR2c
   o90teJ8/jf0VGzJc6SwVSi+vlHE6voEUDIPZ8B0FR8N4Fm3C2KK5CVO+N
   +3P0HNHzPHt6dxchYz0vsCx9pwUAoq5T8CI50Ejb9Q5JwK446HiRXjkEN
   9+nI/Oz6DeYn/mnN87n7fKD6QDXeaE7RohILVm9KPvLVdv5XE8gaGgKQX
   xxaOBBK0QuSzDXVRhto/a8Udz6O/j9wpIQI7jiYkgF4R2gUxKY2V+yo7a
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586599"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586599"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825939"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:45 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 27/27] KVM: x86: Stop emulating for CET protected branch instructions
Date: Tue, 23 Jan 2024 18:42:00 -0800
Message-Id: <20240124024200.102792-28-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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
 arch/x86/kvm/emulate.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e223043ef5b2..ad15ce055a1d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,7 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define IsProtected ((u64)1 << 57)  /* Instruction is protected by CET. */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4098,9 +4099,9 @@ static const struct opcode group4[] = {
 static const struct opcode group5[] = {
 	F(DstMem | SrcNone | Lock,		em_inc),
 	F(DstMem | SrcNone | Lock,		em_dec),
-	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
-	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
-	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
+	I(SrcMem | NearBranch | IsBranch | IsProtected, em_call_near_abs),
+	I(SrcMemFAddr | ImplicitOps | IsBranch | IsProtected, em_call_far),
+	I(SrcMem | NearBranch | IsBranch | IsProtected, em_jmp_abs),
 	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
 	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
 };
@@ -4362,11 +4363,11 @@ static const struct opcode opcode_table[256] = {
 	/* 0xC8 - 0xCF */
 	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
 	I(Stack | IsBranch, em_leave),
-	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
-	I(ImplicitOps | IsBranch, em_ret_far),
-	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
+	I(ImplicitOps | SrcImmU16 | IsBranch | IsProtected, em_ret_far_imm),
+	I(ImplicitOps | IsBranch | IsProtected, em_ret_far),
+	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | IsProtected, intn),
 	D(ImplicitOps | No64 | IsBranch),
-	II(ImplicitOps | IsBranch, em_iret, iret),
+	II(ImplicitOps | IsBranch | IsProtected, em_iret, iret),
 	/* 0xD0 - 0xD7 */
 	G(Src2One | ByteOp, group2), G(Src2One, group2),
 	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
@@ -4382,7 +4383,7 @@ static const struct opcode opcode_table[256] = {
 	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
 	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
 	/* 0xE8 - 0xEF */
-	I(SrcImm | NearBranch | IsBranch, em_call),
+	I(SrcImm | NearBranch | IsBranch | IsProtected, em_call),
 	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
 	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
 	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
@@ -4401,7 +4402,7 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
@@ -4432,8 +4433,8 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
-	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
+	I(ImplicitOps | EmulateOnUD | IsBranch | IsProtected, em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | IsProtected, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4971,6 +4972,10 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
 
+	if ((opcode.flags & IsProtected) &&
+	    (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET))
+		return EMULATION_FAILED;
+
 	ctxt->execute = opcode.u.execute;
 
 	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
-- 
2.39.3


