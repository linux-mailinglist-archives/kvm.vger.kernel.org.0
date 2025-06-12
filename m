Return-Path: <kvm+bounces-49290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62AC7AD75B7
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87C407B15E7
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6758329B8EA;
	Thu, 12 Jun 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EetqQmg5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D042299952;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=WyGpIBbAWmwsT7i55lfRS5FbWPR9n8WeOoadX/2MjzFiC38A68iWBC7Vn1GEwUuPXNXAgJS6BdWGaiBFfbeTsiCeZB1TqKSCoguiNhGXx3OXzoEUctLlOBOXM70Uia0un3xvv+3xUi59N36QB7Rngb7rCJkHAPowwHIaEyn2PXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=fslt9Hp7rK/OAg+jQImQC6ZBKgHxeGpygTcaXz3ySXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvnthwvctmlmZT5S0+UYn84xhOM5HlPI6OaUxODtWRyCWP3MVRCFU+Lkd8aeoBg/3OBK0uCiZPtI4pnOBb+CHGEFlkb4dyXaRkcmNfDZxJhzyH+njR+weA+hhxhA2cxPqfgwlqKILtuuYU6f8TYQoPqfj0Y73Zq+uxTfEYrke/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EetqQmg5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0674DC4CEEA;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741469;
	bh=fslt9Hp7rK/OAg+jQImQC6ZBKgHxeGpygTcaXz3ySXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EetqQmg54h86GClC0MWyGvOFu0zJwwgkLnq2nhvT2j2mv5KZertOh+rdHenvjDpo5
	 qf3O3L5e+dozND4O2vNwyn4YRTZITYOqG64DMyvvyuPRkCguKt7DUS684RhyUu4C6q
	 nqdSrVDxHRGRP5clJIEFJM/s+leKxqD5w1EcNc0AQiUEsjWBkFbHkHLie5eOIsi04u
	 vyoJ5A6vZSZBf5WJSf2GIxea5maUh25lzz30JOUC/ct0hi9sHv3DwU4T1DlvZvcWgA
	 oXGWfFhWh7YDWSV1nPefxrE3mPoHkxD1eAhIG4AfqEeW/6slLNJkqeF7fp/fn8Q9jR
	 u0+CIm8DoigXw==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgZ-00000005Evi-0ceP;
	Thu, 12 Jun 2025 17:17:47 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Ani Sinha" <anisinha@redhat.com>,
	"Dongjiu Geng" <gengdongjiu1@gmail.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	"Peter Maydell" <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Shannon Zhao" <shannon.zhaosl@gmail.com>,
	"Yanan Wang" <wangyanan55@huawei.com>,
	"Zhao Liu" <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 (RESEND) 09/20] acpi/ghes: don't hard-code the number of sources for HEST table
Date: Thu, 12 Jun 2025 17:17:33 +0200
Message-ID: <65e5f85ed1bc7617ce9a655d2b1b906182e83d53.1749741085.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

The current code is actually dependent on having just one error
structure with a single source, as any change there would cause
migration issues.

