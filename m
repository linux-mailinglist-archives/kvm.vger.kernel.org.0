Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1266758A2E
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjGSAuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjGSAuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:50:13 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7355EE53
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:11 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-7673180224bso430066585a.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727810; x=1692319810;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=auk1noj/dkSN4CfNptro90m4Q3cm8nzxOnwzfPqqvIE=;
        b=H1zk3nuxyg/iVPscQ6kvOHZcLVvkmvByvhNGPcnnERpQDW3ulY0pxVN0ZrXu5S3b+2
         j1JCBzzh5vpMURhvkS/g3fjwoaBGSvo1kv3JFrA+1w8OeG5NaX7U5Mram0Hte8iITWx8
         t4ke42nGYb8fmflcJiDjmlgqu+r8XSCY3RtBdcNu4+CT4qG/X6aQB6h00ukR+7umTW/A
         RKkvlG1FsrBaO1iCCiUwxtLU8iapKgCKpI32fG01l3zeheqMbUe2FpxR7Xjq1fA1aQFi
         fhxVMATVH5sw+07Fapx85cmMsEbbhOL/upeEoRiw2yI+NKhw9RCX0KK2gz5qy2YoaLPR
         W3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727810; x=1692319810;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=auk1noj/dkSN4CfNptro90m4Q3cm8nzxOnwzfPqqvIE=;
        b=EzU9OVDEPmfnY5mcMVgoH/dj/kXN31JF9Z1AXHsPyXd2GvqIy5ZpbB41Q35u4iVqhG
         Nt96rGMOsTCKkyTtNlxp86B9okyD+drufwfX1GlmajfBas9dZUsvqVWayDcwQ2+txsnX
         UhnhQYqXNxPtAPsgJGGzpRPBMV0rNaZJXoJkAWxkWxEQ4jjEEL9HhEA0pOg2NGeZgHfH
         pOwXeaO+V8ZQk9lv2C8iPgyXacQTmJQFmyuR9K9dcAohZdVuhbfpG421W1j8wVQpBRKc
         TztTkOSFjDQRBDzfWX62V4FhsS8WqzqQPexycPya1wZh3wXc0hhlQ8TYJ95iEAfW8RG2
         idTw==
X-Gm-Message-State: ABy/qLYRU7iSPUdonqHl6FOQTykIdQRhRH6MlBgbIGT+or0uLO/kBgLP
        vhUsw0Nf5WOedRk56DT+UVPQjg==
X-Google-Smtp-Source: APBJJlE/N3/xT428vroCbSEqkP8WcWmHk1TPcEMDqzyK/6PmsEn2VrCCTZ4+LbzbxaOLWjQTvYJyzA==
X-Received: by 2002:a05:620a:2848:b0:767:fbdc:5d49 with SMTP id h8-20020a05620a284800b00767fbdc5d49mr1327208qkp.70.1689727810255;
        Tue, 18 Jul 2023 17:50:10 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:09 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 19 Jul 2023 00:50:05 +0000
Subject: [PATCH RFC net-next v5 01/14] af_vsock: generalize
 vsock_dgram_recvmsg() to all transports
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v5-1-581bd37fdb26@bytedance.com>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit drops the transport->dgram_dequeue callback and makes
vsock_dgram_recvmsg() generic to all transports.

To make this possible, two transport-level changes are introduced:
- implementation of the ->dgram_addr_init() callback to initialize
  the sockaddr_vm structure with data from incoming socket buffers.
