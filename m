Return-Path: <kvm+bounces-52206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA3FB0266F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63B345A0A9F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 21:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ABF1EFF8D;
	Fri, 11 Jul 2025 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tu/kR/Fr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209691D90A5
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 21:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752269730; cv=none; b=cC5J4P8oep/k4lkqcNR1ukzCuNC9/ObYXqVNkNjOz/T4mcqm0eHob3aOx8cX9N8dXCPTDtNLMcBfDG5vqV+1tt9pGT6auyCRP+HiPj3YlYSy+jxn9l7c/soJm9d5mSYZtqmmNJcFPp0nPXZ4tC0YNn1Wx+AftYRZcYtUEWx20Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752269730; c=relaxed/simple;
	bh=OUcUNJcRYDEm75ZahQ2/IVIkiNvpeKnv3wB3UibZRHI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVw8SD2GM7zYcjWR8A+t4fXZye5C39+5uT8rOegSyZH5iw7dRsioTvHRHp+M3xi3H45LACtUYW9PdKlChYcU13v5DbXQcTcYirkxQ5j7JzpVKHpd/4a+r9+015t23Y53DXbWXANltB4KuwS0wLzh5eHwOWgsbi+NiMIEUwWRCs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tu/kR/Fr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752269728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GgkWm7qRDs+Q41tEmKDUfbmdZCqmGjrzM3iUWhFiHo4=;
	b=Tu/kR/FrLWKB7x+NplPxx3Y1Z7SpgUaa0gN1tp9tcTOMgm5r1JhUGbItbx8sv1tJpDI/Pf
	pZXioQSfS9ELrYYYlWjP7eLw1nG+hM27YyQ6KpclZY9Sh/433h5vW3xUhjgX2H8TRtmSzT
	6qm/3p9W0x9kur9ARZ6bS8w89mI3/Ps=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-zNRxczmkOTGPKh44kgi3fQ-1; Fri, 11 Jul 2025 17:35:27 -0400
X-MC-Unique: zNRxczmkOTGPKh44kgi3fQ-1
X-Mimecast-MFC-AGG-ID: zNRxczmkOTGPKh44kgi3fQ_1752269726
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-86cfa305eb6so11310539f.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752269726; x=1752874526;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GgkWm7qRDs+Q41tEmKDUfbmdZCqmGjrzM3iUWhFiHo4=;
        b=gYPu4oCecngpkVd+rQYXGavynHnFmZVRGpa4CTxZ0xqbE656eDJqcgGkpfkYIMYzD9
         kuKsZ0fmVFNgV1uqFw2Buo5vemBHUL9JmGQGRMkBxXlLGXN4vvZj3Jn2lyrFxP3Gor21
         00Pn6FS1idvogUgdt+Uo+gynCZrjfIpXCnVGp1wlClRimOg9TettSTcFUhiPMt4S8QFL
         lBQIHyXXktJMpnQii4xIP7nSRBNcT+BCsPyagHerwKSUf0P7tQXbuqsb02X9mj6DBUvU
         Ic0S2ZlJOuJI0pvi+6tK3C8nioh5Fl8U0DSdzH4P0Fmle4w9QcyJD8U9EZIOa5sE5BgQ
         rbBw==
X-Forwarded-Encrypted: i=1; AJvYcCXyowi+seoPMeb5qCoXUV0YwL5fPXf/X0urSHE7eHOBVHflWi5BovXKvW2xJ4YWGkF3yak=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsREycidBITcXMsHOE02GtX8wms6Ahk30lfp/XySWnYFdGj5n/
	1cy1ggxDNexmebEjaAlO8UhtXmIySf9LzzeHd9enqelug99oGZ45lBTuu+p7E+wOeRgnYNR6Rtn
	iS+FMcHqkpCw5xXSGsfQHKF3H3d9lm+sWhBCPQxwmSNdULc+kL5zyjQ==
X-Gm-Gg: ASbGncsJq2EjSXeSiAvhlykcXyizVTuNXg0TEIis3IfsLvX/QxuYy7fHqrnRi22A1XD
	TEe/QZZ7m4cF3XKcmhmdd54WfrS2m6aZSSZEA4yVLDX2hdtNtJgzHjCcJDlmc53rPBtPyVAaFdA
	EsjOB+VaXTYUy7Fi7Zb2srB7+DA5JBTZg1mCZE7GPh32Kv3VYSojgknmrQzoz/hsizTBT5uEH/w
	RNoz1QGJxMCQ7c1GK+raEj3H6RgkFQUNdk2SrOjPk+YwnwHgGQ6WyclTEYpiEOUNVvCWYpYDOOX
	OxaBCqY7ELGls9ASGWxKUuBk1BB8sp31v6XFjZ5ogVU=
X-Received: by 2002:a05:6602:1688:b0:85e:12c1:fe90 with SMTP id ca18e2360f4ac-879792f8fbemr145243439f.5.1752269726188;
        Fri, 11 Jul 2025 14:35:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgzikGdHj30Bq9CuVwdpEt36LfpGDi5nuIaLVIiPS6ipxZYS3T0Muy4zgTBSWsG9GGcy2HpQ==
X-Received: by 2002:a05:6602:1688:b0:85e:12c1:fe90 with SMTP id ca18e2360f4ac-879792f8fbemr145242639f.5.1752269725706;
        Fri, 11 Jul 2025 14:35:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556b1d379sm989950173.129.2025.07.11.14.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 14:35:25 -0700 (PDT)
