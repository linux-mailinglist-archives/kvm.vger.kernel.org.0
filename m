Return-Path: <kvm+bounces-70556-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFVaKbqfiGlAsgQAu9opvQ
	(envelope-from <kvm+bounces-70556-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 15:37:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5309E108F01
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 15:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 48845303C800
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 14:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3809835B140;
	Sun,  8 Feb 2026 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+cscega"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A0935B129
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770561316; cv=none; b=NV3BslcMMztBZtbBBoOR2jO+JqK7qnhho6aXomuUvUP5hZ2wLF3FuYaz/jHaWi9dFmNE8WsOAFH8E3cfqcwf68soHRVGWj5rpxHbg7TZTXCi/0KTP/NE1k+c0Ix+YCBuADf8O7xaK8NEF68mfuB4N15ocA+ffiTcn7ngnxtLXSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770561316; c=relaxed/simple;
	bh=wvoz2yEAU6sAeThW/9Wc+oWaUoQaY677EasHFK7XYpE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mU/CLLeTFJZqXWftEZJ/n/cTjm+gCOYK8dF8+7h7N8GEINHlVi4kZxaXW3Bpw3QphNbq7zAxaga+SDgGYkbhTa/SyiqE4Ax5/qePIjv6RW8/JAeBnxu2l5XDW+Vr+Q5F8TpvVZmrNw/D5vPbaw+Tq92xIDqJ+DfS9qvw1Yb8P9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+cscega; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770561314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2jDMLCng9gvJ00q8oAtIVUFVCZC5q7ddA17a+3z9mOs=;
	b=T+cscega89onMHDyhWLvv2Tkm1gYEVtopVy+XB10VfJ2MO4q6BMsGvOFmSqCoCUE2wZJhA
	QKsitIRhwsqKFdEALhReNf7mikv7ZwWvh+AUVV2fd84cUiY6XrCa2SpophWwsrLqFrMNMg
	0GFA8MWAqxi8dYeJTJMtLMNqiZ5IuO0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-216-Z9xYUGllOWWknLj8Ixf3ug-1; Sun,
 08 Feb 2026 09:35:11 -0500
X-MC-Unique: Z9xYUGllOWWknLj8Ixf3ug-1
X-Mimecast-MFC-AGG-ID: Z9xYUGllOWWknLj8Ixf3ug_1770561310
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6289B1956095;
	Sun,  8 Feb 2026 14:35:10 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.33])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DFEA918004AD;
	Sun,  8 Feb 2026 14:35:06 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 3/3] vhost/net: add RX netfilter offload path
Date: Sun,  8 Feb 2026 22:32:24 +0800
Message-ID: <20260208143441.2177372-4-lulu@redhat.com>
In-Reply-To: <20260208143441.2177372-1-lulu@redhat.com>
References: <20260208143441.2177372-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70556-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.997];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5309E108F01
X-Rspamd-Action: no action

Route RX packets through the netfilter socket when configured.
Key points:
- Add VHOST_NET_FILTER_MAX_LEN upper bound for filter payload size
- Introduce vhost_net_filter_request() to send REQUEST to userspace
- Add handle_rx_filter() fast path for RX when filter is active
- Hook filter path in handle_rx() when filter_sock is set

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/net.c | 229 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 229 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f02deff0e53c..aa9a5ed43eae 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -161,6 +161,13 @@ struct vhost_net {
 
 static unsigned vhost_net_zcopy_mask __read_mostly;
 
+/*
+ * Upper bound for a single packet payload on the filter path.
+ * Keep this large enough for the largest expected frame plus vnet headers,
+ * but still bounded to avoid unbounded allocations.
+ */
+#define VHOST_NET_FILTER_MAX_LEN (4096 + 65536)
+
 static void *vhost_net_buf_get_ptr(struct vhost_net_buf *rxq)
 {
 	if (rxq->tail != rxq->head)
@@ -1227,6 +1234,222 @@ static long vhost_net_set_filter(struct vhost_net *n, int fd)
 	return r;
 }
 
+/*
+ * Send a filter REQUEST message to userspace for a single packet.
+ *
+ * The caller provides a writable buffer; userspace may inspect the content and
+ * optionally modify it in place. We only accept the packet if the returned
+ * length matches the original length, otherwise the packet is dropped.
+ */
+static int vhost_net_filter_request(struct vhost_net *n, u16 direction,
+				    void *buf, u32 *len)
+{
+	struct vhost_net_filter_msg msg = {
+		.type = VHOST_NET_FILTER_MSG_REQUEST,
+		.direction = direction,
+		.len = *len,
+	};
+	struct msghdr msghdr = { 0 };
+	struct kvec iov[2] = {
+		{ .iov_base = &msg, .iov_len = sizeof(msg) },
+		{ .iov_base = buf, .iov_len = *len },
+	};
+	struct socket *sock;
+	struct file *sock_file = NULL;
+	int ret;
+
+	/*
+	 * Take a temporary file reference to guard against concurrent
+	 * filter socket replacement while we send the message.
+	 */
+	spin_lock(&n->filter_lock);
+	sock = n->filter_sock;
+	if (sock)
+		sock_file = get_file(sock->file);
+	spin_unlock(&n->filter_lock);
+
+	if (!sock) {
+		ret = -ENOTCONN;
+		goto out_put;
+	}
+
+	ret = kernel_sendmsg(sock, &msghdr, iov,
+			     *len ? 2 : 1, sizeof(msg) + *len);
+
+out_put:
+	if (sock_file)
+		fput(sock_file);
+
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+/*
+ * RX fast path when filter offload is active.
+ *
+ * This mirrors handle_rx() but routes each RX packet through userspace
+ * netfilter. Packets are copied into a temporary buffer, sent to the filter
+ * socket as a REQUEST, and only delivered to the guest if userspace keeps the
+ * length unchanged. Any truncation or mismatch drops the packet.
+ */
+static void handle_rx_filter(struct vhost_net *net, struct socket *sock)
+{
+	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_RX];
+	struct vhost_virtqueue *vq = &nvq->vq;
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
+	unsigned int count = 0;
+	unsigned int in, log;
+	struct vhost_log *vq_log;
+	struct virtio_net_hdr hdr = {
+		.flags = 0,
+		.gso_type = VIRTIO_NET_HDR_GSO_NONE
+	};
+	struct msghdr msg = {
+		.msg_name = NULL,
+		.msg_namelen = 0,
+		.msg_control = NULL,
+		.msg_controllen = 0,
+		.msg_flags = MSG_DONTWAIT,
+	};
+	size_t total_len = 0;
+	int mergeable;
+	bool set_num_buffers;
+	size_t vhost_hlen, sock_hlen;
+	size_t vhost_len, sock_len;
+	bool busyloop_intr = false;
+	struct iov_iter fixup;
+	__virtio16 num_buffers;
+	int recv_pkts = 0;
+	unsigned int ndesc;
+	void *pkt;
+
+	pkt = kvmalloc(VHOST_NET_FILTER_MAX_LEN, GFP_KERNEL | __GFP_NOWARN);
+	if (!pkt) {
+		vhost_net_enable_vq(net, vq);
+		return;
+	}
+
+	vhost_hlen = nvq->vhost_hlen;
+	sock_hlen = nvq->sock_hlen;
+
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ? vq->log : NULL;
+	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
+	set_num_buffers = mergeable || vhost_has_feature(vq, VIRTIO_F_VERSION_1);
+
+	do {
+		u32 pkt_len;
+		int err;
+		s16 headcount;
+		struct kvec iov;
+
+		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
+						      &busyloop_intr, &count);
+		if (!sock_len)
+			break;
+		sock_len += sock_hlen;
+		if (sock_len > VHOST_NET_FILTER_MAX_LEN) {
+			/* Consume and drop oversized packet. */
+			iov.iov_base = pkt;
+			iov.iov_len = 1;
+			kernel_recvmsg(sock, &msg, &iov, 1, 1,
+				       MSG_DONTWAIT | MSG_TRUNC);
+			continue;
+		}
+
+		vhost_len = sock_len + vhost_hlen;
+		headcount = get_rx_bufs(nvq, vq->heads + count,
+					vq->nheads + count, vhost_len, &in,
+					vq_log, &log,
+					likely(mergeable) ? UIO_MAXIOV : 1,
+					&ndesc);
+		if (unlikely(headcount < 0))
+			goto out;
+
+		if (!headcount) {
+			if (unlikely(busyloop_intr)) {
+				vhost_poll_queue(&vq->poll);
+			} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
+				vhost_disable_notify(&net->dev, vq);
+				continue;
+			}
+			goto out;
+		}
+
+		busyloop_intr = false;
+
+		if (nvq->rx_ring)
+			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
+
+		iov.iov_base = pkt;
+		iov.iov_len = sock_len;
+		err = kernel_recvmsg(sock, &msg, &iov, 1, sock_len,
+				     MSG_DONTWAIT | MSG_TRUNC);
+		if (unlikely(err != sock_len)) {
+			vhost_discard_vq_desc(vq, headcount, ndesc);
+			continue;
+		}
+
+		pkt_len = sock_len;
+		err = vhost_net_filter_request(net, VHOST_NET_FILTER_DIRECTION_TX,
+					       pkt, &pkt_len);
+		if (err < 0)
+			pkt_len = sock_len;
+		if (pkt_len != sock_len) {
+			vhost_discard_vq_desc(vq, headcount, ndesc);
+			continue;
+		}
+
+		iov_iter_init(&msg.msg_iter, ITER_DEST, vq->iov, in, vhost_len);
+		fixup = msg.msg_iter;
+		if (unlikely(vhost_hlen))
+			iov_iter_advance(&msg.msg_iter, vhost_hlen);
+
+		if (copy_to_iter(pkt, sock_len, &msg.msg_iter) != sock_len) {
+			vhost_discard_vq_desc(vq, headcount, ndesc);
+			goto out;
+		}
+
+		if (unlikely(vhost_hlen)) {
+			if (copy_to_iter(&hdr, sizeof(hdr),
+					 &fixup) != sizeof(hdr)) {
+				vhost_discard_vq_desc(vq, headcount, ndesc);
+				goto out;
+			}
+		} else {
+			iov_iter_advance(&fixup, sizeof(hdr));
+		}
+
+		num_buffers = cpu_to_vhost16(vq, headcount);
+		if (likely(set_num_buffers) &&
+		    copy_to_iter(&num_buffers, sizeof(num_buffers), &fixup) !=
+			    sizeof(num_buffers)) {
+			vhost_discard_vq_desc(vq, headcount, ndesc);
+			goto out;
+		}
+
+		nvq->done_idx += headcount;
+		count += in_order ? 1 : headcount;
+		if (nvq->done_idx > VHOST_NET_BATCH) {
+			vhost_net_signal_used(nvq, count);
+			count = 0;
+		}
+
+		if (unlikely(vq_log))
+			vhost_log_write(vq, vq_log, log, vhost_len, vq->iov, in);
+
+		total_len += vhost_len;
+	} while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
+
+	if (unlikely(busyloop_intr))
+		vhost_poll_queue(&vq->poll);
+	else if (!sock_len)
+		vhost_net_enable_vq(net, vq);
+
+out:
+	vhost_net_signal_used(nvq, count);
+	kvfree(pkt);
+}
 /* Expects to be always run from workqueue - which acts as
  * read-size critical section for our kind of RCU. */
 static void handle_rx(struct vhost_net *net)
@@ -1281,6 +1504,11 @@ static void handle_rx(struct vhost_net *net)
 	set_num_buffers = mergeable ||
 			  vhost_has_feature(vq, VIRTIO_F_VERSION_1);
 
+	if (READ_ONCE(net->filter_sock)) {
+		handle_rx_filter(net, sock);
+		goto out_unlock;
+	}
+
 	do {
 		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
 						      &busyloop_intr, &count);
@@ -1383,6 +1611,7 @@ static void handle_rx(struct vhost_net *net)
 		vhost_net_enable_vq(net, vq);
 out:
 	vhost_net_signal_used(nvq, count);
+out_unlock:
 	mutex_unlock(&vq->mutex);
 }
 
-- 
2.52.0


