Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E531CA0A2
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 04:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgEHCRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 22:17:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4345 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726951AbgEHCRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 22:17:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5B82A961C24D09A27C0F;
        Fri,  8 May 2020 10:17:46 +0800 (CST)
Received: from huawei.com (10.151.151.243) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 8 May 2020
 10:17:38 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <imammedo@redhat.com>, <mst@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <peter.maydell@linaro.org>,
        <shannon.zhaosl@gmail.com>, <pbonzini@redhat.com>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
CC:     <gengdongjiu@huawei.com>, <zhengxiang9@huawei.com>,
        <Jonathan.Cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [PATCH RESEND v26 04/10] ACPI: Build related register address fields via hardware error fw_cfg blob
Date:   Fri, 8 May 2020 10:19:24 +0800
Message-ID: <20200508021930.37955-5-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200508021930.37955-1-gengdongjiu@huawei.com>
References: <20200508021930.37955-1-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.151.151.243]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch builds error_block_address and read_ack_register fields
in hardware errors table , the error_block_address points to Generic
Error Status Block(GESB) via bios_linker. The max size for one GESB
is 1kb, For more detailed information, please refer to
document: docs/specs/acpi_hest_ghes.rst

Now we only support one Error source, if necessary, we can extend to
support more.

Suggested-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
---
 default-configs/arm-softmmu.mak |  1 +
 hw/acpi/Kconfig                 |  4 ++
 hw/acpi/Makefile.objs           |  1 +
 hw/acpi/aml-build.c             |  2 +
 hw/acpi/ghes.c                  | 89 +++++++++++++++++++++++++++++++++++++++++
 hw/arm/virt-acpi-build.c        |  5 +++
 include/hw/acpi/aml-build.h     |  1 +
 include/hw/acpi/ghes.h          | 28 +++++++++++++
 8 files changed, 131 insertions(+)
 create mode 100644 hw/acpi/ghes.c
 create mode 100644 include/hw/acpi/ghes.h

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 36a0e89..8fc09a4 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -42,3 +42,4 @@ CONFIG_FSL_IMX7=y
 CONFIG_FSL_IMX6UL=y
 CONFIG_SEMIHOSTING=y
 CONFIG_ALLWINNER_H3=y
+CONFIG_ACPI_APEI=y
diff --git a/hw/acpi/Kconfig b/hw/acpi/Kconfig
index 54209c6..1932f66 100644
--- a/hw/acpi/Kconfig
+++ b/hw/acpi/Kconfig
@@ -28,6 +28,10 @@ config ACPI_HMAT
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
index cab9bcd..72886c7 100644
--- a/hw/acpi/Makefile.objs
+++ b/hw/acpi/Makefile.objs
@@ -8,6 +8,7 @@ common-obj-$(CONFIG_ACPI_NVDIMM) += nvdimm.o
 common-obj-$(CONFIG_ACPI_VMGENID) += vmgenid.o
 common-obj-$(CONFIG_ACPI_HW_REDUCED) += generic_event_device.o
 common-obj-$(CONFIG_ACPI_HMAT) += hmat.o
+common-obj-$(CONFIG_ACPI_APEI) += ghes.o
 common-obj-$(call lnot,$(CONFIG_ACPI_X86)) += acpi-stub.o
 common-obj-$(call lnot,$(CONFIG_PC)) += acpi-x86-stub.o
 
diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 2c3702b..3681ec6 100644
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
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
new file mode 100644
index 0000000..e1b3f8f
--- /dev/null
+++ b/hw/acpi/ghes.c
@@ -0,0 +1,89 @@
+/*
+ * Support for generating APEI tables and recording CPER for Guests
+ *
+ * Copyright (c) 2020 HUAWEI TECHNOLOGIES CO., LTD.
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
+#include "qemu/units.h"
+#include "hw/acpi/ghes.h"
+#include "hw/acpi/aml-build.h"
+
+#define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
+#define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
+
+/* The max size in bytes for one error block */
+#define ACPI_GHES_MAX_RAW_DATA_LENGTH   (1 * KiB)
+
+/* Now only support ARMv8 SEA notification type error source */
+#define ACPI_GHES_ERROR_SOURCE_COUNT        1
+
+/*
+ * Build table for the hardware error fw_cfg blob.
+ * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
+ * See docs/specs/acpi_hest_ghes.rst for blobs format.
+ */
+void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
+{
+    int i, error_status_block_offset;
+
+    /* Build error_block_address */
+    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+        build_append_int_noprefix(hardware_errors, 0, sizeof(uint64_t));
+    }
+
+    /* Build read_ack_register */
+    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+        /*
+         * Initialize the value of read_ack_register to 1, so GHES can be
+         * writeable after (re)boot.
+         * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
+         * (GHESv2 - Type 10)
+         */
+        build_append_int_noprefix(hardware_errors, 1, sizeof(uint64_t));
+    }
+
+    /* Generic Error Status Block offset in the hardware error fw_cfg blob */
+    error_status_block_offset = hardware_errors->len;
+
+    /* Reserve space for Error Status Data Block */
+    acpi_data_push(hardware_errors,
+        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
+
+    /* Tell guest firmware to place hardware_errors blob into RAM */
+    bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
+                             hardware_errors, sizeof(uint64_t), false);
+
+    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+        /*
+         * Tell firmware to patch error_block_address entries to point to
+         * corresponding "Generic Error Status Block"
+         */
+        bios_linker_loader_add_pointer(linker,
+            ACPI_GHES_ERRORS_FW_CFG_FILE, sizeof(uint64_t) * i,
+            sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
+            error_status_block_offset + i * ACPI_GHES_MAX_RAW_DATA_LENGTH);
+    }
+
+    /*
+     * tell firmware to write hardware_errors GPA into
+     * hardware_errors_addr fw_cfg, once the former has been initialized.
+     */
+    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
+        0, sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
+}
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index f22b1e6..8397bda 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -49,6 +49,7 @@
 #include "sysemu/reset.h"
 #include "kvm_arm.h"
 #include "migration/vmstate.h"
+#include "hw/acpi/ghes.h"
 
 #define ARM_SPI_BASE 32
 
@@ -818,6 +819,10 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_spcr(tables_blob, tables->linker, vms);
 
+    if (vms->ras) {
+        build_ghes_error_table(tables->hardware_errors, tables->linker);
+    }
+
     if (ms->numa_state->num_nodes > 0) {
         acpi_add_table(table_offsets, tables_blob);
         build_srat(tables_blob, tables->linker, vms);
diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
index 1539fe0..ed7c893 100644
--- a/include/hw/acpi/aml-build.h
+++ b/include/hw/acpi/aml-build.h
@@ -220,6 +220,7 @@ struct AcpiBuildTables {
     GArray *rsdp;
     GArray *tcpalog;
     GArray *vmgenid;
+    GArray *hardware_errors;
     BIOSLinker *linker;
 } AcpiBuildTables;
 
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
new file mode 100644
index 0000000..50379b0
--- /dev/null
+++ b/include/hw/acpi/ghes.h
@@ -0,0 +1,28 @@
+/*
+ * Support for generating APEI tables and recording CPER for Guests
+ *
+ * Copyright (c) 2020 HUAWEI TECHNOLOGIES CO., LTD.
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
+void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
+#endif
-- 
1.8.3.1

