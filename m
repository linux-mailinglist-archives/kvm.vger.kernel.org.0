Return-Path: <kvm+bounces-27798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1BA98D6B7
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 15:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C088B2232A
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 13:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344CB1D0BBC;
	Wed,  2 Oct 2024 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YmWb6biI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82611D0945
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876514; cv=none; b=ZkmAbFZdCkxE7qK60yeAwHtENekw3DjNN/OPDATh0WzKFyneqGr3hPkn346h0uMPe5vgPTthlppvzSmrrvHNZKIqj5upFiygpg/vJX4rjmF2QWc/OtKGrv/A4gvgVu2Q4KASLFpOZ27h3MV+GCt1H/AYp9p//8CA15NENIuV7aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876514; c=relaxed/simple;
	bh=5OZTexW1N2cYsiipBckmnTsow8NYUZJeFd0Dc1g6Amk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iwzuoOZ9VGre0MTrp6L8D99ncQaMXmhYsR+Jj6OZ9C3+YLrSIkIJbQKkz9j432xG1rR6u7WwM7IuccCvA2J8SBjkUO7agVNwrtDWSQexdDTcsq8H6HqYzn8aw86MCUoRFNNzIl3BVtRYDroRK2pCS0Ix2LR9o/O/s/H2Xhx8M2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YmWb6biI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727876511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=UWQpm0mcyr3iomDUG9qlXZHim5cqJMh8ETQLI86SlcY=;
	b=YmWb6biINfbxXUdiYW+epZidj5ckg/LJeYCOUreVuLMhUbm8z4/7fH/WOSAJj5FyeK7VBj
	X4i+uy8iHAKJG7/ZTA0WHSaL+arWshdrGUeA0LF1xtlinZ3qADB/Cuoa924JN8YkZoxczZ
	YFqtVE6Dc/ph6/E+uYOfrMR8QPMxfVA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-QsuOF6n2OXyU4LRqlYf0AA-1; Wed, 02 Oct 2024 09:41:50 -0400
X-MC-Unique: QsuOF6n2OXyU4LRqlYf0AA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8ff95023b6so495688866b.3
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 06:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727876509; x=1728481309;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWQpm0mcyr3iomDUG9qlXZHim5cqJMh8ETQLI86SlcY=;
        b=n+iXVBRGT5DRTGKLv2EJbsFc55Zop+I0xv6RIEczzsnfaeW0ppQRmExeExU4L847H3
         LJOC3Zr0t+4hGVWZ/i4Kaw6l/CqcvmwE8Lft64ED77NWDRvG0wvVkkRJRELUD9X+rJIA
         7OfCZSDB/1gvbBgatauFa/AAoQN1wYy4x48657lKWMoLA1lmKNUJok+tRFgYUzlc55dU
         u+lLj6EKQ8/uICsW8RDl+VjSRX+5gpkCP5MSeIoS+YLpc/jVT0tVf/NUDXHdVl4/tEhT
         7KOSnKVmA6GxBL16H9pKOr1OS8rrBasW+jTpLeXdzTtToYq98k4BKk9A/IvB45GXgA8P
         ShuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqhTxZH7/soT3IEr74/cOglbHsJqYWPOHVMyY32/xCg969ttbE5Ei/Za3h/btf6dOQA8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxAIh6Y1nHdji9fhlmXkjOqWq4BTNktCKswXTlnPExq0nW3nEY
	b0SeinqFG6OTyCx5wL6r0VabUJGdEeGcifwnCzzikW2VAcjWiS9YDxApkMKnW2Hc4Bk8hZLhXLH
	ru33HpofkejaGjkYj0tVX96sDyV6+nJE79GW+JraeFqGlGNKGGw==
X-Received: by 2002:a17:907:6d1e:b0:a86:8917:fcd6 with SMTP id a640c23a62f3a-a98f838de30mr290163266b.60.1727876508860;
        Wed, 02 Oct 2024 06:41:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwRbtorkfQnEgLoH126u7jMASiHc1X3K7k60KPoDf4Uvq08XhmDqGPPCIGAMX5Sl2hbplPTQ==
X-Received: by 2002:a17:907:6d1e:b0:a86:8917:fcd6 with SMTP id a640c23a62f3a-a98f838de30mr290159466b.60.1727876508383;
        Wed, 02 Oct 2024 06:41:48 -0700 (PDT)
Received: from redhat.com ([2a02:14f:17d:4f25:dd73:e931:ef00:4c45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c29844a1sm885087666b.172.2024.10.02.06.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 06:41:47 -0700 (PDT)
Date: Wed, 2 Oct 2024 09:41:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <luigi.leonardi@outlook.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Marco Pinna <marco.pinn95@gmail.com>,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Message-ID: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

virtio_transport_send_pkt in now called on transport fast path,
under RCU read lock. In that case, we have a bug: virtio_add_sgs
is called with GFP_KERNEL, and might sleep.

Pass the gfp flags as an argument, and use GFP_ATOMIC on
the fast path.

Link: https://lore.kernel.org/all/hfcr2aget2zojmqpr4uhlzvnep4vgskblx5b6xf2ddosbsrke7@nt34bxgp7j2x
Fixes: efcd71af38be ("vsock/virtio: avoid queuing packets when intermediate queue is empty")
Reported-by: Christian Brauner <brauner@kernel.org>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Lightly tested. Christian, could you pls confirm this fixes the problem
for you? Stefano, it's a holiday here - could you pls help test!
Thanks!


 net/vmw_vsock/virtio_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f992f9a216f0..0cd965f24609 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -96,7 +96,7 @@ static u32 virtio_transport_get_local_cid(void)
 
 /* Caller need to hold vsock->tx_lock on vq */
 static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
-				     struct virtio_vsock *vsock)
+				     struct virtio_vsock *vsock, gfp_t gfp)
 {
 	int ret, in_sg = 0, out_sg = 0;
 	struct scatterlist **sgs;
@@ -140,7 +140,7 @@ static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
 		}
 	}
 
-	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
+	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, gfp);
 	/* Usually this means that there is no more space available in
 	 * the vq
 	 */
@@ -178,7 +178,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 		reply = virtio_vsock_skb_reply(skb);
 
-		ret = virtio_transport_send_skb(skb, vq, vsock);
+		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
 		if (ret < 0) {
 			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
 			break;
@@ -221,7 +221,7 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
 	if (unlikely(ret == 0))
 		return -EBUSY;
 
-	ret = virtio_transport_send_skb(skb, vq, vsock);
+	ret = virtio_transport_send_skb(skb, vq, vsock, GFP_ATOMIC);
 	if (ret == 0)
 		virtqueue_kick(vq);
 
-- 
MST


