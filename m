Return-Path: <kvm+bounces-62963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED373C555FB
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 03:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B49883BAEA2
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 01:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE1329D29A;
	Thu, 13 Nov 2025 01:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M78Yb8i7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D6E1A2C11
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 01:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762998877; cv=none; b=nFU/naItHEUw6l6z5qwdzm4PXb4G3sXmyH7M+M166xPyj8IpxUSGPk7X9EwuFa3od236/Uo+6BD3UImQM6Dom4GL5EJXVTSkEiag7kEPKJo9HwUIMGzzYHGNC52zlwQyuX/RMjinlT+lZrkB0uP7foddoytCegXe0PI7EQxZyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762998877; c=relaxed/simple;
	bh=gnWSNzi0OA3gG3/b8AUlMQAVwsXgB/vT1Z9sJGw/krw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IEOrCJ4d6ovowMbt9DFCvfjiLDgzrtKK57sfE1uGJmq2S/KLsEpr/tV56LDbdny7FrNJdjv1au1qHHX3B51fWWdnG7+2k3rU+xoMT3ioNGmaMs9WYKj61eYt2KZ4x18zNe+7wnPOchhmTAjgl3xz+TCIfu7hFcVUcElZr0UvBUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M78Yb8i7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762998874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=A9AVvw2WJi8KKO+NxgyZBOodrIZvASz8rlcC9l8TZKw=;
	b=M78Yb8i7gotmd2NZlkcFGIVFXDOE4djqqbaFKTZkKPHVQ536ANLjv1AECRAkQPs8osM6Dc
	AjYWVWTJdnL5M9Cyaj2nYjbL+n/WkXNfePPC+yCp/o9VPM+3ortM0FT38mKAjpwYxu3Asf
	3/2waxtbtKbAe+f40+znFQC0i6vJFZU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-_adgK1-DMFeFQ7Y_acducQ-1; Wed,
 12 Nov 2025 20:54:30 -0500
X-MC-Unique: _adgK1-DMFeFQ7Y_acducQ-1
X-Mimecast-MFC-AGG-ID: _adgK1-DMFeFQ7Y_acducQ_1762998869
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83C9C1800451;
	Thu, 13 Nov 2025 01:54:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF2E6180094B;
	Thu, 13 Nov 2025 01:54:24 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH net] vhost: rewind next_avail_head while discarding descriptors
Date: Thu, 13 Nov 2025 09:54:20 +0800
Message-ID: <20251113015420.3496-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

When discarding descriptors with IN_ORDER, we should rewind
next_avail_head otherwise it would run out of sync with
last_avail_idx. This would cause driver to report
"id X is not a head".

Fixing this by returning the number of descriptors that is used for
each buffer via vhost_get_vq_desc_n() so caller can use the value
while discarding descriptors.

Fixes: 67a873df0c41 ("vhost: basic in order support")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   | 53 ++++++++++++++++++++++++++-----------------
 drivers/vhost/vhost.c | 43 ++++++++++++++++++++++++-----------
 drivers/vhost/vhost.h |  9 +++++++-
 3 files changed, 70 insertions(+), 35 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 35ded4330431..8f7f50acb6d6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -592,14 +592,15 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 				    struct vhost_net_virtqueue *tnvq,
 				    unsigned int *out_num, unsigned int *in_num,
-				    struct msghdr *msghdr, bool *busyloop_intr)
+				    struct msghdr *msghdr, bool *busyloop_intr,
+				    unsigned int *ndesc)
 {
 	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_virtqueue *rvq = &rnvq->vq;
 	struct vhost_virtqueue *tvq = &tnvq->vq;
 
-	int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				  out_num, in_num, NULL, NULL);
+	int r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+				    out_num, in_num, NULL, NULL, ndesc);
 
 	if (r == tvq->num && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
@@ -610,8 +611,8 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
 
-		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				      out_num, in_num, NULL, NULL);
+		r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+					out_num, in_num, NULL, NULL, ndesc);
 	}
 
 	return r;
@@ -642,12 +643,14 @@ static int get_tx_bufs(struct vhost_net *net,
 		       struct vhost_net_virtqueue *nvq,
 		       struct msghdr *msg,
 		       unsigned int *out, unsigned int *in,
-		       size_t *len, bool *busyloop_intr)
+		       size_t *len, bool *busyloop_intr,
+		       unsigned int *ndesc)
 {
 	struct vhost_virtqueue *vq = &nvq->vq;
 	int ret;
 
-	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop_intr);
+	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg,
+				       busyloop_intr, ndesc);
 
 	if (ret < 0 || ret == vq->num)
 		return ret;
@@ -766,6 +769,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	int sent_pkts = 0;
 	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
 	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
+	unsigned int ndesc = 0;
 
 	do {
 		bool busyloop_intr = false;
@@ -774,7 +778,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			vhost_tx_batch(net, nvq, sock, &msg);
 
 		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
+				   &busyloop_intr, &ndesc);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(head < 0))
 			break;
@@ -806,7 +810,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				goto done;
 			} else if (unlikely(err != -ENOSPC)) {
 				vhost_tx_batch(net, nvq, sock, &msg);
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, 1, ndesc);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -829,7 +833,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, 1, ndesc);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -868,6 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	int err;
 	struct vhost_net_ubuf_ref *ubufs;
 	struct ubuf_info_msgzc *ubuf;
+	unsigned int ndesc = 0;
 	bool zcopy_used;
 	int sent_pkts = 0;
 
@@ -879,7 +884,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 
 		busyloop_intr = false;
 		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
