Return-Path: <kvm+bounces-35781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3425BA150CC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 14:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F4FD188CD76
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 13:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EBA2010E3;
	Fri, 17 Jan 2025 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsFOzckS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F71FFC74
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737121512; cv=none; b=gwuqEp1oqt0XMUtGj/L98L9hvZ2DdFFj6IJawLve6EyzqxKZSm5BxqdXKXuTa0NRB1y0djcmrxoP1E/tG8rmNJl6+HIJV14BFkGkWmPV0mi7inBgN8+rZre0eqhGcoEzV8pfhSln7HfvvntmklhrLeCEq67mcAA0KEUW2ti/BLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737121512; c=relaxed/simple;
	bh=wMJ7URqUbxG/AeNcisJ1sXvFYg/CQF4Gt3MwmZwHjWs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sTrMa3TWA0YpZcOdUVbUWR4RxBMy5NelREXy8LpbrUkm3r3svYB4AxJ/x/2tUNtDoVQZcC1ABKHxZ/Vd7p8+Gd2BCgNmARwCLIeRAzD+apwVbvhlI6X5ShYy2API7FVJh/CW3Dw8m9SdrZEijEosWEQ+PW37gg6ZGG1YJ+OYVS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hsFOzckS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737121509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EL/Md/xAnVjdSOMC30BT2Sup8TuZ57RNm5+CW4cdr0g=;
	b=hsFOzckSPnzfdMmYcJsT+bVl3xtJroc0xSsRxvn36YttcmzlO8RkQVEnxAK+hak5505UZ7
	shlL0wJMMO0M46uhjvYzzbgulg2Vy849Z6k0RQGdcj/z9VSuaOxO3QCX8o8ArK8P6lTHrF
	2f76uALbgC25FkIZqJb3thgnbBcY62w=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-8v2Hqf4yP1WI-I4_A9wUEw-1; Fri, 17 Jan 2025 08:45:07 -0500
X-MC-Unique: 8v2Hqf4yP1WI-I4_A9wUEw-1
X-Mimecast-MFC-AGG-ID: 8v2Hqf4yP1WI-I4_A9wUEw
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2a7b77a1ca2so12646fac.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 05:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737121505; x=1737726305;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EL/Md/xAnVjdSOMC30BT2Sup8TuZ57RNm5+CW4cdr0g=;
        b=cxNAooy+P7f29Xd5793a7pfKq//UbHbgzz3Sp6ukllxOztawwikWYK1ESUSs6x4Sqz
         pd2r3E9F93wFVqPiEP5KKUzjqdXyjs+o4gTlGtCbFK1K6wkEhACv4A7RAePw2Vl8DnJ/
         upWD7e78vrWTd8XL5NreZFJI/4XwbV2SFjAn5yVgke+Yd3LJ5BNBk9MxTFETeJLN8e6g
         O+Op2xbrmXmv3ikfhGfDCMgsCUArioy3ecA1bVJHjPR4PiJS2h82uLAhFuXVBSq9uisE
         nsLuiUgLzzSkqXQEBDbr2sa+peOi7AOUknwAG2OOmJBPyEnzUjrdf4daTarOAk0emGh0
         Nilg==
X-Forwarded-Encrypted: i=1; AJvYcCU8taMwwANq4kEeNf4hveWRK3B/vcBdL/Nl8bt0lPjGUEQRBYfnIa+FsdPF5lEj4iJicRc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Cz/53JjgoKspXKvUupeUzmgFjSYgqZMG4ZM+AAjAyf+D/3CB
	41fGV9CGzDnKgbWUuYkdo3OHjwl+ys0mZBRz1e2rRA/yaDUaEszMcRK0JYYfd9A68tpALX0gb8a
	TViE6l17fKxrxDZR0qZLNzYwccWdilU5DtSgG90nsBAENFJ2kaA==
X-Gm-Gg: ASbGncst2Xy2VPnf0Bj0oPBJJibN0CgX8+rJbAEALYN2PdYwSzWOgFdyf3zmFFYZ2gV
	CPzfJOZsrquzUHUmCb7lE77M+o9MqApBG29+sMpqwMBXXnW2Z5kZoZhw5Dop+BbCAIwVDI/8Moi
	N6HmEBktXiY8dkEtNng/hzKKE+SCKsAP0MCKcRYMIhZ8Q+LATIjGSrjOnNcJzhSqU9uToQKEgPL
	MsGQJ9sGP4nLJzHOVPm6nN8XPAjynWzar9L67zPsj/Q9kFM1IwGXzKl4qHU
X-Received: by 2002:a4a:ee06:0:b0:5f2:bae9:5fe4 with SMTP id 006d021491bc7-5fa387f1fafmr610132eaf.1.1737121505633;
        Fri, 17 Jan 2025 05:45:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtHhEKqg933zNO3YKsajRZW3t1314FdZw7gNR6lp2izRBKfUR7wM84axeBHAi48Y/sRavCRQ==
X-Received: by 2002:a4a:ee06:0:b0:5f2:bae9:5fe4 with SMTP id 006d021491bc7-5fa387f1fafmr610123eaf.1.1737121505306;
        Fri, 17 Jan 2025 05:45:05 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7249b4883c0sm882724a34.50.2025.01.17.05.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 05:45:04 -0800 (PST)
Date: Fri, 17 Jan 2025 08:44:49 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Wencheng Yang <east.moutain.yang@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin
 Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] drviers/iommu/amd: support P2P access through IOMMU
 when SME is enabled
