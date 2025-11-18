Return-Path: <kvm+bounces-63450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F556C66EE9
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 97483342643
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669FD32B9A7;
	Tue, 18 Nov 2025 02:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUrWLcG1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DEE324718
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 02:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763431238; cv=none; b=vB6DYiRvZdylcCnZt65hNIANy1xKcfRLCix0meuLVGG6uLGjVQg3BzfqhMpJf6yKNB7hIcwpzU3OJDkezJ2OjPbWlOGAyuUJfNY9Hb3R4HpoLIgY/x5bf7TlcZlelI78BvMIfZlcpslI9kGab9PMUrKmXiRDe5bk3vJ7puzw5qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763431238; c=relaxed/simple;
	bh=HJGq+8JznKPehBe3Auc7LlgZtPWKt50SOYvOScpGBw8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aLUpQL8cfGCK5u78CDN5D0kvaQca4vawYnkfkNsPGxjczu+ZfgxfEAFvTKctb3jI5iOrUHtHHteheogdrEyBIq7C7tgSLBfq9OFQGqsB/gguclcjr5e3nEIT6/6bxNJkHATKjTBvHTNtHd+YWXS2q3gm/xOxqKf19uFnhlYwZvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eUrWLcG1; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2957850c63bso51241255ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 18:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763431234; x=1764036034; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hD0KYb00sKvkaOrJxVEtur1zHnF5j+8KCgDYEdmsvM=;
        b=eUrWLcG1t9oMdVVUHIY/p8VDYRVHSUxUwdMy6LZUlLOkrZ44wxarIlxDv1ZCvHyukL
         /q8DtaUrd07siEyd9pQ4YQqYZ7Grz55QTl9/sH2RLhxH2AlV5zqOk5Uy91EeIVJOZVuQ
         J5VHcJ1yP4Z+XqNEVWyFA9y8s3xsEFfpdT5czzjPEdpCSMyg/n6ymDqE1nld3C9171hf
         Gb0YvtxcINRYQtOLmB37LmMFU+YSuZvbQxWZkxmRkZ+NcVAWyJ3Sa5n4tRdSpmdcF83r
         3Clf58/eFSyNFoPakSzinvEWwxUbQDWGZDyLTwUS8fjgqGgTtK1dYIzDpz8bA2HjqBmU
         5f0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763431234; x=1764036034;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3hD0KYb00sKvkaOrJxVEtur1zHnF5j+8KCgDYEdmsvM=;
        b=GNSTs/M87lam7ysaK2UGd32A9qyne5GZqqLY44TZTYUq8fYt9O6cN1kujRoukeyPfL
         vaHx8O6dwA68vRIJ6akSa/8cAhMIqaGqn3lhMN6nx1TTlWJzxdWCU6KiOy3G4+8NHx58
         W1qyFiDBhjzJDQeXOX77BMNs3fI3wRZE5sZEjSm8jnhKkJjL0BqP5nzAC23cEcfaxFdZ
         TK/TxxFgvyACuvpNKrGIdJJWbs/Mp/SrS7Dm9OMNBjzAG2seXxWj8mVBBtqVhCEWJrgY
         pZ/BFtwgMn3LWrhN+HNk/H7zDEXPqxfN2T5wEDoWXmAVO0GXSLa7GAbRhxR1YTKWcBGg
         3PjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGGahQbOIt6cw5BMp0DlL7KVFw+OB5YBNL9IWgEb4M/usFUNKtG7zhPqIBHe9zE9t6fd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0HAii9vLcGIuah1wB77kGvdgmfSQVsMjbEXo3c+fOZDAIKdPe
	LObML7Xy9aaKDjCFna70uw1UhsmDgIl4KKXjutFTsYM9SoHd2BS/Zb7h
X-Gm-Gg: ASbGncuXe/rUnAXR4skQc3l2MIi7p/++YxRMH0Z9sut/oI6e5rsmOuFDgSzuS6aeiAB
	ozMu0w8XzJjydwtzwFs173jkjkGqDhpPN9wIbQVY4GHT1gMUXhcNF3eRO/oBJ67WiBjlbyDXUFq
	IHhXPor2FpiTAIzuKcd25WkB6LoUzIE4rXTN06Od0JLtr0zmHNlIPMse2UOEOmK1LSBVlA+Q5q2
	ZQXhsKYOhgIYThMRt/7PWzYqrN83m51tlbTjXAqE73LwI3RVE9W+ss1m/KyreUaTSsaY7bKx4cJ
	RY+VB5H55dI8UJtTdwZ5qS/jqOU0K81ypGapAxGhBnBIGemjhxPnKWLVkc1zS5SV7gqAz2l4m4M
	KSsYWoonDZVXvP5TzTXI9Kj5kea2+gNDoLR4UBQdZw+kY7NDnZG6L7i1lAeYgdtHAwojMFO3Cx8
	sRBf5LW0eGkqxx0TzXyApwOsgbsYop9Q==
