Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15432540447
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345375AbiFGRDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345354AbiFGRDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33C8AFF59A
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1603114BF;
        Tue,  7 Jun 2022 10:03:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A69703F66F;
        Tue,  7 Jun 2022 10:03:29 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 11/24] virtio/net: Offload vnet header endianness conversion to tap
Date:   Tue,  7 Jun 2022 18:02:26 +0100
Message-Id: <20220607170239.120084-12-jean-philippe.brucker@arm.com>
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

The conversion of vnet header fields will be more difficult when
supporting the virtio ANY_LAYOUT feature. Since the uip backend doesn't
use the vnet header, and since tap can handle that conversion itself,
offload it to tap.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/net.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/virtio/net.c b/virtio/net.c
index 844612ac..70002f72 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -81,22 +81,6 @@ static bool has_virtio_feature(struct net_dev *ndev, u32 feature)
 	return ndev->vdev.features & (1 << feature);
 }
 
-static void virtio_net_fix_tx_hdr(struct virtio_net_hdr *hdr, struct net_dev *ndev)
-{
-	hdr->hdr_len		= virtio_guest_to_host_u16(&ndev->vdev, hdr->hdr_len);
-	hdr->gso_size		= virtio_guest_to_host_u16(&ndev->vdev, hdr->gso_size);
-	hdr->csum_start		= virtio_guest_to_host_u16(&ndev->vdev, hdr->csum_start);
-	hdr->csum_offset	= virtio_guest_to_host_u16(&ndev->vdev, hdr->csum_offset);
-}
-
-static void virtio_net_fix_rx_hdr(struct virtio_net_hdr *hdr, struct net_dev *ndev)
-{
-	hdr->hdr_len		= virtio_host_to_guest_u16(&ndev->vdev, hdr->hdr_len);
-	hdr->gso_size		= virtio_host_to_guest_u16(&ndev->vdev, hdr->gso_size);
-	hdr->csum_start		= virtio_host_to_guest_u16(&ndev->vdev, hdr->csum_start);
-	hdr->csum_offset	= virtio_host_to_guest_u16(&ndev->vdev, hdr->csum_offset);
-}
-
 static void *virtio_net_rx_thread(void *p)
 {
 	struct iovec iov[VIRTIO_NET_QUEUE_SIZE];
@@ -149,7 +133,6 @@ static void *virtio_net_rx_thread(void *p)
 				head = virt_queue__get_iov(vq, iov, &out, &in, kvm);
 			}
 
-			virtio_net_fix_rx_hdr(&hdr->hdr, ndev);
 			if (has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF))
 				hdr->num_buffers = virtio_host_to_guest_u16(vq, num_buffers);
 
@@ -189,10 +172,7 @@ static void *virtio_net_tx_thread(void *p)
 		mutex_unlock(&queue->lock);
 
 		while (virt_queue__available(vq)) {
-			struct virtio_net_hdr *hdr;
 			head = virt_queue__get_iov(vq, iov, &out, &in, kvm);
-			hdr = iov[0].iov_base;
-			virtio_net_fix_tx_hdr(hdr, ndev);
 			len = ndev->ops->tx(iov, out, ndev);
 			if (len < 0) {
 				pr_warning("%s: tx on vq %u failed (%d)\n",
@@ -565,6 +545,25 @@ static void virtio_net_update_endian(struct net_dev *ndev)
 						VIRTIO_NET_S_LINK_UP);
 	conf->max_virtqueue_pairs = virtio_host_to_guest_u16(&ndev->vdev,
 							     ndev->queue_pairs);
+
+	/* Let TAP know about vnet header endianness */
+	if (ndev->mode == NET_MODE_TAP &&
+	    ndev->vdev.endian != VIRTIO_ENDIAN_HOST) {
+		int enable_val = 1, disable_val = 0;
+		int enable_req, disable_req;
+
+		if (ndev->vdev.endian == VIRTIO_ENDIAN_LE) {
+			enable_req = TUNSETVNETLE;
+			disable_req = TUNSETVNETBE;
+		} else {
+			enable_req = TUNSETVNETBE;
+			disable_req = TUNSETVNETLE;
+		}
+
+		ioctl(ndev->tap_fd, disable_req, &disable_val);
+		if (ioctl(ndev->tap_fd, enable_req, &enable_val) < 0)
+			pr_err("Config tap device TUNSETVNETLE/BE error");
+	}
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
-- 
2.36.1

