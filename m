Return-Path: <kvm+bounces-20548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD17B9180A0
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E00821C23FCD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 12:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FED183075;
	Wed, 26 Jun 2024 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rNLpN/yE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF8B180A82;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719403719; cv=none; b=SmqtM8Qwhflw3RNSbhu0uUwr51CI5PZw1ptWs2tW06m6m2VvNHh9k1HBi6J7w7FuC/anbTCyLHyLXggZkVpifDLX7ViI+sZXm5sPbNMqSQ/amSWyQRKXQu7Qwj+V8SFac/AmnuMf92EUOjeMBQ2Q2/UYP5Xr/4liahydJK4Qkno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719403719; c=relaxed/simple;
	bh=qD7jIQQ4itVO4dok3fB085+FrXBK4cMHYpxJPo2hQd8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=teD70iucOlmX9ROaGC7Vx6+qAq8VtTu5L0/tJGJ+Tw0OO/nO1E4MQSzbJSowVLTK8rsFHSvJeJHiKWcYGnoD2l9P2NEtvBlBuyyTPLT5shLkr4oKc9uf8CiKa4g409fKWCDY5EqYgct+w4sOEH3aRaiwXqhH9VdOgTjwc+h5qcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rNLpN/yE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C66DAC32786;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719403718;
	bh=qD7jIQQ4itVO4dok3fB085+FrXBK4cMHYpxJPo2hQd8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rNLpN/yEtlu53qofoH897wkrp6fACHn8m2oofvoTkjqahspTTA0sNDfUruFpSvdnf
	 YfQRiFnGqVnjZCuMuBbgmTMFkvCGfzndqllL1+KDwQuPaulVarxb3SBRaggYIw1JKa
	 O+1FfLCpgI3qHRn7ykxJ1o5MrWGmqaTpGuuTZiUI64Ze8gmrSABFjOtCIrXDsuuz6y
	 LVjkcfQnjuFlF/AYW2je7hBPYc3OgIb14MmQbGhGFKXNlhCs6aN0prdi1Y1I/0pixh
	 6uQkXuIVrmDvg+ywSWCAX/jhx12LtT1qCTVTDnCLgOo/SJvwq0vhaDtJAzWyaaa3g8
	 Z8+mVd6J1qa0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2584C27C4F;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Wed, 26 Jun 2024 14:08:35 +0200
Subject: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl for
 all vsock socket types.
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>
References: <20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com>
In-Reply-To: <20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com>
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
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719403717; l=3696;
 i=luigi.leonardi@outlook.com; s=20240626; h=from:subject:message-id;
 bh=XBc988xsxIc7ZI663M8AXQFntIOWVVx66o4JkV1CeRo=;
 b=s27ZRWrsGEs4wcLLVlRYz+AUXUZaj9wTRP3v7Pa7DLHqXA29iNZ4ZWw7fFVu6KPGHz0cd2lc8
 x18vpqqFMyvDIt/62Lc5LJolWtc88+UnKO2FOSOEYCKXO8qKCUxUYgd
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=RYXD8JyCxGnx/izNc/6b3g3pgpohJMAI0LJ7ynxXzi8=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240626
 with auth_id=177
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Luigi Leonardi <luigi.leonardi@outlook.com>

Add support for ioctl(s) for SOCK_STREAM SOCK_SEQPACKET and SOCK_DGRAM
in AF_VSOCK.
The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
of unsent bytes in the socket. This information is transport-specific
and is delegated to them using a callback.

Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 include/net/af_vsock.h   |  3 +++
 net/vmw_vsock/af_vsock.c | 60 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 535701efc1e5..7b5375ae7827 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -169,6 +169,9 @@ struct vsock_transport {
 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
 	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
 
+	/* SIOCOUTQ ioctl */
+	size_t (*unsent_bytes)(struct vsock_sock *vsk);
+
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4b040285aa78..d6140d73d122 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -112,6 +112,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 #include <uapi/linux/vm_sockets.h>
+#include <uapi/asm-generic/ioctls.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -1292,6 +1293,59 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
+			  int __user *arg)
+{
+	struct sock *sk = sock->sk;
+	struct vsock_sock *vsk;
+	int retval;
+
+	vsk = vsock_sk(sk);
+
+	switch (cmd) {
+	case SIOCOUTQ: {
+		size_t n_bytes;
+
+		if (!vsk->transport || !vsk->transport->unsent_bytes) {
+			retval = -EOPNOTSUPP;
+			break;
+		}
+
+		if (vsk->transport->unsent_bytes) {
+			if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
+				retval = -EINVAL;
+				break;
+			}
+
+			n_bytes = vsk->transport->unsent_bytes(vsk);
+			if (n_bytes < 0) {
+				retval = n_bytes;
+				break;
+			}
+
+			retval = put_user(n_bytes, arg);
+		}
+		break;
+	}
+	default:
+		retval = -ENOIOCTLCMD;
+	}
+
+	return retval;
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
@@ -1302,7 +1356,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.accept = sock_no_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = vsock_shutdown,
 	.sendmsg = vsock_dgram_sendmsg,
@@ -2286,7 +2340,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,
@@ -2308,7 +2362,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
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



