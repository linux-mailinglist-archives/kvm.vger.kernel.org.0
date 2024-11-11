Return-Path: <kvm+bounces-31394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 274E49C365B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 03:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC46B1F2127D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 02:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD637F48C;
	Mon, 11 Nov 2024 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TFK9Cyfo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440242595;
	Mon, 11 Nov 2024 02:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731290752; cv=none; b=Mr0hcG3hZ7Rv472niDGUc9Xq4Bb0XBuD9JD8Ijy9wc9UrYPbjzlGGs3YKYJ/KFJgxLX8Jzk2wOpYDtEP0fZhjSq7+O2cp468seTrJvTvBvXw6K+Hd2Zk1v72jYSS08O5YwYfI6NczpD8aDQo+V/NH9isl95KjCouhMHTwiYXV5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731290752; c=relaxed/simple;
	bh=bWyRCGTcPRNkiQbPV1UIZK/QkxgPyfNx5HGKdVQ0DSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dAIWiktJVOro7AWm3cKyo5KVtnHgyLJ3/whJK+NksWJjmCSZImmnNkcQievHcgW470LlJS8ptQ2+XBP4zY9+1C5bnSLbR315/WvAggXC66mwORGVfNsYyockuoGFhLGmekEFDrsXSrXr29gJpZMXY7f/zHksTGundu/RiVe8xZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TFK9Cyfo; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f75c56f16aso33894481fa.0;
        Sun, 10 Nov 2024 18:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731290747; x=1731895547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GdEkfAJOsElSV+ujZ/1dK2DOAkU54yl3So/8rs20Jag=;
        b=TFK9CyfoYPA3xi/BnMiYSy2AZc+3QS03ZSbcciD9ujKPMayJSD5iXScOTnTamENIwR
         1eTjtNG9BiHj0/48GqvKhZTByuE0lmexlVbH4GZt9zib4iuwWU4vJqXjv9SrpmqahZ2/
         dmFJvdBgiIUL4ncrY1hazNeY+R4ewAhfDpgTqDstXMgl5Kqob6TCbM+LGfVzy/Ppogfg
         AEuIEx/80ZICocy4zps4aj7K7Ioon8rOtD9nWXkt8GUJd4HH0HRU/rVUbOx9phGHwecR
         Vd0VZbmRAdCvhLyCV1cGo7ZIGnnE3Hme0pNo2lA48QQL7DJ98nWmPf06d+8uYsAeDcrY
         ZJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731290747; x=1731895547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdEkfAJOsElSV+ujZ/1dK2DOAkU54yl3So/8rs20Jag=;
        b=S/4delkvH62/eogfJL78YQs8DUzfMupTrvJJYrkHspJqbL6FfYDcSnKwecYjw8bpe3
         GsnsIN+zUOlm9hBp3rkiyjgPQIzbTB1SZHC3aNW8txWhtKgAlIkuxM3/Hz1v0pxPe4sH
         xuszKnN77CarCSS5WiZrWTk5sdIKAuotDCf9XvD7EhlbHhM6Aa59C5GnmwIaQk08ANdn
         JM+AmzmjfZH12dFnlgV60V84oMstm5nLltm5oNbSo+tYV44skKFO73emN8WXlxrXCJDb
         oUWkfXAodbiEPyaUSBHdjC0d1whbNC+4LccvWx8n+Z/VYEpaZszHz+rz6xSsyxg0omXB
         v+VQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdESwwDHmZfmJ521sofsn2EZ67Z8i7YGI4CUiWLL1k+MRLSbXO0yIZ3Q+R2akvpmkRTtW6q+EOXBBO+b4=@vger.kernel.org, AJvYcCUeiehGzvIPBQRCYMTKlbLvIY3a5XiDpHb0xnWAr8dATf54P8zFUiWz12AHkinWxoMUbMr60O8vSiqa@vger.kernel.org, AJvYcCUy05lnbbyUMhB+O1vJRsXJmpU4lXoEg8DuZTHFtepvZXJg9auyGshuBIVfiahg7+5RKFi7Cp79rfDk@vger.kernel.org, AJvYcCV5TtRSa0vzGjLs6D8vr7xKDxrNkDYiUQQTBN8qP0vpDOOnHh/WXpxePoSnDZXqqeFxTQaDy/q5Rok5Rzxz@vger.kernel.org, AJvYcCVV5ck3dhrIVNT69VaDePYUrclbeOx9PG10iyUW/zAneQbKKXVTc724v5I/B0zltPtDyAU=@vger.kernel.org, AJvYcCXHpuVsut4y3Tw3LkZV/lnSUejTJhe9ZjmSKGrFHYlA6VGs5BirF2DZ63vd0Lv0O70ZQ9r+wgeG18IB2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaKYI7iABcv1/nhqVQxU7Gs5+ka9LpUbLYHp+78YrnqE6YtyFg
	v+AeMcyipGkd4Ssq6FHlMTQMIf4YuemG/4lykIgyZ7JJYPEPPF9BB7YD/B7r63p5ZDT+0yEyJc+
	f65hmku2a+kHuhsa3iPfNNNOn1+Y=
