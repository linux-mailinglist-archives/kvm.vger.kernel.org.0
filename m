Return-Path: <kvm+bounces-37226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3028A271A7
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BBA71881849
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 12:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49E920DD75;
	Tue,  4 Feb 2025 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QE75jh3Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4BB20CCF2
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 12:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738671348; cv=none; b=T9MDftcq7blku3ABtomkEfkqQAAOAitYM94xDrbbZ2XBsdeik+BXsaPdy8MV/xkd/dI1tDDge5E/DmJ0wBz53U3eLIVhxHOjR6dRNSyW0K7uGSF9aozFN3HLkduLzjjwgULnsknM2ZNnyB/u3ttMa7zK9T3jtMjVuraOhMa6g2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738671348; c=relaxed/simple;
	bh=XhIT+5be0aQXVhwv9QulCCNPuCzXKuKQuv2PR3ezl7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ibc0cx7nXLJIs50l6xR5NvC6fDi71GrXcCNWPPUbEJ1QPgfftDNNYLeAbUH1/nZ/pXZIxyFSZCu5dhkCRWJWjio2Qn5G71y93gKgqrrBLGTwcI+ZHXM8gZSc69qNmqMZCpH0rL2NFPEyS9nGiUtu9cTWxOJDUkyIRWLX4yFTXXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QE75jh3Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738671344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VUvkUC7Qb2mF5GiMgDLACey09zZYlr7i7/mTZlGsGks=;
	b=QE75jh3Q5eWgElEPWQ6oTG9lZOCOdbZg0Yv1JpVTYegsfL/ZxLlEAuXlJUYIYgZE4ezBdb
	RwBLFfb/ATLvoKRiziHDjgT/Qo6cKQTvn0KgZsyBxg9Gfb0Psm8f38IUj/Iw0eaAr//i6k
	JesCX4haJGJl5KNpqh7P9H2HhVi5oYs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-j8rIHXjXOJ6Hx9w0DQkc1A-1; Tue, 04 Feb 2025 07:15:43 -0500
X-MC-Unique: j8rIHXjXOJ6Hx9w0DQkc1A-1
X-Mimecast-MFC-AGG-ID: j8rIHXjXOJ6Hx9w0DQkc1A
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4362b9c1641so27522235e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 04:15:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738671342; x=1739276142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUvkUC7Qb2mF5GiMgDLACey09zZYlr7i7/mTZlGsGks=;
        b=rAU68LeR8ofiBg/DG7iQIXqKVcof1Vt66AjfHaG0APnvFk1NTaZZ1f8hhR8lPSDhPB
         21DwNB6UH8qoB3VWczsy6TPNhZHsIS+iJlTc994YU1JauL5CnwCa886zedXCWDWgp/ZM
         apASyIDb9UJdjhvTju8H5h1vUhzJKvV4c2rFYHTvrrJDMAzwIeZv0zUx1o94IaWxUz2n
         Dp8Rse4fUq7RpKpwvIIgQ1vgrQrSkpDQWqSpbpztdyQM2hVDQt9ySj+/PDppd2nl/gUv
         /a5Vq3h+MZF1TtuJRIBCGgfeqBH8np1d+VJ95tUJVh7uHPApZDGkESzbCBtOW7lSG3Kf
         GIoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDd16nPxjYQq0w+iQ33/HBxr6Uzvfm9CmrCzUbphvMczAYLs1M/OF2dwWFuvqqpw3b7Mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YweWLl6qMZFNlzlsCwepFNWEFov3Dr2dxFrTW8qHffc+LeUZ4SO
	6vCC64d9t1dyu9XggSqHPF3BIqaOujJKud7VaCiGtmLhOIpKG4GpV4aIhBoRudYf0YtvxBDwib4
	8nXw6Kdoof1UT3Kiht1VugXPb6VNIvuLJId+aW9LtCCHEiHBxGg==
X-Gm-Gg: ASbGncuIMkKpw2tExuCuearHd4V+H/vuWftXSlzB8OAuG/eKm+KdA20SArxgu49rPvL
	o89bpa2BW5SnJ5AScl/q9cvJQGVqt9AIQAsak2A/PyoTkzRZbpJ3k+jr0lUhVSTBi2FtVsXcwmP
	6x69hSWxio03rpK8PzG6vDz7uMJmPgZPRy9kofiJDv4BnGwhomnvtMlr02bGOmjXMWKlj8WVQ6O
	tk4LSYAb6Cl+KXpIMbv2I76hLd9n6980btdJeV2g83cFtTCYlYY1NiqhkVLpBZkk68OW0Xl5G6R
	zgFG8fC+K2SVGkrn2CQl2Mhna+9YsZscUaY=
