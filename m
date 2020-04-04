Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5973119E5D7
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgDDOjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:39:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726327AbgDDOjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X20dgf4X4pc8SyTqMUbSMQahZSITCPlh6jRxQWys+PQ=;
        b=OXC7KNRgzbrSdfQ3IUPWCyIjXH9E5DlUMeR8tJIhDcXpL8GXFACFYAwzRPFAn+KXPAqUJw
        0Y8MpqwZDEjWKPjXs9sGhUFhxNc3j121n26LB4fgaoI+5fgBxYcJKwP0UpkA5droZ7w2xQ
        Qbo1aAf9+9ynZK61kcThpzJPc2nnW0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-0XoXD2ExO-WrYaVq5OezQw-1; Sat, 04 Apr 2020 10:39:13 -0400
X-MC-Unique: 0XoXD2ExO-WrYaVq5OezQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F0A2800D53;
        Sat,  4 Apr 2020 14:39:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB3D1147D3;
        Sat,  4 Apr 2020 14:39:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PULL kvm-unit-tests 32/39] arm/arm64: ITS: Introspection tests
Date:   Sat,  4 Apr 2020 16:37:24 +0200
Message-Id: <20200404143731.208138-33-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Detect the presence of an ITS as part of the GICv3 init
routine, initialize its base address and read few registers
the IIDR, the TYPER to store its dimensioning parameters.
Parse the BASER registers. As part of the init sequence we
also init all the requested tables.

This is our first ITS test, belonging to a new "its" group.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.arm64         |  1 +
 arm/gic.c                  | 48 +++++++++++++++++++
 arm/unittests.cfg          |  7 +++
 lib/arm/asm/gic-v3-its.h   | 27 +++++++++++
 lib/arm/asm/gic.h          |  1 +
 lib/arm/gic.c              | 40 +++++++++++++---
 lib/arm64/asm/gic-v3-its.h | 96 +++++++++++++++++++++++++++++++++++++
 lib/arm64/gic-v3-its.c     | 98 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 311 insertions(+), 7 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm64/asm/gic-v3-its.h
 create mode 100644 lib/arm64/gic-v3-its.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 6d3dc2c4a464..60182ae92778 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -19,6 +19,7 @@ endef
 cstart.o =3D $(TEST_DIR)/cstart64.o
 cflatobjs +=3D lib/arm64/processor.o
 cflatobjs +=3D lib/arm64/spinlock.o
+cflatobjs +=3D lib/arm64/gic-v3-its.o
=20
 OBJDIRS +=3D lib/arm64
=20
diff --git a/arm/gic.c b/arm/gic.c
index 2f904b0ef375..649ed81d33e1 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -16,6 +16,7 @@
 #include <asm/processor.h>
 #include <asm/delay.h>
 #include <asm/gic.h>
+#include <asm/gic-v3-its.h>
 #include <asm/smp.h>
 #include <asm/barrier.h>
 #include <asm/io.h>
@@ -517,6 +518,49 @@ static void gic_test_mmio(void)
 		test_targets(nr_irqs);
 }
