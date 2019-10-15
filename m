Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76C3D7B8E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbfJOQag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:30:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387919AbfJOQaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:30:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7AF671DA2;
        Tue, 15 Oct 2019 16:30:35 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B8CE19C58;
        Tue, 15 Oct 2019 16:30:24 +0000 (UTC)
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
Subject: [PATCH 17/32] hw/mips/mips_malta: Create IDE hard drive array dynamically
Date:   Tue, 15 Oct 2019 18:26:50 +0200
Message-Id: <20191015162705.28087-18-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 15 Oct 2019 16:30:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the next commit we'll refactor the PIIX4 code out of
mips_malta_init(). As a preliminary step, add the 'ide_drives'
variable and create the drive array dynamically.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/mips/mips_malta.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/hw/mips/mips_malta.c b/hw/mips/mips_malta.c
index 528c34a1c3..774bb810f6 100644
--- a/hw/mips/mips_malta.c
+++ b/hw/mips/mips_malta.c
@@ -1235,7 +1235,8 @@ void mips_malta_init(MachineState *machine)
     int piix4_devfn;
     I2CBus *smbus;
     DriveInfo *dinfo;
-    DriveInfo *hd[MAX_IDE_BUS * MAX_IDE_DEVS];
+    const size_t ide_drives = MAX_IDE_BUS * MAX_IDE_DEVS;
+    DriveInfo **hd;
     int fl_idx = 0;
     int be;
 
@@ -1406,7 +1407,8 @@ void mips_malta_init(MachineState *machine)
     pci_bus = gt64120_register(s->i8259);
 
     /* Southbridge */
-    ide_drive_get(hd, ARRAY_SIZE(hd));
+    hd = g_new(DriveInfo *, ide_drives);
+    ide_drive_get(hd, ide_drives);
 
     pci = pci_create_simple_multifunction(pci_bus, PCI_DEVFN(10, 0),
                                           true, TYPE_PIIX4_PCI_DEVICE);
@@ -1421,6 +1423,7 @@ void mips_malta_init(MachineState *machine)
     }
 
     pci_piix4_ide_init(pci_bus, hd, piix4_devfn + 1);
+    g_free(hd);
     pci_create_simple(pci_bus, piix4_devfn + 2, "piix4-usb-uhci");
     smbus = piix4_pm_init(pci_bus, piix4_devfn + 3, 0x1100,
                           isa_get_irq(NULL, 9), NULL, 0, NULL);
-- 
2.21.0

