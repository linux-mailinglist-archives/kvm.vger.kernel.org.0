Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CD587F53
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437248AbfHIQP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52862 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437114AbfHIQPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 90267305D367;
        Fri,  9 Aug 2019 19:01:43 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 37A7F305B7A1;
        Fri,  9 Aug 2019 19:01:43 +0300 (EEST)
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
Subject: [RFC PATCH v6 88/92] kvm: x86: emulate fst/fstp m64fp
Date:   Fri,  9 Aug 2019 19:00:43 +0300
Message-Id: <20190809160047.8319-89-alazar@bitdefender.com>
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

This adds support for fst m64fp and fstp m64fp.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 14895c043edc..7261b94c6c00 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1178,6 +1178,26 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static int em_fstp(struct x86_emulate_ctxt *ctxt)
+{
+	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
+		return emulate_nm(ctxt);
+
+	asm volatile("fstpl %0" : "=m"(ctxt->dst.val));
+
+	return X86EMUL_CONTINUE;
+}
+
+static int em_fst(struct x86_emulate_ctxt *ctxt)
+{
+	if (ctxt->ops->get_cr(ctxt, 0) & (X86_CR0_TS | X86_CR0_EM))
+		return emulate_nm(ctxt);
+
+	asm volatile("fstl %0" : "=m"(ctxt->dst.val));
+
+	return X86EMUL_CONTINUE;
+}
+
 static int em_xorps(struct x86_emulate_ctxt *ctxt)
 {
 	const sse128_t *src = &ctxt->src.vec_val;
@@ -4678,7 +4698,8 @@ static const struct escape escape_db = { {
 } };
 
 static const struct escape escape_dd = { {
-	N, N, N, N, N, N, N, I(DstMem16 | Mov, em_fnstsw),
+	N, N, I(DstMem64 | Mov, em_fst), I(DstMem64 | Mov, em_fstp),
+	N, N, N, I(DstMem16 | Mov, em_fnstsw),
 }, {
 	/* 0xC0 - 0xC7 */
 	N, N, N, N, N, N, N, N,
