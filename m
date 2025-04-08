Return-Path: <kvm+bounces-42960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 761D0A815C2
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D79163BB6C9
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 19:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4611924394F;
	Tue,  8 Apr 2025 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2T97pAv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53F6237163
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744140224; cv=none; b=IJ5vuPMcKsYgCxpCvNg02kasmOSGrIgSwjYqNFSIkgKoiinD5SWl08sd5YJ9jDcVLaTCNZN0FT6rI3Wy/2jtn5BgvMEXImAKhESMNEwQaFPYFe3R8xt/CI1MKf01+CniAGd++406HAqRngxBc8FtcY86N/DRfY8CF6SXVGH3hoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744140224; c=relaxed/simple;
	bh=aZjnx4k43TZJP1DU6AtSucAMCAwDGEtYxx41zjdlcRY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDRccBR24NfIWQGZDanm+emFKcyzZbNwR8cMVR57NBwKDYeZAHzCWpwLUlMVyyZzEQS9BrdV7wknsKP0YVVJUEEjTCrx7LXJgJoF9GFxg+SV7LDS4NpqrY6LAHi77Jj3QcPueMPoX/ihXkj50yWc3S45lMLwQEYUFowvqHILJ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e2T97pAv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744140220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9OWGT0Rx0UMQmXQEzPjRVbJHTFL3Bqbn7wRQe/nSuc=;
	b=e2T97pAvi0iqpwX4Bjg8GI3YXnKjDbJKboz8NQMCcLmzMqO7Qbkknivt29HgltvZ4rPOHF
	TCz/hyTvOGNP4565JeomOYKlioHEO16FgZQR4S8r+3JxM/4O3gfZ9ZzRWLt8DzHubRCF+a
	5edRbSXQcmDwKEO1Bnpd6RQ6VwiyPl4=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-Bof4xm8YNWSe2OD_4fC6WQ-1; Tue, 08 Apr 2025 15:23:39 -0400
X-MC-Unique: Bof4xm8YNWSe2OD_4fC6WQ-1
X-Mimecast-MFC-AGG-ID: Bof4xm8YNWSe2OD_4fC6WQ_1744140218
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3f7d6197772so164940b6e.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 12:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744140218; x=1744745018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9OWGT0Rx0UMQmXQEzPjRVbJHTFL3Bqbn7wRQe/nSuc=;
        b=LjcdgBkx+02Rwu1Ak+lNkkd/bO1bYpuy3L/dwMZFUAO4DsIGEdsLFS0oGCd8Ww8Lmp
         0Kc29YQGTFMkDfgrHKK31SDmnv9G1X1BkwCBafv7DYBZ5eRzle2dTkhZFfeEfz0sZSkr
         muj6NK45vbcuqq6ukgSvaRzs8XS3Wq3L0v2KT+KId9QX4NpNJyYJZP1Y4WtiqYdH9s/h
         ZRQof8SDTjWhe4FXfCfWfbxomtgQy9E7s/8td8tgHf7oWZQmmwWa+b0hZfqq3P7zHnbt
         HOb/ew/E5iOrjOPiKOmfFLlPAFsb9wOTuBvhHci5Rp0UzayJhKEXJqWUks9+IobM2L2M
         XVXw==
X-Forwarded-Encrypted: i=1; AJvYcCX/my9q86pn14Vb71djvzUgM0g5cywUZYw1L/IxJcguVbpe6Vj8xyqN5M2/6U80PDI4kC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLrcWwhIXnphYzg6c9LHf6Oyya7GpMZ9uiG3wFiAHlQ3xWuudY
	ROlxRTAbQC4QF+C54Lm3EaQfQGjPzQZ6Ie3J7rrRfqf2mcip2r7tLoyMEUAkZJpQXu2L9rrJzGR
	Ujbuu+CQLqtGaX0R9fyCJWACFFDOmbytFdFhV3v0ux+GljaF+4hMJgy18yw==
