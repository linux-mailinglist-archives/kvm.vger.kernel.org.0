Return-Path: <kvm+bounces-31024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D472B9BF535
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F5311F22035
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B09208227;
	Wed,  6 Nov 2024 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="e8gIFCTn"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62C813A26F;
	Wed,  6 Nov 2024 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917510; cv=none; b=PBmni0q9TJu+MvTTNTcVhTV9xckVXx6qK0keP06YMf5Z1+dEZ+vpZMjaB01URPIbo/sVmqfGH1EOSJl6ieyG5ipWH0UqqYKAZ4xXrDkpPJJDBuKlQU+lJrvN5YFrsb8mRgx9G87tlL9DuYZEQZHY7rsxyXTem0gE1aorxUyjc9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917510; c=relaxed/simple;
	bh=KgA8I/V+Cve4q5UsJIo/GYuOhEw8GH4l1Hf73OoQ+hM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JKxAQlC+/uEyGPO74coYFBaUblDt2jYdNXC5aO0SRXE4dHsysygXu2Dy8njpo4htD0+HyC6Mw1EtXMlXImqpku1f8dL1Zh72LFvyaWBQdwDM7eEX3415NTe68hPvbID6vMKAZgKfIQAE7QY24Z7a7P9X/Dun6BhOwXKYgTXpWJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=e8gIFCTn; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t8kCW-00FDuq-UW; Wed, 06 Nov 2024 18:52:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=Ct0XEhml4swkSlIdXGo4yYyMaDVehK1UNpjzCcF1yWA=; b=e8gIFCTn+IZ9UH49qs0POm0nfk
	Py41sqFa3oVqYX64FBxeeFjO1FhlhOF+iD4Q+9qxmTbsu7td6OBDujxO1yRZqCTRjdqx9pa5slAgL
	rktKT/vqwRkw1h6ANPh35CWt+1i1LJffRC0bg9KNYvAnyZGPabHZqBksok0qNO65CJPVKwrfy7ZaR
	xuCcyHdCB7CFfT20M5SA33PBcXTNuRDA+NKx+hgE8p6KKq9GWfh8iwJeBjwhJ9eSDtx7iuzS37yT3
	U4PpHrqByD2uptcSp6NWP71N3tsUAdqEJAPKgCgAqNJWV0vVYHAHj1Mi4fjyUy2WncgZ9zN6owQr/
	9ck1ZsTg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t8kCW-0001oV-A0; Wed, 06 Nov 2024 18:52:16 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t8kCJ-002ver-MP; Wed, 06 Nov 2024 18:52:03 +0100
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 06 Nov 2024 18:51:20 +0100
Subject: [PATCH net 3/4] virtio/vsock: Improve MSG_ZEROCOPY error handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241106-vsock-mem-leaks-v1-3-8f4ffc3099e6@rbox.co>
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

Add a missing kfree_skb() to prevent memory leaks.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index cd075f608d4f6f48f894543e5e9c966d3e5f22df..e2e6a30b759bdc6371bb0d63ee2e77c0ba148fd2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -400,6 +400,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 			if (virtio_transport_init_zcopy_skb(vsk, skb,
 							    info->msg,
 							    can_zcopy)) {
+				kfree_skb(skb);
 				ret = -ENOMEM;
 				break;
 			}

-- 
2.46.2


