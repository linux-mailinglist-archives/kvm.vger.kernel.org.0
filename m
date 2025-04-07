Return-Path: <kvm+bounces-42869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CC8A7ECDF
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 21:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CDBE1885E74
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 19:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014C9214A6C;
	Mon,  7 Apr 2025 19:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="bi6yZ9M0"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1D413CFB6
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 19:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744052683; cv=none; b=Pq87+GTPwp4+WRjp6hsUGStrVt8USfauGa54X28AMqcP/yoo736Ost2mVfW423g0pt3SIkLy8YpctHrgyyjeA9A5DVB/4vNL7kwkSInpuw5dMA0/gxnhz98UvcOEWxe1COMWuVV7Fmb4roP2r+RNj6DLg5JT9MWeggcPz5Y+GDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744052683; c=relaxed/simple;
	bh=QI7mQrvmuSrk43UPe6jrAoVYIEOYC5JWxOa895S1c6Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OXYZvxYpbGRchp2jsJTnMGap9/QnPR7IHmDp/shEBIvgBim1YUNs8yn9UtvP0ijWt/o63JNl6JF6L6DzjzxOCmZNlvijK6dbCtLwAw3OOZ5noBcYvs43MiT7JBUIVVgQjTm4mVMFoWn16ytsi8MdP22ySysM88trtzBA6w3LCCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=bi6yZ9M0; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u1rQC-00CpZc-4S; Mon, 07 Apr 2025 20:42:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=/nxvcDYdriK1YGN1nqBZmrt0621aSzHhg8YqEczI/e0=; b=bi6yZ9M0jYLtOAIMc19kCTzTFN
	6BMX/eIyHlpR46ocNSrCoEFlXLolxs6hdZxrdKKnb5aJ0UwaxJkXXSONGGlXpRpJneWgigsOnwosJ
	5xsVU7mTA4WkRZEDRXowxu3e1GIGeUafQWb1tdLRE+DzZI2CGE9xQY0/rW5pNo4D9tUmOi7/Isnwx
	k5VxIisttm5E1Zn6lUAiWDTVI8nEEL8AFbl9vwoOXUUKdNpMnfR2ZOXeN4e2f70g1NEhtSroyFqVR
	wyXmAPNcApBbWQi3JykclPHFai1wwj0SyB71cemFR18f4KEwVxp9cBSV16u47pzQxvx3g6BOoMlE5
	vLF08Y2g==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u1rQB-0007un-2M; Mon, 07 Apr 2025 20:42:11 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u1rPz-008fhd-TY; Mon, 07 Apr 2025 20:41:59 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Mon, 07 Apr 2025 20:41:43 +0200
Subject: [PATCH net-next 1/2] vsock: Linger on unsent data
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
In-Reply-To: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
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

Change the behaviour of a lingering close(): instead of waiting for all
data to be consumed, block until data is considered sent, i.e. until worker
picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.

Do linger on shutdown() just as well.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 25 +++----------------------
 3 files changed, 29 insertions(+), 22 deletions(-)

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
index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..383c6644d047589035c0439c47d1440273e67ea9 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1013,6 +1013,29 @@ static int vsock_getname(struct socket *sock,
 	return err;
 }
 
+void vsock_linger(struct sock *sk, long timeout)
+{
+	if (timeout) {
+		DEFINE_WAIT_FUNC(wait, woken_wake_function);
+		ssize_t (*unsent)(struct vsock_sock *vsk);
+		struct vsock_sock *vsk = vsock_sk(sk);
+
+		unsent = vsk->transport->unsent_bytes;
+		if (!unsent)
+			return;
+
+		add_wait_queue(sk_sleep(sk), &wait);
+
+		do {
+			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
+				break;
+		} while (!signal_pending(current) && timeout);
+
+		remove_wait_queue(sk_sleep(sk), &wait);
+	}
+}
+EXPORT_SYMBOL_GPL(vsock_linger);
+
 static int vsock_shutdown(struct socket *sock, int mode)
 {
 	int err;
@@ -1056,6 +1079,8 @@ static int vsock_shutdown(struct socket *sock, int mode)
 		if (sock_type_connectible(sk->sk_type)) {
 			sock_reset_flag(sk, SOCK_DONE);
 			vsock_send_shutdown(sk, mode);
+			if (sock_flag(sk, SOCK_LINGER))
+				vsock_linger(sk, sk->sk_lingertime);
 		}
 	}
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7f7de6d8809655fe522749fbbc9025df71f071bd..66ff2e694e474ad16f70248cc1dc235f4e1ebaa1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1192,23 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
 	vsock_remove_sock(vsk);
 }
 
-static void virtio_transport_wait_close(struct sock *sk, long timeout)
-{
-	if (timeout) {
-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
-
-		add_wait_queue(sk_sleep(sk), &wait);
-
-		do {
-			if (sk_wait_event(sk, &timeout,
-					  sock_flag(sk, SOCK_DONE), &wait))
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
@@ -1279,15 +1262,13 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
 
 	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
-		virtio_transport_wait_close(sk, sk->sk_lingertime);
+		vsock_linger(sk, sk->sk_lingertime);
 
-	if (sock_flag(sk, SOCK_DONE)) {
+	if (sock_flag(sk, SOCK_DONE))
 		return true;
-	}
 
 	sock_hold(sk);
-	INIT_DELAYED_WORK(&vsk->close_work,
-			  virtio_transport_close_timeout);
+	INIT_DELAYED_WORK(&vsk->close_work, virtio_transport_close_timeout);
 	vsk->close_work_scheduled = true;
 	schedule_delayed_work(&vsk->close_work, VSOCK_CLOSE_TIMEOUT);
 	return false;

-- 
2.49.0


