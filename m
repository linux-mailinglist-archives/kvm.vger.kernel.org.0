Return-Path: <kvm+bounces-67280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 603D3D0020B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 036F3306B692
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4594133DEDD;
	Wed,  7 Jan 2026 21:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="gCUB2Ysd"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CA133AD94;
	Wed,  7 Jan 2026 21:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819979; cv=none; b=lSgGSxudGqz3y4u0LBp7Kfp7ZZl+vI7VmoXnWuJ71QWN5SM1gNhoSOLk/OasiJlgXr6EE13Pxn0z88J8rltsdbeZUNZWNlLyZBMMyr+E1N4vTuVTIVsLC38MAX2z8zJnBnl/TSbEVypNN7n1Otv2Ne/6Z1i0iXvDktOX9RyBTBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819979; c=relaxed/simple;
	bh=/fsS1OkVQACr2Zwm9U45KQEbYSEtJ4FVNb6QeUMmHXo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doIKtFEjKTrvnO48PP9JYsMUQD3yC0glF40ryCwoX9qF6D64n5jouY798bT4/NK8rgeQWXKvPvOBTJn1GKleu8KcrzxbaHxus+0fz6Rc6yqebczG6E2d0YKUUOZaj1mAQ0skoRXrNECH+D7v1Qkc/zMshs01G+ryvm2yBAUZFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=gCUB2Ysd; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9T026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819963;
	bh=/fsS1OkVQACr2Zwm9U45KQEbYSEtJ4FVNb6QeUMmHXo=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=gCUB2Ysdt6Nb/jBGRKuCjGiyWwz/Yg0gfAbvwRK6KlTI0kp7N6PKWrb4KdBGQ4Fvn
	 tXku3hGWwn2rcUQrv/Bg5uMYh4sYYl5nauAAM9lpgZ7ilhu1qoltXB9aumOeHzPROj
	 sg8NNPtbh1DXJ9n3v1kox4rZvf0jtW/xf4Hzb6yQ=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 7/9] vhost-net: vhost-net: replace rx_ring with tun/tap ring wrappers
Date: Wed,  7 Jan 2026 22:04:46 +0100
Message-ID: <20260107210448.37851-8-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the direct use of ptr_ring in the vhost-net virtqueue with
tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_NONE)
and dispatches to the corresponding tun/tap helpers for ring
produce, consume, and unconsume operations.

Routing ring operations through the tun/tap helpers enables netdev
queue wakeups, which are required for upcoming netdev queue flow
control support shared by tun/tap and vhost-net.

No functional change is intended beyond switching to the wrapper
helpers.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7f886d3dba7d..215556f7cd40 100644
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
@@ -127,10 +133,11 @@ struct vhost_net_virtqueue {
 	/* Reference counting for outstanding ubufs.
 	 * Protected by vq mutex. Writers must also take device mutex. */
 	struct vhost_net_ubuf_ref *ubufs;
-	struct ptr_ring *rx_ring;
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
 	struct xdp_buff *xdp;
+	/* Interface type */
+	enum if_type type;
 };
 
 struct vhost_net {
@@ -176,24 +183,50 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
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
@@ -209,14 +242,15 @@ static int vhost_net_buf_peek_len(void *ptr)
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
@@ -996,8 +1030,8 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 	int len = 0;
 	unsigned long flags;
 
-	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+	if (rvq->type)
+		return vhost_net_buf_peek(rvq, sk);
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
@@ -1212,7 +1246,7 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring)
+		if (nvq->type)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
 		if (unlikely(headcount > UIO_MAXIOV)) {
@@ -1368,7 +1402,6 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
-		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
@@ -1398,8 +1431,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
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
@@ -1479,18 +1512,13 @@ static struct socket *get_raw_socket(int fd)
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
@@ -1572,7 +1600,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 		vhost_net_disable_vq(n, vq);
 		vhost_vq_set_backend(vq, sock);
-		vhost_net_buf_unproduce(nvq);
+		vhost_net_buf_unproduce(nvq, sock);
 		r = vhost_vq_init_access(vq);
 		if (r)
 			goto err_used;
@@ -1581,9 +1609,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
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


