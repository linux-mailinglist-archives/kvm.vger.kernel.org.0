Return-Path: <kvm+bounces-49248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BABAD6ADD
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60E71BC38E0
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CC222068B;
	Thu, 12 Jun 2025 08:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjSm0wSZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19911B412A
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749717156; cv=none; b=pYqV9k9DA4/hbwdlreXXl2ZPRvMi5mzSgtv6vcJTdekG4rhUrlMmI1+NjMStCVc2VEKxsLfnhhmyYjpmDEAIis5pnQsxGrcE6pXqQwVZISR6kZm78Tt0W3+29ivnckuMDhz67SGlC+5NqFeUq9nkWXwBBx/Xm0HpZJ74AUvMcXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749717156; c=relaxed/simple;
	bh=dRnpTqZOgxtCjtrEYPRyB19fZASY1zRRbygsfhWRtpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZPpRGi1F7P0Bqby/NJ5CjW8oT+d2+TCkaBdway0sbQ0qWV69yEahffrFCMslIK8Zanl92UaT8ftkI66QaMdubbGTY2AL93AfIXJBOfMoSzTcQDqp8LhKGToOe1AK7OCNNKBLtvE05/pzr07YO9qEeoELxYeWNGxwctr8ribsOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjSm0wSZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749717153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WBc9H8Z/EQERaKXzDLp/qCNq6MVVbEZ78ho0JJh2JsQ=;
	b=WjSm0wSZFGnrRYeZg/Ak7soj4WMtkJpnlDyW/F18mZa7UA2wowQS0PmlDR5OONpzHpdabN
	ZAInfnzEdHzY5l5hdaJ68pBozQbYK0gl3sk0F14vW4xeCk33aJNDhJ1kcth8of7GYFTiuq
	iZi4UIAJPKvhWfnjiwY+Ict6G8bimHs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-qHPjq-GQPCy8ACNRN0g0hg-1; Thu,
 12 Jun 2025 04:32:32 -0400
X-MC-Unique: qHPjq-GQPCy8ACNRN0g0hg-1
X-Mimecast-MFC-AGG-ID: qHPjq-GQPCy8ACNRN0g0hg_1749717150
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D83019560B6;
	Thu, 12 Jun 2025 08:32:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.165])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72DFC19560A3;
	Thu, 12 Jun 2025 08:32:24 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com
Cc: eperezma@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	willemdebruijn.kernel@gmail.com,
	davem@davemloft.net,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Subject: [PATCH net-next 2/2] vhost-net: reduce one userspace copy when building XDP buff
Date: Thu, 12 Jun 2025 16:32:13 +0800
Message-ID: <20250612083213.2704-2-jasowang@redhat.com>
In-Reply-To: <20250612083213.2704-1-jasowang@redhat.com>
References: <20250612083213.2704-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

We used to do twice copy_from_iter() to copy virtio-net and packet
separately. This introduce overheads for userspace access hardening as
well as SMAP (for x86 it's stac/clac). So this patch tries to use one
copy_from_iter() to copy them once and move the virtio-net header
afterwards to reduce overheads.

Testpmd + vhost_net shows 10% improvement from 5.45Mpps to 6.0Mpps.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 777eb6193985..2845e0a473ea 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -690,13 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	copied = copy_from_iter(buf, sock_hlen, from);
-	if (copied != sock_hlen) {
+	copied = copy_from_iter(buf + pad - sock_hlen, len, from);
+	if (copied != len) {
 		ret = -EFAULT;
 		goto err;
 	}
 
-	gso = buf;
+	gso = buf + pad - sock_hlen;
 
 	if (!sock_hlen)
 		memset(buf, 0, pad);
@@ -715,12 +715,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 		}
 	}
 
-	len -= sock_hlen;
-	copied = copy_from_iter(buf + pad, len, from);
-	if (copied != len) {
-		ret = -EFAULT;
-		goto err;
-	}
+	memcpy(buf, buf + pad - sock_hlen, sock_hlen);
 
 	xdp_init_buff(xdp, buflen, NULL);
 	xdp_prepare_buff(xdp, buf, pad, len, true);
-- 
2.34.1


