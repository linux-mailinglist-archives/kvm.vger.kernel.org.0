Return-Path: <kvm+bounces-37002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F0B7A24211
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 18:43:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4017188ADDF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 17:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B4B1F2383;
	Fri, 31 Jan 2025 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onaBHHrn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0911F1300;
	Fri, 31 Jan 2025 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738345390; cv=none; b=FRueFa9jNEGN7LGELWS15ud4DAFfjmVOwdsQqlRetQLMnE+9ehRU2nAb+CHMdhVPNeYuOGQjYasE473PXnfHYughmszrLmJygcWUejypWdSP9dyAYhg6qpAfOoZ1KwGmIcf+Y58pjJxBGbisHjFQrgsnSpNMbyf8Y4ELptz+IH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738345390; c=relaxed/simple;
	bh=x0uOxxNWsvtIJha7MqKmwihF/O/RS5bBMIi0M93WaHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dQZnNsDPJi6Ex0H5CH2PgUGmHftwOPWYSdJ1WeU9kgfQ/xIA9izboLuyZnssWrN+V/AeVnA/QTYa/ybkF3KyCkye1l83LZh2VIgTLeGpAYsvrVOb5b5OagL8RmjJ160hlGrcsNKt2jBDsjqnX87GWCAzPYAaPc7uZ06JGdDWIO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onaBHHrn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E82C4AF0F;
	Fri, 31 Jan 2025 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738345390;
	bh=x0uOxxNWsvtIJha7MqKmwihF/O/RS5bBMIi0M93WaHg=;
	h=From:To:Cc:Subject:Date:From;
	b=onaBHHrnl9eAHQg6TJoQRme7fnp1+9turwzj+tRqdSciV5MFyoxEns44hB2yv4odM
	 tBupV60NCuaTOH3N1yzJxoNtseVvNTpAe2/aH1Cs2F23Juz16hAy//6cBawLGABNBr
	 mzxTkayHqEyuol0liWr1vZ1dWOWaUb60qbhuGwQ41y1AKzfEef9HiRJ9llbWTuaKTa
	 9IxMuCidsuhYEbVfS6g0/ExI11qHk5L1aRMEdLrbkvZIkQ6T3K1c9HjufGzciWtqV+
	 p1fVG414cJoKsXBB+3g9aNWUUqo1AoLwZv7E4AJ8Glo5U+BbqN64huFJFBystd9hyl
	 BL4m4TP1lJmVA==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1tdv2o-00000006ggf-48pX;
	Fri, 31 Jan 2025 18:43:06 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	John Snow <jsnow@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add support for error inject
Date: Fri, 31 Jan 2025 18:42:41 +0100
Message-ID: <cover.1738345063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Now that the ghes preparation patches were merged, let's add support
for error injection.

On this series, the first 6 patches chang to the math used to calculate offsets at HEST
table and hardware_error firmware file, together with its migration code. Migration tested
with both latest QEMU released kernel and upstream, on both directions.

The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
   to inject ARM Processor Error records.

If I'm counting well, this is the 19th submission of my error inject patches.

---
v3:
- addressed more nits;
- hest_add_le now points to the beginning of HEST table;
- removed HEST from tests/data/acpi;
- added an extra patch to not use fw_cfg with virt-10.0 for hw_error_le

v2: 
- address some nits;
- improved ags cleanup patch and removed ags.present field;
- added some missing le*_to_cpu() calls;
- update date at copyright for new files to 2024-2025;
- qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
- added HEST and DSDT tables after the changes to make check target happy.
  (two patches: first one whitelisting such tables; second one removing from
   whitelist and updating/adding such tables to tests/data/acpi)

It follows a diff against v2 to better show the differences.

diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
index 50313ed7ee96..f5e899155d34 100644
--- a/hw/acpi/generic_event_device.c
+++ b/hw/acpi/generic_event_device.c
@@ -29,12 +29,6 @@ static const uint32_t ged_supported_events[] = {
     ACPI_GED_ERROR_EVT,
 };
 
