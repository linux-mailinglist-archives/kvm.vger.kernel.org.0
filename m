Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0EE87F24
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407428AbfHIQOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:14:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52814 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407425AbfHIQOz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:14:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E7B5A3031EC8;
        Fri,  9 Aug 2019 19:01:40 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 80AB8305B7A0;
        Fri,  9 Aug 2019 19:01:40 +0300 (EEST)
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
Subject: [RFC PATCH v6 82/92] kvm: x86: emulate movq r, xmm
Date:   Fri,  9 Aug 2019 19:00:37 +0300
Message-Id: <20190809160047.8319-83-alazar@bitdefender.com>
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

This adds support for movq r, xmm. It introduces a new flag (GPRModRM)
to indicate decode_modrm() that the encoded register is a general purpose
one.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2297955d0934..7c79504e58cd 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -172,6 +172,7 @@
 #define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
 #define Intercept   ((u64)1 << 48)  /* Has valid intercept field */
 #define CheckPerm   ((u64)1 << 49)  /* Has valid check_perm field */
+#define GPRModRM    ((u64)1 << 50)  /* The ModRM encoded register is a GP one */
 #define PrivUD      ((u64)1 << 51)  /* #UD instead of #GP on CPL > 0 */
 #define NearBranch  ((u64)1 << 52)  /* Near branches */
 #define No16	    ((u64)1 << 53)  /* No 16 bit operand */
@@ -1197,6 +1198,11 @@ static u8 simd_prefix_to_bytes(const struct x86_emulate_ctxt *ctxt,
 		if (simd_prefix == 0x66)
 			bytes = 8;
 		break;
+	case 0x6e:
+		/* movq r/m64, xmm */
+		if (simd_prefix == 0x66)
+			bytes = 8;
+		break;
 	default:
 		break;
 	}
@@ -1262,7 +1268,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
 				ctxt->d & ByteOp);
-		if (ctxt->d & Sse) {
+		if ((ctxt->d & Sse) && !(ctxt->d & GPRModRM)) {
 			op->type = OP_XMM;
 			op->bytes = ctxt->op_bytes;
 			op->addr.xmm = ctxt->modrm_rm;
@@ -4546,6 +4552,10 @@ static const struct gprefix pfx_0f_6f_0f_7f = {
 	I(Mmx, em_mov), I(Sse | Aligned, em_mov), N, I(Sse | Unaligned, em_mov),
 };
 
+static const struct gprefix pfx_0f_6e_0f_7e = {
+	N, I(Sse, em_mov), N, N
+};
+
 static const struct instr_dual instr_dual_0f_2b = {
 	I(0, em_mov), N
 };
@@ -4807,7 +4817,8 @@ static const struct opcode twobyte_table[256] = {
 	N, N, N, N,
 	N, N, N, N,
 	N, N, N, N,
-	N, N, N, GP(SrcMem | DstReg | ModRM | Mov, &pfx_0f_6f_0f_7f),
+	N, N, GP(SrcMem | DstReg | ModRM | GPRModRM | Mov, &pfx_0f_6e_0f_7e),
+	GP(SrcMem | DstReg | ModRM | Mov, &pfx_0f_6f_0f_7f),
 	/* 0x70 - 0x7F */
 	N, N, N, N,
 	N, N, N, N,
