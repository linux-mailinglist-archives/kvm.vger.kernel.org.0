Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8CF540450
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345412AbiFGRD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiFGRDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20FE11021FB
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:44 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 019DA1480;
        Tue,  7 Jun 2022 10:03:44 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8CE063F66F;
        Tue,  7 Jun 2022 10:03:42 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 19/24] virtio/pci: Make doorbell offset dynamic
Date:   Tue,  7 Jun 2022 18:02:34 +0100
Message-Id: <20220607170239.120084-20-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The doorbell offset depends on the transport - virtio-legacy uses a
fixed offset, but modern virtio can have per-vq offsets. Add an offset
field to the virtio_pci structure.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio-pci.h |  1 +
 virtio/pci.c             | 14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index 959b4b81..d64e5c99 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -24,6 +24,7 @@ struct virtio_pci {
 	void			*dev;
 	struct kvm		*kvm;
 
+	u32			doorbell_offset;
 	u8			status;
 	u8			isr;
 	u32			features;
diff --git a/virtio/pci.c b/virtio/pci.c
index f0459925..c02534a6 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -81,6 +81,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
 	u16 port_addr = virtio_pci__port_addr(vpci);
+	off_t offset = vpci->doorbell_offset;
 	int r, flags = 0;
 	int fd;
 
@@ -104,7 +105,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 		flags |= IOEVENTFD_FLAG_USER_POLL;
 
 	/* ioport */
-	ioevent.io_addr	= port_addr + VIRTIO_PCI_QUEUE_NOTIFY;
+	ioevent.io_addr	= port_addr + offset;
 	ioevent.io_len	= sizeof(u16);
 	ioevent.fd	= fd = eventfd(0, 0);
 	r = ioeventfd__add_event(&ioevent, flags | IOEVENTFD_FLAG_PIO);
@@ -112,7 +113,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 		return r;
 
 	/* mmio */
-	ioevent.io_addr	= mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY;
+	ioevent.io_addr	= mmio_addr + offset;
 	ioevent.io_len	= sizeof(u16);
 	ioevent.fd	= eventfd(0, 0);
 	r = ioeventfd__add_event(&ioevent, flags);
@@ -124,7 +125,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vde
 	return 0;
 
 free_ioport_evt:
-	ioeventfd__del_event(port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(port_addr + offset, vq);
 	return r;
 }
 
@@ -148,12 +149,13 @@ static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
 	u16 port_addr = virtio_pci__port_addr(vpci);
+	off_t offset = vpci->doorbell_offset;
 
 	virtio_pci__del_msix_route(vpci, vpci->gsis[vq]);
 	vpci->gsis[vq] = 0;
 	vpci->vq_vector[vq] = VIRTIO_MSI_NO_VECTOR;
-	ioeventfd__del_event(mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
-	ioeventfd__del_event(port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
+	ioeventfd__del_event(mmio_addr + offset, vq);
+	ioeventfd__del_event(port_addr + offset, vq);
 	virtio_exit_vq(kvm, vdev, vpci->dev, vq);
 }
 
@@ -571,6 +573,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
 	msix_io_block = pci_get_mmio_block(VIRTIO_MSIX_BAR_SIZE);
 
+	vpci->doorbell_offset = VIRTIO_PCI_QUEUE_NOTIFY;
+
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
 		.device_id		= cpu_to_le16(device_id),
-- 
2.36.1

