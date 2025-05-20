Return-Path: <kvm+bounces-47190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4854FABE7BA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75D0B4A746E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4152A261593;
	Tue, 20 May 2025 22:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="O2iEYA2G"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E943256C79;
	Tue, 20 May 2025 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781792; cv=none; b=tibk2ug9rOyNFP/sMwNzuoDcRvN0yx2fUkagyns1XUhTNAWZwkey3+lGY7E++HSC5iTaC3NcX9L/COpHuEhRVri/tRSbDnM4NSR2VxY8W4VVlIoHwZcGb4K6dDMTPJaPPj5KOlsPH9vEG6x/oqVcMCdqcEMn2JM/lTqc2zgPtFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781792; c=relaxed/simple;
	bh=7/4DagCvVLly4gImCZNK1PedcDgABasf/ogGGGrZizY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ImV0DcmY1Y7WeiMEFqlFpfAVY4YR6TvAaVYfLwoJEvFMt8o5drOqy0k1/PEkMtQK2qc/XfyUdkVyblxWsgcyca43oHdD4JibdAJjGzyK4hcI4Je6Buix3Jt73naQ+8HVHaV6W+3i8iuM8DGOS+5JyWsyRx1mZ+KHnfbse5wXwvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=O2iEYA2G; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsn-001X6R-C3; Wed, 21 May 2025 00:56:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=1RCUs8dYsV0Y4s60XlR52eOROlRK4tgJbTFvoxC73qY=; b=O2iEYA2GxZA9vCJZO/KyxhWWhF
	i9XbHPsnIjDMRhUV+mltKqa/k+tOy0NKqxn5u4aRmHX5+y520qG98ePC65Q/RkXmXpK5QlCphMYUQ
	09U7yFGBUV0VEntX2fSBXGPyc2S6XRfk4fyriaPTzbrSJIzsewlzBXzWuvDCoNla1nTPqDBuaFkfb
	07VgHWKkMnmoLnm1GdHxGhay7pdjP2nmYQghShZpYyk4bFWwlM75YDEGNNG0wcKg4TdxcykBA4TVx
	IDJN1J8QCv+MxUhbStUIX/6XS0KkwPM82rtdNIrvMnwaiD2TGdMXsskrK8G08VtjMd3l+GYFdeusl
	mv4Oo4ig==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsn-0007nU-45; Wed, 21 May 2025 00:56:25 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHVsX-00CxGf-G9; Wed, 21 May 2025 00:56:09 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 21 May 2025 00:55:20 +0200
Subject: [PATCH net-next v5 2/5] vsock: Move lingering logic to af_vsock
 core
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250521-vsock-linger-v5-2-94827860d1d6@rbox.co>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
In-Reply-To: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Lingering should be transport-independent in the long run. In preparation
for supporting other transports, as well as the linger on shutdown(), move
code to core.

Generalize by querying vsock_transport::unsent_bytes(), guard against the
callback being unimplemented. Do not pass sk_lingertime explicitly. Pull
SOCK_LINGER check into vsock_linger().

Flatten the function. Remove the nested block by inverting the condition:
return early on !timeout.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 33 +++++++++++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 23 ++---------------------
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 9e85424c834353d016a527070dd62e15ff3bfce1..d56e6e135158939087d060dfcf65d3fdaea53bf3 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
+void vsock_linger(struct sock *sk);
 
 /**** TAP ****/
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..2e7a3034e965db30b6ee295370d866e6d8b1c341 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1013,6 +1013,39 @@ static int vsock_getname(struct socket *sock,
 	return err;
 }
 
+void vsock_linger(struct sock *sk)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	ssize_t (*unsent)(struct vsock_sock *vsk);
+	struct vsock_sock *vsk = vsock_sk(sk);
+	long timeout;
+
+	if (!sock_flag(sk, SOCK_LINGER))
+		return;
+
+	timeout = sk->sk_lingertime;
+	if (!timeout)
+		return;
+
+	/* Transports must implement `unsent_bytes` if they want to support
+	 * SOCK_LINGER through `vsock_linger()` since we use it to check when
+	 * the socket can be closed.
+	 */
+	unsent = vsk->transport->unsent_bytes;
+	if (!unsent)
+		return;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+
+	do {
+		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
+			break;
+	} while (!signal_pending(current) && timeout);
+
+	remove_wait_queue(sk_sleep(sk), &wait);
+}
+EXPORT_SYMBOL_GPL(vsock_linger);
+
 static int vsock_shutdown(struct socket *sock, int mode)
 {
 	int err;
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f2f1b166731b1bf2baa3db2854de19aa331128ea..7897fd970dd867bd2c97a2147e3a5c853fb514af 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1191,25 +1191,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
 	vsock_remove_sock(vsk);
 }
 
-static void virtio_transport_wait_close(struct sock *sk, long timeout)
-{
-	if (timeout) {
-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
-		struct vsock_sock *vsk = vsock_sk(sk);
-
-		add_wait_queue(sk_sleep(sk), &wait);
-
-		do {
-			if (sk_wait_event(sk, &timeout,
-					  virtio_transport_unsent_bytes(vsk) == 0,
-					  &wait))
-				break;
-		} while (!signal_pending(current) && timeout);
-
-		remove_wait_queue(sk_sleep(sk), &wait);
-	}
-}
-
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
 					       bool cancel_timeout)
 {
@@ -1279,8 +1260,8 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
 	if ((sk->sk_shutdown & SHUTDOWN_MASK) != SHUTDOWN_MASK)
 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
 
-	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
-		virtio_transport_wait_close(sk, sk->sk_lingertime);
+	if (!(current->flags & PF_EXITING))
+		vsock_linger(sk);
 
 	if (sock_flag(sk, SOCK_DONE)) {
 		return true;

-- 
2.49.0


