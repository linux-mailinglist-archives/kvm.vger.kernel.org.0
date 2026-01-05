Return-Path: <kvm+bounces-67035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD59CF2D22
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7037330275D7
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B2C32FA32;
	Mon,  5 Jan 2026 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bqTttIPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CFB2D8771
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606048; cv=none; b=EmSEvvoCgB+DAf3j9khdom1WGL8T+MzUimyKEPUjzv8fXxgSrDNvoT+uUxdkNZe3YAXikC8z7qtEzK/p5VhpQvBit6B2AvkCBctTbQr5nnVjpuhMybwrno4Wxauj0d/epQ1FdJRQb46wCGwOGMeuX8/fI6WS/nToUGLyzd4BI48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606048; c=relaxed/simple;
	bh=kfKJrQ5a7Po2zi22PzxrbpGrQhRcJMv+xYYFiP1AGz8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYXib8fE1os9PQuWv/TuWrHCZN7sLtfKelVjpPKQ1A7f5WY0K6+ncgbEd65imflVLYBN2Okedx3z0fK5VxiUAA2YGXSN+u4NXjyantmhArS+Wf1kPXrNXL8pya7aZgsf5986Holj/6iCptmYml5CjFAH9tm9+I/Obn6d9WGPl9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bqTttIPN; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42fb04abc24so610292f8f.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606040; x=1768210840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uoPF4qbo+ysXILWF9RMN1mDoAoivYGl4rzNQocqtbj4=;
        b=bqTttIPNXYA02SvzTJN+Iq2teAV4gvhztpFmGuTDYNQmZSW73vvAB1E9iAMwQAdG95
         +2dN6IzaMbz96nWQwBsJuSmXZEKRAZW6cGZNlG5prU3nO/SaQLFCAsLrDDY1ehMxp5h+
         z/AMR8rEXiTZLYVksNz1E4ouEDHzfO9p17we+pJqDgK2Jn5N4hh0imjGEBnl2wqDQDOd
         ORs5/0peeGMBqvb1bzqjT8PY/f+CUXiWQJUT/jALouTFuJNYCGLZ7rZL25+yY1KxBbAy
         JlS6gdFy47ebCoiUqTo0jN3T9SpiOTqtc50xJix+6jvOH+Q0OFRVVePn2z61tJQF8SnP
         2p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606040; x=1768210840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uoPF4qbo+ysXILWF9RMN1mDoAoivYGl4rzNQocqtbj4=;
        b=hyxIzAwpoV2C0XuvSK9by1DgRtx0YZRcpWE5Gd/ruldOWL2nKV5vz4UsvZ5Txwj6oe
         p5YVtakCWZ856yNWF8ujxUVRkw7oBqUDUa0YPB2Mx0Ph6ul74i8oi9Hb61ninu9tf4Lv
         8B7HTgqGruovgsfy5rcUiCpZayD1qQmf8b8Cqp8PAijhIhqdpdkBS3bgFaebJo3G4ik0
         55jebuifqquppS5977QQ/QQSuiUrIxBF7TUoup720/TNfbG//F2sg8lrQWzyfUHBEM4E
         DqM7SYh3WF3467oR8oQRsfD2qMB3bsS17l19eIpEAkRGwZ/SOw5h4yijb0XCxkEFMZuB
         jU8g==
X-Forwarded-Encrypted: i=1; AJvYcCVYaJxiC+3qtt7Oo3C4y/gfHfQs8Yi9ZPffiKo1jJRB18x68q85btXnTk4saQDOuQsKE9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyORs8LSOQP2Cr54qtYQIFgmquA3cRDunYk195W4sSbhrYI7pWL
	yOnu4NVwaIpFTviJoqRUysrtzYpqemJmlShwQvTY6e0fCfOPqODG/cv3XVVSFNvYxJk=
X-Gm-Gg: AY/fxX4Va9N1vOnlhiEnMY5OqA0E+vgNvVybV5zREw1QO4f9PCNXjaFk9pp36NLNMbX
	xe4W7XbiC0TXBF62imklr9uhwjBWOiBRBahczeKMEWQ/MHMq5I94E7A3UYxJOBd3e6D7Y7JG3CA
	Au8zt6+56Vgl6sQmeijk6YwHBrUOiKZgEdrRxmPRp3fZZKYh48St2xfThfg8LXC0w9FXVm+yhJR
	7I5/qJIpIIetbrY6k+KKC2EhIDo8usgdqvKzAmMj7QbMX60Rv87tYx61dwY4TLaZ3sFNHsVj70l
	B/do3FvaotvPvF6POwl2NV2iRqiatNYXXcRCP56SgvoTJQTWiSJpqAysBCNgH/LZh9dEi4BGuMb
	G0np5/K8BytJq+LQ5SXAm5uaTS/1clSIQk161ptKPXgTNOzkJ7vn0nfUeBQ/W1AS9RqZ3p+hkbf
	b7MqXz9jUOh3DQ7ZQ9RXMC7UkXtjIMi3Kz9WeZoHIuoBZQ0ocgSPD8E9Xbm/I+lbjLfSBwN7kJG
	uv3l5ILG6ZZmoY=
X-Google-Smtp-Source: AGHT+IH9uJ6jLlQ3sMbfjfqB2tBZwtUo3Z4YZNjyI98ICTrDJSXZI/68FFDolBTS/hTy3IR7RjNHZw==
X-Received: by 2002:a05:6000:1841:b0:432:84fc:46bb with SMTP id ffacd0b85a97d-43284fc4782mr21485079f8f.6.1767606040029;
        Mon, 05 Jan 2026 01:40:40 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324e9ba877sm100563291f8f.0.2026.01.05.01.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:40:39 -0800 (PST)
Date: Mon, 5 Jan 2026 10:40:36 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski
 <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 01/15] dma-mapping: add
 __dma_from_device_group_begin()/end()
Message-ID: <20260105104036.09a77f13@mordecai>
In-Reply-To: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:22:54 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> When a structure contains a buffer that DMA writes to alongside fields
> that the CPU writes to, cache line sharing between the DMA buffer and
> CPU-written fields can cause data corruption on non-cache-coherent
> platforms.
> 
> Add __dma_from_device_group_begin()/end() annotations to ensure proper
> alignment to prevent this:
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin();
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end();
> 	spinlock_t lock2;
> };
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  include/linux/dma-mapping.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index aa36a0d1d9df..29ad2ce700f0 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -7,6 +7,7 @@
>  #include <linux/dma-direction.h>
>  #include <linux/scatterlist.h>
>  #include <linux/bug.h>
> +#include <linux/cache.h>
>  
>  /**
>   * List of possible attributes associated with a DMA mapping. The semantics
> @@ -703,6 +704,18 @@ static inline int dma_get_cache_alignment(void)
>  }
>  #endif
>  
> +#ifdef ARCH_HAS_DMA_MINALIGN
> +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> +#else
> +#define ____dma_from_device_aligned
> +#endif
> +/* Mark start of DMA buffer */
> +#define __dma_from_device_group_begin(GROUP)			\
> +	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
> +/* Mark end of DMA buffer */
> +#define __dma_from_device_group_end(GROUP)			\
> +	__cacheline_group_end(GROUP) ____dma_from_device_aligned
> +
>  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
>  		dma_addr_t *dma_handle, gfp_t gfp)
>  {


