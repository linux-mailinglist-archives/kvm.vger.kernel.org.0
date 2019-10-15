Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE671D7B6F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfJOQ3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:29:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727651AbfJOQ3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:29:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2FDA18C8320;
        Tue, 15 Oct 2019 16:29:05 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FCEF19C58;
        Tue, 15 Oct 2019 16:28:50 +0000 (UTC)
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
Subject: [PATCH 08/32] piix4: rename some variables in realize function
Date:   Tue, 15 Oct 2019 18:26:41 +0200
Message-Id: <20191015162705.28087-9-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 15 Oct 2019 16:29:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hervé Poussineau <hpoussin@reactos.org>

PIIX4 structure is now 's'
PCI device is now 'pci_dev'
DeviceState is now 'dev'

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hervé Poussineau <hpoussin@reactos.org>
Message-Id: <20171216090228.28505-6-hpoussin@reactos.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/isa/piix4.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/hw/isa/piix4.c b/hw/isa/piix4.c
index 3294056cd5..4202243e41 100644
--- a/hw/isa/piix4.c
+++ b/hw/isa/piix4.c
@@ -88,16 +88,17 @@ static const VMStateDescription vmstate_piix4 = {
     }
 };
 
-static void piix4_realize(PCIDevice *dev, Error **errp)
+static void piix4_realize(PCIDevice *pci_dev, Error **errp)
 {
-    PIIX4State *d = PIIX4_PCI_DEVICE(dev);
+    DeviceState *dev = DEVICE(pci_dev);
+    PIIX4State *s = DO_UPCAST(PIIX4State, dev, pci_dev);
 
-    if (!isa_bus_new(DEVICE(d), pci_address_space(dev),
-                     pci_address_space_io(dev), errp)) {
+    if (!isa_bus_new(dev, pci_address_space(pci_dev),
+                     pci_address_space_io(pci_dev), errp)) {
         return;
     }
-    piix4_dev = &d->dev;
-    qemu_register_reset(piix4_reset, d);
+    piix4_dev = pci_dev;
+    qemu_register_reset(piix4_reset, s);
 }
 
 int piix4_init(PCIBus *bus, ISABus **isa_bus, int devfn)
-- 
2.21.0

