Return-Path: <kvm+bounces-31025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A06EE9BF536
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 575881F22F91
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11044207A3A;
	Wed,  6 Nov 2024 18:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="e1cPY2Cj"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4262813A26F
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917522; cv=none; b=T9LgrSFy/Ftw7Y8JnXDjLPzoQ8zjDZtski5znirR1f3wmJTpy98DxOKa85aqcPLwGjaDV5K/ilia/+NkITBJlb18jJHVyo61LWBYClYGwkzk1W/8UG5OGK9hX99SMBUMj4NlmLdXHYjeLuVdqgnTv0k4ya3K4O2kM9eCRAEXq78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917522; c=relaxed/simple;
	bh=ToEirsG8hKSEVZWDFPtVwr+5Ss0cMfhCSoRUBD5F73Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=diHSRdFLyVJqXzAPC6s2P3IuQpnnlCGq2LBhxqv8jKg3w9wgzBprHRCagiuAaldebwGF+2h/DStK+NflEb1zr93vyS1jkS4g5CM59uEsPuZozAZjn/w5HZyAKzSiFRs7iCldD3BYjDgzYUxtiVOPTl/yWqoZdmBHTXNi3nkf4+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=e1cPY2Cj; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t8kCQ-00FDuN-DH; Wed, 06 Nov 2024 18:52:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=mgnddhxagPc/9l4dw5EI0uGjEiStoOzkIyViqtJTwlA=; b=e1cPY2Cjl7+QaeoW+GsgwldeX1
	b4vSXmNlNtrn3vvRJkLtacNrl9mSpYni0TFSZfD3bIMtw9qAjCGncxANJEUzJjBxcY9Ne/noeAhgd
	WJl+FJtkKasutqGtLM/d3Jn0qRIPYkr3tg7Pxfg18zmq+BfhY/WRE4FaaAt9b0zW7SxzkCPeEmVa8
	ofj4D3AZHFLhwiKfDnXmtBF3ZE+R0DuWmCSXy6lI3jZlaKqkiN0QDsHorWj1S5Zod+f9BthuMdNdG
	orGQ/LMs77P7ufShrxymANOyTPJSgTBg2ZLEUts9ZO7yrLd0iBAaBdtgXK291zmZ/fE8AIXx/C1r6
	K7/BYlIA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t8kCP-0001rN-PU; Wed, 06 Nov 2024 18:52:09 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t8kCK-002ver-Ha; Wed, 06 Nov 2024 18:52:04 +0100
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 06 Nov 2024 18:51:21 +0100
Subject: [PATCH net 4/4] virtio/vsock: Put vsock_connected_sockets_vsk() to
 use
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241106-vsock-mem-leaks-v1-4-8f4ffc3099e6@rbox.co>
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
In-Reply-To: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jia He <justin.he@arm.com>, 
 Arseniy Krasnov <avkrasnov@salutedevices.com>, 
 Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
 George Zhang <georgezhang@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Macro vsock_connected_sockets_vsk() has been unused since its introduction.
Instead of removing it, utilise it in vsock_insert_connected() where it's
been open-coded.

No functional change intended.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/af_vsock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index dfd29160fe11c4675f872c1ee123d65b2da0dae6..c3a37c3d4bf3c8117fbc8bd020da8dc1c9212732 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -275,8 +275,7 @@ static void vsock_insert_unbound(struct vsock_sock *vsk)
 
 void vsock_insert_connected(struct vsock_sock *vsk)
 {
-	struct list_head *list = vsock_connected_sockets(
-		&vsk->remote_addr, &vsk->local_addr);
+	struct list_head *list = vsock_connected_sockets_vsk(vsk);
 
 	spin_lock_bh(&vsock_table_lock);
 	__vsock_insert_connected(list, vsk);

-- 
2.46.2


