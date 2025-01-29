Return-Path: <kvm+bounces-36822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E40A3A21880
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 09:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2F04188912B
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 08:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C36219F104;
	Wed, 29 Jan 2025 08:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5SCrPjl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3E019ABAC;
	Wed, 29 Jan 2025 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738137867; cv=none; b=msQyBMpxiKAjdWI/H0uE5N7Q/kMC6vMvkCVGW512pc1rmqDl89BVxtxhwaeE2cstREPXldCvvnLwlPvUXFEg4lSPJAlQ53gJN/DR7VnhWz64EZYMLqBU++Sx4SXSd02hflX103EJCm/qz+o6/y7UpeK209HCdfDC7hVqeB8KY0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738137867; c=relaxed/simple;
	bh=Cq/ifN6qPFjI9iVcOdcUN7voJgWfTzlDgfjk+/3U7k8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rfpknj5a5Y5aPMYx6QNdinMFug1LWYA1ytNTEr7gGYQeUJBxDYrNki3hyUh8Dj/evRP9qs/zuC4QHq0c3ncfKN4NjXs6Un6NX6Wr4kdcxNLFmjoi6nHWbma4ExpYHeRuc/Nlvj05+4s0XY3vy1BzZn6z1BkBl1mSOC2BA/WxFXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5SCrPjl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACE3C4CEE7;
	Wed, 29 Jan 2025 08:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738137867;
	bh=Cq/ifN6qPFjI9iVcOdcUN7voJgWfTzlDgfjk+/3U7k8=;
	h=From:To:Cc:Subject:Date:From;
	b=X5SCrPjlD2OKkTqgH9tgbsE5MxIo7tBVVsAznBaWyI1O7v2NhkdFGTK+Bj2xpfenD
	 SdoalaJr7vntWRY1NPyYZVTG6GdWbVqlv4axDf/VF8VfBrdw2sDLFvy9a8xFwOeCur
	 xiXeGBb3t/IcZRWuIEVHzSN1CqRAFOj0r4LUBpBQU/AMEnB/1ruk4lhyadMZmxpUp2
	 wPcdzzPaKqCMzPkbYqEqEX605bMjtJObnnjXFSQvqIrVdiOMQpfM+GAK6U9MFHc9N+
	 A5RDQGTRYO0Slpf6pmPh8Z2w8U1AieV9sGuwOSq2y5ZP1BoL5Zjra493EuSPwh7GKt
	 AMFLbDPrzCQnQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1td33g-00000004DPX-2dbb;
	Wed, 29 Jan 2025 09:04:24 +0100
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
Subject: [PATCH v2 00/13] Change ghes to use HEST-based offsets and add support for error inject
Date: Wed, 29 Jan 2025 09:04:06 +0100
Message-ID: <cover.1738137123.git.mchehab+huawei@kernel.org>
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

v2: 
- address some nits;
- improved ags cleanup patch and removed ags.present field;
- added some missing le*_to_cpu() calls;
- update date at copyright for new files to 2024-2025;
- qmp command changed to: inject-ghes-v2-error ans since updated to 10.0;
- added HEST and DSDT tables after the changes to make check target happy.
  (two patches: first one whitelisting such tables; second one removing from
   whitelist and updating/adding such tables to tests/data/acpi)

I'm enclosing a diff from v1 at the end, as it may help check the differences.

