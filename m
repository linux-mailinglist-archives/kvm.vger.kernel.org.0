Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0B514B2B0
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 11:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgA1Kf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 05:35:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23687 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgA1Kf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 05:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580207725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hksWhfx/qjqLBl2kwSG6HIa1DnV2Yh8CnWY4dayzAHc=;
        b=KAxGI6ROO/L68XdlNESrogr807MaG0fNXdZcxfzCOcSt2IhD9f7T5xu71oQ4lzSknGXbXG
        XBE3bX1TTVbvtCVjXA+8n+mlZnrKXMz0Rs35Sdc8S/sVKCgXelZ+rn7C8WHp9hq7UAho9b
        rDeN7phtd1G+vYn836oZOkSk+Y3p7jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-CymzZg9NPg-7tVbWGeDa5g-1; Tue, 28 Jan 2020 05:35:23 -0500
X-MC-Unique: CymzZg9NPg-7tVbWGeDa5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CBB3DB60;
        Tue, 28 Jan 2020 10:35:22 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1BFF1001B08;
        Tue, 28 Jan 2020 10:35:16 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 02/14] arm: gic: Provide per-IRQ helper functions
Date:   Tue, 28 Jan 2020 11:34:47 +0100
Message-Id: <20200128103459.19413-3-eric.auger@redhat.com>
In-Reply-To: <20200128103459.19413-1-eric.auger@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

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

initialize reg
---
 lib/arm/asm/gic-v3.h |  2 +
 lib/arm/asm/gic.h    |  8 ++++
 lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 0dc838b..6beeab6 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -23,6 +23,8 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
=20
+#define GICD_IROUTER			0x6000
+
 /* Re-Distributor registers, offsets from RD_base */
 #define GICR_TYPER			0x0008
=20
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 09826fd..21cdb58 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -74,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
 extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
=20
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
index 9430116..aa9cb86 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *des=
t)
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
+	int split =3D 32 / bits;
+	int shift =3D (irq % split) * bits;
+	u32 reg =3D 0, mask =3D ((1U << bits) - 1) << shift;
+
+	switch (gic_version()) {
+	case 2:
+		base =3D gicv2_dist_base();
+		break;
+	case 3:
+		if (irq < 32)
+			base =3D gicv3_sgi_base();
+		else
+			base =3D gicv3_dist_base();
+		break;
+	default:
+		return 0;
+	}
+	base +=3D offset + (irq / split) * 4;
+
+	switch (access) {
+	case ACCESS_READ:
+		return (readl(base) & mask) >> shift;
+	case ACCESS_SET:
+		reg =3D 0;
+		break;
+	case ACCESS_RMW:
+		reg =3D readl(base) & ~mask;
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
+	if (gic_version() =3D=3D 2) {
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
--=20
2.20.1

