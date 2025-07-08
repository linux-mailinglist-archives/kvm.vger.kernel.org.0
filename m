Return-Path: <kvm+bounces-51729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A79AFC323
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 603D13B60CA
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 06:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5378422B8A5;
	Tue,  8 Jul 2025 06:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCjxkihk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA65622A4EA
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751957324; cv=none; b=j4Y/aC4qAtFErrcL17W5HyrwQzQi4Lep9Dplp5lZawl8LXifVMo2Qazca28LqzfQb/0JEV4xzkyVNtz6i1QlrfnImqFzgQ2fhEKXE8Hs38N+JVYypXV3c1/+Fp7iBvrgjtdU6vsEpIHrPmg5nxl+e5WawRhTbpEOIMl1bhh2ESM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751957324; c=relaxed/simple;
	bh=MY8vMj70pEwa4XHTdydkUlnbuShmK/xDyh6QSW3qoUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjqocOLBnh+ecOwRKew3ZR+f3ssKBYpAQNKmz0ImSrEouSA84qzfjtEiZhTOeRk6BqhEi6lpgX2ceoi0hX3BEXjbXQCwKuyHyyxfkIi6XdNZAOEOllmZqeCzWiO0Bbv14PhH1DcQYo6h16lW8ewWkMkr+kyJaSUQ4XFtzbxcDZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OCjxkihk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751957321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=teTwZIaIdHF2W5KWCPjBDcr/Vz6B+2AKBnkMWIsMlmo=;
	b=OCjxkihku7K6wxLUp+Oz/AW2V8jRvU0CexW7Ldc2goPaFhD/BQYzFUx+p5Dhe3zTc9S3T+
	HD4IoLXzCcR86GNhYGjPycEv2J/JG/6tXIz9wJQEbVigZvGz5lJUEkxZTL+LMXYCtqBI4H
	ne09oA624cLTnX0OtVL5R6jLxNLhCnI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-462-3UxcNv81M0GM_cSvbteMdw-1; Tue,
 08 Jul 2025 02:48:39 -0400
X-MC-Unique: 3UxcNv81M0GM_cSvbteMdw-1
X-Mimecast-MFC-AGG-ID: 3UxcNv81M0GM_cSvbteMdw_1751957318
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 303C3180029F;
	Tue,  8 Jul 2025 06:48:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.173])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E0B419560B2;
	Tue,  8 Jul 2025 06:48:33 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jonah.palmer@oracle.com
Subject: [PATCH net-next 2/2] vhost_net: basic in_order support
Date: Tue,  8 Jul 2025 14:48:19 +0800
Message-ID: <20250708064819.35282-3-jasowang@redhat.com>
In-Reply-To: <20250708064819.35282-1-jasowang@redhat.com>
References: <20250708064819.35282-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This patch introduces basic in-order support for vhost-net. By
recording the number of batched buffers in an array when calling
`vhost_add_used_and_signal_n()`, we can reduce the number of userspace
accesses. Note that the vhost-net batching logic is kept as we still
count the number of buffers there.

Testing Results:

With testpmd:

- TX: txonly mode + vhost_net with XDP_DROP on TAP shows a 17.5%
  improvement, from 4.75 Mpps to 5.35 Mpps.
- RX: No obvious improvements were observed.

With virtio-ring in-order experimental code in the guest:

- TX: pktgen in the guest + XDP_DROP on  TAP shows a 19% improvement,
  from 5.2 Mpps to 6.2 Mpps.
- RX: pktgen on TAP with vhost_net + XDP_DROP in the guest achieves a
  6.1% improvement, from 3.47 Mpps to 3.61 Mpps.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 86 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 4f9c67f17b49..8ac994b3228a 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -74,7 +74,8 @@ enum {
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
 			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			 (1ULL << VIRTIO_F_RING_RESET)
+			 (1ULL << VIRTIO_F_RING_RESET) |
+			 (1ULL << VIRTIO_F_IN_ORDER)
 };
 
 enum {
@@ -450,7 +451,8 @@ static int vhost_net_enable_vq(struct vhost_net *n,
 	return vhost_poll_start(poll, sock->file);
 }
 
-static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
+static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq,
+				  unsigned int count)
 {
 	struct vhost_virtqueue *vq = &nvq->vq;
 	struct vhost_dev *dev = vq->dev;
@@ -458,8 +460,8 @@ static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
 	if (!nvq->done_idx)
 		return;
 
-	vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
-				    nvq->done_idx);
+	vhost_add_used_and_signal_n(dev, vq, vq->heads,
+				    vq->nheads, count);
 	nvq->done_idx = 0;
 }
 
@@ -468,6 +470,8 @@ static void vhost_tx_batch(struct vhost_net *net,
 			   struct socket *sock,
 			   struct msghdr *msghdr)
 {
+	struct vhost_virtqueue *vq = &nvq->vq;
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
 	struct tun_msg_ctl ctl = {
 		.type = TUN_MSG_PTR,
 		.num = nvq->batched_xdp,
@@ -475,6 +479,11 @@ static void vhost_tx_batch(struct vhost_net *net,
 	};
 	int i, err;
 
+	if (in_order) {
+		vq->heads[0].len = 0;
+		vq->nheads[0] = nvq->done_idx;
+	}
+
 	if (nvq->batched_xdp == 0)
 		goto signal_used;
 
@@ -496,7 +505,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 	}
 
 signal_used:
-	vhost_net_signal_used(nvq);
+	vhost_net_signal_used(nvq, in_order ? 1 : nvq->done_idx);
 	nvq->batched_xdp = 0;
 }
 