+				   &busyloop_intr, &ndesc);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(head < 0))
 			break;
@@ -941,7 +946,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 					vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 			}
 			if (retry) {
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, 1, ndesc);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -1045,11 +1050,12 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		       unsigned *iovcount,
 		       struct vhost_log *log,
 		       unsigned *log_num,
-		       unsigned int quota)
+		       unsigned int quota,
+		       unsigned int *ndesc)
 {
 	struct vhost_virtqueue *vq = &nvq->vq;
 	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
-	unsigned int out, in;
+	unsigned int out, in, desc_num, n = 0;
 	int seg = 0;
 	int headcount = 0;
 	unsigned d;
@@ -1064,9 +1070,9 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 			r = -ENOBUFS;
 			goto err;
 		}
-		r = vhost_get_vq_desc(vq, vq->iov + seg,
-				      ARRAY_SIZE(vq->iov) - seg, &out,
-				      &in, log, log_num);
+		r = vhost_get_vq_desc_n(vq, vq->iov + seg,
+					ARRAY_SIZE(vq->iov) - seg, &out,
+					&in, log, log_num, &desc_num);
 		if (unlikely(r < 0))
 			goto err;
 
@@ -1093,6 +1099,7 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		++headcount;
 		datalen -= len;
 		seg += in;
+		n += desc_num;
 	}
 
 	*iovcount = seg;
@@ -1113,9 +1120,11 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		nheads[0] = headcount;
 	}
 
+	*ndesc = n;
+
 	return headcount;
 err:
-	vhost_discard_vq_desc(vq, headcount);
+	vhost_discard_vq_desc(vq, headcount, n);
 	return r;
 }
 
@@ -1151,6 +1160,7 @@ static void handle_rx(struct vhost_net *net)
 	struct iov_iter fixup;
 	__virtio16 num_buffers;
 	int recv_pkts = 0;
+	unsigned int ndesc;
 
 	mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
 	sock = vhost_vq_get_backend(vq);
@@ -1182,7 +1192,8 @@ static void handle_rx(struct vhost_net *net)
 		headcount = get_rx_bufs(nvq, vq->heads + count,
 					vq->nheads + count,
 					vhost_len, &in, vq_log, &log,
-					likely(mergeable) ? UIO_MAXIOV : 1);
+					likely(mergeable) ? UIO_MAXIOV : 1,
+					&ndesc);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(headcount < 0))
 			goto out;
@@ -1228,7 +1239,7 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(err != sock_len)) {
 			pr_debug("Discarded rx packet: "
 				 " len %d, expected %zd\n", err, sock_len);
-			vhost_discard_vq_desc(vq, headcount);
+			vhost_discard_vq_desc(vq, headcount, ndesc);
 			continue;
 		}
 		/* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
@@ -1252,7 +1263,7 @@ static void handle_rx(struct vhost_net *net)
 		    copy_to_iter(&num_buffers, sizeof num_buffers,
 				 &fixup) != sizeof num_buffers) {
 			vq_err(vq, "Failed num_buffers write");
-			vhost_discard_vq_desc(vq, headcount);
+			vhost_discard_vq_desc(vq, headcount, ndesc);
 			goto out;
 		}
 		nvq->done_idx += headcount;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8570fdf2e14a..b56568807588 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2792,18 +2792,11 @@ static int get_indirect(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* This looks in the virtqueue and for the first available buffer, and converts
- * it to an iovec for convenient access.  Since descriptors consist of some
- * number of output then some number of input descriptors, it's actually two
- * iovecs, but we pack them into one and note how many of each there were.
- *
- * This function returns the descriptor number found, or vq->num (which is
- * never a valid descriptor number) if none was found.  A negative code is
- * returned on error. */
-int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct iovec iov[], unsigned int iov_size,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num)
+int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
+			struct iovec iov[], unsigned int iov_size,
+			unsigned int *out_num, unsigned int *in_num,
+			struct vhost_log *log, unsigned int *log_num,
+			unsigned int *ndesc)
 {
 	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
 	struct vring_desc desc;
@@ -2921,16 +2914,40 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	vq->last_avail_idx++;
 	vq->next_avail_head += c;
 
+	if (ndesc)
+		*ndesc = c;
+
 	/* Assume notifications from guest are disabled at this point,
 	 * if they aren't we would need to update avail_event index. */
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 	return head;
 }
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
+
+/* This looks in the virtqueue and for the first available buffer, and converts
+ * it to an iovec for convenient access.  Since descriptors consist of some
+ * number of output then some number of input descriptors, it's actually two
+ * iovecs, but we pack them into one and note how many of each there were.
+ *
+ * This function returns the descriptor number found, or vq->num (which is
+ * never a valid descriptor number) if none was found.  A negative code is
+ * returned on error.
+ */
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	return vhost_get_vq_desc_n(vq, iov, iov_size, out_num, in_num,
+				   log, log_num, NULL);
+}
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
-void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
+void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n,
+			   unsigned int ndesc)
 {
+	vq->next_avail_head -= ndesc;
 	vq->last_avail_idx -= n;
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 621a6d9a8791..69a39540df3d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -230,7 +230,14 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
-void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
+
+int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
+			struct iovec iov[], unsigned int iov_size,
+			unsigned int *out_num, unsigned int *in_num,
+			struct vhost_log *log, unsigned int *log_num,
+			unsigned int *ndesc);
+
+void vhost_discard_vq_desc(struct vhost_virtqueue *, int n, unsigned int ndesc);
 
 bool vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 bool vhost_vq_has_work(struct vhost_virtqueue *vq);
-- 
2.31.1