Mauro Carvalho Chehab (13):
  acpi/ghes: Prepare to support multiple sources on ghes
  tests/acpi: virt: allow acpi table changes for a new table: HEST
  acpi/ghes: add a firmware file with HEST address
  acpi/ghes: Use HEST table offsets when preparing GHES records
  acpi/generic_event_device: Update GHES migration to cover hest addr
  acpi/generic_event_device: add logic to detect if HEST addr is
    available
  acpi/ghes: add a notifier to notify when error data is ready
  acpi/ghes: Cleanup the code which gets ghes ged state
  acpi/generic_event_device: add an APEI error device
  arm/virt: Wire up a GED error device for ACPI / GHES
  qapi/acpi-hest: add an interface to do generic CPER error injection
  tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
  scripts/ghes_inject: add a script to generate GHES error inject

 MAINTAINERS                                   |  10 +
 hw/acpi/Kconfig                               |   5 +
 hw/acpi/aml-build.c                           |  10 +
 hw/acpi/generic_event_device.c                |  44 ++
 hw/acpi/ghes-stub.c                           |   7 +-
 hw/acpi/ghes.c                                | 204 +++--
 hw/acpi/ghes_cper.c                           |  38 +
 hw/acpi/ghes_cper_stub.c                      |  19 +
 hw/acpi/meson.build                           |   2 +
 hw/arm/virt-acpi-build.c                      |  35 +-
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
 scripts/arm_processor_error.py                | 377 ++++++++++
 scripts/ghes_inject.py                        |  51 ++
 scripts/qmp_helper.py                         | 702 ++++++++++++++++++
 target/arm/kvm.c                              |   8 +-
 tests/data/acpi/aarch64/virt/DSDT             | Bin 5196 -> 5240 bytes
 .../data/acpi/aarch64/virt/DSDT.acpihmatvirt  | Bin 5282 -> 5326 bytes
 tests/data/acpi/aarch64/virt/DSDT.memhp       | Bin 6557 -> 6601 bytes
 tests/data/acpi/aarch64/virt/DSDT.pxb         | Bin 7679 -> 7723 bytes
 tests/data/acpi/aarch64/virt/DSDT.topology    | Bin 5398 -> 5442 bytes
 tests/data/acpi/aarch64/virt/HEST             | Bin 0 -> 224 bytes
 30 files changed, 1550 insertions(+), 71 deletions(-)
 create mode 100644 hw/acpi/ghes_cper.c
 create mode 100644 hw/acpi/ghes_cper_stub.c
 create mode 100644 qapi/acpi-hest.json
 create mode 100644 scripts/arm_processor_error.py
 create mode 100755 scripts/ghes_inject.py
 create mode 100644 scripts/qmp_helper.py
 create mode 100644 tests/data/acpi/aarch64/virt/HEST

----

Diff against previous version:
Instead of placing a v2 here, it is probably more useful to add the diffs
against the past version:

diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
index ce00c80054f4..50313ed7ee96 100644
--- a/hw/acpi/generic_event_device.c
+++ b/hw/acpi/generic_event_device.c
@@ -29,6 +29,12 @@ static const uint32_t ged_supported_events[] = {
     ACPI_GED_ERROR_EVT,
 };
 
+/*
+ * ACPI 5.0b: 5.6.6 Device Object Notifications
+ * Table 5-135 Error Device Notification Values
+ */
+#define ERROR_DEVICE_NOTIFICATION   0x80
+
 /*
  * The ACPI Generic Event Device (GED) is a hardware-reduced specific
  * device[ACPI v6.1 Section 5.6.9] that handles all platform events,
@@ -120,7 +126,7 @@ void build_ged_aml(Aml *table, const char *name, HotplugHandler *hotplug_dev,
             case ACPI_GED_ERROR_EVT:
                 aml_append(if_ctx,
                            aml_notify(aml_name(ACPI_APEI_ERROR_DEVICE),
-                                      aml_int(0x80)));
+                                      aml_int(ERROR_DEVICE_NOTIFICATION)));
                 break;
             case ACPI_GED_NVDIMM_HOTPLUG_EVT:
                 aml_append(if_ctx,
@@ -326,7 +332,7 @@ static void acpi_ged_send_event(AcpiDeviceIf *adev, AcpiEventStatusBits ev)
 
 static const Property acpi_ged_properties[] = {
     DEFINE_PROP_UINT32("ged-event", AcpiGedState, ged_event_bitmap, 0),
-    DEFINE_PROP_BOOL("x-has-hest-addr", AcpiGedState, ghes_state.hest_lookup, true),
+    DEFINE_PROP_BOOL("x-has-hest-addr", AcpiGedState, ghes_state.use_hest_addr, true),
 };
 
 static const VMStateDescription vmstate_memhp_state = {
diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index fbabf955155a..40f660c246fe 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,7 +11,8 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t physical_address)
 {
     return -1;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 479c465c9554..52e1528aa788 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -67,16 +67,18 @@
  * docs/specs/acpi_hest_ghes.rst.
  */
 
