Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4951B7943
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgDXPRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:17:16 -0400
Received: from foss.arm.com ([217.140.110.172]:36830 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgDXPRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:17:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79CA931B;
        Fri, 24 Apr 2020 08:17:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8258C3F68F;
        Fri, 24 Apr 2020 08:17:14 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool v4 6/5] pci: Move legacy IRQ assignment into devices
Date:   Fri, 24 Apr 2020 16:17:02 +0100
Message-Id: <20200424151702.4750-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far the (legacy) IRQ line for a PCI device is allocated in devices.c,
which should actually not take care of that. Since we allocate all other
device specific resources in the actual device emulation code, the IRQ
should not be something special.

Remove the PCI specific code from devices.c, and move the IRQ line
allocation to the PCI code.
This drops the IRQ line from the VESA device, since it does not use one.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi Will,

this is the patch I mentioned earlier today. Briefly tested on x86 with
the VESA device and on a Juno.

Cheers,
Andre

 devices.c         | 9 ---------
 include/kvm/pci.h | 2 +-
 pci.c             | 6 +++---
 vfio/pci.c        | 2 ++
 virtio/pci.c      | 5 ++---
 5 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/devices.c b/devices.c
index 2c8b2665..41cffdd7 100644
--- a/devices.c
+++ b/devices.c
@@ -1,6 +1,5 @@
 #include "kvm/devices.h"
 #include "kvm/kvm.h"
-#include "kvm/pci.h"
 
 #include <linux/err.h>
 #include <linux/rbtree.h>
@@ -28,14 +27,6 @@ int device__register(struct device_header *dev)
 	bus = &device_trees[dev->bus_type];
 	dev->dev_num = bus->dev_num++;
 
-	switch (dev->bus_type) {
-	case DEVICE_BUS_PCI:
-		pci__assign_irq(dev);
-		break;
-	default:
-		break;
-	}
-
 	node = &bus->root.rb_node;
 	while (*node) {
 		int num = rb_entry(*node, struct device_header, node)->dev_num;
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index ccb155e3..2c29c094 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -155,7 +155,7 @@ int pci__exit(struct kvm *kvm);
 struct pci_device_header *pci__find_dev(u8 dev_num);
 u32 pci_get_mmio_block(u32 size);
 u16 pci_get_io_port_block(u32 size);
-void pci__assign_irq(struct device_header *dev_hdr);
+int pci__assign_irq(struct pci_device_header *pci_hdr);
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size);
 void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size);
 
diff --git a/pci.c b/pci.c
index b6892d97..3ecdd0f9 100644
--- a/pci.c
+++ b/pci.c
@@ -49,10 +49,8 @@ void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type)
 	return NULL;
 }
 
-void pci__assign_irq(struct device_header *dev_hdr)
+int pci__assign_irq(struct pci_device_header *pci_hdr)
 {
-	struct pci_device_header *pci_hdr = dev_hdr->data;
-
 	/*
 	 * PCI supports only INTA#,B#,C#,D# per device.
 	 *
@@ -64,6 +62,8 @@ void pci__assign_irq(struct device_header *dev_hdr)
 
 	if (!pci_hdr->irq_type)
 		pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
+
+	return pci_hdr->irq_line;
 }
 
 static void *pci_config_address_ptr(u16 port)
diff --git a/vfio/pci.c b/vfio/pci.c
index 4412c6d7..7c2ea10c 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1212,6 +1212,8 @@ static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev
 	}
 
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
+		pci__assign_irq(&vdev->pci.hdr);
+
 		ret = vfio_pci_init_intx(kvm, vdev);
 		if (ret)
 			return ret;
diff --git a/virtio/pci.c b/virtio/pci.c
index 281c3181..c6529493 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -524,13 +524,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	if (irq__can_signal_msi(kvm))
 		vpci->features |= VIRTIO_PCI_F_SIGNAL_MSI;
 
+	vpci->legacy_irq_line = pci__assign_irq(&vpci->pci_hdr);
+
 	r = device__register(&vpci->dev_hdr);
 	if (r < 0)
 		goto free_msix_mmio;
 
-	/* save the IRQ that device__register() has allocated */
-	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;
-
 	return 0;
 
 free_msix_mmio:
-- 
2.17.1

