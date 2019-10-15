Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C560D7BA6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbfJOQbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfJOQbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:31:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B7FE8AC6F5;
        Tue, 15 Oct 2019 16:31:51 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D974419C58;
        Tue, 15 Oct 2019 16:31:37 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 23/32] hw/i386/pc: Extract pc_i8259_create()
Date:   Tue, 15 Oct 2019 18:26:56 +0200
Message-Id: <20191015162705.28087-24-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 15 Oct 2019 16:31:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The i8259 creation code is common to all PC machines, extract the
common code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c         | 19 +++++++++++++++++++
 hw/i386/pc_piix.c    | 13 +------------
 hw/i386/pc_q35.c     | 14 +-------------
 include/hw/i386/pc.h |  1 +
 4 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 59de0c8a1f..2b6a52f23b 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1978,6 +1978,25 @@ void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)
     rom_reset_order_override();
 }
 
+void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs)
+{
+    qemu_irq *i8259;
+
+    if (kvm_pic_in_kernel()) {
+        i8259 = kvm_i8259_init(isa_bus);
+    } else if (xen_enabled()) {
+        i8259 = xen_interrupt_controller_init();
+    } else {
+        i8259 = i8259_init(isa_bus, pc_allocate_cpu_irq());
+    }
+
+    for (size_t i = 0; i < ISA_NUM_IRQS; i++) {
+        i8259_irqs[i] = i8259[i];
+    }
+
+    g_free(i8259);
+}
+
 void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name)
 {
     DeviceState *dev;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 452b107e1b..0a7193a3cc 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -81,7 +81,6 @@ static void pc_init1(MachineState *machine,
     ISABus *isa_bus;
     PCII440FXState *i440fx_state;
     int piix3_devfn = -1;
-    qemu_irq *i8259;
     qemu_irq smi_irq;
     GSIState *gsi_state;
     DriveInfo *hd[MAX_IDE_BUS * MAX_IDE_DEVS];
@@ -208,18 +207,8 @@ static void pc_init1(MachineState *machine,
     }
     isa_bus_irqs(isa_bus, pcms->gsi);
 
-    if (kvm_pic_in_kernel()) {
-        i8259 = kvm_i8259_init(isa_bus);
-    } else if (xen_enabled()) {
-        i8259 = xen_interrupt_controller_init();
-    } else {
-        i8259 = i8259_init(isa_bus, pc_allocate_cpu_irq());
-    }
+    pc_i8259_create(isa_bus, gsi_state->i8259_irq);
 
-    for (i = 0; i < ISA_NUM_IRQS; i++) {
-        gsi_state->i8259_irq[i] = i8259[i];
-    }
-    g_free(i8259);
     if (pcmc->pci_enabled) {
         ioapic_init_gsi(gsi_state, "i440fx");
     }
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 6d096eff28..f4fb9a02ba 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -128,7 +128,6 @@ static void pc_q35_init(MachineState *machine)
     MemoryRegion *ram_memory;
     GSIState *gsi_state;
     ISABus *isa_bus;
-    qemu_irq *i8259;
     int i;
     ICH9LPCState *ich9_lpc;
     PCIDevice *ahci;
@@ -255,18 +254,7 @@ static void pc_q35_init(MachineState *machine)
     pci_bus_set_route_irq_fn(host_bus, ich9_route_intx_pin_to_irq);
     isa_bus = ich9_lpc->isa_bus;
 
-    if (kvm_pic_in_kernel()) {
-        i8259 = kvm_i8259_init(isa_bus);
-    } else if (xen_enabled()) {
-        i8259 = xen_interrupt_controller_init();
-    } else {
-        i8259 = i8259_init(isa_bus, pc_allocate_cpu_irq());
-    }
-
-    for (i = 0; i < ISA_NUM_IRQS; i++) {
-        gsi_state->i8259_irq[i] = i8259[i];
-    }
-    g_free(i8259);
+    pc_i8259_create(isa_bus, gsi_state->i8259_irq);
 
     if (pcmc->pci_enabled) {
         ioapic_init_gsi(gsi_state, "q35");
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 75b44e156c..183326d9fe 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -235,6 +235,7 @@ void pc_pci_device_init(PCIBus *pci_bus);
 
 typedef void (*cpu_set_smm_t)(int smm, void *arg);
 
+void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs);
 void ioapic_init_gsi(GSIState *gsi_state, const char *parent_name);
 
 ISADevice *pc_find_fdc0(void);
-- 
2.21.0

