Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4590433BFFB
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhCOPfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:35:06 -0400
Received: from foss.arm.com ([217.140.110.172]:50810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhCOPei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 11:34:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94904106F;
        Mon, 15 Mar 2021 08:34:37 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AEF13F792;
        Mon, 15 Mar 2021 08:34:36 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v3 17/22] virtio: Switch trap handling to use MMIO handler
Date:   Mon, 15 Mar 2021 15:33:45 +0000
Message-Id: <20210315153350.19988-18-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO prototype.

Adjust the existing MMIO callback routine to automatically determine
the region this trap came through, and call the existing I/O handlers.
Register the ioport region using the new registration function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virtio/pci.c | 46 ++++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 6eea6c68..eb91f512 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -178,15 +178,6 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
 	return ret;
 }
 
-static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	struct virtio_device *vdev = ioport->priv;
-	struct virtio_pci *vpci = vdev->virtio;
-	unsigned long offset = port - virtio_pci__port_addr(vpci);
-
-	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
-}
-
 static void update_msix_map(struct virtio_pci *vpci,
 			    struct msix_table *msix_entry, u32 vecnum)
 {
@@ -334,20 +325,6 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	return ret;
 }
 
-static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	struct virtio_device *vdev = ioport->priv;
-	struct virtio_pci *vpci = vdev->virtio;
-	unsigned long offset = port - virtio_pci__port_addr(vpci);
-
-	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
-}
-
-static struct ioport_operations virtio_pci__io_ops = {
-	.io_in	= virtio_pci__io_in,
-	.io_out	= virtio_pci__io_out,
-};
-
 static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 					   u64 addr, u8 *data, u32 len,
 					   u8 is_write, void *ptr)
@@ -455,12 +432,19 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 {
 	struct virtio_device *vdev = ptr;
 	struct virtio_pci *vpci = vdev->virtio;
-	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
+	u32 ioport_addr = virtio_pci__port_addr(vpci);
+	u32 base_addr;
+
+	if (addr >= ioport_addr &&
+	    addr < ioport_addr + pci__bar_size(&vpci->pci_hdr, 0))
+		base_addr = ioport_addr;
+	else
+		base_addr = virtio_pci__mmio_addr(vpci);
 
 	if (!is_write)
-		virtio_pci__data_in(vcpu, vdev, addr - mmio_addr, data, len);
+		virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
 	else
-		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
+		virtio_pci__data_out(vcpu, vdev, addr - base_addr, data, len);
 }
 
 static int virtio_pci__bar_activate(struct kvm *kvm,
@@ -478,10 +462,8 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
 
 	switch (bar_num) {
 	case 0:
-		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
-				     bar_size, vdev);
-		if (r > 0)
-			r = 0;
+		r = kvm__register_pio(kvm, bar_addr, bar_size,
+				      virtio_pci__io_mmio_callback, vdev);
 		break;
 	case 1:
 		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
@@ -510,7 +492,7 @@ static int virtio_pci__bar_deactivate(struct kvm *kvm,
 
 	switch (bar_num) {
 	case 0:
-		r = ioport__unregister(kvm, bar_addr);
+		r = kvm__deregister_pio(kvm, bar_addr);
 		break;
 	case 1:
 	case 2:
@@ -625,7 +607,7 @@ int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev)
 	virtio_pci__reset(kvm, vdev);
 	kvm__deregister_mmio(kvm, virtio_pci__mmio_addr(vpci));
 	kvm__deregister_mmio(kvm, virtio_pci__msix_io_addr(vpci));
-	ioport__unregister(kvm, virtio_pci__port_addr(vpci));
+	kvm__deregister_pio(kvm, virtio_pci__port_addr(vpci));
 
 	return 0;
 }
-- 
2.17.5

