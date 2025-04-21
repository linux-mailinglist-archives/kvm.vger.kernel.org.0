Return-Path: <kvm+bounces-43729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D2BA9586E
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 23:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4115F17509B
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E0621D3C5;
	Mon, 21 Apr 2025 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="O5hg71pU"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29531F09BF
	for <kvm@vger.kernel.org>; Mon, 21 Apr 2025 21:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272286; cv=none; b=rZE7Ou5mhIEMobvZVAICDfGDNz1r8YWdv3/jT1iP9lXKiq3esgVt4VYS2GpNxIo2IgGu2Shr2tQsREP6JcdROaN/YvK+/dX9poHoEIjxyJF4LX2gfsg0u6jEQKt9PgNT/IblwvNzQyxaZet6H1m1B1hvF9BlXmh7/HqSUl7L6gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272286; c=relaxed/simple;
	bh=bHwtlyMxeHnsuncWmgegHfpg8gQ1s1DmHKYAxY8sXgk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XaJBapN/DZ/V1cAAKTZDpNZr6iuvSRCCA428COkYdUc5r909hr0DL9nD3qRVDzWv6Zh+9b5xuZxAmcv0fP6I5sljC9jGVbaH7HDJ+u+KITfivQ9ui92VnBaoOuL1e1sr4wH0Ot3sAmrQ84ZbJU1k4o9gNDBnFC/tXnkf8zDlHzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=O5hg71pU; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2o-000P5q-Hb; Mon, 21 Apr 2025 23:51:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=497SM9RsTvdwm5GlckzJy9eHMN+5FbxFzHDjGrgCfG0=; b=O5hg71pUdZHmXxa1Y9QOpsyloh
	Z8857BgHLvnJZ+g5bi0rqGZBzECQDJfDKgKPA/Pwgt7mvzSl7ZPWq3V96byIFeD3ZSuN23junglVa
	JXB/dotkuq/XzSErNQyCmZ0vOjyvwzBr8SFGRAnf/+yzmjdltyt2Qg0ZAlbreJqzWlZaYAWKQOvtk
	dcYZA0yw9aeesVfx2wbXK2zy1W177weBBSWpUoxuskFllEd94Y8KiPTBTStjVbfcvu86BBjQEIWNv
	GVo6n6zEqN3ieS+qgJtdRdhVE0IqyF01c0uDp8X/b+jWuAxrffn+1YsUDC2OH8CtRh20+Z2YxOBqR
	wnTXRS+g==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2o-0008Iu-4s; Mon, 21 Apr 2025 23:51:14 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u6z2i-0056xd-9L; Mon, 21 Apr 2025 23:51:08 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Mon, 21 Apr 2025 23:50:42 +0200
Subject: [PATCH net-next v2 2/3] vsock: Reduce indentation in
 virtio_transport_wait_close()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250421-vsock-linger-v2-2-fe9febd64668@rbox.co>
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
In-Reply-To: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
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

Flatten the function. Remove the nested block by inverting the condition:
return early on !timeout.

No functional change intended.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 36 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index aeb7f3794f7cfc251dde878cb44fdcc54814c89c..73b6e7b437d950fd1cd1507f7dcc28780bd98a0b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1194,28 +1194,28 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
 
 static void virtio_transport_wait_close(struct sock *sk, long timeout)
 {
-	if (timeout) {
-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
-		ssize_t (*unsent)(struct vsock_sock *vsk);
-		struct vsock_sock *vsk = vsock_sk(sk);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	ssize_t (*unsent)(struct vsock_sock *vsk);
+	struct vsock_sock *vsk = vsock_sk(sk);
 
-		/* Some transports (Hyper-V, VMCI) do not implement
-		 * unsent_bytes. For those, no lingering on close().
-		 */
-		unsent = vsk->transport->unsent_bytes;
-		if (!unsent)
-			return;
+	if (!timeout)
+		return;
+
+	/* Some transports (Hyper-V, VMCI) do not implement unsent_bytes.
+	 * For those, no lingering on close().
+	 */
+	unsent = vsk->transport->unsent_bytes;
+	if (!unsent)
+		return;
 
-		add_wait_queue(sk_sleep(sk), &wait);
+	add_wait_queue(sk_sleep(sk), &wait);
 
-		do {
-			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0,
-					  &wait))
-				break;
-		} while (!signal_pending(current) && timeout);
+	do {
+		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
+			break;
+	} while (!signal_pending(current) && timeout);
 
-		remove_wait_queue(sk_sleep(sk), &wait);
-	}
+	remove_wait_queue(sk_sleep(sk), &wait);
 }
 
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,

-- 
2.49.0


