Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A4717294
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjEaAgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 20:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbjEaAgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 20:36:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08D2F3
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 17:35:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d2a613ec4so3773523b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 17:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685493312; x=1688085312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bin9aaX650fxHCt543M9gpvPPhCX2bzjhyAEjcf0baQ=;
        b=At1lQ4S6kiQ8pmVR+cX/dsPlho071ErmGgyQCsbH5QF6G8gq+Jfz/9U9x8Ay3w3WbK
         BH8XaM0YUMYmzKtR6jj7d1+JJTpnJRcXwCYRNGJXaCIWR7m+SjFsy/xOBcPd1iGUV4HT
         JWB0xQpqDwStRaBnu8UpRmQlO4pRVTjPFc62qSTu7E/KkwSlnau+LshW4gG1A3D0ItNp
         zoOyiygrdUGSr7HlD81uzyxZSHQnIM2/M9yMN4fLUXxuRqvMuGsTfhQG32zAxMokEMDh
         jlnh49egIXFqsNA6wTaxFl93aKmTe0/B9xQwr5Gejc5eO4NgY3DxPM66z5fKSgLPGP20
         LTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493312; x=1688085312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bin9aaX650fxHCt543M9gpvPPhCX2bzjhyAEjcf0baQ=;
        b=hJ3fi/mRiBfy9GK6aBJqWZThZHsA/YQPENc1COCr9vFKxdjbJfrrpv5ZgJrXBve18O
         Z+9LMYUJO1IwD4Gy4Rn23nsTn6IqgGq1x8APJcVJB9337wiCv9OCqqEBwL3pflCXX0/u
         Jbmynl4cwwt+Hvy2UE1R/A7rTjazyarZT93NwNfWZ6faPoBZsjKDkZCd+9kK/cYSUWJ4
         7bDvS+N4o3WvKzuJ0EZbIsMg58WpWFxe/IV2onwRphbG/uCoWh9nh6E4UstEqPrKNyd4
         gIkurle2QlJO0aEaqHEZMYstaCipV5D3pNwGfcM2oVp6cYrDCE5B3++Rov84cUCoxJFr
         3UUA==
X-Gm-Message-State: AC+VfDzaugEY1pALOSdeyw86XzPXTT0xHYeNEHAe5iGTQQUOz6TZWHiX
        ABcnnmpKs7E75pfF4t7JhCxKig==
X-Google-Smtp-Source: ACHHUZ5pgMp+bbpmHPeCyGTaOInIRFl4aGNVvfZOcbpQyhdKuR3LZIMhxof1ihaEoV74IVdir+G9Fw==
X-Received: by 2002:a05:6a00:2d1f:b0:63d:4752:4da3 with SMTP id fa31-20020a056a002d1f00b0063d47524da3mr4638994pfb.25.1685493311969;
        Tue, 30 May 2023 17:35:11 -0700 (PDT)
Received: from [172.17.0.2] (c-67-170-131-147.hsd1.wa.comcast.net. [67.170.131.147])
        by smtp.gmail.com with ESMTPSA id j12-20020a62b60c000000b0064cb0845c77sm2151340pff.122.2023.05.30.17.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 17:35:11 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 31 May 2023 00:35:07 +0000
Subject: [PATCH RFC net-next v3 3/8] vsock: support multi-transport
 datagrams
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v3-3-c2414413ef6a@bytedance.com>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for multi-transport datagrams.

This includes:
- Per-packet lookup of transports when using sendto(sockaddr_vm)
- Selecting H2G or G2H transport using VMADDR_FLAG_TO_HOST and CID in
  sockaddr_vm

To preserve backwards compatibility with VMCI, some important changes
were made. The "transport_dgram" / VSOCK_TRANSPORT_F_DGRAM is changed to
be used for all dgrams if it has been registered / is non-NULL.
Otherwise, the normal h2g/g2h transports are used. It makes more
intuitive sense to eliminate transport_dgram and simply use
transport_{h2g,g2h} since there is nothing preventing any of these
transports from support datagrams. But "transport_dgram" had
to be retained to prevent breaking VMCI:

1) VMCI datagrams appear to function outside of the h2g/g2h
   paradigm. When the vmci transport becomes online, it registers itself
   with the DGRAM feature, but not H2G/G2H. Only later when the
   transport has more information about its environment does it register
   H2G or G2H. In the case that a datagram socket becomes active
   after DGRAM registration but before G2H/H2G registration, the
   "transport_dgram" transport needs to be used.

2) VMCI seems to require special message be sent by the transport when a
   datagram socket calls bind(). Under the h2g/g2h model, the transport
   is selected using the remote_addr which is set by connect(). At
   bind time there is no remote_addr because often no connect() has been
   called yet: the transport is null. Therefore, with a null transport
   there doesn't seem to be any good way for a datagram socket a tell the
   VMCI transport that it has just had bind() called upon it.

Therefore, to preserve backwards compatibility, his patch follows this
rule: if transport_dgram exists, all datagram socket traffic must use
it. Otherwise, use the normal logic to determine whether or not to use
H2G or G2H.