=20
+#if defined(__arm__)
+
+static void test_its_introspection(void) {}
+
+#else /* __aarch64__ */
+
+static void test_its_introspection(void)
+{
+	struct its_baser *dev_baser =3D &its_data.device_baser;
+	struct its_baser *coll_baser =3D &its_data.coll_baser;
+	struct its_typer *typer =3D &its_data.typer;
+
+	if (!gicv3_its_base()) {
+		report_skip("No ITS, skip ...");
+		return;
+	}
+
+	/* IIDR */
+	report(test_readonly_32(gicv3_its_base() + GITS_IIDR, false),
+	       "GITS_IIDR is read-only"),
+
+	/* TYPER */
+	report(test_readonly_32(gicv3_its_base() + GITS_TYPER, false),
+	       "GITS_TYPER is read-only");
+
+	report(typer->phys_lpi, "ITS supports physical LPIs");
+	report_info("vLPI support: %s", typer->virt_lpi ? "yes" : "no");
+	report_info("ITT entry size =3D 0x%x", typer->ite_size);
+	report_info("Bit Count: EventID=3D%d DeviceId=3D%d CollId=3D%d",
+		    typer->eventid_bits, typer->deviceid_bits,
+		    typer->collid_bits);
+	report(typer->eventid_bits && typer->deviceid_bits &&
+	       typer->collid_bits, "ID spaces");
+	report_info("Target address format %s",
+			typer->pta ? "Redist base address" : "PE #");
+
+	report(dev_baser && coll_baser, "detect device and collection BASER");
+	report_info("device table entry_size =3D 0x%x", dev_baser->esz);
+	report_info("collection table entry_size =3D 0x%x", coll_baser->esz);
+}
+
+#endif
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -548,6 +592,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		gic_test_mmio();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_its_introspection();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 455fd10d63c9..fff37f9fb5e6 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -177,6 +177,13 @@ smp =3D $MAX_SMP
 extra_params =3D -machine gic-version=3D3 -append 'active'
 groups =3D gic
=20
+[its-introspection]
+file =3D gic.flat
+smp =3D $MAX_SMP
+extra_params =3D -machine gic-version=3D3 -append 'its-introspection'
+groups =3D its
+arch =3D arm64
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
new file mode 100644
index 000000000000..efd8f675dbf2
--- /dev/null
+++ b/lib/arm/asm/gic-v3-its.h
@@ -0,0 +1,27 @@
+/*
+ * ITS 32-bit stubs
+ *
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_GIC_V3_ITS_H_
+#define _ASMARM_GIC_V3_ITS_H_
+
+#ifndef _ASMARM_GIC_H_
+#error Do not directly include <asm/gic-v3-its.h>. Include <asm/gic.h>
+#endif
+
+#include <libcflat.h>
+
+/* dummy its_data struct to allow gic_get_dt_bases() call */
+struct its_data {
+	void *base;
+};
+
+static inline void its_init(void)
+{
+	assert_msg(false, "not supported on 32-bit");
+}
+
+#endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index afb33096078d..38e79b2ac281 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -40,6 +40,7 @@
=20
 #include <asm/gic-v2.h>
 #include <asm/gic-v3.h>
+#include <asm/gic-v3-its.h>
=20
 #define PPI(irq)			((irq) + 16)
 #define SPI(irq)			((irq) + GIC_FIRST_SPI)
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 8a1a8c84bf29..1bfcfcfbc253 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -9,6 +9,7 @@
=20
 struct gicv2_data gicv2_data;
 struct gicv3_data gicv3_data;
+struct its_data its_data;
=20
 struct gic_common_ops {
 	void (*enable_defaults)(void);
@@ -44,12 +45,13 @@ static const struct gic_common_ops gicv3_common_ops =3D=
 {
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
-gic_get_dt_bases(const char *compatible, void **base1, void **base2)
+gic_get_dt_bases(const char *compatible, void **base1, void **base2, voi=
d **base3)
 {
 	struct dt_pbus_reg reg;
-	struct dt_device gic;
+	struct dt_device gic, its;
 	struct dt_bus bus;
-	int node, ret, i;
+	int node, subnode, ret, i, len;
+	const void *fdt =3D dt_fdt();
=20
 	dt_bus_init_defaults(&bus);
 	dt_device_init(&gic, &bus, NULL);
@@ -74,19 +76,39 @@ gic_get_dt_bases(const char *compatible, void **base1=
, void **base2)
 		base2[i] =3D ioremap(reg.addr, reg.size);
 	}
=20
+	if (!base3) {
+		assert(!strcmp(compatible, "arm,cortex-a15-gic"));
+		return true;
+	}
+
+	assert(!strcmp(compatible, "arm,gic-v3"));
+
+	dt_for_each_subnode(node, subnode) {
+		const struct fdt_property *prop;
+
+		prop =3D fdt_get_property(fdt, subnode, "compatible", &len);
+		if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
+			dt_device_bind_node(&its, subnode);
+			ret =3D dt_pbus_translate(&its, 0, &reg);
+			assert(ret =3D=3D 0);
+			*base3 =3D ioremap(reg.addr, reg.size);
+			break;
+		}
+	}
+
 	return true;
 }
