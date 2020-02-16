Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44B160363
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2020 11:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBPKWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 05:22:01 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726256AbgBPKWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 05:22:00 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1B47686BBEC71731ADE3;
        Sun, 16 Feb 2020 18:21:57 +0800 (CST)
Received: from huawei.com (10.151.151.243) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Sun, 16 Feb 2020
 18:21:49 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <mst@redhat.com>, <imammedo@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <shannon.zhaosl@gmail.com>,
        <peter.maydell@linaro.org>, <fam@euphon.net>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <mtosatti@redhat.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <pbonzini@redhat.com>,
        <james.morse@arm.com>, <lersek@redhat.com>,
        <jonathan.cameron@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>
CC:     <gengdongjiu@huawei.com>, <zhengxiang9@huawei.com>
Subject: [PATCH v23 4/9] ACPI: Build Hardware Error Source Table
Date:   Sun, 16 Feb 2020 18:24:03 +0800
Message-ID: <20200216102408.22987-6-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20200216102408.22987-1-gengdongjiu@huawei.com>
References: <20200216102408.22987-1-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.151.151.243]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch builds Hardware Error Source Table(HEST) via fw_cfg blobs.
Now it only supports ARMv8 SEA, a type of Generic Hardware Error
Source version 2(GHESv2) error source. Afterwards, we can extend
the supported types if needed. For the CPER section, currently it
is memory section because kernel mainly wants userspace to handle
the memory errors.

This patch follows the spec ACPI 6.2 to build the Hardware Error
Source table. For more detailed information, please refer to
document: docs/specs/acpi_hest_ghes.rst

build_ghes_hw_error_notification() helper will help to add Hardware
Error Notification to ACPI tables without using packed C structures
and avoid endianness issues as API doesn't need explicit conversion.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 hw/acpi/ghes.c           | 126 +++++++++++++++++++++++++++++++++++++++++++++++
 hw/arm/virt-acpi-build.c |   1 +
 include/hw/acpi/ghes.h   |  39 +++++++++++++++
 3 files changed, 166 insertions(+)

diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index e1b3f8f..7a7381d 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -23,6 +23,7 @@
 #include "qemu/units.h"
 #include "hw/acpi/ghes.h"
 #include "hw/acpi/aml-build.h"
+#include "qemu/error-report.h"
 
 #define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
 #define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
@@ -33,6 +34,42 @@
 /* Now only support ARMv8 SEA notification type error source */
 #define ACPI_GHES_ERROR_SOURCE_COUNT        1
 
