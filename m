Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2998C146992
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAWNsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:33 -0500
Received: from foss.arm.com ([217.140.110.172]:39726 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbgAWNsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7081CFEC;
        Thu, 23 Jan 2020 05:48:32 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4DD963F68E;
        Thu, 23 Jan 2020 05:48:31 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 kvmtool 10/30] virtio/pci: Make memory and IO BARs independent
Date:   Thu, 23 Jan 2020 13:47:45 +0000
Message-Id: <20200123134805.1993-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Currently, callbacks for memory BAR 1 call the IO port emulation.  This
means that the memory BAR needs I/O Space to be enabled whenever Memory
Space is enabled.

Refactor the code so the two type of  BARs are independent. Also, unify
ioport/mmio callback arguments so that they all receive a virtio_device.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virtio/pci.c | 71 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index eeb5b5efa6e1..6723a1f3a84d 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -87,8 +87,8 @@ static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 	return vpci->pci_hdr.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE);
 }
 
-static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_device *vdev, u16 port,
-					void *data, int size, int offset)
+static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *vdev,
+					 void *data, int size, unsigned long offset)
 {
 	u32 config_offset;
 	struct virtio_pci *vpci = vdev->virtio;
@@ -117,20 +117,17 @@ static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_device *vd
 	return false;
 }
 
-static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+				unsigned long offset, void *data, int size)
 {
-	unsigned long offset;
 	bool ret = true;
-	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
 	struct virt_queue *vq;
 	struct kvm *kvm;
 	u32 val;
 
 	kvm = vcpu->kvm;
-	vdev = ioport->priv;
 	vpci = vdev->virtio;
-	offset = port - vpci->port_addr;
 
 	switch (offset) {
 	case VIRTIO_PCI_HOST_FEATURES:
@@ -154,13 +151,26 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 		vpci->isr = VIRTIO_IRQ_LOW;
 		break;
 	default:
-		ret = virtio_pci__specific_io_in(kvm, vdev, port, data, size, offset);
+		ret = virtio_pci__specific_data_in(kvm, vdev, data, size, offset);
 		break;
 	};
 
 	return ret;
 }
 
+static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	unsigned long offset;
+	struct virtio_device *vdev;
+	struct virtio_pci *vpci;
+
+	vdev = ioport->priv;
+	vpci = vdev->virtio;
+	offset = port - vpci->port_addr;
+
+	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
+}
+
 static void update_msix_map(struct virtio_pci *vpci,
 			    struct msix_table *msix_entry, u32 vecnum)
 {
@@ -185,8 +195,8 @@ static void update_msix_map(struct virtio_pci *vpci,
 	irq__update_msix_route(vpci->kvm, gsi, &msix_entry->msg);
 }
 
-static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *vdev, u16 port,
-					void *data, int size, int offset)
+static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
+					  void *data, int size, unsigned long offset)
 {
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 config_offset, vec;
@@ -259,19 +269,16 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 	return false;
 }
 
-static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+				 unsigned long offset, void *data, int size)
 {
-	unsigned long offset;
 	bool ret = true;
-	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
 
 	kvm = vcpu->kvm;
-	vdev = ioport->priv;
 	vpci = vdev->virtio;
-	offset = port - vpci->port_addr;
 
 	switch (offset) {
 	case VIRTIO_PCI_GUEST_FEATURES:
@@ -304,13 +311,26 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 		virtio_notify_status(kvm, vdev, vpci->dev, vpci->status);
 		break;
 	default:
-		ret = virtio_pci__specific_io_out(kvm, vdev, port, data, size, offset);
+		ret = virtio_pci__specific_data_out(kvm, vdev, data, size, offset);
 		break;
 	};
 
 	return ret;
 }
 
+static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	unsigned long offset;
+	struct virtio_device *vdev;
+	struct virtio_pci *vpci;
+
+	vdev = ioport->priv;
+	vpci = vdev->virtio;
+	offset = port - vpci->port_addr;
+
+	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
+}
+
 static struct ioport_operations virtio_pci__io_ops = {
 	.io_in	= virtio_pci__io_in,
 	.io_out	= virtio_pci__io_out,
@@ -320,7 +340,8 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 					   u64 addr, u8 *data, u32 len,
 					   u8 is_write, void *ptr)
 {
-	struct virtio_pci *vpci = ptr;
+	struct virtio_device *vdev = ptr;
+	struct virtio_pci *vpci = vdev->virtio;
 	struct msix_table *table;
 	int vecnum;
 	size_t offset;
@@ -419,11 +440,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 					 u64 addr, u8 *data, u32 len,
 					 u8 is_write, void *ptr)
 {
-	struct virtio_pci *vpci = ptr;
-	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
-	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
+	struct virtio_device *vdev = ptr;
+	struct virtio_pci *vpci = vdev->virtio;
 
-	kvm__emulate_io(vcpu, port, data, direction, len, 1);
+	if (!is_write)
+		virtio_pci__data_in(vcpu, vdev, addr - vpci->mmio_addr,
+				    data, len);
+	else
+		virtio_pci__data_out(vcpu, vdev, addr - vpci->mmio_addr,
+				     data, len);
 }
 
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
@@ -445,13 +470,13 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
 	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
-			       virtio_pci__io_mmio_callback, vpci);
+			       virtio_pci__io_mmio_callback, vdev);
 	if (r < 0)
 		goto free_ioport;
 
 	vpci->msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
 	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
-			       virtio_pci__msix_mmio_callback, vpci);
+			       virtio_pci__msix_mmio_callback, vdev);
 	if (r < 0)
 		goto free_mmio;
 
-- 
2.20.1

