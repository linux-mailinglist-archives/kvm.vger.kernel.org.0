Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E81CD7B70
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbfJOQ3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732717AbfJOQ3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:29:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E8ED307D942;
        Tue, 15 Oct 2019 16:29:12 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21B2419C58;
        Tue, 15 Oct 2019 16:29:05 +0000 (UTC)
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
Subject: [PATCH 09/32] piix4: add Reset Control Register
Date:   Tue, 15 Oct 2019 18:26:42 +0200
Message-Id: <20191015162705.28087-10-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 15 Oct 2019 16:29:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hervé Poussineau <hpoussin@reactos.org>

The RCR I/O port (0xcf9) is used to generate a hard reset or a soft reset.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hervé Poussineau <hpoussin@reactos.org>
Message-Id: <20171216090228.28505-7-hpoussin@reactos.org>
[PMD: rebased, updated includes]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/isa/piix4.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/hw/isa/piix4.c b/hw/isa/piix4.c
index 4202243e41..6e2d9b9774 100644
--- a/hw/isa/piix4.c
+++ b/hw/isa/piix4.c
@@ -2,6 +2,7 @@
  * QEMU PIIX4 PCI Bridge Emulation
  *
  * Copyright (c) 2006 Fabrice Bellard
+ * Copyright (c) 2018 Hervé Poussineau
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
@@ -29,11 +30,16 @@
 #include "hw/sysbus.h"
 #include "migration/vmstate.h"
 #include "sysemu/reset.h"
+#include "sysemu/runstate.h"
 
 PCIDevice *piix4_dev;
 
 typedef struct PIIX4State {
     PCIDevice dev;
+
+    /* Reset Control Register */
+    MemoryRegion rcr_mem;
+    uint8_t rcr;
 } PIIX4State;
 
 #define TYPE_PIIX4_PCI_DEVICE "PIIX4"
@@ -88,6 +94,34 @@ static const VMStateDescription vmstate_piix4 = {
     }
 };
 
+static void piix4_rcr_write(void *opaque, hwaddr addr, uint64_t val,
+                            unsigned int len)
+{
+    PIIX4State *s = opaque;
+
+    if (val & 4) {
+        qemu_system_reset_request(SHUTDOWN_CAUSE_GUEST_RESET);
+        return;
+    }
+    s->rcr = val & 2; /* keep System Reset type only */
+}
+
+static uint64_t piix4_rcr_read(void *opaque, hwaddr addr, unsigned int len)
+{
+    PIIX4State *s = opaque;
+    return s->rcr;
+}
+
+static const MemoryRegionOps piix4_rcr_ops = {
+    .read = piix4_rcr_read,
+    .write = piix4_rcr_write,
+    .endianness = DEVICE_LITTLE_ENDIAN,
+    .impl = {
+        .min_access_size = 1,
+        .max_access_size = 1,
+    },
+};
+
 static void piix4_realize(PCIDevice *pci_dev, Error **errp)
 {
     DeviceState *dev = DEVICE(pci_dev);
@@ -97,6 +131,12 @@ static void piix4_realize(PCIDevice *pci_dev, Error **errp)
                      pci_address_space_io(pci_dev), errp)) {
         return;
     }
+
+    memory_region_init_io(&s->rcr_mem, OBJECT(dev), &piix4_rcr_ops, s,
+                          "reset-control", 1);
+    memory_region_add_subregion_overlap(pci_address_space_io(pci_dev), 0xcf9,
+                                        &s->rcr_mem, 1);
+
     piix4_dev = pci_dev;
     qemu_register_reset(piix4_reset, s);
 }
-- 
2.21.0