- transport implementations set the skb->data pointer to the beginning
  of the payload prior to adding the skb to the socket's receive queue.
  That is, they must use skb_pull() before enqueuing. This is an
  agreement between the transport and the socket layer that skb->data
  always points to the beginning of the payload (and not, for example,
  the packet header).

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  1 -
 include/linux/virtio_vsock.h            |  5 ---
 include/net/af_vsock.h                  |  3 +-
 net/vmw_vsock/af_vsock.c                | 40 ++++++++++++++++++++++-
 net/vmw_vsock/hyperv_transport.c        |  7 ----
 net/vmw_vsock/virtio_transport.c        |  1 -
 net/vmw_vsock/virtio_transport_common.c |  9 -----
 net/vmw_vsock/vmci_transport.c          | 58 ++++++---------------------------
 net/vmw_vsock/vsock_loopback.c          |  1 -
 9 files changed, 50 insertions(+), 75 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6578db78f0ae..ae8891598a48 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c58453699ee9..18cbe8d37fca 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -167,11 +167,6 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
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
index 0e7504a42925..305d57502e89 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -120,11 +120,10 @@ struct vsock_transport {
 
 	/* DGRAM. */
 	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
-	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
-			     size_t len, int flags);
 	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
 			     struct msghdr *, size_t len);
 	bool (*dgram_allow)(u32 cid, u32 port);
+	void (*dgram_addr_init)(struct sk_buff *skb, struct sockaddr_vm *addr);
 
 	/* STREAM. */
 	/* TODO: stream_bind() */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index deb72a8c44a7..ad71e084bf2f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1272,11 +1272,15 @@ static int vsock_dgram_connect(struct socket *sock,
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags)
 {
+	const struct vsock_transport *transport;
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
@@ -1287,7 +1291,41 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		return prot->recvmsg(sk, msg, len, flags, NULL);
 #endif
 
-	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
+	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
+		return -EOPNOTSUPP;
+
+	transport = vsk->transport;
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
+		transport->dgram_addr_init(skb, vm_addr);
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
index 7cb1a9d2cdb4..7f1ea434656d 100644
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
index e95df847176b..66edffdbf303 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -429,7 +429,6 @@ static struct virtio_transport virtio_transport = {
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
 		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..01ea1402ad40 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -583,15 +583,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
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
index b370070194fa..0bbbdb222245 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -641,6 +641,7 @@ static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
 	sock_hold(sk);
 	skb_put(skb, size);
 	memcpy(skb->data, dg, size);
+	skb_pull(skb, VMCI_DG_HEADERSIZE);
 	sk_receive_skb(sk, skb, 0);
 
 	return VMCI_SUCCESS;
@@ -1731,57 +1732,18 @@ static int vmci_transport_dgram_enqueue(
 	return err - sizeof(*dg);
 }
 
-static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
-					struct msghdr *msg, size_t len,
-					int flags)
+static void vmci_transport_dgram_addr_init(struct sk_buff *skb,
+					   struct sockaddr_vm *addr)
 {
-	int err;
 	struct vmci_datagram *dg;
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
+	unsigned int cid, port;
 
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
+	WARN_ONCE(skb->head == skb->data, "vmci vsock bug: bad dgram skb");
 
-out:
-	skb_free_datagram(&vsk->sk, skb);
-	return err;
+	dg = (struct vmci_datagram *)skb->head;
+	cid = dg->src.context;
+	port = dg->src.resource;
+	vsock_addr_init(addr, cid, port);
 }
 
 static bool vmci_transport_dgram_allow(u32 cid, u32 port)
@@ -2040,9 +2002,9 @@ static struct vsock_transport vmci_transport = {
 	.release = vmci_transport_release,
 	.connect = vmci_transport_connect,
 	.dgram_bind = vmci_transport_dgram_bind,
-	.dgram_dequeue = vmci_transport_dgram_dequeue,
 	.dgram_enqueue = vmci_transport_dgram_enqueue,
 	.dgram_allow = vmci_transport_dgram_allow,
+	.dgram_addr_init = vmci_transport_dgram_addr_init,
 	.stream_dequeue = vmci_transport_stream_dequeue,
 	.stream_enqueue = vmci_transport_stream_enqueue,
 	.stream_has_data = vmci_transport_stream_has_data,
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 5c6360df1f31..2a59dd177c74 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -62,7 +62,6 @@ static struct virtio_transport loopback_transport = {
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
 		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 

-- 
2.30.2

