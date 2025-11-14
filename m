Return-Path: <kvm+bounces-63156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BFFC5ACF4
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0CA99352D52
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475B229D266;
	Fri, 14 Nov 2025 00:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELkkeS1j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE6231829
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080611; cv=none; b=LmXC59mD1HmaYeziV25h8dWPYn0FHrc0pDS0iCcyUbTzJw9T9aqy//VbW4ABDnJLl4WjVLLkxO+r4cFlJUGH0oxunINPrH8TDIqGKHJ0wrR+Lna+WI1U8IxqXddJWmblVpiv2JfS923rYC13stwGzl3FpQeMpbwG1qHzZoXpamY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080611; c=relaxed/simple;
	bh=cbv+1Fat/ws9XNBwItoYQDrFWVI/znG8JERbwZ+8DmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ql5yA7QLJ2G3XntquZC+2ASygo2V4eCF4lzClaFtxIwo/niG3N0qbLQ5vgxdjzLsGqLcqFpzm2k3jUrXrp+UsbpL/TucHkCLEE7+J2hp4X1aa65SVW7EHpjnBJ3JlST94PUou0tkC+7mwqnjvd0lXIHRwt9iTa46rRba90bayCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELkkeS1j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSY+6VrNbgLdwj9VS8oZZfpM8V9YQilibvZdcCAQauE=;
	b=ELkkeS1jpz3aDkheSfyfCPsfUVp0tsbP4/CFIEXvKOE6Hjs6gk/nZwJUyo2wCtDI22bVxR
	CqaWAkbjwA//pr8fwORuolT4xo90RMEfGfkM12Mqo3pJeyzX+w0oK7eJktjvxl66qo/WD0
	4/K1kR1jegzRMlETiePC63BcL432PQc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-98-NyKMqJlYM8KX5gofAFctrA-1; Thu,
 13 Nov 2025 19:36:44 -0500
X-MC-Unique: NyKMqJlYM8KX5gofAFctrA-1
X-Mimecast-MFC-AGG-ID: NyKMqJlYM8KX5gofAFctrA_1763080601
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 831FE180047F;
	Fri, 14 Nov 2025 00:36:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D649619560B9;
	Fri, 14 Nov 2025 00:36:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 09/10] KVM: emulate: decode VEX prefix
Date: Thu, 13 Nov 2025 19:36:32 -0500
Message-ID: <20251114003633.60689-10-pbonzini@redhat.com>
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

After all the changes done in the previous patches, the only thing
left to support AVX moves is to expand the VEX prefix into the appropriate
REX, 66/F3/F2 and map prefixes.  Three-operand instructions are not
supported.

The Avx bit in this case is not cleared, in fact it is used as the
sign that the instruction does support VEX encoding.  Until it is
added to any instruction, however, the only functional change is
to change some not-implemented instructions to #UD if they correspond
to a VEX prefix with an invalid map.

Co-developed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 123 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 113 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 643f0ebadf9c..1e17043a6304 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3963,6 +3963,8 @@ static int check_perm_out(struct x86_emulate_ctxt *ctxt)
 		I2bv(((_f) | DstReg | SrcMem | ModRM) & ~Lock, _e),	\
 		I2bv(((_f) & ~Lock) | DstAcc | SrcImm, _e)
 
+static const struct opcode ud = I(SrcNone, emulate_ud);
+
 static const struct opcode group7_rm0[] = {
 	N,
 	I(SrcNone | Priv | EmulateOnUD,	em_hypercall),
@@ -4762,11 +4765,87 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	return rc;
 }
 
