Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185E43BF321
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhGHA7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:23557 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhGHA6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168449"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168449"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770111"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 37/44] hw/i386: add option to forcibly report edge trigger in acpi tables
Date:   Wed,  7 Jul 2021 17:55:07 -0700
Message-Id: <7348b3dd8450923bba9b52e6705bdce477197bef.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When level trigger isn't supported on x86 platform, forcibly report edge
trigger in acpi tables.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/acpi-build.c  | 103 ++++++++++++++++++++++++++++--------------
 hw/i386/acpi-common.c |  74 ++++++++++++++++++++++--------
 2 files changed, 124 insertions(+), 53 deletions(-)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 796ffc6f5c..d0d52258b9 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -866,7 +866,8 @@ static void build_dbg_aml(Aml *table)
     aml_append(table, scope);
 }
 
-static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
+static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg,
+                           bool level_trigger_unsupported)
 {
     Aml *dev;
     Aml *crs;
@@ -878,7 +879,10 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
     aml_append(dev, aml_name_decl("_UID", aml_int(uid)));
 
     crs = aml_resource_template();
-    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
+    aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                  level_trigger_unsupported ?
+                                  AML_EDGE : AML_LEVEL,
+                                  AML_ACTIVE_HIGH,
                                   AML_SHARED, irqs, ARRAY_SIZE(irqs)));
     aml_append(dev, aml_name_decl("_PRS", crs));
 
@@ -902,7 +906,8 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
     return dev;
  }
 
-static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
+static Aml *build_gsi_link_dev(const char *name, uint8_t uid,
+                               uint8_t gsi, bool level_trigger_unsupported)
 {
     Aml *dev;
     Aml *crs;
@@ -915,7 +920,10 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
 
     crs = aml_resource_template();
     irqs = gsi;
-    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
+    aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                  level_trigger_unsupported ?
+                                  AML_EDGE : AML_LEVEL,
+                                  AML_ACTIVE_HIGH,
                                   AML_SHARED, &irqs, 1));
     aml_append(dev, aml_name_decl("_PRS", crs));
 
@@ -934,7 +942,7 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
 }
 
 /* _CRS method - get current settings */
-static Aml *build_iqcr_method(bool is_piix4)
+static Aml *build_iqcr_method(bool is_piix4, bool level_trigger_unsupported)
 {
     Aml *if_ctx;
     uint32_t irqs;
@@ -942,7 +950,9 @@ static Aml *build_iqcr_method(bool is_piix4)
     Aml *crs = aml_resource_template();
 
     irqs = 0;
-    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
+    aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                  level_trigger_unsupported ?
+                                  AML_EDGE : AML_LEVEL,
                                   AML_ACTIVE_HIGH, AML_SHARED, &irqs, 1));
     aml_append(method, aml_name_decl("PRR0", crs));
 
@@ -976,7 +986,7 @@ static Aml *build_irq_status_method(void)
     return method;
 }
 
-static void build_piix4_pci0_int(Aml *table)
+static void build_piix4_pci0_int(Aml *table, bool level_trigger_unsupported)
 {
     Aml *dev;
     Aml *crs;
@@ -997,12 +1007,16 @@ static void build_piix4_pci0_int(Aml *table)
     aml_append(sb_scope, field);
 
     aml_append(sb_scope, build_irq_status_method());
-    aml_append(sb_scope, build_iqcr_method(true));
+    aml_append(sb_scope, build_iqcr_method(true, level_trigger_unsupported));
 
-    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQ0")));
-    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQ1")));
-    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQ2")));
-    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQ3")));
+    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQ0"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQ1"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQ2"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQ3"),
+                                        level_trigger_unsupported));
 
     dev = aml_device("LNKS");
     {
@@ -1011,7 +1025,9 @@ static void build_piix4_pci0_int(Aml *table)
 
         crs = aml_resource_template();
         irqs = 9;
-        aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
+        aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                      level_trigger_unsupported ?
+                                      AML_EDGE : AML_LEVEL,
                                       AML_ACTIVE_HIGH, AML_SHARED,
                                       &irqs, 1));
         aml_append(dev, aml_name_decl("_PRS", crs));
@@ -1097,7 +1113,7 @@ static Aml *build_q35_routing_table(const char *str)
     return pkg;
 }
 
-static void build_q35_pci0_int(Aml *table)
+static void build_q35_pci0_int(Aml *table, bool level_trigger_unsupported)
 {
     Aml *field;
     Aml *method;
@@ -1149,25 +1165,41 @@ static void build_q35_pci0_int(Aml *table)
     aml_append(sb_scope, field);
 
     aml_append(sb_scope, build_irq_status_method());
-    aml_append(sb_scope, build_iqcr_method(false));
-
-    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA")));
-    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB")));
-    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC")));
-    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD")));
-    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE")));
-    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF")));
-    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG")));
-    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH")));
-
-    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10));
-    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11));
-    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12));
-    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13));
-    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14));
-    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15));
-    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16));
-    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17));
+    aml_append(sb_scope, build_iqcr_method(false, level_trigger_unsupported));
+
+    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG"),
+                                        level_trigger_unsupported));
+    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH"),
+                                        level_trigger_unsupported));
+
+    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16,
+                                            level_trigger_unsupported));
+    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17,
+                                            level_trigger_unsupported));
 
     aml_append(table, sb_scope);
 }
