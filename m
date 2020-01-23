Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F3814699B
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgAWNss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:48 -0500
Received: from foss.arm.com ([217.140.110.172]:39816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgAWNsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50408FEC;
        Thu, 23 Jan 2020 05:48:46 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4FB433F68E;
        Thu, 23 Jan 2020 05:48:45 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 21/30] virtio/pci: Get emulated region address from BARs
Date:   Thu, 23 Jan 2020 13:47:56 +0000
Message-Id: <20200123134805.1993-22-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The struct virtio_pci fields port_addr, mmio_addr and msix_io_block
represent the same addresses that are written in the corresponding BARs.
Remove this duplication of information and always use the address from the
BAR. This will make our life a lot easier when we add support for
reassignable BARs, because we won't have to update the fields on each BAR
change.

No functional changes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/virtio-pci.h |  3 --
 virtio/pci.c             | 86 ++++++++++++++++++++++++++--------------
 2 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index 278a25950d8b..959b4b81c871 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -24,8 +24,6 @@ struct virtio_pci {
 	void			*dev;
 	struct kvm		*kvm;
 
-	u16			port_addr;
-	u32			mmio_addr;
 	u8			status;
 	u8			isr;
 	u32			features;
@@ -43,7 +41,6 @@ struct virtio_pci {
 	u32			config_gsi;
 	u32			vq_vector[VIRTIO_PCI_MAX_VQ];
 	u32			gsis[VIRTIO_PCI_MAX_VQ];
-	u32			msix_io_block;
 	u64			msix_pba;
 	struct msix_table	msix_table[VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG];
 
diff --git a/virtio/pci.c b/virtio/pci.c
index 6723a1f3a84d..c4822514856c 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -13,6 +13,21 @@
 #include <linux/byteorder.h>
 #include <string.h>
 
+static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
+{
+	return pci__bar_address(&vpci->pci_hdr, 0);
+}
+
+static u32 virtio_pci__mmio_addr(struct virtio_pci *vpci)
+{
+	return pci__bar_address(&vpci->pci_hdr, 1);
+}
+
+static u32 virtio_pci__msix_io_addr(struct virtio_pci *vpci)
+{
+	return pci__bar_address(&vpci->pci_hdr, 2);
+}
+
 static void virtio_pci__ioevent_callback(struct kvm *kvm, void *param)
 {
 	struct virtio_pci_ioevent_param *ioeventfd = param;
@@ -25,6 +40,8 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 {
 	struct ioevent ioevent;
 	struct virtio_pci *vpci = vdev->virtio;
+	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
+	u16 port_addr = virtio_pci__port_addr(vpci);
 	int r, flags = 0;
 	int fd;
 
@@ -48,7 +65,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 		flags |= IOEVENTFD_FLAG_USER_POLL;
 
 	/* ioport */
-	ioevent.io_addr	= vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY;
+	ioevent.io_addr	= port_addr + VIRTIO_PCI_QUEUE_NOTIFY;
 	ioevent.io_len	= sizeof(u16);
 	ioevent.fd	= fd = eventfd(0, 0);
 	r = ioeventfd__add_event(&ioevent, flags | IOEVENTFD_FLAG_PIO);
@@ -56,7 +73,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 		return r;
 
 	/* mmio */
-	ioevent.io_addr	= vpci->mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY;
+	ioevent.io_addr	= mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY;
 	ioevent.io_len	= sizeof(u16);
 	ioevent.fd	= eventfd(0, 0);
 	r = ioeventfd__add_event(&ioevent, flags);
@@ -68,7 +85,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 	return 0;
 
 free_ioport_evt:
-	ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
 	return r;
 }
 
@@ -76,9 +93,11 @@ static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 			       int vq)
 {
 	struct virtio_pci *vpci = vdev->virtio;
+	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
+	u16 port_addr = virtio_pci__port_addr(vpci);
 
-	ioeventfd__del_event(vpci->mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
-	ioeventfd__del_event(vpci->port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
 	virtio_exit_vq(kvm, vdev, vpci->dev, vq);
 }
 
@@ -163,10 +182,12 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 	unsigned long offset;
 	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
+	u16 port_addr;
 
 	vdev = ioport->priv;
 	vpci = vdev->virtio;
-	offset = port - vpci->port_addr;
+	port_addr = virtio_pci__port_addr(vpci);
+	offset = port - port_addr;
 
 	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
 }
@@ -323,10 +344,12 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 	unsigned long offset;
 	struct virtio_device *vdev;
 	struct virtio_pci *vpci;
+	u16 port_addr;
 
 	vdev = ioport->priv;
 	vpci = vdev->virtio;
-	offset = port - vpci->port_addr;
+	port_addr = virtio_pci__port_addr(vpci);
+	offset = port - port_addr;
 
 	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
 }
@@ -343,17 +366,18 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 	struct virtio_device *vdev = ptr;
 	struct virtio_pci *vpci = vdev->virtio;
 	struct msix_table *table;
+	u32 msix_io_addr = virtio_pci__msix_io_addr(vpci);
 	int vecnum;
 	size_t offset;
 
-	if (addr > vpci->msix_io_block + PCI_IO_SIZE) {
+	if (addr > msix_io_addr + PCI_IO_SIZE) {
 		if (is_write)
 			return;
 		table  = (struct msix_table *)&vpci->msix_pba;
-		offset = addr - (vpci->msix_io_block + PCI_IO_SIZE);
+		offset = addr - (msix_io_addr + PCI_IO_SIZE);
 	} else {
 		table  = vpci->msix_table;
-		offset = addr - vpci->msix_io_block;
+		offset = addr - msix_io_addr;
 	}
 	vecnum = offset / sizeof(struct msix_table);
 	offset = offset % sizeof(struct msix_table);
@@ -442,19 +466,20 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 {
 	struct virtio_device *vdev = ptr;
 	struct virtio_pci *vpci = vdev->virtio;
+	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
 
 	if (!is_write)
-		virtio_pci__data_in(vcpu, vdev, addr - vpci->mmio_addr,
-				    data, len);
+		virtio_pci__data_in(vcpu, vdev, addr - mmio_addr, data, len);
 	else
-		virtio_pci__data_out(vcpu, vdev, addr - vpci->mmio_addr,
-				     data, len);
+		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
 }
 
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
 	struct virtio_pci *vpci = vdev->virtio;
+	u32 mmio_addr, msix_io_block;
+	u16 port_addr;
 	int r;
 
 	vpci->kvm = kvm;
@@ -462,20 +487,21 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
 
-	r = pci_get_io_port_block(PCI_IO_SIZE);
-	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
+	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
+	r = ioport__register(kvm, port_addr, &virtio_pci__io_ops, PCI_IO_SIZE,
+			     vdev);
 	if (r < 0)
 		return r;
-	vpci->port_addr = (u16)r;
+	port_addr = (u16)r;
 
-	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
-	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
+	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
+	r = kvm__register_mmio(kvm, mmio_addr, PCI_IO_SIZE, false,
 			       virtio_pci__io_mmio_callback, vdev);
 	if (r < 0)
 		goto free_ioport;
 
-	vpci->msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
-	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
+	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
+	r = kvm__register_mmio(kvm, msix_io_block, PCI_IO_SIZE * 2, false,
 			       virtio_pci__msix_mmio_callback, vdev);
 	if (r < 0)
 		goto free_mmio;
@@ -491,11 +517,11 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.class[2]		= (class >> 16) & 0xff,
 		.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
 		.subsys_id		= cpu_to_le16(subsys_id),
-		.bar[0]			= cpu_to_le32(vpci->port_addr
+		.bar[0]			= cpu_to_le32(port_addr
 							| PCI_BASE_ADDRESS_SPACE_IO),
-		.bar[1]			= cpu_to_le32(vpci->mmio_addr
+		.bar[1]			= cpu_to_le32(mmio_addr
 							| PCI_BASE_ADDRESS_SPACE_MEMORY),
-		.bar[2]			= cpu_to_le32(vpci->msix_io_block
+		.bar[2]			= cpu_to_le32(msix_io_block
 							| PCI_BASE_ADDRESS_SPACE_MEMORY),
 		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
 		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
@@ -542,11 +568,11 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	return 0;
 
 free_msix_mmio:
-	kvm__deregister_mmio(kvm, vpci->msix_io_block);
+	kvm__deregister_mmio(kvm, msix_io_block);
 free_mmio:
-	kvm__deregister_mmio(kvm, vpci->mmio_addr);
+	kvm__deregister_mmio(kvm, mmio_addr);
 free_ioport:
-	ioport__unregister(kvm, vpci->port_addr);
+	ioport__unregister(kvm, port_addr);
 	return r;
 }
 
@@ -566,9 +592,9 @@ int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
 	struct virtio_pci *vpci = vdev->virtio;
 
 	virtio_pci__reset(kvm, vdev);
-	kvm__deregister_mmio(kvm, vpci->mmio_addr);
-	kvm__deregister_mmio(kvm, vpci->msix_io_block);
-	ioport__unregister(kvm, vpci->port_addr);
+	kvm__deregister_mmio(kvm, virtio_pci__mmio_addr(vpci));
+	kvm__deregister_mmio(kvm, virtio_pci__msix_io_addr(vpci));
+	ioport__unregister(kvm, virtio_pci__port_addr(vpci));
 
 	return 0;
 }
-- 
2.20.1

