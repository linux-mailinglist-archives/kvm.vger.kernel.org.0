Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F13EF4E8A
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfKHOnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:43:14 -0500
Received: from foss.arm.com ([217.140.110.172]:44750 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbfKHOnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:43:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 487157A7;
        Fri,  8 Nov 2019 06:43:13 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26E563F719;
        Fri,  8 Nov 2019 06:43:12 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 17/17] arm: gic: Test Group0 SPIs
Date:   Fri,  8 Nov 2019 14:42:40 +0000
Message-Id: <20191108144240.204202-18-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the newly gained building blocks we can now actually test Group 0
interrupts on our emulated/virtualized GIC.
The least common denominator for the groups usage on both GICv2 and
GICv3 is to configure group 0 interrupts to trigger FIQs, and group 1
interrupts to trigger IRQs.
For testing this we first configure our test SPI to belong to group 0,
then trigger it to see that it is actually delivered as an FIQ, and not as
an IRQ.
The we change the group to become 1, and trigger again, this time
expecting the opposite behaviour.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 101 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 43a272b..9942314 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -276,6 +276,22 @@ static void irqs_enable(void)
 	local_irq_enable();
 }
 
+static void fiqs_enable(void)
+{
+#ifdef __arm__
+	install_exception_handler(EXCPTN_FIQ, fiq_handler);
+#else
+	install_irq_handler(EL1H_FIQ, fiq_handler);
+#endif
+	if (gic_version() == 3) {
+		gicv3_write_grpen0(1);
+	} else {
+		gicv2_enable_fiq(true);
+		gicv2_enable_group1(true);
+	}
+	local_fiq_enable();
+}
+
 static void ipi_send(void)
 {
 	irqs_enable();
@@ -598,6 +614,7 @@ static void spi_configure_irq(int irq, int cpu)
 
 #define IRQ_STAT_NONE		0
 #define IRQ_STAT_IRQ		1
+#define IRQ_STAT_FIQ		2
 #define IRQ_STAT_TYPE_MASK	0x3
 #define IRQ_STAT_NO_CLEAR	4
 
@@ -617,14 +634,21 @@ static bool trigger_and_check_spi(const char *test_name,
 	cpumask_clear(&cpumask);
 	switch (irq_stat & IRQ_STAT_TYPE_MASK) {
 	case IRQ_STAT_NONE:
+		ret &= (check_acked(NULL, &cpumask, 0) >= 0);
+		ret &= (check_acked(test_name, &cpumask, 1) >= 0);
 		break;
 	case IRQ_STAT_IRQ:
+		ret &= (check_acked(NULL, &cpumask, 0) >= 0);
+		cpumask_set_cpu(cpu, &cpumask);
+		ret &= (check_acked(test_name, &cpumask, 1) >= 0);
+		break;
+	case IRQ_STAT_FIQ:
+		ret &= (check_acked(NULL, &cpumask, 1) >= 0);
 		cpumask_set_cpu(cpu, &cpumask);
+		ret &= (check_acked(test_name, &cpumask, 0) >= 0);
 		break;
 	}
 
-	ret = (check_acked(test_name, &cpumask, 1) >= 0);
-
 	/* Clean up pending bit in case this IRQ wasn't taken. */
 	if (!(irq_stat & IRQ_STAT_NO_CLEAR))
 		gic_set_irq_bit(SPI_IRQ, GICD_ICPENDR);
@@ -657,6 +681,9 @@ static void spi_test_smp(void)
 	int cpu;
 	int cores = 1;
 
+	if (nr_cpus > 8)
+		printf("triggering SPIs on all %d cores, takes %d seconds\n",
+		       nr_cpus, (nr_cpus - 1) * 3 / 2);
 	wait_on_ready();
 	for_each_present_cpu(cpu) {
 		if (cpu == smp_processor_id())
@@ -671,6 +698,46 @@ static void spi_test_smp(void)
 }
 
 #define GICD_CTLR_ENABLE_BOTH (GICD_CTLR_ENABLE_G0 | GICD_CTLR_ENABLE_G1)
+#define EXPECT_FIQ	true
+#define EXPECT_IRQ	false
+
+/*
+ * Check whether our SPI interrupt is correctly delivered as an FIQ or as
+ * an IRQ, as configured.
+ * This tries to enable the two groups independently, to check whether
+ * the relation group0->FIQ and group1->IRQ holds.
+ */
+static void gic_check_irq_delivery(void *gicd_base, bool as_fiq)
+{
+	u32 reg = readl(gicd_base + GICD_CTLR) & ~GICD_CTLR_ENABLE_BOTH;
+	int cpu = smp_processor_id();
+
+	/* Check that both groups disabled block the IRQ. */
+	writel(reg, gicd_base + GICD_CTLR);
+	trigger_and_check_spi("no IRQs with both groups disabled",
+			      IRQ_STAT_NONE, cpu);
+
+	/* Check that just the *other* group enabled blocks the IRQ. */
+	if (as_fiq)
+		writel(reg | GICD_CTLR_ENABLE_G1, gicd_base + GICD_CTLR);
+	else
+		writel(reg | GICD_CTLR_ENABLE_G0, gicd_base + GICD_CTLR);
+	trigger_and_check_spi("no IRQs with just the other group enabled",
+			      IRQ_STAT_NONE, cpu);
+
+	/* Check that just this group enabled fires the IRQ. */
+	if (as_fiq)
+		writel(reg | GICD_CTLR_ENABLE_G0, gicd_base + GICD_CTLR);
+	else
+		writel(reg | GICD_CTLR_ENABLE_G1, gicd_base + GICD_CTLR);
+	trigger_and_check_spi("just this group enabled",
+			      as_fiq ? IRQ_STAT_FIQ : IRQ_STAT_IRQ, cpu);
+
+	/* Check that both groups enabled fires the IRQ. */
+	writel(reg | GICD_CTLR_ENABLE_BOTH, gicd_base + GICD_CTLR);
+	trigger_and_check_spi("both groups enabled",
+			      as_fiq ? IRQ_STAT_FIQ : IRQ_STAT_IRQ, cpu);
+}
 
 /*
  * Check the security state configuration of the GIC.
@@ -711,6 +778,9 @@ static bool gicv3_check_security(void *gicd_base)
  * Check whether this works as expected (as Linux will not use this feature).
  * We can only verify this state on a GICv3, so we check it there and silently
  * assume it's valid for GICv2.
+ * GICv2 and GICv3 handle the groups differently, but we use the common
+ * denominator (Group0 as FIQ, Group1 as IRQ) and rely on the GIC library for
+ * abstraction.
  */
 static void test_irq_group(void *gicd_base)
 {
@@ -754,6 +824,35 @@ static void test_irq_group(void *gicd_base)
 	gic_set_irq_group(SPI_IRQ, !reg);
 	report("IGROUPR is writable", gic_get_irq_group(SPI_IRQ) != reg);
 	gic_set_irq_group(SPI_IRQ, reg);
+
+	/*
+	 * Configure group 0 interrupts as FIQs, install both an FIQ and IRQ
+	 * handler and allow both types to be delivered to the core.
+	 */
+	irqs_enable();
+	fiqs_enable();
+
+	/* Configure one SPI to be a group0 interrupt. */
+	gic_set_irq_group(SPI_IRQ, 0);
+	spi_configure_irq(SPI_IRQ, smp_processor_id());
+	report_prefix_push("FIQ");
+	gic_check_irq_delivery(gicd_base, EXPECT_FIQ);
+	report_prefix_pop();
+
+	/* Configure the SPI to be a group1 interrupt instead. */
+	gic_set_irq_group(SPI_IRQ, 1);
+	report_prefix_push("IRQ");
+	gic_check_irq_delivery(gicd_base, EXPECT_IRQ);
+	report_prefix_pop();
+
+	/* Reset the IRQ to the default group. */
+	if (is_gicv3)
+		gic_set_irq_group(SPI_IRQ, 1);
+	else
+		gic_set_irq_group(SPI_IRQ, 0);
+	gic_disable_irq(SPI_IRQ);
+
+	report_prefix_pop();
 }
 
 static void spi_send(void)
-- 
2.17.1

