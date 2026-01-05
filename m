Return-Path: <kvm+bounces-67039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EA7CF2DC1
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:53:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A24E8304B97B
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC50337699;
	Mon,  5 Jan 2026 09:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ch6/Q7bJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C08330B2B
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606625; cv=none; b=dpX62DrVkwS6OOLEjmwbgh/exI5HPTgTbV+zEQILTVAOz7raJOvLL9mq/qP4l6r7IP5i9SxAccaZYNmmiGgf2rCdPnf0BO6/joShm+BYMIEvm4M0K5GYbAcP/o+o+7NWp3nMY7xqQO7m/ZYZfzvp/xtGz5NJGzu7e1ab7fqusKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606625; c=relaxed/simple;
	bh=FhA8UK+chCa+pd17hZ6IOPyBbup1JCfkMRjpIxTkHNo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFgKhA0keo1XSYJ4HuGgVubifyuzwXCztyT18t0LmHMO8ZWrNtJBr5WN6b0dlBPTdK9vBtdJ02ydw8nJI8+zb9NYzAOVWCTDtV4m7BTdzN1fcnZ3XiIMZkePrKc/5krrlwjR/aZHNdjv7XqzzZHorClWHTEJDzd5z8p2TVLNZ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ch6/Q7bJ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47928022b93so20053975e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606621; x=1768211421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHbyaIHmldcU+eqqgyAXM9nUM8TFQGdgTiHVbrY2G0o=;
        b=ch6/Q7bJAAq2dveUyIY5ODasRlLELdDmSr5b55hbxAvwj+DMYKdVCaUko5AOiQmhgi
         N0EgetQVqD8vgYahlGMM9R+BEC99QpGuJJpdFQa0NQQ3yG2LTA2Tu0ZRyqO634+rlWN9
         wWzjBF++QRgs75FDG2EkurOYdM0VguozM5JgJzY852qkRTaFJqNo7vxptgkwUADi1VrB
         Qa+9fTkoB5MRLnHd8dUxsp5bdfGE6gD+Tq/xeCHSn57yb3largDmjmBNlL2mU4Z43TzA
         mPZkRDY3siUk5PgIkppZuLF4tj/VclHM+LbsIjkSiZ36Ee2gIjBXlOBAVtAhFgWCg783
         97qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606621; x=1768211421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FHbyaIHmldcU+eqqgyAXM9nUM8TFQGdgTiHVbrY2G0o=;
        b=tqH/AHPBe71wzoi55hQv3E7AYuJRrCwhZOns0t0HfkR+aehOh5EJhhpWos9P65iIiC
         28XbwtVjRVm0jUd7Wxxjx9YGxHr5guRqmOkScKQBzx8VmKICxgmVzzKkY2oLsJJ5KEHC
         04vy6oNCpglxcoXQe86zsO2aLYRzHgr1g1z3/WdpXlChcReR+zVOG6zMMhd3GMW2ugbP
         PCOKZW7YIKNwoepnBvAaITHtD8k40Z9+Yag5EHvbDS2+bdjb1U9Yo1LcF5q9wD6chN2k
         axWD5jh4/6O+WSjxbP97v5yrpHC9/VaYGV0OSnPW+yWiLqiKBgykyJCZ5XsIw0m/oDDA
         gOqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaW+TMjINWGDFCYwlURVxfv8KRt2pg8bzG4QU2l4RmaHbEuCAbFfp3IzzewuSMqfGSUtM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhFg04XgaEcYP0vBf+v++lsM+BN8BIWp8CXbwSvoN9FL42afZk
	KksAd8UfUzDpIu40seIUBtIfm3K+JEHv9AKanCqqqCM+mDyO8B2YAa/cmG/yRTVMKko=
X-Gm-Gg: AY/fxX4YcWRfKJvHJxhedsWNrSqBtkpPO07n+vNlnGNWTMnJJu0zHzCOZfgObUBaNW3
	h2djS5xwvE4iXIPIosxg2GRAHv2I3J8sYxaRgyO+IBqtxSntGp5s/OjXR7zPHIuIpWaxEqN5ef/
	b3YUsKhCcmpsZi3PP9ZCkNZcJRSiZ4VWVSjQ9Kua6SPvIHJIEjqZ10EEjlYzjjvkZ2o9IUgjpRw
	5enJTTcP1U3eNLoHcv1klLeFSeLbe9crCl++MTuqiBKDCoV+M7wk/9l6RAPb8LkzEb/0sxuj4y1
	cd9PAJ5/IdZh/Z0PVARnRYtOe4YFr9iafr4K5ajoyPjnjJ+IQRG3X/aMSiCll2YhcAVCKjYY9/5
	ZF0ejsAvG+kNhk4GQvwKjKUYn5xqnuL06970/S1bedKL7QWyseUFLVvntBtHXt+el/+XpKMkR++
	9PsM8Cy5MJaqF5k5L4cbGX8UWtnRvc2NAWTYVH/o2kslOKZKmHQkW4U22q1+QmPhWreafGeK7ry
	/651Fzgkxryf+Y=
X-Google-Smtp-Source: AGHT+IGnsRamZ5T2skVdNNSZv9niwK5H6wuQG4RJC9WMb4c0kDes0M5FONvR6OuiLsAxcMrzh8ZmXw==
X-Received: by 2002:a05:600c:1d1d:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-47d19574e09mr373374595e9.3.1767606620962;
        Mon, 05 Jan 2026 01:50:20 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7443c04csm28265855e9.1.2026.01.05.01.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:50:20 -0800 (PST)
Date: Mon, 5 Jan 2026 10:50:18 +0100
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
Subject: Re: [PATCH v2 03/15] dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <20260105105018.732dd009@mordecai>
In-Reply-To: <2d5d091f9d84b68ea96abd545b365dd1d00bbf48.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<2d5d091f9d84b68ea96abd545b365dd1d00bbf48.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:23:01 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> When multiple small DMA_FROM_DEVICE or DMA_BIDIRECTIONAL buffers share a
> cacheline, and DMA_API_DEBUG is enabled, we get this warning:
> 	cacheline tracking EEXIST, overlapping mappings aren't supported.
> 
> This is because when one of the mappings is removed, while another one
> is active, CPU might write into the buffer.
> 
> Add an attribute for the driver to promise not to do this, making the
> overlapping safe, and suppressing the warning.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  include/linux/dma-mapping.h | 7 +++++++
>  kernel/dma/debug.c          | 3 ++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 29ad2ce700f0..29973baa0581 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -79,6 +79,13 @@
>   */
>  #define DMA_ATTR_MMIO		(1UL << 10)
>  
> +/*
> + * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
> + * overlapping this buffer while it is mapped for DMA. All mappings sharing
> + * a cacheline must have this attribute for this to be considered safe.
> + */
> +#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
> +
>  /*
>   * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
>   * be given to a device to use as a DMA source or target.  It is specific to a
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> index 138ede653de4..7e66d863d573 100644
> --- a/kernel/dma/debug.c
> +++ b/kernel/dma/debug.c
> @@ -595,7 +595,8 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
>  	if (rc == -ENOMEM) {
>  		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
>  		global_disable = true;
> -	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
> +	} else if (rc == -EEXIST &&
> +		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
>  		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
>  		     is_swiotlb_active(entry->dev))) {
>  		err_printk(entry->dev, entry,


