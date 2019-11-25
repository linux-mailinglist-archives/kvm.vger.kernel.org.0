Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B756108BCA
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfKYKcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:47 -0500
Received: from foss.arm.com ([217.140.110.172]:47806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbfKYKcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0330D1045;
        Mon, 25 Nov 2019 02:32:46 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1C9623F52E;
        Mon, 25 Nov 2019 02:32:45 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 14/16] virtio/pci: Add support for BAR configuration
Date:   Mon, 25 Nov 2019 10:30:31 +0000
Message-Id: <20191125103033.22694-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A device's Memory or I/O space address can be written by software in a
Base Address Register (BAR). Allow the BARs to be programable by
registering the mmio or ioport emulation when access is enabled for that
region, not when the virtual machine is created.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/virtio-pci.h |   1 +
 virtio/pci.c             | 208 +++++++++++++++++++++++++++++++++------
 2 files changed, 179 insertions(+), 30 deletions(-)

diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index 278a25950d8b..9b3ad3d04d41 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -22,6 +22,7 @@ struct virtio_pci {
 	struct pci_device_header pci_hdr;
 	struct device_header	dev_hdr;
 	void			*dev;
+	struct virtio_device	*vdev;
 	struct kvm		*kvm;
 
 	u16			port_addr;
diff --git a/virtio/pci.c b/virtio/pci.c
index 9f86bb7b6f93..dadb796e6d62 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -463,6 +463,170 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 				     data, len);
 }
 
+static void virtio_pci__update_command(struct kvm *kvm,
+				       struct pci_device_header *pci_hdr,
+				       void *data, int sz)
+{
+	struct virtio_pci *vpci = container_of(pci_hdr, struct virtio_pci, pci_hdr);
+	u32 addr, mem_size;
+	u16 cmd;
+	int r;
+	bool toggle_io, toggle_mem;
+
+	cmd = ioport__read16(data);
+
+	toggle_io = !!((cmd ^ pci_hdr->command) & PCI_COMMAND_IO);
+	toggle_mem = !!((cmd ^ pci_hdr->command) & PCI_COMMAND_MEMORY);
+
+	if (toggle_io && (cmd & PCI_COMMAND_IO)) {
+		addr = pci_hdr->bar[0] & PCI_BASE_ADDRESS_IO_MASK;
+		mem_size = pci_hdr->bar_size[0];
+
+		r = ioport__register(kvm, addr, &virtio_pci__io_ops, mem_size,
+				     vpci->vdev);
+		if (r < 0) {
+			pr_err("ioport__register failed for memory region 0x%x@0x%x\n",
+			       mem_size, addr);
+			/* Drop writes. */
+			memcpy(data, (void *)&pci_hdr->command, sz);
+			goto mem_setup;
+		}
+		vpci->port_addr = (u16)r;
+	}
+
+	if (toggle_io && !(cmd & PCI_COMMAND_IO)) {
+		/* Same as for the memory BARs. */
+		memcpy((void *)&pci_hdr->command, data, sz);
+		ioport__unregister(kvm, vpci->port_addr);
+	}
+
+mem_setup:
+	if (toggle_mem && (cmd & PCI_COMMAND_MEMORY)) {
+		addr = pci_hdr->bar[1] & PCI_BASE_ADDRESS_MEM_MASK;
+		mem_size = pci_hdr->bar_size[1];
+		r = kvm__register_mmio(kvm, addr, mem_size, false,
+				       virtio_pci__io_mmio_callback, vpci->vdev);
+		if (r < 0) {
+			pr_err("kvm__register_mmio failed for memory region 0x%x@0x%x\n",
+			       mem_size, addr);
+			/* Treat it like a Master Abort and drop writes. */
+			memcpy(data, (void *)&pci_hdr->command, sz);
+			return;
+		}
+		vpci->mmio_addr = addr;
+
+		addr = pci_hdr->bar[2] & PCI_BASE_ADDRESS_MEM_MASK;
+		mem_size = pci_hdr->bar_size[2];
+		r = kvm__register_mmio(kvm, addr, mem_size, false,
+				       virtio_pci__msix_mmio_callback, vpci->vdev);
+		if (r < 0) {
+			pr_err("kvm__register_mmio failed for memory region 0x%x@0x%x\n",
+			       mem_size, addr);
+			kvm__deregister_mmio(kvm, pci_hdr->bar[1] & PCI_BASE_ADDRESS_MEM_MASK);
+			/* Drop writes. */
+			memcpy(data, (void *)&pci_hdr->command, sz);
+			return;
+		}
+		vpci->msix_io_block = addr;
+	}
+
+	if (toggle_mem && !(cmd & PCI_COMMAND_MEMORY)) {
+		/*
+		 * This is to prevent races - an access by another thread
+		 * initiated before the region is unregistered, but performed
+		 * after that, will see that memory access is disabled and won't
+		 * do any emulation.
+		 */
+		memcpy((void *)&pci_hdr->command, data, sz);
+		kvm__deregister_mmio(kvm, vpci->mmio_addr);
+		kvm__deregister_mmio(kvm, vpci->msix_io_block);
+	}
+}
+
+static void virtio_pci__update_bar(struct kvm *kvm,
+				   struct pci_device_header *pci_hdr,
+				   int bar_num, void *data, int sz)
+{
+	struct virtio_pci *vpci = container_of(pci_hdr, struct virtio_pci, pci_hdr);
+	u32 new_bar, old_bar;
+	u32 new_addr, mem_size;
+	int r;
+
+	if (bar_num > 2) {
+		/* BARs not implemented, ignore writes. */
+		bzero(data, sz);
+		return;
+	}
+
+	/*
+	 * The BARs are being configured when device access is disabled, the
+	 * memory will be registered for mmio/ioport emulation when the device
+	 * is actually enabled.
+	 */
+	if (bar_num == 0 && !(pci_hdr->command & PCI_COMMAND_IO))
+		return;
+	if (bar_num >= 1 && !(pci_hdr->command & PCI_COMMAND_MEMORY))
+		return;
+
+	new_bar = ioport__read32(data);
+	if (bar_num == 0)
+		new_addr = new_bar & PCI_BASE_ADDRESS_IO_MASK;
+	else
+		new_addr = new_bar & PCI_BASE_ADDRESS_MEM_MASK;
+	old_bar = pci_hdr->bar[bar_num];
+	mem_size = pci_hdr->bar_size[bar_num];
+
+	if (bar_num == 0) {
+		ioport__unregister(kvm, old_bar & PCI_BASE_ADDRESS_IO_MASK);
+		r = ioport__register(kvm, new_addr, &virtio_pci__io_ops,
+				     mem_size, vpci->vdev);
+		if (r < 0) {
+			pr_err("ioport__register failed for memory region 0x%x@0x%x\n",
+			       mem_size, new_addr);
+			/* Treat it like a Master Abort and drop writes. */
+			memcpy(data, (void *)&old_bar, sz);
+			return;
+		}
+		vpci->port_addr = (u16)r;
+	} else {
+		kvm__deregister_mmio(kvm, old_bar & PCI_BASE_ADDRESS_MEM_MASK);
+		if (bar_num == 1)
+			r = kvm__register_mmio(kvm, new_addr, mem_size, false,
+					       virtio_pci__io_mmio_callback,
+					       vpci->vdev);
+		else
+			r = kvm__register_mmio(kvm, new_addr, mem_size, false,
+					       virtio_pci__msix_mmio_callback,
+					       vpci->vdev);
+		if (r < 0) {
+			pr_err("kvm__register_mmio failed for memory region 0x%x@0x%x\n",
+			       mem_size, new_addr);
+			/* Drop writes. */
+			memcpy(data, (void *)&old_bar, sz);
+			return;
+		}
+		if (bar_num == 1)
+			vpci->mmio_addr = new_addr;
+		else
+			vpci->msix_io_block = new_addr;
+	}
+}
+
+static void virtio_pci__config_wr(struct kvm *kvm,
+                                 struct pci_device_header *pci_hdr,
+                                 u8 offset, void *data, int sz)
+{
+	int bar_num;
+
+	if (offset == PCI_COMMAND)
+		virtio_pci__update_command(kvm, pci_hdr, data, sz);
+
+	if (offset >= PCI_BASE_ADDRESS_0 && offset <= PCI_BASE_ADDRESS_5) {
+		bar_num = (offset - PCI_BASE_ADDRESS_0) / sizeof(u32);
+		virtio_pci__update_bar(kvm, pci_hdr, bar_num, data, sz);
+	}
+}
+
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
@@ -471,26 +635,14 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	vpci->kvm = kvm;
 	vpci->dev = dev;