Message-ID: <20250117084449.6cfd68b3.alex.williamson@redhat.com>
In-Reply-To: <20250117071423.469880-1-east.moutain.yang@gmail.com>
References: <20250117071423.469880-1-east.moutain.yang@gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Jan 2025 15:14:18 +0800
Wencheng Yang <east.moutain.yang@gmail.com> wrote:

> When SME is enabled, memory encryption bit is set in IOMMU page table
> pte entry, it works fine if the pfn of the pte entry is memory.
> However, if the pfn is MMIO address, for example, map other device's mmio
> space to its io page table, in such situation, setting memory encryption
> bit in pte would cause P2P failure.
> 
> Clear memory encryption bit in io page table if the mapping is MMIO
> rather than memory.
> 
> Signed-off-by: Wencheng Yang <east.moutain.yang@gmail.com>
> ---
>  drivers/iommu/amd/amd_iommu_types.h | 7 ++++---
>  drivers/iommu/amd/io_pgtable.c      | 2 ++
>  drivers/iommu/amd/io_pgtable_v2.c   | 5 ++++-
>  drivers/iommu/amd/iommu.c           | 2 ++
>  drivers/vfio/vfio_iommu_type1.c     | 4 +++-
>  include/uapi/linux/vfio.h           | 1 +
>  6 files changed, 16 insertions(+), 5 deletions(-)

This needs to:

 - Be split into separate IOMMU vs VFIO patches
 - Consider and consolidate with other IOMMU implementations of the same
 - Provide introspection to userspace relative to the availability of
   the resulting mapping option

It's also not clear to me that the user should be responsible for
setting this flag versus something in the VFIO or IOMMU layer.  For
example what are the implications of the user setting this flag
incorrectly (not just failing to set it for MMIO, but using it for RAM)?
Thanks,

Alex

> 
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index fdb0357e0bb9..b0f055200cf3 100644
> --- a/drivers/iommu/amd/amd_iommu_types.h
> +++ b/drivers/iommu/amd/amd_iommu_types.h
> @@ -434,9 +434,10 @@
>  #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_MASK))
>  #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
>  
> -#define IOMMU_PROT_MASK 0x03
> -#define IOMMU_PROT_IR 0x01
> -#define IOMMU_PROT_IW 0x02
> +#define IOMMU_PROT_MASK 0x07
> +#define IOMMU_PROT_IR   0x01
> +#define IOMMU_PROT_IW   0x02
> +#define IOMMU_PROT_MMIO 0x04
>  
>  #define IOMMU_UNITY_MAP_FLAG_EXCL_RANGE	(1 << 2)
>  
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index f3399087859f..dff887958a56 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -373,6 +373,8 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  			__pte |= IOMMU_PTE_IR;
>  		if (prot & IOMMU_PROT_IW)
>  			__pte |= IOMMU_PTE_IW;
> +		if (prot & IOMMU_PROT_MMIO)
> +			__pte = __sme_clr(__pte);
>  
>  		for (i = 0; i < count; ++i)
>  			pte[i] = __pte;
> diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
> index c616de2c5926..55f969727dea 100644
> --- a/drivers/iommu/amd/io_pgtable_v2.c
> +++ b/drivers/iommu/amd/io_pgtable_v2.c
> @@ -65,7 +65,10 @@ static u64 set_pte_attr(u64 paddr, u64 pg_size, int prot)
>  {
>  	u64 pte;
>  
> -	pte = __sme_set(paddr & PM_ADDR_MASK);
> +	pte = paddr & PM_ADDR_MASK;
> +	if (!(prot & IOMMU_PROT_MMIO))
> +		pte = __sme_set(pte);
> +
>  	pte |= IOMMU_PAGE_PRESENT | IOMMU_PAGE_USER;
>  	pte |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
>  
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 16f40b8000d7..9194ad681504 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2578,6 +2578,8 @@ static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long iova,
>  		prot |= IOMMU_PROT_IR;
>  	if (iommu_prot & IOMMU_WRITE)
>  		prot |= IOMMU_PROT_IW;
> +	if (iommu_prot & IOMMU_MMIO)
> +		prot |= IOMMU_PROT_MMIO;
>  
>  	if (ops->map_pages) {
>  		ret = ops->map_pages(ops, iova, paddr, pgsize,
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 50ebc9593c9d..08be1ef8514b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1557,6 +1557,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		prot |= IOMMU_WRITE;
>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>  		prot |= IOMMU_READ;
> +    if (map->flags & VFIO_DMA_MAP_FLAG_MMIO)
> +        prot |= IOMMU_MMIO;
>  
>  	if ((prot && set_vaddr) || (!prot && !set_vaddr))
>  		return -EINVAL;
> @@ -2801,7 +2803,7 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
>  	struct vfio_iommu_type1_dma_map map;
>  	unsigned long minsz;
>  	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
> -			VFIO_DMA_MAP_FLAG_VADDR;
> +			VFIO_DMA_MAP_FLAG_VADDR | VFIO_DMA_MAP_FLAG_MMIO;
>  
>  	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index c8dbf8219c4f..68002c8f1157 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1560,6 +1560,7 @@ struct vfio_iommu_type1_dma_map {
>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
>  #define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
> +#define VFIO_DMA_MAP_FLAG_MMIO (1 << 3)     /* map of mmio */
>  	__u64	vaddr;				/* Process virtual address */
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */


