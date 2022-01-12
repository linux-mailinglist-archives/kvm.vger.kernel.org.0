Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AFB48D51C
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 10:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiAMJny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 04:43:54 -0500
Received: from mx22.baidu.com ([220.181.50.185]:36842 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233288AbiAMJny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 04:43:54 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2022 04:43:52 EST
Received: from BC-Mail-Ex25.internal.baidu.com (unknown [172.31.51.19])
        by Forcepoint Email with ESMTPS id C6B585F51549BDDAE321;
        Thu, 13 Jan 2022 17:28:36 +0800 (CST)
Received: from FB9D8C53FFFC188.internal.baidu.com (172.31.62.11) by
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 13 Jan 2022 17:28:36 +0800
From:   Wang Guangju <wangguangju@baidu.com>
To:     <pbonzini@redhat.com>, <sean.j.christopherson@intel.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <wangguangju@baidu.com>
Subject: [PATCH] KVM: x86: enhance the readability of function pic_intack()
Date:   Wed, 12 Jan 2022 16:51:53 +0800
Message-ID: <20220112085153.4506-1-wangguangju@baidu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.11]
X-ClientProxiedBy: BJHW-Mail-Ex08.internal.baidu.com (10.127.64.18) To
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: wangguangju <wangguangju@baidu.com>

In function pic_intack(), use a varibale of "mask" to
record expression of "1 << irq", so we can enhance the
readability of this function.

Signed-off-by: wangguangju <wangguangju@baidu.com>
---
 arch/x86/kvm/i8259.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 814064d06016..ad6b64b11adc 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -216,12 +216,14 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
  */
 static inline void pic_intack(struct kvm_kpic_state *s, int irq)
 {
-	s->isr |= 1 << irq;
+	int mask;
+	mask = 1 << irq;
+	s->isr |= mask;
 	/*
 	 * We don't clear a level sensitive interrupt here
 	 */
-	if (!(s->elcr & (1 << irq)))
-		s->irr &= ~(1 << irq);
+	if (!(s->elcr & mask))
+		s->irr &= ~mask;
 
 	if (s->auto_eoi) {
 		if (s->rotate_on_auto_eoi)
-- 
2.25.1

