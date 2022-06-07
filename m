Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796C554044A
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345365AbiFGRDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345367AbiFGRDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69734FF589
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 440CF14BF;
        Tue,  7 Jun 2022 10:03:34 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DA3FF3F66F;
        Tue,  7 Jun 2022 10:03:32 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 13/24] virtio/net: Implement VIRTIO_F_ANY_LAYOUT feature
Date:   Tue,  7 Jun 2022 18:02:28 +0100
Message-Id: <20220607170239.120084-14-jean-philippe.brucker@arm.com>
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

Modern virtio demands that devices do not make assumptions about the
buffer layouts. Currently the user network backend assumes that TX
packets are neatly split between virtio-net header and ethernet frame.
Modern virtio-net usually puts everything into one descriptor, but could
also split the buffer arbitrarily. Handle arbitrary buffer layouts and
advertise the VIRTIO_F_ANY_LAYOUT feature.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 net/uip/core.c | 71 ++++++++++++++++++++++++++++++++------------------
 virtio/net.c   | 21 ++++++++-------
 2 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/net/uip/core.c b/net/uip/core.c
index 977b9b0c..e409512e 100644
--- a/net/uip/core.c
+++ b/net/uip/core.c
@@ -9,40 +9,56 @@
 int uip_tx(struct iovec *iov, u16 out, struct uip_info *info)
 {
 	void *vnet;
+	ssize_t len;
 	struct uip_tx_arg arg;
-	int eth_len, vnet_len;
+	size_t eth_len, vnet_len;
 	struct uip_eth *eth;
-	u8 *buf = NULL;
+	void *vnet_buf = NULL;
+	void *eth_buf = NULL;
+	size_t iovcount = out;
+
 	u16 proto;
-	int i;
 
 	/*
 	 * Buffer from guest to device
 	 */
-	vnet_len = iov[0].iov_len;
+	vnet_len = info->vnet_hdr_len;
 	vnet	 = iov[0].iov_base;
 
-	eth_len	 = iov[1].iov_len;
-	eth	 = iov[1].iov_base;
+	len = iov_size(iov, iovcount);
+	if (len <= (ssize_t)vnet_len)
+		return -EINVAL;
+
+	/* Try to avoid memcpy if possible */
+	if (iov[0].iov_len == vnet_len && out == 2) {
+		/* Legacy layout: first descriptor for vnet header */
+		eth	= iov[1].iov_base;
+		eth_len	= iov[1].iov_len;
+
+	} else if (out == 1) {
+		/* Single descriptor */
+		eth	= (void *)vnet + vnet_len;
+		eth_len	= iov[0].iov_len - vnet_len;
+
+	} else {
+		/* Any layout */
+		len = vnet_len;
+		vnet = vnet_buf = malloc(len);
+		if (!vnet)
+			return -ENOMEM;
 
-	/*
-	 * In case, ethernet frame is in more than one iov entry.
-	 * Copy iov buffer into one linear buffer.
-	 */
-	if (out > 2) {
-		eth_len = 0;
-		for (i = 1; i < out; i++)
-			eth_len += iov[i].iov_len;
+		len = memcpy_fromiovec_safe(vnet_buf, &iov, len, &iovcount);
+		if (len)
+			goto out_free_buf;
 
-		buf = malloc(eth_len);
-		if (!buf)
-			return -ENOMEM;
+		len = eth_len = iov_size(iov, iovcount);
+		eth = eth_buf = malloc(len);
+		if (!eth)
+			goto out_free_buf;
 
-		eth = (struct uip_eth *)buf;
-		for (i = 1; i < out; i++) {
-			memcpy(buf, iov[i].iov_base, iov[i].iov_len);
-			buf += iov[i].iov_len;
-		}
+		len = memcpy_fromiovec_safe(eth_buf, &iov, len, &iovcount);
+		if (len)
+			goto out_free_buf;
 	}
 
 	memset(&arg, 0, sizeof(arg));
@@ -65,14 +81,17 @@ int uip_tx(struct iovec *iov, u16 out, struct uip_info *info)
 	case UIP_ETH_P_IP:
 		uip_tx_do_ipv4(&arg);
 		break;
-	default:
-		break;
 	}
 
-	if (out > 2 && buf)
-		free(eth);
+	free(vnet_buf);
+	free(eth_buf);
 
 	return vnet_len + eth_len;
+
+out_free_buf:
+	free(vnet_buf);
+	free(eth_buf);
+	return -EINVAL;
 }
 
 int uip_rx(struct iovec *iov, u16 in, struct uip_info *info)
diff --git a/virtio/net.c b/virtio/net.c
index 985642f6..f8c40d40 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -221,8 +221,9 @@ static void *virtio_net_ctrl_thread(void *p)
 	struct net_dev *ndev = queue->ndev;
 	u16 out, in, head;
 	struct kvm *kvm = ndev->kvm;
-	struct virtio_net_ctrl_hdr *ctrl;
-	virtio_net_ctrl_ack *ack;
+	struct virtio_net_ctrl_hdr ctrl;
+	virtio_net_ctrl_ack ack;
+	size_t len;
 
 	kvm__set_thread_name("virtio-net-ctrl");
 
@@ -234,18 +235,19 @@ static void *virtio_net_ctrl_thread(void *p)
 
 		while (virt_queue__available(vq)) {
 			head = virt_queue__get_iov(vq, iov, &out, &in, kvm);
-			ctrl = iov[0].iov_base;
-			ack = iov[out].iov_base;
+			len = min(iov_size(iov, in), sizeof(ctrl));
+			memcpy_fromiovec((void *)&ctrl, iov, len);
 
-			switch (ctrl->class) {
+			switch (ctrl.class) {
 			case VIRTIO_NET_CTRL_MQ:
-				*ack = virtio_net_handle_mq(kvm, ndev, ctrl);
+				ack = virtio_net_handle_mq(kvm, ndev, &ctrl);
 				break;
 			default:
-				*ack = VIRTIO_NET_ERR;
+				ack = VIRTIO_NET_ERR;
 				break;
 			}
-			virt_queue__set_used_elem(vq, head, iov[out].iov_len);
+			memcpy_toiovec(iov + in, &ack, sizeof(ack));
+			virt_queue__set_used_elem(vq, head, sizeof(ack));
 		}
 
 		if (virtio_queue__should_signal(vq))
@@ -495,7 +497,8 @@ static u32 get_host_features(struct kvm *kvm, void *dev)
 		| 1UL << VIRTIO_RING_F_INDIRECT_DESC
 		| 1UL << VIRTIO_NET_F_CTRL_VQ
 		| 1UL << VIRTIO_NET_F_MRG_RXBUF
-		| 1UL << (ndev->queue_pairs > 1 ? VIRTIO_NET_F_MQ : 0);
+		| 1UL << (ndev->queue_pairs > 1 ? VIRTIO_NET_F_MQ : 0)
+		| 1UL << VIRTIO_F_ANY_LAYOUT;
 
 	/*
 	 * The UFO feature for host and guest only can be enabled when the
-- 
2.36.1

