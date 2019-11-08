Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B103EF4E76
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKHOmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:42:54 -0500
Received: from foss.arm.com ([217.140.110.172]:44536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHOmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35203AB6;
        Fri,  8 Nov 2019 06:42:53 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 182873F719;
        Fri,  8 Nov 2019 06:42:51 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 02/17] arm: gic: Generalise function names
Date:   Fri,  8 Nov 2019 14:42:25 +0000
Message-Id: <20191108144240.204202-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for adding functions to test SPI interrupts, generalise
some existing functions dealing with IPIs so far, since most of them
are actually generic for all kind of interrupts.
This also reformats the irq_handler() function, to later expand it
more easily.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 04b3337..a114009 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -135,28 +135,30 @@ static void check_ipi_sender(u32 irqstat)
 	}
 }
 
-static void check_irqnr(u32 irqnr)
+static void check_irqnr(u32 irqnr, int expected)
 {
-	if (irqnr != IPI_IRQ)
+	if (irqnr != expected)
 		bad_irq[smp_processor_id()] = irqnr;
 }
 
-static void ipi_handler(struct pt_regs *regs __unused)
+static void irq_handler(struct pt_regs *regs __unused)
 {
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
-	if (irqnr != GICC_INT_SPURIOUS) {
-		gic_write_eoir(irqstat);
-		smp_rmb(); /* pairs with wmb in stats_reset */
-		++acked[smp_processor_id()];
-		check_ipi_sender(irqstat);
-		check_irqnr(irqnr);
-		smp_wmb(); /* pairs with rmb in check_acked */
-	} else {
+	if (irqnr == GICC_INT_SPURIOUS) {
 		++spurious[smp_processor_id()];
 		smp_wmb();
+		return;
 	}
+
+	gic_write_eoir(irqstat);
+
+	smp_rmb(); /* pairs with wmb in stats_reset */
+	++acked[smp_processor_id()];
+	check_ipi_sender(irqstat);
+	check_irqnr(irqnr, IPI_IRQ);
+	smp_wmb(); /* pairs with rmb in check_acked */
 }
 
 static void gicv2_ipi_send_self(void)
@@ -216,20 +218,20 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
 
-static void ipi_enable(void)
+static void irqs_enable(void)
 {
 	gic_enable_defaults();
 #ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, ipi_handler);
+	install_exception_handler(EXCPTN_IRQ, irq_handler);
 #else
-	install_irq_handler(EL1H_IRQ, ipi_handler);
+	install_irq_handler(EL1H_IRQ, irq_handler);
 #endif
 	local_irq_enable();
 }
 
 static void ipi_send(void)
 {
-	ipi_enable();
+	irqs_enable();
 	wait_on_ready();
 	ipi_test_self();
 	ipi_test_smp();
@@ -237,9 +239,9 @@ static void ipi_send(void)
 	exit(report_summary());
 }
 
-static void ipi_recv(void)
+static void irq_recv(void)
 {
-	ipi_enable();
+	irqs_enable();
 	cpumask_set_cpu(smp_processor_id(), &ready);
 	while (1)
 		wfi();
@@ -250,7 +252,7 @@ static void ipi_test(void *data __unused)
 	if (smp_processor_id() == IPI_SENDER)
 		ipi_send();
 	else
-		ipi_recv();
+		irq_recv();
 }
 
 static struct gic gicv2 = {
@@ -285,7 +287,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		smp_rmb(); /* pairs with wmb in stats_reset */
 		++acked[smp_processor_id()];
-		check_irqnr(irqnr);
+		check_irqnr(irqnr, IPI_IRQ);
 		smp_wmb(); /* pairs with rmb in check_acked */
 	} else {
 		++spurious[smp_processor_id()];
-- 
2.17.1

