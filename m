Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F3563585
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiGAOar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiGAO3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:29:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98D8F3DA7E
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7ED7C143D;
        Fri,  1 Jul 2022 07:25:23 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DDEB03F792;
        Fri,  1 Jul 2022 07:25:21 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 02/12] virtio: Extract init_vq() for PCI and MMIO
Date:   Fri,  1 Jul 2022 15:24:24 +0100
Message-Id: <20220701142434.75170-3-jean-philippe.brucker@arm.com>
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

Modern virtio will need to reuse this code when initializing a
virtqueue. It's not much, but still nicer to have next to exit_vq().

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/mmio.c | 19 +++++++++++++++----
 virtio/pci.c  | 19 +++++++++++++++----
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/virtio/mmio.c b/virtio/mmio.c
index 268a4391..2a96e0e3 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -79,6 +79,20 @@ int virtio_mmio_signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 	return 0;
 }
 
+static int virtio_mmio_init_vq(struct kvm *kvm, struct virtio_device *vdev,
+			       int vq)
+{
+	int ret;
+	struct virtio_mmio *vmmio = vdev->virtio;
+
+	ret = virtio_mmio_init_ioeventfd(vmmio->kvm, vdev, vq);
+	if (ret) {
+		pr_err("couldn't add ioeventfd for vq %d: %d", vq, ret);
+		return ret;
+	}
+	return vdev->ops->init_vq(vmmio->kvm, vmmio->dev, vq);
+}
+
 static void virtio_mmio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 				int vq)
 {
@@ -200,10 +214,7 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 				.align	= vmmio->hdr.queue_align,
 				.pgsize	= vmmio->hdr.guest_page_size,
 			};
-			virtio_mmio_init_ioeventfd(vmmio->kvm, vdev,
-						   vmmio->hdr.queue_sel);
-			vdev->ops->init_vq(vmmio->kvm, vmmio->dev,
-					   vmmio->hdr.queue_sel);
+			virtio_mmio_init_vq(kvm, vdev, vmmio->hdr.queue_sel);
 		} else {
 			virtio_mmio_exit_vq(kvm, vdev, vmmio->hdr.queue_sel);
 		}
diff --git a/virtio/pci.c b/virtio/pci.c
index 9b710852..f0459925 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -128,6 +128,20 @@ free_ioport_evt:
 	return r;
 }
 
+static int virtio_pci_init_vq(struct kvm *kvm, struct virtio_device *vdev,
+			      int vq)
+{
+	int ret;
+	struct virtio_pci *vpci = vdev->virtio;
+
+	ret = virtio_pci__init_ioeventfd(kvm, vdev, vq);
+	if (ret) {
+		pr_err("couldn't add ioeventfd for vq %d: %d", vq, ret);
+		return ret;
+	}
+	return vdev->ops->init_vq(kvm, vpci->dev, vq);
+}
+
 static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 			       int vq)
 {
@@ -314,10 +328,7 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 				.align	= VIRTIO_PCI_VRING_ALIGN,
 				.pgsize	= 1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
 			};
-			virtio_pci__init_ioeventfd(kvm, vdev,
-						   vpci->queue_selector);
-			vdev->ops->init_vq(kvm, vpci->dev,
-					   vpci->queue_selector);
+			virtio_pci_init_vq(kvm, vdev, vpci->queue_selector);
 		} else {
 			virtio_pci_exit_vq(kvm, vdev, vpci->queue_selector);
 		}
-- 
2.36.1

