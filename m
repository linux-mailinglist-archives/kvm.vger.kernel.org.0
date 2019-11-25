Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3F1108BC6
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfKYKcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:43 -0500
Received: from foss.arm.com ([217.140.110.172]:47778 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfKYKcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D33555D;
        Mon, 25 Nov 2019 02:32:42 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B329F3F52E;
        Mon, 25 Nov 2019 02:32:41 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 11/16] virtio/pci: Ignore MMIO and I/O accesses when they are disabled
Date:   Mon, 25 Nov 2019 10:30:28 +0000
Message-Id: <20191125103033.22694-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A device's response to memory or I/O accesses is disabled when Memory
Space, respectively I/O Space, is set to 0 in the Command register.
According to the PCI Local Bus Specification Revision 3.0, those two
bits reset to 0.

Let's respect the specifiction, so set Command and I/O Space to 0 on
reset, and ignore accesses to a device's respective regions when they
are disabled.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virtio/pci.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 6723a1f3a84d..9f86bb7b6f93 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -168,6 +168,9 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 p
 	vpci = vdev->virtio;
 	offset = port - vpci->port_addr;
 
+	if (!(vpci->pci_hdr.command & PCI_COMMAND_IO))
+		return true;
+
 	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
 }
 
@@ -328,6 +331,9 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
 	vpci = vdev->virtio;
 	offset = port - vpci->port_addr;
 
+	if (!(vpci->pci_hdr.command & PCI_COMMAND_IO))
+		return true;
+
 	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
 }
 
@@ -346,6 +352,9 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 	int vecnum;
 	size_t offset;
 
+	if (!(vpci->pci_hdr.command & PCI_COMMAND_MEMORY))
+		return;
+
 	if (addr > vpci->msix_io_block + PCI_IO_SIZE) {
 		if (is_write)
 			return;
@@ -443,6 +452,9 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 	struct virtio_device *vdev = ptr;
 	struct virtio_pci *vpci = vdev->virtio;
 
+	if (!(vpci->pci_hdr.command & PCI_COMMAND_MEMORY))
+		return;
+
 	if (!is_write)
 		virtio_pci__data_in(vcpu, vdev, addr - vpci->mmio_addr,
 				    data, len);
@@ -483,7 +495,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
 		.device_id		= cpu_to_le16(device_id),
-		.command		= PCI_COMMAND_IO | PCI_COMMAND_MEMORY,
+		/* The Command register is 0 on RST. */
+		.command		= 0,
 		.header_type		= PCI_HEADER_TYPE_NORMAL,
 		.revision_id		= 0,
 		.class[0]		= class & 0xff,
-- 
2.20.1