X-Google-Smtp-Source: AGHT+IF1CsQmfEx6EB8DX8w1tzs1Zdd3wDl7UiawoOG6oflh+1/zrlsscaroBegx2HOkAvflhjbKWg==
X-Received: by 2002:a17:902:cf06:b0:298:5fde:5a77 with SMTP id d9443c01a7336-299f559e658mr18193015ad.22.1763431233593;
        Mon, 17 Nov 2025 18:00:33 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2345e3sm153683375ad.1.2025.11.17.18.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:00:32 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 17 Nov 2025 18:00:27 -0800
Subject: [PATCH net-next v10 04/11] vsock: add netns support to virtio
 transports
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-vsock-vmtest-v10-4-df08f165bf3e@meta.com>
References: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
In-Reply-To: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add netns support to loopback and vhost. Keep netns disabled for
virtio-vsock, but add necessary changes to comply with common API
updates.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v10:
- Splitting patches complicates the series with meaningless placeholder values that eventually get replaced anyway,
  so to avoid that this patch combines into one. Links
  to previous patches here:
  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-3-852787a37bed@meta.com/
  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-6-852787a37bed@meta.com/
  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-7-852787a37bed@meta.com/
- remove placeholder values (Stefano)
- update comment describe net/net_mode for
  virtio_transport_reset_no_sock()
---
 drivers/vhost/vsock.c                   | 45 +++++++++++++++++------
 include/linux/virtio_vsock.h            |  8 +++--
 net/vmw_vsock/virtio_transport.c        | 10 ++++--
 net/vmw_vsock/virtio_transport_common.c | 63 ++++++++++++++++++++++++---------
 net/vmw_vsock/vsock_loopback.c          |  8 +++--
 5 files changed, 102 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c8319cd1c232..2846076d484f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -46,6 +46,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
 struct vhost_vsock {
 	struct vhost_dev dev;
 	struct vhost_virtqueue vqs[2];
+	struct net *net;
+	netns_tracker ns_tracker;
+
+	/* The ns mode at the time vhost_vsock was created */
+	enum vsock_net_mode net_mode;
 
 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 	struct hlist_node hash;
@@ -72,7 +77,8 @@ static bool vhost_transport_supports_local_mode(void)
 /* Callers that dereference the return value must hold vhost_vsock_mutex or the
  * RCU read lock.
  */
-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net,
+					   enum vsock_net_mode mode)
 {
 	struct vhost_vsock *vsock;
 
@@ -83,9 +89,10 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 		if (other_cid == 0)
 			continue;
 
-		if (other_cid == guest_cid)
+		if (other_cid == guest_cid &&
+		    vsock_net_check_mode(net, mode, vsock->net,
+					 vsock->net_mode))
 			return vsock;
-
 	}
 
 	return NULL;
@@ -274,7 +281,8 @@ static void vhost_transport_send_pkt_work(struct vhost_work *work)
 }
 
 static int
-vhost_transport_send_pkt(struct sk_buff *skb)
+vhost_transport_send_pkt(struct sk_buff *skb, struct net *net,
+			 enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct vhost_vsock *vsock;
@@ -283,7 +291,7 @@ vhost_transport_send_pkt(struct sk_buff *skb)
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid), net, net_mode);
 	if (!vsock) {
 		rcu_read_unlock();
 		kfree_skb(skb);
@@ -310,7 +318,8 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid,
+				sock_net(sk_vsock(vsk)), vsk->net_mode);
 	if (!vsock)
 		goto out;
 
