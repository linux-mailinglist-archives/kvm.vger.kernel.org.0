Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF787F5A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437116AbfHIQQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:08 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53026 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437086AbfHIQPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 86D35305D363;
        Fri,  9 Aug 2019 19:01:40 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2FE9E305B7A1;
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
Subject: [RFC PATCH v6 81/92] kvm: x86: emulate movq xmm, m64
Date:   Fri,  9 Aug 2019 19:00:36 +0300
Message-Id: <20190809160047.8319-82-alazar@bitdefender.com>
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

This is needed in order to be able to support guest code that uses movq to
write into pages that are marked for write tracking.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b8a412b8b087..2297955d0934 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1180,23 +1180,24 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 static u8 simd_prefix_to_bytes(const struct x86_emulate_ctxt *ctxt,
 			       int simd_prefix)
 {
-	u8 bytes;
+	u8 bytes = 16;
 
 	switch (ctxt->b) {
 	case 0x11:
 		/* movss xmm, m32 */
 		/* movsd xmm, m64 */
 		/* movups xmm, m128 */
-		if (simd_prefix == 0xf3) {
+		if (simd_prefix == 0xf3)
 			bytes = 4;
-			break;
-		} else if (simd_prefix == 0xf2) {
+		else if (simd_prefix == 0xf2)
 			bytes = 8;
-			break;
-		}
-		/* fallthrough */
+		break;
+	case 0xd6:
+		/* movq xmm, m64 */
+		if (simd_prefix == 0x66)
+			bytes = 8;
+		break;
 	default:
-		bytes = 16;
 		break;
 	}
 	return bytes;
@@ -4549,6 +4550,10 @@ static const struct instr_dual instr_dual_0f_2b = {
 	I(0, em_mov), N
 };
 
+static const struct gprefix pfx_0f_d6 = {
+	N, I(0, em_mov), N, N,
+};
+
 static const struct gprefix pfx_0f_2b = {
 	ID(0, &instr_dual_0f_2b), ID(0, &instr_dual_0f_2b), N, N,
 };
@@ -4846,7 +4851,8 @@ static const struct opcode twobyte_table[256] = {
 	/* 0xC8 - 0xCF */
 	X8(I(DstReg, em_bswap)),
 	/* 0xD0 - 0xDF */
-	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
+	N, N, N, N, N, N, GP(ModRM | SrcReg | DstMem | Mov | Sse, &pfx_0f_d6),
+	N, N, N, N, N, N, N, N, N,
 	/* 0xE0 - 0xEF */
 	N, N, N, N, N, N, N, GP(SrcReg | DstMem | ModRM | Mov, &pfx_0f_e7),
 	N, N, N, N, N, N, N, N,
