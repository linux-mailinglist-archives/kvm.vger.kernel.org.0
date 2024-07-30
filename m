Return-Path: <kvm+bounces-22697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B6D9420DE
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6F121F21990
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D4118DF8D;
	Tue, 30 Jul 2024 19:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLvgud9X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CD618C93D;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368604; cv=none; b=nJiYEEvq8ORUwIJSVOuYbqRIfc5dqPooaJh4KGFjEeGoD7CpCo+4OEZ0i9QRvzddVOPnC01G6PIbkQbjek+MiPRHnbYc5aU2JG+naMQOTNlenT94GP9VRBwFX1dcDmT4Y64c/oA09pgzG8z8xT+fIUKNgqUfkExSH11EMPcDoY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368604; c=relaxed/simple;
	bh=2oMqxCijArVpVFEZmIIabQFSTOLGEfB8i/8bIevjDUI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oDLmngBtsReajB3AMlgtysLli9D73yzRk0v5Mc99lTm2Z+bxlBbBMuzrUDrRJABGPTYaRx2Mx2HNetBLUFLZleN+/kgaUZdWAy38ZPVM+q5nlLgvJeQhiLSWZdASrL/dxn2ibsJOOIE8kiJ7rLNPdkpNPDQ+AjO2L5Qj2b8AH88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLvgud9X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0044AC4AF0B;
	Tue, 30 Jul 2024 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722368604;
	bh=2oMqxCijArVpVFEZmIIabQFSTOLGEfB8i/8bIevjDUI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nLvgud9XoJBQqXgsjpfsJHJgtoKB706LD3EHiJjVUIVXznBH6F5xAKblnIwPHaaU0
	 shFUS9/7NahcqVphrjCvCBHS/NDOYTHZsx19gyVjap25dJAuuzqRC7j4wfA7szxH1U
	 m1BZoenP+G6c5f/dlFRAFt3bYHNBxQu5/N2eTgoUE3QTDY+rFXhgtDtIYGcq9kCHK7
	 64aZraLt1lj43XSCZOmDRalEUMw4znVmDYy+/2Te4d8Ss3mElX6ZYDGFpG8luICcrk
	 qp0MDgVU/mUlUBnK/8PpYL/zb95x0mb8uzJlropydaod0g1YvhQB/KzXArj2NfaD8W
	 TxlqG5s3gbYgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB03C49EA1;
	Tue, 30 Jul 2024 19:43:23 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Tue, 30 Jul 2024 21:43:06 +0200
Subject: [PATCH net-next v4 1/3] vsock: add support for SIOCOUTQ ioctl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-ioctl-v4-1-16d89286a8f0@outlook.com>
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
In-Reply-To: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>, 
 Daan De Meyer <daan.j.demeyer@gmail.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722368602; l=3574;
 i=luigi.leonardi@outlook.com; s=20240730; h=from:subject:message-id;
 bh=tOduH9idPiKnZwf8CNAIhL2hOnk+kmfFKHFRY8F+vZM=;
 b=m6IeOxKV94c/A2Fvb6bE47RYUV0qqkJUbC8xQLVVj2UxvOD1NtURB/iR9TuFCMbiOxL7fnyUd
 rxD+/qqDzKOBKe+W8z66BNVsf8aAA6cmV7l69XNyXvxetEpaWaqJNIh
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=rejHGgcyJQFeByIJsRIz/gA6pOPZJ1I2fpxoFD/jris=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240730
 with auth_id=192
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Luigi Leonardi <luigi.leonardi@outlook.com>

Add support for ioctl(s) in AF_VSOCK.
The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
of unsent bytes in the socket. This information is transport-specific
and is delegated to them using a callback.

Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 include/net/af_vsock.h   |  3 +++
 net/vmw_vsock/af_vsock.c | 58 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 535701efc1e5..fc504d2da3d0 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -169,6 +169,9 @@ struct vsock_transport {
 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
 	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
 
+	/* SIOCOUTQ ioctl */
+	ssize_t (*unsent_bytes)(struct vsock_sock *vsk);
+
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4b040285aa78..58e639e82942 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -112,6 +112,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 #include <uapi/linux/vm_sockets.h>
+#include <uapi/asm-generic/ioctls.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -1292,6 +1293,57 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
+			  int __user *arg)
+{
+	struct sock *sk = sock->sk;
+	struct vsock_sock *vsk;
+	int ret;
+
+	vsk = vsock_sk(sk);
+
+	switch (cmd) {
+	case SIOCOUTQ: {
+		ssize_t n_bytes;
+
+		if (!vsk->transport || !vsk->transport->unsent_bytes) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
+			ret = -EINVAL;
+			break;
+		}
+
+		n_bytes = vsk->transport->unsent_bytes(vsk);
+		if (n_bytes < 0) {
+			ret = n_bytes;
+			break;
+		}
+
+		ret = put_user(n_bytes, arg);
+		break;
+	}
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
+static int vsock_ioctl(struct socket *sock, unsigned int cmd,
+		       unsigned long arg)
+{
+	int ret;
+
+	lock_sock(sock->sk);
+	ret = vsock_do_ioctl(sock, cmd, (int __user *)arg);
+	release_sock(sock->sk);
+
+	return ret;
+}
+
 static const struct proto_ops vsock_dgram_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
@@ -1302,7 +1354,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.accept = sock_no_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = vsock_shutdown,
 	.sendmsg = vsock_dgram_sendmsg,
@@ -2286,7 +2338,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,
@@ -2308,7 +2360,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,

-- 
2.45.2