X-Google-Smtp-Source: AGHT+IF0tJPIolZyNYPTT2b/MpCJe82Fg/iZslXB6gzAqlmjhMUqVGRF2M5H+UaSiVlIP433HQ0w2T+2CyxfkrVJL68=
X-Received: by 2002:a2e:bc1d:0:b0:2fb:5014:8eb9 with SMTP id
 38308e7fff4ca-2ff2014ec60mr46592301fa.10.1731290746959; Sun, 10 Nov 2024
 18:05:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731244445.git.leon@kernel.org> <dca3aecdeeaa962c7842bc488378cdf069201d65.1731244445.git.leon@kernel.org>
In-Reply-To: <dca3aecdeeaa962c7842bc488378cdf069201d65.1731244445.git.leon@kernel.org>
From: anish kumar <yesanishhere@gmail.com>
Date: Sun, 10 Nov 2024 18:05:35 -0800
Message-ID: <CABCoZhAN-eeu=E5r+ZbZGTNwQta5yUw86sy8e_Je+Yri-+iuoQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/17] docs: core-api: document the IOVA-based API
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 10, 2024 at 5:50=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Christoph Hellwig <hch@lst.de>
>
> Add an explanation of the newly added IOVA-based mapping API.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>
> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/=
dma-api.rst
> index 8e3cce3d0a23..61d6f4fe3d88 100644
> --- a/Documentation/core-api/dma-api.rst
> +++ b/Documentation/core-api/dma-api.rst
> @@ -530,6 +530,76 @@ routines, e.g.:::
>                 ....
>         }
>
> +Part Ie - IOVA-based DMA mappings
> +---------------------------------
> +
> +These APIs allow a very efficient mapping when using an IOMMU.  They are=
 an

"They" doesn't sound nice.
> +optional path that requires extra code and are only recommended for driv=
ers
> +where DMA mapping performance, or the space usage for storing the DMA ad=
dresses
> +matter.  All the considerations from the previous section apply here as =
well.

These APIs provide an efficient mapping when using an IOMMU. However, they
are optional and require additional code. They are recommended primarily fo=
r
drivers where performance in DMA mapping or the storage space for DMA
addresses are critical. All the considerations discussed in the previous se=
ction
also apply in this case.

You can disregard this comment, as anyone reading this paragraph will
understand the intended message.

> +
> +::
> +
> +    bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *s=
tate,
> +               phys_addr_t phys, size_t size);
> +
> +Is used to try to allocate IOVA space for mapping operation.  If it retu=
rns
> +false this API can't be used for the given device and the normal streami=
ng
> +DMA mapping API should be used.  The ``struct dma_iova_state`` is alloca=
ted
> +by the driver and must be kept around until unmap time.
> +
> +::
> +
> +    static inline bool dma_use_iova(struct dma_iova_state *state)
> +
> +Can be used by the driver to check if the IOVA-based API is used after a
> +call to dma_iova_try_alloc.  This can be useful in the unmap path.
> +
> +::
> +
> +    int dma_iova_link(struct device *dev, struct dma_iova_state *state,
> +               phys_addr_t phys, size_t offset, size_t size,
> +               enum dma_data_direction dir, unsigned long attrs);
> +
> +Is used to link ranges to the IOVA previously allocated.  The start of a=
ll
> +but the first call to dma_iova_link for a given state must be aligned
> +to the DMA merge boundary returned by ``dma_get_merge_boundary())``, and
> +the size of all but the last range must be aligned to the DMA merge boun=
dary
> +as well.
> +
> +::
> +
> +    int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +               size_t offset, size_t size);
> +
> +Must be called to sync the IOMMU page tables for IOVA-range mapped by on=
e or
> +more calls to ``dma_iova_link()``.
> +
> +For drivers that use a one-shot mapping, all ranges can be unmapped and =
the
> +IOVA freed by calling:
> +
> +::
> +
> +   void dma_iova_destroy(struct device *dev, struct dma_iova_state *stat=
e,
> +               enum dma_data_direction dir, unsigned long attrs);
> +
> +Alternatively drivers can dynamically manage the IOVA space by unmapping
> +and mapping individual regions.  In that case
> +
> +::
> +
> +    void dma_iova_unlink(struct device *dev, struct dma_iova_state *stat=
e,
> +               size_t offset, size_t size, enum dma_data_direction dir,
> +               unsigned long attrs);
> +
> +is used to unmap a range previously mapped, and
> +
> +::
> +
> +   void dma_iova_free(struct device *dev, struct dma_iova_state *state);
> +
> +is used to free the IOVA space.  All regions must have been unmapped usi=
ng
> +``dma_iova_unlink()`` before calling ``dma_iova_free()``.
>
>  Part II - Non-coherent DMA allocations
>  --------------------------------------
> --
> 2.47.0
>
>