Date: Fri, 11 Jul 2025 15:35:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, david@redhat.com, jgg@ziepe.ca,
 peterx@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Message-ID: <20250711153523.42d68ec0.alex.williamson@redhat.com>
In-Reply-To: <20250710085355.54208-3-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
	<20250710085355.54208-3-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Jul 2025 16:53:52 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> Batch processing of statistical counting operations can effectively enhance
> performance.
> 
> In addition, the pages obtained through longterm GUP are neither invalid
> nor reserved. Therefore, we can reduce the overhead associated with some
> calls to function is_invalid_reserved_pfn().
> 
> The performance test results for completing the 16G VFIO IOMMU DMA mapping
> are as follows.
> 
> Base(v6.16-rc4):
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.047 s (340.2 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.280 s (57.2 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.052 s (310.5 GB/s)
> 
> With this patch:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.027 s (602.1 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.257 s (62.4 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.031 s (517.4 GB/s)
> 
> For large folio, we achieve an over 40% performance improvement.
> For small folios, the performance test results indicate a
> slight improvement.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
>  1 file changed, 71 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1136d7ac6b59..6909275e46c2 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -318,7 +318,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>  /*
>   * Helper Functions for host iova-pfn list
>   */
> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +
> +/*
> + * Find the highest vfio_pfn that overlapping the range
> + * [iova_start, iova_end) in rb tree.
> + */
> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> +		dma_addr_t iova_start, dma_addr_t iova_end)
>  {
>  	struct vfio_pfn *vpfn;
>  	struct rb_node *node = dma->pfn_list.rb_node;
> @@ -326,9 +332,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>  	while (node) {
>  		vpfn = rb_entry(node, struct vfio_pfn, node);
>  
> -		if (iova < vpfn->iova)
> +		if (iova_end <= vpfn->iova)
>  			node = node->rb_left;
> -		else if (iova > vpfn->iova)
> +		else if (iova_start > vpfn->iova)
>  			node = node->rb_right;
>  		else
>  			return vpfn;
> @@ -336,6 +342,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>  	return NULL;
>  }
>  
> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +{
> +	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> +}
> +
>  static void vfio_link_pfn(struct vfio_dma *dma,
>  			  struct vfio_pfn *new)
>  {
> @@ -614,6 +625,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>  	return ret;
>  }
>  
> +
> +static long vpfn_pages(struct vfio_dma *dma,
> +		dma_addr_t iova_start, long nr_pages)
> +{
> +	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> +	struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
> +	long ret = 1;
> +	struct vfio_pfn *vpfn;
> +	struct rb_node *prev;
> +	struct rb_node *next;
> +
> +	if (likely(!top))
> +		return 0;
> +
> +	prev = next = &top->node;
> +
> +	while ((prev = rb_prev(prev))) {
> +		vpfn = rb_entry(prev, struct vfio_pfn, node);
> +		if (vpfn->iova < iova_start)
> +			break;
> +		ret++;
> +	}
> +
> +	while ((next = rb_next(next))) {
> +		vpfn = rb_entry(next, struct vfio_pfn, node);
> +		if (vpfn->iova >= iova_end)
> +			break;
> +		ret++;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  		 * and rsvd here, and therefore continues to use the batch.
>  		 */
>  		while (true) {
> +			long nr_pages, acct_pages = 0;
> +
>  			if (pfn != *pfn_base + pinned ||
>  			    rsvd != is_invalid_reserved_pfn(pfn))
>  				goto out;
>  
> +			/*
> +			 * Using GUP with the FOLL_LONGTERM in
> +			 * vaddr_get_pfns() will not return invalid
> +			 * or reserved pages.
> +			 */
> +			nr_pages = num_pages_contiguous(
> +					&batch->pages[batch->offset],
> +					batch->size);
> +			if (!rsvd) {
> +				acct_pages = nr_pages;
> +				acct_pages -= vpfn_pages(dma, iova, nr_pages);
> +			}
> +
>  			/*
>  			 * Reserved pages aren't counted against the user,
>  			 * externally pinned pages are already counted against
>  			 * the user.
>  			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (acct_pages) {
>  				if (!dma->lock_cap &&
> -				    mm->locked_vm + lock_acct + 1 > limit) {
> +				     mm->locked_vm + lock_acct + acct_pages > limit) {

Don't resend, I'll fix on commit, but there's still a gratuitous
difference in leading white space from the original.  Otherwise the
series looks good to me but I'll give Jason a little more time to
provide reviews since he's been so active in the thread (though he'd
rather we just use iommufd ;).  Thanks,

Alex

>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>  						__func__, limit << PAGE_SHIFT);
>  					ret = -ENOMEM;
>  					goto unpin_out;
>  				}
> -				lock_acct++;
> +				lock_acct += acct_pages;
>  			}
>  
> -			pinned++;
> -			npage--;
> -			vaddr += PAGE_SIZE;
> -			iova += PAGE_SIZE;
> -			batch->offset++;
> -			batch->size--;
> +			pinned += nr_pages;
> +			npage -= nr_pages;
> +			vaddr += PAGE_SIZE * nr_pages;
> +			iova += PAGE_SIZE * nr_pages;
> +			batch->offset += nr_pages;
> +			batch->size -= nr_pages;
>  
>  			if (!batch->size)
>  				break;