-/*
- * ACPI 5.0b: 5.6.6 Device Object Notifications
- * Table 5-135 Error Device Notification Values
- */
-#define ERROR_DEVICE_NOTIFICATION   0x80
-
 /*
  * The ACPI Generic Event Device (GED) is a hardware-reduced specific
  * device[ACPI v6.1 Section 5.6.9] that handles all platform events,
@@ -124,9 +118,14 @@ void build_ged_aml(Aml *table, const char *name, HotplugHandler *hotplug_dev,
                                       aml_int(0x80)));
                 break;
             case ACPI_GED_ERROR_EVT:
+                /*
+                 * ACPI 5.0b: 5.6.6 Device Object Notifications
+                 * Table 5-135 Error Device Notification Values
+                 * Defines 0x80 as the value to be used on notifications
+                 */
                 aml_append(if_ctx,
                            aml_notify(aml_name(ACPI_APEI_ERROR_DEVICE),
-                                      aml_int(ERROR_DEVICE_NOTIFICATION)));
+                                      aml_int(0x80)));
                 break;
             case ACPI_GED_NVDIMM_HOTPLUG_EVT:
                 aml_append(if_ctx,
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index ef57ad14a38b..bcef0b22e612 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -41,6 +41,12 @@
 /* Address offset in Generic Address Structure(GAS) */
 #define GAS_ADDR_OFFSET 4
 
+/*
+ * ACPI spec 1.0b
+ * 5.2.3 System Description Table Header
+ */
+#define ACPI_DESC_HEADER_OFFSET     36
+
 /*
  * The total size of Generic Error Data Entry
  * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
@@ -226,8 +232,8 @@ ghes_gen_err_data_uncorrectable_recoverable(GArray *block,
  * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
  * See docs/specs/acpi_hest_ghes.rst for blobs format.
  */
-static void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker,
-                                   int num_sources)
+static void build_ghes_error_table(AcpiGhesState *ags, GArray *hardware_errors,
+                                   BIOSLinker *linker, int num_sources)
 {
     int i, error_status_block_offset;
 
@@ -272,13 +278,15 @@ static void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker,
                                        i * ACPI_GHES_MAX_RAW_DATA_LENGTH);
     }
 
-    /*
-     * Tell firmware to write hardware_errors GPA into
-     * hardware_errors_addr fw_cfg, once the former has been initialized.
-     */
-    bios_linker_loader_write_pointer(linker, ACPI_HW_ERROR_ADDR_FW_CFG_FILE, 0,
-                                     sizeof(uint64_t),
-                                     ACPI_HW_ERROR_FW_CFG_FILE, 0);
+    if (!ags->use_hest_addr) {
+        /*
+         * Tell firmware to write hardware_errors GPA into
+         * hardware_errors_addr fw_cfg, once the former has been initialized.
+         */
+        bios_linker_loader_write_pointer(linker, ACPI_HW_ERROR_ADDR_FW_CFG_FILE,
+                                         0, sizeof(uint64_t),
+                                         ACPI_HW_ERROR_FW_CFG_FILE, 0);
+    }
 }
 
 /* Build Generic Hardware Error Source version 2 (GHESv2) */
@@ -365,11 +373,11 @@ void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
     uint32_t hest_offset;
     int i;
 
-    build_ghes_error_table(hardware_errors, linker, num_sources);
+    hest_offset = table_data->len;
 
-    acpi_table_begin(&table, table_data);
+    build_ghes_error_table(ags, hardware_errors, linker, num_sources);
 
-    hest_offset = table_data->len;
+    acpi_table_begin(&table, table_data);
 
     /* Error Source Count */
     build_append_int_noprefix(table_data, num_sources, 4);
@@ -383,7 +391,6 @@ void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
      * Tell firmware to write into GPA the address of HEST via fw_cfg,
      * once initialized.
      */
