Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37504F4E77
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfKHOmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:42:55 -0500
Received: from foss.arm.com ([217.140.110.172]:44550 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbfKHOmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86E55CFC;
        Fri,  8 Nov 2019 06:42:54 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 696023F719;
        Fri,  8 Nov 2019 06:42:53 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 03/17] arm: gic: Provide per-IRQ helper functions
Date:   Fri,  8 Nov 2019 14:42:26 +0000
Message-Id: <20191108144240.204202-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A common theme when accessing per-IRQ parameters in the GIC distributor
is to set fields of a certain bit width in a range of MMIO registers.
Examples are the enabled status (one bit per IRQ), the level/edge
configuration (2 bits per IRQ) or the priority (8 bits per IRQ).

Add a generic helper function which is able to mask and set the
respective number of bits, given the IRQ number and the MMIO offset.
Provide wrappers using this function to easily allow configuring an IRQ.

For now assume that private IRQ numbers always refer to the current CPU.
In a GICv2 accessing the "other" private IRQs is not easily doable (the
registers are banked per CPU on the same MMIO address), so we impose the
same limitation on GICv3, even though those registers are not banked
there anymore.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 lib/arm/asm/gic-v3.h |  1 +
 lib/arm/asm/gic.h    |  9 +++++
 lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index ed6a5ad..8cfaed1 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -23,6 +23,7 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_IROUTER			0x6000
 #define GICD_PIDR2			0xffe8
 
 /* Re-Distributor registers, offsets from RD_base */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 1fc10a0..21cdb58 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -15,6 +15,7 @@
 #define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
 #define GICD_ISPENDR			0x0200
 #define GICD_ICPENDR			0x0280
 #define GICD_ISACTIVER			0x0300
@@ -73,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
 extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
 
+void gic_set_irq_bit(int irq, int offset);
+void gic_enable_irq(int irq);
+void gic_disable_irq(int irq);
+void gic_set_irq_priority(int irq, u8 prio);
+void gic_set_irq_target(int irq, int cpu);
+void gic_set_irq_group(int irq, int group);
+int gic_get_irq_group(int irq);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 9430116..cf4e811 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
 	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
 	gic_common_ops->ipi_send_mask(irq, dest);
 }
+
+enum gic_bit_access {
+	ACCESS_READ,
+	ACCESS_SET,
+	ACCESS_RMW
+};
+
+static u8 gic_masked_irq_bits(int irq, int offset, int bits, u8 value,
+			      enum gic_bit_access access)
+{
+	void *base;
+	int split = 32 / bits;
+	int shift = (irq % split) * bits;
+	u32 reg, mask = ((1U << bits) - 1) << shift;
+
+	switch (gic_version()) {
+	case 2:
+		base = gicv2_dist_base();
+		break;
+	case 3:
+		if (irq < 32)
+			base = gicv3_sgi_base();
+		else
+			base = gicv3_dist_base();
+		break;
+	default:
+		return 0;
+	}
+	base += offset + (irq / split) * 4;
+
+	switch (access) {
+	case ACCESS_READ:
+		return (readl(base) & mask) >> shift;
+	case ACCESS_SET:
+		reg = 0;
+		break;
+	case ACCESS_RMW:
+		reg = readl(base) & ~mask;
+		break;
+	}
+
+	writel(reg | ((u32)value << shift), base);
+
+	return 0;
+}
+
+void gic_set_irq_bit(int irq, int offset)
+{
+	gic_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET);
+}
+
+void gic_enable_irq(int irq)
+{
+	gic_set_irq_bit(irq, GICD_ISENABLER);
+}
+
+void gic_disable_irq(int irq)
+{
+	gic_set_irq_bit(irq, GICD_ICENABLER);
+}
+
+void gic_set_irq_priority(int irq, u8 prio)
+{
+	gic_masked_irq_bits(irq, GICD_IPRIORITYR, 8, prio, ACCESS_RMW);
+}
+
+void gic_set_irq_target(int irq, int cpu)
+{
+	if (irq < 32)
+		return;
+
+	if (gic_version() == 2) {
+		gic_masked_irq_bits(irq, GICD_ITARGETSR, 8, 1U << cpu,
+				    ACCESS_RMW);
+
+		return;
+	}
+
+	writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
+}
+
+void gic_set_irq_group(int irq, int group)
+{
+	gic_masked_irq_bits(irq, GICD_IGROUPR, 1, group, ACCESS_RMW);
+}
+
+int gic_get_irq_group(int irq)
+{
+	return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
+}
-- 
2.17.1

