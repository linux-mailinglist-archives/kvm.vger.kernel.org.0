Return-Path: <kvm+bounces-21348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FA492DAC6
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07FD11F235BE
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49C01527AC;
	Wed, 10 Jul 2024 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hSy21nOG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8373413C3D5;
	Wed, 10 Jul 2024 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646761; cv=none; b=SQ9MhAQUfFktVbawjNalNI14YI6qaDduHp9a2dST+Sc1IgznHLvHohBVnqcMZIwbqz8LAxqkCq05hizeZV4Ytdr8NMpCBf0G+5uXtR0z66k5FNfWXCqavoWV4DQdGS34pWBlVTA0+jdduTepuVFjPmrmA8dJqamw3mhxBL2RL5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646761; c=relaxed/simple;
	bh=D7bU0xTCYCxoEESWH79unr00SoYxZC59BgSUj/2UI3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oTJo6ZGK2e2lYdwqKAV/GaUQctNbZN/9zo+u9CkmcG6Vc7y96IwK3waVMjnLo0/OH6FVsPMfxMYUONUUkY+wbOhNTM4hCy6ubKFl2Ey9bIZQD8cZmA2Xc2doeCqRDB/vgdg2mMeZ6k0JZoLhudKO1wIlSVTALyh3VPzxmjoivGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hSy21nOG; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3d93147ac6bso143967b6e.0;
        Wed, 10 Jul 2024 14:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646758; x=1721251558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkNP9Z6IAyHZ8EAIT6XWxpNToC+wJe3BhT7w/VKuCP0=;
        b=hSy21nOGEXJ+ChsCwn+Bw49UxDS11KqQPvT2Ejes8IOtNkt1FJ7ll4Ui6/bTaWXeX1
         awVsRZp3VM5WXj7Y4CuEbuMseQmSam3z77XuB0DZJvrPDGelzj66qS3OO5fhx9DznXe+
         KPN0Prq7TMbGku9/Wiq14p7k2MXWhQIchMXjTqcqaMLQqYv8DbnR/QmWpDi1zvq8bwd4
         z6u76FAaYQQ1LO8X81o5mrsV7b8FHAGZAdqym9ma1AkEWqq3ca1bCC2jmnNprD6Ik7Co
         UKB8zBXqbEivw6SgswEdSFufCK3sdPL4S0OVXIbbxLwoebvoyjApmABOpJsifqvs6dYp
         Knrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646758; x=1721251558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkNP9Z6IAyHZ8EAIT6XWxpNToC+wJe3BhT7w/VKuCP0=;
        b=ZyjVfk/Oz+EkSFuyCYqrX0S/GTh8ywwP96M+/O1I99ONxLp0fskppEpANF8DqwmAKb
         f4iD0mSGtU8NhM8/B8yAva230rVKt4B8srVkT3+VjhI4vPKPVpR2vO3xF94Xr42qo61H
         BCSM4KU4G5aePmd/Bd5uWmtVAHnoV6hjhnTiThMUE6aWsArX9gentdDCytfttLnXlrUI
         p3y4W8y4fb972YjPwBO17vbHHqra54ElMoPecDuRctX/lLdHHzq8Enq3s9SOpmanDwiD
         oskSYibGi2aiiGOiWPl9dUzlxJc/4yHWYxQJxVvXoT4gcr3EX97EEKs8PUtp6O5aRn/y
         ZkaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGTYkz+t7GNu/Ks/49HhSyOIKYsyfH8FRW7zkYh5GHEwt/I+UYzf2CRtsdsnyvNQWmLd5+GP5i1A/Mpw16vF6hl8Fsnnn1EgC7HjEPXMxT3jR+VVjo3Mz22H/rZ9G5aUJmU7hvBu+AhuHnSx5/nlcCab8U/zYtZ7UGI2Nplx5KMHWVLC5SyYiBxC3ydwL02UZlsKaJ+YzYLqVay0CSsyEzVBtMYAa+78alyyLG
