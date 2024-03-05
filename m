Return-Path: <kvm+bounces-10989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 582C487208F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C45791F250C6
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA3685C7B;
	Tue,  5 Mar 2024 13:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="an7nzRRG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDD85676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646182; cv=none; b=mjkyLHBM4tV+hqwsPEHUlwO9vWFvK1CbvxQcgVA3Sy6TBx6wjEXcpKyljw/a6xr/XhH7ocSazYX8EE3XoPKR4Yeo/RjWgyAMn396eMs9nOjnAmfBu9LDczGHo8hQ471hY5QAjC5zZv7/5t69MxymkFWAuvXQeCXVzysOSsJUwjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646182; c=relaxed/simple;
	bh=62dsR2/qTVriqw72MWy5pDibfLhl1iF8csUOZ4rt08Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7w7OK5k2hu4mUydSI9XFeT11+gdusyA28IWBvfzGGKp29hs9av2JBW9YLxYNizCxxJgNGCvnM7R8CFyzuvcxJRk2sDea7I/C0rVE9S7IQSBSWwI63ez0ngW4QaLGi/FccQdSxog8VD0drJ79UNozd2jOLsqFFLEuBFV55E2raQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=an7nzRRG; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5640fef9fa6so6950001a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646179; x=1710250979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6j3vsQkgHjlqXgYSK7hYcuXtUupY0HchuWejne43RQ=;
        b=an7nzRRGV3uVcFY8xddW6AmKgW0P8F475T5P/44pADzc1xo6uNVgj3HJiwuvGRjDFt
         VSjz/mgH7j+akVQ8yl/UGsedGEvzVIgc+9d5PA5yeAWdU8f8iZEgTKBd9PAofU+9hh0G
         bWtXk8Cg3Ea938r1Q4meXl+U4vV8ToyzKksWZ+I6DdkL0MDrYzN73nF4HNCji7GjlgpL
         mNEnE6ub3LKofT/Z/LsODlXK6QteQYGfh/Pxmvy7XUjh6eg8Hqve60DwG3SCvQImQ/P4
         EzJumNEgnH1L4vtp5kpReDKA1FzIhz7dsbErz/UhyQ8B+KFr4+kTagGLfpdwVYBFwrPM
         DAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646179; x=1710250979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6j3vsQkgHjlqXgYSK7hYcuXtUupY0HchuWejne43RQ=;
        b=Y0Gu/YMj3ZaSntVMQk2kSzW4moZ+9/zKqkIY0sNnrPFJArJkefb/0oslxEIeF41m0K
         OjqQwSpE13lAfs3kVbAZceIQ0BK4TdxrBIG/anPTvk1IZpSwqExTWH4Jn858ZpE+UOfg
         jOsLw8XGOj+1kcPOQiYoP/Z2ZH87GGTtR4oJse3Jm32ST945Iim+z/UFvjXRAqMtMVYX
         wucS0h0D/jIx0ukTMk4hyzyybxTrcC5sTUJWz4LJPL95qqkN0J0vHzBn2/XGaCoqO2XY
         U2eOKcs7MAXTJqqGaDiDVNGaHFFbAGrks06hZCnVl1x+3Qi10sZfJ58w9a3jLSk2KT4i
         Kntw==
X-Forwarded-Encrypted: i=1; AJvYcCXJPMjq82eSpcIOv0OXa0rafyhgjr3RJIY6XznAq+bztziuviKx3BBY/ZQQZj6FtuJHQu5tOtsOeWc9SHOhm277+obu
X-Gm-Message-State: AOJu0YzfjAga72rdJzGZcwvXxzDoJViA9wwHjGaCNX/DRAIRv1toFovy
	7wLzsEbXV+3ZUQg3jewuZzoTeLuQphrSCS8/jYBVS74FiQEjF2o4n2NcH4IKjgQ=
X-Google-Smtp-Source: AGHT+IFbWNyURA+FceZTD6yItwbOnb08ix3nn/dgtrYLs3f5Fy0iPr8irxrkPsFNRKIP2au/om3Y3Q==
X-Received: by 2002:a05:6402:2152:b0:566:ef8:a81a with SMTP id bq18-20020a056402215200b005660ef8a81amr9346231edb.7.1709646179007;
        Tue, 05 Mar 2024 05:42:59 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id ev16-20020a056402541000b0055d333a0584sm5846620edb.72.2024.03.05.05.42.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:42:58 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH-for-9.1 05/18] hw/i386/acpi: Remove PCMachineClass::legacy_acpi_table_size
Date: Tue,  5 Mar 2024 14:42:07 +0100
Message-ID: <20240305134221.30924-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

