Return-Path: <kvm+bounces-29800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 798449B23D8
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F6F22820DD
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 04:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6957718C037;
	Mon, 28 Oct 2024 04:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZW/6JVa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627B62C697;
	Mon, 28 Oct 2024 04:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730089504; cv=none; b=N7Xw+G6Yc0b4cozjSyZRp6u5AtWbKabQPZEftEXljq8wKqx6p5azMuZkZq0miNFB8uMPqrZJkgZk9uej3BS9xAqId0RfQ1xi8Wev2kn7KmK5QZPbYh22P1QYDigL6AOV9MNGr48kIcoX2eXUP+kEyzNw/spcPrdldCVqb67drBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730089504; c=relaxed/simple;
	bh=Y9iGHqOHKOxRX/YuktGKzJY8/m4TQ2gtHKBpbGPfu08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nsxjt8Or9NRNvtg8Bu7HJM1tmuHER9TVkgdIwn/7EGsR1m1VADKLO1jERxQKSPWAnpCdkObjMONR7eo4kfpS2X3FHUvyRCPbhB/yc74ZEC3qPIeMC8SGMBIYEL+jeZRz6LcOzvxyWQsHC+MFpdzA8PYvDuj7WAixNdwF1jt6DrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZW/6JVa; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20ce65c8e13so32672865ad.1;
        Sun, 27 Oct 2024 21:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730089501; x=1730694301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3x7sfjCk6an/jee3PqRBielnEix2rcYMcqqI8sdlR0=;
        b=HZW/6JVawHAxzFNSlstne4v8ZLwIBzZ/hFR4VCaHpgqJ8GSDFTDnc4YWgofsbQufKN
         HIx315PLpMQQfwqZj+xbmrPlcZe+UaBlXV4zLxjGmEwAVCf9PithW+DZbtv7o6qyV1/u
         /OZY1U6KBJWar/a4DhEuT5gkVeInBjSZ0viUzvdzcPbTzKSNEfOvIrL0Uwheu8JBdpCP
         BB48abAunqpjx19gpEpmUUQtHuHcHYnLcO49oymLxLxPfLzE0w6uUQDbWmqz1+DZTPeZ
         Vlq0tb6DnQPCaSw279VPyk8CJ5xLnn7K0tXomR0pphg1o+w+gnkJQNMj+g+Ct8MpQ9RS
         pVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730089501; x=1730694301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3x7sfjCk6an/jee3PqRBielnEix2rcYMcqqI8sdlR0=;
        b=TomX+xKwUT5OjQeQOwK3ChVXn6TtIAhIS4+GHzNsuSXCXg+TJrj1VzLtKkwprpeJ+k
         0jzMz6ezqVlcoAFsI6/B28EMuYWOPt7KfqduFDmyHH1xc4K9bwFF5pcsX8b+KXg696UA
         9Cg+UMRDQbZgYG5/edaNGm0CJxfKoLQsv//LpMZ/SqU5Tf+MKX2pZWRzmGNpIFsuxhez
         th5WRDnAS2wz2Qp4iujyik5ErWW6zFx3YR4vkuNidUl8rxmNw3NZMYZgCTauVsZ2ETJl
         M3bjP4K2ycrw6YdrgsV73XXjWvN4SRkqXpYYb/5Hqrnj5mXTApwb+cuh4JWOmTjeSZ8O
         /2pQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdF+Aywr1Gzc3skSLsQ6z6ZvcO91EdEdJTJnD+toMZGwUaoDRqC8orfaSW7OjmKrME11vVSkLYEkxl6xxc@vger.kernel.org, AJvYcCUk735xtfOppH/TGfChX3BAtCvGG/DAuT1r+EwHZfcVC1ExE+lQPQmvnGonJPVTEiyPZes=@vger.kernel.org, AJvYcCVKY2l5TG20ypDiYFn2SK27Zn7yBsGRSzvcEhuN8ngIE1lxMbrIUBtIQjavQh8ZQ+iNIKS6QWHrOTFHTwc=@vger.kernel.org, AJvYcCVqOk8UMTNz2Y+C7D8Z0Wcglscrrf676kbL7h+eaYZJXAnMyzHqCTU+mpUS6yr6yIstM0KdHAwh3ckC@vger.kernel.org, AJvYcCXHmQRg+iICohAmSgKnUhW0J1A1KSPlLpQaTrQoSa67YM/Ugm/y2B2gWjfHCd9cLSsnBUlxx+2XG+mW@vger.kernel.org, AJvYcCXPHW2+dNz3SfTRwwyirSu3t7LLYRbbSzEaNeQYBumriat8e7Y/4YGKk8gIQoQVuO5lEPrNL6JEOuYnXA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUCErQq57Jw3Y2C7ug1Bi33oHYx0USUQcZ79Cd7+2fzTwUivIK
	Gz8pCpEq9wx5ltLQa35VI9exP4kf+HKReYXQR6NH5S/kg8YCRzxORcLkIIAF2n4px8XqEaGf/lV
	tM13yBqTwXMGXtab0NwMGFaDdurU=