X-Gm-Message-State: AOJu0Yzyi2u6vUGQ1B53UVe8GM1D9PWzkIwloSiphaNw+olLQSMBCQu4
	0CUM24F9bXUhJHtdRT6+T04kBcYJx6/ncxzGVTFtgexGjlVq+7h/W4ggAw==
X-Google-Smtp-Source: AGHT+IHyv86SB1wKRp+SssFKGtx5File1fFaZVPfEkTbDGohBQbmnEazU/6Dk0ydOGV62SNpzW5JIg==
X-Received: by 2002:a05:6808:bd4:b0:3d9:303a:fc6d with SMTP id 5614622812f47-3d93c08a1f4mr6990349b6e.41.1720646758332;
        Wed, 10 Jul 2024 14:25:58 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:25:57 -0700 (PDT)
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
Subject: [RFC PATCH net-next v6 03/14] af_vsock: support multi-transport datagrams
Date: Wed, 10 Jul 2024 21:25:44 +0000
Message-Id: <20240710212555.1617795-4-amery.hung@bytedance.com>
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

This patch adds support for multi-transport datagrams.

This includes:
- Allow transport to be undecided (i.e., empty) for non-VMCI datagram
  use cases during socket creation.
- connect() now assigns the transport for (similar to connectible
  sockets)
- Per-packet lookup of transports when using sendto(sockaddr_vm)
- Selecting H2G or G2H transport using VMADDR_FLAG_TO_HOST and CID in
  sockaddr_vm
- Rename VSOCK_TRANSPORT_F_DGRAM to VSOCK_TRANSPORT_F_DGRAM_FALLBACK

* Dynamic transport lookup *

virtio datagram will follow h2g/g2h paradigm. Since it is impossible
to know which transport to use during socket creation, the transport is
allowed to remain empty. The transport will be assigned only when
connect() is called. Otherwise, in the sendmsg() path, if sendto() is
used, the cid is used to lookup the transport that will be used. In the
recvmsg() path, since the receiving method is generalized and shared by
different transport, there is now no need to resolve the transport.
Finally, a couple of checks for empty transport are added in other paths
to prevent null-pointer dereference.

* Compatibiliity with VMCI *

To preserve backwards compatibility with VMCI, some important changes
are made. The "transport_dgram" / VSOCK_TRANSPORT_F_DGRAM is changed to
be used for dgrams only if there is not yet a g2h or h2g transport that
has been registered that can transmit the packet. If there is a g2h/h2g
transport for that remote address, then that transport will be used and
not "transport_dgram". This essentially makes "transport_dgram" a
fallback transport for when h2g/g2h has not yet gone online, and so it
is renamed "transport_dgram_fallback". VMCI implements this transport.

The logic around "transport_dgram" needs to be retained to prevent
breaking VMCI:

1) VMCI datagrams existed prior to h2g/g2h and so operate under a
   different paradigm. When the vmci transport comes online, it registers
   itself with the DGRAM feature, but not H2G/G2H. Only later when the
   transport has more information about its environment does it register
   H2G or G2H.  In the case that a datagram socket is created after
   VSOCK_TRANSPORT_F_DGRAM registration but before G2H/H2G registration,
   the "transport_dgram" transport is the only registered transport and so
   needs to be used.

2) VMCI seems to require a special message be sent by the transport when a
   datagram socket calls bind(). Under the h2g/g2h model, the transport
   is selected using the remote_addr which is set by connect(). At
   bind time there is no remote_addr because often no connect() has been
   called yet: the transport is null. Therefore, with a null transport
   there doesn't seem to be any good way for a datagram socket to tell the
   VMCI transport that it has just had bind() called upon it.

With the new fallback logic, after H2G/G2H comes online the socket layer
will access the VMCI transport via transport_{h2g,g2h}. Prior to H2G/G2H
coming online, the socket layer will access the VMCI transport via
"transport_dgram_fallback".

