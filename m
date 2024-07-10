Return-Path: <kvm+bounces-21354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B167492DAE7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D59431C214BA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552F21607B5;
	Wed, 10 Jul 2024 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="funhm5q2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C512F38B;
	Wed, 10 Jul 2024 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646766; cv=none; b=Jvwo6e2KmOeYO4LDALX1uMeDEX6mRjIu+uN7PE3h5Wb2nOYCU3Y7NCuxlVihvlIwfA+0UIIcBUujD1UAzL0pFyCRqsIxQToCQjDGUuAQMxSW/Dc69LZAV9mbPXjziPGbJ514d3U4XVNPM7jMMbjV6hD7tteYg3rrDvY2ldrRg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646766; c=relaxed/simple;
	bh=n39Do9tgRbgw3ZexXlykzLjGhES5h4aEp9HSXPdUahY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GfTtxL1kF5I+u81dzwJUtuMKmSZi07/3rYi6oskcJm92t+1P+tIAgGYDgwfAZfFI/DUZxVyzIvJSiMKbHkNX04hyyU6HcKXwx8ZcTxGUbRS6HqYGytGvmcawuupanLmiww5T+KTfz0Li1s4JihkKpaK4nJgLkMPsYmM5R3nFZ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=funhm5q2; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-79f0c08aa45so16841685a.0;
        Wed, 10 Jul 2024 14:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646763; x=1721251563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFRj+5GbXZp5LYveWDQo7+PJsMaLqCxqCVhahBc+e9E=;
        b=funhm5q2MZaPE1b8E39hYwkfAImZj2KyTxfxUOx7H0beGiwkvY3qipHLGkS0mNNVlW
         kyVsdQCWPQodOFlp1ojHqKLdP2rWf0KUpeZ8fGfybCXXOhHiSEU8FD0W/VgducbtBcua
         8tvaXokS2ytf0duv9qppdosBCD9QVUcN+RfvFOLaGPe1StHZ/TuIJHUtoSfh5fZ7yXN+
         JDyGD1srFCguvkzMSOadC92pvIv4UFYRsvJzxY0OXyxa7TwqRR/pQ2GtPP95OPhUBiIp
         j8vZmvBwSykXQUnJXIhFvASu8aghgrWeRL9mh6HCmFbnAfTOiEssxTtQHnXb7ipjixtc
         baqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646763; x=1721251563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFRj+5GbXZp5LYveWDQo7+PJsMaLqCxqCVhahBc+e9E=;
        b=NX/9KtMNVXMnFMG4G2Ndybr7hnK/oLHtxJZqXg2vs8UNH5bWax+xnt57dG6MfPFhbr
         4oWllD7KKItv1/7M7LFZwl9it7GG608Cj3peDgtR5ga0HbAr+sROQRfzdXCkClBYqle4
         pGJ/0zeTkX2FOf8Fr6xrvX06nzs4ftFHDpu66JfGHC1TZ1CcbYRXJSzcDSKsZzAwbzZD
         0bBRo4Ah15B7+WqNDVbdlGuQdQJUCrJMAckp3hfzNb24f8KDZPrqPxNtMdJQXV1I5zg+
         EDcutOXkVM/AE67BVFvMh63wFvMo1uzgg/IxGEjXrr0U3TBDuKBfjzFdHQVzbp8xZAJI
         pKYw==
X-Forwarded-Encrypted: i=1; AJvYcCVX6WBgW7w6+hr1OrC8pu1swgGoQDYNUXLDxFI8Y5ubt0mkOsYLi54AZypSpXV3Dcbt5SZD6QzOoRN1sE3o36EONhZLWDkonSMqqFehNd2cok+HG8kJyJcB0pdF/4pHjO99KxbgOVXxVQ18A+93HyxoLUgLouA3DgvtTNwx96/Drxdo4JSpoPvL9LEYAbSptuljAXYG+5Aj7IlqTKP5hIXWetIFtWDLOe28DPYP
X-Gm-Message-State: AOJu0YzedcSirGa7Sy8Yj3oi76y2F1ehStSj5UPNY31e+GE8+a0OZkUp
	iU/NfGmdro3ud2bO8HAsbIWk3FPwCjGm/C6rmYiQwkj+chSzbwg+
X-Google-Smtp-Source: AGHT+IHqZShenZdCom11Cahq1mvTkynECydjnvU9rIy9/fCc1xw0zjvl3LB4oJWNPyqHWZq+r+EQ8A==
X-Received: by 2002:a05:620a:1aa4:b0:79f:67b:4fdc with SMTP id af79cd13be357-79f19a36bb9mr1028884485a.2.1720646763205;
        Wed, 10 Jul 2024 14:26:03 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:02 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 09/14] virtio/vsock: add common datagram recv path
Date: Wed, 10 Jul 2024 21:25:50 +0000
Message-Id: <20240710212555.1617795-10-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

This commit adds the common datagram receive functionality for virtio
transports. It does not add the vhost/virtio users of that
functionality.

This functionality includes:
- changes to the virtio_transport_recv_pkt() path for finding the
  bound socket receiver for incoming packets