-/* ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
+/*
+ * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
  * Table 18-382 Generic Hardware Error Source version 2 (GHESv2) Structure
  */
 #define HEST_GHES_V2_TABLE_SIZE  92
-#define GHES_ACK_OFFSET          (64 + GAS_ADDR_OFFSET)
+#define GHES_READ_ACK_ADDR_OFF          64
 
-/* ACPI 6.2: 18.3.2.7: Generic Hardware Error Source
+/*
+ * ACPI 6.2: 18.3.2.7: Generic Hardware Error Source
  * Table 18-380: 'Error Status Address' field
  */
-#define GHES_ERR_ST_ADDR_OFFSET  (20 + GAS_ADDR_OFFSET)
+#define GHES_ERR_STATUS_ADDR_OFF  20
 
 /*
  * Values for error_severity field
@@ -286,10 +288,10 @@ static void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker,
 }
 
 /* Build Generic Hardware Error Source version 2 (GHESv2) */
-static void build_ghes_v2(GArray *table_data,
-                          BIOSLinker *linker,
-                          const AcpiNotificationSourceId *notif_src,
-                          uint16_t index, int num_sources)
+static void build_ghes_v2_entry(GArray *table_data,
+                                BIOSLinker *linker,
+                                const AcpiNotificationSourceId *notif_src,
+                                uint16_t index, int num_sources)
 {
     uint64_t address_offset;
     const uint16_t notify = notif_src->notify;
@@ -357,45 +359,38 @@ static void build_ghes_v2(GArray *table_data,
 }
 
 /* Build Hardware Error Source Table */
-void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
+void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
+                     GArray *hardware_errors,
                      BIOSLinker *linker,
-                     const AcpiNotificationSourceId * const notif_source,
+                     const AcpiNotificationSourceId *notif_source,
                      int num_sources,
                      const char *oem_id, const char *oem_table_id)
 {
     AcpiTable table = { .sig = "HEST", .rev = 1,
                         .oem_id = oem_id, .oem_table_id = oem_table_id };
-    AcpiGedState *acpi_ged_state;
-    AcpiGhesState *ags = NULL;
+    uint32_t hest_offset;
     int i;
 
     build_ghes_error_table(hardware_errors, linker, num_sources);
 
     acpi_table_begin(&table, table_data);
 
-    int hest_offset = table_data->len;
+    hest_offset = table_data->len;
 
     /* Error Source Count */
     build_append_int_noprefix(table_data, num_sources, 4);
     for (i = 0; i < num_sources; i++) {
-        build_ghes_v2(table_data, linker, &notif_source[i], i, num_sources);
+        build_ghes_v2_entry(table_data, linker, &notif_source[i], i, num_sources);
     }
 
     acpi_table_end(linker, &table);
 
     /*
-     * tell firmware to write into GPA the address of HEST via fw_cfg,
+     * Tell firmware to write into GPA the address of HEST via fw_cfg,
      * once initialized.
      */
 
-    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
-                                                       NULL));
-    if (!acpi_ged_state) {
-        return;
-    }
-
-    ags = &acpi_ged_state->ghes_state;
-    if (ags->hest_lookup) {
+    if (ags->use_hest_addr) {
         bios_linker_loader_write_pointer(linker,
                                          ACPI_HEST_ADDR_FW_CFG_FILE, 0,
                                          sizeof(uint64_t),
@@ -414,12 +409,10 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
     fw_cfg_add_file_callback(s, ACPI_HW_ERROR_ADDR_FW_CFG_FILE, NULL, NULL,
         NULL, &(ags->hw_error_le), sizeof(ags->hw_error_le), false);
 
-    if (ags && ags->hest_lookup) {
+    if (ags->use_hest_addr) {
         fw_cfg_add_file_callback(s, ACPI_HEST_ADDR_FW_CFG_FILE, NULL, NULL,
             NULL, &(ags->hest_addr_le), sizeof(ags->hest_addr_le), false);
     }
-
-    ags->present = true;
 }
 
 static void get_hw_error_offsets(uint64_t ghes_addr,
@@ -444,26 +437,29 @@ static void get_hw_error_offsets(uint64_t ghes_addr,
     *read_ack_register_addr = ghes_addr + sizeof(uint64_t);
 }
 
-static void get_ghes_source_offsets(uint16_t source_id, uint64_t hest_addr,
+static void get_ghes_source_offsets(uint16_t source_id,
+                                    uint64_t hest_entry_addr,
                                     uint64_t *cper_addr,
                                     uint64_t *read_ack_start_addr,
                                     Error **errp)
 {
     uint64_t hest_err_block_addr, hest_read_ack_addr;
-    uint64_t err_source_struct, error_block_addr;
+    uint64_t err_source_entry, error_block_addr;
     uint32_t num_sources, i;
 
-    cpu_physical_memory_read(hest_addr, &num_sources, sizeof(num_sources));
+
+    cpu_physical_memory_read(hest_entry_addr, &num_sources,
+                             sizeof(num_sources));
     num_sources = le32_to_cpu(num_sources);
 
-    err_source_struct = hest_addr + sizeof(num_sources);
+    err_source_entry = hest_entry_addr + sizeof(num_sources);
 
     /*
      * Currently, HEST Error source navigates only for GHESv2 tables
      */
 
     for (i = 0; i < num_sources; i++) {
-        uint64_t addr = err_source_struct;
+        uint64_t addr = err_source_entry;
         uint16_t type, src_id;
 
         cpu_physical_memory_read(addr, &type, sizeof(type));
@@ -479,11 +475,11 @@ static void get_ghes_source_offsets(uint16_t source_id, uint64_t hest_addr,
         addr += sizeof(type);
         cpu_physical_memory_read(addr, &src_id, sizeof(src_id));
 
-        if (src_id == source_id) {
+        if (le16_to_cpu(src_id) == source_id) {
             break;
         }
 
-        err_source_struct += HEST_GHES_V2_TABLE_SIZE;
+        err_source_entry += HEST_GHES_V2_TABLE_SIZE;
     }
     if (i == num_sources) {
         error_setg(errp, "HEST: Source %d not found.", source_id);
@@ -491,39 +487,42 @@ static void get_ghes_source_offsets(uint16_t source_id, uint64_t hest_addr,
     }
 
     /* Navigate though table address pointers */
-    hest_err_block_addr = err_source_struct + GHES_ERR_ST_ADDR_OFFSET;
-    hest_read_ack_addr = err_source_struct + GHES_ACK_OFFSET;
+    hest_err_block_addr = err_source_entry + GHES_ERR_STATUS_ADDR_OFF +
+                          GAS_ADDR_OFFSET;
 
     cpu_physical_memory_read(hest_err_block_addr, &error_block_addr,
                              sizeof(error_block_addr));
 
+    error_block_addr = le64_to_cpu(error_block_addr);
+
     cpu_physical_memory_read(error_block_addr, cper_addr,
                              sizeof(*cper_addr));
 
+    *cper_addr = le64_to_cpu(*cper_addr);
+
+    hest_read_ack_addr = err_source_entry + GHES_READ_ACK_ADDR_OFF +
+                         GAS_ADDR_OFFSET;
+
     cpu_physical_memory_read(hest_read_ack_addr, read_ack_start_addr,
                              sizeof(*read_ack_start_addr));
+
+    *read_ack_start_addr = le64_to_cpu(*read_ack_start_addr);
 }
 
 NotifierList acpi_generic_error_notifiers =
     NOTIFIER_LIST_INITIALIZER(error_device_notifiers);
 
-void ghes_record_cper_errors(const void *cper, size_t len,
+void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
                              uint16_t source_id, Error **errp)
 {
     uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
-    AcpiGhesState *ags;
 
     if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
         error_setg(errp, "GHES CPER record is too big: %zd", len);
         return;
     }
 
-    ags = acpi_ghes_get_state();
-    if (!ags) {
-        return;
-    }
-
-    if (!ags->hest_lookup) {
+    if (!ags->use_hest_addr) {
         fprintf(stderr,"Using old GHES lookup\n");
         get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
                              &cper_addr, &read_ack_register_addr);
@@ -558,7 +557,8 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     notifier_list_notify(&acpi_generic_error_notifiers, &source_id);
 }
 
-int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
@@ -576,7 +576,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
     acpi_ghes_build_append_mem_cper(block, physical_address);
 
     /* Report the error */
-    ghes_record_cper_errors(block->data, block->len, source_id, &errp);
+    ghes_record_cper_errors(ags, block->data, block->len, source_id, &errp);
 
     g_array_free(block, true);
 
@@ -600,9 +600,7 @@ AcpiGhesState *acpi_ghes_get_state(void)
         return NULL;
     }
     ags = &acpi_ged_state->ghes_state;
-    if (!ags->present) {
-        return NULL;
-    }
+
     if (!ags->hw_error_le && !ags->hest_addr_le) {
         return NULL;
     }
diff --git a/hw/acpi/ghes_cper.c b/hw/acpi/ghes_cper.c
index 02c47b41b990..0a2d95dd8b27 100644
--- a/hw/acpi/ghes_cper.c
+++ b/hw/acpi/ghes_cper.c
@@ -1,7 +1,7 @@
 /*
  * CPER payload parser for error injection
  *
- * Copyright(C) 2024 Huawei LTD.
+ * Copyright(C) 2024-2025 Huawei LTD.
  *
  * This code is licensed under the GPL version 2 or later. See the
  * COPYING file in the top-level directory.
@@ -16,8 +16,14 @@
 #include "qapi/qapi-commands-acpi-hest.h"
 #include "hw/acpi/ghes.h"
 
-void qmp_inject_ghes_error(const char *qmp_cper, Error **errp)
+void qmp_inject_ghes_v2_error(const char *qmp_cper, Error **errp)
 {
+    AcpiGhesState *ags;
+
+    ags = acpi_ghes_get_state();
+    if (!ags) {
+        return;
+    }
 
     uint8_t *cper;
     size_t  len;
@@ -28,5 +34,5 @@ void qmp_inject_ghes_error(const char *qmp_cper, Error **errp)
         return;
     }
 
-    ghes_record_cper_errors(cper, len, ACPI_HEST_SRC_ID_QMP, errp);
+    ghes_record_cper_errors(ags, cper, len, ACPI_HEST_SRC_ID_QMP, errp);
 }
diff --git a/hw/acpi/ghes_cper_stub.c b/hw/acpi/ghes_cper_stub.c
index 8782e2c02fa8..5ebc61970a78 100644
--- a/hw/acpi/ghes_cper_stub.c
+++ b/hw/acpi/ghes_cper_stub.c
@@ -1,7 +1,7 @@
 /*
  * Stub interface for CPER payload parser for error injection
  *
- * Copyright(C) 2024 Huawei LTD.
+ * Copyright(C) 2024-2025 Huawei LTD.
  *
  * This code is licensed under the GPL version 2 or later. See the
  * COPYING file in the top-level directory.
@@ -13,7 +13,7 @@
 #include "qapi/qapi-commands-acpi-hest.h"
 #include "hw/acpi/ghes.h"
 
-void qmp_inject_ghes_error(const char *cper, Error **errp)
+void qmp_inject_ghes_v2_error(const char *cper, Error **errp)
 {
     error_setg(errp, "GHES QMP error inject is not compiled in");
 }
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index 0a1f0b62d289..7c7094f46b39 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -966,13 +966,13 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
 
             acpi_add_table(table_offsets, tables_blob);
 
-            if (!ags->hest_lookup) {
-                acpi_build_hest(tables_blob, tables->hardware_errors,
+            if (!ags->use_hest_addr) {
+                acpi_build_hest(ags, tables_blob, tables->hardware_errors,
                                 tables->linker, hest_ghes_notify_9_2,
                                 ARRAY_SIZE(hest_ghes_notify_9_2),
                                 vms->oem_id, vms->oem_table_id);
             } else {
-                acpi_build_hest(tables_blob, tables->hardware_errors,
+                acpi_build_hest(ags, tables_blob, tables->hardware_errors,
                                 tables->linker, hest_ghes_notify,
                                 ARRAY_SIZE(hest_ghes_notify),
                                 vms->oem_id, vms->oem_table_id);
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 078d78666f91..376933a0024a 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -63,8 +63,7 @@ enum AcpiGhesNotifyType {
 typedef struct AcpiGhesState {
     uint64_t hest_addr_le;
     uint64_t hw_error_le;
-    bool present; /* True if GHES is present at all on this board */
-    bool hest_lookup; /* True if HEST address is present */
+    bool use_hest_addr; /* True if HEST address is present */
 } AcpiGhesState;
 
 /*
@@ -80,15 +79,17 @@ typedef struct AcpiNotificationSourceId {
     enum AcpiGhesNotifyType notify;
 } AcpiNotificationSourceId;
 
-void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
+void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
+                     GArray *hardware_errors,
                      BIOSLinker *linker,
                      const AcpiNotificationSourceId * const notif_source,
                      int num_sources,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
-int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
-void ghes_record_cper_errors(const void *cper, size_t len,
+int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
+                            uint64_t error_physical_addr);
+void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
 
 /**
diff --git a/qapi/acpi-hest.json b/qapi/acpi-hest.json
index d58fba485180..fff5018c7ec1 100644
--- a/qapi/acpi-hest.json
+++ b/qapi/acpi-hest.json
@@ -12,7 +12,7 @@
 
 
 ##
-# @inject-ghes-error:
+# @inject-ghes-v2-error:
 #
 # Inject an error with additional ACPI 6.1 GHESv2 error information
 #
@@ -25,9 +25,9 @@
 #
 # @unstable: This command is experimental.
 #
-# Since: 9.2
+# Since: 10.0
 ##
-{ 'command': 'inject-ghes-error',
+{ 'command': 'inject-ghes-v2-error',
   'data': {
     'cper': 'str'
   },
diff --git a/scripts/arm_processor_error.py b/scripts/arm_processor_error.py
index b4321ff45517..326efc8492dd 100644
--- a/scripts/arm_processor_error.py
+++ b/scripts/arm_processor_error.py
@@ -3,7 +3,7 @@
 # pylint: disable=C0301,C0114,R0903,R0912,R0913,R0914,R0915,W0511
 # SPDX-License-Identifier: GPL-2.0
 #
-# Copyright (C) 2024 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+# Copyright (C) 2024-2025 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
 
 # Note: currently it lacks a method to fill the ARM Processor Error CPER
 # psci field from emulation. On a real hardware, this is filled only
diff --git a/scripts/ghes_inject.py b/scripts/ghes_inject.py
index 67cb6077bec8..5d72bc7f09e1 100755
--- a/scripts/ghes_inject.py
+++ b/scripts/ghes_inject.py
@@ -2,7 +2,7 @@
 #
 # SPDX-License-Identifier: GPL-2.0
 #
-# Copyright (C) 2024 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+# Copyright (C) 2024-2025 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
 
 """
 Handle ACPI GHESv2 error injection logic QEMU QMP interface.
diff --git a/scripts/qmp_helper.py b/scripts/qmp_helper.py
index 357ebc6e8359..8e375d6a6cab 100644
--- a/scripts/qmp_helper.py
+++ b/scripts/qmp_helper.py
@@ -3,7 +3,7 @@
 # # pylint: disable=C0103,E0213,E1135,E1136,E1137,R0902,R0903,R0912,R0913
 # SPDX-License-Identifier: GPL-2.0
 #
-# Copyright (C) 2024 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+# Copyright (C) 2024-2025 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
 
 """
 Helper classes to be used by ghes_inject command classes.
@@ -541,7 +541,7 @@ def send_cper_raw(self, cper_data):
 
         self._connect()
 
-        if self.send_cmd("inject-ghes-error", cmd_arg):
+        if self.send_cmd("inject-ghes-v2-error", cmd_arg):
             print("Error injected.")
 
     def send_cper(self, notif_type, payload):
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0283089713b9..544ff174784d 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2366,10 +2366,13 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 {
     ram_addr_t ram_addr;
     hwaddr paddr;
+    AcpiGhesState *ags;
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
-    if (acpi_ghes_get_state() && addr) {
+    ags = acpi_ghes_get_state();
+
+    if (ags && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
@@ -2387,7 +2390,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SEA,
+                                             paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
                     error_report("failed to record the error");
diff --git a/tests/data/acpi/aarch64/virt/DSDT b/tests/data/acpi/aarch64/virt/DSDT
index 36d3e5d5a5e4..a182bd9d7182 100644
Binary files a/tests/data/acpi/aarch64/virt/DSDT and b/tests/data/acpi/aarch64/virt/DSDT differ
diff --git a/tests/data/acpi/aarch64/virt/DSDT.acpihmatvirt b/tests/data/acpi/aarch64/virt/DSDT.acpihmatvirt
index e6154d0355f8..af1f2b0eb0b7 100644
Binary files a/tests/data/acpi/aarch64/virt/DSDT.acpihmatvirt and b/tests/data/acpi/aarch64/virt/DSDT.acpihmatvirt differ
diff --git a/tests/data/acpi/aarch64/virt/DSDT.memhp b/tests/data/acpi/aarch64/virt/DSDT.memhp
index 33f011d6b635..10436ec87c48 100644
Binary files a/tests/data/acpi/aarch64/virt/DSDT.memhp and b/tests/data/acpi/aarch64/virt/DSDT.memhp differ
diff --git a/tests/data/acpi/aarch64/virt/DSDT.pxb b/tests/data/acpi/aarch64/virt/DSDT.pxb
index c0fdc6e9c139..0524b3cbe00b 100644
Binary files a/tests/data/acpi/aarch64/virt/DSDT.pxb and b/tests/data/acpi/aarch64/virt/DSDT.pxb differ
diff --git a/tests/data/acpi/aarch64/virt/DSDT.topology b/tests/data/acpi/aarch64/virt/DSDT.topology
index 029d03eecc4e..8c0423fe62d6 100644
Binary files a/tests/data/acpi/aarch64/virt/DSDT.topology and b/tests/data/acpi/aarch64/virt/DSDT.topology differ
diff --git a/tests/data/acpi/aarch64/virt/HEST b/tests/data/acpi/aarch64/virt/HEST
new file mode 100644
index 000000000000..8b0cf87700fa
Binary files /dev/null and b/tests/data/acpi/aarch64/virt/HEST differ



