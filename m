Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C44087F56
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437141AbfHIQPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53042 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437090AbfHIQPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3CAC9305D366;
        Fri,  9 Aug 2019 19:01:43 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A9FD4305B7A4;
        Fri,  9 Aug 2019 19:01:42 +0300 (EEST)
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
Subject: [RFC PATCH v6 87/92] kvm: x86: emulate xorps xmm/m128, xmm
Date:   Fri,  9 Aug 2019 19:00:42 +0300
Message-Id: <20190809160047.8319-88-alazar@bitdefender.com>
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

This extends the previous xorpd by creating a dedicated group, something
I should have done since the very beginning.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 28aac552b34b..14895c043edc 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1178,6 +1178,22 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static int em_xorps(struct x86_emulate_ctxt *ctxt)
+{
+	const sse128_t *src = &ctxt->src.vec_val;
+	sse128_t *dst = &ctxt->dst.vec_val;
+	sse128_t xmm0;
+
+	asm volatile("movdqu %%xmm0, %0\n"
+		     "movdqu %1, %%xmm0\n"
+		     "xorps %2, %%xmm0\n"
+		     "movdqu %%xmm0, %1\n"
+		     "movdqu %0, %%xmm0"
+		     : "+m"(xmm0), "+m"(*dst) : "m"(*src));
+
+	return X86EMUL_CONTINUE;
+}
+
 static int em_xorpd(struct x86_emulate_ctxt *ctxt)
 {
 	const sse128_t *src = &ctxt->src.vec_val;
@@ -4615,6 +4631,10 @@ static const struct gprefix pfx_0f_e7 = {
 	N, I(Sse, em_mov), N, N,
 };
 
+static const struct gprefix pfx_0f_57 = {
+	I(Unaligned, em_xorps), I(Unaligned, em_xorpd), N, N
+};
+
 static const struct escape escape_d9 = { {
 	N, N, N, N, N, N, N, I(DstMem16 | Mov, em_fnstcw),
 }, {
@@ -4847,7 +4867,7 @@ static const struct opcode twobyte_table[256] = {
 	/* 0x40 - 0x4F */
 	X16(D(DstReg | SrcMem | ModRM)),
 	/* 0x50 - 0x5F */
-	N, N, N, N, N, N, N, I(SrcMem | DstReg | ModRM | Unaligned | Sse, em_xorpd),
+	N, N, N, N, N, N, N, GP(SrcMem | DstReg | ModRM | Sse, &pfx_0f_57),
 	N, N, N, N, N, N, N, N,
 	/* 0x60 - 0x6F */
 	N, N, N, N,
