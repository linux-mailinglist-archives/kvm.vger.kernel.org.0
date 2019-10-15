Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4FD7B71
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387603AbfJOQ3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbfJOQ3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:29:24 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFC2918C8936;
        Tue, 15 Oct 2019 16:29:23 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1003719C58;
        Tue, 15 Oct 2019 16:29:12 +0000 (UTC)
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
Subject: [PATCH 10/32] piix4: add a i8259 interrupt controller as specified in datasheet
Date:   Tue, 15 Oct 2019 18:26:43 +0200
Message-Id: <20191015162705.28087-11-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 15 Oct 2019 16:29:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hervé Poussineau <hpoussin@reactos.org>

Add ISA irqs as piix4 gpio in, and CPU interrupt request as piix4 gpio out.
Remove i8259 instanciated in malta board, to not have it twice.

We can also remove the now unused piix4_init() function.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hervé Poussineau <hpoussin@reactos.org>
Message-Id: <20171216090228.28505-8-hpoussin@reactos.org>
[PMD: rebased, updated includes, use ISA_NUM_IRQS in for loop]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/isa/piix4.c       | 41 ++++++++++++++++++++++++++++++-----------
 hw/mips/mips_malta.c | 32 +++++++++++++-------------------
 include/hw/i386/pc.h |  1 -
 3 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/hw/isa/piix4.c b/hw/isa/piix4.c
index 6e2d9b9774..1cfc51335a 100644
--- a/hw/isa/piix4.c
+++ b/hw/isa/piix4.c
@@ -24,6 +24,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "hw/irq.h"
 #include "hw/i386/pc.h"
 #include "hw/pci/pci.h"
 #include "hw/isa/isa.h"
@@ -36,6 +37,8 @@ PCIDevice *piix4_dev;
 
 typedef struct PIIX4State {
     PCIDevice dev;
+    qemu_irq cpu_intr;
+    qemu_irq *isa;
 
     /* Reset Control Register */
     MemoryRegion rcr_mem;
@@ -94,6 +97,18 @@ static const VMStateDescription vmstate_piix4 = {
     }
 };
 
