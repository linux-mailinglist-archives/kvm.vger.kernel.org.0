Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250864074DC
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 05:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhIKDpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 23:45:17 -0400
Received: from mail-m972.mail.163.com ([123.126.97.2]:51080 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhIKDpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 23:45:16 -0400
X-Greylist: delayed 927 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Sep 2021 23:45:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=FH+USxEfweAJl8Lxzo
        japaWWh0n2lXlPBIHKiYTBzcE=; b=TsRTo/8nvSqrW9Zq1Zghdddq0zgub3MLY5
        0VwHe93khXD7RuRGgDLG6dyC5hlOmwbsSm2PefGcTba/nfNpZMTswnf+NyDF27IA
        pG+TkR3jgiwJ5BU4t5fOYeF3ciBn3txLWePN3gBGB2yB2+VpVtZgUxWr9ZibLj63
        gXrzQttus=
Received: from ubuntu.localdomain (unknown [124.64.16.40])
        by smtp2 (Coremail) with SMTP id GtxpCgAnGycUIjxhDHDuSQ--.500S2;
        Sat, 11 Sep 2021 11:27:17 +0800 (CST)
From:   18341265598@163.com
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhaoge Zhang <18341265598@163.com>
Subject: [PATCH] kvm: x86: i8259: Converts mask values to logical binary values.
Date:   Sat, 11 Sep 2021 11:27:21 +0800
Message-Id: <1631330841-3507-1-git-send-email-18341265598@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: GtxpCgAnGycUIjxhDHDuSQ--.500S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF1UCr13GryrJry7Gw45Jrb_yoWfXrbEka
        48t397C3yfGrW8Z3yfCa1FyFn3Kw4qgrWfXw18tas0vr9IvFWUZrW5G3W7tr48urZ3GrZr
        WrySvFnYkr1IkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8b6pPUUUUU==
X-Originating-IP: [124.64.16.40]
X-CM-SenderInfo: jpryjkyrswkkmzybiqqrwthudrp/xtbB+AYL+12MaQ7z1AAAsf
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhaoge Zhang <18341265598@163.com>

Signed-off-by: Zhaoge Zhang <18341265598@163.com>
---
 arch/x86/kvm/i8259.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 0b80263..a8f1d60 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -92,7 +92,7 @@ static inline int pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
 	mask = 1 << irq;
 	if (s->elcr & mask)	/* level triggered */
 		if (level) {
-			ret = !(s->irr & mask);
+			ret = !!!(s->irr & mask);
 			s->irr |= mask;
 			s->last_irr |= mask;
 		} else {
@@ -102,7 +102,7 @@ static inline int pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
 	else	/* edge triggered */
 		if (level) {
 			if ((s->last_irr & mask) == 0) {
-				ret = !(s->irr & mask);
+				ret = !!!(s->irr & mask);
 				s->irr |= mask;
 			}
 			s->last_irr |= mask;
-- 
2.7.4

