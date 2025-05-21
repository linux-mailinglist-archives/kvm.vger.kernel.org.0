Return-Path: <kvm+bounces-47307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E40DABFD37
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 21:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6123B1BC4CD3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 19:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897F628ECD9;
	Wed, 21 May 2025 19:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwnmEjUZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A0522173C
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 19:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747855039; cv=none; b=e5MNqJtYY2pQLQuwor51wyFT2yyHd1+jj1/rJIsh3DY9vskUIULgSg6gRp/+EZn1VnPj7HCeAeKUH0Y/dA2e4ruhhW8eU6jhabzYUmN/DtspOIzQStY/fP7/xIhUrFhtVkM5NVsF44GdyH+sRwd85Jzy7UXa8soeCZXVeujgq/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747855039; c=relaxed/simple;
	bh=9kZv0wB7aYOjgY0M3wV8Agi5BwVU9rPueqNiaXYr230=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cevl0LkHZ2hpL+2iviYsyBGw5Tp162GmSESR6n7ecH5WdJp/C82coPRpin1YbxKgZgrSPPW3HukkxMVP208BvqCKlaLyDlLayl02A4Aaab2i3KGSzqSFClKT+Km9fDYONdfbDhfUWBJg201vCDIYdRpy5eLBnhJi3j6KDxoQPLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cwnmEjUZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747855036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJXXXDW4PYAr8Jjvjaer7RTmIfx81VQn47DGQ6gp/X4=;
	b=cwnmEjUZwY4yoJwThopPL1OSBnuyhcSUDviCGZh+MHWkv2JHpELoULz18ZzVuMPfTY4C5x
	Tziic956THPxvzviBS0SIdwO1lrI1fNchZTclmYkvCEFnT9QkmIEoDO/mlQHKDx0EJE3nR
	Qouke4lwvW7nrvL/O/O0Xj34nim+g4o=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-PN6B_ppkM2WKOg8DVlDLcA-1; Wed, 21 May 2025 15:17:15 -0400
X-MC-Unique: PN6B_ppkM2WKOg8DVlDLcA-1
X-Mimecast-MFC-AGG-ID: PN6B_ppkM2WKOg8DVlDLcA_1747855034
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85b3e93e052so127672539f.3
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 12:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747855034; x=1748459834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJXXXDW4PYAr8Jjvjaer7RTmIfx81VQn47DGQ6gp/X4=;
        b=rLCn1NT/yxBDP0sjGS6PFLRx3VYt99oMXcnf71I4WovkZRqHoH2H/pK/GBxLqaPutc
         phJ1rDRww82bb8UsRhrA12Dun8bo2a7Hrl3VnZeugF1+Jo6KXUvMT1jsC6zlaYH9gJm9
         KOsbOQxzQ+ekLXTNZpEmDkcNhy5YE89Fl2cDV4zsy9Y/Vn1Ik+MpP6jjrzMV+rCDJgJV
         +3SrWVwG9WB0nxzOunbwYnmCPmdenxxA2P2eOLnUHsywcDD/G9xXoCsFnlWRZG6fLDN4
         tS360TJaoVe4UK1lvz648jyyrFxoO6RR/+znbfryu0hc66UmVVQzeeE9NLxPGUfJCHRg
         Lfeg==
X-Forwarded-Encrypted: i=1; AJvYcCXJiFIYn5lRIdF5bXGmXHnwtLqPUiYTUHeAd2Bv2nqcfS45is+SYPESfcerXmi34+CbdDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsoFYyN5p6b4dk4OPIvuZVx6K4PVpytXrLhPMR5bSLrRgy115/
	ChcZPbCJhrTaGToFNINz0AViUlo40E0sgbU3TmZ20yM6X1mIAbQ+w3IMsMYiOGzy84dMj63iRk/
	86+M6ayr9Bemyjj/wmBLU6LcNIVuAAkdgq/gi5ZogSE5+Gn2ZhRsLLA==
X-Gm-Gg: ASbGnctR4zXyUM/k5xk+U0bQQIoqFAv/0UkrGK1rUM5l9dHVYlAkX4xSM5GuiFjiMe/
	j0BQjgYUjn0wkIZBpZIPjHenh8HEH6/oXsWAwsEz42mwWAvl+fmluzdvLh1d7F50w5uQjZh2i6b
	dHMhgmNqUp3VYY1TVgTr3HdZyJXxnb6KXkcjx2HlKKKQ6zh4q5zQdvYe8TPHDOIjSEj08Srx5ut
	Qzh6nudc5YBe8wbzL6OT41Ga+ORim4OwuiuyYULHkyRNKKv53VA/vB9lQJZ6ZYhM+S/N/ZbVOwP
	HHBik5MOwY6NIWc=