+static void piix4_request_i8259_irq(void *opaque, int irq, int level)
+{
+    PIIX4State *s = opaque;
+    qemu_set_irq(s->cpu_intr, level);
+}
+
+static void piix4_set_i8259_irq(void *opaque, int irq, int level)
+{
+    PIIX4State *s = opaque;
+    qemu_set_irq(s->isa[irq], level);
+}
+
 static void piix4_rcr_write(void *opaque, hwaddr addr, uint64_t val,
                             unsigned int len)
 {
@@ -126,30 +141,34 @@ static void piix4_realize(PCIDevice *pci_dev, Error **errp)
 {
     DeviceState *dev = DEVICE(pci_dev);
     PIIX4State *s = DO_UPCAST(PIIX4State, dev, pci_dev);
+    ISABus *isa_bus;
+    qemu_irq *i8259_out_irq;
 
-    if (!isa_bus_new(dev, pci_address_space(pci_dev),
-                     pci_address_space_io(pci_dev), errp)) {
+    isa_bus = isa_bus_new(dev, pci_address_space(pci_dev),
+                          pci_address_space_io(pci_dev), errp);
+    if (!isa_bus) {
         return;
     }
 
+    qdev_init_gpio_in_named(dev, piix4_set_i8259_irq, "isa", ISA_NUM_IRQS);
+    qdev_init_gpio_out_named(dev, &s->cpu_intr, "intr", 1);
+
     memory_region_init_io(&s->rcr_mem, OBJECT(dev), &piix4_rcr_ops, s,
                           "reset-control", 1);
     memory_region_add_subregion_overlap(pci_address_space_io(pci_dev), 0xcf9,
                                         &s->rcr_mem, 1);
 
+    /* initialize i8259 pic */
+    i8259_out_irq = qemu_allocate_irqs(piix4_request_i8259_irq, s, 1);
+    s->isa = i8259_init(isa_bus, *i8259_out_irq);
+
+    /* initialize ISA irqs */
+    isa_bus_irqs(isa_bus, s->isa);
+
     piix4_dev = pci_dev;
     qemu_register_reset(piix4_reset, s);
 }
 
-int piix4_init(PCIBus *bus, ISABus **isa_bus, int devfn)
-{
-    PCIDevice *d;
-
-    d = pci_create_simple_multifunction(bus, devfn, true, "PIIX4");
-    *isa_bus = ISA_BUS(qdev_get_child_bus(DEVICE(d), "isa.0"));
-    return d->devfn;
-}
-
 static void piix4_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
diff --git a/hw/mips/mips_malta.c b/hw/mips/mips_malta.c
index 4d9c64b36a..7d25ab6c23 100644
--- a/hw/mips/mips_malta.c
+++ b/hw/mips/mips_malta.c
@@ -97,7 +97,7 @@ typedef struct {
     SysBusDevice parent_obj;
 
     MIPSCPSState cps;
-    qemu_irq *i8259;
+    qemu_irq i8259[16];
 } MaltaState;
 
 static ISADevice *pit;
@@ -1235,8 +1235,8 @@ void mips_malta_init(MachineState *machine)
     int64_t kernel_entry, bootloader_run_addr;
     PCIBus *pci_bus;
     ISABus *isa_bus;
-    qemu_irq *isa_irq;
     qemu_irq cbus_irq, i8259_irq;
+    PCIDevice *pci;
     int piix4_devfn;
     I2CBus *smbus;
     DriveInfo *dinfo;
@@ -1407,30 +1407,24 @@ void mips_malta_init(MachineState *machine)
     /* Board ID = 0x420 (Malta Board with CoreLV) */
     stl_p(memory_region_get_ram_ptr(bios_copy) + 0x10, 0x00000420);
 
-    /*
-     * We have a circular dependency problem: pci_bus depends on isa_irq,
-     * isa_irq is provided by i8259, i8259 depends on ISA, ISA depends
-     * on piix4, and piix4 depends on pci_bus.  To stop the cycle we have
-     * qemu_irq_proxy() adds an extra bit of indirection, allowing us
-     * to resolve the isa_irq -> i8259 dependency after i8259 is initialized.
-     */
-    isa_irq = qemu_irq_proxy(&s->i8259, 16);
-
     /* Northbridge */
-    pci_bus = gt64120_register(isa_irq);
+    pci_bus = gt64120_register(s->i8259);
 
     /* Southbridge */
     ide_drive_get(hd, ARRAY_SIZE(hd));
 
-    piix4_devfn = piix4_init(pci_bus, &isa_bus, 80);
+    pci = pci_create_simple_multifunction(pci_bus, PCI_DEVFN(10, 0),
+                                          true, "PIIX4");
+    dev = DEVICE(pci);
+    isa_bus = ISA_BUS(qdev_get_child_bus(dev, "isa.0"));
+    piix4_devfn = pci->devfn;
 
-    /*
-     * Interrupt controller
-     * The 8259 is attached to the MIPS CPU INT0 pin, ie interrupt 2
-     */
-    s->i8259 = i8259_init(isa_bus, i8259_irq);
+    /* Interrupt controller */
+    qdev_connect_gpio_out_named(dev, "intr", 0, i8259_irq);
+    for (int i = 0; i < ISA_NUM_IRQS; i++) {
+        s->i8259[i] = qdev_get_gpio_in_named(dev, "isa", i);
+    }
 
-    isa_bus_irqs(isa_bus, s->i8259);
     pci_piix4_ide_init(pci_bus, hd, piix4_devfn + 1);
     pci_create_simple(pci_bus, piix4_devfn + 2, "piix4-usb-uhci");
     smbus = piix4_pm_init(pci_bus, piix4_devfn + 3, 0x1100,
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 09e74e7764..a95eab0d8a 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -282,7 +282,6 @@ PCIBus *i440fx_init(const char *host_type, const char *pci_type,
 PCIBus *find_i440fx(void);
 /* piix4.c */
 extern PCIDevice *piix4_dev;
-int piix4_init(PCIBus *bus, ISABus **isa_bus, int devfn);
 
 /* pc_sysfw.c */
 void pc_system_flash_create(PCMachineState *pcms);
-- 
2.21.0

