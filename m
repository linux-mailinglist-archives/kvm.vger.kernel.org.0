Return-Path: <kvm+bounces-63152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B7CC5ACAC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C72A3A6EAF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594EF27F749;
	Fri, 14 Nov 2025 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3kQQytj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87111264609
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080607; cv=none; b=kqR+1YQBqm+fCTJQxXLMFOWuq16IRRc2zK1gZCly0QBrmIktDwDApP8w3DBHWKRnziujYrXQWtRNmdYubjIbk0El6NJmFQrDSubWFqkkzkUlN3FiUPgzbVlpTG4oq5LFbOd/gyXsmZetuyMiSep7Dg54sB8hyBwXyLu+iEQlDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080607; c=relaxed/simple;
	bh=3r0OIW8A9ufdniaqKZIhE4WsKxPArpRoKDKIQx+lg6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFYdS7gid/4IzmUuqkX5HhquGyLmMZjwVgjgUxw+wbDJbvYykWtv2+XvXB7GJTkJkZnuxRSUrsmy2lhbxbZCevEBaWayVK6V77yOEawcZbYwwiM+mONtBAaBDnoPhC6l4E91jI7mZmyF57x8sUFtYgkj8CCrfzKvLRoBMLOz4Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a3kQQytj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VBAxHVko6/182nHW5ZVlRZzvvlDcZyQZGnlOB+L+Z6E=;
	b=a3kQQytjZwtzFuQSplSmdpOm5/rD41a2Vw8QnM2vpGgWGTw1Wmn5gt2YMkNM420sgV0FXi
	Ivngfrq7Cu9+3Ph5CWdSGJj4eM/FxaxZ1VSSLVNA4xraq9pnCQhbZ5hBT7FYzS9TEr3Ju6
	TefxyTYufQxNfVX0VLFDKqWfKWGgN9U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-y8J6qhUfNCOckQiLXIBxhA-1; Thu,
 13 Nov 2025 19:36:41 -0500
X-MC-Unique: y8J6qhUfNCOckQiLXIBxhA-1
X-Mimecast-MFC-AGG-ID: y8J6qhUfNCOckQiLXIBxhA_1763080600
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF5611800452;
	Fri, 14 Nov 2025 00:36:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2602419560B9;
	Fri, 14 Nov 2025 00:36:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 08/10] KVM: x86: Refactor REX prefix handling in instruction emulation
Date: Thu, 13 Nov 2025 19:36:31 -0500
Message-ID: <20251114003633.60689-9-pbonzini@redhat.com>
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>
References: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: "Chang S. Bae" <chang.seok.bae@intel.com>

Restructure how to represent and interpret REX fields, preparing
for handling of both REX2 and VEX.

REX uses the upper four bits of a single byte as a fixed identifier,
and the lower four bits containing the data. VEX and REX2 extends this so
that the first byte identifies the prefix and the rest encode additional
bits; and while VEX only has the same four data bits as REX, eight zero
bits are a valid value for the data bits of REX2.  So, stop storing the
REX byte as-is.  Instead, store only the low bits of the REX prefix and
track separately whether a REX-like prefix was used.

