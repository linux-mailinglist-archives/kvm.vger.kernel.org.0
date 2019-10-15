Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB8DD7BBC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbfJOQde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388156AbfJOQde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:33:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E87A882FB;
        Tue, 15 Oct 2019 16:33:33 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D044319C5B;
        Tue, 15 Oct 2019 16:33:27 +0000 (UTC)
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
Subject: [PATCH 32/32] hw/pci-host/i440fx: Remove the last PIIX3 traces
Date:   Tue, 15 Oct 2019 18:27:05 +0200
Message-Id: <20191015162705.28087-33-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 15 Oct 2019 16:33:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PIIX3 is not tied to the i440FX and can even be used without it.
Move its creation to the machine code (pc_piix.c).
We have now removed the last trace of southbridge code in the i440FX
northbridge.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc_piix.c            | 8 +++++++-
 hw/pci-host/i440fx.c         | 8 --------
 include/hw/pci-host/i440fx.h | 3 +--
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 8ac4bf12ca..cb4f4fc94c 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -190,14 +190,20 @@ static void pc_init1(MachineState *machine,
     gsi_state = pc_gsi_create(&pcms->gsi, pcmc->pci_enabled);
 
     if (pcmc->pci_enabled) {
+        PIIX3State *piix3;
+
         pci_bus = i440fx_init(host_type,
                               pci_type,
-                              &i440fx_state, &piix3_devfn, &isa_bus, pcms->gsi,
+                              &i440fx_state,
                               system_memory, system_io, machine->ram_size,
                               pcms->below_4g_mem_size,
                               pcms->above_4g_mem_size,
                               pci_memory, ram_memory);
         pcms->bus = pci_bus;
+
+        piix3 = piix3_create(pci_bus, &isa_bus);
+        piix3->pic = pcms->gsi;
+        piix3_devfn = piix3->dev.devfn;
     } else {
         pci_bus = NULL;
         i440fx_state = NULL;
diff --git a/hw/pci-host/i440fx.c b/hw/pci-host/i440fx.c
index 79ecd58a2b..f27131102d 100644
--- a/hw/pci-host/i440fx.c
+++ b/hw/pci-host/i440fx.c
@@ -27,7 +27,6 @@
 #include "hw/pci/pci.h"
 #include "hw/pci/pci_host.h"
 #include "hw/pci-host/i440fx.h"
-#include "hw/southbridge/piix.h"
 #include "hw/qdev-properties.h"
 #include "hw/sysbus.h"
 #include "qapi/error.h"
@@ -272,8 +271,6 @@ static void i440fx_realize(PCIDevice *dev, Error **errp)
 
 PCIBus *i440fx_init(const char *host_type, const char *pci_type,
                     PCII440FXState **pi440fx_state,
-                    int *piix3_devfn,
-                    ISABus **isa_bus, qemu_irq *pic,
                     MemoryRegion *address_space_mem,
                     MemoryRegion *address_space_io,
                     ram_addr_t ram_size,
@@ -286,7 +283,6 @@ PCIBus *i440fx_init(const char *host_type, const char *pci_type,
     PCIBus *b;
     PCIDevice *d;
     PCIHostState *s;
-    PIIX3State *piix3;
     PCII440FXState *f;
     unsigned i;
     I440FXState *i440fx;
@@ -339,10 +335,6 @@ PCIBus *i440fx_init(const char *host_type, const char *pci_type,
                  PAM_EXPAN_SIZE);
     }
 
-    piix3 = piix3_create(b, isa_bus);
-    piix3->pic = pic;
-    *piix3_devfn = piix3->dev.devfn;
-
     ram_size = ram_size / 8 / 1024 / 1024;
     if (ram_size > 255) {
         ram_size = 255;
diff --git a/include/hw/pci-host/i440fx.h b/include/hw/pci-host/i440fx.h
index e327f9bf87..f54e6466e4 100644
--- a/include/hw/pci-host/i440fx.h
+++ b/include/hw/pci-host/i440fx.h
@@ -22,8 +22,7 @@ typedef struct PCII440FXState PCII440FXState;
 #define TYPE_IGD_PASSTHROUGH_I440FX_PCI_DEVICE "igd-passthrough-i440FX"
 
 PCIBus *i440fx_init(const char *host_type, const char *pci_type,
-                    PCII440FXState **pi440fx_state, int *piix_devfn,
-                    ISABus **isa_bus, qemu_irq *pic,
+                    PCII440FXState **pi440fx_state,
                     MemoryRegion *address_space_mem,
                     MemoryRegion *address_space_io,
                     ram_addr_t ram_size,
-- 
2.21.0

