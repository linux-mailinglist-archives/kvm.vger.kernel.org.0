Return-Path: <kvm+bounces-67380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4332DD03950
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 514153024B9A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AEB4ED482;
	Thu,  8 Jan 2026 14:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UF3RLuvY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="shfpwgPb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2510F4ECFC9
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881072; cv=none; b=DWgGoa1O1hVyKr40+QeHqNGj1sYjuABYFUbqyz09SDU8GvyPxq7VOpMCWGXfq/eCfHkU5HgMkq1yC/3DOnmjkHBWprlfkX9jah9q3+iQcf3ygNt/YL/URu4kTvfrgfBuQ/UokttXKgxBECSmDwvDxTfFu0pIcWS0JYjVFjB8MlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881072; c=relaxed/simple;
	bh=yXMok8JlOEM2sgAIipul0a74lzFqWXRhO2Aov20FAgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SNpKaX/CXm9/jPPRYW6f2tg+qCKgkD2v9jVaGI6fbvtKIgtpLddWryA6nUgfaI4QNHB/E8zjpkAIP7x9obU42YeaJ2526w79RNw81Lvzpq+AGhU6QGD4w628LLmavaxeURoA2mUwbErG5U8LAIVjjoByQr1XhnCzoF/J2Fkc5wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UF3RLuvY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=shfpwgPb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FmGHhC+vkdZJgHO0r54G5/mI53k1eZnkbsYL2uSG2DQ=;
	b=UF3RLuvYJBY5RjSmvxQ6zCy4LCIq1tzeAReT9cIp+jzDXHSIA4JXqYkWxlZ4O1zgbTl154
	1nNN9KiuDZU4d9Z1rTKvbwpYKi0chZFPJmensz/7eSzaVYN9ixJ8pZ9NFtaLQOJMHF6Xz0
	TDmx7kkamKn+HUBwaJZQ9YpG1X4XqMw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-nqX-V_KwMIaXVXEAEzbr2w-1; Thu, 08 Jan 2026 09:04:28 -0500
X-MC-Unique: nqX-V_KwMIaXVXEAEzbr2w-1
X-Mimecast-MFC-AGG-ID: nqX-V_KwMIaXVXEAEzbr2w_1767881068
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b80055977feso445441166b.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881068; x=1768485868; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FmGHhC+vkdZJgHO0r54G5/mI53k1eZnkbsYL2uSG2DQ=;
        b=shfpwgPb9LiNC4RMyXNeaAydM+O4PgXrgayaVFh93s4USaWOAaWjZpVwiy1sXwxVba
         +joVYqHfHeZAptMJrIAHxN+Il8KeIwX8vLznxxcMIJ1fFQz9JXdXx2vk2a4I/AHdyxva
         cTYY9/tSUdMp1ijSF6MFKiXUxA6rpdXMRu7eAD38oCh7tocT1ncw0/5GVNMy5MP5ZtPS
         5k7qSgFQaTfMXylcEdtmyZ4XyiK+iNaTqnFVtbMaa/dVgCM+4h99Mdg0JkPDzpZltGlK
         gsh2k9LQwfzbiZtioTg9D9HsFjFqKW67YV/ABUXh53UzuP7Rh+1eYW9ysm1SKRlaoP+9
         3Tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881068; x=1768485868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FmGHhC+vkdZJgHO0r54G5/mI53k1eZnkbsYL2uSG2DQ=;
        b=FzIBhNcFFdsNKSqeP+dyjgjqEQJqXmlUhBIphqFV6hgTTvgVEfqM8+xblxGDOwHCbc
         ZbSJWslau1UF0hqYsesD+RctDDPbdH528jgwHpPaHmE2wQ1aGmaAS1KYraYdWaD79hTL
         pNrn/5T7vyFNB8ISOm8rB3AdfWvFe5gs0nxYSmlsxllJAltFVLxd/Es3eYn+uwIEdHaG
         kdMKWLVLHF4c5PzXvDENnv3Ng2KfuSww9oZAyaqHqJUVLik7gZwhaF4uAAOFfkZBFJUi
         y/Rfy5vwFdaKx6OuSjW1tuOiy7l/w1PqlO0uIWjXghHtmha5tROQBI90JymH6Q1qH1CF
         hNLA==