Only transports with a special datagram fallback use-case such as VMCI
need to register VSOCK_TRANSPORT_F_DGRAM_FALLBACK.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 drivers/vhost/vsock.c                   |   1 -
 include/linux/virtio_vsock.h            |   2 -
 include/net/af_vsock.h                  |  10 +-
 net/vmw_vsock/af_vsock.c                | 127 +++++++++++++++++++-----
 net/vmw_vsock/hyperv_transport.c        |   6 --
 net/vmw_vsock/virtio_transport.c        |   1 -
 net/vmw_vsock/virtio_transport_common.c |   7 --
 net/vmw_vsock/vmci_transport.c          |   2 +-
 net/vmw_vsock/vsock_loopback.c          |   1 -
 9 files changed, 107 insertions(+), 50 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 97fffa914e66..fa1aefb78016 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -419,7 +419,6 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
 		.stream_enqueue           = virtio_transport_stream_enqueue,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 8b56b8a19ddd..f749a066af46 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -221,8 +221,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
 bool virtio_transport_stream_allow(u32 cid, u32 port);
-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
-				struct sockaddr_vm *addr);
 bool virtio_transport_dgram_allow(u32 cid, u32 port);
 
 int virtio_transport_connect(struct vsock_sock *vsk);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 7aa1f5f2b1a5..44db8f2c507d 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -96,13 +96,13 @@ struct vsock_transport_send_notify_data {
 
 /* Transport features flags */
 /* Transport provides host->guest communication */
-#define VSOCK_TRANSPORT_F_H2G		0x00000001
+#define VSOCK_TRANSPORT_F_H2G			0x00000001
 /* Transport provides guest->host communication */
-#define VSOCK_TRANSPORT_F_G2H		0x00000002
-/* Transport provides DGRAM communication */
-#define VSOCK_TRANSPORT_F_DGRAM		0x00000004
+#define VSOCK_TRANSPORT_F_G2H			0x00000002
+/* Transport provides fallback for DGRAM communication */
+#define VSOCK_TRANSPORT_F_DGRAM_FALLBACK	0x00000004
 /* Transport provides local (loopback) communication */
-#define VSOCK_TRANSPORT_F_LOCAL		0x00000008
+#define VSOCK_TRANSPORT_F_LOCAL			0x00000008
 
 struct vsock_transport {
 	struct module *module;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 98d10cd30483..acc15e11700c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -140,8 +140,8 @@ struct proto vsock_proto = {
 static const struct vsock_transport *transport_h2g;
 /* Transport used for guest->host communication */
 static const struct vsock_transport *transport_g2h;
-/* Transport used for DGRAM communication */
-static const struct vsock_transport *transport_dgram;
+/* Transport used as a fallback for DGRAM communication */
+static const struct vsock_transport *transport_dgram_fallback;
 /* Transport used for local communication */
 static const struct vsock_transport *transport_local;
 static DEFINE_MUTEX(vsock_register_mutex);
@@ -440,19 +440,20 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
 	return transport;
 }
 
-/* Assign a transport to a socket and call the .init transport callback.
- *
- * Note: for connection oriented socket this must be called when vsk->remote_addr
- * is set (e.g. during the connect() or when a connection request on a listener
- * socket is received).
- * The vsk->remote_addr is used to decide which transport to use:
- *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
- *    g2h is not loaded, will use local transport;
- *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
- *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
- */
-int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
+static const struct vsock_transport *
+vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
+{
+	const struct vsock_transport *transport;
+
+	transport = vsock_connectible_lookup_transport(cid, flags);
+	if (transport)
+		return transport;
+
+	return transport_dgram_fallback;
+}
+
+static int __vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk,
+				    bool create_sock)
 {
 	const struct vsock_transport *new_transport;
 	struct sock *sk = sk_vsock(vsk);
@@ -476,7 +477,21 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
-		new_transport = transport_dgram;
+		/* During vsock_create(), the transport cannot be decided yet if
+		 * using virtio. While for VMCI, it is transport_dgram_fallback.
+		 * Therefore, we try to initialize it to transport_dgram_fallback
+		 * so that we don't break VMCI. If VMCI is not present, it is okay
+		 * to leave the transport empty since vsk->transport != NULL checks
+		 * will be performed in send and receive paths.
+		 *
+		 * During vsock_dgram_connect(), since remote_cid is available,
+		 * the right transport is assigned after lookup.
+		 */
+		if (create_sock)
+			new_transport = transport_dgram_fallback;
+		else
+			new_transport = vsock_dgram_lookup_transport(remote_cid,
+								     remote_flags);
 		break;
 	case SOCK_STREAM:
 	case SOCK_SEQPACKET:
@@ -501,6 +516,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		vsock_deassign_transport(vsk);
 	}
 
+	/* Only allow empty transport during vsock_create() for datagram */
+	if (!new_transport && sk->sk_type == SOCK_DGRAM && create_sock)
+		return 0;
+
 	/* We increase the module refcnt to prevent the transport unloading
 	 * while there are open sockets assigned to it.
 	 */
@@ -525,6 +544,23 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 
 	return 0;
 }
