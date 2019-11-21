Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2681047C8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 01:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfKUA6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 19:58:47 -0500
Received: from ozlabs.org ([203.11.71.1]:52665 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfKUA6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 19:58:47 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47JLm434w0z9sPn; Thu, 21 Nov 2019 11:58:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574297924;
        bh=Q2CHP0Ke6mkaX6t4hswofWQZGdJTg0Yt2bzdTOJZj8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTZ8RZOPsHWsPlug7qeJ77TO3NZIzw84Ege2mnZE9FQXPBQNOMFKManr/FpA/JEVX
         JpUbc+NncdPM4Lln8rWPT5XCKio3EgYMEr4M73X4n8sjX4u6pacwgYbfxPOAc+45r2
         /nFqLBv+EQ3+WLKVvQgA3zAbTm5KsbKFNpAU9tfs=
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
Subject: [PATCH 3/5] vfio/pci: Respond to KVM irqchip change notifier
Date:   Thu, 21 Nov 2019 11:56:05 +1100
Message-Id: <20191121005607.274347-4-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121005607.274347-1-david@gibson.dropbear.id.au>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO PCI devices already respond to the pci intx routing notifier, in order
to update kernel irqchip mappings when routing is updated.  However this
won't handle the case where the irqchip itself is replaced by a different
model while retaining the same routing.  This case can happen on
the pseries machine type due to PAPR feature negotiation.

To handle that case, add a handler for the irqchip change notifier, which
does much the same thing as the routing notifier, but is unconditional,
rather than being a no-op when the routing hasn't changed.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/vfio/pci.c | 23 ++++++++++++++++++-----
 hw/vfio/pci.h |  1 +
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 521289aa7d..95478c2c55 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -256,6 +256,14 @@ static void vfio_intx_routing_notifier(PCIDevice *pdev)
     }
 }
 
+static void vfio_irqchip_change(Notifier *notify, void *data)
+{
+    VFIOPCIDevice *vdev = container_of(notify, VFIOPCIDevice,
+                                       irqchip_change_notifier);
+
+    vfio_intx_update(vdev, &vdev->intx.route);
+}
+
 static int vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
 {
     uint8_t pin = vfio_pci_read_config(&vdev->pdev, PCI_INTERRUPT_PIN, 1);
@@ -2973,16 +2981,18 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
                                                   vfio_intx_mmap_enable, vdev);
         pci_device_set_intx_routing_notifier(&vdev->pdev,
                                              vfio_intx_routing_notifier);
+        vdev->irqchip_change_notifier.notify = vfio_irqchip_change;
+        kvm_irqchip_add_change_notifier(&vdev->irqchip_change_notifier);
         ret = vfio_intx_enable(vdev, errp);
         if (ret) {
-            goto out_teardown;
+            goto out_deregister;
         }
     }
 
     if (vdev->display != ON_OFF_AUTO_OFF) {
         ret = vfio_display_probe(vdev, errp);
         if (ret) {
-            goto out_teardown;
+            goto out_deregister;
         }
     }
     if (vdev->enable_ramfb && vdev->dpy == NULL) {
@@ -2992,11 +3002,11 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     if (vdev->display_xres || vdev->display_yres) {
         if (vdev->dpy == NULL) {
             error_setg(errp, "xres and yres properties require display=on");
-            goto out_teardown;
+            goto out_deregister;
         }
         if (vdev->dpy->edid_regs == NULL) {
             error_setg(errp, "xres and yres properties need edid support");
-            goto out_teardown;
+            goto out_deregister;
         }
     }
 
@@ -3020,8 +3030,10 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 
     return;
 
-out_teardown:
+out_deregister:
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
+    kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
+out_teardown:
     vfio_teardown_msi(vdev);
     vfio_bars_exit(vdev);
 error:
@@ -3064,6 +3076,7 @@ static void vfio_exitfn(PCIDevice *pdev)
     vfio_unregister_req_notifier(vdev);
     vfio_unregister_err_notifier(vdev);
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
+    kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
     vfio_disable_interrupts(vdev);
     if (vdev->intx.mmap_timer) {
         timer_free(vdev->intx.mmap_timer);
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index b329d50338..35626cd63e 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -169,6 +169,7 @@ typedef struct VFIOPCIDevice {
     bool enable_ramfb;
     VFIODisplay *dpy;
     Error *migration_blocker;
+    Notifier irqchip_change_notifier;
 } VFIOPCIDevice;
 
 uint32_t vfio_pci_read_config(PCIDevice *pdev, uint32_t addr, int len);
-- 
2.23.0

