Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930E587F39
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437210AbfHIQPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:12 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52912 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437014AbfHIQPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DABFE305D361;
        Fri,  9 Aug 2019 19:01:39 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8EF59305B7A3;
        Fri,  9 Aug 2019 19:01:39 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 79/92] kvm: x86: emulate movsd xmm, m64
Date:   Fri,  9 Aug 2019 19:00:34 +0300
Message-Id: <20190809160047.8319-80-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed in order to be able to support guest code that uses movsd to
write into pages that are marked for write tracking.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 34431cf31f74..9d38f892beea 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1177,6 +1177,27 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static u8 simd_prefix_to_bytes(const struct x86_emulate_ctxt *ctxt,
+			       int simd_prefix)
+{
+	u8 bytes;
+
+	switch (ctxt->b) {
+	case 0x11:
+		/* movsd xmm, m64 */
+		/* movups xmm, m128 */
+		if (simd_prefix == 0xf2) {
+			bytes = 8;
+			break;
+		}
+		/* fallthrough */
+	default:
+		bytes = 16;
+		break;
+	}
+	return bytes;
+}
+
 static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 				    struct operand *op)
 {
@@ -1187,7 +1208,7 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 
 	if (ctxt->d & Sse) {
 		op->type = OP_XMM;
-		op->bytes = 16;
+		op->bytes = ctxt->op_bytes;
 		op->addr.xmm = reg;
 		read_sse_reg(ctxt, &op->vec_val, reg);
 		return;
@@ -1238,7 +1259,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 				ctxt->d & ByteOp);
 		if (ctxt->d & Sse) {
 			op->type = OP_XMM;
-			op->bytes = 16;
+			op->bytes = ctxt->op_bytes;
 			op->addr.xmm = ctxt->modrm_rm;
 			read_sse_reg(ctxt, &op->vec_val, ctxt->modrm_rm);
 			return rc;
@@ -4529,7 +4550,7 @@ static const struct gprefix pfx_0f_2b = {
 };
 
 static const struct gprefix pfx_0f_10_0f_11 = {
-	I(Unaligned, em_mov), I(Unaligned, em_mov), N, N,
+	I(Unaligned, em_mov), I(Unaligned, em_mov), I(Unaligned, em_mov), N,
 };
 
 static const struct gprefix pfx_0f_28_0f_29 = {
@@ -5097,7 +5118,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 {
 	int rc = X86EMUL_CONTINUE;
 	int mode = ctxt->mode;
-	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
+	int def_op_bytes, def_ad_bytes, goffset, simd_prefix = 0;
 	bool op_prefix = false;
 	bool has_seg_override = false;
 	struct opcode opcode;
@@ -5320,7 +5341,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 			ctxt->op_bytes = 4;
 
 		if (ctxt->d & Sse)
-			ctxt->op_bytes = 16;
+			ctxt->op_bytes = simd_prefix_to_bytes(ctxt,
+							      simd_prefix);
 		else if (ctxt->d & Mmx)
 			ctxt->op_bytes = 8;
 	}
