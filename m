Return-Path: <kvm+bounces-66834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD71CE966B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DBD130E1C9B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3D72C21DC;
	Tue, 30 Dec 2025 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUV93+Gv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8kiRJdc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850AC261388
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089777; cv=none; b=I9Rav/TIiIQmSk/6UVKClHepT+HhoflOzU1ZqIYlPKxsEhiBRPvwBOtCmFJLLxsxtW+wGGGaMrzgG/wofT5vzSC71IsNg/lS9C2lQ+4+Wrnl+cxN17L/EPiugemIFItQOnEP1JlJXcO94tDUDC3dWRpCohsfLNpMDwsbVm27DWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089777; c=relaxed/simple;
	bh=1nvGVVfYMss4t3CEcUrrF8Nk2cSppyMGKm3YyiTIiKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bm2jmql13zg90hb2QWkYqZAZace7ZLu8+jVmNjpSnWisGJxqk50ZE+XzWuvJvEWn6dzlYrQ4miuI31a0gwp5klGjFXmUFDDs92YZcy9jmfKrzFHAJcks/Zh/UMQtxSGrNmFTJ9PZCgXehpqJtmkDC7ufn/6FYvgpgGEaFEjeJwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUV93+Gv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8kiRJdc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
	b=JUV93+GvNWX3nxpTw8cau2vP30RBijuoxCYWrIDxyYcvX4p3XvCk95xccbON6+L/U3eb9t
	si8hWuSvT4Mt3QErEjU5PTb0AlztpEMPM3HXaJlVfXud/33UjYfqDajJuESmoRTs+TkhT4
	8bBFTetu85d5QnbDKsQ6WrE2G/IJ4h8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-oFS-Q-NSOdigZ2-D-NLB1w-1; Tue, 30 Dec 2025 05:16:12 -0500
X-MC-Unique: oFS-Q-NSOdigZ2-D-NLB1w-1
X-Mimecast-MFC-AGG-ID: oFS-Q-NSOdigZ2-D-NLB1w_1767089772
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477563e531cso66031665e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089771; x=1767694571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
        b=D8kiRJdccnjA7UBfQdPD1dIdRkpZkqA8vResLYU9t9f20l4nQJx5GuLg0IRRo4HmkA
         Ez9QUd8ztax/ZM6qlWpStt6ig9rAwGG18m9odbjAYC7V/8aib3iWrs8f6Glxnfo92e6M
         kbzp51OUt/jpLMIaQ9dSi354rrPCe5h6M+dOEHdwzUrk1FtyKjQU3A+QpWIY5VrGfgPZ
         GasDPxSRI4RFXD/RE1XwOWs4ZpqcTdTHkb9bC/VEyiOzSm70/GLjGNOKak5FNDBdiJa7
         ZMR2k8LgePJspuqK6/IhpTuKlpvOtJWOoqS7UikPR07hhtZjj/ERppykuPbLuGVi1fLU
         yJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089771; x=1767694571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7TdGrHAal4YSCbHD/e5fBMwf7XbmUGP5Z2mh/ui0sA=;
        b=ZKuvU/Ibi7mKR+O1rYG1usvYdn+Z7ExMrL6ZLdXRaheZrevBgTisJnKEjwotwub7Z/
         rE4PBAxZk7ksWAuZfs0sQVIRRch/3YWayTHnmCvD3SytdY4UUY6BKXdUFuxnGEs7KMJX
         pHzlMx2NG8++Vns4GajUjDxJJcDw+eFc3SpnRJCcjL+K7AYxnVg13KTApiS5mC1hZihF
         CC8OOxsMKt7J56xK8mbaHqrNlcV97VOswcB7YHM4R+I3tQsZHt3FMwn7wDvDaJckb19w
         R9kBKlkS7eRtNyyKZqdnacqCJkltE62KRYb0X8Mo+GY9fTKVFedVPt9PYeRNvuKtsUp7
         9D8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVN1JkkLU5MpUjxaKz3mL9RO6/URnSBb0bvEeyp8yZCHLP5ISaMg3cLFOOHKisAIdbFj8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyskBU0uYxhdPVWHGUFhK16fHZeIwRYnlUlbiEcauuGvQCtjljR
	ugGS9u6wWQeFQwtzNLoLS+r3Z6GPSIF5/gmUXRKba5mofaY1pfsjLWwihP9/bR7a892tJFmwz+p
	CVkXIOPPT3YQVIxGArtk0oiGqc+B/xTk/vH6CitgZVtdMF5hWQKq+aA==
X-Gm-Gg: AY/fxX7IQBnlcck1J9wYOpb5NFZ4tCcw4giL9RsADncY1ZJ113uNeF00/HIWGXxgyen
	8z0LQ54lIOY8YzJ9Hm141Drpc9swytCR92A6CtBz9f7WM4S5lFlEb7JTvv7Q6NZ56Lx/icPFTDw
	LisWnrYsxagdqcoNeKH285d5sALlAWr7z9H4Qbt89oBhGJH4Tmg7T8uzgIzhbRVKRmVlv3Lv3kK
	c+vVYrgr/qt1T1gvNz4mQuBd16E75tzfB5aYo6gKngFRUYpVDVTZDthPMggZ+bfkF3qJMkk/Qq3
	JtCnM7A9HgyjqIq609+ZOtf+xY3OwvU6FPH4qzK87sikI5QtHLsfg5c6QmTyjEolMS0mgYZnUbM
	Ftw8dJ4LlzaXRm5wQUV/LBbrzfg7eCAY/cA==
X-Received: by 2002:a05:600c:45c8:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-47d195558bemr375729635e9.11.1767089771385;
        Tue, 30 Dec 2025 02:16:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjzVX0GYuttaIVhsj3PIAp1ZJ2Zp++QasW4yFBwV4WaDkrZ/icz8/Y8CMg+xDJDk6ilEld2g==
X-Received: by 2002:a05:600c:45c8:b0:477:8a2a:1244 with SMTP id 5b1f17b1804b1-47d195558bemr375729355e9.11.1767089770967;
        Tue, 30 Dec 2025 02:16:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d4e91sm569777955e9.13.2025.12.30.02.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:09 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:07 -0500
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
Subject: [PATCH RFC 07/13] vsock/virtio: fix DMA alignment for event_list
Message-ID: <c195bc45032be85c3f0bad7362f0ba0a4e8a7726.1767089672.git.mst@redhat.com>
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

On non-cache-coherent platforms, when a structure contains a buffer
used for DMA alongside fields that the CPU writes to, cacheline sharing
can cause data corruption.

The event_list array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent event_run and guest_cid fields are
written by the CPU while the buffer is available, so mapped for the
device. If these share cachelines with event_list, CPU writes can
corrupt DMA data.

Add __dma_from_device_aligned_begin/end annotations to ensure event_list
is isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 8c867023a2e5..76099f7dc040 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -17,6 +17,7 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_vsock.h>
+#include <linux/dma-mapping.h>
 #include <net/sock.h>
 #include <linux/mutex.h>
 #include <net/af_vsock.h>
@@ -59,8 +60,10 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
+	__dma_from_device_aligned_begin
 	struct virtio_vsock_event event_list[8];
 
+	__dma_from_device_aligned_end
 	u32 guest_cid;
 	bool seqpacket_allow;
 
-- 
MST


