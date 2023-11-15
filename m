Return-Path: <kvm+bounces-1792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CC87EBDF6
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9ADD281472
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0BE946F;
	Wed, 15 Nov 2023 07:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lRfSU9gw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD21611A
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:23:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E868E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700033030; x=1731569030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0g9dnthujLNyHxHfMoax2e4P1EjpI+iQbJ17gbkKV6I=;
  b=lRfSU9gwzuSZ2nbF7TDOEpII90g0NkXl/rD7+jvs3FRqVRmgHVqIaYqA
   lnXsHf0Idmq6aC5cdJb3WM6isDPmtsK20W6DyYZinuHlLIqS3EEtHjhlH
   35uS/296HG3QZIHwj6dnzELHru+aJANATHklbYG3wRbrj1W0diVpZvZB3
   aOHiyk2TvXmLr0bBQuin71ggE6gFBC5vt0JgQHTn3dE7QXiHQOEfgvewK
   lycRBE9itHNEi8OvtOja77DiJNu8/MAeYEJ+PLKEjXxP1zkR9D2VzLO7i
   F7B7xy/AQY/exdCuPKblJrFagB9g+6A/KgYN+c6HxBcAsDyyGWVLoAuwA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623674"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623674"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:23:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800434"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800434"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:23:43 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 65/70] hw/i386: add option to forcibly report edge trigger in acpi tables
Date: Wed, 15 Nov 2023 02:15:14 -0500
Message-Id: <20231115071519.2864957-66-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

When level trigger isn't supported on x86 platform,
forcibly report edge trigger in acpi tables.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/acpi-build.c  | 99 ++++++++++++++++++++++++++++---------------
 hw/i386/acpi-common.c | 50 ++++++++++++++++------
 2 files changed, 104 insertions(+), 45 deletions(-)

diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 80db183b786a..23df7163e5e7 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -975,7 +975,8 @@ static void build_dbg_aml(Aml *table)
     aml_append(table, scope);
 }
 
-static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
+static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg,
+                           bool level_trigger_unsupported)
 {
     Aml *dev;
     Aml *crs;
@@ -987,7 +988,10 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
     aml_append(dev, aml_name_decl("_UID", aml_int(uid)));
 
     crs = aml_resource_template();
-    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
+    aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                  level_trigger_unsupported ?
+                                  AML_EDGE : AML_LEVEL,
+                                  AML_ACTIVE_HIGH,
                                   AML_SHARED, irqs, ARRAY_SIZE(irqs)));
     aml_append(dev, aml_name_decl("_PRS", crs));
 
@@ -1011,7 +1015,8 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
     return dev;
  }
 
-static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
+static Aml *build_gsi_link_dev(const char *name, uint8_t uid,
+                               uint8_t gsi, bool level_trigger_unsupported)
 {
     Aml *dev;
     Aml *crs;
@@ -1024,7 +1029,10 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
 
     crs = aml_resource_template();
     irqs = gsi;
-    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
+    aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                  level_trigger_unsupported ?
+                                  AML_EDGE : AML_LEVEL,
+                                  AML_ACTIVE_HIGH,
                                   AML_SHARED, &irqs, 1));
     aml_append(dev, aml_name_decl("_PRS", crs));
 
@@ -1043,7 +1051,7 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
 }
 
 /* _CRS method - get current settings */
-static Aml *build_iqcr_method(bool is_piix4)
+static Aml *build_iqcr_method(bool is_piix4, bool level_trigger_unsupported)
 {
     Aml *if_ctx;
     uint32_t irqs;
@@ -1051,7 +1059,9 @@ static Aml *build_iqcr_method(bool is_piix4)
     Aml *crs = aml_resource_template();
 
     irqs = 0;
-    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
+    aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                  level_trigger_unsupported ?
+                                  AML_EDGE : AML_LEVEL,
                                   AML_ACTIVE_HIGH, AML_SHARED, &irqs, 1));
     aml_append(method, aml_name_decl("PRR0", crs));
 
@@ -1085,7 +1095,7 @@ static Aml *build_irq_status_method(void)
     return method;
 }
 
-static void build_piix4_pci0_int(Aml *table)
+static void build_piix4_pci0_int(Aml *table, bool level_trigger_unsupported)
 {
     Aml *dev;
     Aml *crs;
@@ -1098,12 +1108,16 @@ static void build_piix4_pci0_int(Aml *table)
     aml_append(sb_scope, pci0_scope);
 
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
@@ -1112,7 +1126,9 @@ static void build_piix4_pci0_int(Aml *table)
 
         crs = aml_resource_template();
         irqs = 9;
-        aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
+        aml_append(crs, aml_interrupt(AML_CONSUMER,
+                                      level_trigger_unsupported ?
+                                      AML_EDGE : AML_LEVEL,
                                       AML_ACTIVE_HIGH, AML_SHARED,
                                       &irqs, 1));
         aml_append(dev, aml_name_decl("_PRS", crs));
@@ -1198,7 +1214,7 @@ static Aml *build_q35_routing_table(const char *str)
     return pkg;
 }
 