+	vpci->vdev = vdev;
 
 	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
 
-	r = pci_get_io_port_block(PCI_IO_SIZE);
-	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
-	if (r < 0)
-		return r;
-	vpci->port_addr = (u16)r;
-
+	/* Let's have some sensible initial values for the BARs. */
+	vpci->port_addr = (u16)pci_get_io_port_block(PCI_IO_SIZE);
 	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
-	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
-			       virtio_pci__io_mmio_callback, vdev);
-	if (r < 0)
-		goto free_ioport;
-
 	vpci->msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
-	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
-			       virtio_pci__msix_mmio_callback, vdev);
-	if (r < 0)
-		goto free_mmio;
 
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
@@ -504,17 +656,21 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.class[2]		= (class >> 16) & 0xff,
 		.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
 		.subsys_id		= cpu_to_le16(subsys_id),
-		.bar[0]			= cpu_to_le32(vpci->port_addr
-							| PCI_BASE_ADDRESS_SPACE_IO),
-		.bar[1]			= cpu_to_le32(vpci->mmio_addr
-							| PCI_BASE_ADDRESS_SPACE_MEMORY),
-		.bar[2]			= cpu_to_le32(vpci->msix_io_block
-							| PCI_BASE_ADDRESS_SPACE_MEMORY),
+		/*
+		 * According to PCI Local Bus 3.0, read accesses to reserved or
+		 * unimplemented registers must be completed normally and a data
+		 * value of 0 returned. Set the bars to sensible addresses so
+		 * the guest does not think that they are not implemented.
+		 */
+		.bar[0]                 = vpci->port_addr | PCI_BASE_ADDRESS_SPACE_IO,
+		.bar[1]                 = vpci->mmio_addr | PCI_BASE_ADDRESS_SPACE_MEMORY,
+		.bar[2]                 = vpci->msix_io_block | PCI_BASE_ADDRESS_SPACE_MEMORY,
 		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
 		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
 		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
+		.cfg_ops.write		= virtio_pci__config_wr,
 	};
 
 	vpci->dev_hdr = (struct device_header) {
@@ -547,20 +703,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	r = device__register(&vpci->dev_hdr);
 	if (r < 0)
-		goto free_msix_mmio;
+		return r;
 
 	/* save the IRQ that device__register() has allocated */
 	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;
 
 	return 0;
-
-free_msix_mmio:
-	kvm__deregister_mmio(kvm, vpci->msix_io_block);
-free_mmio:
-	kvm__deregister_mmio(kvm, vpci->mmio_addr);
-free_ioport:
-	ioport__unregister(kvm, vpci->port_addr);
-	return r;
 }
 
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
-- 
2.20.1

