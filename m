Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7077A540449
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbiFGRDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345378AbiFGRDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 265E2FF586
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A702E1480;
        Tue,  7 Jun 2022 10:03:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 479683F66F;
        Tue,  7 Jun 2022 10:03:31 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 12/24] virtio/net: Prepare for modern virtio
Date:   Tue,  7 Jun 2022 18:02:27 +0100
Message-Id: <20220607170239.120084-13-jean-philippe.brucker@arm.com>
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

The virtio_net header contains a 'num_buffers' field, used when the
VIRTIO_NET_F_MRG_RXBUF feature is negotiated. The legacy driver does not
present this field when the feature is not negotiated. In that case the
header is 2 bytes smaller.

When using the modern virtio transport, the header always contains the
field and in addition the device MUST set it to 1 when the
VIRTIO_NET_F_MRG_RXBUF is not negotiated. Prepare for modern virtio
support by enabling this case once the 'legacy' flag is switched off.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio.h |  1 +
 virtio/core.c        |  2 ++
 virtio/net.c         | 25 ++++++++++++++++++-------
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 2da5e4f6..8c05bae2 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -198,6 +198,7 @@ enum virtio_trans {
 };
 
 struct virtio_device {
+	bool			legacy;
 	bool			use_vhost;
 	void			*virtio;
 	struct virtio_ops	*ops;
diff --git a/virtio/core.c b/virtio/core.c
index 568667f2..09abbf40 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -330,6 +330,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	switch (trans) {
 	case VIRTIO_PCI:
+		vdev->legacy			= true;
 		virtio = calloc(sizeof(struct virtio_pci), 1);
 		if (!virtio)
 			return -ENOMEM;
@@ -343,6 +344,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		r = vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
 		break;
 	case VIRTIO_MMIO:
+		vdev->legacy			= true;
 		virtio = calloc(sizeof(struct virtio_mmio), 1);
 		if (!virtio)
 			return -ENOMEM;
diff --git a/virtio/net.c b/virtio/net.c
index 70002f72..985642f6 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -81,6 +81,15 @@ static bool has_virtio_feature(struct net_dev *ndev, u32 feature)
 	return ndev->vdev.features & (1 << feature);
 }
 
+static int virtio_net_hdr_len(struct net_dev *ndev)
+{
+	if (has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF) ||
+	    !ndev->vdev.legacy)
+		return sizeof(struct virtio_net_hdr_mrg_rxbuf);
+
+	return sizeof(struct virtio_net_hdr);
+}
+
 static void *virtio_net_rx_thread(void *p)
 {
 	struct iovec iov[VIRTIO_NET_QUEUE_SIZE];
@@ -133,7 +142,13 @@ static void *virtio_net_rx_thread(void *p)
 				head = virt_queue__get_iov(vq, iov, &out, &in, kvm);
 			}
 
-			if (has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF))
+			/*
+			 * The device MUST set num_buffers, except in the case
+			 * where the legacy driver did not negotiate
+			 * VIRTIO_NET_F_MRG_RXBUF and the field does not exist.
+			 */
+			if (has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF) ||
+			    !ndev->vdev.legacy)
 				hdr->num_buffers = virtio_host_to_guest_u16(vq, num_buffers);
 
 			virt_queue__used_idx_advance(vq, num_buffers);
@@ -301,9 +316,7 @@ static bool virtio_net__tap_init(struct net_dev *ndev)
 	const struct virtio_net_params *params = ndev->params;
 	bool skipconf = !!params->tapif;
 
-	hdr_len = has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF) ?
-			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
-			sizeof(struct virtio_net_hdr);
+	hdr_len = virtio_net_hdr_len(ndev);
 	if (ioctl(ndev->tap_fd, TUNSETVNETHDRSZ, &hdr_len) < 0)
 		pr_warning("Config tap device TUNSETVNETHDRSZ error");
 
@@ -521,9 +534,7 @@ static void virtio_net_start(struct net_dev *ndev)
 				virtio_net__vhost_set_features(ndev) != 0)
 			die_perror("VHOST_SET_FEATURES failed");
 	} else {
-		ndev->info.vnet_hdr_len = has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF) ?
-						sizeof(struct virtio_net_hdr_mrg_rxbuf) :
-						sizeof(struct virtio_net_hdr);
+		ndev->info.vnet_hdr_len = virtio_net_hdr_len(ndev);
 		uip_init(&ndev->info);
 	}
 }
-- 
2.36.1

