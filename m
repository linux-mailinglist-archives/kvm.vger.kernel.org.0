Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5AF6F1734
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346001AbjD1MFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345984AbjD1MFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:05:08 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5430E2696
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:05:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E07F1480;
        Fri, 28 Apr 2023 05:05:50 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C41A3F5A1;
        Fri, 28 Apr 2023 05:05:05 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 15/29] arm64: Add support for gic initialization through ACPI
Date:   Fri, 28 Apr 2023 13:03:51 +0100
Message-Id: <20230428120405.3770496-16-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In systems with ACPI support and when a DT is not provided, we can use
the MADTs to figure out if it implements a GICv2 or a GICv3 and
discover the GIC parameters. This change implements this but retains
the default behavior; we check if a valid DT is provided, if not, we
try to discover the cores in the system using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/acpi.h     |  44 +++++++++++++++-
 lib/libcflat.h |   1 +
 lib/acpi.c     |   9 +++-
 lib/arm/gic.c  | 139 ++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 189 insertions(+), 4 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 4a59f543..202d832e 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -184,6 +184,48 @@ struct acpi_madt_generic_interrupt {
 	u16 spe_interrupt;	/* ACPI 6.3 */
 };
 
+/* 12: Generic Distributor (ACPI 5.0 + ACPI 6.0 changes) */
+
+struct acpi_madt_generic_distributor {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* reserved - must be zero */
+	u32 gic_id;
+	u64 base_address;
+	u32 global_irq_base;
+	u8 version;
+	u8 reserved2[3];	/* reserved - must be zero */
+};
+
+/* Values for Version field above */
+
+enum acpi_madt_gic_version {
+	ACPI_MADT_GIC_VERSION_NONE = 0,
+	ACPI_MADT_GIC_VERSION_V1 = 1,
+	ACPI_MADT_GIC_VERSION_V2 = 2,
+	ACPI_MADT_GIC_VERSION_V3 = 3,
+	ACPI_MADT_GIC_VERSION_V4 = 4,
+	ACPI_MADT_GIC_VERSION_RESERVED = 5	/* 5 and greater are reserved */
+};
+
+/* 14: Generic Redistributor (ACPI 5.1) */
+
+struct acpi_madt_generic_redistributor {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* reserved - must be zero */
+	u64 base_address;
+	u32 length;
+};
+
+/* 15: Generic Translator (ACPI 6.0) */
+
+struct acpi_madt_generic_translator {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* reserved - must be zero */
+	u32 translation_id;
+	u64 base_address;
+	u32 reserved2;
+};
+
 /* Values for MADT subtable type in struct acpi_subtable_header */
 
 enum acpi_madt_type {
@@ -254,6 +296,6 @@ struct acpi_table_gtdt {
 
 void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
 void *find_acpi_table_addr(u32 sig);
-void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
+int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
 
 #endif
diff --git a/lib/libcflat.h b/lib/libcflat.h
index c1fd31ff..700f4352 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -161,6 +161,7 @@ extern void setup_vm(void);
 #define SZ_8K			(1 << 13)
 #define SZ_16K			(1 << 14)
 #define SZ_64K			(1 << 16)
+#define SZ_128K			(1 << 17)
 #define SZ_1M			(1 << 20)
 #define SZ_2M			(1 << 21)
 #define SZ_1G			(1 << 30)
diff --git a/lib/acpi.c b/lib/acpi.c
index bbe33d08..760cd8b2 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -103,11 +103,12 @@ void *find_acpi_table_addr(u32 sig)
 	return NULL;
 }
 
-void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
+int acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler)
 {
 	struct acpi_table_madt *madt;
 	struct acpi_subtable_header *header;
 	void *end;
+	int count = 0;
 
 	madt = find_acpi_table_addr(MADT_SIGNATURE);
 	assert(madt);
@@ -116,9 +117,13 @@ void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler
 	end = (void *)((ulong) madt + madt->length);
 
 	while ((void *)header < end) {
-		if (header->type == mtype)
+		if (header->type == mtype) {
 			handler(header);
+			count++;
+		}
 
 		header = (void *)(ulong) header + header->length;
 	}
+
+	return count;
 }
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 89a15fe8..af43a96d 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -3,6 +3,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <acpi.h>
 #include <devicetree.h>
 #include <asm/gic.h>
 #include <asm/io.h>
@@ -120,7 +121,7 @@ int gic_version(void)
 	return 0;
 }
 