- virtio_transport_recv_pkt() saves the source cid and port to the
  control buffer for recvmsg() to initialize sockaddr_vm structure
  when using datagram

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 net/vmw_vsock/virtio_transport_common.c | 79 +++++++++++++++++++++----
 1 file changed, 66 insertions(+), 13 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 46cd1807f8e3..a571b575fde9 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -235,7 +235,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
 
 static u16 virtio_transport_get_type(struct sock *sk)
 {
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_DGRAM)
+		return VIRTIO_VSOCK_TYPE_DGRAM;
+	else if (sk->sk_type == SOCK_STREAM)
 		return VIRTIO_VSOCK_TYPE_STREAM;
 	else
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
@@ -1422,6 +1424,33 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		kfree_skb(skb);
 }
 
+static void
+virtio_transport_dgram_kfree_skb(struct sk_buff *skb, int err)
+{
+	if (err == -ENOMEM)
+		kfree_skb_reason(skb, SKB_DROP_REASON_SOCKET_RCVBUFF);
+	else if (err == -ENOBUFS)
+		kfree_skb_reason(skb, SKB_DROP_REASON_PROTO_MEM);
+	else
+		kfree_skb(skb);
+}
+
+/* This function takes ownership of the skb.
+ *
+ * It either places the skb on the sk_receive_queue or frees it.
+ */
+static void
+virtio_transport_recv_dgram(struct sock *sk, struct sk_buff *skb)
+{
+	int err;
+
+	err = sock_queue_rcv_skb(sk, skb);
+	if (err) {
+		virtio_transport_dgram_kfree_skb(skb, err);
+		return;
+	}
+}
+
 static int
 virtio_transport_recv_connected(struct sock *sk,
 				struct sk_buff *skb)
@@ -1591,7 +1620,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 static bool virtio_transport_valid_type(u16 type)
 {
 	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
-	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
+	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
 }
 
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
@@ -1601,44 +1631,57 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 			       struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
+	struct vsock_skb_cb *vsock_cb;
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
 	struct sock *sk;
 	bool space_available;
+	u16 type;
 
 	vsock_addr_init(&src, le64_to_cpu(hdr->src_cid),
 			le32_to_cpu(hdr->src_port));
 	vsock_addr_init(&dst, le64_to_cpu(hdr->dst_cid),
 			le32_to_cpu(hdr->dst_port));
 
+	type = le16_to_cpu(hdr->type);
+
 	trace_virtio_transport_recv_pkt(src.svm_cid, src.svm_port,
 					dst.svm_cid, dst.svm_port,
 					le32_to_cpu(hdr->len),
-					le16_to_cpu(hdr->type),
+					type,
 					le16_to_cpu(hdr->op),
 					le32_to_cpu(hdr->flags),
 					le32_to_cpu(hdr->buf_alloc),
 					le32_to_cpu(hdr->fwd_cnt));
 
-	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
+	if (!virtio_transport_valid_type(type)) {
 		(void)virtio_transport_reset_no_sock(t, skb);
 		goto free_pkt;
 	}
 
-	/* The socket must be in connected or bound table
-	 * otherwise send reset back
+	/* For stream/seqpacket, the socket must be in connected or bound table
+	 * otherwise send reset back.
+	 *
+	 * For datagrams, no reset is sent back.
 	 */
 	sk = vsock_find_connected_socket(&src, &dst);
 	if (!sk) {
-		sk = vsock_find_bound_socket(&dst);
-		if (!sk) {
-			(void)virtio_transport_reset_no_sock(t, skb);
-			goto free_pkt;
+		if (type == VIRTIO_VSOCK_TYPE_DGRAM) {
+			sk = vsock_find_bound_dgram_socket(&dst);
+			if (!sk)
+				goto free_pkt;
+		} else {
+			sk = vsock_find_bound_socket(&dst);
+			if (!sk) {
+				(void)virtio_transport_reset_no_sock(t, skb);
+				goto free_pkt;
+			}
 		}
 	}
 
-	if (virtio_transport_get_type(sk) != le16_to_cpu(hdr->type)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+	if (virtio_transport_get_type(sk) != type) {
+		if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+			(void)virtio_transport_reset_no_sock(t, skb);
 		sock_put(sk);
 		goto free_pkt;
 	}
@@ -1654,12 +1697,21 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	/* Check if sk has been closed before lock_sock */
 	if (sock_flag(sk, SOCK_DONE)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+			(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);
 		goto free_pkt;
 	}
 
+	if (sk->sk_type == SOCK_DGRAM) {
+		vsock_cb = vsock_skb_cb(skb);
+		vsock_cb->src_cid = src.svm_cid;
+		vsock_cb->src_port = src.svm_port;
+		virtio_transport_recv_dgram(sk, skb);
+		goto out;
+	}
+
 	space_available = virtio_transport_space_update(sk, skb);
 
 	/* Update CID in case it has changed after a transport reset event */
@@ -1691,6 +1743,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		break;
 	}
 
+out:
 	release_sock(sk);
 
 	/* Release refcnt obtained when we fetched this socket out of the
-- 
2.20.1


