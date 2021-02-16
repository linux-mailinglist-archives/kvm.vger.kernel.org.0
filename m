Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE131C556
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhBPCQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:16:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:63533 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhBPCQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:16:04 -0500
IronPort-SDR: elptBxOQuH2FnjQwZfqzYMmayspVYqVR67/JXezWuLYRTGpqgcWKnih0D7aRNDYzOIGdxPiHak
 vXjBXmYMo+1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="170454371"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="170454371"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:54 -0800
IronPort-SDR: sgFYJihCG3Low2pGfY8Y9Msmd0NIKiCT1BKPUKAJ2IITt/1H9l1AYN0rn5GzN52ISwVhYXeAfp
 8qelepet7r3w==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705457"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:54 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 23/23] target/i386: Add machine option to disable PIC/8259
Date:   Mon, 15 Feb 2021 18:13:19 -0800
Message-Id: <594a1420065737aa10c872878c303f82666e2870.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a machine option to disable the legacy PIC (8259), which cannot be
supported for TDX guests as TDX-SEAM doesn't allow directly interrupt
injection.  Using posted interrupts for the PIC is not a viable option
as the guest BIOS/kernel will not do EOI for PIC IRQs, i.e. will leave
the vIRR bit set.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/pc.c         | 18 ++++++++++++++++++
 hw/i386/pc_piix.c    |  4 +++-
 hw/i386/pc_q35.c     |  4 +++-
 include/hw/i386/pc.h |  2 ++
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 8aa85dec54..12d44659bf 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1532,6 +1532,20 @@ static void pc_machine_set_hpet(Object *obj, bool value, Error **errp)
     pcms->hpet_enabled = value;
 }
 
+static bool pc_machine_get_pic(Object *obj, Error **errp)
+{
+    PCMachineState *pcms = PC_MACHINE(obj);
+
+    return pcms->pic_enabled;
+}
+
+static void pc_machine_set_pic(Object *obj, bool value, Error **errp)
+{
+    PCMachineState *pcms = PC_MACHINE(obj);
+
+    pcms->pic_enabled = value;
+}
+
 static void pc_machine_get_max_ram_below_4g(Object *obj, Visitor *v,
                                             const char *name, void *opaque,
                                             Error **errp)
@@ -1672,6 +1686,7 @@ static void pc_machine_initfn(Object *obj)
     pcms->smbus_enabled = true;
     pcms->sata_enabled = true;
     pcms->pit_enabled = true;
+    pcms->pic_enabled = true;
     pcms->max_fw_size = 8 * MiB;
 #ifdef CONFIG_HPET
     pcms->hpet_enabled = true;
@@ -1797,6 +1812,9 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     object_class_property_add_bool(oc, PC_MACHINE_PIT,
         pc_machine_get_pit, pc_machine_set_pit);
 
+    object_class_property_add_bool(oc, PC_MACHINE_PIC,
+        pc_machine_get_pic, pc_machine_set_pic);
+
     object_class_property_add_bool(oc, "hpet",
         pc_machine_get_hpet, pc_machine_set_hpet);
 
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 2904b40163..4b59d40c3c 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -220,7 +220,9 @@ static void pc_init1(MachineState *machine,
     }
     isa_bus_irqs(isa_bus, x86ms->gsi);
 
-    pc_i8259_create(isa_bus, gsi_state->i8259_irq);
+    if (pcms->pic_enabled) {
+        pc_i8259_create(isa_bus, gsi_state->i8259_irq);
+    }
 
     if (pcmc->pci_enabled) {
         ioapic_init_gsi(gsi_state, "i440fx");
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 0a212443aa..c68799efbb 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -250,7 +250,9 @@ static void pc_q35_init(MachineState *machine)
     pci_bus_set_route_irq_fn(host_bus, ich9_route_intx_pin_to_irq);
     isa_bus = ich9_lpc->isa_bus;
 
-    pc_i8259_create(isa_bus, gsi_state->i8259_irq);
+    if (pcms->pic_enabled) {
+        pc_i8259_create(isa_bus, gsi_state->i8259_irq);
+    }
 
     if (pcmc->pci_enabled) {
         ioapic_init_gsi(gsi_state, "q35");
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 5f93540a43..6368f7bf77 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -44,6 +44,7 @@ typedef struct PCMachineState {
     bool sata_enabled;
     bool pit_enabled;
     bool hpet_enabled;
+    bool pic_enabled;
     uint64_t max_fw_size;
     char *oem_id;
     char *oem_table_id;
@@ -63,6 +64,7 @@ typedef struct PCMachineState {
 #define PC_MACHINE_SMBUS            "smbus"
 #define PC_MACHINE_SATA             "sata"
 #define PC_MACHINE_PIT              "pit"
+#define PC_MACHINE_PIC              "pic"
 #define PC_MACHINE_MAX_FW_SIZE      "max-fw-size"
 #define PC_MACHINE_OEM_ID           "oem-id"
 #define PC_MACHINE_OEM_TABLE_ID     "oem-table-id"
-- 
2.17.1