PCMachineClass::legacy_acpi_table_size was only used by the
pc-i440fx-2.0 machine, which got removed. Remove it and simplify
acpi_build().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/pc.h |  1 -
 hw/i386/acpi-build.c | 60 +++++++++-----------------------------------
 2 files changed, 12 insertions(+), 49 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 3360ca2307..758d670a36 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -103,7 +103,6 @@ struct PCMachineClass {
     /* ACPI compat: */
     bool has_acpi_build;
     bool rsdp_in_ram;
-    int legacy_acpi_table_size;
     unsigned acpi_data_size;
     int pci_root_uid;
 
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 15242b9096..8c7fad92e9 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -2496,13 +2496,12 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
     X86MachineState *x86ms = X86_MACHINE(machine);
     DeviceState *iommu = pcms->iommu;
     GArray *table_offsets;
-    unsigned facs, dsdt, rsdt, fadt;
+    unsigned facs, dsdt, rsdt;
     AcpiPmInfo pm;
     AcpiMiscInfo misc;
     AcpiMcfgInfo mcfg;
     Range pci_hole = {}, pci_hole64 = {};
     uint8_t *u;
-    size_t aml_len = 0;
     GArray *tables_blob = tables->table_data;
     AcpiSlicOem slic_oem = { .id = NULL, .table_id = NULL };
     Object *vmgenid_dev;
@@ -2548,19 +2547,12 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
     build_dsdt(tables_blob, tables->linker, &pm, &misc,
                &pci_hole, &pci_hole64, machine);
 
-    /* Count the size of the DSDT and SSDT, we will need it for legacy
-     * sizing of ACPI tables.
-     */
-    aml_len += tables_blob->len - dsdt;
-
     /* ACPI tables pointed to by RSDT */
-    fadt = tables_blob->len;
     acpi_add_table(table_offsets, tables_blob);
     pm.fadt.facs_tbl_offset = &facs;
     pm.fadt.dsdt_tbl_offset = &dsdt;
     pm.fadt.xdsdt_tbl_offset = &dsdt;
     build_fadt(tables_blob, tables->linker, &pm.fadt, oem_id, oem_table_id);
-    aml_len += tables_blob->len - fadt;
 
     acpi_add_table(table_offsets, tables_blob);
     acpi_build_madt(tables_blob, tables->linker, x86ms,
@@ -2691,49 +2683,21 @@ void acpi_build(AcpiBuildTables *tables, MachineState *machine)
      * too simple to be enough.  4k turned out to be too small an
      * alignment very soon, and in fact it is almost impossible to
      * keep the table size stable for all (max_cpus, max_memory_slots)
-     * combinations.  So the table size is always 64k for pc-i440fx-2.1
-     * and we give an error if the table grows beyond that limit.
-     *
-     * We still have the problem of migrating from "-M pc-i440fx-2.0".  For
-     * that, we exploit the fact that QEMU 2.1 generates _smaller_ tables
-     * than 2.0 and we can always pad the smaller tables with zeros.  We can
-     * then use the exact size of the 2.0 tables.
+     * combinations.
      *
      * All this is for PIIX4, since QEMU 2.0 didn't support Q35 migration.
      */
-    if (pcmc->legacy_acpi_table_size) {
-        /* Subtracting aml_len gives the size of fixed tables.  Then add the
-         * size of the PIIX4 DSDT/SSDT in QEMU 2.0.
-         */
-        int legacy_aml_len =
-            pcmc->legacy_acpi_table_size +
-            ACPI_BUILD_LEGACY_CPU_AML_SIZE * x86ms->apic_id_limit;
-        int legacy_table_size =
-            ROUND_UP(tables_blob->len - aml_len + legacy_aml_len,
-                     ACPI_BUILD_ALIGN_SIZE);
-        if ((tables_blob->len > legacy_table_size) &&
-            !pcmc->resizable_acpi_blob) {
-            /* Should happen only with PCI bridges and -M pc-i440fx-2.0.  */
-            warn_report("ACPI table size %u exceeds %d bytes,"
-                        " migration may not work",
-                        tables_blob->len, legacy_table_size);
-            error_printf("Try removing CPUs, NUMA nodes, memory slots"
-                         " or PCI bridges.\n");
-        }
-        g_array_set_size(tables_blob, legacy_table_size);
-    } else {
-        /* Make sure we have a buffer in case we need to resize the tables. */
-        if ((tables_blob->len > ACPI_BUILD_TABLE_SIZE / 2) &&
-            !pcmc->resizable_acpi_blob) {
-            /* As of QEMU 2.1, this fires with 160 VCPUs and 255 memory slots.  */
-            warn_report("ACPI table size %u exceeds %d bytes,"
-                        " migration may not work",
-                        tables_blob->len, ACPI_BUILD_TABLE_SIZE / 2);
-            error_printf("Try removing CPUs, NUMA nodes, memory slots"
-                         " or PCI bridges.\n");
-        }
-        acpi_align_size(tables_blob, ACPI_BUILD_TABLE_SIZE);
+    /* Make sure we have a buffer in case we need to resize the tables. */
+    if ((tables_blob->len > ACPI_BUILD_TABLE_SIZE / 2) &&
+        !pcmc->resizable_acpi_blob) {
+        /* As of QEMU 2.1, this fires with 160 VCPUs and 255 memory slots.  */
+        warn_report("ACPI table size %u exceeds %d bytes,"
+                    " migration may not work",
+                    tables_blob->len, ACPI_BUILD_TABLE_SIZE / 2);
+        error_printf("Try removing CPUs, NUMA nodes, memory slots"
+                     " or PCI bridges.\n");
     }
+    acpi_align_size(tables_blob, ACPI_BUILD_TABLE_SIZE);
 
     acpi_align_size(tables->linker->cmd_blob, ACPI_BUILD_ALIGN_SIZE);
 
-- 
2.41.0


