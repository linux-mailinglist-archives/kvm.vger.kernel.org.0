Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E599561738
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiF3KEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiF3KEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:06 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B94A02A732
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:04:02 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD3A41042;
        Thu, 30 Jun 2022 03:04:02 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A77E83F5A1;
        Thu, 30 Jun 2022 03:04:01 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 11/27] arm/arm64: Add support for gic initialization through ACPI
Date:   Thu, 30 Jun 2022 11:03:08 +0100
Message-Id: <20220630100324.3153655-12-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
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
 lib/acpi.h     |  44 +++++++++++++++++
 lib/libcflat.h |   1 +
 lib/arm/gic.c  | 127 ++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 171 insertions(+), 1 deletion(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 160bfbe..9f6fbe4 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -187,6 +187,50 @@ struct acpi_madt_generic_interrupt {
 	u16 spe_interrupt;	/* ACPI 6.3 */
 };
 
+#define ACPI_MADT_ENABLED           (1) /* 00: Processor is usable if set */
+
+/* 12: Generic Distributor (ACPI 5.0 + ACPI 6.0 changes) */
+
+struct acpi_madt_generic_distributor {
+	struct acpi_subtable_header header;
+	u16 reserved;           /* reserved - must be zero */
+	u32 gic_id;
+	u64 base_address;
+	u32 global_irq_base;
+	u8 version;
+	u8 reserved2[3];        /* reserved - must be zero */
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
+	ACPI_MADT_GIC_VERSION_RESERVED = 5      /* 5 and greater are reserved */
+};
+
+/* 14: Generic Redistributor (ACPI 5.1) */
+
+struct acpi_madt_generic_redistributor {
+	struct acpi_subtable_header header;
+	u16 reserved;           /* reserved - must be zero */
+	u64 base_address;
+	u32 length;
+};
+
+/* 15: Generic Translator (ACPI 6.0) */
+
+struct acpi_madt_generic_translator {
+	struct acpi_subtable_header header;
+	u16 reserved;           /* reserved - must be zero */
+	u32 translation_id;
+	u64 base_address;
+	u32 reserved2;
+};
+
 /* Values for MADT subtable type in struct acpi_subtable_header */
 
 enum acpi_madt_type {
diff --git a/lib/libcflat.h b/lib/libcflat.h
index c1fd31f..700f435 100644
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
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 1bfcfcf..c346d1f 100644
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
@@ -133,6 +134,130 @@ int gic_init(void)
 	return gic_version();
 }
 
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
+	acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+			      gic_acpi_version);
+	if (gic_version() == 2) {
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      gicv2_acpi_parse_madt_cpu);
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+				      gicv2_acpi_parse_madt_dist);
+	} else if (gic_version() == 3) {
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+				      gicv3_acpi_parse_madt_dist);
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
+				      gicv3_acpi_parse_madt_redist);
+		if (!gicv3_data.redist_base)
+			acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
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