X-Gm-Gg: ASbGncsEVvBxRc2KH5mepBayKuG0R1S1Uo9+M5JkqT+ffLi2Mgrs750nso+70reQkZ0
	sgz42weimcANqROMP2NrCK+6QwKOO+fqL1l16GRGmw/ip19m3Dt8x3MTTyY1rYdeOAqkTfHnIyH
	G5r/GiHTkiMt8HLr5jOazPYnpkuRtzlX5snAQlKLg9QIdoi4heuiaC2tQtHY0Tkl8wls9cp9Q+O
	/CWpZ6stbRjJ+nacD8crRtXVGt5fjsm07MQsokZed+d5yLOSIEHA6eQLPEWKLmIo6Md8ATgs1Z5
	wUJgv/HcC3F67MfYkR0=
X-Received: by 2002:a4a:e042:0:b0:600:24f9:21fc with SMTP id 006d021491bc7-6045ca7f1b4mr44215eaf.2.1744140217885;
        Tue, 08 Apr 2025 12:23:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV+MA4e1zCg14ovKPYZ7n17MAgow6OrOKLo569urIyPfVcFprCJ+gldjemcdqQgow5RJkg3w==
X-Received: by 2002:a4a:e042:0:b0:600:24f9:21fc with SMTP id 006d021491bc7-6045ca7f1b4mr44214eaf.2.1744140217514;
        Tue, 08 Apr 2025 12:23:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6044f951c8fsm542187eaf.30.2025.04.08.12.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 12:23:36 -0700 (PDT)
Date: Tue, 8 Apr 2025 13:23:33 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/type1: Remove Fine Grained Superpages detection
Message-ID: <20250408132333.382ab143.alex.williamson@redhat.com>
In-Reply-To: <0-v1-0eed68063e59+93d-vfio_fgsp_jgg@nvidia.com>
References: <0-v1-0eed68063e59+93d-vfio_fgsp_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  8 Apr 2025 14:39:52 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> VFIO is looking to enable an optimization where it can rely on the
> unmap operation not splitting and returning the size of a larger IOPTE.
> 
> However since commits:
>   d50651636fb ("iommu/io-pgtable-arm-v7s: Remove split on unmap behavior")
>   33729a5fc0ca ("iommu/io-pgtable-arm: Remove split on unmap behavior")
> 
> There are no iommu drivers that do split on unmap anymore. Instead all
> iommu drivers are expected to unmap the whole contiguous page and return
> its size.
> 
> Thus, there is no purpose in vfio_test_domain_fgsp() as it is only
> checking if the iommu supports 2*PAGE_SIZE as a contiguous page or not.
> 
> Currently only AMD v1 supports such a page size so all this logic only
> activates on AMD v1.
> 
> Remove vfio_test_domain_fgsp() and just rely on a direct 2*PAGE_SIZE check
> instead so there is no behavior change.
> 
> Maybe it should always activate the iommu_iova_to_phys(), it shouldn't
> have a performance downside since split is gone.

We were never looking for splitting here, in fact an IOMMU driver that
supports splitting would break the fgsp test.  Nor was the intent ever
to look for 2*PAGE_SIZE support.  This was simply a test to see if we
mapped two contiguous pages and tried to unmap only the first, does the
IOMMU unmap only the first page (VT-d), or both pages (AMD v1).  If both
pages are unmapped, then we expect the same behavior with runtime
mappings, ie. the IOMMU will unmap larger chunks than we've asked for
based on whether the original mapping was contiguous.  If only one page
is unmapped, then we need to look for contiguous ranges ourselves.

