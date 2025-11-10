Return-Path: <kvm+bounces-62561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BC1C488FE
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 100571891726
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B016B334C27;
	Mon, 10 Nov 2025 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzkXQhN9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E0B334687;
	Mon, 10 Nov 2025 18:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799094; cv=none; b=MQBW/1iTjnMR5zCkMjr5v2YHVaaXNp8HC1OqA4UvHvErc+0qhxZt9NuShQ1L+8P3TAX4DdCH5vywoLjHe7rOq0xWkke0RXUJNWbw00F8+qv/NXRxnB2vyUfaPxhf5+QabjqEQSk9QtYwmpunTiI/Sqbc8wmuENkvwoPGSlktL1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799094; c=relaxed/simple;
	bh=5dYF4iad+H8uTWx9fKhN0f3/Ncx+rJF2lXMG350MeIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMPHg4S+qMhh1Ye2aM6pvkmuycYg5WR2qvXt+7v9gDMqHoOEIiwgHgMZHVXumjHwlNwmHPoEO2oTaiv7zLXdNDAvqD5VTSGDTvi9nZIU0A4uR8GiFEBoGTsS3WtIrkk53MAuQ0AwwH76h5h1klpnvLbrKnQj3iyHe74ISx/tUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzkXQhN9; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799093; x=1794335093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5dYF4iad+H8uTWx9fKhN0f3/Ncx+rJF2lXMG350MeIE=;
  b=mzkXQhN9DMO4C1yL4ENmXMCmyC8ETDbKHwDGAdYo0oUBJBqGKn8QuA29
   v98wkj4ZeYOw+EVmQxljeJdcruLnDPHGdMOzUMqGWuRzMbeuR7SYtsJ4p
   ZX4j5BjUcb73KHMg4OGAEmN66+rEZqDT8fvUN7wj8scHPy+FJFQXJ/c/G
   VIJCguzYMUmekB4kjii9MAobLmzJTQq4fnuwU7KEGUyK32HBg+E+KFZjo
   pQC5nWeYJBzye6wfri/rc5sNcrln9IqUNMD5xZ0n5Di3hgxyyWqky+0G3
   KFkWpv5mqye/gpqFaV6uEfDY02sY9s4dx+ppm/+7cJ/+wApQAZt9IheBs
   Q==;
X-CSE-ConnectionGUID: 8s2WRLUsTwCrktcs4M89gQ==
X-CSE-MsgGUID: EIkXouZPS4irYPvCEe6ZZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305508"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305508"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:53 -0800
X-CSE-ConnectionGUID: qpiy4uSiTOqX6PYOCuK4xw==
X-CSE-MsgGUID: rRbWRPE8SKeq1MgqvdYS/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396161"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:53 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 10/20] KVM: x86: Refactor REX prefix handling in instruction emulation
Date: Mon, 10 Nov 2025 18:01:21 +0000
Message-ID: <20251110180131.28264-11-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restructure how to represent and interpret REX fields. Specifically,

 * Repurpose the existing rex_prefix field to identify the prefix type
 * Introduce a new union to hold both REX and REX2 bitfields
 * Update decoder logic to interpret the unified data type

Historically, REX used the upper four bits of a signle byte as a fixed
identifier, with the lower bits encoded. REX2 extends this to two bytes.
The first byte identifies the prefix, and the second encodes additional
bits, preserving compatibility with legacy REX encoding.

Previously, the emulator stored the REX byte as-is, which cannot capture
REX2 semantics. This refactor prepares for REX2 decoding while preserving
current behavior.

