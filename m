Return-Path: <kvm+bounces-49333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 125B2AD7E6A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 541897AE8F7
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 22:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9882DECDD;
	Thu, 12 Jun 2025 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MykXgfUT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAA82D6600
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749767568; cv=none; b=dM0uxPPxoOqTM9UwWRrK4UsUKnIdNeoQeH1xGs2sUtpJ4t+hlDt/eIspQ27/D8foU0XxSVgI7Mbj75Ir0WdFjt0Yj5ZpZr/WZAOky8KJ4qhEQRLNjrZxm70SS7vmD4mtmeIb0ZXEMxjz5t0mrnKLQ7vu3db56gIh0rXueW48VWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749767568; c=relaxed/simple;
	bh=ctdtthRBf734RF+bRXRAg1huSW90W+IfRetliFxoKTY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJ+tcY/NHMa4/PBLaht4h4jIeLNUHVHm8NSzF1zhgya0PJYBHQv2Ct1EtWY9RrpbA/gXuAXzdZSlv5jfyzgTRe5v7SCc/pTx11iEVOfJp6R6GRxi1dHi3pQ5JiLuU5qLyjFZD4L017IDC7r1a11tLUlkTjBE/fsqvG5J2BrVEf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MykXgfUT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749767565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6EkmZKkEbCw6g+yAHEMJk9YyAvmLNqFOuK+gidHgpWQ=;
	b=MykXgfUTn4JY3cAh2nZsWtsFjXLMmE4N31ezaUtUxpFObMg5c/T6ROkPbDoEXD0RxlnbMM
	4hq2Jsx0JQ+r6j88HhmNXMV2KJ16ac5Ty72EtjRZvYw49lbqsE0HJ3HZq4bq1JEHPyAYFl
	f3DRWsXiLPP+7pfAVll+j5viZT0yFcU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-UcYPLTPxO2mV9Vw7KOthXw-1; Thu, 12 Jun 2025 18:32:44 -0400
X-MC-Unique: UcYPLTPxO2mV9Vw7KOthXw-1
X-Mimecast-MFC-AGG-ID: UcYPLTPxO2mV9Vw7KOthXw_1749767563
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-875cdf03c23so11292839f.2
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 15:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749767563; x=1750372363;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6EkmZKkEbCw6g+yAHEMJk9YyAvmLNqFOuK+gidHgpWQ=;
        b=B/Yabqms6B/Er8Kgrkxvt0OnOvOpu83g8aHRThrs0ZHG1llLowOmusj+mT/jB1YhF/
         DG62w73ZWzrUEYYNtiu5Y/8OYQlHVCPU7Crhbq91TxdoUxfd5Boh7wyduVsSDAlyPIvp
         U9ZHIPB3lS3fVIz3CmPYAhO+EsM1lqeCCaiG4zn1QVKCFsavRbSY1eGCbt3PKoJIgank
         fWk3g8fcHMtH+noxTmxqBN2ULaJGiOMSBWtjY7BngsmEhdxhmzKk1n3Bx+MdnmcyycfE
         sZBsz5ZwZG7H44nEpJyIvOAQkzGcB/piKsir8nEhXQR/RZ5EyBtlsKN+MZVLP7Gcn7b/
         VatA==
X-Gm-Message-State: AOJu0Ywe0whTM/dOWRwkgfEY1EGGJiWFXX/QrC+7IigpgROSXLhtrygX
	VZJ0m/xYNj9/vePw+124j53f07VD133GAgmOT80moTyRR+7rObhd1JjvVrxlKhQrRv07aaia4HI
	HfUKA/c6SJ2fNz4fynibpJ9aJtElGWZPMIxBADmDuctABIN7vAmsEOw==
X-Gm-Gg: ASbGnctYeiXhVEUwFNaV36g0euuY55CV5as8O5l5SuE2KS6AJDWrPxrWi6j3IQ7zpbK
	83Cmr76n1I5jPWZkOMOO7PrPm8RRqrGbCVor92xnSN9wUbXlKA5Gf/tjfH2Ip7ZZTB/HHv6XYop
	Toit+7DR/DUgfhmkEWyuFU7iSYtXSi3jD7MzlBy8/rcbxKAiT6c4KLDVxC188AYHq0DLQymURz2
	B5kEQmGp3iBUxKHO8xmw32LMekHk5PyPfMAAx4B+fOUndLfD1HGsf4fkG9nMeR2ZiosYqi47CQZ
	oKsOhvcSXuhbOMvuQ8iON3bvOw==
X-Received: by 2002:a05:6e02:1c23:b0:3dd:990b:83e3 with SMTP id e9e14a558f8ab-3de00a146a1mr2862845ab.0.1749767563159;
        Thu, 12 Jun 2025 15:32:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECFjWxtIl10OpsNKUPkSqSRGbG0DNH2aN/PiID4uxi4rhkt+zNmPyfwseizCMRqeeZbRBHWg==
X-Received: by 2002:a05:6e02:1c23:b0:3dd:990b:83e3 with SMTP id e9e14a558f8ab-3de00a146a1mr2862815ab.0.1749767562754;
        Thu, 12 Jun 2025 15:32:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de019d11e8sm130095ab.30.2025.06.12.15.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 15:32:41 -0700 (PDT)
Date: Thu, 12 Jun 2025 16:32:39 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
 <peterx@redhat.com>, David Hildenbrand <david@redhat.com>
Subject: Re: [RFC v2] vfio/type1: optimize vfio_unpin_pages_remote() for
 large folio