+
+/* Assign a transport to a socket and call the .init transport callback.
+ *
+ * Note: for connection oriented socket this must be called when vsk->remote_addr
+ * is set (e.g. during the connect() or when a connection request on a listener
+ * socket is received).
+ * The vsk->remote_addr is used to decide which transport to use:
+ *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
+ *    g2h is not loaded, will use local transport;
+ *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
+ *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
+ *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
+ */
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
+{
+	return __vsock_assign_transport(vsk, psk, false);
+}
 EXPORT_SYMBOL_GPL(vsock_assign_transport);
 
 bool vsock_find_cid(unsigned int cid)
@@ -693,6 +729,9 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 			      struct sockaddr_vm *addr)
 {
+	if (!vsk->transport || !vsk->transport->dgram_bind)
+		return -EINVAL;
+
 	return vsk->transport->dgram_bind(vsk, addr);
 }
 
@@ -825,6 +864,9 @@ static void __vsock_release(struct sock *sk, int level)
 			vsk->transport->release(vsk);
 		else if (sock_type_connectible(sk->sk_type))
 			vsock_remove_sock(vsk);
+		else if (sk->sk_type == SOCK_DGRAM &&
+			 (!vsk->transport || !vsk->transport->dgram_bind))
+			vsock_remove_sock(vsk);
 
 		sock_orphan(sk);
 		sk->sk_shutdown = SHUTDOWN_MASK;
@@ -1152,6 +1194,9 @@ static int vsock_read_skb(struct sock *sk, skb_read_actor_t read_actor)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
+	if (!vsk->transport)
+		return -EINVAL;
+
 	return vsk->transport->read_skb(vsk, read_actor);
 }
 
@@ -1163,6 +1208,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct vsock_sock *vsk;
 	struct sockaddr_vm *remote_addr;
 	const struct vsock_transport *transport;
+	bool module_got = false;
 
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
@@ -1174,19 +1220,40 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
-	transport = vsk->transport;
-
 	err = vsock_auto_bind(vsk);
 	if (err)
 		goto out;
 
-
 	/* If the provided message contains an address, use that.  Otherwise
 	 * fall back on the socket's remote handle (if it has been connected).
 	 */
 	if (msg->msg_name &&
 	    vsock_addr_cast(msg->msg_name, msg->msg_namelen,
 			    &remote_addr) == 0) {
+		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
+							 remote_addr->svm_flags);
+		/* transport_dgram_fallback needs to be initialized to be called */
+		if (transport == transport_dgram_fallback && transport != vsk->transport) {
+			err = -EINVAL;
+			goto out;
+		}
+
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
+		/* When looking up a transport dynamically and acquiring a
+		 * reference on the module, we need to remember to release the
+		 * reference later.
+		 */
+		module_got = true;
+
 		/* Ensure this address is of the right type and is a valid
 		 * destination.
 		 */
