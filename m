Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388651207ED
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 15:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfLPOEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 09:04:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728083AbfLPOD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 09:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VTbMEgV9QnedN5K97l8ttQss70ssTQM1tBlGgU23A1E=;
        b=ZQwGiDgW1glxOyha+t7LoDAYviNK3hxJiVUddsq14WAvcdKWpsYwqQdFWlwDhhyqwbE7Fw
        e/M105lTbyfcYKj5BTavwiQaTgB/UFKqvKXaADocPM9RlbVyJwvy+ObjpvgdzocRlwCbdD
        UJgDYj57qLi89hPdkOkd+vNtAAtzXVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-y-TEE1S-M12pskfSJZ9Uhg-1; Mon, 16 Dec 2019 09:03:56 -0500
X-MC-Unique: y-TEE1S-M12pskfSJZ9Uhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C92D1007288;
        Mon, 16 Dec 2019 14:03:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2C05675B8;
        Mon, 16 Dec 2019 14:03:51 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 05/16] arm/arm64: ITS: Introspection tests
Date:   Mon, 16 Dec 2019 15:02:24 +0100
Message-Id: <20191216140235.10751-6-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Detect the presence of an ITS as part of the GICv3 init
routine, initialize its base address and read few registers
the IIDR, the TYPER to store its dimensioning parameters.

This is our first ITS test, belonging to a new "its" group.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/Makefile.common        |   1 +
 arm/gic.c                  |  34 +++++++++++
 arm/unittests.cfg          |   6 ++
 lib/arm/asm/gic-v3-its.h   | 116 +++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h          |   1 +
 lib/arm/gic-v3-its.c       |  41 +++++++++++++
 lib/arm/gic.c              |  31 ++++++++--
 lib/arm64/asm/gic-v3-its.h |   1 +
 8 files changed, 226 insertions(+), 5 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm/gic-v3-its.c
 create mode 100644 lib/arm64/asm/gic-v3-its.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index b8988f2..1aae5a3 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -52,6 +52,7 @@ cflatobjs +=3D lib/arm/psci.o
 cflatobjs +=3D lib/arm/smp.o
 cflatobjs +=3D lib/arm/delay.o
 cflatobjs +=3D lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
+cflatobjs +=3D lib/arm/gic-v3-its.o
=20
 OBJDIRS +=3D lib/arm
=20
diff --git a/arm/gic.c b/arm/gic.c
index ba43ae5..adeb981 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -506,6 +506,36 @@ static void gic_test_mmio(void)
 		test_targets(nr_irqs);
 }
