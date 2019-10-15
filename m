Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C1D7B98
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbfJOQa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbfJOQa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:30:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84B7D3082B41;
        Tue, 15 Oct 2019 16:30:55 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8F7219C58;
        Tue, 15 Oct 2019 16:30:46 +0000 (UTC)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 19/32] hw/isa/piix4: Move piix4_create() to hw/isa/piix4.c
Date:   Tue, 15 Oct 2019 18:26:52 +0200
Message-Id: <20191015162705.28087-20-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 15 Oct 2019 16:30:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

Now that we properly refactored the piix4_create() function, let's
move it to hw/isa/piix4.c where it belongs, so it can be reused
on other places.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/isa/piix4.c                | 30 ++++++++++++++++++++++++++++++
 hw/mips/gt64xxx_pci.c         |  1 +
 hw/mips/mips_malta.c          | 28 ----------------------------
 include/hw/i386/pc.h          |  2 --
 include/hw/southbridge/piix.h |  6 ++++++
 5 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/hw/isa/piix4.c b/hw/isa/piix4.c
index 9f554747af..d90899e122 100644
--- a/hw/isa/piix4.c
+++ b/hw/isa/piix4.c
@@ -27,12 +27,14 @@
 #include "qapi/error.h"
 #include "hw/irq.h"
 #include "hw/i386/pc.h"
+#include "hw/southbridge/piix.h"
 #include "hw/pci/pci.h"
 #include "hw/isa/isa.h"
 #include "hw/sysbus.h"
 #include "hw/dma/i8257.h"
 #include "hw/timer/i8254.h"
 #include "hw/timer/mc146818rtc.h"
+#include "hw/ide.h"
 #include "migration/vmstate.h"
 #include "sysemu/reset.h"
 #include "sysemu/runstate.h"
@@ -234,3 +236,31 @@ static void piix4_register_types(void)
 }
 
 type_init(piix4_register_types)
+
+DeviceState *piix4_create(PCIBus *pci_bus, ISABus **isa_bus,
+                          I2CBus **smbus, size_t ide_buses)
+{
+    size_t ide_drives = ide_buses * MAX_IDE_DEVS;
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
diff --git a/hw/mips/gt64xxx_pci.c b/hw/mips/gt64xxx_pci.c
index f325bd6c1c..c277398c0d 100644
--- a/hw/mips/gt64xxx_pci.c
+++ b/hw/mips/gt64xxx_pci.c
@@ -28,6 +28,7 @@
 #include "hw/mips/mips.h"
 #include "hw/pci/pci.h"
 #include "hw/pci/pci_host.h"
+#include "hw/southbridge/piix.h"
 #include "migration/vmstate.h"
 #include "hw/i386/pc.h"
 #include "hw/irq.h"
diff --git a/hw/mips/mips_malta.c b/hw/mips/mips_malta.c
index 0d4312840b..477a4725c0 100644
--- a/hw/mips/mips_malta.c
+++ b/hw/mips/mips_malta.c
@@ -1210,34 +1210,6 @@ static void mips_create_cpu(MachineState *ms, MaltaState *s,
     }
 }
 
-static DeviceState *piix4_create(PCIBus *pci_bus, ISABus **isa_bus,
-                                 I2CBus **smbus, size_t ide_buses)
-{
-    const size_t ide_drives = ide_buses * MAX_IDE_DEVS;
-    DriveInfo **hd;
-    PCIDevice *pci;
-    DeviceState *dev;
-
-    pci = pci_create_simple_multifunction(pci_bus, PCI_DEVFN(10, 0),
-                                          true, TYPE_PIIX4_PCI_DEVICE);
-    dev = DEVICE(pci);
-    if (isa_bus) {
-        *isa_bus = ISA_BUS(qdev_get_child_bus(dev, "isa.0"));
-    }
-
-    hd = g_new(DriveInfo *, ide_drives);
-    ide_drive_get(hd, ide_drives);
-    pci_piix4_ide_init(pci_bus, hd, pci->devfn + 1);
-    g_free(hd);
-    pci_create_simple(pci_bus, pci->devfn + 2, "piix4-usb-uhci");
-    if (smbus) {
-        *smbus = piix4_pm_init(pci_bus, pci->devfn + 3, 0x1100,
-                               isa_get_irq(NULL, 9), NULL, 0, NULL);
-   }
-
-    return dev;
-}
-
 static
 void mips_malta_init(MachineState *machine)
 {
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index c671c9fd2a..b63fc7631e 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -274,8 +274,6 @@ PCIBus *i440fx_init(const char *host_type, const char *pci_type,
                     MemoryRegion *ram_memory);
 
 PCIBus *find_i440fx(void);
-/* piix4.c */
-extern PCIDevice *piix4_dev;
 
 /* pc_sysfw.c */
 void pc_system_flash_create(PCMachineState *pcms);
diff --git a/include/hw/southbridge/piix.h b/include/hw/southbridge/piix.h
index b8ce26fec4..add352456b 100644
--- a/include/hw/southbridge/piix.h
+++ b/include/hw/southbridge/piix.h
@@ -2,6 +2,7 @@
  * QEMU PIIX South Bridge Emulation
  *
  * Copyright (c) 2006 Fabrice Bellard
+ * Copyright (c) 2018 Hervé Poussineau
  *
  * This work is licensed under the terms of the GNU GPL, version 2 or later.
  * See the COPYING file in the top-level directory.
@@ -17,4 +18,9 @@ I2CBus *piix4_pm_init(PCIBus *bus, int devfn, uint32_t smb_io_base,
                       qemu_irq sci_irq, qemu_irq smi_irq,
                       int smm_enabled, DeviceState **piix4_pm);
 
+extern PCIDevice *piix4_dev;
+
+DeviceState *piix4_create(PCIBus *pci_bus, ISABus **isa_bus,
+                          I2CBus **smbus, size_t ide_buses);
+
 #endif
-- 
2.21.0