X-Received: by 2002:a05:6602:2d8d:b0:85d:9738:54ac with SMTP id ca18e2360f4ac-86a2319bcf3mr742130939f.2.1747855034250;
        Wed, 21 May 2025 12:17:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSvVThNYy1+dND2QTneRwGhWDuKajIiFFHmLrsqDkQp1WNz78tRhTCrOQoZ5e3B+h1U5LwsA==
X-Received: by 2002:a05:6602:2d8d:b0:85d:9738:54ac with SMTP id ca18e2360f4ac-86a2319bcf3mr742129539f.2.1747855033881;
        Wed, 21 May 2025 12:17:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86a2360cb1esm266746339f.24.2025.05.21.12.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 12:17:13 -0700 (PDT)
Date: Wed, 21 May 2025 13:17:11 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for
 large folios
Message-ID: <20250521131711.4e0d3f2f.alex.williamson@redhat.com>
In-Reply-To: <20250521042507.77205-1-lizhe.67@bytedance.com>
References: <20250521042507.77205-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 May 2025 12:25:07 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> This patch optimize this process by batching the statistics counting
> operations.
> 
> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> obtained through trace-cmd, are as follows. In this case, the 8G virtual
> address space has been mapped to physical memory using hugetlbfs with
> pagesize=2M.
> 
> Before this patch:
> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> 
> After this patch:
> funcgraph_entry:      # 16071.378 us |  vfio_pin_map_dma();
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Given the discussion on v3, this is currently a Nak.  Follow-up in that
thread if there are further ideas how to salvage this.  Thanks,

Alex

> Changelogs:
> 
> v3->v4:
> - Use min_t() to obtain the step size, rather than min().
> - Fix some issues in commit message and title.
> 
> v2->v3:
> - Code simplification.
> - Fix some issues in comments.
> 
> v1->v2:
> - Fix some issues in comments and formatting.
> - Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
> - Move the processing logic for hugetlbfs folio into the while(true) loop
>   and use a variable with a default value of 1 to indicate the number of
>   consecutive pages.
> 
> v3 patch: https://lore.kernel.org/all/20250520070020.6181-1-lizhe.67@bytedance.com/
> v2 patch: https://lore.kernel.org/all/20250519070419.25827-1-lizhe.67@bytedance.com/
> v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
> 
>  drivers/vfio/vfio_iommu_type1.c | 48 +++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac56072af9f..bd46ed9361fe 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -319,15 +319,22 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>  /*
>   * Helper Functions for host iova-pfn list
>   */
> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +
> +/*
> + * Find the first vfio_pfn that overlapping the range
> + * [iova, iova + PAGE_SIZE * npage) in rb tree.
> + */
> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> +		dma_addr_t iova, unsigned long npage)
>  {
>  	struct vfio_pfn *vpfn;
>  	struct rb_node *node = dma->pfn_list.rb_node;
> +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
>  
>  	while (node) {
>  		vpfn = rb_entry(node, struct vfio_pfn, node);
>  
> -		if (iova < vpfn->iova)
> +		if (end_iova <= vpfn->iova)
>  			node = node->rb_left;
>  		else if (iova > vpfn->iova)
>  			node = node->rb_right;
> @@ -337,6 +344,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>  	return NULL;
>  }
>  
> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +{
> +	return vfio_find_vpfn_range(dma, iova, 1);
> +}
> +
>  static void vfio_link_pfn(struct vfio_dma *dma,
>  			  struct vfio_pfn *new)
>  {
> @@ -681,32 +693,46 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  		 * and rsvd here, and therefore continues to use the batch.
>  		 */
>  		while (true) {
> +			struct folio *folio = page_folio(batch->pages[batch->offset]);
> +			long nr_pages;
> +
>  			if (pfn != *pfn_base + pinned ||
>  			    rsvd != is_invalid_reserved_pfn(pfn))
>  				goto out;
>  
> +			/*
> +			 * Note: The current nr_pages does not achieve the optimal
> +			 * performance in scenarios where folio_nr_pages() exceeds
> +			 * batch->capacity. It is anticipated that future enhancements
> +			 * will address this limitation.
> +			 */
> +			nr_pages = min_t(long, batch->size, folio_nr_pages(folio) -
> +						folio_page_idx(folio, batch->pages[batch->offset]));
> +			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
> +				nr_pages = 1;
> +
>  			/*
>  			 * Reserved pages aren't counted against the user,
>  			 * externally pinned pages are already counted against
>  			 * the user.
>  			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (!rsvd && (nr_pages > 1 || !vfio_find_vpfn(dma, iova))) {
>  				if (!dma->lock_cap &&
> -				    mm->locked_vm + lock_acct + 1 > limit) {
> +				    mm->locked_vm + lock_acct + nr_pages > limit) {
>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>  						__func__, limit << PAGE_SHIFT);
>  					ret = -ENOMEM;
>  					goto unpin_out;
>  				}
> -				lock_acct++;
> +				lock_acct += nr_pages;
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


