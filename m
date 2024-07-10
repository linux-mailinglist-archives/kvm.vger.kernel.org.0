Return-Path: <kvm+bounces-21346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C26C092DABB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5EBFB2135C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EED1494B8;
	Wed, 10 Jul 2024 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNrHr5JY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEB5839F3;
	Wed, 10 Jul 2024 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646759; cv=none; b=a0W7+xVPE8VjCskddhHxtha8Y8cR/JH0dcT81Zeu7Q7q1uBOxPiNkDIQPgyObGRg4Vb1z6zgUiUpEUGQjCoT0yszdYKYP1Ikl0+ZurZ1s7xcUdPYZvd8ytse5iZu+PRd2xHt4epB+w/Xu7QXDWHuWGPdhn0Mj1qNRcM/c7qcgTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646759; c=relaxed/simple;
	bh=2oNBKsr/zKHor9vzhBEXHNQLyKLNT6n5DiR1niLN3c8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VIQgkK7Xp0LRW/rXWSOtCZIVk5sdexX50seE96sQ9232iMIfHlMthasKtf1W4KNw0Zidxe7ILO10OVbe8+OurKRZSriOXFvcyCG2m5sChbZowrlOxrrXb7K4UlxZmQaHzzzkelKwDBoYZPvYIGbMUg6z9qqUSXFwmccOKi8CDpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNrHr5JY; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a05b4fa525so20546885a.1;
        Wed, 10 Jul 2024 14:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646757; x=1721251557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KX8KIo3iV7NoMHa3zqkZ0Z+vhF8zraRE7TtvznvQNIg=;
        b=XNrHr5JYrR4eRytMW7+w6ry/02BpdPUbA3Ocgtn7kHaTvNR0/qw74f8y8ZNS7IhIQS
         Shr6QJKV0CzE9hXqvFgWEbitBT+4u9Ejv9ftYvCKl6oewGb9vlY6LdKXiYGPEETR2JUu
         dsz9b4ZQNjikDmyFfOjVqfl+G0cV2lmN5SaTPFy7e/+y3xX0aADMFV0goQ8JHBrue7Mo
         gBKAlj9v9cVsaWZnHuGIzUmeUmaDz1ZT5uNXnxYsxiZGrMEk40lGW/N/c69mQD/RprXy
         jZdJTVXx66sj7lPEth2NWViMEMJHxCnd948WLJ0LCF+/ZA/0Vq/qdQ2HI+xxyC9Wu45Y
         RA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646757; x=1721251557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KX8KIo3iV7NoMHa3zqkZ0Z+vhF8zraRE7TtvznvQNIg=;
        b=PdsN9iSeMSTWAczVlQu/urvOrlleINVYoDt3FhJ0bZM3gc/un6Csn2jCnWgj90kRxb
         33hBBRmY8txuyEzcsMKq/BKbZQShUpSQ9Wi64q/uiBONzhV7JzKf1LPPsoSU6NP5M2GK
         mOx0y4TJK0inPc1IuYP5jp6j2Rh/uKYwEjwBCu/wrhnPsob7+ewZL1KquLy5wkkazRL/
         3B/NIzdjNTNq3W0942RzwZtxVT2x/zJm0iZ/yzSY9NqKgJp3NlI5frLRjAvMO6stkufs
         4EC/3onlNqtrn0Qb0ngCwJ0bOTAXQ5b2bxiekh4KhhrmHY617v8iE9RJnrlPEZIl6RpO
         RvyQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0KwqrA3O00J0IbnDJDeppACs4CHnsiNUXqI/Kxdt757qtk0TSqhe+Pflv5vSR7/s6UjCYMncgnlG6P/EFd0/oYLhSdJ6rucQ1iI3m1aieEiGG8XgSTYiGwliyj6DFlmtKEMX/FXbJny5p8WvWGR+uivedPHApQsrRoaj9oR2dYSWeLFdL+nUq/WF5+0nYCZWJV9gj4cMResw8hCdejr282Id7ZKMaqwNLTOWd
X-Gm-Message-State: AOJu0YxUquBgRgOpieSYVbv5kVwL2pXObffBq3y5eDZSpAq/bGAxJKNh
	GQ+7IEwpAf+X4aJx2uLVFfKv4nrKobj/O9ZQGc+8YgGu2Fg68tis