X-Google-Smtp-Source: AGHT+IF/XbpZuxphQQOGSTKqE4rMFhTi6L+p1iG+0wHvbb3b0Zmpl46tdIWRMT6RjNj1jqQyIDmtIwt2bzj/qL3GX/U=
X-Received: by 2002:a17:902:db02:b0:20c:b700:6e10 with SMTP id
 d9443c01a7336-210c6c8856cmr116967905ad.34.1730089501376; Sun, 27 Oct 2024
 21:25:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1730037276.git.leon@kernel.org> <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
In-Reply-To: <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
From: Srinivasulu Thanneeru <dev.srinivasulu@gmail.com>
Date: Mon, 28 Oct 2024 09:54:49 +0530
Message-ID: <CAMtOeKJeVrELCp5JpYTC64KdfKpbnW9a8QrnL6ziCYL48nc=qQ@mail.gmail.com>
Subject: Re: [PATCH 05/18] dma: Provide an interface to allow allocate IOVA
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Leon Romanovsky <leonro@nvidia.com>, Keith Busch <kbusch@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 10:23=E2=80=AFPM Leon Romanovsky <leon@kernel.org> =
wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The existing .map_page() callback provides both allocating of IOVA
> and linking DMA pages. That combination works great for most of the
> callers who use it in control paths, but is less effective in fast
> paths where there may be multiple calls to map_page().

Can you please share perf stats with this patch in fast path, if available?

