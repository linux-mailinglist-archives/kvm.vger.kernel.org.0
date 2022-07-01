Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB1056359D
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbiGAObQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiGAOay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F5663FBF9
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C2FD1CC4;
        Fri,  1 Jul 2022 07:25:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CE9513F792;
        Fri,  1 Jul 2022 07:25:38 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 12/12] virtio/pci: Remove VIRTIO_PCI_F_SIGNAL_MSI
Date:   Fri,  1 Jul 2022 15:24:34 +0100
Message-Id: <20220701142434.75170-13-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
References: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
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

VIRTIO_PCI_F_SIGNAL_MSI is not a virtio feature but an internal flag.
Change it to bool to avoid confusion.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio-pci.h | 4 +---
 virtio/pci.c             | 8 ++++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index 4590d1b3..143028b1 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -20,8 +20,6 @@ struct virtio_pci_ioevent_param {
 	u32			vq;
 };
 
-#define VIRTIO_PCI_F_SIGNAL_MSI (1 << 0)
-
 #define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
 #define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
 #define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
@@ -36,11 +34,11 @@ struct virtio_pci {
 	struct kvm		*kvm;
 
 	u32			doorbell_offset;
+	bool			signal_msi;
 	u8			status;
 	u8			isr;
 	u32			device_features_sel;
 	u32			driver_features_sel;
-	u32			features;
 
 	/*
 	 * We cannot rely on the INTERRUPT_LINE byte in the config space once
diff --git a/virtio/pci.c b/virtio/pci.c
index cffabc76..701f4566 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -28,7 +28,7 @@ int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec)
 	 * We don't need IRQ routing if we can use
 	 * MSI injection via the KVM_SIGNAL_MSI ioctl.
 	 */
-	if (gsi == -ENXIO && vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
+	if (gsi == -ENXIO && vpci->signal_msi)
 		return gsi;
 
 	if (gsi < 0)
@@ -234,7 +234,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 			return 0;
 		}
 
-		if (vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
+		if (vpci->signal_msi)
 			virtio_pci__signal_msi(kvm, vpci, vpci->vq_vector[vq]);
 		else
 			kvm__irq_trigger(kvm, vpci->gsis[vq]);
@@ -258,7 +258,7 @@ int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev)
 			return 0;
 		}
 
-		if (vpci->features & VIRTIO_PCI_F_SIGNAL_MSI)
+		if (vpci->signal_msi)
 			virtio_pci__signal_msi(kvm, vpci, tbl);
 		else
 			kvm__irq_trigger(kvm, vpci->config_gsi);
@@ -409,7 +409,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	memset(vpci->vq_vector, 0xff, sizeof(vpci->vq_vector));
 
 	if (irq__can_signal_msi(kvm))
-		vpci->features |= VIRTIO_PCI_F_SIGNAL_MSI;
+		vpci->signal_msi = true;
 
 	vpci->legacy_irq_line = pci__assign_irq(&vpci->pci_hdr);
 
-- 
2.36.1