X-Google-Smtp-Source: AGHT+IFSj7+MYM52RaS6eZWKXpFPukkOvw7LM6PzzibSNjmPqd57Dl57Ba5FqQJnizrjtsz6ZhSPkQ==
X-Received: by 2002:a05:620a:2444:b0:79e:f9f4:3e99 with SMTP id af79cd13be357-7a1469a84d6mr197991885a.1.1720646756780;
        Wed, 10 Jul 2024 14:25:56 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:25:56 -0700 (PDT)
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
Subject: [RFC PATCH net-next v6 01/14] af_vsock: generalize vsock_dgram_recvmsg() to all transports
Date: Wed, 10 Jul 2024 21:25:42 +0000
Message-Id: <20240710212555.1617795-2-amery.hung@bytedance.com>
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

This commit drops the transport->dgram_dequeue callback and makes
vsock_dgram_recvmsg() generic to all transports.

To make this possible, two transport-level changes are introduced:
- transport in the receiving path now stores the cid and port into
  the control buffer of an skb when populating an skb. The information
  later is used to initialize sockaddr_vm structure in recvmsg()
  without referencing vsk->transport.
- transport implementations set the skb->data pointer to the beginning
  of the payload prior to adding the skb to the socket's receive queue.
  That is, they must use skb_pull() before enqueuing. This is an
  agreement between the transport and the socket layer that skb->data
  always points to the beginning of the payload (and not, for example,
  the packet header).

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 drivers/vhost/vsock.c                   |  1 -
 include/linux/virtio_vsock.h            |  5 ---
 include/net/af_vsock.h                  | 11 ++++-
 net/vmw_vsock/af_vsock.c                | 42 +++++++++++++++++-
 net/vmw_vsock/hyperv_transport.c        |  7 ---
 net/vmw_vsock/virtio_transport.c        |  1 -
 net/vmw_vsock/virtio_transport_common.c |  9 ----
 net/vmw_vsock/vmci_transport.c          | 59 +++----------------------
 net/vmw_vsock/vsock_loopback.c          |  1 -
 9 files changed, 55 insertions(+), 81 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..97fffa914e66 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -419,7 +419,6 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..8b56b8a19ddd 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -177,11 +177,6 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 				size_t len,
 				int type);
 int
-virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
-			       struct msghdr *msg,
-			       size_t len, int flags);
-
-int
 virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   size_t len);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 535701efc1e5..7aa1f5f2b1a5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -120,8 +120,6 @@ struct vsock_transport {
 
 	/* DGRAM. */
 	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
-	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
-			     size_t len, int flags);
 	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
 			     struct msghdr *, size_t len);
 	bool (*dgram_allow)(u32 cid, u32 port);
@@ -219,6 +217,15 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
 
