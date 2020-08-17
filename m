Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868D8245B3A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgHQDt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgHQDtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:49:23 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7456BC061388
        for <kvm@vger.kernel.org>; Sun, 16 Aug 2020 20:49:23 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id C704E1FF2E;
        Mon, 17 Aug 2020 03:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636158; bh=tkpc/JTygn6o+xCIvRDfTn+uT6G2NyWz4hNvpeTgZbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfoazQ/PgCh5GA96W/lf7BkTN1v5bd84tXxLgIDPZgMuONl2mddmPNlnANRxUOzrT
         OBJLeZgqcHNpCbVSVcu5rojv87oL9nSB14ZwwdYDaCSK1qRX5sj7zXHWJ4agS/uCP8
         CgaKmzZQm5Yaa6yjR4K4ypZG5CtTJ/FyrI5hyaao1swL1Il4LeDMysgprbnJMRcnUJ
         J9LEQm4qPNSyl4qroyAUa7yhJKKSPBRp2hH+eWYyjpCWai8oU0CEyFoGS25Zuv6mVb
         JP21CW1cN4lMqB61AXAcWOe08rxIccIOu08WPeXyeLLKHyYJMC1WYEs1OGFIjxo23u
         M0qE42HcTiI2A==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        WANG Xuerui <git@xen0n.name>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Marc Zyngier <maz@kernel.org>, Anup Patel <anup.patel@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steven Price <steven.price@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Mike Leach <mike.leach@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 5/7] MIPS: cevt-r4k: Don't handle IRQ if clockevent is not enabled
Date:   Mon, 17 Aug 2020 11:46:44 +0800
Message-Id: <20200817034701.3515721-6-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some platforms may have shared Cause.TI, bailing out in IRQ handler
when clock event is not enabled can give another clock device a chance.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kernel/cevt-r4k.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index f0c52d751d0a..d396b1011fee 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -142,6 +142,15 @@ irqreturn_t c0_compare_interrupt(int irq, void *dev_id)
 	if (handle_perf_irq(r2))
 		return IRQ_HANDLED;
 
+	cd = &per_cpu(mips_clockevent_device, cpu);
+	/*
+	 * If the clockevent have not enabled, then no need to check the rest.
+	 * Some platforms may have shared Cause.TI, bailing out here can
+	 * give another clock device a chance.
+	 */
+	if (clockevent_state_detached(cd) || clockevent_state_shutdown(cd))
+		return IRQ_NONE;
+
 	/*
 	 * The same applies to performance counter interrupts.	But with the
 	 * above we now know that the reason we got here must be a timer
@@ -150,7 +159,6 @@ irqreturn_t c0_compare_interrupt(int irq, void *dev_id)
 	if (!r2 || (read_c0_cause() & CAUSEF_TI)) {
 		/* Clear Count/Compare Interrupt */
 		write_c0_compare(read_c0_compare());
-		cd = &per_cpu(mips_clockevent_device, cpu);
 		cd->event_handler(cd);
 
 		return IRQ_HANDLED;
-- 
2.28.0.rc1

