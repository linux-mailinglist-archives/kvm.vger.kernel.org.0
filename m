Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A57F4E7F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfKHOnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:43:03 -0500
Received: from foss.arm.com ([217.140.110.172]:44632 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfKHOnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:43:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88B927A7;
        Fri,  8 Nov 2019 06:43:02 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A5A73F719;
        Fri,  8 Nov 2019 06:43:01 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping GICD_CTLR.DS
Date:   Fri,  8 Nov 2019 14:42:32 +0000
Message-Id: <20191108144240.204202-10-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DS (Disable Security) bit in the GICv3 GICD_CTLR register controls
access to Group 0 interrupts from the non-secure side.
The KVM VGIC emulation provides a "GIC with a single security state",
so both groups should be accessible.
Provide a test to check this bit can be set to one. The current KVM
emulation should treat this is as RAO/WI (which we also check here). It
would be architecturally compliant though to have this bit at 0 as well,
so we refrain from treating different behaviour as a FAIL.
However we use this as a gateway for further Group 0 IRQ tests.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c            | 62 ++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic-v3.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 304b7b9..c882a24 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -531,6 +531,8 @@ static void gic_test_mmio(void)
 	reg = readl(gic_dist_base + GICD_TYPER);
 	nr_irqs = GICD_TYPER_IRQS(reg);
 	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
+	report_info("GIC %s security extension",
+		reg & (1U << 10) ? "has" : "does not have");
 
 	if (gic_version() == 0x2)
 		test_typer_v2(reg);
@@ -638,6 +640,60 @@ static void spi_test_smp(void)
 	report("SPI delievered on all cores", cores == nr_cpus);
 }
 
+/*
+ * Check the security state configuration of the GIC.
+ * Test whether we can switch to a single security state, to test both
+ * group 0 and group 1 interrupts.
+ * Architecturally a GIC can be configured in different ways, so we don't
+ * insist on the current way KVM emulates the GIC.
+ */
+static bool gicv3_check_security(void *gicd_base)
+{
+	u32 ctlr = readl(gicd_base + GICD_CTLR);
+
+	if (ctlr & GICD_CTLR_DS) {
+		writel(ctlr & ~GICD_CTLR_DS, gicd_base + GICD_CTLR);
+		ctlr = readl(gicd_base + GICD_CTLR);
+		if (!(ctlr & GICD_CTLR_DS))
+			report_info("GIC allowing two security states");
+		else
+			report_info("GIC is one security state only");
+	} else {
+		report_info("GIC resets to two security states");
+	}
+
+	writel(ctlr | GICD_CTLR_DS, gicd_base + GICD_CTLR);
+	ctlr = readl(gicd_base + GICD_CTLR);
+	report("switching to single security state", ctlr & GICD_CTLR_DS);
+
+	/* Group0 delivery only works in single security state. */
+	return ctlr & GICD_CTLR_DS;
+}
+
+/*
+ * The GIC architecture describes two interrupt groups, group 0 and group 1.
+ * On bare-metal systems, running in non-secure world on a GIC with the
+ * security extensions, there is only one group available: group 1.
+ * However in the kernel KVM emulates a GIC with only one security state,
+ * so both groups are available to guests.
+ * Check whether this works as expected (as Linux will not use this feature).
+ * We can only verify this state on a GICv3, so we check it there and silently
+ * assume it's valid for GICv2.
+ */
+static void test_irq_group(void *gicd_base)
+{
+	bool is_gicv3 = (gic_version() == 3);
+
+	report_prefix_push("GROUP");
+	gic_enable_defaults();
+
+	if (is_gicv3) {
+		/* GICv3 features a bit to read and set the security state. */
+		if (!gicv3_check_security(gicd_base))
+			return;
+	}
+}
+
 static void spi_send(void)
 {
 	irqs_enable();
@@ -647,6 +703,12 @@ static void spi_send(void)
 	if (nr_cpus > 1)
 		spi_test_smp();
 
+	if (gic_version() == 3)
+		test_irq_group(gicv3_dist_base());
+
+	if (gic_version() == 2)
+		test_irq_group(gicv2_dist_base());
+
 	check_spurious();
 	exit(report_summary());
 }
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 8cfaed1..2eaf944 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -19,6 +19,7 @@
  * group1 enable bits with respect to that view.
  */
 #define GICD_CTLR_RWP			(1U << 31)
+#define GICD_CTLR_DS			(1U << 6)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
-- 
2.17.1

