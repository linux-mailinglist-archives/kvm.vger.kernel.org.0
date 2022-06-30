Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115F3561735
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiF3KEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiF3KED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D6E643AC1
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:04:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B12971063;
        Thu, 30 Jun 2022 03:04:01 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 810CF3F5A1;
        Thu, 30 Jun 2022 03:04:00 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 10/27] arm/arm64: Add support for cpu initialization through ACPI
Date:   Thu, 30 Jun 2022 11:03:07 +0100
Message-Id: <20220630100324.3153655-11-nikos.nikoleris@arm.com>
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
the MADTs to discover the number of CPUs and their corresponding MIDR.
This change implements this but retains the default behavior; we check
if a valid DT is provided, if not, we try to discover the cores in the
system using ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/acpi.h      | 63 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/acpi.c      | 21 +++++++++++++++++
 lib/arm/setup.c | 25 +++++++++++++++++---
 3 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index 9910c39..160bfbe 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -17,6 +17,7 @@
 #define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
+#define MADT_SIGNATURE ACPI_SIGNATURE('A','P','I','C')
 #define SPCR_SIGNATURE ACPI_SIGNATURE('S','P','C','R')
 #define GTDT_SIGNATURE ACPI_SIGNATURE('G','T','D','T')
 
@@ -150,6 +151,67 @@ struct facs_descriptor_rev1
 	u8  reserved3 [40];		/* Reserved - must be zero */
 };
 
+struct acpi_table_madt {
+	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
+	u32 address;		/* Physical address of local APIC */
+	u32 flags;
+};
+
+struct acpi_subtable_header {
+	u8 type;
+	u8 length;
+};
+
+typedef int (*acpi_table_handler)(struct acpi_subtable_header *header);
+
+/* 11: Generic interrupt - GICC (ACPI 5.0 + ACPI 6.0 + ACPI 6.3 changes) */
+
+struct acpi_madt_generic_interrupt {
+	u8 type;
+	u8 length;
+	u16 reserved;		/* reserved - must be zero */
+	u32 cpu_interface_number;
+	u32 uid;
+	u32 flags;
+	u32 parking_version;
+	u32 performance_interrupt;
+	u64 parked_address;
+	u64 base_address;
+	u64 gicv_base_address;
+	u64 gich_base_address;
+	u32 vgic_interrupt;
+	u64 gicr_base_address;
+	u64 arm_mpidr;
+	u8 efficiency_class;
+	u8 reserved2[1];
+	u16 spe_interrupt;	/* ACPI 6.3 */
+};
+
+/* Values for MADT subtable type in struct acpi_subtable_header */
+
+enum acpi_madt_type {
+	ACPI_MADT_TYPE_LOCAL_APIC = 0,
+	ACPI_MADT_TYPE_IO_APIC = 1,
+	ACPI_MADT_TYPE_INTERRUPT_OVERRIDE = 2,
+	ACPI_MADT_TYPE_NMI_SOURCE = 3,
+	ACPI_MADT_TYPE_LOCAL_APIC_NMI = 4,
+	ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE = 5,
+	ACPI_MADT_TYPE_IO_SAPIC = 6,
+	ACPI_MADT_TYPE_LOCAL_SAPIC = 7,
+	ACPI_MADT_TYPE_INTERRUPT_SOURCE = 8,
+	ACPI_MADT_TYPE_LOCAL_X2APIC = 9,
+	ACPI_MADT_TYPE_LOCAL_X2APIC_NMI = 10,
+	ACPI_MADT_TYPE_GENERIC_INTERRUPT = 11,
+	ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR = 12,
+	ACPI_MADT_TYPE_GENERIC_MSI_FRAME = 13,
+	ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR = 14,
+	ACPI_MADT_TYPE_GENERIC_TRANSLATOR = 15,
+	ACPI_MADT_TYPE_RESERVED = 16	/* 16 and greater are reserved */
+};
+
+/* MADT Local APIC flags */
+#define ACPI_MADT_ENABLED		(1) /* 00: Processor is usable if set */
+
 struct spcr_descriptor {
 	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
 	u8 interface_type;	/* 0=full 16550, 1=subset of 16550 */
@@ -195,5 +257,6 @@ struct acpi_table_gtdt {
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
+void acpi_table_parse_madt(enum acpi_madt_type mtype, acpi_table_handler handler);
 
 #endif
diff --git a/lib/acpi.c b/lib/acpi.c
index aeaccb8..b652d18 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -104,3 +104,24 @@ void *find_acpi_table_addr(u32 sig)
 
 	return NULL;
 }
+
+void acpi_table_parse_madt(enum acpi_madt_type mtype,
+			   acpi_table_handler handler)
+{
+	struct acpi_table_madt *madt;
+	struct acpi_subtable_header *header;
+	void *end;
+
+	madt = find_acpi_table_addr(MADT_SIGNATURE);
+	assert(madt);
+
+	header = (void *)(ulong)madt + sizeof(struct acpi_table_madt);
+	end = (void *)((ulong)madt + madt->length);
+
+	while ((void *)header < end) {
+		if (header->type == mtype)
+			handler(header);
+
+		header = (void *)(ulong)header + header->length;
+	}
+}
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 1572c64..3612991 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <libfdt/libfdt.h>
 #include <devicetree.h>
+#include <acpi.h>
 #include <alloc.h>
 #include <alloc_phys.h>
 #include <alloc_page.h>
@@ -55,7 +56,7 @@ int mpidr_to_cpu(uint64_t mpidr)
 	return -1;
 }
 
-static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
+static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
 {
 	int cpu = nr_cpus++;
 
@@ -65,13 +66,31 @@ static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
 	set_cpu_present(cpu, true);
 }
 
+static int cpu_set_acpi(struct acpi_subtable_header *header)
+{
+	int cpu = nr_cpus++;
+	struct acpi_madt_generic_interrupt *gicc = (void *)header;
+
+	assert_msg(cpu < NR_CPUS, "Number cpus exceeds maximum supported (%d).", NR_CPUS);
+
+	cpus[cpu] = gicc->arm_mpidr;
+	set_cpu_present(cpu, true);
+
+	return 0;
+}
+
 static void cpu_init(void)
 {
 	int ret;
 
 	nr_cpus = 0;
-	ret = dt_for_each_cpu_node(cpu_set, NULL);
-	assert(ret == 0);
+	if (dt_available()) {
+		ret = dt_for_each_cpu_node(cpu_set_fdt, NULL);
+		assert(ret == 0);
+	} else {
+		acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT, cpu_set_acpi);
+	}
+
 	set_cpu_online(0, true);
 }
 
-- 
2.25.1