X-Received: by 2002:a05:600c:4f55:b0:436:51bb:7a43 with SMTP id 5b1f17b1804b1-438dc3ab675mr242755195e9.5.1738671342064;
        Tue, 04 Feb 2025 04:15:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4tQ5q9E6Yxu+JN4mWimlvj7yjOo3f8Z7rh6yaBUL8ZjGCY5yo/S+gH10TnPYvFIU94EeRnw==
X-Received: by 2002:a05:600c:4f55:b0:436:51bb:7a43 with SMTP id 5b1f17b1804b1-438dc3ab675mr242754885e9.5.1738671341707;
        Tue, 04 Feb 2025 04:15:41 -0800 (PST)
Received: from [192.168.88.253] (146-241-41-201.dyn.eolo.it. [146.241.41.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e23d48b3sm197508285e9.5.2025.02.04.04.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 04:15:41 -0800 (PST)
Message-ID: <09a0caba-db29-4100-a46d-b104b282ea0a@redhat.com>
Date: Tue, 4 Feb 2025 13:15:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 5/6] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kselftest@vger.kernel.org
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk,
 Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 Samiullah Khawaja <skhawaja@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>
References: <20250203223916.1064540-1-almasrymina@google.com>
 <20250203223916.1064540-6-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250203223916.1064540-6-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 11:39 PM, Mina Almasry wrote:
> Augment dmabuf binding to be able to handle TX. Additional to all the RX
> binding, we also create tx_vec needed for the TX path.
> 
> Provide API for sendmsg to be able to send dmabufs bound to this device:
> 
> - Provide a new dmabuf_tx_cmsg which includes the dmabuf to send from.
> - MSG_ZEROCOPY with SCM_DEVMEM_DMABUF cmsg indicates send from dma-buf.
> 
> Devmem is uncopyable, so piggyback off the existing MSG_ZEROCOPY
> implementation, while disabling instances where MSG_ZEROCOPY falls back
> to copying.
> 
> We additionally pipe the binding down to the new
> zerocopy_fill_skb_from_devmem which fills a TX skb with net_iov netmems
> instead of the traditional page netmems.
> 
> We also special case skb_frag_dma_map to return the dma-address of these
> dmabuf net_iovs instead of attempting to map pages.
> 
> Based on work by Stanislav Fomichev <sdf@fomichev.me>. A lot of the meat
> of the implementation came from devmem TCP RFC v1[1], which included the
> TX path, but Stan did all the rebasing on top of netmem/net_iov.
> 
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Signed-off-by: Kaiyuan Zhang <kaiyuanz@google.com>
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Very minor nit: you unexpectedly leaved a lot of empty lines after the SoB.

[...]
@@ -240,13 +249,23 @@ net_devmem_bind_dmabuf(struct net_device *dev,
unsigned int dmabuf_fd,
>  	 * binding can be much more flexible than that. We may be able to
>  	 * allocate MTU sized chunks here. Leave that for future work...
>  	 */
> -	binding->chunk_pool =
> -		gen_pool_create(PAGE_SHIFT, dev_to_node(&dev->dev));
> +	binding->chunk_pool = gen_pool_create(PAGE_SHIFT,
> +					      dev_to_node(&dev->dev));
>  	if (!binding->chunk_pool) {
>  		err = -ENOMEM;
>  		goto err_unmap;
>  	}
>  
> +	if (direction == DMA_TO_DEVICE) {
> +		binding->tx_vec = kvmalloc_array(dmabuf->size / PAGE_SIZE,
> +						 sizeof(struct net_iov *),
> +						 GFP_KERNEL);
> +		if (!binding->tx_vec) {
> +			err = -ENOMEM;
> +			goto err_free_chunks;

It looks like the later error paths (in the for_each_sgtable_dma_sg()
loop) could happen even for 'direction == DMA_TO_DEVICE', so I guess an
additional error label is needed to clean tx_vec on such paths.

/P