-
     if (ags->use_hest_addr) {
         bios_linker_loader_write_pointer(linker,
                                          ACPI_HEST_ADDR_FW_CFG_FILE, 0,
@@ -399,13 +406,13 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
     fw_cfg_add_file(s, ACPI_HW_ERROR_FW_CFG_FILE, hardware_error->data,
                     hardware_error->len);
 
-    /* Create a read-write fw_cfg file for Address */
-    fw_cfg_add_file_callback(s, ACPI_HW_ERROR_ADDR_FW_CFG_FILE, NULL, NULL,
-        NULL, &(ags->hw_error_le), sizeof(ags->hw_error_le), false);
-
     if (ags->use_hest_addr) {
         fw_cfg_add_file_callback(s, ACPI_HEST_ADDR_FW_CFG_FILE, NULL, NULL,
             NULL, &(ags->hest_addr_le), sizeof(ags->hest_addr_le), false);
+    } else {
+        /* Create a read-write fw_cfg file for Address */
+        fw_cfg_add_file_callback(s, ACPI_HW_ERROR_ADDR_FW_CFG_FILE, NULL, NULL,
+            NULL, &(ags->hw_error_le), sizeof(ags->hw_error_le), false);
     }
 }
 
@@ -432,7 +439,7 @@ static void get_hw_error_offsets(uint64_t ghes_addr,
 }
 
 static void get_ghes_source_offsets(uint16_t source_id,
-                                    uint64_t hest_entry_addr,
+                                    uint64_t hest_addr,
                                     uint64_t *cper_addr,
                                     uint64_t *read_ack_start_addr,
                                     Error **errp)
@@ -441,12 +448,13 @@ static void get_ghes_source_offsets(uint16_t source_id,
     uint64_t err_source_entry, error_block_addr;
     uint32_t num_sources, i;
 
+    hest_addr += ACPI_DESC_HEADER_OFFSET;
 
-    cpu_physical_memory_read(hest_entry_addr, &num_sources,
+    cpu_physical_memory_read(hest_addr, &num_sources,
                              sizeof(num_sources));
     num_sources = le32_to_cpu(num_sources);
 
-    err_source_entry = hest_entry_addr + sizeof(num_sources);
+    err_source_entry = hest_addr + sizeof(num_sources);
 
     /*
      * Currently, HEST Error source navigates only for GHESv2 tables
@@ -468,7 +476,6 @@ static void get_ghes_source_offsets(uint16_t source_id,
         /* Compare CPER source address at the GHESv2 structure */
         addr += sizeof(type);
         cpu_physical_memory_read(addr, &src_id, sizeof(src_id));
-
         if (le16_to_cpu(src_id) == source_id) {
             break;
         }
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 7d3580244179..7b6e90d69298 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -956,8 +956,10 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     build_dbg2(tables_blob, tables->linker, vms);
 
     if (vms->ras) {
-        AcpiGhesState *ags;
+        static const AcpiNotificationSourceId *notify;
         AcpiGedState *acpi_ged_state;
+        unsigned int notify_sz;
+        AcpiGhesState *ags;
 
         acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
                                                        NULL));
@@ -967,16 +969,16 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
             acpi_add_table(table_offsets, tables_blob);
 
             if (!ags->use_hest_addr) {
-                acpi_build_hest(ags, tables_blob, tables->hardware_errors,
-                                tables->linker, hest_ghes_notify_9_2,
-                                ARRAY_SIZE(hest_ghes_notify_9_2),
-                                vms->oem_id, vms->oem_table_id);
+                notify = hest_ghes_notify_9_2;
+                notify_sz = ARRAY_SIZE(hest_ghes_notify_9_2);
             } else {
-                acpi_build_hest(ags, tables_blob, tables->hardware_errors,
-                                tables->linker, hest_ghes_notify,
-                                ARRAY_SIZE(hest_ghes_notify),
-                                vms->oem_id, vms->oem_table_id);
+                notify = hest_ghes_notify;
+                notify_sz = ARRAY_SIZE(hest_ghes_notify);
             }
+
+            acpi_build_hest(ags, tables_blob, tables->hardware_errors,
+                            tables->linker, notify, notify_sz,
+                            vms->oem_id, vms->oem_table_id);
         }
     }
 
diff --git a/scripts/arm_processor_error.py b/scripts/arm_processor_error.py
index 4ac04ab08299..b0e8450e667e 100644
--- a/scripts/arm_processor_error.py
+++ b/scripts/arm_processor_error.py
@@ -12,11 +12,110 @@
 #
 #   - ARM registers: power_state, mpidr.
 