=20
+static void test_its_introspection(void)
+{
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
+	report(!typer->hw_collections, "collections only in ext memory");
+	report_info("Target address format %s",
+			typer->pta ? "Redist basse address" : "PE #");
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -537,6 +567,10 @@ int main(int argc, char **argv)
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
index daeb5a0..bd20460 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -122,6 +122,12 @@ smp =3D $MAX_SMP
 extra_params =3D -machine gic-version=3D3 -append 'active'
 groups =3D gic
=20
+[its-introspection]
+file =3D gic.flat
+smp =3D $MAX_SMP
+extra_params =3D -machine gic-version=3D3 -append 'its-introspection'
+groups =3D its
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
new file mode 100644
index 0000000..2ce483e
--- /dev/null
+++ b/lib/arm/asm/gic-v3-its.h
@@ -0,0 +1,116 @@
+/*
+ * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#ifndef _ASMARM_GIC_V3_ITS_H_
+#define _ASMARM_GIC_V3_ITS_H_
+
+#ifndef __ASSEMBLY__
+
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+
+#define GITS_TYPER_PLPIS                (1UL << 0)
+#define GITS_TYPER_IDBITS_SHIFT         8
+#define GITS_TYPER_DEVBITS_SHIFT        13
+#define GITS_TYPER_DEVBITS(r)           ((((r) >> GITS_TYPER_DEVBITS_SHI=
FT) & 0x1f) + 1)
+#define GITS_TYPER_PTA                  (1UL << 19)
+#define GITS_TYPER_HWCOLLCNT_SHIFT      24
+
+#define GITS_CTLR_ENABLE                (1U << 0)
+
+#define GITS_CBASER_VALID                       (1UL << 63)
+#define GITS_CBASER_SHAREABILITY_SHIFT          (10)
+#define GITS_CBASER_INNER_CACHEABILITY_SHIFT    (59)
+#define GITS_CBASER_OUTER_CACHEABILITY_SHIFT    (53)
+#define GITS_CBASER_SHAREABILITY_MASK                                   =
\
+	GIC_BASER_SHAREABILITY(GITS_CBASER, SHAREABILITY_MASK)
+#define GITS_CBASER_INNER_CACHEABILITY_MASK                             =
\
+	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, MASK)
+#define GITS_CBASER_OUTER_CACHEABILITY_MASK                             =
\
+	GIC_BASER_CACHEABILITY(GITS_CBASER, OUTER, MASK)
+#define GITS_CBASER_CACHEABILITY_MASK GITS_CBASER_INNER_CACHEABILITY_MAS=
K
+
+#define GITS_CBASER_InnerShareable                                      =
\
+	GIC_BASER_SHAREABILITY(GITS_CBASER, InnerShareable)
+
+#define GITS_CBASER_nCnB        GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, nCnB)
+#define GITS_CBASER_nC          GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, nC)
+#define GITS_CBASER_RaWt        GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, RaWt)
+#define GITS_CBASER_RaWb        GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, RaWt)
+#define GITS_CBASER_WaWt        GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, WaWt)
+#define GITS_CBASER_WaWb        GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, WaWb)
+#define GITS_CBASER_RaWaWt      GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, RaWaWt)
+#define GITS_CBASER_RaWaWb      GIC_BASER_CACHEABILITY(GITS_CBASER, INNE=
R, RaWaWb)
+
+#define GITS_BASER_NR_REGS              8
+
+#define GITS_BASER_VALID                        (1UL << 63)
+#define GITS_BASER_INDIRECT                     (1ULL << 62)
+
+#define GITS_BASER_INNER_CACHEABILITY_SHIFT     (59)
+#define GITS_BASER_OUTER_CACHEABILITY_SHIFT     (53)
+#define GITS_BASER_CACHEABILITY_MASK		0x7
+
+#define GITS_BASER_nCnB         GIC_BASER_CACHEABILITY(GITS_BASER, INNER=
, nCnB)
+
+#define GITS_BASER_TYPE_SHIFT                   (56)
+#define GITS_BASER_TYPE(r)              (((r) >> GITS_BASER_TYPE_SHIFT) =
& 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT             (48)
+#define GITS_BASER_ENTRY_SIZE(r)        ((((r) >> GITS_BASER_ENTRY_SIZE_=
SHIFT) & 0x1f) + 1)
+#define GITS_BASER_SHAREABILITY_SHIFT   (10)
+#define GITS_BASER_InnerShareable                                       =
\
+	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
+#define GITS_BASER_PAGE_SIZE_SHIFT      (8)
+#define GITS_BASER_PAGE_SIZE_4K         (0UL << GITS_BASER_PAGE_SIZE_SHI=
FT)
+#define GITS_BASER_PAGE_SIZE_16K        (1UL << GITS_BASER_PAGE_SIZE_SHI=
FT)
+#define GITS_BASER_PAGE_SIZE_64K        (2UL << GITS_BASER_PAGE_SIZE_SHI=
FT)
+#define GITS_BASER_PAGE_SIZE_MASK       (3UL << GITS_BASER_PAGE_SIZE_SHI=
FT)
+#define GITS_BASER_PAGES_MAX            256
+#define GITS_BASER_PAGES_SHIFT          (0)
+#define GITS_BASER_NR_PAGES(r)          (((r) & 0xff) + 1)
+#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
+
+#define GITS_BASER_TYPE_NONE            0
+#define GITS_BASER_TYPE_DEVICE          1
+#define GITS_BASER_TYPE_VCPU            2
+#define GITS_BASER_TYPE_CPU             3
+#define GITS_BASER_TYPE_COLLECTION      4
+
+#define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
+
+struct its_typer {
+	unsigned int ite_size;
+	unsigned int eventid_bits;
+	unsigned int deviceid_bits;
+	unsigned int collid_bits;
+	unsigned int hw_collections;
+	bool pta;
+	bool cil;
+	bool cct;
+	bool phys_lpi;
+	bool virt_lpi;
+};
+
+struct its_data {
+	void *base;
+	struct its_typer typer;
+};
+
+extern struct its_data its_data;
+
+#define gicv3_its_base()		(its_data.base)
+
+extern void its_parse_typer(void);
+extern void its_init(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 55dd84b..b44da9c 100644
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
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
new file mode 100644
index 0000000..34f4d0e
--- /dev/null
+++ b/lib/arm/gic-v3-its.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2016, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/gic.h>
+
+struct its_data its_data;
+
+void its_parse_typer(void)
+{
+	u64 typer =3D readq(gicv3_its_base() + GITS_TYPER);
+
+	its_data.typer.ite_size =3D ((typer >> 4) & 0xf) + 1;
+	its_data.typer.pta =3D typer & GITS_TYPER_PTA;
+	its_data.typer.eventid_bits =3D
+		((typer >> GITS_TYPER_IDBITS_SHIFT) & 0x1f) + 1;
+	its_data.typer.deviceid_bits =3D GITS_TYPER_DEVBITS(typer) + 1;
+
+	its_data.typer.cil =3D (typer >> 36) & 0x1;
+	if (its_data.typer.cil)
+		its_data.typer.collid_bits =3D ((typer >> 32) & 0xf) + 1;
+	else
+		its_data.typer.collid_bits =3D 16;
+
+	its_data.typer.hw_collections =3D
+		(typer >> GITS_TYPER_HWCOLLCNT_SHIFT) & 0xff;
+
+	its_data.typer.cct =3D typer & 0x4;
+	its_data.typer.virt_lpi =3D typer & 0x2;
+	its_data.typer.phys_lpi =3D typer & GITS_TYPER_PLPIS;
+}
+
+void its_init(void)
+{
+	if (!its_data.base)
+		return;
+
+	its_parse_typer();
+}
+
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 8416dde..f9a6f57 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -6,6 +6,7 @@
 #include <devicetree.h>
 #include <asm/gic.h>
 #include <asm/io.h>
+#include <asm/gic-v3-its.h>
=20
 struct gicv2_data gicv2_data;
 struct gicv3_data gicv3_data;
@@ -44,12 +45,14 @@ static const struct gic_common_ops gicv3_common_ops =3D=
 {
  * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
  */
 static bool
-gic_get_dt_bases(const char *compatible, void **base1, void **base2)
+gic_get_dt_bases(const char *compatible, void **base1, void **base2,
+		 void **base3)
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
@@ -74,19 +77,36 @@ gic_get_dt_bases(const char *compatible, void **base1=
, void **base2)
 		base2[i] =3D ioremap(reg.addr, reg.size);
 	}
=20
+	if (base3 && !strcmp(compatible, "arm,gic-v3")) {
+		dt_for_each_subnode(node, subnode) {
+			const struct fdt_property *prop;
+
+			prop =3D fdt_get_property(fdt, subnode,
+						"compatible", &len);
+			if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
+				dt_device_bind_node(&its, subnode);
+				ret =3D dt_pbus_translate(&its, 0, &reg);
+				assert(ret =3D=3D 0);
+				*base3 =3D ioremap(reg.addr, reg.size);
+				break;
+			}
+		}
+
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
@@ -104,6 +124,7 @@ int gic_init(void)
 		gic_common_ops =3D &gicv2_common_ops;
 	else if (gicv3_init())
 		gic_common_ops =3D &gicv3_common_ops;
+	its_init();
 	return gic_version();
 }
=20
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
new file mode 100644
index 0000000..083cba4
--- /dev/null
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -0,0 +1 @@
+#include "../../arm/asm/gic-v3-its.h"
--=20
2.20.1

