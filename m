Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E63BF323
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhGHA7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:23557 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhGHA6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168450"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168450"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770114"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:59 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 38/44] hw/i386: plug eoi_intercept_unsupported to ioapic
Date:   Wed,  7 Jul 2021 17:55:08 -0700
Message-Id: <f4276b88405e4fe9eefbfd7a19f621f168dad6e2.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When x86machine doesn't support eoi intercept, set
level_trigger_unsupported property of ioapic to true so that ioapic doesn't
accept configuration to use level trigger.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/microvm.c     |  5 +++--
 hw/i386/pc_piix.c     |  2 +-
 hw/i386/pc_q35.c      |  2 +-
 hw/i386/x86.c         | 10 ++++++++--
 include/hw/i386/x86.h |  6 ++++--
 5 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index aba0c83219..9b03d051ca 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -175,9 +175,10 @@ static void microvm_devices_init(MicrovmMachineState *mms)
                           &error_abort);
     isa_bus_irqs(isa_bus, x86ms->gsi);
 
-    ioapic_init_gsi(gsi_state, "machine");
+    ioapic_init_gsi(gsi_state, "machine", x86ms->eoi_intercept_unsupported);
     if (ioapics > 1) {
-        x86ms->ioapic2 = ioapic_init_secondary(gsi_state);
+        x86ms->ioapic2 = ioapic_init_secondary(
+            gsi_state, x86ms->eoi_intercept_unsupported);
     }
 
     kvmclock_create(true);
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 4c1e31f180..a601c4a916 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -223,7 +223,7 @@ static void pc_init1(MachineState *machine,
     }
 
     if (pcmc->pci_enabled) {
-        ioapic_init_gsi(gsi_state, "i440fx");
+        ioapic_init_gsi(gsi_state, "i440fx", x86ms->eoi_intercept_unsupported);
     }
 
     if (tcg_enabled()) {
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 106f5726cc..464463766c 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -256,7 +256,7 @@ static void pc_q35_init(MachineState *machine)
     }
 
     if (pcmc->pci_enabled) {
-        ioapic_init_gsi(gsi_state, "q35");
+        ioapic_init_gsi(gsi_state, "q35", x86ms->eoi_intercept_unsupported);
     }
 
     if (tcg_enabled()) {
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 9862fe5bc9..88c365b72d 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -608,7 +608,8 @@ void gsi_handler(void *opaque, int n, int level)
     }
 }
 
-void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name)
+void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name,
+                     bool level_trigger_unsupported)
 {
     DeviceState *dev;
     SysBusDevice *d;
@@ -622,6 +623,8 @@ void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name)
     }
     object_property_add_child(object_resolve_path(parent_name, NULL),
                               "ioapic", OBJECT(dev));
+    object_property_set_bool(OBJECT(dev), "level_trigger_unsupported",
+                             level_trigger_unsupported, NULL);
     d = SYS_BUS_DEVICE(dev);
     sysbus_realize_and_unref(d, &error_fatal);
     sysbus_mmio_map(d, 0, IO_APIC_DEFAULT_ADDRESS);
@@ -631,13 +634,16 @@ void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name)
     }
 }
 
-DeviceState *ioapic_init_secondary(GSIState *gsi_state)
+DeviceState *ioapic_init_secondary(GSIState *gsi_state,
+                                   bool level_trigger_unsupported)
 {
     DeviceState *dev;
     SysBusDevice *d;
     unsigned int i;
 
     dev = qdev_new(TYPE_IOAPIC);
+    object_property_set_bool(OBJECT(dev), "level_trigger_unsupported",
+                             level_trigger_unsupported, NULL);
     d = SYS_BUS_DEVICE(dev);
     sysbus_realize_and_unref(d, &error_fatal);
     sysbus_mmio_map(d, 0, IO_APIC_SECONDARY_ADDRESS);
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 6eff42550f..7536e5fb8c 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -140,7 +140,9 @@ typedef struct GSIState {
 
 qemu_irq x86_allocate_cpu_irq(void);
 void gsi_handler(void *opaque, int n, int level);
-void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name);
-DeviceState *ioapic_init_secondary(GSIState *gsi_state);
+void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name,
+                     bool eoi_intercept_unsupported);
+DeviceState *ioapic_init_secondary(GSIState *gsi_state,
+                                   bool eoi_intercept_unsupported);
 
 #endif
-- 
2.25.1

