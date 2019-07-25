Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BF874ED9
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbfGYNKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 09:10:07 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:7495 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfGYNKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 09:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564060205; x=1595596205;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=XVUUtw0CvlEEBiYTPB9kfxqDs5UZqL6rWnE9qzMwF0s=;
  b=B/FBoR7X/DN+AHna2GFzNgGMXHp/8u4cM9njUALbmKumMrgwmkhYi1KN
   4paSfE9yd3oaCxTZjeK5zM0DWx/mO6R1pQcoJq8mlzgAeBuFEu+0gUJJ5
   xDzlNsWtdx3L9J/1cX+bq0kdfMiHmw1ruM66MVjzn9klxmkJt0cQQf3YD
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,306,1559520000"; 
   d="scan'208";a="813661062"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Jul 2019 13:10:02 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id D6240C068E;
        Thu, 25 Jul 2019 13:09:59 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 13:09:59 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.137) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 13:09:57 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     Andrew Jones <drjones@redhat.com>, <kvmarm@lists.cs.columbia.edu>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Andre Przywara" <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvm-unit-tests v4] arm: Add PL031 test
Date:   Thu, 25 Jul 2019 15:09:49 +0200
Message-ID: <20190725130949.27436-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.137]
X-ClientProxiedBy: EX13D04UWA002.ant.amazon.com (10.43.160.31) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds a unit test for the PL031 RTC that is used in the virt machine.
It just pokes basic functionality. I've mostly written it to familiarize myself
with the device, but I suppose having the test around does not hurt, as it also
exercises the GIC SPI interrupt path.

Signed-off-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>

---

v1 -> v2:

  - Use FDT to find base, irq and existence
  - Put isb after timer read
  - Use dist_base for gicv3

v2 -> v3

  - Enable compilation on 32bit ARM target
  - Use ioremap

v3 -> v4:

  - Use dt_pbus_translate_node()
  - Make irq_triggered volatile
---
 arm/Makefile.common |   1 +
 arm/pl031.c         | 260 ++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h   |   1 +
 3 files changed, 262 insertions(+)
 create mode 100644 arm/pl031.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f0c4b5d..b8988f2 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
 tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
