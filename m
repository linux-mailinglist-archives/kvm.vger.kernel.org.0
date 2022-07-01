Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC92956359E
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiGAObO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiGAOay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 788DB3FBE1
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC70A1C2B;
        Fri,  1 Jul 2022 07:25:38 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3B7023F792;
        Fri,  1 Jul 2022 07:25:37 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 11/12] virtio/pci: Initialize all vectors to VIRTIO_MSI_NO_VECTOR
Date:   Fri,  1 Jul 2022 15:24:33 +0100
Message-Id: <20220701142434.75170-12-jean-philippe.brucker@arm.com>
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

According to the virtio spec, all vectors must be initialized to
VIRTIO_MSI_NO_VECTOR (0xffff). In 4.1.5.1.2.1 "Device Requirements:
MSI-X Vector Configuration":

    The device MUST return vector mapped to a given event, (NO_VECTOR if
    unmapped) on read of config_msix_vector/queue_msix_vector.

Currently we return 0, which is a valid MSI vector. Return NO_VECTOR
instead.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio-pci.h | 2 +-
 virtio/pci.c             | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index 47075334..4590d1b3 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -53,7 +53,7 @@ struct virtio_pci {
 	/* MSI-X */
 	u16			config_vector;
 	u32			config_gsi;
-	u32			vq_vector[VIRTIO_PCI_MAX_VQ];
+	u16			vq_vector[VIRTIO_PCI_MAX_VQ];
 	u32			gsis[VIRTIO_PCI_MAX_VQ];
 	u64			msix_pba;
 	struct msix_table	msix_table[VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG];
diff --git a/virtio/pci.c b/virtio/pci.c
index c645d4a0..cffabc76 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -404,7 +404,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	/* Both table and PBA are mapped to the same BAR (2) */
 	vpci->pci_hdr.msix.table_offset = cpu_to_le32(2);
 	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | VIRTIO_MSIX_TABLE_SIZE);
-	vpci->config_vector = 0;
+	vpci->config_vector = VIRTIO_MSI_NO_VECTOR;
+	/* Initialize all vq vectors to NO_VECTOR */
+	memset(vpci->vq_vector, 0xff, sizeof(vpci->vq_vector));
 
 	if (irq__can_signal_msi(kvm))
 		vpci->features |= VIRTIO_PCI_F_SIGNAL_MSI;
-- 
2.36.1