No functional changes intended.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/emulate.c     | 33 ++++++++++++++++++---------------
 arch/x86/kvm/kvm_emulate.h | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4e3da5b497b8..763fbd139242 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -924,7 +924,7 @@ static void *decode_register(struct x86_emulate_ctxt *ctxt, u8 modrm_reg,
 			     int byteop)
 {
 	void *p;
-	int highbyte_regs = (ctxt->rex_prefix == 0) && byteop;
+	int highbyte_regs = (ctxt->rex_prefix == REX_NONE) && byteop;
 
 	if (highbyte_regs && modrm_reg >= 4 && modrm_reg < 8)
 		p = (unsigned char *)reg_rmw(ctxt, modrm_reg & 3) + 1;
@@ -1080,10 +1080,12 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 {
 	unsigned int reg;
 
-	if (ctxt->d & ModRM)
+	if (ctxt->d & ModRM) {
 		reg = ctxt->modrm_reg;
-	else
-		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
+	} else {
+		reg = (ctxt->b & 7) |
+		      (ctxt->rex.bits.b3 * BIT(3));
+	}
 
 	if (ctxt->d & Sse) {
 		op->type = OP_XMM;
@@ -1122,9 +1124,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
 
-	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
-	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
-	base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
+	ctxt->modrm_reg = ctxt->rex.bits.r3 * BIT(3);
+	index_reg       = ctxt->rex.bits.x3 * BIT(3);
+	base_reg        = ctxt->rex.bits.b3 * BIT(3);
 
 	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
 	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
@@ -2466,7 +2468,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 
 	setup_syscalls_segments(&cs, &ss);
 
-	if ((ctxt->rex_prefix & 0x8) != 0x0)
+	if (ctxt->rex.bits.w)
 		usermode = X86EMUL_MODE_PROT64;
 	else
 		usermode = X86EMUL_MODE_PROT32;
@@ -4851,7 +4853,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)
 				goto done_prefixes;
-			ctxt->rex_prefix = ctxt->b;
+			ctxt->rex_prefix = REX_PREFIX;
+			ctxt->rex.raw    = 0x0f & ctxt->b;
 			continue;
 		case 0xf0:	/* LOCK */
 			ctxt->lock_prefix = 1;
@@ -4865,15 +4868,14 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		}
 
 		/* Any legacy prefix after a REX prefix nullifies its effect. */
-
-		ctxt->rex_prefix = 0;
+		ctxt->rex_prefix = REX_NONE;
+		ctxt->rex.raw = 0;
 	}
 
 done_prefixes:
 
-	/* REX prefix. */
-	if (ctxt->rex_prefix & 8)
-		ctxt->op_bytes = 8;	/* REX.W */
+	if (ctxt->rex.bits.w)
+		ctxt->op_bytes = 8;
 
 	/* Opcode byte(s). */
 	opcode = opcode_table[ctxt->b];
@@ -5137,7 +5139,8 @@ void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
 	/* Clear fields that are set conditionally but read without a guard. */
 	ctxt->rip_relative = false;
-	ctxt->rex_prefix = 0;
+	ctxt->rex_prefix = REX_NONE;
+	ctxt->rex.raw = 0;
 	ctxt->lock_prefix = 0;
 	ctxt->rep_prefix = 0;
 	ctxt->regs_valid = 0;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 153c70ea5561..b285299ebfa4 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -317,6 +317,32 @@ typedef void (*fastop_t)(struct fastop *);
 #define NR_EMULATOR_GPRS	8
 #endif
 
+/*
+ * REX prefix type to distinguish between no prefix, legacy REX, REX2,
+ * or an invalid REX2 sequence.
+ */
+enum rex_type {
+	REX_NONE,
+	REX_PREFIX,
+	REX2_PREFIX,
+	REX2_INVALID
+};
+
+/* Unified representation for REX/REX2 prefix bits */
+union rex_field {
+	struct {
+		u8 b3 :1, /* REX2.B3 or REX.B */
+		   x3 :1, /* REX2.X3 or REX.X */
+		   r3 :1, /* REX2.R3 or REX.R */
+		   w  :1, /* REX2.W  or REX.W */
+		   b4 :1, /* REX2.B4 */
+		   x4 :1, /* REX2.X4 */
+		   r4 :1, /* REX2.R4 */
+		   m0 :1; /* REX2.M0 */
+	} bits;
+	u8 raw;
+};
+
 struct x86_emulate_ctxt {
 	void *vcpu;
 	const struct x86_emulate_ops *ops;
@@ -357,7 +383,10 @@ struct x86_emulate_ctxt {
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
 
 	bool rip_relative;
-	u8 rex_prefix;
+	/* Type of REX prefix (none, REX, REX2) */
+	enum rex_type rex_prefix;
+	/* Rex bits */
+	union rex_field rex;
 	u8 lock_prefix;
 	u8 rep_prefix;
 	/* bitmaps of registers in _regs[] that can be read */
-- 
2.51.0


