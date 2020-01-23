Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D90C146990
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAWNsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:31 -0500
Received: from foss.arm.com ([217.140.110.172]:39704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbgAWNsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:30 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE76111B3;
        Thu, 23 Jan 2020 05:48:29 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8D5473F68E;
        Thu, 23 Jan 2020 05:48:28 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 kvmtool 08/30] pci: Fix ioport allocation size
Date:   Thu, 23 Jan 2020 13:47:43 +0000
Message-Id: <20200123134805.1993-9-alexandru.elisei@arm.com>
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

The PCI Local Bus Specification, Rev. 3.0,
Section 6.2.5.1. "Address Maps" states:
"Devices that map control functions into I/O Space must not consume more
than 256 bytes per I/O Base Address register."

Yet all the PCI devices allocate IO ports of IOPORT_SIZE (= 1024 bytes).

Fix this by having PCI devices use 256 bytes ports for IO BARs.

There is no hard requirement on the size of the memory region described
by memory BARs. Since BAR 1 is supposed to offer the same functionality as
IO ports, let's make its size match BAR 0.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
[Added rationale for changing BAR1 size to PCI_IO_SIZE]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c            |  4 ++--
 include/kvm/ioport.h |  1 -
 pci.c                |  2 +-
 virtio/pci.c         | 15 +++++++--------
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index 24fb46faad3b..d8d91aa9c873 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -63,8 +63,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
 		return NULL;
-	r = pci_get_io_port_block(IOPORT_SIZE);
-	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
+	r = pci_get_io_port_block(PCI_IO_SIZE);
+	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
 	if (r < 0)
 		return ERR_PTR(r);
 
diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index b10fcd5b4412..8c86b7151f25 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -14,7 +14,6 @@
 
 /* some ports we reserve for own use */
 #define IOPORT_DBG			0xe0
-#define IOPORT_SIZE			0x400
 
 struct kvm;
 
diff --git a/pci.c b/pci.c
index 80b5c5d3d7f3..b6892d974c08 100644
--- a/pci.c
+++ b/pci.c
@@ -20,7 +20,7 @@ static u16 io_port_blocks		= PCI_IOPORT_START;
 
 u16 pci_get_io_port_block(u32 size)
 {
-	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
+	u16 port = ALIGN(io_port_blocks, PCI_IO_SIZE);
 
 	io_port_blocks = port + size;
 	return port;
diff --git a/virtio/pci.c b/virtio/pci.c
index d73414abde05..eeb5b5efa6e1 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -421,7 +421,7 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 {
 	struct virtio_pci *vpci = ptr;
 	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
-	u16 port = vpci->port_addr + (addr & (IOPORT_SIZE - 1));
+	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
 
 	kvm__emulate_io(vcpu, port, data, direction, len, 1);
 }
@@ -435,17 +435,16 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	vpci->kvm = kvm;
 	vpci->dev = dev;
 
-	BUILD_BUG_ON(!is_power_of_two(IOPORT_SIZE));
 	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
 
-	r = pci_get_io_port_block(IOPORT_SIZE);
-	r = ioport__register(kvm, r, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
+	r = pci_get_io_port_block(PCI_IO_SIZE);
+	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
 	if (r < 0)
 		return r;
 	vpci->port_addr = (u16)r;
 
-	vpci->mmio_addr = pci_get_mmio_block(IOPORT_SIZE);
-	r = kvm__register_mmio(kvm, vpci->mmio_addr, IOPORT_SIZE, false,
+	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
+	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
 			       virtio_pci__io_mmio_callback, vpci);
 	if (r < 0)
 		goto free_ioport;
@@ -475,8 +474,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 							| PCI_BASE_ADDRESS_SPACE_MEMORY),
 		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
 		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
-		.bar_size[0]		= cpu_to_le32(IOPORT_SIZE),
-		.bar_size[1]		= cpu_to_le32(IOPORT_SIZE),
+		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
+		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
 	};
 
-- 
2.20.1

