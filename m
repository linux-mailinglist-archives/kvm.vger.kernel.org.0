Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EE9563584
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiGAOam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiGAO3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:29:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 596DA3A181
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB2D61424;
        Fri,  1 Jul 2022 07:25:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 47CA83F792;
        Fri,  1 Jul 2022 07:25:20 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 01/12] virtio/pci: Delete MSI routes
Date:   Fri,  1 Jul 2022 15:24:23 +0100
Message-Id: <20220701142434.75170-2-jean-philippe.brucker@arm.com>
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

On exit_vq() and device reset, remove the MSI routes that were set up at
runtime.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/pci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/virtio/pci.c b/virtio/pci.c
index 1a549314..9b710852 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -60,6 +60,13 @@ static int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec)
 	return gsi;
 }
 
+static void virtio_pci__del_msix_route(struct virtio_pci *vpci, u32 gsi)
+{
+	struct msi_msg msg = { 0 };
+
+	irq__update_msix_route(vpci->kvm, gsi, &msg);
+}
+
 static void virtio_pci__ioevent_callback(struct kvm *kvm, void *param)
 {
 	struct virtio_pci_ioevent_param *ioeventfd = param;
@@ -128,6 +135,9 @@ static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
 	u16 port_addr = virtio_pci__port_addr(vpci);
 
+	virtio_pci__del_msix_route(vpci, vpci->gsis[vq]);
+	vpci->gsis[vq] = 0;
+	vpci->vq_vector[vq] = VIRTIO_MSI_NO_VECTOR;
 	ioeventfd__del_event(mmio_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
 	ioeventfd__del_event(port_addr + VIRTIO_PCI_QUEUE_NOTIFY, vq);
 	virtio_exit_vq(kvm, vdev, vpci->dev, vq);
@@ -623,6 +633,10 @@ int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
 	unsigned int vq;
 	struct virtio_pci *vpci = vdev->virtio;
 
+	virtio_pci__del_msix_route(vpci, vpci->config_gsi);
+	vpci->config_gsi = 0;
+	vpci->config_vector = VIRTIO_MSI_NO_VECTOR;
+
 	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
 		virtio_pci_exit_vq(kvm, vdev, vq);
 
-- 
2.36.1

