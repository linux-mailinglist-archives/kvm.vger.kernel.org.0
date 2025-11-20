Return-Path: <kvm+bounces-63876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9CBC75051
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id C219B30F9E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C3B3A1CE8;
	Thu, 20 Nov 2025 15:30:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0558D36C0A1;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652611; cv=none; b=EZJnZ86az7CsLpwp+Bcy0Ls8kimU/ScSCmeOTLkWiB64VDCseyWZnnlE1BdjXlixt1aJdVIToFjEDAvxYJEsV4O318SJiop/tnoq1XyFVtSsRWMBxFbMxnjiMvwMVDqW9vQZamMbNntO53CGTb5B/onxSRzngpP55cx+B3QnQ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652611; c=relaxed/simple;
	bh=xqUVt6XIhPNbPKJPoJJFvfbDFblgtbEC1To91Na6jsU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9HWSMlTpoCTzU+nP2axLjRvnAqFnm3krtT+6b/Mryco+rYfznxAn6V/bf+tD3EVhKT7PtyrCBdSHpBAXM3DNNPswyLUlBIvfRCfDaAYIlzITHfzMutHMqCHoMt35dRCpAaY0+6GPxTBW4cmAa46h50uBvy3ZyMM36yLhmBMpn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8M005406
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 16:29:58 +0100 (CET)
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v6 7/8] tun/tap/vhost: use {tun|tap}_ring_{consume|produce} to avoid tail drops
Date: Thu, 20 Nov 2025 16:29:13 +0100
Message-ID: <20251120152914.1127975-9-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch to {tun|tap}_ring_{consume|produce} in both tun/tap as well as
vhost_net to avoid ptr_ring tail drops.

For tun, disable dev->lltx to ensure that tun_net_xmit is not called even
though the netdev queue is stopped (it can happen due to unconsume or
queue resize). Consequently, the update of trans_start in tun_net_xmit is
also removed.

Instead of the rx_ring, the virtqueue now saves the interface type
IF_TAP, IF_TUN, (or IF_NONE) to call tun/tap wrappers.

+--------------------------------+-----------+----------+
| pktgen benchmarks to Debian VM | Stock     | Patched  |
| i5 6300HQ, 20M packets         |           |          |
+-----------------+--------------+-----------+----------+
| TAP             | Transmitted  | 195 Kpps  | 183 Kpps |
|                 +--------------+-----------+----------+
|                 | Lost         | 1615 Kpps | 0 pps    |
+-----------------+--------------+-----------+----------+
| TAP+vhost_net   | Transmitted  | 589 Kpps  | 588 Kpps |
|                 +--------------+-----------+----------+
|                 | Lost         | 1164 Kpps | 0 pps    |
+-----------------+--------------+-----------+----------+

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c   |  4 +-
 drivers/net/tun.c   | 20 ++++------
 drivers/vhost/net.c | 92 ++++++++++++++++++++++++++++++---------------
 3 files changed, 71 insertions(+), 45 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 56b8fe376e4a..2847db4e3cc7 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -805,7 +805,7 @@ static void *__tap_ring_consume(struct tap_queue *q)
 	return ptr;
 }
 
-static __always_unused void *tap_ring_consume(struct tap_queue *q)
+static void *tap_ring_consume(struct tap_queue *q)
 {
 	void *ptr;
 
@@ -868,7 +868,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
 					TASK_INTERRUPTIBLE);
 
 		/* Read frames from the queue */
-		skb = ptr_ring_consume(&q->ring);
+		skb = tap_ring_consume(q);
 		if (skb)
 			break;
 		if (noblock) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dc2d267d30d7..9da6e794a80f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -931,7 +931,6 @@ static int tun_net_init(struct net_device *dev)
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
 			       NETIF_F_HW_VLAN_STAG_TX);
-	dev->lltx = true;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
 		      (ifr->ifr_flags & TUN_FEATURES);