> These advanced callers already manage their data in some sort of
> database and can perform IOVA allocation in advance, leaving range
> linkage operation to be in fast path.
>
> Provide an interface to allocate/deallocate IOVA and next patch
> link/unlink DMA ranges to that specific IOVA.
>
> The API is exported from dma-iommu as it is the only implementation
> supported, the namespace is clearly different from iommu_* functions
> which are not allowed to be used. This code layout allows us to save
> function call per API call used in datapath as well as a lot of boilerpla=
te
> code.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/iommu/dma-iommu.c   | 79 +++++++++++++++++++++++++++++++++++++
>  include/linux/dma-mapping.h | 15 +++++++
>  2 files changed, 94 insertions(+)
>
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index c422e36c0d66..0644152c5aad 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1745,6 +1745,85 @@ size_t iommu_dma_max_mapping_size(struct device *d=
ev)
>         return SIZE_MAX;
>  }
>
> +static bool iommu_dma_iova_alloc(struct device *dev,
> +               struct dma_iova_state *state, phys_addr_t phys, size_t si=
ze)
> +{
> +       struct iommu_domain *domain =3D iommu_get_dma_domain(dev);
> +       struct iommu_dma_cookie *cookie =3D domain->iova_cookie;
> +       struct iova_domain *iovad =3D &cookie->iovad;
> +       size_t iova_off =3D iova_offset(iovad, phys);
> +       dma_addr_t addr;
> +
> +       if (WARN_ON_ONCE(!size))
> +               return false;
> +       if (WARN_ON_ONCE(size & DMA_IOVA_USE_SWIOTLB))
> +               return false;
> +
> +       addr =3D iommu_dma_alloc_iova(domain,
> +                       iova_align(iovad, size + iova_off),
> +                       dma_get_mask(dev), dev);
> +       if (!addr)
> +               return false;
> +
> +       state->addr =3D addr + iova_off;
> +       state->__size =3D size;
> +       return true;
> +}
> +
> +/**
> + * dma_iova_try_alloc - Try to allocate an IOVA space
> + * @dev: Device to allocate the IOVA space for
> + * @state: IOVA state
> + * @phys: physical address
> + * @size: IOVA size
> + *
> + * Check if @dev supports the IOVA-based DMA API, and if yes allocate IO=
VA space
> + * for the given base address and size.
> + *
> + * Note: @phys is only used to calculate the IOVA alignment. Callers tha=
t always
> + * do PAGE_SIZE aligned transfers can safely pass 0 here.
> + *
> + * Returns %true if the IOVA-based DMA API can be used and IOVA space ha=
s been
> + * allocated, or %false if the regular DMA API should be used.
> + */
> +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state=
,
> +               phys_addr_t phys, size_t size)
> +{
> +       memset(state, 0, sizeof(*state));
> +       if (!use_dma_iommu(dev))
> +               return false;
> +       if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> +           iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> +               return false;
> +       return iommu_dma_iova_alloc(dev, state, phys, size);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_try_alloc);
> +
> +/**
> + * dma_iova_free - Free an IOVA space
> + * @dev: Device to free the IOVA space for
> + * @state: IOVA state
> + *
> + * Undoes a successful dma_try_iova_alloc().
> + *
> + * Note that all dma_iova_link() calls need to be undone first.  For cal=
lers
> + * that never call dma_iova_unlink(), dma_iova_destroy() can be used ins=
tead
> + * which unlinks all ranges and frees the IOVA space in a single efficie=
nt
> + * operation.
> + */
> +void dma_iova_free(struct device *dev, struct dma_iova_state *state)
> +{
> +       struct iommu_domain *domain =3D iommu_get_dma_domain(dev);
> +       struct iommu_dma_cookie *cookie =3D domain->iova_cookie;
> +       struct iova_domain *iovad =3D &cookie->iovad;
> +       size_t iova_start_pad =3D iova_offset(iovad, state->addr);
> +       size_t size =3D dma_iova_size(state);
> +
> +       iommu_dma_free_iova(cookie, state->addr - iova_start_pad,
> +                       iova_align(iovad, size + iova_start_pad), NULL);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_free);
> +
>  void iommu_setup_dma_ops(struct device *dev)
>  {
>         struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 6075e0708deb..817f11bce7bc 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -11,6 +11,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/bug.h>
>  #include <linux/mem_encrypt.h>
> +#include <linux/iommu.h>
>
>  /**
>   * List of possible attributes associated with a DMA mapping. The semant=
ics
> @@ -77,6 +78,7 @@
>  #define DMA_BIT_MASK(n)        (((n) =3D=3D 64) ? ~0ULL : ((1ULL<<(n))-1=
))
>
>  struct dma_iova_state {
> +       dma_addr_t addr;
>         size_t __size;
>  };
>
> @@ -307,11 +309,24 @@ static inline bool dma_use_iova(struct dma_iova_sta=
te *state)
>  {
>         return state->__size !=3D 0;
>  }
> +
> +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state=
,
> +               phys_addr_t phys, size_t size);
> +void dma_iova_free(struct device *dev, struct dma_iova_state *state);
>  #else /* CONFIG_IOMMU_DMA */
>  static inline bool dma_use_iova(struct dma_iova_state *state)
>  {
>         return false;
>  }
> +static inline bool dma_iova_try_alloc(struct device *dev,
> +               struct dma_iova_state *state, phys_addr_t phys, size_t si=
ze)
> +{
> +       return false;
> +}
> +static inline void dma_iova_free(struct device *dev,
> +               struct dma_iova_state *state)
> +{
> +}
>  #endif /* CONFIG_IOMMU_DMA */
>
>  #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
> --
> 2.46.2
>
>

