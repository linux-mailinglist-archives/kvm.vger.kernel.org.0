Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47BE3BF320
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhGHA7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:23555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhGHA6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168452"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168452"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770120"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 40/44] hw/i386: add a flag to disallow SMI
Date:   Wed,  7 Jul 2021 17:55:10 -0700
Message-Id: <ffab6a95d135612a81e3941002ee098108128268.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new flag to X86Machine to disallow SMI and pass it to ioapic creation
so that ioapic disallows delivery mode of SMI.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/microvm.c     |  6 ++++--
 hw/i386/pc_piix.c     |  3 ++-
 hw/i386/pc_q35.c      |  3 ++-
 hw/i386/x86.c         | 11 +++++++++--
 include/hw/i386/x86.h |  7 +++++--
 5 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 9b03d051ca..7504324891 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -175,10 +175,12 @@ static void microvm_devices_init(MicrovmMachineState *mms)
                           &error_abort);
     isa_bus_irqs(isa_bus, x86ms->gsi);
 
-    ioapic_init_gsi(gsi_state, "machine", x86ms->eoi_intercept_unsupported);
+    ioapic_init_gsi(gsi_state, "machine", x86ms->eoi_intercept_unsupported,
+                    x86ms->smi_unsupported);
     if (ioapics > 1) {
         x86ms->ioapic2 = ioapic_init_secondary(
-            gsi_state, x86ms->eoi_intercept_unsupported);
+            gsi_state, x86ms->eoi_intercept_unsupported,
+            x86ms->smi_unsupported);
     }
 
     kvmclock_create(true);
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index a601c4a916..0958035bf8 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -223,7 +223,8 @@ static void pc_init1(MachineState *machine,
     }
 
     if (pcmc->pci_enabled) {
-        ioapic_init_gsi(gsi_state, "i440fx", x86ms->eoi_intercept_unsupported);
+        ioapic_init_gsi(gsi_state, "i440fx", x86ms->eoi_intercept_unsupported,
+                        x86ms->smi_unsupported);
     }
 
     if (tcg_enabled()) {
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 464463766c..1ab8a6a78b 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -256,7 +256,8 @@ static void pc_q35_init(MachineState *machine)
     }
 
     if (pcmc->pci_enabled) {
-        ioapic_init_gsi(gsi_state, "q35", x86ms->eoi_intercept_unsupported);
+        ioapic_init_gsi(gsi_state, "q35", x86ms->eoi_intercept_unsupported,
+                        x86ms->smi_unsupported);
     }
 
     if (tcg_enabled()) {
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 88c365b72d..3dc36e3590 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -609,7 +609,8 @@ void gsi_handler(void *opaque, int n, int level)
 }
 
 void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name,
-                     bool level_trigger_unsupported)
+                     bool level_trigger_unsupported,
+                     bool smi_unsupported)
 {
     DeviceState *dev;
     SysBusDevice *d;
@@ -625,6 +626,8 @@ void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name,
                               "ioapic", OBJECT(dev));
     object_property_set_bool(OBJECT(dev), "level_trigger_unsupported",
                              level_trigger_unsupported, NULL);
+    object_property_set_bool(OBJECT(dev), "smi_unsupported",
+                             smi_unsupported, NULL);
     d = SYS_BUS_DEVICE(dev);
     sysbus_realize_and_unref(d, &error_fatal);
     sysbus_mmio_map(d, 0, IO_APIC_DEFAULT_ADDRESS);
@@ -635,7 +638,8 @@ void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name,
 }
 
 DeviceState *ioapic_init_secondary(GSIState *gsi_state,
-                                   bool level_trigger_unsupported)
+                                   bool level_trigger_unsupported,
+                                   bool smi_unsupported)
 {
     DeviceState *dev;
     SysBusDevice *d;
@@ -644,6 +648,8 @@ DeviceState *ioapic_init_secondary(GSIState *gsi_state,
     dev = qdev_new(TYPE_IOAPIC);
     object_property_set_bool(OBJECT(dev), "level_trigger_unsupported",
                              level_trigger_unsupported, NULL);
+    object_property_set_bool(OBJECT(dev), "smi_unsupported",
+                             smi_unsupported, NULL);
     d = SYS_BUS_DEVICE(dev);
     sysbus_realize_and_unref(d, &error_fatal);
     sysbus_mmio_map(d, 0, IO_APIC_SECONDARY_ADDRESS);
@@ -1318,6 +1324,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->eoi_intercept_unsupported = false;
+    x86ms->smi_unsupported = false;
 
     object_property_add_str(obj, "kvm-type",
                             x86_get_kvm_type, x86_set_kvm_type);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 7536e5fb8c..3d1d74d171 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -64,6 +64,7 @@ struct X86MachineState {
     unsigned apic_id_limit;
     uint16_t boot_cpus;
     bool eoi_intercept_unsupported;
+    bool smi_unsupported;
 
     OnOffAuto smm;
     OnOffAuto acpi;
@@ -141,8 +142,10 @@ typedef struct GSIState {
 qemu_irq x86_allocate_cpu_irq(void);
 void gsi_handler(void *opaque, int n, int level);
 void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name,
-                     bool eoi_intercept_unsupported);
+                     bool eoi_intercept_unsupported,
+                     bool smi_unsupported);
 DeviceState *ioapic_init_secondary(GSIState *gsi_state,
-                                   bool eoi_intercept_unsupported);
+                                   bool eoi_intercept_unsupported,
+                                   bool smi_unsupported);
 
 #endif
-- 
2.25.1