+"""
+Generates an ARM processor error CPER, compatible with
+UEFI 2.9A Errata.
+
+Injecting such errors can be done using:
+
+    $ ./scripts/ghes_inject.py arm
+    Error injected.
+
+Produces a simple CPER register, as detected on a Linux guest:
+
+[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
+[Hardware Error]: event severity: recoverable
+[Hardware Error]:  Error 0, type: recoverable
+[Hardware Error]:   section_type: ARM processor error
+[Hardware Error]:   MIDR: 0x0000000000000000
+[Hardware Error]:   running state: 0x0
+[Hardware Error]:   Power State Coordination Interface state: 0
+[Hardware Error]:   Error info structure 0:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x02: cache error
+[Hardware Error]:    error_info: 0x000000000091000f
+[Hardware Error]:     transaction type: Data Access
+[Hardware Error]:     cache error, operation type: Data write
+[Hardware Error]:     cache level: 2
+[Hardware Error]:     processor context not corrupted
+[Firmware Warn]: GHES: Unhandled processor error type 0x02: cache error
+
+The ARM Processor Error message can be customized via command line
+parameters. For instance:
+
+    $ ./scripts/ghes_inject.py arm --mpidr 0x444 --running --affinity 1 \
+        --error-info 12345678 --vendor 0x13,123,4,5,1 --ctx-array 0,1,2,3,4,5 \
+        -t cache tlb bus micro-arch tlb,micro-arch
+    Error injected.
+
+Injects this error, as detected on a Linux guest:
+
+[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
+[Hardware Error]: event severity: recoverable
+[Hardware Error]:  Error 0, type: recoverable
+[Hardware Error]:   section_type: ARM processor error
+[Hardware Error]:   MIDR: 0x0000000000000000
+[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000000000000
+[Hardware Error]:   error affinity level: 0
+[Hardware Error]:   running state: 0x1
+[Hardware Error]:   Power State Coordination Interface state: 0
+[Hardware Error]:   Error info structure 0:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x02: cache error
+[Hardware Error]:    error_info: 0x0000000000bc614e
+[Hardware Error]:     cache level: 2
+[Hardware Error]:     processor context not corrupted
+[Hardware Error]:   Error info structure 1:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x04: TLB error
+[Hardware Error]:    error_info: 0x000000000054007f
+[Hardware Error]:     transaction type: Instruction
+[Hardware Error]:     TLB error, operation type: Instruction fetch
+[Hardware Error]:     TLB level: 1
+[Hardware Error]:     processor context not corrupted
+[Hardware Error]:     the error has not been corrected
+[Hardware Error]:     PC is imprecise
+[Hardware Error]:   Error info structure 2:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x08: bus error
+[Hardware Error]:    error_info: 0x00000080d6460fff
+[Hardware Error]:     transaction type: Generic
+[Hardware Error]:     bus error, operation type: Generic read (type of instruction or data request cannot be determined)
+[Hardware Error]:     affinity level at which the bus error occurred: 1
+[Hardware Error]:     processor context corrupted
+[Hardware Error]:     the error has been corrected
+[Hardware Error]:     PC is imprecise
+[Hardware Error]:     Program execution can be restarted reliably at the PC associated with the error.
+[Hardware Error]:     participation type: Local processor observed
+[Hardware Error]:     request timed out
+[Hardware Error]:     address space: External Memory Access
+[Hardware Error]:     memory access attributes:0x20
+[Hardware Error]:     access mode: secure
+[Hardware Error]:   Error info structure 3:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x10: micro-architectural error
+[Hardware Error]:    error_info: 0x0000000078da03ff
+[Hardware Error]:   Error info structure 4:
+[Hardware Error]:   num errors: 2
+[Hardware Error]:    error_type: 0x14: TLB error|micro-architectural error
+[Hardware Error]:   Context info structure 0:
+[Hardware Error]:    register context type: AArch64 EL1 context registers
+[Hardware Error]:    00000000: 00000000 00000000
+[Hardware Error]:   Vendor specific error info has 5 bytes:
+[Hardware Error]:    00000000: 13 7b 04 05 01                                   .{...
+[Firmware Warn]: GHES: Unhandled processor error type 0x02: cache error
+[Firmware Warn]: GHES: Unhandled processor error type 0x04: TLB error
+[Firmware Warn]: GHES: Unhandled processor error type 0x08: bus error
+[Firmware Warn]: GHES: Unhandled processor error type 0x10: micro-architectural error
+[Firmware Warn]: GHES: Unhandled processor error type 0x14: TLB error|micro-architectural error
+"""
+
 import argparse
 import re
 
 from qmp_helper import qmp, util, cper_guid
 
