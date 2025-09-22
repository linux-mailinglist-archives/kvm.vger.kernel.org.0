Return-Path: <kvm+bounces-58422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2874B93773
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E35862E1067
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A1031E885;
	Mon, 22 Sep 2025 22:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="E/J15dFW"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81C028725A;
	Mon, 22 Sep 2025 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579433; cv=none; b=j1kqb5+COdeUliU6+DtZ5FG0uB/+akI1goC1mahu504zR+c1Vvavxoia/7JFRszeDACK8zL0nk9CVmmHPkSGJiJ9M5K7unQtaMmbrX7va9XzIdVrlaSAg3C4z0smgV4qzSVmgxaxCcrYclj1e6JFhkvscWyj5ojo7TppU4FpjAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579433; c=relaxed/simple;
	bh=aRqxQBtjU6+rvyZVBu/BLGv3XNOiqN63EK6zK9acjS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBaQix8ihIQArSdvYqui2BJx16TQ/WZZ2xsH0UsW0td4Ks9wVLfGsnDpzr7YUBM1AyoHz5b1mN/hlUBbSb0dpavRFYqZBAJjY9dbSLcezmo5GqOhPoK7AaiX925+fChUCWLbKZhrYkTCSvhk2O2Z00Pzd10hZZ+es+0gtbOBiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=E/J15dFW; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4en003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579428;
	bh=aRqxQBtjU6+rvyZVBu/BLGv3XNOiqN63EK6zK9acjS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/J15dFWROga6n6cRlsCwaio02tipl9T9AO72hyiym+6rD/r5r/8GSfOgNGuW6ELT
	 AgKtZOskiEA60dIKWuJbLWQXKLmxDoNWzYZOd/g7pOb4z5qAMm6KzJez933H95/Omu
	 lB6pA6lnN4xHhrHLuz5BiOhVFHhflQYpehDH8c/A=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 8/8] vhost_net: Replace rx_ring with calls of TUN/TAP wrappers
Date: Tue, 23 Sep 2025 00:15:53 +0200
Message-ID: <20250922221553.47802-9-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of the rx_ring, the virtqueue saves the interface type TUN, TAP
(or IF_NONE) to call TUN/TAP wrappers.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/vhost/net.c | 90 +++++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c6508fe0d5c8..6be17b53cc6c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -127,10 +127,10 @@ struct vhost_net_virtqueue {
 	/* Reference counting for outstanding ubufs.
 	 * Protected by vq mutex. Writers must also take device mutex. */
 	struct vhost_net_ubuf_ref *ubufs;
-	struct ptr_ring *rx_ring;
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
 	struct xdp_buff *xdp;
+	enum if_type {IF_NONE = 0, TUN, TAP} type;
 };
 
 struct vhost_net {
@@ -176,24 +176,54 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
 	return ret;
 }
 
-static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
+static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq,
+		struct sock *sk)
 {
+	struct file *file = sk->sk_socket->file;
 	struct vhost_net_buf *rxq = &nvq->rxq;
 
 	rxq->head = 0;
-	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
-					      VHOST_NET_BATCH);
+
+	switch (nvq->type) {
+	case TUN:
+		rxq->tail = tun_ring_consume_batched(file,
+				rxq->queue, VHOST_NET_BATCH);
+		break;
+	case TAP:
+		rxq->tail = tap_ring_consume_batched(file,
+				rxq->queue, VHOST_NET_BATCH);
+		break;
+	case IF_NONE:
+		WARN_ON_ONCE();
+	}
+
 	return rxq->tail;
 }
 
-static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq)
+static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq,
+				struct socket *sk)
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
+		case TUN:
+			tun_ring_unconsume(file,
+					   rxq->queue + rxq->head,
+					   vhost_net_buf_get_size(rxq),
+					   tun_ptr_free);
+			break;
+		case TAP:
+			tap_ring_unconsume(file,
+					   rxq->queue + rxq->head,
+					   vhost_net_buf_get_size(rxq),
+					   tun_ptr_free);
+			break;
+		case IF_NONE:
+			return;
+		}
 		rxq->head = rxq->tail = 0;
 	}
 }
@@ -209,14 +239,15 @@ static int vhost_net_buf_peek_len(void *ptr)
 	return __skb_array_len_with_tag(ptr);
 }
 
-static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq)
+static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq,
+							  struct sock *sk)
 {
 	struct vhost_net_buf *rxq = &nvq->rxq;
 
 	if (!vhost_net_buf_is_empty(rxq))
 		goto out;
 
-	if (!vhost_net_buf_produce(nvq))
+	if (!vhost_net_buf_produce(nvq, sk))
 		return 0;
 
 out:
@@ -998,8 +1029,8 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 	int len = 0;
 	unsigned long flags;
 
-	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+	if (rvq->type)
+		return vhost_net_buf_peek(rvq, sk);
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
@@ -1207,7 +1238,7 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring)
+		if (nvq->type)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
 		if (unlikely(headcount > UIO_MAXIOV)) {
@@ -1363,7 +1394,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
-		n->vqs[i].rx_ring = NULL;
+		n->vqs[i].type = IF_NONE;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
@@ -1393,8 +1424,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
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
@@ -1474,18 +1505,13 @@ static struct socket *get_raw_socket(int fd)
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
+	if (is_tap_file(file))
+		return TAP;
+	if (is_tun_file(file))
+		return TUN;
+	return IF_NONE;
 }
 
 static struct socket *get_tap_socket(int fd)
@@ -1567,7 +1593,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 
 		vhost_net_disable_vq(n, vq);
 		vhost_vq_set_backend(vq, sock);
-		vhost_net_buf_unproduce(nvq);
+		vhost_net_buf_unproduce(nvq, sock);
 		r = vhost_vq_init_access(vq);
 		if (r)
 			goto err_used;
@@ -1576,9 +1602,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
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