In the case of other transports like virtio, they may simply only
register H2G or G2H to a transport (but not DGRAM!) to support multi-transport and
nesting.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  1 -
 include/linux/virtio_vsock.h            |  2 -
 net/vmw_vsock/af_vsock.c                | 75 +++++++++++++++++++++++++--------
 net/vmw_vsock/hyperv_transport.c        |  6 ---
 net/vmw_vsock/virtio_transport.c        |  1 -
 net/vmw_vsock/virtio_transport_common.c |  7 ---
 net/vmw_vsock/vsock_loopback.c          |  1 -
 7 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c8201c070b4b..8f0082da5e70 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_allow              = virtio_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
 		.dgram_get_port		  = virtio_transport_dgram_get_port,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 23521a318cf0..73afa09f4585 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -216,8 +216,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
 bool virtio_transport_stream_allow(u32 cid, u32 port);
-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
-				struct sockaddr_vm *addr);
 bool virtio_transport_dgram_allow(u32 cid, u32 port);
 int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
 int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 67dd9d78272d..578272a987be 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -438,6 +438,15 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
 	return transport;
 }
 
+static const struct vsock_transport *
+vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
+{
+	if (transport_dgram)
+		return transport_dgram;
+
+	return vsock_connectible_lookup_transport(cid, flags);
+}
+
 /* Assign a transport to a socket and call the .init transport callback.
  *
  * Note: for connection oriented socket this must be called when vsk->remote_addr
@@ -474,7 +483,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
-		new_transport = transport_dgram;
+		new_transport = vsock_dgram_lookup_transport(remote_cid,
+							     remote_flags);
 		break;
 	case SOCK_STREAM:
 	case SOCK_SEQPACKET:
@@ -691,6 +701,9 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 			      struct sockaddr_vm *addr)
 {
+	if (!vsk->transport || !vsk->transport->dgram_bind)
+		return -EINVAL;
+
 	return vsk->transport->dgram_bind(vsk, addr);
 }
 
@@ -1172,19 +1185,24 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
-	transport = vsk->transport;
-
-	err = vsock_auto_bind(vsk);
-	if (err)
-		goto out;
-
-
 	/* If the provided message contains an address, use that.  Otherwise
 	 * fall back on the socket's remote handle (if it has been connected).
 	 */
 	if (msg->msg_name &&
 	    vsock_addr_cast(msg->msg_name, msg->msg_namelen,
 			    &remote_addr) == 0) {
+		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
+							 remote_addr->svm_flags);
+		if (!transport) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (!try_module_get(transport->module)) {
+			err = -ENODEV;
+			goto out;
+		}
+
 		/* Ensure this address is of the right type and is a valid
 		 * destination.
 		 */
@@ -1193,11 +1211,27 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			remote_addr->svm_cid = transport->get_local_cid();
 
 		if (!vsock_addr_bound(remote_addr)) {
+			module_put(transport->module);
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (!transport->dgram_allow(remote_addr->svm_cid,
+					    remote_addr->svm_port)) {
+			module_put(transport->module);
 			err = -EINVAL;
 			goto out;
 		}
+
+		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+		module_put(transport->module);
 	} else if (sock->state == SS_CONNECTED) {
 		remote_addr = &vsk->remote_addr;
+		transport = vsk->transport;
+
+		err = vsock_auto_bind(vsk);
+		if (err)
+			goto out;
 
 		if (remote_addr->svm_cid == VMADDR_CID_ANY)
 			remote_addr->svm_cid = transport->get_local_cid();
@@ -1205,23 +1239,23 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		/* XXX Should connect() or this function ensure remote_addr is
 		 * bound?
 		 */
-		if (!vsock_addr_bound(&vsk->remote_addr)) {
+		if (!vsock_addr_bound(remote_addr)) {
 			err = -EINVAL;
 			goto out;
 		}
-	} else {
-		err = -EINVAL;
-		goto out;
-	}
 
-	if (!transport->dgram_allow(remote_addr->svm_cid,
-				    remote_addr->svm_port)) {
+		if (!transport->dgram_allow(remote_addr->svm_cid,
+					    remote_addr->svm_port)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
+	} else {
 		err = -EINVAL;
 		goto out;
 	}
 
-	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
-
 out:
 	release_sock(sk);
 	return err;
@@ -1255,13 +1289,18 @@ static int vsock_dgram_connect(struct socket *sock,
 	if (err)
 		goto out;
 
+	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
+
+	err = vsock_assign_transport(vsk, NULL);
+	if (err)
+		goto out;
+
 	if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
 					 remote_addr->svm_port)) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
 	sock->state = SS_CONNECTED;
 
 	/* sock map disallows redirection of non-TCP sockets with sk_state !=
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index ff6e87e25fa0..c00bc5da769a 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -551,11 +551,6 @@ static void hvs_destruct(struct vsock_sock *vsk)
 	kfree(hvs);
 }
 
-static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
 {
 	return -EOPNOTSUPP;
@@ -841,7 +836,6 @@ static struct vsock_transport hvs_transport = {
 	.connect                  = hvs_connect,
 	.shutdown                 = hvs_shutdown,
 
-	.dgram_bind               = hvs_dgram_bind,
 	.dgram_get_cid		  = hvs_dgram_get_cid,
 	.dgram_get_port		  = hvs_dgram_get_port,
 	.dgram_get_length	  = hvs_dgram_get_length,
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 5763cdf13804..1b7843a7779a 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -428,7 +428,6 @@ static struct virtio_transport virtio_transport = {
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index abd939694a1a..5e9bccb21869 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -790,13 +790,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 
-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
-				struct sockaddr_vm *addr)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
-
 int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
 {
 	return -EOPNOTSUPP;
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 136061f622b8..7b0a5030e555 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -62,7 +62,6 @@ static struct virtio_transport loopback_transport = {
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,

-- 
2.30.2