+
 class ArmProcessorEinj:
     """
     Implements ARM Processor Error injection via GHES
diff --git a/scripts/qmp_helper.py b/scripts/qmp_helper.py
old mode 100644
new mode 100755
index 4f7ebb31b424..8e375d6a6cab
--- a/scripts/qmp_helper.py
+++ b/scripts/qmp_helper.py
@@ -541,7 +541,7 @@ def send_cper_raw(self, cper_data):
 
         self._connect()
 
-        if self.send_cmd("inject-ghes-error", cmd_arg):
+        if self.send_cmd("inject-ghes-v2-error", cmd_arg):
             print("Error injected.")
 
     def send_cper(self, notif_type, payload):
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 544ff174784d..80ca7779797b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2371,7 +2371,6 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
     ags = acpi_ghes_get_state();
-
     if (ags && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
diff --git a/tests/data/acpi/aarch64/virt/HEST b/tests/data/acpi/aarch64/virt/HEST
deleted file mode 100644
index 8b0cf87700fa..000000000000
Binary files a/tests/data/acpi/aarch64/virt/HEST and /dev/null differ

-

Mauro Carvalho Chehab (14):
  acpi/ghes: Prepare to support multiple sources on ghes
  acpi/ghes: add a firmware file with HEST address
  acpi/ghes: Use HEST table offsets when preparing GHES records
  acpi/generic_event_device: Update GHES migration to cover hest addr
  acpi/generic_event_device: add logic to detect if HEST addr is
    available
  acpi/ghes: only set hw_error_le or hest_addr_le
  acpi/ghes: add a notifier to notify when error data is ready
  acpi/ghes: Cleanup the code which gets ghes ged state
  acpi/generic_event_device: add an APEI error device
  tests/acpi: virt: allow acpi table changes for a new table: HEST
  arm/virt: Wire up a GED error device for ACPI / GHES
  tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
  qapi/acpi-hest: add an interface to do generic CPER error injection
  scripts/ghes_inject: add a script to generate GHES error inject

 MAINTAINERS                                   |  10 +
 hw/acpi/Kconfig                               |   5 +
 hw/acpi/aml-build.c                           |  10 +
 hw/acpi/generic_event_device.c                |  43 ++
 hw/acpi/ghes-stub.c                           |   7 +-
 hw/acpi/ghes.c                                | 231 ++++--
 hw/acpi/ghes_cper.c                           |  38 +
 hw/acpi/ghes_cper_stub.c                      |  19 +
 hw/acpi/meson.build                           |   2 +
 hw/arm/virt-acpi-build.c                      |  37 +-
 hw/arm/virt.c                                 |  19 +-
 hw/core/machine.c                             |   2 +
 include/hw/acpi/acpi_dev_interface.h          |   1 +
 include/hw/acpi/aml-build.h                   |   2 +
 include/hw/acpi/generic_event_device.h        |   1 +
 include/hw/acpi/ghes.h                        |  45 +-
 include/hw/arm/virt.h                         |   2 +
 qapi/acpi-hest.json                           |  35 +
 qapi/meson.build                              |   1 +
 qapi/qapi-schema.json                         |   1 +
 scripts/arm_processor_error.py                | 476 ++++++++++++
 scripts/ghes_inject.py                        |  51 ++
 scripts/qmp_helper.py                         | 702 ++++++++++++++++++
 target/arm/kvm.c                              |   7 +-
 tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
 .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
 tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
 tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
 tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
 29 files changed, 1666 insertions(+), 81 deletions(-)
 create mode 100644 hw/acpi/ghes_cper.c
 create mode 100644 hw/acpi/ghes_cper_stub.c
 create mode 100644 qapi/acpi-hest.json
 create mode 100644 scripts/arm_processor_error.py
 create mode 100755 scripts/ghes_inject.py
 create mode 100755 scripts/qmp_helper.py

-- 
2.48.1