X-Forwarded-Encrypted: i=1; AJvYcCU5bM8ucMGs5ukI7Zo5vMBDODRVXrQKCr16D+tqJjHqRHkL4nYk/n+iZp/KPbXhtuoMNZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCRK+YHx/DnV4+GO1hUFqKqsPYgfPfd08AJYlGLxtP9NEgF4fN
	XeqVEpQzhsDAthuHpDwrEyQqq8ujQQ0a+DNmR/u3PfY2kQUjkQO951P7UUYU99z7g5ZAzNGd466
	2SOzjBgojeq9sIXpSfdhTsp+u5gvnzhIPlpJBucFZwhOqtjtSlXKeWw==
X-Gm-Gg: AY/fxX4/XhEFnpPlr111IYdhzlrWbIKyRikzvhv0HCkus1XAuBvPP5GeSzYsFoHX0Ts
	XwRITGZSt9fusaDOLF+QS+/FSgWbpaWq8CdUEGAZd07UP0ly09zaurhrGf4iJvnx9HIm3KHnxKK
	hU2QXCAUJv7sbmLZ0BNzoioEl9OV7oKdqqPdLWceqTguZmcRRVmdloH7fIM/tp2WcNuXN6nTHDp
	lqVv7s2uLcjkpRDewYLvMj23JW1Mm0HlmLe9YouTdxWzeFTuhHS7duHJZonh93k5VejGKQwC7/h
	6kxH3F1CZI+YkwrUAj/7oxaxTtCs5Et2sn2BNGhDJw9en9nEUwpMxUKHE7c/xrFgkc5KverY3tF
	XlIyrbGYsUaxh+QIS
X-Received: by 2002:a17:907:3da6:b0:b7d:11ae:4006 with SMTP id a640c23a62f3a-b8444fd6743mr637892466b.52.1767881067702;
        Thu, 08 Jan 2026 06:04:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgw/BdfC1kapmuRYU6+l1S1c4vqL+ygT6gHm7yV/BgYYGWFixI2eOd8lpv0XHKoQQX3Zl7xQ==
X-Received: by 2002:a17:907:3da6:b0:b7d:11ae:4006 with SMTP id a640c23a62f3a-b8444fd6743mr637888166b.52.1767881067171;
        Thu, 08 Jan 2026 06:04:27 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a564284sm830039366b.62.2026.01.08.06.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:04:26 -0800 (PST)
Date: Thu, 8 Jan 2026 15:04:07 +0100
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
Subject: Re: [PATCH v2 07/15] vsock/virtio: fix DMA alignment for event_list
Message-ID: <aV-4mPQYn3MUW10A@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <f19ebd74f70c91cab4b0178df78cf6a6e107a96b.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f19ebd74f70c91cab4b0178df78cf6a6e107a96b.1767601130.git.mst@redhat.com>

On Mon, Jan 05, 2026 at 03:23:17AM -0500, Michael S. Tsirkin wrote:
>On non-cache-coherent platforms, when a structure contains a buffer
>used for DMA alongside fields that the CPU writes to, cacheline sharing
>can cause data corruption.
>
>The event_list array is used for DMA_FROM_DEVICE operations via
>virtqueue_add_inbuf(). The adjacent event_run and guest_cid fields are
>written by the CPU while the buffer is available, so mapped for the
>device. If these share cachelines with event_list, CPU writes can
>corrupt DMA data.
>
>Add __dma_from_device_group_begin()/end() annotations to ensure event_list
>is isolated in its own cachelines.
>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> net/vmw_vsock/virtio_transport.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 8c867023a2e5..bb94baadfd8b 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -17,6 +17,7 @@
> #include <linux/virtio_ids.h>
> #include <linux/virtio_config.h>
> #include <linux/virtio_vsock.h>
>+#include <linux/dma-mapping.h>
> #include <net/sock.h>
> #include <linux/mutex.h>
> #include <net/af_vsock.h>
>@@ -59,8 +60,9 @@ struct virtio_vsock {
> 	 */
> 	struct mutex event_lock;
> 	bool event_run;
>+	__dma_from_device_group_begin();
> 	struct virtio_vsock_event event_list[8];
>-
>+	__dma_from_device_group_end();

Can we keep the blank line before `guest_cid` so that the comment before 
this section makes sense? (regarding the lock required to access these 
fields)

Thanks,
Stefano

> 	u32 guest_cid;
> 	bool seqpacket_allow;
>
>-- 
>MST
>


