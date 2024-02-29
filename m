Return-Path: <kvm+bounces-10453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6CB86C25F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:26:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29A2EB27500
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4125810F;
	Thu, 29 Feb 2024 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LukkCFYD"
X-Original-To: kvm@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127C745BFB;
	Thu, 29 Feb 2024 07:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191281; cv=none; b=ZU5oST5PvwVLuxTWl0S2P2s5pZg9zYG5USqcyM/mK0jgAvIO2JpuNTRfIeAn5RMMD59KGO9q0cO7fEbThY8pQFltXeaKcXOLaUQn9Pvlsmk/3sfgcBP+NRtJxDksk3hByaIEMcpn0YhTssv2PRXMYYrSBw4Pr0jmA10yLsAsR1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191281; c=relaxed/simple;
	bh=0Gk9UztMGIIcRnEHpqYyAjKvdnBaolmfK4xirNAtcuc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m683jRcQdQO8oRbFL3UNySpocgBeB+F1F3+JDr/nI7wazFEx29Aa560DyA1tv/F32yAvA9HId0pcpnNiPUjhBhbRUaebLbbze4122r74dcepguCbFGILOOofA4YYnCSQnqCzJN4sQjPrZdijVUA9I9LPHs6GRHeukLYnhBxq75c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LukkCFYD; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709191276; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=0bf+ondcixqn/GNrn6hzfTiAxwONS6eM86OVYrAkzbE=;
	b=LukkCFYDzHDNjuaXAVfA3WjA+GjFTfyo49cpJO8T8Q/yQt0jnx8FzFjimoDfGV4eGswSpVsZK6er0wBW4xtbtbnUPK4bvMAJn0/qChUi6iE0IJJWHrkZ1NSeqHuCVkIxpTdNA5tEpl3SgyENFcu5x7/oKmUnFjilRrVPjll8tRE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1SCLiX_1709191273;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1SCLiX_1709191273)
          by smtp.aliyun-inc.com;
          Thu, 29 Feb 2024 15:21:14 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v3 18/19] virtio_net: rename free_old_xmit_skbs to free_old_xmit
Date: Thu, 29 Feb 2024 15:20:43 +0800
Message-Id: <20240229072044.77388-19-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: e3a3e51d6b70
Content-Transfer-Encoding: 8bit

Since free_old_xmit_skbs not only deals with skb, but also xdp frame and
subsequent added xsk, so change the name of this function to
free_old_xmit.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 62f65e2cacd5..7715bb7032ec 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -787,7 +787,7 @@ static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
 	virtnet_rq_free_buf(vi, rq, buf);
 }
 
-static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
+static void free_old_xmit(struct send_queue *sq, bool in_napi)
 {
 	struct virtnet_sq_free_stats stats = {0};
 
@@ -841,7 +841,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 				virtqueue_napi_schedule(&sq->napi, sq->vq);
 		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
-			free_old_xmit_skbs(sq, false);
+			free_old_xmit(sq, false);
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
 				netif_start_subqueue(dev, qnum);
 				virtqueue_disable_cb(sq->vq);
@@ -2137,7 +2137,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 
 		do {
 			virtqueue_disable_cb(sq->vq);
-			free_old_xmit_skbs(sq, true);
+			free_old_xmit(sq, true);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
@@ -2285,7 +2285,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit_skbs(sq, true);
+	free_old_xmit(sq, true);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
@@ -2375,7 +2375,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (use_napi)
 			virtqueue_disable_cb(sq->vq);
 
-		free_old_xmit_skbs(sq, false);
+		free_old_xmit(sq, false);
 
 	} while (use_napi && kick &&
 	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
-- 
2.32.0.3.g01195cf9f


