Return-Path: <kvm+bounces-59508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 046E8BB9B83
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 21:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B0D624E40E7
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 19:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A96F1DD525;
	Sun,  5 Oct 2025 19:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N9ZwOJAY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F97191F98
	for <kvm@vger.kernel.org>; Sun,  5 Oct 2025 19:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759691817; cv=none; b=edEye0kmlTQFIerxUibpHsjp53sTF4dZdulHrSfXpk0YH18L9ItECi+C0ShVInK5WrG7TJnddsCg461CgfpJFT2Llz3TC/dmcNCRgy0Z4mEMJrBoGdPyrXAxfV/ksdzwG9611ARYh7ZL/H8al4zOGhCFR22pnl51KTbD4SUjCSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759691817; c=relaxed/simple;
	bh=Mmtla5DDZbeeDr+ehEk0ji3Obuungug/aAmHAVTU6Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0Jdg22ewX8WvSCtCjq9R0HxBqfM9HX6Zhi569E5zNxQSb91Vtin7/UgMOSBTuNop83i7qnNWOwTfjKdyo+is3+oMGMZZeCVthyyU/BkeK1Nhdf94tX14AEDEQnrNByDVSQlOsQRsFCcVeCXptBlnoKT13inGai6QflxV8WSjhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N9ZwOJAY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759691814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OhUIAcnmQM/zKU/vQjFpt3gEtPEYN7XIQ1W4eirGAyc=;
	b=N9ZwOJAYcng1xEf6WivbUPXTVZMx18UmkMr2OtT9vEp6696Se6BmVLxMvGLj9aSVfk7Sab
	XL3SWi5gebLIFOWfHXv/eb1RAjF2pOt18IEHrXD7EFV+HG8JkHuKNVPFSJtSOydeQDK2nb
	jW1q8Y0+A558wFKwZsy5eo4SsnWSIZc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-nPc1C7dPM-ywxl2K_M7A2Q-1; Sun, 05 Oct 2025 15:16:50 -0400
X-MC-Unique: nPc1C7dPM-ywxl2K_M7A2Q-1
X-Mimecast-MFC-AGG-ID: nPc1C7dPM-ywxl2K_M7A2Q_1759691809
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e38bd6680so14092075e9.1
        for <kvm@vger.kernel.org>; Sun, 05 Oct 2025 12:16:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759691809; x=1760296609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhUIAcnmQM/zKU/vQjFpt3gEtPEYN7XIQ1W4eirGAyc=;
        b=jQKcPbFauX14waUqwUwQmqD6VfdqZmOeWhDvLuCfUnqKotTB11h/hBy+DwvRgfknDd
         41koSOQ8GjqhQSWfj2ghsxhpQUX+rDTa6O6lGi0O1oiP3eKsbblRSCOOQp6aPZAS2tze
         v9zt+zW+WUrfepNQ6vvUye37f4e3E0iHOj+bjiXXYn+PHgq6tZjKD0Y+pya9ThcMzx+o
         rf/h8f6Hqs1CEHZ8MRtJojXcDCdhB8PgVI3M8Blt47f6xsdtCgO2y5b1+QCy2FQAUCRg
         luGEqR8oDNochqkdn/LgYt+4S7Dztm8kfhqPurFpiROW9uv0oMNKdpZnXS56kl8RxaQU
         zExw==
X-Forwarded-Encrypted: i=1; AJvYcCVIo9mixRR7OTHKOl88IEFNaOfRY9yplC7y+lLFx5XsvDOElpezdkvl/6+HV0n018AW+lA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhj8SZP8GTBwLW6mE6MwiFQqgcbeybfnTI4zVajxhOsbP1X8sg
	Vz1FXW59/rYC30g1+XeO8uoIlm56Co9Jql3h4yoQCBdyV9QDJQRlHzLrAPIx2DD5eX1Sh601AtT
	/3HLclXtikBRwkPiwNlPlC/ST2fPfgHq9+9wqKuSeUf/SaUYcetal6Q==
X-Gm-Gg: ASbGncvE9VsYFOs4CscYTsLS4m/0vkTorv/jiBh/6hEU6/AuK1SFNDe833QaUZjHhJM
	UWG3VVx6vPj+rxKVALSfxrTmkpjmq8tmXgTaVCu2rz8eX0AmFr2Hy0VLrCSNz5pFIG1kFk77wj0
	E0SM5jhTxWxziaYyVuyCft4y0Xacha1uqLe9OE4tZLUoItNuq1JwEPeVThOX7YKpBZjRw03hETZ
	UvZaTZ/liw6+gs4mujxB5zq2xnIu8ZIWwwTycz+G2xiLbZc80/dSLbGolcHqBlC34b7p6yJ0QPf
	ucXXvfSqv0AX7KwBe2B63zbArpKqc0HdI+zIaT4=
X-Received: by 2002:a05:600c:1d05:b0:45d:d353:a491 with SMTP id 5b1f17b1804b1-46e711002damr58957035e9.1.1759691808752;
        Sun, 05 Oct 2025 12:16:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnI3QzF955EPnYrzFeohbyruMJEXq1zjmTD98cXJ4ebvS4vYaqwtEfv2fewDwhtSdDCnS+5Q==
X-Received: by 2002:a05:600c:1d05:b0:45d:d353:a491 with SMTP id 5b1f17b1804b1-46e711002damr58956945e9.1.1759691808297;
        Sun, 05 Oct 2025 12:16:48 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1518:6900:b69a:73e1:9698:9cd3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a4161bsm234287055e9.16.2025.10.05.12.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 12:16:47 -0700 (PDT)
Date: Sun, 5 Oct 2025 15:16:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 20/75] acpi/ghes: don't hard-code the number of sources for
 HEST table
Message-ID: <2c5a2616ed047e9d5e70970af5c4b2a54e9fa290.1759691708.git.mst@redhat.com>
References: <cover.1759691708.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1759691708.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

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
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <1698680848c11d6f26368426f1657e14faaf55c4.1758610789.git.mchehab+huawei@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/acpi/ghes.h   | 17 ++++++++++++-----
 hw/acpi/ghes.c           | 39 +++++++++++++++++++++------------------
 hw/arm/virt-acpi-build.c |  8 +++++++-
 target/arm/kvm.c         |  2 +-
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 5265102ba5..8c4b084337 100644
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
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 668ca72587..f49d0d628f 100644
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
index bbe83fab9a..c856d293c6 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -1125,6 +1125,10 @@ static void acpi_align_size(GArray *blob, unsigned align)
     g_array_set_size(blob, ROUND_UP(acpi_data_len(blob), align));
 }
 
+static const AcpiNotificationSourceId hest_ghes_notify[] = {
+    { ACPI_HEST_SRC_ID_SYNC, ACPI_GHES_NOTIFY_SEA },
+};
+
 static
 void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
 {
@@ -1189,7 +1193,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
         if (ags) {
             acpi_add_table(table_offsets, tables_blob);
             acpi_build_hest(ags, tables_blob, tables->hardware_errors,
-                            tables->linker, vms->oem_id, vms->oem_table_id);
+                            tables->linker, hest_ghes_notify,
+                            ARRAY_SIZE(hest_ghes_notify),
+                            vms->oem_id, vms->oem_table_id);
         }
     }
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 891d4fcde9..4f769d69b3 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2456,7 +2456,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SEA,
+                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC,
                                              paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
-- 
MST


