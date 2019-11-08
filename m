Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF42F4E88
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfKHOnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:43:13 -0500
Received: from foss.arm.com ([217.140.110.172]:44712 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbfKHOnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:43:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B9147A7;
        Fri,  8 Nov 2019 06:43:10 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D3A13F719;
        Fri,  8 Nov 2019 06:43:09 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 15/17] arm: gic: Provide FIQ handler
Date:   Fri,  8 Nov 2019 14:42:38 +0000
Message-Id: <20191108144240.204202-16-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When configuring an interrupt as Group 0, we can ask the GIC to deliver
them as a FIQ. For this we need a separate exception handler.

Provide this to be used later.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index c68b5b5..6756850 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -178,6 +178,30 @@ static void irq_handler(struct pt_regs *regs __unused)
 	smp_wmb(); /* pairs with rmb in check_acked */
 }
 
+static inline void fiq_handler(struct pt_regs *regs __unused)
+{
+	u32 irqstat = gic_read_iar(0);
+	u32 irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr == GICC_INT_SPURIOUS) {
+		++spurious[smp_processor_id()];
+		smp_wmb();
+		return;
+	}
+
+	gic_write_eoir(irqstat, 0);
+
+	smp_rmb(); /* pairs with wmb in stats_reset */
+	++acked[smp_processor_id()];
+	if (irqnr < GIC_NR_PRIVATE_IRQS) {
+		check_ipi_sender(irqstat);
+		check_irqnr(irqnr, IPI_IRQ);
+	} else {
+		check_irqnr(irqnr, SPI_IRQ);
+	}
+	smp_wmb(); /* pairs with rmb in check_acked */
+}
+
 static void gicv2_ipi_send_self(void)
 {
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
-- 
2.17.1