@@ -758,6 +767,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	int sent_pkts = 0;
 	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
 	bool busyloop_intr;
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
 
 	do {
 		busyloop_intr = false;
@@ -794,11 +804,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				break;
 			}
 
-			/* We can't build XDP buff, go for single
-			 * packet path but let's flush batched
-			 * packets.
-			 */
-			vhost_tx_batch(net, nvq, sock, &msg);
+			if (nvq->batched_xdp) {
+				/* We can't build XDP buff, go for single
+				 * packet path but let's flush batched
+				 * packets.
+				 */
+				vhost_tx_batch(net, nvq, sock, &msg);
+			}
 			msg.msg_control = NULL;
 		} else {
 			if (tx_can_batch(vq, total_len))
@@ -819,8 +831,12 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			pr_debug("Truncated TX packet: len %d != %zd\n",
 				 err, len);
 done:
-		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
-		vq->heads[nvq->done_idx].len = 0;
+		if (in_order) {
+			vq->heads[0].id = cpu_to_vhost32(vq, head);
+		} else {
+			vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
+			vq->heads[nvq->done_idx].len = 0;
+		}
 		++nvq->done_idx;
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
@@ -999,7 +1015,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 }
 
 static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
-				      bool *busyloop_intr)
+				      bool *busyloop_intr, unsigned int count)
 {
 	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_net_virtqueue *tnvq = &net->vqs[VHOST_NET_VQ_TX];
@@ -1009,7 +1025,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
 
 	if (!len && rvq->busyloop_timeout) {
 		/* Flush batched heads first */
-		vhost_net_signal_used(rnvq);
+		vhost_net_signal_used(rnvq, count);
 		/* Both tx vq and rx socket were polled here */
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
 
@@ -1021,7 +1037,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
 
 /* This is a multi-buffer version of vhost_get_desc, that works if
  *	vq has read descriptors only.
- * @vq		- the relevant virtqueue
+ * @nvq		- the relevant vhost_net virtqueue
  * @datalen	- data length we'll be reading
  * @iovcount	- returned count of io vectors we fill
  * @log		- vhost log
@@ -1029,14 +1045,17 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
  * @quota       - headcount quota, 1 for big buffer
  *	returns number of buffer heads allocated, negative on error
  */
-static int get_rx_bufs(struct vhost_virtqueue *vq,
+static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		       struct vring_used_elem *heads,
+		       u16 *nheads,
 		       int datalen,
 		       unsigned *iovcount,
 		       struct vhost_log *log,
 		       unsigned *log_num,
 		       unsigned int quota)
 {
+	struct vhost_virtqueue *vq = &nvq->vq;
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
 	unsigned int out, in;
 	int seg = 0;
 	int headcount = 0;
@@ -1073,14 +1092,16 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			nlogs += *log_num;
 			log += *log_num;
 		}
-		heads[headcount].id = cpu_to_vhost32(vq, d);
 		len = iov_length(vq->iov + seg, in);
-		heads[headcount].len = cpu_to_vhost32(vq, len);
-		datalen -= len;
+		if (!in_order) {
+			heads[headcount].id = cpu_to_vhost32(vq, d);
+			heads[headcount].len = cpu_to_vhost32(vq, len);
+		}
 		++headcount;
+		datalen -= len;
 		seg += in;
 	}
-	heads[headcount - 1].len = cpu_to_vhost32(vq, len + datalen);
+
 	*iovcount = seg;
 	if (unlikely(log))
 		*log_num = nlogs;
@@ -1090,6 +1111,15 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 		r = UIO_MAXIOV + 1;
 		goto err;
 	}
+
+	if (!in_order)
+		heads[headcount - 1].len = cpu_to_vhost32(vq, len + datalen);
+	else {
+		heads[0].len = cpu_to_vhost32(vq, len + datalen);
+		heads[0].id = cpu_to_vhost32(vq, d);
+		nheads[0] = headcount;
+	}
+
 	return headcount;
 err:
 	vhost_discard_vq_desc(vq, headcount);
@@ -1102,6 +1132,8 @@ static void handle_rx(struct vhost_net *net)
 {
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_virtqueue *vq = &nvq->vq;
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
+	unsigned int count = 0;
 	unsigned in, log;
 	struct vhost_log *vq_log;
 	struct msghdr msg = {
@@ -1149,12 +1181,13 @@ static void handle_rx(struct vhost_net *net)
 
 	do {
 		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
-						      &busyloop_intr);
+						      &busyloop_intr, count);
 		if (!sock_len)
 			break;
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
-		headcount = get_rx_bufs(vq, vq->heads + nvq->done_idx,
+		headcount = get_rx_bufs(nvq, vq->heads + count,
+					vq->nheads + count,
 					vhost_len, &in, vq_log, &log,
 					likely(mergeable) ? UIO_MAXIOV : 1);
 		/* On error, stop handling until the next kick. */
@@ -1230,8 +1263,11 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		nvq->done_idx += headcount;
-		if (nvq->done_idx > VHOST_NET_BATCH)
-			vhost_net_signal_used(nvq);
+		count += in_order ? 1 : headcount;
+		if (nvq->done_idx > VHOST_NET_BATCH) {
+			vhost_net_signal_used(nvq, count);
+			count = 0;
+		}
 		if (unlikely(vq_log))
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
@@ -1243,7 +1279,7 @@ static void handle_rx(struct vhost_net *net)
 	else if (!sock_len)
 		vhost_net_enable_vq(net, vq);
 out:
-	vhost_net_signal_used(nvq);
+	vhost_net_signal_used(nvq, count);
 	mutex_unlock(&vq->mutex);
 }
 
-- 
2.31.1