+/* Generic Hardware Error Source version 2 */
+#define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
+
+/* Address offset in Generic Address Structure(GAS) */
+#define GAS_ADDR_OFFSET 4
+
+/*
+ * Hardware Error Notification
+ * ACPI 4.0: 17.3.2.7 Hardware Error Notification
+ * Composes dummy Hardware Error Notification descriptor of specified type
+ */
+static void build_ghes_hw_error_notification(GArray *table, const uint8_t type)
+{
+    /* Type */
+    build_append_int_noprefix(table, type, 1);
+    /*
+     * Length:
+     * Total length of the structure in bytes
+     */
+    build_append_int_noprefix(table, 28, 1);
+    /* Configuration Write Enable */
+    build_append_int_noprefix(table, 0, 2);
+    /* Poll Interval */
+    build_append_int_noprefix(table, 0, 4);
+    /* Vector */
+    build_append_int_noprefix(table, 0, 4);
+    /* Switch To Polling Threshold Value */
+    build_append_int_noprefix(table, 0, 4);
+    /* Switch To Polling Threshold Window */
+    build_append_int_noprefix(table, 0, 4);
+    /* Error Threshold Value */
+    build_append_int_noprefix(table, 0, 4);
+    /* Error Threshold Window */
+    build_append_int_noprefix(table, 0, 4);
+}
+
 /*
  * Build table for the hardware error fw_cfg blob.
  * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
@@ -87,3 +124,92 @@ void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
     bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
         0, sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
 }
+
+/* Build Generic Hardware Error Source version 2 (GHESv2) */
+static void build_ghes_v2(GArray *table_data, int source_id, BIOSLinker *linker)
+{
+    uint64_t address_offset;
+    /*
+     * Type:
+     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
+     */
+    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ERROR_V2, 2);
+    /* Source Id */
+    build_append_int_noprefix(table_data, source_id, 2);
+    /* Related Source Id */
+    build_append_int_noprefix(table_data, 0xffff, 2);
+    /* Flags */
+    build_append_int_noprefix(table_data, 0, 1);
+    /* Enabled */
+    build_append_int_noprefix(table_data, 1, 1);
+
+    /* Number of Records To Pre-allocate */
+    build_append_int_noprefix(table_data, 1, 4);
+    /* Max Sections Per Record */
+    build_append_int_noprefix(table_data, 1, 4);
+    /* Max Raw Data Length */
+    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
+
+    address_offset = table_data->len;
+    /* Error Status Address */
+    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
+                     4 /* QWord access */, 0);
+    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
+        address_offset + GAS_ADDR_OFFSET, sizeof(uint64_t),
+        ACPI_GHES_ERRORS_FW_CFG_FILE, source_id * sizeof(uint64_t));
+
+    switch (source_id) {
+    case ACPI_HEST_SRC_ID_SEA:
+        /*
+         * Notification Structure
+         * Now only enable ARMv8 SEA notification type
+         */
+        build_ghes_hw_error_notification(table_data, ACPI_GHES_NOTIFY_SEA);
+        break;
+    default:
+        error_report("Not support this error source");
+        abort();
+    }
+
+    /* Error Status Block Length */
+    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
+
+    /*
+     * Read Ack Register
+     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
+     * version 2 (GHESv2 - Type 10)
+     */
+    address_offset = table_data->len;
+    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
+                     4 /* QWord access */, 0);
+    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
+        address_offset + GAS_ADDR_OFFSET,
+        sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
+        (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * sizeof(uint64_t));
+
+    /*
+     * Read Ack Preserve field
+     * We only provide the first bit in Read Ack Register to OSPM to write
+     * while the other bits are preserved.
+     */
+    build_append_int_noprefix(table_data, ~0x1ULL, 8);
+    /* Read Ack Write */
+    build_append_int_noprefix(table_data, 0x1, 8);
+}
+
+/* Build Hardware Error Source Table */
+void acpi_build_hest(GArray *table_data, BIOSLinker *linker)
+{
+    uint64_t hest_start = table_data->len;
+
+    /* Hardware Error Source Table header*/
+    acpi_data_push(table_data, sizeof(AcpiTableHeader));
+
+    /* Error Source Count */
+    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, 4);
+
+    build_ghes_v2(table_data, ACPI_HEST_SRC_ID_SEA, linker);
+
+    build_header(linker, table_data, (void *)(table_data->data + hest_start),
+        "HEST", table_data->len - hest_start, 1, NULL, "");
+}
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 6819fcf..12a9a78 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -834,6 +834,7 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     if (vms->ras) {
         acpi_add_table(table_offsets, tables_blob);
         build_ghes_error_table(tables->hardware_errors, tables->linker);
+        acpi_build_hest(tables_blob, tables->linker);
     }
 
     if (ms->numa_state->num_nodes > 0) {
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 50379b0..18debd8 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -24,5 +24,44 @@
 
 #include "hw/acpi/bios-linker-loader.h"
 
+/*
+ * Values for Hardware Error Notification Type field
+ */
+enum AcpiGhesNotifyType {
+    /* Polled */
+    ACPI_GHES_NOTIFY_POLLED = 0,
+    /* External Interrupt */
+    ACPI_GHES_NOTIFY_EXTERNAL = 1,
+    /* Local Interrupt */
+    ACPI_GHES_NOTIFY_LOCAL = 2,
+    /* SCI */
+    ACPI_GHES_NOTIFY_SCI = 3,
+    /* NMI */
+    ACPI_GHES_NOTIFY_NMI = 4,
+    /* CMCI, ACPI 5.0: 18.3.2.7, Table 18-290 */
+    ACPI_GHES_NOTIFY_CMCI = 5,
+    /* MCE, ACPI 5.0: 18.3.2.7, Table 18-290 */
+    ACPI_GHES_NOTIFY_MCE = 6,
+    /* GPIO-Signal, ACPI 6.0: 18.3.2.7, Table 18-332 */
+    ACPI_GHES_NOTIFY_GPIO = 7,
+    /* ARMv8 SEA, ACPI 6.1: 18.3.2.9, Table 18-345 */
+    ACPI_GHES_NOTIFY_SEA = 8,
+    /* ARMv8 SEI, ACPI 6.1: 18.3.2.9, Table 18-345 */
+    ACPI_GHES_NOTIFY_SEI = 9,
+    /* External Interrupt - GSIV, ACPI 6.1: 18.3.2.9, Table 18-345 */
+    ACPI_GHES_NOTIFY_GSIV = 10,
+    /* Software Delegated Exception, ACPI 6.2: 18.3.2.9, Table 18-383 */
+    ACPI_GHES_NOTIFY_SDEI = 11,
+    /* 12 and greater are reserved */
+    ACPI_GHES_NOTIFY_RESERVED = 12
+};
+
+enum {
+    ACPI_HEST_SRC_ID_SEA = 0,
+    /* future ids go here */
+    ACPI_HEST_SRC_ID_RESERVED,
+};
+
 void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
+void acpi_build_hest(GArray *table_data, BIOSLinker *linker);
 #endif
-- 
1.8.3.1

