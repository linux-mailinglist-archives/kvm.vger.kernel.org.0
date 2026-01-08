Return-Path: <kvm+bounces-67382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1BED04105
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 16:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9399E334A98B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B546A3A7DE6;
	Thu,  8 Jan 2026 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cPlHR8Tz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9sH7pR8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2D93033E2
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881322; cv=none; b=YXDe0+qga7EOWPguG8GZVp4mMBwtOlgWGOVRVKiS2pTTHozo5ezvyxeMezzFnR6GbhehLZglayCPxh0ZVmgMjetCRUCA5sHhHY3RddijK/pvuqYSwwCYRtVCfQ5WDFGKGb5emhv+tfofvl9i+ROcQjcGSj82xe3DuNYz/YLu/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881322; c=relaxed/simple;
	bh=Tv7zh9Hk92kdNn+K2fPlpE9fTBNWYFWSvOonEurgOJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QaQS5FmMbRVwKnXpRpP0JzP/HvUuOUIFaR0nonQvXB4RFJ2aQ0eab00NOa4VGHQ88GF3TjiEYVJhUhpHIVwqqK64OPntE0/Iw8vGcOSCA2eYmF7Mu9C00CTQ5HORky/IoFNEKmCICnN2O2mCL2M3D7aJU2eUHAtCLvPlIWruSpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cPlHR8Tz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9sH7pR8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qb0opi0EkMyYcYBrprImauJ5+csaYa0bSdovEgtQBZs=;
	b=cPlHR8Tz94aESrXUVdCcac5UQVHHsJW/otNPU7Z8XsBU9skpLQOURiYsqesOtQL7lYN3MU
	va68COUfCeTUzAdz0lhNKqwp+79T/xszT4nfWaGSj/uPWHh54IZsY4Vyvpb1PXDJPKo0V8
	QLHEbwbrOAAWuSngoc132hdCDGIhwfs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-_nnE-3XHM1CJc2VEfiJ4Cw-1; Thu, 08 Jan 2026 09:08:38 -0500
X-MC-Unique: _nnE-3XHM1CJc2VEfiJ4Cw-1
X-Mimecast-MFC-AGG-ID: _nnE-3XHM1CJc2VEfiJ4Cw_1767881317
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b80716085a0so501787166b.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881317; x=1768486117; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qb0opi0EkMyYcYBrprImauJ5+csaYa0bSdovEgtQBZs=;
        b=F9sH7pR867jA/rHKxKKU/wpVji4GMqf5bUfz/vL/UajgRxivMXVN1rpc+bMD//MFem
         1/W8C34QuRmQ49nrCPu280beltecWuHq1ZHRIhey8IRNXFSJwnwFmr3n1XCxadOSXRTW
         aRQNsTndJZfe/+athyPIXMVHIHuJKSXtdJcQODBjYfw2l1dt7fi3IziyM7jZfem9OIs5
         Ui5Cc5tJJak48o9XioaoIpsOvshER1DSGt9a+BAUtuf1sUYim4U62vGBvUppT8EKllKD
         hjquDst3yF/i2CRxsABHhuJZQc8Q7GPqdOXx4evG9W63gV86858VQhDj57XNG8g09u5U
         QDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881317; x=1768486117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qb0opi0EkMyYcYBrprImauJ5+csaYa0bSdovEgtQBZs=;
        b=h52TE4ixwKEzSbaExdVKyMHRLlivUa1N9QoJgb21VPtBsQY0wMhOfSlCIBVmzOwpuE
         0ucK5/ugUuo+CLLXvA2pijgiNM2icFVvRllMKR1D6vvTy2sGsg0mmbjfQroUVjnxjio2
         EW8AW31FXyr83zCyan42F3OAZ0UIkTfhtnOYZPkQsIRAspplS57zrqAbfJAITsRMZ2Ko
         OFxJnWkMRQg66MM4zGABSaasaTyZhkYwuREfi2X8vyqTTJgQQV8QseiurgKXqQg6a834
         /6WhtO1mJ3mN+LtCu2KYNLthA/bBzkE9jSHcroAaddHXN7m9lY0uY2RjAgE83BI0dIAV
         jqiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2ii0Uzk9jzpm0DCgiIwvGn9ESB9KFt9iidNNUHouNMgRsDqpjZRNUMOfqsHsVsYzB/4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUIUCw6DJwO9ZG55C0qQNY/e7gdsAQflYbFhI7aOsJ6P29LKKz
	kPbsMUyVlY9WADQkeIs8dT2koeQzvE285OO34qT8msh9yZz06KNXXI38RXQe9oD1nvnqBaYryXF
	O31p/z0Xi4eG93zBqlsT56uuDHP4B+vsV/TF3643+10xg108j1FbEYA==
