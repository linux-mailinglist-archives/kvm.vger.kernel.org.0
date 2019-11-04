Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D09EDFCD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 13:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfKDMQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 07:16:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:5701 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728504AbfKDMQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 07:16:34 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 983B1F11F94F384B65E4;
        Mon,  4 Nov 2019 20:16:30 +0800 (CST)
Received: from HGHY4Z004218071.china.huawei.com (10.133.224.57) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 4 Nov 2019 20:16:23 +0800
From:   Xiang Zheng <zhengxiang9@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>
CC:     <zhengxiang9@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: [PATCH v21 3/6] ACPI: Add APEI GHES table generation support
Date:   Mon, 4 Nov 2019 20:14:55 +0800
Message-ID: <20191104121458.29208-4-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
In-Reply-To: <20191104121458.29208-1-zhengxiang9@huawei.com>
References: <20191104121458.29208-1-zhengxiang9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongjiu Geng <gengdongjiu@huawei.com>

This patch implements APEI GHES Table generation via fw_cfg blobs. Now
it only supports ARMv8 SEA, a type of GHESv2 error source. Afterwards,
we can extend the supported types if needed. For the CPER section,
currently it is memory section because kernel mainly wants userspace to
handle the memory errors.

This patch follows the spec ACPI 6.2 to build the Hardware Error Source
table. For more detailed information, please refer to document:
docs/specs/acpi_hest_ghes.rst

Suggested-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 default-configs/arm-softmmu.mak |   1 +
 hw/acpi/Kconfig                 |   4 +
 hw/acpi/Makefile.objs           |   1 +
 hw/acpi/acpi_ghes.c             | 267 ++++++++++++++++++++++++++++++++
 hw/acpi/aml-build.c             |   2 +
 hw/arm/virt-acpi-build.c        |  12 ++
 include/hw/acpi/acpi_ghes.h     |  56 +++++++
 include/hw/acpi/aml-build.h     |   1 +
 8 files changed, 344 insertions(+)
 create mode 100644 hw/acpi/acpi_ghes.c
 create mode 100644 include/hw/acpi/acpi_ghes.h

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 1f2e0e7fde..5722f3130e 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -40,3 +40,4 @@ CONFIG_FSL_IMX25=y
 CONFIG_FSL_IMX7=y
 CONFIG_FSL_IMX6UL=y
 CONFIG_SEMIHOSTING=y
+CONFIG_ACPI_APEI=y
diff --git a/hw/acpi/Kconfig b/hw/acpi/Kconfig
index 12e3f1e86e..ed8c34d238 100644
--- a/hw/acpi/Kconfig
+++ b/hw/acpi/Kconfig
@@ -23,6 +23,10 @@ config ACPI_NVDIMM
     bool
     depends on ACPI
 
+config ACPI_APEI
+    bool
+    depends on ACPI
+
 config ACPI_PCI
     bool
     depends on ACPI && PCI
diff --git a/hw/acpi/Makefile.objs b/hw/acpi/Makefile.objs
index 655a9c1973..84474b0ca8 100644
--- a/hw/acpi/Makefile.objs
+++ b/hw/acpi/Makefile.objs
@@ -5,6 +5,7 @@ common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) += cpu_hotplug.o
 common-obj-$(CONFIG_ACPI_MEMORY_HOTPLUG) += memory_hotplug.o
 common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) += cpu.o
 common-obj-$(CONFIG_ACPI_NVDIMM) += nvdimm.o
+common-obj-$(CONFIG_ACPI_APEI) += acpi_ghes.o
 common-obj-$(CONFIG_ACPI_VMGENID) += vmgenid.o
 common-obj-$(CONFIG_ACPI_HW_REDUCED) += generic_event_device.o
 common-obj-$(call lnot,$(CONFIG_ACPI_X86)) += acpi-stub.o
diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
new file mode 100644
index 0000000000..42c00ff3d3
--- /dev/null
+++ b/hw/acpi/acpi_ghes.c
@@ -0,0 +1,267 @@
+/*
+ * Support for generating APEI tables and recording CPER for Guests
+ *
+ * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
+ *
+ * Author: Dongjiu Geng <gengdongjiu@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/acpi/acpi.h"
+#include "hw/acpi/aml-build.h"
+#include "hw/acpi/acpi_ghes.h"
+#include "hw/nvram/fw_cfg.h"
+#include "sysemu/sysemu.h"
+#include "qemu/error-report.h"
+
+#define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
+#define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
+
+/*
+ * The size of Address field in Generic Address Structure.
+ * ACPI 2.0/3.0: 5.2.3.1 Generic Address Structure.
+ */
+#define ACPI_GHES_ADDRESS_SIZE              8
+
+/* The max size in bytes for one error block */
+#define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
+
+/*
+ * Now only support ARMv8 SEA notification type error source
+ */
+#define ACPI_GHES_ERROR_SOURCE_COUNT        1
+
+/*
+ * Generic Hardware Error Source version 2
+ */
+#define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
+
+/*
+ * | +--------------------------+ 0
+ * | |        Header            |
+ * | +--------------------------+ 40---+-
+ * | | .................        |      |
+ * | | error_status_address-----+ 60   |
+ * | | .................        |      |
+ * | | read_ack_register--------+ 104  92
+ * | | read_ack_preserve        |      |
+ * | | read_ack_write           |      |
+ * + +--------------------------+ 132--+-
+ *
+ * From above GHES definition, the error status address offset is 60;
+ * the Read Ack Register offset is 104, the whole size of GHESv2 is 92
+ */
+
+/* The error status address offset in GHES */
+#define ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(start_addr, n) (start_addr + \
+            60 + offsetof(struct AcpiGenericAddress, address) + n * 92)
+
+/* The Read Ack Register offset in GHES */
+#define ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(start_addr, n) (start_addr +\
+            104 + offsetof(struct AcpiGenericAddress, address) + n * 92)
+
+typedef struct AcpiGhesState {
+    uint64_t ghes_addr_le;
+} AcpiGhesState;
+
+/*
+ * Hardware Error Notification
+ * ACPI 4.0: 17.3.2.7 Hardware Error Notification
+ */
+static void acpi_ghes_build_notify(GArray *table, const uint8_t type)
+{
+        /* Type */
+        build_append_int_noprefix(table, type, 1);
+        /*
+         * Length:
+         * Total length of the structure in bytes
+         */
+        build_append_int_noprefix(table, 28, 1);
+        /* Configuration Write Enable */
+        build_append_int_noprefix(table, 0, 2);
+        /* Poll Interval */
+        build_append_int_noprefix(table, 0, 4);
+        /* Vector */
+        build_append_int_noprefix(table, 0, 4);
+        /* Switch To Polling Threshold Value */
+        build_append_int_noprefix(table, 0, 4);
+        /* Switch To Polling Threshold Window */
+        build_append_int_noprefix(table, 0, 4);
+        /* Error Threshold Value */
+        build_append_int_noprefix(table, 0, 4);
+        /* Error Threshold Window */
+        build_append_int_noprefix(table, 0, 4);
+}
+
+/* Build table for the hardware error fw_cfg blob */
+void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker)
+{
+    int i, error_status_block_offset;
+
+    /*
+     * | +--------------------------+
+     * | |    error_block_address   |
+     * | |      ..........          |
+     * | +--------------------------+
+     * | |    read_ack_register     |
+     * | |     ...........          |
+     * | +--------------------------+
+     * | |  Error Status Data Block |
+     * | |      ........            |
+     * | +--------------------------+
+     */
+
+    /* Build error_block_address */
+    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+        build_append_int_noprefix(hardware_errors, 0, ACPI_GHES_ADDRESS_SIZE);
+    }
+
+    /* Build read_ack_register */
+    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+        /*
+         * Initialize the value of read_ack_register to 1, so GHES can be
+         * writeable in the first time.
+         * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
+         * (GHESv2 - Type 10)
+         */
+        build_append_int_noprefix(hardware_errors, 1, ACPI_GHES_ADDRESS_SIZE);
+    }
+
+    /* Generic Error Status Block offset in the hardware error fw_cfg blob */
+    error_status_block_offset = hardware_errors->len;
+
+    /* Build Error Status Data Block */
+    build_append_int_noprefix(hardware_errors, 0,
+        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
+
+    /* Allocate guest memory for the hardware error fw_cfg blob */
+    bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
+                             hardware_errors, 1, false);
+
+    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+        /*
+         * Patch the address of Error Status Data Block into
+         * the error_block_address of hardware_errors fw_cfg blob
+         */
+        bios_linker_loader_add_pointer(linker,
+            ACPI_GHES_ERRORS_FW_CFG_FILE, ACPI_GHES_ADDRESS_SIZE * i,
+            ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
+            error_status_block_offset + i * ACPI_GHES_MAX_RAW_DATA_LENGTH);
+    }
+
+    /*
+     * Write the address of hardware_errors fw_cfg blob into the
+     * hardware_errors_addr fw_cfg blob.
+     */
+    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
+        0, ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
+}
+
+/* Build Hardware Error Source Table */
+void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_errors,
+                          BIOSLinker *linker)
+{
+    uint32_t hest_start = table_data->len;
+    uint32_t source_id = 0;
+
+    /* Hardware Error Source Table header*/
+    acpi_data_push(table_data, sizeof(AcpiTableHeader));
+
+    /* Error Source Count */
+    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, 4);
+
+    /*
+     * Type:
+     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
+     */
+    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ERROR_V2, 2);
+    /*
+     * Source Id
+     * Once we support more than one hardware error sources, we need to
+     * increase the value of this field.
+     */
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
+    /* Error Status Address */
+    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
+                     4 /* QWord access */, 0);
+    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
+        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
+        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
+        source_id * ACPI_GHES_ADDRESS_SIZE);
+
+    /*
+     * Notification Structure
+     * Now only enable ARMv8 SEA notification type
+     */
+    acpi_ghes_build_notify(table_data, ACPI_GHES_NOTIFY_SEA);
+
+    /* Error Status Block Length */
+    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
+
+    /*
+     * Read Ack Register
+     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
+     * version 2 (GHESv2 - Type 10)
+     */
+    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
+                     4 /* QWord access */, 0);
+    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
+        ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(hest_start, 0),
+        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
+        (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * ACPI_GHES_ADDRESS_SIZE);
+
+    /*
+     * Read Ack Preserve
+     * We only provide the first bit in Read Ack Register to OSPM to write
+     * while the other bits are preserved.
+     */
+    build_append_int_noprefix(table_data, ~0x1ULL, 8);
+    /* Read Ack Write */
+    build_append_int_noprefix(table_data, 0x1, 8);
+
+    build_header(linker, table_data, (void *)(table_data->data + hest_start),
+        "HEST", table_data->len - hest_start, 1, NULL, "GHES");
+}
+
+static AcpiGhesState ges;
+void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
+{
+
+    size_t size = 2 * ACPI_GHES_ADDRESS_SIZE + ACPI_GHES_MAX_RAW_DATA_LENGTH;
+    size_t request_block_size = ACPI_GHES_ERROR_SOURCE_COUNT * size;
+
+    /* Create a read-only fw_cfg file for GHES */
+    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
+                    request_block_size);
+
+    /* Create a read-write fw_cfg file for Address */
+    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
+        NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
+}
diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 2c3702b882..3681ec6e3d 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -1578,6 +1578,7 @@ void acpi_build_tables_init(AcpiBuildTables *tables)
     tables->table_data = g_array_new(false, true /* clear */, 1);
     tables->tcpalog = g_array_new(false, true /* clear */, 1);
     tables->vmgenid = g_array_new(false, true /* clear */, 1);