@@ -1002,9 +1001,9 @@ static unsigned int run_ebpf_filter(struct tun_struct *tun,
 /* Produce a packet into the transmit ring. If the ring becomes full, the
  * netdev queue is stopped until the consumer wakes it again.
  */
-static __always_unused int tun_ring_produce(struct ptr_ring *ring,
-					    struct netdev_queue *queue,
-					    struct sk_buff *skb)
+static int tun_ring_produce(struct ptr_ring *ring,
+			    struct netdev_queue *queue,
+			    struct sk_buff *skb)
 {
 	int ret;
 
@@ -1089,7 +1088,7 @@ static void *__tun_ring_consume(struct tun_file *tfile)
 	return ptr;
 }
 
-static void __always_unused *tun_ring_consume(struct tun_file *tfile)
+static void *tun_ring_consume(struct tun_file *tfile)
 {
 	void *ptr;
 
@@ -1161,15 +1160,12 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+	queue = netdev_get_tx_queue(dev, txq);
+	if (unlikely(tun_ring_produce(&tfile->tx_ring, queue, skb))) {
 		drop_reason = SKB_DROP_REASON_FULL_RING;
 		goto drop;
 	}
 
-	/* dev->lltx requires to do our own update of trans_start */
-	queue = netdev_get_tx_queue(dev, txq);
-	txq_trans_cond_update(queue);
-
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
@@ -2220,7 +2216,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	void *ptr = NULL;
 	int error = 0;
 
-	ptr = ptr_ring_consume(&tfile->tx_ring);
+	ptr = tun_ring_consume(tfile);
 	if (ptr)
 		goto out;
 	if (noblock) {
@@ -2232,7 +2228,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ptr = ptr_ring_consume(&tfile->tx_ring);
+		ptr = tun_ring_consume(tfile);
 		if (ptr)
 			break;
 		if (signal_pending(current)) {
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 35ded4330431..022efca1d4af 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -90,6 +90,12 @@ enum {
 	VHOST_NET_VQ_MAX = 2,
 };
 
+enum if_type {
+	IF_NONE = 0,
+	IF_TUN = 1,
+	IF_TAP = 2,
+};
+
 struct vhost_net_ubuf_ref {
 	/* refcount follows semantics similar to kref:
 	 *  0: object is released
@@ -131,6 +137,8 @@ struct vhost_net_virtqueue {
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
 	struct xdp_buff *xdp;
+	/* Interface type */
+	enum if_type type;
 };
 
 struct vhost_net {
@@ -176,24 +184,50 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
 	return ret;
 }
 
-static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
+static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq,
+				 struct sock *sk)
 {
+	struct file *file = sk->sk_socket->file;
 	struct vhost_net_buf *rxq = &nvq->rxq;
 
 	rxq->head = 0;
-	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
-					      VHOST_NET_BATCH);
+	switch (nvq->type) {
+	case IF_TUN:
+		rxq->tail = tun_ring_consume_batched(file, rxq->queue,
+						     VHOST_NET_BATCH);
+		break;
+	case IF_TAP:
+		rxq->tail = tap_ring_consume_batched(file, rxq->queue,
+						     VHOST_NET_BATCH);
+		break;
+	case IF_NONE:
+		return 0;
+	}
 	return rxq->tail;
 }
 
-static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq)
+static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq,
+				    struct socket *sk)
 {
 	struct vhost_net_buf *rxq = &nvq->rxq;
-
-	if (nvq->rx_ring && !vhost_net_buf_is_empty(rxq)) {
-		ptr_ring_unconsume(nvq->rx_ring, rxq->queue + rxq->head,
-				   vhost_net_buf_get_size(rxq),
-				   tun_ptr_free);
+	struct file *file;
+
+	if (sk && !vhost_net_buf_is_empty(rxq)) {
+		file = sk->file;
+		switch (nvq->type) {
+		case IF_TUN:
+			tun_ring_unconsume(file, rxq->queue + rxq->head,
+					   vhost_net_buf_get_size(rxq),
+					   tun_ptr_free);
+			break;
+		case IF_TAP:
+			tap_ring_unconsume(file, rxq->queue + rxq->head,
+					   vhost_net_buf_get_size(rxq),
+					   tun_ptr_free);
+			break;
+		case IF_NONE:
+			return;
+		}
 		rxq->head = rxq->tail = 0;
 	}
 }
@@ -209,14 +243,15 @@ static int vhost_net_buf_peek_len(void *ptr)
 	return __skb_array_len_with_tag(ptr);
 }
 
-static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq)
+static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq,
+			      struct sock *sk)
 {
 	struct vhost_net_buf *rxq = &nvq->rxq;
 
 	if (!vhost_net_buf_is_empty(rxq))
 		goto out;
 
-	if (!vhost_net_buf_produce(nvq))
+	if (!vhost_net_buf_produce(nvq, sk))
 		return 0;
 
 out:
@@ -991,8 +1026,8 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 	int len = 0;
 	unsigned long flags;
 
-	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+	if (rvq->type)
+		return vhost_net_buf_peek(rvq, sk);
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
@@ -1201,7 +1236,7 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring)
+		if (nvq->type)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
 		if (unlikely(headcount > UIO_MAXIOV)) {
@@ -1357,7 +1392,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
-		n->vqs[i].rx_ring = NULL;
+		n->vqs[i].rx_ring = IF_NONE;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
@@ -1387,8 +1422,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	sock = vhost_vq_get_backend(vq);
 	vhost_net_disable_vq(n, vq);
 	vhost_vq_set_backend(vq, NULL);
-	vhost_net_buf_unproduce(nvq);
-	nvq->rx_ring = NULL;
+	vhost_net_buf_unproduce(nvq, sock);
+	nvq->type = IF_NONE;
 	mutex_unlock(&vq->mutex);
 	return sock;
 }
@@ -1468,18 +1503,13 @@ static struct socket *get_raw_socket(int fd)
 	return ERR_PTR(r);
 }
 
-static struct ptr_ring *get_tap_ptr_ring(struct file *file)
+static enum if_type get_if_type(struct file *file)
 {
-	struct ptr_ring *ring;
-	ring = tun_get_tx_ring(file);
-	if (!IS_ERR(ring))
-		goto out;
-	ring = tap_get_ptr_ring(file);
-	if (!IS_ERR(ring))
-		goto out;
-	ring = NULL;
-out:
-	return ring;
+	if (tap_is_tap_file(file))
+		return IF_TAP;
+	if (tun_is_tun_file(file))
+		return IF_TUN;
+	return IF_NONE;
 }
 
 static struct socket *get_tap_socket(int fd)
@@ -1561,7 +1591,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 		vhost_net_disable_vq(n, vq);
 		vhost_vq_set_backend(vq, sock);
-		vhost_net_buf_unproduce(nvq);
+		vhost_net_buf_unproduce(nvq, sock);
 		r = vhost_vq_init_access(vq);
 		if (r)
 			goto err_used;
@@ -1570,9 +1600,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 			goto err_used;
 		if (index == VHOST_NET_VQ_RX) {
 			if (sock)
-				nvq->rx_ring = get_tap_ptr_ring(sock->file);
+				nvq->type = get_if_type(sock->file);
 			else
-				nvq->rx_ring = NULL;
+				nvq->type = IF_NONE;
 		}
 
 		oldubufs = nvq->ubufs;
-- 
2.43.0