As the number of sources should be arch-dependent, as it will depend on
what kind of notifications will exist, and how many errors can be
reported at the same time, change the logic to be more flexible,
allowing the number of sources to be defined when building the
HEST table by the caller.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
---
 hw/acpi/ghes.c           | 39 +++++++++++++++++++++------------------
 hw/arm/virt-acpi-build.c |  8 +++++++-
 include/hw/acpi/ghes.h   | 17 ++++++++++++-----
 target/arm/kvm.c         |  2 +-
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 668ca72587c7..f49d0d628fc4 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -238,17 +238,17 @@ ghes_gen_err_data_uncorrectable_recoverable(GArray *block,
  * See docs/specs/acpi_hest_ghes.rst for blobs format.
  */
 static void build_ghes_error_table(AcpiGhesState *ags, GArray *hardware_errors,
-                                   BIOSLinker *linker)
+                                   BIOSLinker *linker, int num_sources)
 {
     int i, error_status_block_offset;
 
     /* Build error_block_address */
-    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+    for (i = 0; i < num_sources; i++) {
         build_append_int_noprefix(hardware_errors, 0, sizeof(uint64_t));
     }
 
     /* Build read_ack_register */
-    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+    for (i = 0; i < num_sources; i++) {
         /*
          * Initialize the value of read_ack_register to 1, so GHES can be
          * writable after (re)boot.
@@ -263,13 +263,13 @@ static void build_ghes_error_table(AcpiGhesState *ags, GArray *hardware_errors,
 
     /* Reserve space for Error Status Data Block */
     acpi_data_push(hardware_errors,
-        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
+        ACPI_GHES_MAX_RAW_DATA_LENGTH * num_sources);
 
     /* Tell guest firmware to place hardware_errors blob into RAM */
     bios_linker_loader_alloc(linker, ACPI_HW_ERROR_FW_CFG_FILE,
                              hardware_errors, sizeof(uint64_t), false);
 
-    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
+    for (i = 0; i < num_sources; i++) {
         /*
          * Tell firmware to patch error_block_address entries to point to
          * corresponding "Generic Error Status Block"
@@ -295,12 +295,14 @@ static void build_ghes_error_table(AcpiGhesState *ags, GArray *hardware_errors,
 }
 
 /* Build Generic Hardware Error Source version 2 (GHESv2) */
-static void build_ghes_v2(GArray *table_data,
-                          BIOSLinker *linker,
-                          enum AcpiGhesNotifyType notify,
-                          uint16_t source_id)
+static void build_ghes_v2_entry(GArray *table_data,
+                                BIOSLinker *linker,
+                                const AcpiNotificationSourceId *notif_src,
+                                uint16_t index, int num_sources)
 {
     uint64_t address_offset;
+    const uint16_t notify = notif_src->notify;
+    const uint16_t source_id = notif_src->source_id;
 
     /*
      * Type:
@@ -331,7 +333,7 @@ static void build_ghes_v2(GArray *table_data,
                                    address_offset + GAS_ADDR_OFFSET,
                                    sizeof(uint64_t),
                                    ACPI_HW_ERROR_FW_CFG_FILE,
-                                   source_id * sizeof(uint64_t));
+                                   index * sizeof(uint64_t));
 
     /* Notification Structure */
     build_ghes_hw_error_notification(table_data, notify);
@@ -351,8 +353,7 @@ static void build_ghes_v2(GArray *table_data,
                                    address_offset + GAS_ADDR_OFFSET,
                                    sizeof(uint64_t),
                                    ACPI_HW_ERROR_FW_CFG_FILE,
-                                   (ACPI_GHES_ERROR_SOURCE_COUNT + source_id)
-                                   * sizeof(uint64_t));
+                                   (num_sources + index) * sizeof(uint64_t));
 
     /*
      * Read Ack Preserve field
@@ -368,22 +369,26 @@ static void build_ghes_v2(GArray *table_data,
 void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
                      GArray *hardware_errors,
                      BIOSLinker *linker,
+                     const AcpiNotificationSourceId *notif_source,
+                     int num_sources,
                      const char *oem_id, const char *oem_table_id)
 {
     AcpiTable table = { .sig = "HEST", .rev = 1,
                         .oem_id = oem_id, .oem_table_id = oem_table_id };
     uint32_t hest_offset;
+    int i;
 
     hest_offset = table_data->len;
 
-    build_ghes_error_table(ags, hardware_errors, linker);
+    build_ghes_error_table(ags, hardware_errors, linker, num_sources);
 
     acpi_table_begin(&table, table_data);
 
     /* Error Source Count */
-    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, 4);
-    build_ghes_v2(table_data, linker,
-                  ACPI_GHES_NOTIFY_SEA, ACPI_HEST_SRC_ID_SEA);
+    build_append_int_noprefix(table_data, num_sources, 4);
+    for (i = 0; i < num_sources; i++) {
+        build_ghes_v2_entry(table_data, linker, &notif_source[i], i, num_sources);
+    }
 
     acpi_table_end(linker, &table);
 
@@ -515,8 +520,6 @@ void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
         return;
     }
 
-    assert(ACPI_GHES_ERROR_SOURCE_COUNT == 1);
-
     if (!ags->use_hest_addr) {
         get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
                              &cper_addr, &read_ack_register_addr);
diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index b57f1256c30f..da3ebf403ef9 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -889,6 +889,10 @@ static void acpi_align_size(GArray *blob, unsigned align)
     g_array_set_size(blob, ROUND_UP(acpi_data_len(blob), align));
 }
 
+static const AcpiNotificationSourceId hest_ghes_notify[] = {
+    { ACPI_HEST_SRC_ID_SYNC, ACPI_GHES_NOTIFY_SEA },
+};
+
 static
 void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
 {
@@ -950,7 +954,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
         if (ags) {
             acpi_add_table(table_offsets, tables_blob);
             acpi_build_hest(ags, tables_blob, tables->hardware_errors,
-                            tables->linker, vms->oem_id, vms->oem_table_id);
+                            tables->linker, hest_ghes_notify,
+                            ARRAY_SIZE(hest_ghes_notify),
+                            vms->oem_id, vms->oem_table_id);
         }
     }
 
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 5265102ba51f..8c4b08433760 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -57,13 +57,18 @@ enum AcpiGhesNotifyType {
     ACPI_GHES_NOTIFY_RESERVED = 12
 };
 
-enum {
-    ACPI_HEST_SRC_ID_SEA = 0,
-    /* future ids go here */
-
-    ACPI_GHES_ERROR_SOURCE_COUNT
+/*
+ * ID numbers used to fill HEST source ID field
+ */
+enum AcpiGhesSourceID {
+    ACPI_HEST_SRC_ID_SYNC,
 };
 
+typedef struct AcpiNotificationSourceId {
+    enum AcpiGhesSourceID source_id;
+    enum AcpiGhesNotifyType notify;
+} AcpiNotificationSourceId;
+
 /*
  * AcpiGhesState stores GPA values that will be used to fill HEST entries.
  *
@@ -84,6 +89,8 @@ typedef struct AcpiGhesState {
 void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
                      GArray *hardware_errors,
                      BIOSLinker *linker,
+                     const AcpiNotificationSourceId * const notif_source,
+                     int num_sources,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c2a7abb66433..2191db8af1ab 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2365,7 +2365,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SEA,
+                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC,
                                              paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
-- 
2.49.0


