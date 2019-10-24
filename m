Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFEFE3378
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502336AbfJXNHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55470 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388377AbfJXNHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hdktmowMosU+qHQiA+aeRYFYmH7E+y/SH0pOtHuJyhk=;
        b=Q7GTwPLYwQyx9yE7p7QACmYwqXnC6tdKYvRqLtWHvhCNfCP2FnBs0l0LUWEHhy9UmvDW0a
        Kp/Ow7RKx625/w9QRiJyYpdfbhQpCXxj+ROcZ+XC8mHox/fC3Tg/OJnYSPBjwM66ReTIxm
        8CeLhR+Y/+0sYDY4DWTeQURaLCXyxHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-5bqa73AKOvCW58CxXP9b2g-1; Thu, 24 Oct 2019 09:07:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C005A1800E06;
        Thu, 24 Oct 2019 13:07:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C29FE5D70E;
        Thu, 24 Oct 2019 13:07:19 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexander Graf <graf@amazon.com>
Subject: [PULL 10/10] arm: Add PL031 test
Date:   Thu, 24 Oct 2019 15:07:01 +0200
Message-Id: <20191024130701.31238-11-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 5bqa73AKOvCW58CxXP9b2g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Graf <graf@amazon.com>

This patch adds a unit test for the PL031 RTC that is used in the virt mach=
ine.
It just pokes basic functionality. I've mostly written it to familiarize my=
self
with the device, but I suppose having the test around does not hurt, as it =
also
exercises the GIC SPI interrupt path.

Signed-off-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.common |   1 +
 arm/pl031.c         | 262 ++++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h   |   1 +
 3 files changed, 264 insertions(+)
 create mode 100644 arm/pl031.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f0c4b5d7620c..b8988f214d3b 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -11,6 +11,7 @@ tests-common +=3D $(TEST_DIR)/pmu.flat
 tests-common +=3D $(TEST_DIR)/gic.flat
 tests-common +=3D $(TEST_DIR)/psci.flat
 tests-common +=3D $(TEST_DIR)/sieve.flat
+tests-common +=3D $(TEST_DIR)/pl031.flat
=20
 tests-all =3D $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/pl031.c b/arm/pl031.c
