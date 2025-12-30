Return-Path: <kvm+bounces-66835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD86CE9734
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CFDA430164C8
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780322EBB98;
	Tue, 30 Dec 2025 10:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hx27djo6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlNCUSCT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52A02EACF2
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089781; cv=none; b=QRdT1/ys84/xtuDsQj6dm9IOUK2WrfZvi6clrq7HpTuRiyAKXuUefFoSU2QKT29SN7ErBhXJ5x8ivUM5hAl4km7lGd1tRz6hOiL0kLLvh5uZyxnpdd/XrSlgUBZMAb2P5rndd7nMvhsdQyRHgMZYuEsihdkcea0JZwEEsKQodqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089781; c=relaxed/simple;
	bh=d79M2iBKtK7/e3UWQBP6Z7XMZcGHJdPNMKAqQ6Eyk7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZ1IpEAmU6UwYUmnLcnxzeSXM7WU6NvhX/76Cs69TVg0KezQKmnGxOPZcbLPKNew+QSAoaGq2+Nds3OX6zo3vS40BUOHPpoLVKp9K2K7HVEugIxVr7WXgywRUvNY9+Ios0eM6cVsB0SEgXzwdNeaSMijYHHLPblaZ65Tc5Pxz3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hx27djo6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LlNCUSCT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
	b=Hx27djo6x77GeQQ1lgTSKc/rpiU1WdokGmJc/sZ5Z9orN3COn1wNf3Tzt0v86p+rfoMn0N
	CJDZRinML9rxytkRt0M/BsAcdQFYr5z95bCdTEFMaieVJ5oTRPJOGYcvDzUKKM+vqA40M8
	uAHiqfhGbM+tEVcYbRorSWHsEV56cf4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-xvJISFtgNJazSeRmNcrqNQ-1; Tue, 30 Dec 2025 05:16:16 -0500
X-MC-Unique: xvJISFtgNJazSeRmNcrqNQ-1
X-Mimecast-MFC-AGG-ID: xvJISFtgNJazSeRmNcrqNQ_1767089775
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-431054c09e3so5919455f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089775; x=1767694575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
        b=LlNCUSCTByjGB0z6MsJ1GKRqOrCxKlKxKzGbqSTZscLcZoTmQ33rpW4PooijX2SKVN
         GdkPVv4kz1LwJMCcxDEH2rdpeJZYlU2q2NV15nRJomG3W4VdIg1TwNBnMdL6duDLsEj6
         SITH5U1beqZ3WfDoinZ5ccYNG8KVhPM25lpkP+r6vRtu77abiGOAOUNe1a4fZcHjaOow
         QyauQS7ID7RPNlGTYYk4/rDckAGeF6YvUt6WatWjvM/7XW0IxNcVX2ZRhqBuR/wR0Vo/
         DXHHdKifRDH6ve+UEv2h217bxnJzEdsyVFp7qYUm82SPivQVvNpJTZT/GD/aKchdj5cO
         BPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089775; x=1767694575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awHY3MD6YI7UgDTD6QKfkNuaN+VrZkEZlRiSgXqWnPs=;
        b=hqcvNB+li01pykToI9gI1p7paKDRVXkwEG+vAxFxzArFYqZJBk0x8hoP4Aoqr0j3+4
         B8ska5bT2guY06sy1lTiG5PDF96ZaayMTn6Eokv6cB844n4/ECK3gMYyDIdQG5TBM6Nw
         9snyQ/Sh1/Bv6ygkXk2GFM/Lbfx5H/RF9/wiQHszpE7aPBdU4Yistxt5AZUz0XA/1gIu
         xK6iqqFdt4uGkLNodcEkOPRjXgmtaS/i3mN7lb/ERcoGAfiyUGHLh5hHfk08wqU5Oomd
         D8PCJHl/T8MGTr0DvU8yow8j6VvbSdA36Jqij2zt0V270X81UCbhO3tI87lkcU+fybc7
         p7+w==
X-Forwarded-Encrypted: i=1; AJvYcCUspdtGs0j2QiL2POGgqdALMwSif1pACveu089yr0URqjTagWxpsX6B2wso3jP5ILWACoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFRJ/XYDp8pyKQU202pmS/AKg3JgjLugqZpz1JZvC2UVf+xv8k
	6DQWkGtERBGXOA1cUeAkUq+daI/jGDb3yZWBoPk11ApKjUOsAGBXO851F/RaSWHUMeFb8jCESZ/
	W9z1cs/IT5rCWRU+yGLTW5ym9vfjBzKHXSb3ZskFnbKjlPpxH5jjsog==
X-Gm-Gg: AY/fxX4WbJvipzcKV7u1wXCaHGuFNLhprFCXXnefltjNCouoYwQ97gKgUkAnAQzF1jf
	/WavjWgWsSSwymlVPmHE9bwU8Ro11nFFwyuMS4CksKcxQ+FdMEkUW1lJRjUxbO/SIK2StjGx8Ay
	IgwAfop5l2CWooHT0MViF9MqrBVZj3hnGWGTgxgsOYccMvU4Nm7mkt81GRQ+o+x9w8AXoA3QmO7
	wtS4FfMXJXs8tL8DCd6R+iMNJ3OX2CxC8XJZP+I4/0DrUuMu25qL8jSkpmVcbzz4N1lUb/PFkUB
	9UpV2tjPoE81Ev68+BsxOqUOnFgfYoTr07HTvw4roGRs/VzTA6lbIFASbJQ3QxsOEZCQpLIM1QR
	5qDDKR1FcDVxksu0bQFKMLmIiHEsrb9ao7A==
X-Received: by 2002:a05:600c:500d:b0:47d:576d:8140 with SMTP id 5b1f17b1804b1-47d5b261006mr54434045e9.24.1767089774872;
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhdLHPqUgLnPyVKN6hwhRQFuXWAPZjO+w56XwRJ3KNAI+UkHXfY0sXelHGWgys0dAYrWVbAg==
X-Received: by 2002:a05:600c:500d:b0:47d:576d:8140 with SMTP id 5b1f17b1804b1-47d5b261006mr54433635e9.24.1767089774436;
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be272eaf8sm630015255e9.5.2025.12.30.02.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:14 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:11 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 08/13] vsock/virtio: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <34e5e1af186fc92ab4ea6cf6c9f5550a40c9567d.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

The event_list array contains 8 small (4-byte) events that share
cachelines with each other. When CONFIG_DMA_API_DEBUG is enabled,
this can trigger warnings about overlapping DMA mappings within
the same cacheline.

The previous patch isolated event_list in its own cache lines
so the warnings are spurious.

Use virtqueue_add_inbuf_cache_clean() to indicate that the CPU does not
write into these fields, suppressing the warnings.

Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 76099f7dc040..f1589db5d190 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -393,7 +393,7 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 
 	sg_init_one(&sg, event, sizeof(*event));
 
-	return virtqueue_add_inbuf(vq, &sg, 1, event, GFP_KERNEL);
+	return virtqueue_add_inbuf_cache_clean(vq, &sg, 1, event, GFP_KERNEL);
 }
 
 /* event_lock must be held */
-- 
MST