=20
 int gicv2_init(void)
 {
 	return gic_get_dt_bases("arm,cortex-a15-gic",
-			&gicv2_data.dist_base, &gicv2_data.cpu_base);
+			&gicv2_data.dist_base, &gicv2_data.cpu_base, NULL);
 }
=20
 int gicv3_init(void)
 {
 	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
-			&gicv3_data.redist_bases[0]);
+			&gicv3_data.redist_bases[0], &its_data.base);
 }
=20
 int gic_version(void)
@@ -100,10 +122,14 @@ int gic_version(void)
=20
 int gic_init(void)
 {
-	if (gicv2_init())
+	if (gicv2_init()) {
 		gic_common_ops =3D &gicv2_common_ops;
-	else if (gicv3_init())
+	} else if (gicv3_init()) {
 		gic_common_ops =3D &gicv3_common_ops;
+#ifdef __aarch64__
+		its_init();
+#endif
+	}
 	return gic_version();
 }
=20
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
new file mode 100644
index 000000000000..c0bd58c6d0f5
--- /dev/null
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -0,0 +1,96 @@
+/*
+ * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
+ *
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM64_GIC_V3_ITS_H_
+#define _ASMARM64_GIC_V3_ITS_H_
+
+#ifndef _ASMARM_GIC_H_
+#error Do not directly include <asm/gic-v3-its.h>. Include <asm/gic.h>
+#endif
+
+struct its_typer {
+	unsigned int ite_size;
+	unsigned int eventid_bits;
+	unsigned int deviceid_bits;
+	unsigned int collid_bits;
+	bool pta;
+	bool phys_lpi;
+	bool virt_lpi;
+};
+
+struct its_baser {
+	int index;
+	size_t psz;
+	int esz;
+	bool indirect;
+	void *table_addr;
+};
+
+#define GITS_BASER_NR_REGS		8
+
+struct its_data {
+	void *base;
+	struct its_typer typer;
+	struct its_baser device_baser;
+	struct its_baser coll_baser;
+	struct its_cmd_block *cmd_base;
+	struct its_cmd_block *cmd_write;
+};
+
+extern struct its_data its_data;
+
+#define gicv3_its_base()		(its_data.base)
+
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+
+#define GITS_TYPER_PLPIS		BIT(0)
+#define GITS_TYPER_VLPIS		BIT(1)
+#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
+#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
+#define GITS_TYPER_IDBITS		GENMASK_ULL(12, 8)
+#define GITS_TYPER_IDBITS_SHIFT		8
+#define GITS_TYPER_DEVBITS		GENMASK_ULL(17, 13)
+#define GITS_TYPER_DEVBITS_SHIFT	13
+#define GITS_TYPER_PTA			BIT(19)
+#define GITS_TYPER_CIDBITS		GENMASK_ULL(35, 32)
+#define GITS_TYPER_CIDBITS_SHIFT	32
+#define GITS_TYPER_CIL			BIT(36)
+
+#define GITS_CTLR_ENABLE		(1U << 0)
+
+#define GITS_CBASER_VALID		(1UL << 63)
+
+#define GITS_BASER_VALID		BIT(63)
+#define GITS_BASER_INDIRECT		BIT(62)
+#define GITS_BASER_TYPE_SHIFT		(56)
+#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
+#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) =
& 0x1f) + 1)
+#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
+#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGES_MAX		256
+#define GITS_BASER_PAGES_SHIFT		(0)
+#define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
+#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
+#define GITS_BASER_TYPE_NONE		0
+#define GITS_BASER_TYPE_DEVICE		1
+#define GITS_BASER_TYPE_COLLECTION	4
+
+extern void its_parse_typer(void);
+extern void its_init(void);
+extern int its_baser_lookup(int i, struct its_baser *baser);
+
+#endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
new file mode 100644
index 000000000000..04dde9774c5d
--- /dev/null
+++ b/lib/arm64/gic-v3-its.c
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+#include <alloc_page.h>
+
+void its_parse_typer(void)
+{
+	u64 typer =3D readq(gicv3_its_base() + GITS_TYPER);
+	struct its_typer *t =3D &its_data.typer;
+
+	t->ite_size =3D ((typer & GITS_TYPER_ITT_ENTRY_SIZE) >> GITS_TYPER_ITT_=
ENTRY_SIZE_SHIFT) + 1;
+	t->pta =3D typer & GITS_TYPER_PTA;
+	t->eventid_bits =3D ((typer & GITS_TYPER_IDBITS) >> GITS_TYPER_IDBITS_S=
HIFT) + 1;
+	t->deviceid_bits =3D ((typer & GITS_TYPER_DEVBITS) >> GITS_TYPER_DEVBIT=
S_SHIFT) + 1;
+
+	if (typer & GITS_TYPER_CIL)
+		t->collid_bits =3D ((typer & GITS_TYPER_CIDBITS) >> GITS_TYPER_CIDBITS=
_SHIFT) + 1;
+	else
+		t->collid_bits =3D 16;
+
+	t->virt_lpi =3D typer & GITS_TYPER_VLPIS;
+	t->phys_lpi =3D typer & GITS_TYPER_PLPIS;
+}
+
+int its_baser_lookup(int type, struct its_baser *baser)
+{
+	int i;
+
+	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
+		void *reg_addr =3D gicv3_its_base() + GITS_BASER + i * 8;
+		u64 val =3D readq(reg_addr);
+
+		if (GITS_BASER_TYPE(val) =3D=3D type) {
+			assert((val & GITS_BASER_PAGE_SIZE_MASK) =3D=3D GITS_BASER_PAGE_SIZE_=
64K);
+			baser->esz =3D GITS_BASER_ENTRY_SIZE(val);
+			baser->indirect =3D val & GITS_BASER_INDIRECT;
+			baser->index =3D i;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+/*
+ * Allocate the BASER table (a single page of size @baser->psz)
+ * and set the BASER valid
+ */
+static void its_baser_alloc_table(struct its_baser *baser, size_t size)
+{
+	unsigned long order =3D get_order(size >> PAGE_SHIFT);
+	void *reg_addr =3D gicv3_its_base() + GITS_BASER + baser->index * 8;
+	u64 val =3D readq(reg_addr);
+
+	baser->table_addr =3D alloc_pages(order);
+
+	val |=3D virt_to_phys(baser->table_addr) | GITS_BASER_VALID;
+
+	writeq(val, reg_addr);
+}
+
+/*
+ * init_cmd_queue - Allocate the command queue and initialize
+ * CBASER, CWRITER
+ */
+static void its_cmd_queue_init(void)
+{
+	unsigned long order =3D get_order(SZ_64K >> PAGE_SHIFT);
+	u64 cbaser;
+
+	its_data.cmd_base =3D alloc_pages(order);
+
+	cbaser =3D virt_to_phys(its_data.cmd_base) | (SZ_64K / SZ_4K - 1) | GIT=
S_CBASER_VALID;
+
+	writeq(cbaser, its_data.base + GITS_CBASER);
+
+	its_data.cmd_write =3D its_data.cmd_base;
+	writeq(0, its_data.base + GITS_CWRITER);
+}
+
+void its_init(void)
+{
+	if (!its_data.base)
+		return;
+
+	its_parse_typer();
+
+	assert(!its_baser_lookup(GITS_BASER_TYPE_DEVICE, &its_data.device_baser=
));
+	assert(!its_baser_lookup(GITS_BASER_TYPE_COLLECTION, &its_data.coll_bas=
er));
+
+	its_baser_alloc_table(&its_data.device_baser, SZ_64K);
+	its_baser_alloc_table(&its_data.coll_baser, SZ_64K);
+
+	its_cmd_queue_init();
+}
+
--=20
2.25.1