@@ -1201,6 +1268,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	} else if (sock->state == SS_CONNECTED) {
 		remote_addr = &vsk->remote_addr;
 
+		transport = vsk->transport;
 		if (remote_addr->svm_cid == VMADDR_CID_ANY)
 			remote_addr->svm_cid = transport->get_local_cid();
 
@@ -1225,6 +1293,8 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
 
 out:
+	if (module_got)
+		module_put(transport->module);
 	release_sock(sk);
 	return err;
 }
@@ -1257,13 +1327,18 @@ static int vsock_dgram_connect(struct socket *sock,
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
@@ -2406,7 +2481,7 @@ static int vsock_create(struct net *net, struct socket *sock,
 	vsk = vsock_sk(sk);
 
 	if (sock->type == SOCK_DGRAM) {
-		ret = vsock_assign_transport(vsk, NULL);
+		ret = __vsock_assign_transport(vsk, NULL, true);
 		if (ret < 0) {
 			sock_put(sk);
 			return ret;
@@ -2548,7 +2623,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 
 	t_h2g = transport_h2g;
 	t_g2h = transport_g2h;
-	t_dgram = transport_dgram;
+	t_dgram = transport_dgram_fallback;
 	t_local = transport_local;
 
 	if (features & VSOCK_TRANSPORT_F_H2G) {
@@ -2567,7 +2642,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 		t_g2h = t;
 	}
 
-	if (features & VSOCK_TRANSPORT_F_DGRAM) {
+	if (features & VSOCK_TRANSPORT_F_DGRAM_FALLBACK) {
 		if (t_dgram) {
 			err = -EBUSY;
 			goto err_busy;
@@ -2585,7 +2660,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 
 	transport_h2g = t_h2g;
 	transport_g2h = t_g2h;
-	transport_dgram = t_dgram;
+	transport_dgram_fallback = t_dgram;
 	transport_local = t_local;
 
 err_busy:
@@ -2604,8 +2679,8 @@ void vsock_core_unregister(const struct vsock_transport *t)
 	if (transport_g2h == t)
 		transport_g2h = NULL;
 
-	if (transport_dgram == t)
-		transport_dgram = NULL;
+	if (transport_dgram_fallback == t)
+		transport_dgram_fallback = NULL;
 
 	if (transport_local == t)
 		transport_local = NULL;
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 326dd41ee2d5..64ad87a3879c 100644
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
 static int hvs_dgram_enqueue(struct vsock_sock *vsk,
 			     struct sockaddr_vm *remote, struct msghdr *msg,
 			     size_t dgram_len)
@@ -826,7 +821,6 @@ static struct vsock_transport hvs_transport = {
 	.connect                  = hvs_connect,
 	.shutdown                 = hvs_shutdown,
 
-	.dgram_bind               = hvs_dgram_bind,
 	.dgram_enqueue            = hvs_dgram_enqueue,
 	.dgram_allow              = hvs_dgram_allow,
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index a8c97e95622a..4891b845fcde 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -507,7 +507,6 @@ static struct virtio_transport virtio_transport = {
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 4bf73d20c12a..a1c76836d798 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1008,13 +1008,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 
-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
-				struct sockaddr_vm *addr)
-{
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
-
 bool virtio_transport_dgram_allow(u32 cid, u32 port)
 {
 	return false;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b39df3ed8c8d..49aba9c48415 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2061,7 +2061,7 @@ static int __init vmci_transport_init(void)
 	/* Register only with dgram feature, other features (H2G, G2H) will be
 	 * registered when the first host or guest becomes active.
 	 */
-	err = vsock_core_register(&vmci_transport, VSOCK_TRANSPORT_F_DGRAM);
+	err = vsock_core_register(&vmci_transport, VSOCK_TRANSPORT_F_DGRAM_FALLBACK);
 	if (err < 0)
 		goto err_unsubscribe;
 
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 11488887a5cc..4dd4886f29d1 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -65,7 +65,6 @@ static struct virtio_transport loopback_transport = {
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
-		.dgram_bind               = virtio_transport_dgram_bind,
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
 
-- 
2.20.1


