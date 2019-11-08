Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54F4F4E7B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfKHOnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:43:00 -0500
Received: from foss.arm.com ([217.140.110.172]:44596 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfKHOm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 870D346A;
        Fri,  8 Nov 2019 06:42:58 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A1ED3F719;
        Fri,  8 Nov 2019 06:42:57 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 06/17] arm: gic: Add simple shared IRQ test
Date:   Fri,  8 Nov 2019 14:42:29 +0000
Message-Id: <20191108144240.204202-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far we were testing the GIC's MMIO interface and IPI delivery.
Add a simple test to trigger a shared IRQ (SPI), using the ISPENDR
register in the (emulated) GIC distributor.
This tests configuration of an IRQ (target CPU) and whether it can be
properly enabled or disabled.

This is a bit more sophisticated than actually needed at this time,
but paves the way for extending this to FIQs in the future.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg | 12 +++++++
 2 files changed, 91 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index c909668..3be76cb 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -546,6 +546,81 @@ static void gic_test_mmio(void)
 		test_targets(nr_irqs);
 }
 
+static void gic_spi_trigger(int irq)
+{
+	gic_set_irq_bit(irq, GICD_ISPENDR);
+}
+
+static void spi_configure_irq(int irq, int cpu)
+{
+	gic_set_irq_target(irq, cpu);
+	gic_set_irq_priority(irq, 0xa0);
+	gic_enable_irq(irq);
+}
+
+#define IRQ_STAT_NONE		0
+#define IRQ_STAT_IRQ		1
+#define IRQ_STAT_TYPE_MASK	0x3
+#define IRQ_STAT_NO_CLEAR	4
+
+/*
+ * Wait for an SPI to fire (or not) on a certain CPU.
+ * Clears the pending bit if requested afterwards.
+ */
+static void trigger_and_check_spi(const char *test_name,
+				  unsigned int irq_stat,
+				  int cpu)
+{
+	cpumask_t cpumask;
+
+	stats_reset();
+	gic_spi_trigger(SPI_IRQ);
+	cpumask_clear(&cpumask);
+	switch (irq_stat & IRQ_STAT_TYPE_MASK) {
+	case IRQ_STAT_NONE:
+		break;
+	case IRQ_STAT_IRQ:
+		cpumask_set_cpu(cpu, &cpumask);
+		break;
+	}
+
+	check_acked(test_name, &cpumask);
+
+	/* Clean up pending bit in case this IRQ wasn't taken. */
+	if (!(irq_stat & IRQ_STAT_NO_CLEAR))
+		gic_set_irq_bit(SPI_IRQ, GICD_ICPENDR);
+}
+
+static void spi_test_single(void)
+{
+	cpumask_t cpumask;
+	int cpu = smp_processor_id();
+
+	spi_configure_irq(SPI_IRQ, cpu);
+
+	trigger_and_check_spi("SPI triggered by CPU write", IRQ_STAT_IRQ, cpu);
+
+	gic_disable_irq(SPI_IRQ);
+	trigger_and_check_spi("disabled SPI does not fire",
+			      IRQ_STAT_NONE | IRQ_STAT_NO_CLEAR, cpu);
+
+	stats_reset();
+	cpumask_clear(&cpumask);
+	cpumask_set_cpu(cpu, &cpumask);
+	gic_enable_irq(SPI_IRQ);
+	check_acked("now enabled SPI fires", &cpumask);
+}
+
+static void spi_send(void)
+{
+	irqs_enable();
+
+	spi_test_single();
+
+	check_spurious();
+	exit(report_summary());
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -577,6 +652,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		gic_test_mmio();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "irq") == 0) {
+		report_prefix_push(argv[1]);
+		spi_send();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 12ac142..7a78275 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -92,6 +92,18 @@ smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'ipi'
 groups = gic
 
+[gicv2-spi]
+file = gic.flat
+smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
+extra_params = -machine gic-version=2 -append 'irq'
+groups = gic
+
+[gicv3-spi]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'irq'
+groups = gic
+
 [gicv2-max-mmio]
 file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
-- 
2.17.1