@@ -470,11 +479,12 @@ static struct virtio_transport vhost_transport = {
 static bool
 vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
 {
+	struct net *net = sock_net(sk_vsock(vsk));
 	struct vhost_vsock *vsock;
 	bool seqpacket_allow = false;
 
 	rcu_read_lock();
-	vsock = vhost_vsock_get(remote_cid);
+	vsock = vhost_vsock_get(remote_cid, net, vsk->net_mode);
 
 	if (vsock)
 		seqpacket_allow = vsock->seqpacket_allow;
@@ -545,7 +555,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		if (le64_to_cpu(hdr->src_cid) == vsock->guest_cid &&
 		    le64_to_cpu(hdr->dst_cid) ==
 		    vhost_transport_get_local_cid())
-			virtio_transport_recv_pkt(&vhost_transport, skb);
+			virtio_transport_recv_pkt(&vhost_transport, skb,
+						  vsock->net, vsock->net_mode);
 		else
 			kfree_skb(skb);
 
@@ -662,6 +673,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 {
 	struct vhost_virtqueue **vqs;
 	struct vhost_vsock *vsock;
+	struct net *net;
 	int ret;
 
 	/* This struct is large and allocation could fail, fall back to vmalloc
@@ -677,6 +689,17 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
+	net = current->nsproxy->net_ns;
+	vsock->net = get_net_track(net, &vsock->ns_tracker, GFP_KERNEL);
+
+	/* Store the mode of the namespace at the time of creation. If this
+	 * namespace later changes from "global" to "local", we want this vsock
+	 * to continue operating normally and not suddenly break. For that
+	 * reason, we save the mode here and later use it when performing
+	 * socket lookups with vsock_net_check_mode() (see vhost_vsock_get()).
+	 */
+	vsock->net_mode = vsock_net_mode(net);
+
 	vsock->guest_cid = 0; /* no CID assigned yet */
 	vsock->seqpacket_allow = false;
 
@@ -716,7 +739,8 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 */
 
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk),
+			    vsk->net_mode))
 		return;
 
 	/* If the close timeout is pending, let it expire.  This avoids races
@@ -761,6 +785,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
 
 	vhost_dev_cleanup(&vsock->dev);
+	put_net_track(vsock->net, &vsock->ns_tracker);
 	kfree(vsock->dev.vqs);
 	vhost_vsock_free(vsock);
 	return 0;
@@ -787,7 +812,7 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 guest_cid)
 
 	/* Refuse if CID is already in use */
 	mutex_lock(&vhost_vsock_mutex);
-	other = vhost_vsock_get(guest_cid);
+	other = vhost_vsock_get(guest_cid, vsock->net, vsock->net_mode);
 	if (other && other != vsock) {
 		mutex_unlock(&vhost_vsock_mutex);
 		return -EADDRINUSE;
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 0c67543a45c8..5ed6136a4ed4 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -173,6 +173,8 @@ struct virtio_vsock_pkt_info {
 	u32 remote_cid, remote_port;
 	struct vsock_sock *vsk;
 	struct msghdr *msg;
+	struct net *net;
+	enum vsock_net_mode net_mode;
 	u32 pkt_len;
 	u16 type;
 	u16 op;
@@ -185,7 +187,8 @@ struct virtio_transport {
 	struct vsock_transport transport;
 
 	/* Takes ownership of the packet */
-	int (*send_pkt)(struct sk_buff *skb);
+	int (*send_pkt)(struct sk_buff *skb, struct net *net,
+			enum vsock_net_mode net_mode);
 
 	/* Used in MSG_ZEROCOPY mode. Checks, that provided data
 	 * (number of buffers) could be transmitted with zerocopy
@@ -280,7 +283,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 void virtio_transport_destruct(struct vsock_sock *vsk);
 
 void virtio_transport_recv_pkt(struct virtio_transport *t,
-			       struct sk_buff *skb);
+			       struct sk_buff *skb, struct net *net,
+			       enum vsock_net_mode net_mode);
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
 void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e585cb66c6f5..bc266bdb7faa 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -243,7 +243,8 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
 }
 
 static int
-virtio_transport_send_pkt(struct sk_buff *skb)
+virtio_transport_send_pkt(struct sk_buff *skb, struct net *net,
+			  enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr;
 	struct virtio_vsock *vsock;
@@ -675,7 +676,12 @@ static void virtio_transport_rx_work(struct work_struct *work)
 				virtio_vsock_skb_put(skb, payload_len);
 
 			virtio_transport_deliver_tap_pkt(skb);
-			virtio_transport_recv_pkt(&virtio_transport, skb);
+
+			/* Force virtio-transport into global mode since it
+			 * does not yet support local-mode namespacing.
+			 */
+			virtio_transport_recv_pkt(&virtio_transport, skb,
+						  NULL, VSOCK_NET_MODE_GLOBAL);
 		}
 	} while (!virtqueue_enable_cb(vq));
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dcc8a1d5851e..168e7517a3f0 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -413,7 +413,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
-		ret = t_ops->send_pkt(skb);
+		ret = t_ops->send_pkt(skb, info->net, info->net_mode);
 		if (ret < 0)
 			break;
 
@@ -527,6 +527,8 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1067,6 +1069,8 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_REQUEST,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1082,6 +1086,8 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 			 (mode & SEND_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1108,6 +1114,8 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1145,6 +1153,8 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.reply = !!skb,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	/* Send RST only if the original pkt is not a RST pkt */
@@ -1156,15 +1166,27 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 
 /* Normally packets are associated with a socket.  There may be no socket if an
  * attempt was made to connect to a socket that does not exist.
+ *
+ * net and net_mode refer to the namespace of whoever sent the invalid message.
+ * For loopback, this is the namespace of the socket. For vhost, this is the
+ * namespace of the VM (i.e., vhost_vsock).
  */
 static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb, struct net *net,
+					  enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
 		.type = le16_to_cpu(hdr->type),
 		.reply = true,
+
+		/* net or net_mode are not defined here because we pass
+		 * net and net_mode directly to t->send_pkt(), instead of
+		 * relying on virtio_transport_send_pkt_info() to pass them to
+		 * t->send_pkt(). They are not needed by
+		 * virtio_transport_alloc_skb().
+		 */
 	};
 	struct sk_buff *reply;
 
@@ -1183,7 +1205,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!reply)
 		return -ENOMEM;
 