X-Gm-Gg: AY/fxX7G2if5PA9jfZ7rM7ttVgfWZqqmQj3EE879MzuPo3N5iwkA0KX1RXKnQt07iUm
	C3zkXNnJQUEkTGbDEZuLY+y/E+fSo9cRoG7Ewj/KgPUHpWoiEhE5QeGE9HVoQ1zL0jligP+wfSd
	3VhuIYfH8mhiN8wvdXUuIcUPWsQ5VQZEcq5OpLVxQNnq8y2f2/UHcphlDWiTchaZUds1KWRMIOv
	dCD3a6xuZBV/suejU1FfQyZtau8Bl1hZUjhXFYm+tIBD+5R38rc/vzB2oX1KysjKQuauZoQyUeL
	nw5gJJxBIRdi0YemsD3tBXL231WKC3aMmMhEzZjlZSiiBlCRMbUgNbRsV0IwCvKtnEjFgdypiOp
	2bgIv2DZFVHg1ENKS
X-Received: by 2002:a17:907:7b89:b0:b6d:6c1a:31ae with SMTP id a640c23a62f3a-b8444fd453amr620664566b.49.1767881317029;
        Thu, 08 Jan 2026 06:08:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7HOHiWGYK4xorotJbNX0jMidX1ixXQJJ1VdDBrRK+mMgTkrWVhdGn0FKO7KNa9bc9HZtucg==
X-Received: by 2002:a17:907:7b89:b0:b6d:6c1a:31ae with SMTP id a640c23a62f3a-b8444fd453amr620660466b.49.1767881316491;
        Thu, 08 Jan 2026 06:08:36 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2cb447sm843387866b.29.2026.01.08.06.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:08:35 -0800 (PST)
Date: Thu, 8 Jan 2026 15:08:31 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 08/15] vsock/virtio: use
 virtqueue_add_inbuf_cache_clean for events
Message-ID: <aV-6UTKChBhiTynA@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <4b5bf63a7ebb782d87f643466b3669df567c9fe1.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4b5bf63a7ebb782d87f643466b3669df567c9fe1.1767601130.git.mst@redhat.com>

On Mon, Jan 05, 2026 at 03:23:21AM -0500, Michael S. Tsirkin wrote:
>The event_list array contains 8 small (4-byte) events that share
>cachelines with each other. When CONFIG_DMA_API_DEBUG is enabled,
>this can trigger warnings about overlapping DMA mappings within
>the same cacheline.
>
>The previous patch isolated event_list in its own cache lines
>so the warnings are spurious.
>
>Use virtqueue_add_inbuf_cache_clean() to indicate that the CPU does not
>write into these fields, suppressing the warnings.
>
>Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> net/vmw_vsock/virtio_transport.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index bb94baadfd8b..ef983c36cb66 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -392,7 +392,7 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
>
> 	sg_init_one(&sg, event, sizeof(*event));
>
>-	return virtqueue_add_inbuf(vq, &sg, 1, event, GFP_KERNEL);
>+	return virtqueue_add_inbuf_cache_clean(vq, &sg, 1, event, GFP_KERNEL);
> }
>
> /* event_lock must be held */
>-- 
>MST
>