@@ -1370,6 +1402,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
     PCMachineState *pcms = PC_MACHINE(machine);
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(machine);
     X86MachineState *x86ms = X86_MACHINE(machine);
+    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
     AcpiMcfgInfo mcfg;
     bool mcfg_valid = !!acpi_get_mcfg(&mcfg);
     uint32_t nr_mem = machine->ram_slots;
@@ -1404,7 +1437,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
         if (pm->pcihp_bridge_en || pm->pcihp_root_en) {
             build_piix4_pci_hotplug(dsdt);
         }
-        build_piix4_pci0_int(dsdt);
+        build_piix4_pci0_int(dsdt, level_trigger_unsupported);
     } else {
         sb_scope = aml_scope("_SB");
         dev = aml_device("PCI0");
@@ -1450,7 +1483,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
         }
         build_q35_isa_bridge(dsdt);
         build_isa_devices_aml(dsdt);
-        build_q35_pci0_int(dsdt);
+        build_q35_pci0_int(dsdt, level_trigger_unsupported);
         if (pcms->smbus && !pcmc->do_not_add_smb_acpi) {
             build_smb0(dsdt, pcms->smbus, ICH9_SMB_DEV, ICH9_SMB_FUNC);
         }
diff --git a/hw/i386/acpi-common.c b/hw/i386/acpi-common.c
index 1f5947fcf9..90cb05a46d 100644
--- a/hw/i386/acpi-common.c
+++ b/hw/i386/acpi-common.c
@@ -80,6 +80,7 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
     int madt_start = table_data->len;
     AcpiDeviceIfClass *adevc = ACPI_DEVICE_IF_GET_CLASS(adev);
     bool x2apic_mode = false;
+    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
 
     AcpiMultipleApicTable *madt;
     AcpiMadtIoApic *io_apic;
@@ -114,26 +115,63 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
         io_apic2->interrupt = cpu_to_le32(IO_APIC_SECONDARY_IRQBASE);
     }
 
-    if (x86ms->apic_xrupt_override) {
-        intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
-        intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
-        intsrcovr->length = sizeof(*intsrcovr);
-        intsrcovr->source = 0;
-        intsrcovr->gsi    = cpu_to_le32(2);
-        intsrcovr->flags  = cpu_to_le16(0); /* conforms to bus specifications */
-    }
+    if (level_trigger_unsupported) {
+        /* Force edge trigger */
+        if (x86ms->apic_xrupt_override) {
+            intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
+            intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
+            intsrcovr->length = sizeof(*intsrcovr);
+            intsrcovr->source = 0;
+            intsrcovr->gsi    = cpu_to_le32(2);
+            /* active high, edge triggered */
+            intsrcovr->flags  = cpu_to_le16(1 | (1 << 2));
+        }
+
+        for (i = x86ms->apic_xrupt_override ? 1 : 0; i < 16; i++) {
+            intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
+            intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
+            intsrcovr->length = sizeof(*intsrcovr);
+            intsrcovr->source = i;
+            intsrcovr->gsi    = cpu_to_le32(i);
+            /* active high, edge triggered */
+            intsrcovr->flags  = cpu_to_le16(1 | (1 << 2));
+        }
+
+        if (x86ms->ioapic2) {
+            for (i = 0; i < 16; i++) {
+                intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
+                intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
+                intsrcovr->length = sizeof(*intsrcovr);
+                intsrcovr->source = IO_APIC_SECONDARY_IRQBASE + i;
+                intsrcovr->gsi    = cpu_to_le32(IO_APIC_SECONDARY_IRQBASE + i);
+                /* active high, edge triggered */
+                intsrcovr->flags  = cpu_to_le16(1 | (1 << 2));
+            }
+        }
+    } else {
+        if (x86ms->apic_xrupt_override) {
+            intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
+            intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
+            intsrcovr->length = sizeof(*intsrcovr);
+            intsrcovr->source = 0;
+            intsrcovr->gsi    = cpu_to_le32(2);
+            /* conforms to bus specifications */
+            intsrcovr->flags  = cpu_to_le16(0);
+        }
 
-    for (i = 1; i < 16; i++) {
-        if (!(x86ms->pci_irq_mask & (1 << i))) {
-            /* No need for a INT source override structure. */
-            continue;
+        for (i = 1; i < 16; i++) {
+            if (!(x86ms->pci_irq_mask & (1 << i))) {
+                /* No need for a INT source override structure. */
+                continue;
+            }
+            intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
+            intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
+            intsrcovr->length = sizeof(*intsrcovr);
+            intsrcovr->source = i;
+            intsrcovr->gsi    = cpu_to_le32(i);
+            /* active high, level triggered */
+            intsrcovr->flags  = cpu_to_le16(0xd);
         }
-        intsrcovr = acpi_data_push(table_data, sizeof *intsrcovr);
-        intsrcovr->type   = ACPI_APIC_XRUPT_OVERRIDE;
-        intsrcovr->length = sizeof(*intsrcovr);
-        intsrcovr->source = i;
-        intsrcovr->gsi    = cpu_to_le32(i);
-        intsrcovr->flags  = cpu_to_le16(0xd); /* active high, level triggered */
     }
 
     if (x2apic_mode) {
-- 
2.25.1

