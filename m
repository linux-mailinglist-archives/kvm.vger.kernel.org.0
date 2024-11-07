Return-Path: <kvm+bounces-31175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4ED49C0FFD
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CA961F23DC2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAF7218581;
	Thu,  7 Nov 2024 20:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="Dz6r7CR5"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB02194C92;
	Thu,  7 Nov 2024 20:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012413; cv=none; b=VHwXxBue3gUAZuIqNXSAmI9j4ybmkDFPXdj8NFDjWm+BFbKm/H2UTtdJkh8f01cxnEDtqVzqbtJDlePZ/BmGvK/xAhrPkAeLMS0Gs4ean7wnf8oSSVZ4rQ6QKXWA0S7CbpKFOrBlV4hB99Cjfz7Jfs6SZGy75QQG0U+ZUIL2yns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012413; c=relaxed/simple;
	bh=kLr7cOclroyf5zVvYnQrQ2CcjkVEuNICECl91R8pvZA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MlhNV9vkfrYBWIpH1Vx968FUwrT9HDe/nrTUr57P/CYhHu5oShoeBAV4RUnkkzwwPB5N22/4dJ5sncAs8qme1TTcs8Y26Vjs5OtRnxBy0l+sLS0KM8f05yeAy1QjAxActYzyuMcmiQWMMf+mTjZNa3BfdKNtdkwGfBtQeNhUsRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=Dz6r7CR5; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t99Op-001cy6-6x; Thu, 07 Nov 2024 21:46:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=s52+eMLfek4vBrlWTawS+NMGo3ZdEqQlahGa6OYNJF4=; b=Dz6r7CR5wDT+ZtZF595bhaKEfu
	kxWO6bfhAifZPleGJZEVQnhhTLbkv7BOBwxQR6uRRqGc0JiSNyC6rD0D9rPAZ+hQ0YQEM6cKgE6tA
	Efh6l8A1R+UTDU2I3Gmm5smLxeHTy//+e7QI6LFYewxLd4ypnaT68Th8jnJNymp4Hh7WAZhze+MjE
	F07BANiCiLO+Vp1ktYqX2WUcSBRYD3oBzrY7Cf8sznfXeZeSIjiXvDslUmB9xY1eoiMtf5qkHzviC
	LWF14FB6SvpByieEJ1cA47rMERqKYxwTSa0QsVdn6H5LMcZkuumHSrgdMHeu/1B6h/psFTtbzK3IU
	ct5REk3A==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t99Oj-0003F0-T5; Thu, 07 Nov 2024 21:46:34 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t99Oi-00303e-3b; Thu, 07 Nov 2024 21:46:32 +0100
From: Michal Luczaj <mhal@rbox.co>
Date: Thu, 07 Nov 2024 21:46:14 +0100
Subject: [PATCH net v2 3/3] virtio/vsock: Improve MSG_ZEROCOPY error
 handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-vsock-mem-leaks-v2-3-4e21bfcfc818@rbox.co>
References: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
In-Reply-To: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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