new file mode 100644
index 000000000000..5672f36f5fc2
--- /dev/null
+++ b/arm/pl031.c
@@ -0,0 +1,262 @@
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
+=09uint32_t dr;=09/* Data Register */
+=09uint32_t mr;=09/* Match Register */
+=09uint32_t lr;=09/* Load Register */
+=09union {
+=09=09uint8_t cr;=09/* Control Register */
+=09=09uint32_t cr32;
+=09};
+=09union {
+=09=09uint8_t imsc;=09/* Interrupt Mask Set or Clear register */
+=09=09uint32_t imsc32;
+=09};
+=09union {
+=09=09uint8_t ris;=09/* Raw Interrupt Status */
+=09=09uint32_t ris32;
+=09};
+=09union {
+=09=09uint8_t mis;=09/* Masked Interrupt Status */
+=09=09uint32_t mis32;
+=09};
+=09union {
+=09=09uint8_t icr;=09/* Interrupt Clear Register */
+=09=09uint32_t icr32;
+=09};
+=09uint32_t reserved[1008];
+=09uint32_t periph_id[4];
+=09uint32_t pcell_id[4];
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
+=09uint32_t id[] =3D { 0x31, 0x10, 0x14, 0x00, 0x0d, 0xf0, 0x05, 0xb1 };
+=09int i;
+
+=09for (i =3D 0; i < ARRAY_SIZE(id); i++)
+=09=09if (id[i] !=3D readl(&pl031->periph_id[i]))
+=09=09=09return 1;
+
+=09return 0;
+}
+
+static int check_ro(void)
+{
+=09uint32_t offs[] =3D { offsetof(struct pl031_regs, ris),
+=09=09=09    offsetof(struct pl031_regs, mis),
+=09=09=09    offsetof(struct pl031_regs, periph_id[0]),
+=09=09=09    offsetof(struct pl031_regs, periph_id[1]),
+=09=09=09    offsetof(struct pl031_regs, periph_id[2]),
+=09=09=09    offsetof(struct pl031_regs, periph_id[3]),
+=09=09=09    offsetof(struct pl031_regs, pcell_id[0]),
+=09=09=09    offsetof(struct pl031_regs, pcell_id[1]),
+=09=09=09    offsetof(struct pl031_regs, pcell_id[2]),
+=09=09=09    offsetof(struct pl031_regs, pcell_id[3]) };
+=09int i;
+
+=09for (i =3D 0; i < ARRAY_SIZE(offs); i++) {
+=09=09uint32_t before32;
+=09=09uint16_t before16;
+=09=09uint8_t before8;
+=09=09void *addr =3D (void*)pl031 + offs[i];
+=09=09uint32_t poison =3D 0xdeadbeefULL;
+
+=09=09before8 =3D readb(addr);
+=09=09before16 =3D readw(addr);
+=09=09before32 =3D readl(addr);
+
+=09=09writeb(poison, addr);
+=09=09writew(poison, addr);
+=09=09writel(poison, addr);
+
+=09=09if (before8 !=3D readb(addr))
+=09=09=09return 1;
+=09=09if (before16 !=3D readw(addr))
+=09=09=09return 1;
+=09=09if (before32 !=3D readl(addr))
+=09=09=09return 1;
+=09}
+
+=09return 0;
+}
+
+static int check_rtc_freq(void)
+{
+=09uint32_t seconds_to_wait =3D 2;
+=09uint32_t before =3D readl(&pl031->dr);
+=09uint64_t before_tick =3D get_cntvct();
+=09uint64_t target_tick =3D before_tick + (cntfrq * seconds_to_wait);
+
+=09/* Wait for 2 seconds */
+=09while (get_cntvct() < target_tick) ;
+
+=09if (readl(&pl031->dr) !=3D before + seconds_to_wait)
+=09=09return 1;
+
+=09return 0;
+}
+
+static bool gic_irq_pending(void)
+{
+=09uint32_t offset =3D (pl031_irq / 32) * 4;
+
+=09return readl(gic_ispendr + offset) & (1 << (pl031_irq & 31));
+}
+
+static void gic_irq_unmask(void)
+{
+=09uint32_t offset =3D (pl031_irq / 32) * 4;
+
+=09writel(1 << (pl031_irq & 31), gic_isenabler + offset);
+}
+
+static void irq_handler(struct pt_regs *regs)
+{
+=09u32 irqstat =3D gic_read_iar();
+=09u32 irqnr =3D gic_iar_irqnr(irqstat);
+
+=09gic_write_eoir(irqstat);
+
+=09if (irqnr =3D=3D pl031_irq) {
+=09=09report("  RTC RIS =3D=3D 1", readl(&pl031->ris) =3D=3D 1);
+=09=09report("  RTC MIS =3D=3D 1", readl(&pl031->mis) =3D=3D 1);
+
+=09=09/* Writing any value should clear IRQ status */
+=09=09writel(0x80000000ULL, &pl031->icr);
+
+=09=09report("  RTC RIS =3D=3D 0", readl(&pl031->ris) =3D=3D 0);
+=09=09report("  RTC MIS =3D=3D 0", readl(&pl031->mis) =3D=3D 0);
+=09=09irq_triggered =3D true;
+=09} else {
+=09=09report_info("Unexpected interrupt: %d\n", irqnr);
+=09=09return;
+=09}
+}
+
+static int check_rtc_irq(void)
+{
+=09uint32_t seconds_to_wait =3D 1;
+=09uint32_t before =3D readl(&pl031->dr);
+=09uint64_t before_tick =3D get_cntvct();
+=09uint64_t target_tick =3D before_tick + (cntfrq * (seconds_to_wait + 1))=
;
+
+=09report_info("Checking IRQ trigger (MR)");
+
+=09irq_triggered =3D false;
+
+=09/* Fire IRQ in 1 second */
+=09writel(before + seconds_to_wait, &pl031->mr);
+
+#ifdef __aarch64__
+=09install_irq_handler(EL1H_IRQ, irq_handler);
+#else
+=09install_exception_handler(EXCPTN_IRQ, irq_handler);
+#endif
+
+=09/* Wait until 2 seconds are over */
+=09while (get_cntvct() < target_tick) ;
+
+=09report("  RTC IRQ not delivered without mask", !gic_irq_pending());
+
+=09/* Mask the IRQ so that it gets delivered */
+=09writel(1, &pl031->imsc);
+=09report("  RTC IRQ pending now", gic_irq_pending());
+
+=09/* Enable retrieval of IRQ */
+=09gic_irq_unmask();
+=09local_irq_enable();
+
+=09report("  IRQ triggered", irq_triggered);
+=09report("  RTC IRQ not pending anymore", !gic_irq_pending());
+=09if (!irq_triggered) {
+=09=09report_info("  RTC RIS: %x", readl(&pl031->ris));
+=09=09report_info("  RTC MIS: %x", readl(&pl031->mis));
+=09=09report_info("  RTC IMSC: %x", readl(&pl031->imsc));
+=09=09report_info("  GIC IRQs pending: %08x %08x", readl(gic_ispendr), rea=
dl(gic_ispendr + 4));
+=09}
+
+=09local_irq_disable();
+=09return 0;
+}
+
+static void rtc_irq_init(void)
+{
+=09gic_enable_defaults();
+
+=09switch (gic_version()) {
+=09case 2:
+=09=09gic_ispendr =3D gicv2_dist_base() + GICD_ISPENDR;
+=09=09gic_isenabler =3D gicv2_dist_base() + GICD_ISENABLER;
+=09=09break;
+=09case 3:
+=09=09gic_ispendr =3D gicv3_dist_base() + GICD_ISPENDR;
+=09=09gic_isenabler =3D gicv3_dist_base() + GICD_ISENABLER;
+=09=09break;
+=09}
+}
+
+static int rtc_fdt_init(void)
+{
+=09const struct fdt_property *prop;
+=09const void *fdt =3D dt_fdt();
+=09struct dt_pbus_reg base;
+=09int node, len;
+=09u32 *data;
+=09int ret;
+
+=09node =3D fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
+=09if (node < 0)
+=09=09return -1;
+
+=09prop =3D fdt_get_property(fdt, node, "interrupts", &len);
+=09assert(prop && len =3D=3D (3 * sizeof(u32)));
+=09data =3D (u32 *)prop->data;
+=09assert(data[0] =3D=3D 0); /* SPI */
+=09pl031_irq =3D SPI(fdt32_to_cpu(data[1]));
+
+=09ret =3D dt_pbus_translate_node(node, 0, &base);
+=09assert(!ret);
+=09pl031 =3D ioremap(base.addr, base.size);
+
+=09return 0;
+}
+
+int main(int argc, char **argv)
+{
+=09cntfrq =3D get_cntfrq();
+=09rtc_irq_init();
+=09if (rtc_fdt_init()) {
+=09=09report_skip("Skipping PL031 tests. No device present.");
+=09=09return 0;
+=09}
+
+=09report("Periph/PCell IDs match", !check_id());
+=09report("R/O fields are R/O", !check_ro());
+=09report("RTC ticks at 1HZ", !check_rtc_freq());
+=09report("RTC IRQ not pending yet", !gic_irq_pending());
+=09check_rtc_irq();
+
+=09return report_summary();
+}
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index f6dfb907a7d5..1fc10a096259 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -41,6 +41,7 @@
 #include <asm/gic-v3.h>
=20
 #define PPI(irq)=09=09=09((irq) + 16)
+#define SPI(irq)=09=09=09((irq) + GIC_FIRST_SPI)
=20
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
--=20
2.21.0

