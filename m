Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5521C1047CB
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKUA6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 19:58:49 -0500
Received: from ozlabs.org ([203.11.71.1]:35763 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfKUA6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 19:58:47 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47JLm42L1Gz9sPW; Thu, 21 Nov 2019 11:58:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574297924;
        bh=M0mcg5/1en/4FPfwraZYSINmLiks1lDcs9ZPZyf4HFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrCBuvydoJarKwc/AqXBCCfhRHgtOv2SIHcrg7RMzyu44qkv46jqKR1N3sGuqc4mh
         I9yv01OBJiKsd+pNQA58bD4EXpoXcEVNT14kxVqV0ZDbKeXx1WZqgw8B5syMI78vvk
         FKKxC/uAqg99z7l1n69qh3cmU4omIQGoacX/vSQ4=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>, clg@kaod.org
Cc:     groug@kaod.org, philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 2/5] vfio/pci: Split vfio_intx_update()
Date:   Thu, 21 Nov 2019 11:56:04 +1100
Message-Id: <20191121005607.274347-3-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121005607.274347-1-david@gibson.dropbear.id.au>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This splits the vfio_intx_update() function into one part doing the actual
reconnection with the KVM irqchip (vfio_intx_update(), now taking an
argument with the new routing) and vfio_intx_routing_notifier() which
handles calls to the pci device intx routing notifier and calling
vfio_intx_update() when necessary.  This will make adding support for the
irqchip change notifier easier.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/vfio/pci.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 0c55883bba..521289aa7d 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -216,30 +216,18 @@ static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
 #endif
 }
 
-static void vfio_intx_update(PCIDevice *pdev)
+static void vfio_intx_update(VFIOPCIDevice *vdev, PCIINTxRoute *route)
 {
-    VFIOPCIDevice *vdev = PCI_VFIO(pdev);
-    PCIINTxRoute route;
     Error *err = NULL;
 
-    if (vdev->interrupt != VFIO_INT_INTx) {
-        return;
-    }
-
-    route = pci_device_route_intx_to_irq(&vdev->pdev, vdev->intx.pin);
-
-    if (!pci_intx_route_changed(&vdev->intx.route, &route)) {
-        return; /* Nothing changed */
-    }
-
     trace_vfio_intx_update(vdev->vbasedev.name,
-                           vdev->intx.route.irq, route.irq);
+                           vdev->intx.route.irq, route->irq);
 
     vfio_intx_disable_kvm(vdev);
 
-    vdev->intx.route = route;
+    vdev->intx.route = *route;
 
-    if (route.mode != PCI_INTX_ENABLED) {
+    if (route->mode != PCI_INTX_ENABLED) {
         return;
     }
 
@@ -252,6 +240,22 @@ static void vfio_intx_update(PCIDevice *pdev)
     vfio_intx_eoi(&vdev->vbasedev);
 }
 
+static void vfio_intx_routing_notifier(PCIDevice *pdev)
+{
+    VFIOPCIDevice *vdev = PCI_VFIO(pdev);
+    PCIINTxRoute route;
+
+    if (vdev->interrupt != VFIO_INT_INTx) {
+        return;
+    }
+
+    route = pci_device_route_intx_to_irq(&vdev->pdev, vdev->intx.pin);
+
+    if (pci_intx_route_changed(&vdev->intx.route, &route)) {
+        vfio_intx_update(vdev, &route);
+    }
+}
+
 static int vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
 {
     uint8_t pin = vfio_pci_read_config(&vdev->pdev, PCI_INTERRUPT_PIN, 1);
@@ -2967,7 +2971,8 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     if (vfio_pci_read_config(&vdev->pdev, PCI_INTERRUPT_PIN, 1)) {
         vdev->intx.mmap_timer = timer_new_ms(QEMU_CLOCK_VIRTUAL,
                                                   vfio_intx_mmap_enable, vdev);
-        pci_device_set_intx_routing_notifier(&vdev->pdev, vfio_intx_update);
+        pci_device_set_intx_routing_notifier(&vdev->pdev,
+                                             vfio_intx_routing_notifier);
         ret = vfio_intx_enable(vdev, errp);
         if (ret) {
             goto out_teardown;
-- 
2.23.0

