Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413D6F4E7A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfKHOm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:42:57 -0500
Received: from foss.arm.com ([217.140.110.172]:44578 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfKHOm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35BC7DA7;
        Fri,  8 Nov 2019 06:42:57 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 187D13F719;
        Fri,  8 Nov 2019 06:42:55 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 05/17] arm: gic: Prepare IRQ handler for handling SPIs
Date:   Fri,  8 Nov 2019 14:42:28 +0000
Message-Id: <20191108144240.204202-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far our IRQ handler routine checks that the received IRQ is actually
the one SGI (IPI) that we are using for our testing.

To make the IRQ testing routine more versatile, also allow the IRQ to be
one test SPI (shared interrupt).
We use the penultimate IRQ of the first SPI group for that purpose.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index eca9188..c909668 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -23,6 +23,7 @@
 
 #define IPI_SENDER	1
 #define IPI_IRQ		1
+#define SPI_IRQ		(GIC_FIRST_SPI + 30)
 
 struct gic {
 	struct {
@@ -162,8 +163,12 @@ static void irq_handler(struct pt_regs *regs __unused)
 
 	smp_rmb(); /* pairs with wmb in stats_reset */
 	++acked[smp_processor_id()];
-	check_ipi_sender(irqstat);
-	check_irqnr(irqnr, IPI_IRQ);
+	if (irqnr < GIC_NR_PRIVATE_IRQS) {
+		check_ipi_sender(irqstat);
+		check_irqnr(irqnr, IPI_IRQ);
+	} else {
+		check_irqnr(irqnr, SPI_IRQ);
+	}
 	smp_wmb(); /* pairs with rmb in check_acked */
 }
 
-- 
2.17.1

