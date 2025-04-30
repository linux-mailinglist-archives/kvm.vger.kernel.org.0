Return-Path: <kvm+bounces-44872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC55AA4689
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 252E71895105
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57AE7221736;
	Wed, 30 Apr 2025 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="ffRb+s5H"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EF121ADAB;
	Wed, 30 Apr 2025 09:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004291; cv=none; b=iotAAYkmBglMVW82t8zVTZjDIv3v2n0VMUiCQlMZH8PBDPbIL3+YJ29O3mtl5UlFkc3anSKhn7uElVorgyqw0kobvw+u7d1KrKD3oUz57l+F2ezGwaPmRX+sM80BexJMPU0DKswJjLgkLYQGRT/+hDZH2PuH6XygZ2fW8W/VKF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004291; c=relaxed/simple;
	bh=B6PUeUS9nTSTlha5n91p/+cQVOJulOurJQNUX1pTWL8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HSrGslVxr/gO6FtmguMEmqEGnPSJZie8tcS9evQ//23wNbfehOLnm72YvgcIlyBe7LInRmbpkiugaUL8jBWvSfKO/uXt+qNOVV88WPSPEXuVu54n7TheX7wnYXrAr/o99QNtzYpTHVo9Kw7loe/MnHHAIZG2rRiwe1cr01B3tAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=ffRb+s5H; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA3TM-006EEa-3L; Wed, 30 Apr 2025 11:11:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=06COR0tHUw7dwx3cleQDSPa8f7BJblvvOI8tjwdPeEs=; b=ffRb+s5HpGDOPdiZFy+1cNQJsg
	720p7GEtohFdCIqTKb+Xci0dCuflIRFQAPczM9Fy2eRltBfmNboHS7UCZhL9KInT2IevMTfkW2io+
	EH9M2tYJ1VbURZm8FXdyychvFe70jG6c0wlJrdZZK4ENbZbT/lS3vPHsYgeLgU/h+UtU79hfvpoRh
	/12wtHiDNv9f9Aq4QKbxpKTm0xfvSvS/jrS97IE86BtWpXyB5mHGJE7tAt9+pNVJWB2szKNKBVwiB
	K/2FuejfDtRKo4jGliVMxpvIXRmvUDNklz1sFM3ASXHQzpFonLmNvbdbJMy0ljBdthGS0Zxjfyvmp
	iFNnpGEw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA3TL-0006As-Or; Wed, 30 Apr 2025 11:11:19 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA3TI-00CDEV-A1; Wed, 30 Apr 2025 11:11:16 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 30 Apr 2025 11:10:29 +0200
Subject: [PATCH net-next v3 3/4] vsock: Move lingering logic to af_vsock
 core
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250430-vsock-linger-v3-3-ddbe73b53457@rbox.co>
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
In-Reply-To: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
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
for supporting other transports, as well the linger on shutdown(), move
code to core.

Guard against an unimplemented vsock_transport::unsent_bytes() callback.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 23 +----------------------
 3 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 9e85424c834353d016a527070dd62e15ff3bfce1..bd8b88d70423051dd05fc445fe37971af631ba03 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
+void vsock_linger(struct sock *sk, long timeout);
 
 /**** TAP ****/
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..946b37de679a0e68b84cd982a3af2a959c60ee57 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1013,6 +1013,31 @@ static int vsock_getname(struct socket *sock,
 	return err;
 }
 
+void vsock_linger(struct sock *sk, long timeout)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	ssize_t (*unsent)(struct vsock_sock *vsk);
+	struct vsock_sock *vsk = vsock_sk(sk);
+
+	if (!timeout)
+		return;
+
+	/* unsent_bytes() may be unimplemented. */
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
index 4425802c5d718f65aaea425ea35886ad64e2fe6e..9230b8358ef2ac1f6e72a5961bae39f9093c8884 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1192,27 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
 	vsock_remove_sock(vsk);
 }
 
-static void virtio_transport_wait_close(struct sock *sk, long timeout)
-{
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	ssize_t (*unsent)(struct vsock_sock *vsk);
-	struct vsock_sock *vsk = vsock_sk(sk);
-
-	if (!timeout)
-		return;
-
-	unsent = vsk->transport->unsent_bytes;
-
-	add_wait_queue(sk_sleep(sk), &wait);
-
-	do {
-		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
-			break;
-	} while (!signal_pending(current) && timeout);
-
-	remove_wait_queue(sk_sleep(sk), &wait);
-}
-
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
 					       bool cancel_timeout)
 {
@@ -1283,7 +1262,7 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
 
 	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
-		virtio_transport_wait_close(sk, sk->sk_lingertime);
+		vsock_linger(sk, sk->sk_lingertime);
 
 	if (sock_flag(sk, SOCK_DONE)) {
 		return true;

-- 
2.49.0