-static void build_q35_pci0_int(Aml *table)
+static void build_q35_pci0_int(Aml *table, bool level_trigger_unsupported)
 {
     Aml *method;
     Aml *sb_scope = aml_scope("_SB");
@@ -1237,25 +1253,41 @@ static void build_q35_pci0_int(Aml *table)
     aml_append(sb_scope, pci0_scope);
 
     aml_append(sb_scope, build_irq_status_method());
-    aml_append(sb_scope, build_iqcr_method(false));
+    aml_append(sb_scope, build_iqcr_method(false, level_trigger_unsupported));
 
-    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA")));
-    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB")));
-    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC")));
-    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD")));
-    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE")));
-    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF")));
-    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG")));
-    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH")));
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
 
-    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10));
-    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11));
-    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12));
-    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13));
-    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14));
-    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15));
-    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16));
-    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17));
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
@@ -1436,6 +1468,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
     PCMachineState *pcms = PC_MACHINE(machine);
     PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(machine);
     X86MachineState *x86ms = X86_MACHINE(machine);
+    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
     AcpiMcfgInfo mcfg;
     bool mcfg_valid = !!acpi_get_mcfg(&mcfg);
     uint32_t nr_mem = machine->ram_slots;
@@ -1468,7 +1501,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
         if (pm->pcihp_bridge_en || pm->pcihp_root_en) {
             build_x86_acpi_pci_hotplug(dsdt, pm->pcihp_io_base);
         }
-        build_piix4_pci0_int(dsdt);
+        build_piix4_pci0_int(dsdt, level_trigger_unsupported);
     } else if (q35) {
         sb_scope = aml_scope("_SB");
         dev = aml_device("PCI0");
@@ -1512,7 +1545,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
         if (pm->pcihp_bridge_en) {
             build_x86_acpi_pci_hotplug(dsdt, pm->pcihp_io_base);
         }
-        build_q35_pci0_int(dsdt);
+        build_q35_pci0_int(dsdt, level_trigger_unsupported);
     }
 
     if (misc->has_hpet) {
diff --git a/hw/i386/acpi-common.c b/hw/i386/acpi-common.c
index 43dc23f7e06f..26ff3c738e78 100644
--- a/hw/i386/acpi-common.c
+++ b/hw/i386/acpi-common.c
@@ -103,6 +103,7 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
     const CPUArchIdList *apic_ids = mc->possible_cpu_arch_ids(MACHINE(x86ms));
     AcpiTable table = { .sig = "APIC", .rev = 3, .oem_id = oem_id,
                         .oem_table_id = oem_table_id };
+    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
 
     acpi_table_begin(&table, table_data);
     /* Local APIC Address */
@@ -122,18 +123,43 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
                      IO_APIC_SECONDARY_ADDRESS, IO_APIC_SECONDARY_IRQBASE);
     }
 
-    if (x86ms->apic_xrupt_override) {
-        build_xrupt_override(table_data, 0, 2,
-            0 /* Flags: Conforms to the specifications of the bus */);
-    }
-
-    for (i = 1; i < 16; i++) {
-        if (!(x86ms->pci_irq_mask & (1 << i))) {
-            /* No need for a INT source override structure. */
-            continue;
-        }
-        build_xrupt_override(table_data, i, i,
-            0xd /* Flags: Active high, Level Triggered */);
+    if (level_trigger_unsupported) {
+        /* Force edge trigger */
+        if (x86ms->apic_xrupt_override) {
+            build_xrupt_override(table_data, 0, 2,
+                                 /* Flags: active high, edge triggered */
+                                 1 | (1 << 2));
+        }
+
+        for (i = x86ms->apic_xrupt_override ? 1 : 0; i < 16; i++) {
+            build_xrupt_override(table_data, i, i,
+                                 /* Flags: active high, edge triggered */
+                                 1 | (1 << 2));
+        }
+
+        if (x86ms->ioapic2) {
+            for (i = 0; i < 16; i++) {
+                build_xrupt_override(table_data, IO_APIC_SECONDARY_IRQBASE + i,
+                                     IO_APIC_SECONDARY_IRQBASE + i,
+                                     /* Flags: active high, edge triggered */
+                                     1 | (1 << 2));
+            }
+        }
+    } else {
+        if (x86ms->apic_xrupt_override) {
+            build_xrupt_override(table_data, 0, 2,
+                                 0 /* Flags: Conforms to the specifications of the bus */);
+        }
+
+        for (i = 1; i < 16; i++) {
+            if (!(x86ms->pci_irq_mask & (1 << i))) {
+                /* No need for a INT source override structure. */
+                continue;
+            }
+            build_xrupt_override(table_data, i, i,
+                                 0xd /* Flags: Active high, Level Triggered */);
+
+        }
     }
 
     if (x2apic_mode) {
-- 
2.34.1


