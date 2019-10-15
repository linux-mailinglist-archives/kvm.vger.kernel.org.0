Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D50D7B93
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388056AbfJOQaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727651AbfJOQaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:30:46 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F817308FBAC;
        Tue, 15 Oct 2019 16:30:46 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 22B6819C5B;
        Tue, 15 Oct 2019 16:30:35 +0000 (UTC)
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
Subject: [PATCH 18/32] hw/mips/mips_malta: Extract the PIIX4 creation code as piix4_create()
Date:   Tue, 15 Oct 2019 18:26:51 +0200
Message-Id: <20191015162705.28087-19-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 15 Oct 2019 16:30:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Malta board instantiate a PIIX4 chipset doing various
calls. Refactor all those related calls into a single
function: piix4_create().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/mips/mips_malta.c | 47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/hw/mips/mips_malta.c b/hw/mips/mips_malta.c
index 774bb810f6..0d4312840b 100644
--- a/hw/mips/mips_malta.c
+++ b/hw/mips/mips_malta.c
@@ -1210,6 +1210,34 @@ static void mips_create_cpu(MachineState *ms, MaltaState *s,
     }
 }
 
+static DeviceState *piix4_create(PCIBus *pci_bus, ISABus **isa_bus,
+                                 I2CBus **smbus, size_t ide_buses)
+{
+    const size_t ide_drives = ide_buses * MAX_IDE_DEVS;
+    DriveInfo **hd;
+    PCIDevice *pci;
+    DeviceState *dev;
+
+    pci = pci_create_simple_multifunction(pci_bus, PCI_DEVFN(10, 0),
+                                          true, TYPE_PIIX4_PCI_DEVICE);
+    dev = DEVICE(pci);
+    if (isa_bus) {
+        *isa_bus = ISA_BUS(qdev_get_child_bus(dev, "isa.0"));
+    }
+
+    hd = g_new(DriveInfo *, ide_drives);
+    ide_drive_get(hd, ide_drives);
+    pci_piix4_ide_init(pci_bus, hd, pci->devfn + 1);
+    g_free(hd);
+    pci_create_simple(pci_bus, pci->devfn + 2, "piix4-usb-uhci");
+    if (smbus) {
+        *smbus = piix4_pm_init(pci_bus, pci->devfn + 3, 0x1100,
+                               isa_get_irq(NULL, 9), NULL, 0, NULL);
+   }
+
+    return dev;
+}
+
 static
 void mips_malta_init(MachineState *machine)
 {
@@ -1231,12 +1259,8 @@ void mips_malta_init(MachineState *machine)
     PCIBus *pci_bus;
     ISABus *isa_bus;
     qemu_irq cbus_irq, i8259_irq;
-    PCIDevice *pci;
-    int piix4_devfn;
     I2CBus *smbus;
     DriveInfo *dinfo;
-    const size_t ide_drives = MAX_IDE_BUS * MAX_IDE_DEVS;
-    DriveInfo **hd;
     int fl_idx = 0;
     int be;
 
@@ -1407,14 +1431,7 @@ void mips_malta_init(MachineState *machine)
     pci_bus = gt64120_register(s->i8259);
 
     /* Southbridge */
-    hd = g_new(DriveInfo *, ide_drives);
-    ide_drive_get(hd, ide_drives);
-
-    pci = pci_create_simple_multifunction(pci_bus, PCI_DEVFN(10, 0),
-                                          true, TYPE_PIIX4_PCI_DEVICE);
-    dev = DEVICE(pci);
-    isa_bus = ISA_BUS(qdev_get_child_bus(dev, "isa.0"));
-    piix4_devfn = pci->devfn;
+    dev = piix4_create(pci_bus, &isa_bus, &smbus, MAX_IDE_BUS);
 
     /* Interrupt controller */
     qdev_connect_gpio_out_named(dev, "intr", 0, i8259_irq);
@@ -1422,12 +1439,6 @@ void mips_malta_init(MachineState *machine)
         s->i8259[i] = qdev_get_gpio_in_named(dev, "isa", i);
     }
 
-    pci_piix4_ide_init(pci_bus, hd, piix4_devfn + 1);
-    g_free(hd);
-    pci_create_simple(pci_bus, piix4_devfn + 2, "piix4-usb-uhci");
-    smbus = piix4_pm_init(pci_bus, piix4_devfn + 3, 0x1100,
-                          isa_get_irq(NULL, 9), NULL, 0, NULL);
-
     /* generate SPD EEPROM data */
     generate_eeprom_spd(&smbus_eeprom_buf[0 * 256], ram_size);
     generate_eeprom_serial(&smbus_eeprom_buf[6 * 256]);
-- 
2.21.0