+    tables->hardware_errors = g_array_new(false, true /* clear */, 1);
     tables->linker = bios_linker_loader_init();
 }
 
@@ -1588,6 +1589,7 @@ void acpi_build_tables_cleanup(AcpiBuildTables *tables, bool mfre)
     g_array_free(tables->table_data, true);
     g_array_free(tables->tcpalog, mfre);
     g_array_free(tables->vmgenid, mfre);
+    g_array_free(tables->hardware_errors, mfre);
 }
 
 /*
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 4cd50175e0..1b1fd273e4 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -48,6 +48,7 @@
 #include "sysemu/reset.h"
 #include "kvm_arm.h"
 #include "migration/vmstate.h"
+#include "hw/acpi/acpi_ghes.h"
 
 #define ARM_SPI_BASE 32
 
@@ -825,6 +826,13 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_spcr(tables_blob, tables->linker, vms);
 
+    if (vms->ras) {
+        acpi_add_table(table_offsets, tables_blob);
+        acpi_ghes_build_error_table(tables->hardware_errors, tables->linker);
+        acpi_ghes_build_hest(tables_blob, tables->hardware_errors,
+                             tables->linker);
+    }
+
     if (ms->numa_state->num_nodes > 0) {
         acpi_add_table(table_offsets, tables_blob);
         build_srat(tables_blob, tables->linker, vms);
@@ -942,6 +950,10 @@ void virt_acpi_setup(VirtMachineState *vms)
     fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
                     acpi_data_len(tables.tcpalog));
 
+    if (vms->ras) {
+        acpi_ghes_add_fw_cfg(vms->fw_cfg, tables.hardware_errors);
+    }
+
     build_state->rsdp_mr = acpi_add_rom_blob(virt_acpi_build_update,
                                              build_state, tables.rsdp,
                                              ACPI_BUILD_RSDP_FILE, 0);
diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
new file mode 100644
index 0000000000..cb62ec9c7b
--- /dev/null
+++ b/include/hw/acpi/acpi_ghes.h
@@ -0,0 +1,56 @@
+/*
+ * Support for generating APEI tables and recording CPER for Guests
+ *
+ * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
+ *
+ * Author: Dongjiu Geng <gengdongjiu@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef ACPI_GHES_H
+#define ACPI_GHES_H
+
+#include "hw/acpi/bios-linker-loader.h"
+
+/*
+ * Values for Hardware Error Notification Type field
+ */
+enum AcpiGhesNotifyType {
+    ACPI_GHES_NOTIFY_POLLED = 0,    /* Polled */
+    ACPI_GHES_NOTIFY_EXTERNAL = 1,  /* External Interrupt */
+    ACPI_GHES_NOTIFY_LOCAL = 2, /* Local Interrupt */
+    ACPI_GHES_NOTIFY_SCI = 3,   /* SCI */
+    ACPI_GHES_NOTIFY_NMI = 4,   /* NMI */
+    ACPI_GHES_NOTIFY_CMCI = 5,  /* CMCI, ACPI 5.0: 18.3.2.7, Table 18-290 */
+    ACPI_GHES_NOTIFY_MCE = 6,   /* MCE, ACPI 5.0: 18.3.2.7, Table 18-290 */
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
+    ACPI_GHES_NOTIFY_RESERVED = 12 /* 12 and greater are reserved */
+};
+
+void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
+                          BIOSLinker *linker);
+
+void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker);
+void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
+#endif
diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
index de4a406568..8f13620701 100644
--- a/include/hw/acpi/aml-build.h
+++ b/include/hw/acpi/aml-build.h
@@ -220,6 +220,7 @@ struct AcpiBuildTables {
     GArray *rsdp;
     GArray *tcpalog;
     GArray *vmgenid;
+    GArray *hardware_errors;
     BIOSLinker *linker;
 } AcpiBuildTables;
 
-- 
2.19.1


