Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809271612BA
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 14:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgBQNKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 08:10:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10195 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728115AbgBQNKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 08:10:47 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4FF199DBF10D2DFAE3F1;
        Mon, 17 Feb 2020 21:10:41 +0800 (CST)
Received: from huawei.com (10.151.151.243) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Feb 2020
 21:10:33 +0800
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
Subject: [PATCH v24 06/10] ACPI: Record the Generic Error Status Block address
Date:   Mon, 17 Feb 2020 21:12:44 +0800
Message-ID: <20200217131248.28273-7-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20200217131248.28273-1-gengdongjiu@huawei.com>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.151.151.243]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Record the GHEB address via fw_cfg file, when recording
a error to CPER, it will use this address to find out
Generic Error Data Entries and write the error.

In order to avoid migration failure, make hardware
error table address to a part of GED device instead
of global variable, then this address will be migrated
to target QEMU.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 hw/acpi/generic_event_device.c         | 18 ++++++++++++++++++
 hw/acpi/ghes.c                         | 17 +++++++++++++++++
 hw/arm/virt-acpi-build.c               | 10 ++++++++++
 include/hw/acpi/generic_event_device.h |  2 ++
 include/hw/acpi/ghes.h                 |  6 ++++++
 5 files changed, 53 insertions(+)

diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
index 021ed2b..d59607c 100644
--- a/hw/acpi/generic_event_device.c
+++ b/hw/acpi/generic_event_device.c
@@ -234,6 +234,23 @@ static const VMStateDescription vmstate_ged_state = {
     }
 };
 
+static bool ghes_needed(void *opaque)
+{
+    return object_property_get_bool(qdev_get_machine(), "ras", NULL);
+}
+
+static const VMStateDescription vmstate_ghes_state = {
+    .name = "acpi-ged/ghes",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = ghes_needed,
+    .fields      = (VMStateField[]) {
+        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
+                       vmstate_ghes_state, AcpiGhesState),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static const VMStateDescription vmstate_acpi_ged = {
     .name = "acpi-ged",
     .version_id = 1,
@@ -244,6 +261,7 @@ static const VMStateDescription vmstate_acpi_ged = {
     },
     .subsections = (const VMStateDescription * []) {
         &vmstate_memhp_state,
+        &vmstate_ghes_state,
         NULL
     }
 };
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 7a7381d..cea2bff 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -24,6 +24,8 @@
 #include "hw/acpi/ghes.h"
 #include "hw/acpi/aml-build.h"
 #include "qemu/error-report.h"
+#include "hw/acpi/generic_event_device.h"
+#include "hw/nvram/fw_cfg.h"
 
 #define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
 #define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
@@ -213,3 +215,18 @@ void acpi_build_hest(GArray *table_data, BIOSLinker *linker)
     build_header(linker, table_data, (void *)(table_data->data + hest_start),
         "HEST", table_data->len - hest_start, 1, NULL, "");
 }
+
+void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
+                          GArray *hardware_error)
+{
+    size_t size = 2 * sizeof(uint64_t) + ACPI_GHES_MAX_RAW_DATA_LENGTH;
+    size_t request_block_size = ACPI_GHES_ERROR_SOURCE_COUNT * size;
+
+    /* Create a read-only fw_cfg file for GHES */
+    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
+                    request_block_size);
+
+    /* Create a read-write fw_cfg file for Address */
+    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
+        NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
+}
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 12a9a78..d6e7521 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -832,6 +832,7 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     build_spcr(tables_blob, tables->linker, vms);
 
     if (vms->ras) {
+        assert(vms->acpi_dev);
         acpi_add_table(table_offsets, tables_blob);
         build_ghes_error_table(tables->hardware_errors, tables->linker);
         acpi_build_hest(tables_blob, tables->linker);
@@ -924,6 +925,7 @@ void virt_acpi_setup(VirtMachineState *vms)
 {
     AcpiBuildTables tables;
     AcpiBuildState *build_state;
+    AcpiGedState *acpi_ged_state;
 
     if (!vms->fw_cfg) {
         trace_virt_acpi_setup();
@@ -954,6 +956,14 @@ void virt_acpi_setup(VirtMachineState *vms)
     fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
                     acpi_data_len(tables.tcpalog));
 
+    if (vms->ras) {
+        assert(vms->acpi_dev);
+        acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
+                                                           NULL));
+        acpi_ghes_add_fw_cfg(&acpi_ged_state->ghes_state,
+                             vms->fw_cfg, tables.hardware_errors);
+    }
+
     build_state->rsdp_mr = acpi_add_rom_blob(virt_acpi_build_update,
                                              build_state, tables.rsdp,
                                              ACPI_BUILD_RSDP_FILE, 0);
diff --git a/include/hw/acpi/generic_event_device.h b/include/hw/acpi/generic_event_device.h
index d157eac..037d2b5 100644
--- a/include/hw/acpi/generic_event_device.h
+++ b/include/hw/acpi/generic_event_device.h
@@ -61,6 +61,7 @@
 
 #include "hw/sysbus.h"
 #include "hw/acpi/memory_hotplug.h"
+#include "hw/acpi/ghes.h"
 
 #define ACPI_POWER_BUTTON_DEVICE "PWRB"
 
@@ -95,6 +96,7 @@ typedef struct AcpiGedState {
     GEDState ged_state;
     uint32_t ged_event_bitmap;
     qemu_irq irq;
+    AcpiGhesState ghes_state;
 } AcpiGedState;
 
 void build_ged_aml(Aml *table, const char* name, HotplugHandler *hotplug_dev,
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 18debd8..a3420fc 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -62,6 +62,12 @@ enum {
     ACPI_HEST_SRC_ID_RESERVED,
 };
 
+typedef struct AcpiGhesState {
+    uint64_t ghes_addr_le;
+} AcpiGhesState;
+
 void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
 void acpi_build_hest(GArray *table_data, BIOSLinker *linker);
+void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
+                          GArray *hardware_errors);
 #endif
-- 
1.8.3.1

