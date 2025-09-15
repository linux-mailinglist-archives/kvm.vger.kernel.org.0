Return-Path: <kvm+bounces-57588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D113FB5817D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75A9C204918
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ABB25D917;
	Mon, 15 Sep 2025 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVZ5gmm9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5411F248861
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952213; cv=none; b=LZqqFDmnRiCbe6oBworomY/9ihhfWkHlRjs2qXUGtWxU6x3vrNo9RLtsZVmVEGmeYI1GICIvmytac6Osv+NnsxstqiprqnPPUhVm6KhsvAz6T+5g/T6o3CmU+9zXyEDOMEoPBu5FfVQD0HNQsXTYPodgRNfbt4Pe1ixNWv6Wb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952213; c=relaxed/simple;
	bh=BAS0GBMKCDtwydPahpuw2HyfF0E/Y0qQ4Zq/+5p3ac8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4g3tA37ha3N+HQpp7lOMeHNhGGzdD3Dsp8TLElAAPBhmaN6zdyiH+TZL5nBzW/t0Kls+joihZDwnEz/POjsehYkPv1bu6zPt7petU6mOUxEEqzg+xhg0Xp1Y5nOQUltd3OTTiblPEUPgePX2xYIrpKVT0M3ki9R4DbqtnuV4Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVZ5gmm9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757952210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eMxsZvyoTV3G/hm1yNnpqqa9WqA68QAPsx4b+ZiU9Ys=;
	b=FVZ5gmm9600Jd5Rn5WQ+jC5HpIh/KIoy/u2nEqyUpqX7TdQDJ1gR7vyOMDyQstoz7+MRul
	v0O2ANwNWosumRy/3DhPe3eHwtKZLutHsQALjHX9q+vlTAvV1o3/HobNv5n5GM0vdG0Zwn
	hBSIBekawI8x9/7NBLV+P2r1GixqWO8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-HSzFdgRpNPmnOjhdfybCZw-1; Mon, 15 Sep 2025 12:03:26 -0400
X-MC-Unique: HSzFdgRpNPmnOjhdfybCZw-1
X-Mimecast-MFC-AGG-ID: HSzFdgRpNPmnOjhdfybCZw_1757952206
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b0467f38c91so549982566b.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757952205; x=1758557005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMxsZvyoTV3G/hm1yNnpqqa9WqA68QAPsx4b+ZiU9Ys=;
        b=gjn9tgcVbVTf6Y6/gv1td41IyyG3Dy3eb/cpE35SRrto7YPFF3X6GMIyzo/Xs4jgVB
         XB7UxOp7jh9zaxBxctK1pGxnStIdeqVSR7oxB8RvHcRylLIBgKS2XfeB/1GM43aSLrgD
         qIUCFfqL1NIyEM8HsoyeEvlRq+6O81Ct4XV6oc+eZ3Jzt0JqyRi53tq/98wBaJ/X8TpK
         8QxAJhliQQZetbn+vbSRoULa5keP5DXcpsWhcIYRqtclLpwD++qAYV/jmLTeETlK1h45
         6bll05Cv3Qu1dVT2CVTureZ4jqNrYG9RyI+lzhKRPFPU0mfgbsAzPyzjVcPxNsF84lzQ
         83FA==
X-Forwarded-Encrypted: i=1; AJvYcCX8DPOTjiVgcKADHtxT1eZbljaMB7pcMj0b91T/Id1DxqWeNPyhmvZ0vu3fikPKcrMgoV4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3PiJCnjPguEXdroEj+vnMiPb7WNhnG6gD/Tm0tQwzv0nNjZFs
	yCkRs/TzOVE7nZpj7qxsDHRqEdhhKotyYKxYC6Ce2Fl7KfyidY31NDogIS/mj0d+TSRcMd3Aw+m
	2KYWV9biuBJVLveMN/s5wPyCD/Ln1C4Ufk60MNFLDYZx6RhcaoDdgDw==
X-Gm-Gg: ASbGncuV2tBLZ/irLJpE+KzuDrtj4LhUDVBt0ztTvAO43WYSzzOeTNgby0owl3s+lZI
	FYCGJpqF1FHy4nYNcjHnc9eFDCtmORGgdPcTYwONbvTpI5v6NoAcYTadMMTNMNg8AoQW+Ss8102
	aam7n9cO6tzhYNB2I86eeo7c5GQqNIoYnF98SnwfMtkj7QhnCED9lqhYt9Xfi7bjSRrqOylQMFS
	/CSQ+AIR1lavVoDMSgAxKYoMsOgSmMPY+igt9b0ie9W2/a2vZZgFNY/Sikxc2xd9FXZaDLh3skb
	SHa6VFqqEvhmXkCFjQtKOouNs9Dt
X-Received: by 2002:a17:907:9408:b0:b04:97df:d741 with SMTP id a640c23a62f3a-b07c3867766mr1173786466b.44.1757952205448;
        Mon, 15 Sep 2025 09:03:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMAUdK5dLnmNqeaAzIQ4sLNIVdJ/bLJv6BqI8ieVrFaCmiktbN+iyKUpr58pZivx2Iqu/CNg==
X-Received: by 2002:a17:907:9408:b0:b04:97df:d741 with SMTP id a640c23a62f3a-b07c3867766mr1173783066b.44.1757952204919;
        Mon, 15 Sep 2025 09:03:24 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b2e7a35dsm1001013466b.0.2025.09.15.09.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 09:03:24 -0700 (PDT)
Date: Mon, 15 Sep 2025 12:03:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>, netdev@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, stable@vger.kernel.org,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Jonah Palmer <jonah.palmer@oracle.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v3 1/3] vhost-net: unbreak busy polling
Message-ID: <b93d3101a6c78f17a19bb0f883d72b30f66d1b54.1757952021.git.mst@redhat.com>
References: <cover.1757951612.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1757951612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: Jason Wang <jasowang@redhat.com>

Commit 67a873df0c41 ("vhost: basic in order support") pass the number
of used elem to vhost_net_rx_peek_head_len() to make sure it can
signal the used correctly before trying to do busy polling. But it
forgets to clear the count, this would cause the count run out of sync
with handle_rx() and break the busy polling.

Fixing this by passing the pointer of the count and clearing it after
the signaling the used.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 67a873df0c41 ("vhost: basic in order support")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20250915024703.2206-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c6508fe0d5c8..16e39f3ab956 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1014,7 +1014,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 }
 
 static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
-				      bool *busyloop_intr, unsigned int count)
+				      bool *busyloop_intr, unsigned int *count)
 {
 	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_net_virtqueue *tnvq = &net->vqs[VHOST_NET_VQ_TX];
@@ -1024,7 +1024,8 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
 
 	if (!len && rvq->busyloop_timeout) {
 		/* Flush batched heads first */
-		vhost_net_signal_used(rnvq, count);
+		vhost_net_signal_used(rnvq, *count);
+		*count = 0;
 		/* Both tx vq and rx socket were polled here */
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
 
@@ -1180,7 +1181,7 @@ static void handle_rx(struct vhost_net *net)
 
 	do {
 		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
-						      &busyloop_intr, count);
+						      &busyloop_intr, &count);
 		if (!sock_len)
 			break;
 		sock_len += sock_hlen;
-- 
MST