-	return t->send_pkt(reply);
+	return t->send_pkt(reply, net, net_mode);
 }
 
 /* This function should be called with sk_lock held and SOCK_DONE set */
@@ -1465,6 +1487,8 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 		.remote_port = le32_to_cpu(hdr->src_port),
 		.reply = true,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1507,12 +1531,14 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	int ret;
 
 	if (le16_to_cpu(hdr->op) != VIRTIO_VSOCK_OP_REQUEST) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -EINVAL;
 	}
 
 	if (sk_acceptq_is_full(sk)) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -ENOMEM;
 	}
 
@@ -1520,13 +1546,15 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	 * Subsequent enqueues would lead to a memory leak.
 	 */
 	if (sk->sk_shutdown == SHUTDOWN_MASK) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -ESHUTDOWN;
 	}
 
 	child = vsock_create_connected(sk);
 	if (!child) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -ENOMEM;
 	}
 
@@ -1548,7 +1576,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	 */
 	if (ret || vchild->transport != &t->transport) {
 		release_sock(child);
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		sock_put(child);
 		return ret;
 	}
@@ -1576,7 +1605,8 @@ static bool virtio_transport_valid_type(u16 type)
  * lock.
  */
 void virtio_transport_recv_pkt(struct virtio_transport *t,
-			       struct sk_buff *skb)
+			       struct sk_buff *skb, struct net *net,
+			       enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct sockaddr_vm src, dst;
@@ -1599,24 +1629,25 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le32_to_cpu(hdr->fwd_cnt));
 
 	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		goto free_pkt;
 	}
 
 	/* The socket must be in connected or bound table
 	 * otherwise send reset back
 	 */
-	sk = vsock_find_connected_socket(&src, &dst);
+	sk = vsock_find_connected_socket_net(&src, &dst, net, net_mode);
 	if (!sk) {
-		sk = vsock_find_bound_socket(&dst);
+		sk = vsock_find_bound_socket_net(&dst, net, net_mode);
 		if (!sk) {
-			(void)virtio_transport_reset_no_sock(t, skb);
+			(void)virtio_transport_reset_no_sock(t, skb, net,
+							     net_mode);
 			goto free_pkt;
 		}
 	}
 
 	if (virtio_transport_get_type(sk) != le16_to_cpu(hdr->type)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		sock_put(sk);
 		goto free_pkt;
 	}
@@ -1635,7 +1666,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	 */
 	if (sock_flag(sk, SOCK_DONE) ||
 	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		release_sock(sk);
 		sock_put(sk);
 		goto free_pkt;
@@ -1667,7 +1698,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		kfree_skb(skb);
 		break;
 	default:
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		kfree_skb(skb);
 		break;
 	}
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 1e25c1a6b43f..a730fa74d2d9 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -31,7 +31,8 @@ static bool vsock_loopback_supports_local_mode(void)
 	return true;
 }
 
-static int vsock_loopback_send_pkt(struct sk_buff *skb)
+static int vsock_loopback_send_pkt(struct sk_buff *skb, struct net *net,
+				   enum vsock_net_mode net_mode)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
 	int len = skb->len;
@@ -138,7 +139,10 @@ static void vsock_loopback_work(struct work_struct *work)
 		 */
 		virtio_transport_consume_skb_sent(skb, false);
 		virtio_transport_deliver_tap_pkt(skb);
-		virtio_transport_recv_pkt(&loopback_transport, skb);
+
+		virtio_transport_recv_pkt(&loopback_transport, skb,
+					  sock_net(skb->sk),
+					  vsock_sk(skb->sk)->net_mode);
 	}
 }
 

-- 
2.47.3