Message-ID: <20250612163239.5e45afc6.alex.williamson@redhat.com>
In-Reply-To: <20250610045753.6405-1-lizhe.67@bytedance.com>
References: <20250610045753.6405-1-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

[Cc+ David, Peter]

On Tue, 10 Jun 2025 12:57:53 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patch is based on patch 'vfio/type1: optimize vfio_pin_pages_remote()
> for large folios'[1].
> 
> When vfio_unpin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> put_pfn() operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> This patch optimize this process by batching the put_pfn() operations.
> 
> The performance test results, based on v6.15, for completing the 16G VFIO
> IOMMU DMA unmapping, obtained through unit test[2] with slight
> modifications[3], are as follows.
> 
> Base(v6.15):
> ./vfio-pci-mem-dma-map 0000:03:00.0 16
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.048 s (331.3 GB/s)
> VFIO UNMAP DMA in 0.138 s (116.1 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.281 s (57.0 GB/s)
> VFIO UNMAP DMA in 0.313 s (51.1 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.053 s (301.2 GB/s)
> VFIO UNMAP DMA in 0.139 s (115.2 GB/s)
> 
> Map[1] + This patches:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.028 s (578.4 GB/s)
> VFIO UNMAP DMA in 0.049 s (324.8 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.293 s (54.6 GB/s)
> VFIO UNMAP DMA in 0.308 s (51.9 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.032 s (494.5 GB/s)
> VFIO UNMAP DMA in 0.050 s (322.8 GB/s)
> 
> For large folio, we achieve an approximate 64% performance improvement
> in the VFIO UNMAP DMA item. For small folios, the performance test
> results appear to show no significant changes.
> 
> [1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
> [2]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
> [3]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
> Changelogs:
> 
> v1->v2:
> - Refactor the implementation of the optimized code
> 
> v1 patch: https://lore.kernel.org/all/20250605124923.21896-1-lizhe.67@bytedance.com/
> 
>  drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++--------
>  1 file changed, 41 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 28ee4b8d39ae..2f6c0074d7b3 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
>  	return true;
>  }
>  
> -static int put_pfn(unsigned long pfn, int prot)
> +static inline void _put_pfns(struct page *page, int npages, int prot)
>  {
> -	if (!is_invalid_reserved_pfn(pfn)) {
> -		struct page *page = pfn_to_page(pfn);
> +	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
> +}
>  
> -		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
> -		return 1;
> +/*
> + * The caller must ensure that these npages PFNs belong to the same folio.
> + */
> +static inline int put_pfns(unsigned long pfn, int npages, int prot)
> +{
> +	if (!is_invalid_reserved_pfn(pfn)) {
> +		_put_pfns(pfn_to_page(pfn), npages, prot);
> +		return npages;
>  	}
>  	return 0;
>  }
>  
> +static inline int put_pfn(unsigned long pfn, int prot)
> +{
> +	return put_pfns(pfn, 1, prot);
> +}
> +
>  #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
>  
>  static void __vfio_batch_init(struct vfio_batch *batch, bool single)
> @@ -805,15 +816,33 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    unsigned long pfn, unsigned long npage,
>  				    bool do_accounting)
>  {
> -	long unlocked = 0, locked = 0;
> -	long i;
> +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>  
> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> -		if (put_pfn(pfn++, dma->prot)) {
> -			unlocked++;
> -			if (vfio_find_vpfn(dma, iova))
> -				locked++;
> +	while (npage) {
> +		struct folio *folio;
> +		struct page *page;
> +		long step = 1;
> +
> +		if (is_invalid_reserved_pfn(pfn))
> +			goto next;
> +
> +		page = pfn_to_page(pfn);
> +		folio = page_folio(page);
> +
> +		if (!folio_test_large(folio)) {
> +			_put_pfns(page, 1, dma->prot);
> +		} else {
> +			step = min_t(long, npage,
> +				folio_nr_pages(folio) -
> +				folio_page_idx(folio, page));
> +			_put_pfns(page, step, dma->prot);
>  		}
> +
> +		unlocked += step;
> +next:

Usage of @step is inconsistent, goto isn't really necessary either, how
about:

	while (npage) {
		unsigned long step = 1;

		if (!is_invalid_reserved_pfn(pfn)) {
			struct page *page = pfn_to_page(pfn);
			struct folio *folio = page_folio(page);
			long nr_pages = folio_nr_pages(folio);

			if (nr_pages > 1)
				step = min_t(long, npage,
					nr_pages -
					folio_page_idx(folio, page));

			_put_pfns(page, step, dma->prot);
			unlocked += step;
		}

> +		pfn += step;
> +		iova += PAGE_SIZE * step;
> +		npage -= step;
>  	}
>  
>  	if (do_accounting)

AIUI, the idea is that we know we have npage contiguous pfns and we
currently test invalid/reserved, call pfn_to_page(), call
unpin_user_pages_dirty_lock(), and test vpfn for each individually.

This instead wants to batch the vpfn accounted pfns using the range
helper added for the mapping patch, infer that continuous pfns have the
same invalid/reserved state, the pages are sequential, and that we can
use the end of the folio to mark any inflections in those assumptions
otherwise.  Do I have that correct?

I think this could be split into two patches, one simply batching the
vpfn accounting and the next introducing the folio dependency.  The
contributions of each to the overall performance improvement would be
interesting.

I'll Cc some mm folks to see if they can punch holes in it.  Thanks,

Alex