+static int x86_decode_avx(struct x86_emulate_ctxt *ctxt,
+			  u8 vex_1st, u8 vex_2nd, struct opcode *opcode)
+{
+	u8 vex_3rd, map, pp, l, v;
+	int rc = X86EMUL_CONTINUE;
+
+	if (ctxt->rep_prefix || ctxt->op_prefix || ctxt->rex_prefix)
+		goto ud;
+
+	if (vex_1st == 0xc5) {
+		/* Expand RVVVVlpp to VEX3 format */
+		vex_3rd = vex_2nd & ~0x80;         /* VVVVlpp from VEX2, w=0 */
+		vex_2nd = (vex_2nd & 0x80) | 0x61; /* R from VEX2, X=1 B=1 mmmmm=00001 */
+	} else {
+		vex_3rd = insn_fetch(u8, ctxt);
+	}
+
+	/* vex_2nd = RXBmmmmm, vex_3rd = wVVVVlpp.  Fix polarity */
+	vex_2nd ^= 0xE0; /* binary 11100000 */
+	vex_3rd ^= 0x78; /* binary 01111000 */
+
+	ctxt->rex_prefix = REX_PREFIX;
+	ctxt->rex_bits = (vex_2nd & 0xE0) >> 5; /* RXB */
+	ctxt->rex_bits |= (vex_3rd & 0x80) >> 4; /* w */
+	if (ctxt->rex_bits && ctxt->mode != X86EMUL_MODE_PROT64)
+		goto ud;
+
+	map = vex_2nd & 0x1f;
+	v = (vex_3rd >> 3) & 0xf;
+	l = vex_3rd & 0x4;
+	pp = vex_3rd & 0x3;
+
+	ctxt->b = insn_fetch(u8, ctxt);
+	switch (map) {
+	case 1:
+		ctxt->opcode_len = 2;
+		*opcode = twobyte_table[ctxt->b];
+		break;
+	case 2:
+		ctxt->opcode_len = 3;
+		*opcode = opcode_map_0f_38[ctxt->b];
+		break;
+	case 3:
+		/* no 0f 3a instructions are supported yet */
+		return X86EMUL_UNHANDLEABLE;
+	default:
+		goto ud;
+	}
+
+	/*
+	 * No three operand instructions are supported yet; those that
+	 * *are* marked with the Avx flag reserve the VVVV flag.
+	 */
+	if (v)
+		goto ud;
+
+	if (l)
+		ctxt->op_bytes = 32;
+	else
+		ctxt->op_bytes = 16;
+
+	switch (pp) {
+	case 0: break;
+	case 1: ctxt->op_prefix = true; break;
+	case 2: ctxt->rep_prefix = 0xf3; break;
+	case 3: ctxt->rep_prefix = 0xf2; break;
+	}
+
+done:
+	return rc;
+ud:
+	*opcode = ud;
+	return rc;
+}
+
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int emulation_type)
 {
 	int rc = X86EMUL_CONTINUE;
 	int mode = ctxt->mode;
 	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
+	bool vex_prefix = false;
 	bool has_seg_override = false;
 	struct opcode opcode;
 	u16 dummy;
@@ -4883,7 +4962,21 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		ctxt->op_bytes = 8;
 
 	/* Opcode byte(s). */
-	if (ctxt->b == 0x0f) {
+	if (ctxt->b == 0xc4 || ctxt->b == 0xc5) {
+		/* VEX or LDS/LES */
+		u8 vex_2nd = insn_fetch(u8, ctxt);
+		if (mode != X86EMUL_MODE_PROT64 && (vex_2nd & 0xc0) != 0xc0) {
+			opcode = opcode_table[ctxt->b];
+			ctxt->modrm = vex_2nd;
+			/* the Mod/RM byte has been fetched already!  */
+			goto done_modrm;
+		}
+
+		vex_prefix = true;
+		rc = x86_decode_avx(ctxt, ctxt->b, vex_2nd, &opcode);
+		if (rc != X86EMUL_CONTINUE)
+			goto done;
+	} else if (ctxt->b == 0x0f) {
 		/* Two- or three-byte opcode */
 		ctxt->opcode_len = 2;
 		ctxt->b = insn_fetch(u8, ctxt);
@@ -4899,17 +4992,12 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		/* Opcode byte(s). */
 		opcode = opcode_table[ctxt->b];
 	}
-	ctxt->d = opcode.flags;
 
-	if (ctxt->d & ModRM)
+	if (opcode.flags & ModRM)
 		ctxt->modrm = insn_fetch(u8, ctxt);
 
-	/* vex-prefix instructions are not implemented */
-	if (ctxt->opcode_len == 1 && (ctxt->b == 0xc5 || ctxt->b == 0xc4) &&
-	    (mode == X86EMUL_MODE_PROT64 || (ctxt->modrm & 0xc0) == 0xc0)) {
-		ctxt->d = NotImpl;
-	}
-
+done_modrm:
+	ctxt->d = opcode.flags;
 	while (ctxt->d & GroupMask) {
 		switch (ctxt->d & GroupMask) {
 		case Group:
@@ -4975,6 +5063,19 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	if (ctxt->d == 0)
 		return EMULATION_FAILED;
 
+	if (unlikely(vex_prefix)) {
+		/*
+		 * Only specifically marked instructions support VEX.  Since many
+		 * instructions support it but are not annotated, return not implemented
+		 * rather than #UD.
+		 */
+		if (!(ctxt->d & Avx))
+			return EMULATION_FAILED;
+
+		if (!(ctxt->d & AlignMask))
+			ctxt->d |= Unaligned;
+	}
+
 	ctxt->execute = opcode.u.execute;
 
 	/*
@@ -5045,7 +5146,9 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 		if ((ctxt->d & No16) && ctxt->op_bytes == 2)
 			ctxt->op_bytes = 4;
 
-		if (ctxt->d & Sse)
+		if (vex_prefix)
+			;
+		else if (ctxt->d & Sse)
 			ctxt->op_bytes = 16, ctxt->d &= ~Avx;
 		else if (ctxt->d & Mmx)
 			ctxt->op_bytes = 8;
-- 
2.43.5