We also previously couldn't rely on pgsize_bitmap to indicate the
physical page sizes supported by the IOMMU, ex. VT-d essentially
reported PAGE_MASK util a886d5a7e67b ("iommu/vt-d: Report real pgsize
bitmap to iommu core").

I don't recall the optimization being overwhelming in the first place,
so if it's relegated to AMD v1 maybe we should just remove it
altogether rather than introducing this confusing notion that
2*PAGE_SIZE has some particular importance.  Thanks,

Alex

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 71 +++++++++------------------------
>  1 file changed, 19 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac56072af9f23..529561bbbef98a 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -80,7 +80,6 @@ struct vfio_domain {
>  	struct iommu_domain	*domain;
>  	struct list_head	next;
>  	struct list_head	group_list;
> -	bool			fgsp : 1;	/* Fine-grained super pages */
>  	bool			enforce_cache_coherency : 1;
>  };
>  
> @@ -1056,6 +1055,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	LIST_HEAD(unmapped_region_list);
>  	struct iommu_iotlb_gather iotlb_gather;
>  	int unmapped_region_cnt = 0;
> +	bool scan_for_contig;
>  	long unlocked = 0;
>  
>  	if (!dma->size)
> @@ -1079,9 +1079,15 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		cond_resched();
>  	}
>  
> +	/*
> +	 * For historical reasons this has only triggered on AMDv1 page tables,
> +	 * though these days it should work everywhere.
> +	 */
> +	scan_for_contig = !(domain->domain->pgsize_bitmap & (2 * PAGE_SIZE));
>  	iommu_iotlb_gather_init(&iotlb_gather);
>  	while (iova < end) {
> -		size_t unmapped, len;
> +		size_t len = PAGE_SIZE;
> +		size_t unmapped;
>  		phys_addr_t phys, next;
>  
>  		phys = iommu_iova_to_phys(domain->domain, iova);
> @@ -1094,12 +1100,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		 * To optimize for fewer iommu_unmap() calls, each of which
>  		 * may require hardware cache flushing, try to find the
>  		 * largest contiguous physical memory chunk to unmap.
> +		 *
> +		 * If the iova is part of a contiguous page > PAGE_SIZE then
> +		 * unmap will unmap the whole contiguous page and return its
> +		 * size.
>  		 */
> -		for (len = PAGE_SIZE;
> -		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
> -			next = iommu_iova_to_phys(domain->domain, iova + len);
> -			if (next != phys + len)
> -				break;
> +		if (scan_for_contig) {
> +			for (; iova + len < end; len += PAGE_SIZE) {
> +				next = iommu_iova_to_phys(domain->domain,
> +							  iova + len);
> +				if (next != phys + len)
> +					break;
> +			}
>  		}
>  
>  		/*
> @@ -1833,49 +1845,6 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> -/*
> - * We change our unmap behavior slightly depending on whether the IOMMU
> - * supports fine-grained superpages.  IOMMUs like AMD-Vi will use a superpage
> - * for practically any contiguous power-of-two mapping we give it.  This means
> - * we don't need to look for contiguous chunks ourselves to make unmapping
> - * more efficient.  On IOMMUs with coarse-grained super pages, like Intel VT-d
> - * with discrete 2M/1G/512G/1T superpages, identifying contiguous chunks
> - * significantly boosts non-hugetlbfs mappings and doesn't seem to hurt when
> - * hugetlbfs is in use.
> - */
> -static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *regions)
> -{
> -	int ret, order = get_order(PAGE_SIZE * 2);
> -	struct vfio_iova *region;
> -	struct page *pages;
> -	dma_addr_t start;
> -
> -	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> -	if (!pages)
> -		return;
> -
> -	list_for_each_entry(region, regions, list) {
> -		start = ALIGN(region->start, PAGE_SIZE * 2);
> -		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
> -			continue;
> -
> -		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
> -				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE,
> -				GFP_KERNEL_ACCOUNT);
> -		if (!ret) {
> -			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
> -
> -			if (unmapped == PAGE_SIZE)
> -				iommu_unmap(domain->domain, start + PAGE_SIZE, PAGE_SIZE);
> -			else
> -				domain->fgsp = true;
> -		}
> -		break;
> -	}
> -
> -	__free_pages(pages, order);
> -}
> -
>  static struct vfio_iommu_group *find_iommu_group(struct vfio_domain *domain,
>  						 struct iommu_group *iommu_group)
>  {
> @@ -2314,8 +2283,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		}
>  	}
>  
> -	vfio_test_domain_fgsp(domain, &iova_copy);
> -
>  	/* replay mappings on new domains */
>  	ret = vfio_iommu_replay(iommu, domain);
>  	if (ret)
> 
> base-commit: 5a7ff05a5717e2ac4f4f83bcdd9033f246e9946b