+struct vsock_skb_cb {
+	unsigned int src_cid;
+	unsigned int src_port;
+};
+
+static inline struct vsock_skb_cb *vsock_skb_cb(struct sk_buff *skb) {
+	return (struct vsock_skb_cb *)skb->cb;
+};
+
 /**** TAP ****/
 
 struct vsock_tap {
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4b040285aa78..5e7d4d99ea2c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1273,11 +1273,15 @@ static int vsock_dgram_connect(struct socket *sock,
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags)
 {
+	struct vsock_skb_cb *vsock_cb;
 #ifdef CONFIG_BPF_SYSCALL
 	const struct proto *prot;
 #endif
 	struct vsock_sock *vsk;
+	struct sk_buff *skb;
+	size_t payload_len;
 	struct sock *sk;
+	int err;
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
@@ -1288,7 +1292,43 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		return prot->recvmsg(sk, msg, len, flags, NULL);
 #endif
 
-	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
+	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
+		return -EOPNOTSUPP;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
+
+	/* Retrieve the head sk_buff from the socket's receive queue. */
+	err = 0;
+	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
+	if (!skb)
+		return err;
+
+	payload_len = skb->len;
+
+	if (payload_len > len) {
+		payload_len = len;
+		msg->msg_flags |= MSG_TRUNC;
+	}
+
+	/* Place the datagram payload in the user's iovec. */
+	err = skb_copy_datagram_msg(skb, 0, msg, payload_len);
+	if (err)
+		goto out;
+
+	if (msg->msg_name) {
+		/* Provide the address of the sender. */
+		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
+
+		vsock_cb = vsock_skb_cb(skb);
+		vsock_addr_init(vm_addr, vsock_cb->src_cid, vsock_cb->src_port);
+		msg->msg_namelen = sizeof(*vm_addr);
+	}
+	err = payload_len;
+
+out:
+	skb_free_datagram(&vsk->sk, skb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index e2157e387217..326dd41ee2d5 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -556,12 +556,6 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
 	return -EOPNOTSUPP;
 }
 
-static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
-			     size_t len, int flags)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hvs_dgram_enqueue(struct vsock_sock *vsk,
 			     struct sockaddr_vm *remote, struct msghdr *msg,
 			     size_t dgram_len)
@@ -833,7 +827,6 @@ static struct vsock_transport hvs_transport = {
 	.shutdown                 = hvs_shutdown,
 
 	.dgram_bind               = hvs_dgram_bind,
-	.dgram_dequeue            = hvs_dgram_dequeue,
 	.dgram_enqueue            = hvs_dgram_enqueue,
 	.dgram_allow              = hvs_dgram_allow,
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 43d405298857..a8c97e95622a 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -508,7 +508,6 @@ static struct virtio_transport virtio_transport = {
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
 		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3..4bf73d20c12a 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -810,15 +810,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
 
-int
-virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
-			       struct msghdr *msg,
-			       size_t len, int flags)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
-
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b370070194fa..b39df3ed8c8d 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -610,6 +610,7 @@ vmci_transport_datagram_create_hnd(u32 resource_id,
 
 static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
 {
+	struct vsock_skb_cb *vsock_cb;
 	struct sock *sk;
 	size_t size;
 	struct sk_buff *skb;
@@ -637,10 +638,14 @@ static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
 	if (!skb)
 		return VMCI_ERROR_NO_MEM;
 
+	vsock_cb = vsock_skb_cb(skb);
+	vsock_cb->src_cid = dg->src.context;
+	vsock_cb->src_port = dg->src.resource;
 	/* sk_receive_skb() will do a sock_put(), so hold here. */
 	sock_hold(sk);
 	skb_put(skb, size);
 	memcpy(skb->data, dg, size);
+	skb_pull(skb, VMCI_DG_HEADERSIZE);
 	sk_receive_skb(sk, skb, 0);
 
 	return VMCI_SUCCESS;
@@ -1731,59 +1736,6 @@ static int vmci_transport_dgram_enqueue(
 	return err - sizeof(*dg);
 }
 
-static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
-					struct msghdr *msg, size_t len,
-					int flags)
-{
-	int err;
-	struct vmci_datagram *dg;
-	size_t payload_len;
-	struct sk_buff *skb;
-
-	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
-		return -EOPNOTSUPP;
-
-	/* Retrieve the head sk_buff from the socket's receive queue. */
-	err = 0;
-	skb = skb_recv_datagram(&vsk->sk, flags, &err);
-	if (!skb)
-		return err;
-
-	dg = (struct vmci_datagram *)skb->data;
-	if (!dg)
-		/* err is 0, meaning we read zero bytes. */
-		goto out;
-
-	payload_len = dg->payload_size;
-	/* Ensure the sk_buff matches the payload size claimed in the packet. */
-	if (payload_len != skb->len - sizeof(*dg)) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	if (payload_len > len) {
-		payload_len = len;
-		msg->msg_flags |= MSG_TRUNC;
-	}
-
-	/* Place the datagram payload in the user's iovec. */
-	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
-	if (err)
-		goto out;
-
-	if (msg->msg_name) {
-		/* Provide the address of the sender. */
-		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
-		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
-		msg->msg_namelen = sizeof(*vm_addr);
-	}
-	err = payload_len;
-
-out:
-	skb_free_datagram(&vsk->sk, skb);
-	return err;
-}
-
 static bool vmci_transport_dgram_allow(u32 cid, u32 port)
 {
 	if (cid == VMADDR_CID_HYPERVISOR) {
@@ -2040,7 +1992,6 @@ static struct vsock_transport vmci_transport = {
 	.release = vmci_transport_release,
 	.connect = vmci_transport_connect,
 	.dgram_bind = vmci_transport_dgram_bind,
-	.dgram_dequeue = vmci_transport_dgram_dequeue,
 	.dgram_enqueue = vmci_transport_dgram_enqueue,
 	.dgram_allow = vmci_transport_dgram_allow,
 	.stream_dequeue = vmci_transport_stream_dequeue,
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6dea6119f5b2..11488887a5cc 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -66,7 +66,6 @@ static struct virtio_transport loopback_transport = {
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
 		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
-- 
2.20.1