-int gic_init(void)
+static int gic_init_fdt(void)
 {
 	if (gicv2_init()) {
 		gic_common_ops = &gicv2_common_ops;
@@ -133,6 +134,142 @@ int gic_init(void)
 	return gic_version();
 }
 
+#ifdef CONFIG_EFI
+
+#define ACPI_GICV2_DIST_MEM_SIZE	(SZ_4K)
+#define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
+#define ACPI_GICV3_DIST_MEM_SIZE	(SZ_64K)
+#define ACPI_GICV3_ITS_MEM_SIZE		(SZ_128K)
+
+static int gic_acpi_version(struct acpi_subtable_header *header)
+{
+	struct acpi_madt_generic_distributor *dist = (void *)header;
+	int version = dist->version;
+
+	if (version == 2)
+		gic_common_ops = &gicv2_common_ops;
+	else if (version == 3)
+		gic_common_ops = &gicv3_common_ops;
+
+	return version;
+}
+
+static int gicv2_acpi_parse_madt_cpu(struct acpi_subtable_header *header)
+{
+	struct acpi_madt_generic_interrupt *gicc = (void *)header;
+	static phys_addr_t gicc_base_address;
+
+	if (!(gicc->flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (!gicc_base_address) {
+		gicc_base_address = gicc->base_address;
+		gicv2_data.cpu_base = ioremap(gicc_base_address, ACPI_GIC_CPU_IF_MEM_SIZE);
+	}
+	assert(gicc_base_address == gicc->base_address);
+
+	return 0;
+}
+
+static int gicv2_acpi_parse_madt_dist(struct acpi_subtable_header *header)
+{
+	struct acpi_madt_generic_distributor *dist = (void *)header;
+
+	gicv2_data.dist_base = ioremap(dist->base_address, ACPI_GICV2_DIST_MEM_SIZE);
+
+	return 0;
+}
+
+static int gicv3_acpi_parse_madt_gicc(struct acpi_subtable_header *header)
+{
+	struct acpi_madt_generic_interrupt *gicc = (void *)header;
+	static phys_addr_t gicr_base_address;
+
+	if (!(gicc->flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (!gicr_base_address) {
+		gicr_base_address = gicc->gicr_base_address;
+		gicv3_data.redist_bases[0] = ioremap(gicr_base_address, SZ_64K * 2);
+	}
+	assert(gicr_base_address == gicc->gicr_base_address);
+
+	return 0;
+}
+
+static int gicv3_acpi_parse_madt_dist(struct acpi_subtable_header *header)
+{
+	struct acpi_madt_generic_distributor *dist = (void *)header;
+
+	gicv3_data.dist_base = ioremap(dist->base_address, ACPI_GICV3_DIST_MEM_SIZE);
+
+	return 0;
+}
+
+static int gicv3_acpi_parse_madt_redist(struct acpi_subtable_header *header)
+{
+	static int i;
+	struct acpi_madt_generic_redistributor *redist = (void *)header;
+
+	gicv3_data.redist_bases[i++] = ioremap(redist->base_address, redist->length);
+
+	return 0;
+}
+
+static int gicv3_acpi_parse_madt_its(struct acpi_subtable_header *header)
+{
+	struct acpi_madt_generic_translator *its_entry = (void *)header;
+
+	its_data.base = ioremap(its_entry->base_address, ACPI_GICV3_ITS_MEM_SIZE - 1);
+
+	return 0;
+}
+
+static int gic_init_acpi(void)
+{
+	int count;
+
+	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR, gic_acpi_version);
+	if (gic_version() == 2) {
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				     gicv2_acpi_parse_madt_cpu);
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+				      gicv2_acpi_parse_madt_dist);
+	} else if (gic_version() == 3) {
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+				      gicv3_acpi_parse_madt_dist);
+		count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
+					      gicv3_acpi_parse_madt_redist);
+		if (!count)
+			acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+					      gicv3_acpi_parse_madt_gicc);
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
+				      gicv3_acpi_parse_madt_its);
+#ifdef __aarch64__
+		its_init();
+#endif
+	}
+
+	return gic_version();
+}
+
+#else
+
+static int gic_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+#endif /* CONFIG_EFI */
+
+int gic_init(void)
+{
+	if (dt_available())
+		return gic_init_fdt();
+	else
+		return gic_init_acpi();
+}
+
 void gic_enable_defaults(void)
 {
 	if (!gic_common_ops) {
-- 
2.25.1

