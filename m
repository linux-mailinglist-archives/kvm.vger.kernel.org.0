Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B0454044D
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbiFGRDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345397AbiFGRDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56ED6FF5A1
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2561D1480;
        Tue,  7 Jun 2022 10:03:39 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B6AC53F66F;
        Tue,  7 Jun 2022 10:03:37 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 16/24] virtio/pci: Factor MSI route creation
Date:   Tue,  7 Jun 2022 18:02:31 +0100
Message-Id: <20220607170239.120084-17-jean-philippe.brucker@arm.com>
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

The code for creating an MSI route is already duplicated between config
and virtqueue MSI. Modern virtio will need it as well, so move it to a
separate function.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/pci.c | 60 +++++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 85018e79..1a549314 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -37,6 +37,29 @@ static u32 virtio_pci__msix_io_addr(struct virtio_pci *vpci)
 	return pci__bar_address(&vpci->pci_hdr, 2);
 }
 
+static int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec)
+{
+	int gsi;
+	struct msi_msg *msg;
+
+	if (vec == VIRTIO_MSI_NO_VECTOR)
+		return -EINVAL;
+
+	msg = &vpci->msix_table[vec].msg;
+	gsi = irq__add_msix_route(vpci->kvm, msg, vpci->dev_hdr.dev_num << 3);
+	/*
+	 * We don't need IRQ routing if we can use
+	 * MSI injection via the KVM_SIGNAL_MSI ioctl.
+	 */
+	if (gsi == -ENXIO && vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
+		return gsi;
+
+	if (gsi < 0)
+		die("failed to configure MSIs");
+
+	return gsi;
+}
+
 static void virtio_pci__ioevent_callback(struct kvm *kvm, void *param)
 {
 	struct virtio_pci_ioevent_param *ioeventfd = param;
@@ -219,24 +242,10 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 		switch (offset) {
 		case VIRTIO_MSI_CONFIG_VECTOR:
 			vec = vpci->config_vector = ioport__read16(data);
-			if (vec == VIRTIO_MSI_NO_VECTOR)
-				break;
-
-			gsi = irq__add_msix_route(kvm,
-						  &vpci->msix_table[vec].msg,
-						  vpci->dev_hdr.dev_num << 3);
-			/*
-			 * We don't need IRQ routing if we can use
-			 * MSI injection via the KVM_SIGNAL_MSI ioctl.
-			 */
-			if (gsi == -ENXIO &&
-			    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
-				break;
 
-			if (gsi < 0) {
-				die("failed to configure MSIs");
+			gsi = virtio_pci__add_msix_route(vpci, vec);
+			if (gsi < 0)
 				break;
-			}
 
 			vpci->config_gsi = gsi;
 			break;
@@ -244,24 +253,9 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 			vec = ioport__read16(data);
 			vpci->vq_vector[vpci->queue_selector] = vec;
 
-			if (vec == VIRTIO_MSI_NO_VECTOR)
-				break;
-
-			gsi = irq__add_msix_route(kvm,
-						  &vpci->msix_table[vec].msg,
-						  vpci->dev_hdr.dev_num << 3);
-			/*
-			 * We don't need IRQ routing if we can use
-			 * MSI injection via the KVM_SIGNAL_MSI ioctl.
-			 */
-			if (gsi == -ENXIO &&
-			    vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
-				break;
-
-			if (gsi < 0) {
-				die("failed to configure MSIs");
+			gsi = virtio_pci__add_msix_route(vpci, vec);
+			if (gsi < 0)
 				break;
-			}
 
 			vpci->gsis[vpci->queue_selector] = gsi;
 			if (vdev->ops->notify_vq_gsi)
-- 
2.36.1