No functional changes intended.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Message-ID: <20251110180131.28264-11-chang.seok.bae@intel.com>
[Extracted from APX series; removed bitfields and REX2-specific default. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c     | 33 +++++++++++++++++++++------------
 arch/x86/kvm/kvm_emulate.h | 11 ++++++++++-
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 94dc8a61965b..643f0ebadf9c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -239,6 +239,13 @@ enum x86_transfer_type {
 	X86_TRANSFER_TASK_SWITCH,
 };
 
+enum {
+	REX_B = 1,
+	REX_X = 2,
+	REX_R = 4,
+	REX_W = 8,
+};
+
 static void writeback_registers(struct x86_emulate_ctxt *ctxt)
 {
 	unsigned long dirty = ctxt->regs_dirty;
@@ -919,7 +926,7 @@ static void *decode_register(struct x86_emulate_ctxt *ctxt, u8 modrm_reg,
 			     int byteop)
 {
 	void *p;
-	int highbyte_regs = (ctxt->rex_prefix == 0) && byteop;
+	int highbyte_regs = (ctxt->rex_prefix == REX_NONE) && byteop;
 
 	if (highbyte_regs && modrm_reg >= 4 && modrm_reg < 8)
 		p = (unsigned char *)reg_rmw(ctxt, modrm_reg & 3) + 1;
@@ -1110,7 +1117,7 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 	if (ctxt->d & ModRM)
 		reg = ctxt->modrm_reg;
 	else
-		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
+		reg = (ctxt->b & 7) | (ctxt->rex_bits & REX_B ? 8 : 0);
 
 	__decode_register_operand(ctxt, op, reg);
 }
@@ -1129,9 +1136,9 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	int rc = X86EMUL_CONTINUE;
 	ulong modrm_ea = 0;
 
-	ctxt->modrm_reg = ((ctxt->rex_prefix << 1) & 8); /* REX.R */
-	index_reg = (ctxt->rex_prefix << 2) & 8; /* REX.X */
-	base_reg = (ctxt->rex_prefix << 3) & 8; /* REX.B */
+	ctxt->modrm_reg = (ctxt->rex_bits & REX_R ? 8 : 0);
+	index_reg = (ctxt->rex_bits & REX_X ? 8 : 0);
+	base_reg = (ctxt->rex_bits & REX_B ? 8 : 0);
 
 	ctxt->modrm_mod = (ctxt->modrm & 0xc0) >> 6;
 	ctxt->modrm_reg |= (ctxt->modrm & 0x38) >> 3;
@@ -2464,7 +2471,7 @@ static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 
 	setup_syscalls_segments(&cs, &ss);
 
-	if ((ctxt->rex_prefix & 0x8) != 0x0)
+	if (ctxt->rex_bits & REX_W)
 		usermode = X86EMUL_MODE_PROT64;
 	else
 		usermode = X86EMUL_MODE_PROT32;
@@ -4850,7 +4857,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)
 				goto done_prefixes;
-			ctxt->rex_prefix = ctxt->b;
+			ctxt->rex_prefix = REX_PREFIX;
+			ctxt->rex_bits   = ctxt->b & 0xf;
 			continue;
 		case 0xf0:	/* LOCK */
 			ctxt->lock_prefix = 1;
@@ -4864,15 +4872,15 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		}
 
 		/* Any legacy prefix after a REX prefix nullifies its effect. */
-
-		ctxt->rex_prefix = 0;
+		ctxt->rex_prefix = REX_NONE;
+		ctxt->rex_bits = 0;
 	}
 
 done_prefixes:
 
 	/* REX prefix. */
-	if (ctxt->rex_prefix & 8)
-		ctxt->op_bytes = 8;	/* REX.W */
+	if (ctxt->rex_bits & REX_W)
+		ctxt->op_bytes = 8;
 
 	/* Opcode byte(s). */
 	if (ctxt->b == 0x0f) {
@@ -5138,7 +5146,8 @@ void init_decode_cache(struct x86_emulate_ctxt *ctxt)
 {
 	/* Clear fields that are set conditionally but read without a guard. */
 	ctxt->rip_relative = false;
-	ctxt->rex_prefix = 0;
+	ctxt->rex_prefix = REX_NONE;
+	ctxt->rex_bits = 0;
 	ctxt->lock_prefix = 0;
 	ctxt->op_prefix = false;
 	ctxt->rep_prefix = 0;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c526f46f5595..fb3dab4b5a53 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -319,6 +319,14 @@ typedef void (*fastop_t)(struct fastop *);
 #define NR_EMULATOR_GPRS	8
 #endif
 
+/*
+ * Distinguish between no prefix, REX, or in the future REX2.
+ */
+enum rex_type {
+	REX_NONE,
+	REX_PREFIX,
+};
+
 struct x86_emulate_ctxt {
 	void *vcpu;
 	const struct x86_emulate_ops *ops;
@@ -360,7 +368,8 @@ struct x86_emulate_ctxt {
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
 
 	bool rip_relative;
-	u8 rex_prefix;
+	enum rex_type rex_prefix;
+	u8 rex_bits;
 	u8 lock_prefix;
 	u8 rep_prefix;
 	/* bitmaps of registers in _regs[] that can be read */
-- 
2.43.5