+tests-common += $(TEST_DIR)/pl031.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/pl031.c b/arm/pl031.c
new file mode 100644
index 0000000..e335cd6
--- /dev/null
+++ b/arm/pl031.c
@@ -0,0 +1,260 @@
+/*
+ * Verify PL031 functionality
+ *
+ * This test verifies whether the emulated PL031 behaves correctly.
+ *
+ * Copyright 2019 Amazon.com, Inc. or its affiliates.
+ * Author: Alexander Graf <graf@amazon.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <devicetree.h>
+#include <asm/processor.h>
+#include <asm/io.h>
+#include <asm/gic.h>
+
+struct pl031_regs {
+	uint32_t dr;	/* Data Register */
+	uint32_t mr;	/* Match Register */
+	uint32_t lr;	/* Load Register */
+	union {
+		uint8_t cr;	/* Control Register */
+		uint32_t cr32;
+	};
+	union {
+		uint8_t imsc;	/* Interrupt Mask Set or Clear register */
+		uint32_t imsc32;
+	};
+	union {
+		uint8_t ris;	/* Raw Interrupt Status */
+		uint32_t ris32;
+	};
+	union {
+		uint8_t mis;	/* Masked Interrupt Status */
+		uint32_t mis32;
+	};
+	union {
+		uint8_t icr;	/* Interrupt Clear Register */
+		uint32_t icr32;
+	};
+	uint32_t reserved[1008];
+	uint32_t periph_id[4];
+	uint32_t pcell_id[4];
+};
+
+static u32 cntfrq;
+static struct pl031_regs *pl031;
+static int pl031_irq;
+static void *gic_ispendr;
+static void *gic_isenabler;
+static volatile bool irq_triggered;
+
+static int check_id(void)
+{
+	uint32_t id[] = { 0x31, 0x10, 0x14, 0x00, 0x0d, 0xf0, 0x05, 0xb1 };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id); i++)
+		if (id[i] != readl(&pl031->periph_id[i]))
+			return 1;
+
+	return 0;
+}
+
+static int check_ro(void)
+{
+	uint32_t offs[] = { offsetof(struct pl031_regs, ris),
+			    offsetof(struct pl031_regs, mis),
+			    offsetof(struct pl031_regs, periph_id[0]),
+			    offsetof(struct pl031_regs, periph_id[1]),
+			    offsetof(struct pl031_regs, periph_id[2]),
+			    offsetof(struct pl031_regs, periph_id[3]),
+			    offsetof(struct pl031_regs, pcell_id[0]),
+			    offsetof(struct pl031_regs, pcell_id[1]),
+			    offsetof(struct pl031_regs, pcell_id[2]),
+			    offsetof(struct pl031_regs, pcell_id[3]) };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(offs); i++) {
+		uint32_t before32;
+		uint16_t before16;
+		uint8_t before8;
+		void *addr = (void*)pl031 + offs[i];
+		uint32_t poison = 0xdeadbeefULL;
+
+		before8 = readb(addr);
+		before16 = readw(addr);
+		before32 = readl(addr);
+
+		writeb(poison, addr);
+		writew(poison, addr);
+		writel(poison, addr);
+
+		if (before8 != readb(addr))
+			return 1;
+		if (before16 != readw(addr))
+			return 1;
+		if (before32 != readl(addr))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int check_rtc_freq(void)
+{
+	uint32_t seconds_to_wait = 2;
+	uint32_t before = readl(&pl031->dr);
+	uint64_t before_tick = get_cntvct();
+	uint64_t target_tick = before_tick + (cntfrq * seconds_to_wait);
+
+	/* Wait for 2 seconds */
+	while (get_cntvct() < target_tick) ;
+
+	if (readl(&pl031->dr) != before + seconds_to_wait)
+		return 1;
+
+	return 0;
+}
+
+static bool gic_irq_pending(void)
+{
+	uint32_t offset = (pl031_irq / 32) * 4;
+
+	return readl(gic_ispendr + offset) & (1 << (pl031_irq & 31));
+}
+
+static void gic_irq_unmask(void)
+{
+	uint32_t offset = (pl031_irq / 32) * 4;
+
+	writel(1 << (pl031_irq & 31), gic_isenabler + offset);
+}
+
+static void irq_handler(struct pt_regs *regs)
+{
+	u32 irqstat = gic_read_iar();
+	u32 irqnr = gic_iar_irqnr(irqstat);
+
+	gic_write_eoir(irqstat);
+
+	if (irqnr == pl031_irq) {
+		report("  RTC RIS == 1", readl(&pl031->ris) == 1);
+		report("  RTC MIS == 1", readl(&pl031->mis) == 1);
+
+		/* Writing any value should clear IRQ status */
+		writel(0x80000000ULL, &pl031->icr);
+
+		report("  RTC RIS == 0", readl(&pl031->ris) == 0);
+		report("  RTC MIS == 0", readl(&pl031->mis) == 0);
+		irq_triggered = true;
+	} else {
+		report_info("Unexpected interrupt: %d\n", irqnr);
+		return;
+	}
+}
+
+static int check_rtc_irq(void)
+{
+	uint32_t seconds_to_wait = 1;
+	uint32_t before = readl(&pl031->dr);
+	uint64_t before_tick = get_cntvct();
+	uint64_t target_tick = before_tick + (cntfrq * (seconds_to_wait + 1));
+
+	report_info("Checking IRQ trigger (MR)");
+
+	irq_triggered = false;
+
+	/* Fire IRQ in 1 second */
+	writel(before + seconds_to_wait, &pl031->mr);
+
+#ifdef __aarch64__
+	install_irq_handler(EL1H_IRQ, irq_handler);
+#else
+	install_exception_handler(EXCPTN_IRQ, irq_handler);
+#endif
+
+	/* Wait until 2 seconds are over */
+	while (get_cntvct() < target_tick) ;
+
+	report("  RTC IRQ not delivered without mask", !gic_irq_pending());
+
+	/* Mask the IRQ so that it gets delivered */
+	writel(1, &pl031->imsc);
+	report("  RTC IRQ pending now", gic_irq_pending());
+
+	/* Enable retrieval of IRQ */
+	gic_irq_unmask();
+	local_irq_enable();
+
+	report("  IRQ triggered", irq_triggered);
+	report("  RTC IRQ not pending anymore", !gic_irq_pending());
+	if (!irq_triggered) {
+		report_info("  RTC RIS: %x", readl(&pl031->ris));
+		report_info("  RTC MIS: %x", readl(&pl031->mis));
+		report_info("  RTC IMSC: %x", readl(&pl031->imsc));
+		report_info("  GIC IRQs pending: %08x %08x", readl(gic_ispendr), readl(gic_ispendr + 4));
+	}
+
+	local_irq_disable();
+	return 0;
+}
+
+static void rtc_irq_init(void)
+{
+	gic_enable_defaults();
+
+	switch (gic_version()) {
+	case 2:
+		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
+		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
+		break;
+	case 3:
+		gic_ispendr = gicv3_dist_base() + GICD_ISPENDR;
+		gic_isenabler = gicv3_dist_base() + GICD_ISENABLER;
+		break;
+	}
+}
+
+static int rtc_fdt_init(void)
+{
+	const struct fdt_property *prop;
+	const void *fdt = dt_fdt();
+	struct dt_pbus_reg base;
+	int node, len;
+	u32 *data;
+
+	node = fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
+	if (node < 0)
+		return -1;
+
+	prop = fdt_get_property(fdt, node, "interrupts", &len);
+	assert(prop && len == (3 * sizeof(u32)));
+	data = (u32 *)prop->data;
+	assert(data[0] == 0); /* SPI */
+	pl031_irq = SPI(fdt32_to_cpu(data[1]));
+
+	assert(!dt_pbus_translate_node(node, 0, &base));
+	pl031 = ioremap(base.addr, base.size);
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	cntfrq = get_cntfrq();
+	rtc_irq_init();
+	if (rtc_fdt_init()) {
+		report_skip("Skipping PL031 tests. No device present.");
+		return 0;
+	}
+
+	report("Periph/PCell IDs match", !check_id());
+	report("R/O fields are R/O", !check_ro());
+	report("RTC ticks at 1HZ", !check_rtc_freq());
+	report("RTC IRQ not pending yet", !gic_irq_pending());
+	check_rtc_irq();
+
+	return report_summary();
+}
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index f6dfb90..1fc10a0 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -41,6 +41,7 @@
 #include <asm/gic-v3.h>
 
 #define PPI(irq)			((irq) + 16)
+#define SPI(irq)			((irq) + GIC_FIRST_SPI)
 
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
-- 
2.17.1

