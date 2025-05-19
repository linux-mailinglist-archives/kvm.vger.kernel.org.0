Return-Path: <kvm+bounces-46996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B20ABC40A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0E4816EAB1
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57626288C8E;
	Mon, 19 May 2025 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dAYdNcPI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CB62857EA
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747670854; cv=none; b=hh7wrZZrdUjBo8V2tmV/FlBO0oq79Xj8XtWtxNFN0gfdamub9Jfx/PeAifVBeD2hg9mQZo0NB3Tk2VUY4M3wP639mBl6nb45g6HpZaCtcindxhH6fYgfM6pkknf6M7+FdoLMcOkh6vwn2jOCrRWi1ggkCO1JA+RK7Ft2K2MWtkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747670854; c=relaxed/simple;
	bh=hNEw6u4EAGJb1DB1bVNC/5/BMToJOqKdj2yoY4Jt1lk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e46zA1jBOdlPqL5WNKoKScWAWQ+eOn6kJkKPrSBGMNpe7KgnOlay+DAzJ8/RexkcbCcR/9uarIGMw8al1KHS+eZYrpWpov82TqZ8AgZVHpNiJZp2wMbO7QwP9o0V167UXuNQnhvCoAIdS8yE7aBepCkA8ZW4D5CxYF4HNl+BV2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dAYdNcPI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747670851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GYjpCzu4umHTb9XWgj4v2xAt07lJPlnlktCffQkFSlg=;
	b=dAYdNcPIieosAx7KWGf14a0J/nCJlgsi6kyEqPTcFYYtRmarKe0p0IgEG0PEWA206KJhqC
	MKDpMEtSh8zGotuRCafig8KZjFZI3noVwNl3lGc2vjz53H7z8Sn4XzJkksKOPclwzR9iIo
	1ZEngnwJBoOddItJvhPPkdlxoz2fa7k=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-nz__7dtWOqCRhvhdia3tgg-1; Mon, 19 May 2025 12:07:30 -0400
X-MC-Unique: nz__7dtWOqCRhvhdia3tgg-1
X-Mimecast-MFC-AGG-ID: nz__7dtWOqCRhvhdia3tgg_1747670848
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8649babc826so78840639f.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 09:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747670848; x=1748275648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYjpCzu4umHTb9XWgj4v2xAt07lJPlnlktCffQkFSlg=;
        b=CuQLJLGgbNunN2yMLe2973cOapxfAAVHhqtuuJsctUVRDfItCZKeCZmMQt5f0n/HOh
         7Xi+IMyZgDgTwJyPJ3WLUHDaiTfquP8TO1sItd5Vdyn5xgCxiaWkZcD+X9MT6RL5NGBP
         /aM0ntVV79VsDxa/gic7KmzkDl5y2flqwwUQkggQH5i3O3zabdGk7wJcK1+MMQ00yYPy
         TnfRdUw6t4GcMP3XF3rn5+uQVh1HtamOicMu0exfp5yl+aC4CVWbXKO0reGtnBlrHekY
         az1WsT+nDKrNeNl/7MpzlgEKRYiWW2366Yt+NcVVY0Ds/Sc2kza3exdezOFwXxPPPh/c
         wngw==
X-Gm-Message-State: AOJu0YyryF0Lzd08RtD7AVQ9IKWLS9ZG6BzZQJyysYV4BynCQeX+kv//
	RU+5C+vLNcSYgNTCnrr+JVhBzx0Nqu+NYSMrGnGkfj2sdZvRPw5X9VHOsbol2pnmHkXeHex0eTd
	EC7PCg1v99CNUka+RFGX5lNbBLP3ijA+zsZf+wpYmuG+nG+SFOe9zuQ==
X-Gm-Gg: ASbGnctCBURZRdkX7LYIKd4gNrguHmQXRmTWupnCw6WNyNDMNkhxyi3BZ3Oc+h14Eg+
	OkhNAleiTAemEsX90mm6e8h3cE8TS01pOTCI0GwTBp66M467sWYSJQrKy/qT4diuTpWpXOdH1bn
	Ip+/Oh0o/d8fBNxTnRJbPBImzEhu9PjcX/7kbdfSVEi5z7EhMOCOelbJz4R8BtFYYGb91CXgAgN
	dS5EmaoZTEpoqj6Rqo8B2WW+vPqr/kJlmkdgFaWcKGXDq6z32T0tfQnGln5jqotYgNhkGaUd3i7
	uMzenADFoxaQHRw=
X-Received: by 2002:a05:6602:1689:b0:85b:3f28:ff99 with SMTP id ca18e2360f4ac-86a231d1645mr481250339f.2.1747670847852;
        Mon, 19 May 2025 09:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtAn8Y71vVS4SgiQMLw5VEZe3qH5TqVf8MmbELUKPUbMF5+1cEG6jjieH5EM5q4B/OXdZgVA==
X-Received: by 2002:a05:6602:1689:b0:85b:3f28:ff99 with SMTP id ca18e2360f4ac-86a231d1645mr481248839f.2.1747670847362;
        Mon, 19 May 2025 09:07:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4b170asm1790708173.128.2025.05.19.09.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 09:07:26 -0700 (PDT)
Date: Mon, 19 May 2025 10:07:24 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] vfio/type1: optimize vfio_pin_pages_remote() for
 hugetlbfs folio
Message-ID: <20250519100724.7fd6cc1e.alex.williamson@redhat.com>
In-Reply-To: <20250519070419.25827-1-lizhe.67@bytedance.com>
References: <20250519070419.25827-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 May 2025 15:04:19 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes hugetlbfs folios, the function currently performs individual
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
> funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
> Changelogs:
> 
> v1->v2:
> - Fix some issues in comments and formatting.
> - Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
> - Move the processing logic for hugetlbfs folio into the while(true) loop
>   and use a variable with a default value of 1 to indicate the number of
>   consecutive pages.
> 
> v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
> 
>  drivers/vfio/vfio_iommu_type1.c | 70 +++++++++++++++++++++++++++------
>  1 file changed, 58 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac56072af9f..2218ca415366 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -317,17 +317,20 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>  }
>  
>  /*
> - * Helper Functions for host iova-pfn list
> + * Find the first vfio_pfn that overlapping the range
> + * [iova, iova + PAGE_SIZE * npage) in rb tree
>   */
> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
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
> @@ -337,6 +340,14 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>  	return NULL;
>  }
>  
> +/*
> + * Helper Functions for host iova-pfn list
> + */

This comment should still precede the renamed function above, it's in
reference to this section of code related to searching, inserting, and
removing entries from the pfn list.

> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +{
> +	return vfio_find_vpfn_range(dma, iova, 1);
> +}
> +
>  static void vfio_link_pfn(struct vfio_dma *dma,
>  			  struct vfio_pfn *new)
>  {
> @@ -681,32 +692,67 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  		 * and rsvd here, and therefore continues to use the batch.
>  		 */
>  		while (true) {
> +			int page_step = 1;
> +			long lock_acct_step = 1;
> +			struct folio *folio = page_folio(batch->pages[batch->offset]);
> +			bool found_vpfn;
> +
>  			if (pfn != *pfn_base + pinned ||
>  			    rsvd != is_invalid_reserved_pfn(pfn))
>  				goto out;
>  
> +			/* Handle hugetlbfs page */
> +			if (folio_test_hugetlb(folio)) {

Why do we care to specifically test for hugetlb vs
folio_large_nr_pages(), at which point we can just use folio_nr_pages()
directly here.

> +				unsigned long start_pfn = PHYS_PFN(vaddr);

Using this macro on a vaddr looks wrong.

> +
> +				/*
> +				 * Note: The current page_step does not achieve the optimal
> +				 * performance in scenarios where folio_nr_pages() exceeds
> +				 * batch->capacity. It is anticipated that future enhancements
> +				 * will address this limitation.
> +				 */
> +				page_step = min(batch->size,
> +					ALIGN(start_pfn + 1, folio_nr_pages(folio)) - start_pfn);

Why do we assume start_pfn is the beginning of the folio?

> +				found_vpfn = !!vfio_find_vpfn_range(dma, iova, page_step);
> +				if (rsvd || !found_vpfn) {
> +					lock_acct_step = page_step;
> +				} else {
> +					dma_addr_t tmp_iova = iova;
> +					int i;
> +
> +					lock_acct_step = 0;
> +					for (i = 0; i < page_step; ++i, tmp_iova += PAGE_SIZE)
> +						if (!vfio_find_vpfn(dma, tmp_iova))
> +							lock_acct_step++;
> +					if (lock_acct_step)
> +						found_vpfn = false;

Why are we making this so complicated versus falling back to iterating
at page per page?

> +				}
> +			} else {
> +				found_vpfn = vfio_find_vpfn(dma, iova);
> +			}
> +
>  			/*
>  			 * Reserved pages aren't counted against the user,
>  			 * externally pinned pages are already counted against
>  			 * the user.
>  			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (!rsvd && !found_vpfn) {
>  				if (!dma->lock_cap &&
> -				    mm->locked_vm + lock_acct + 1 > limit) {
> +				    mm->locked_vm + lock_acct + lock_acct_step > limit) {
>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>  						__func__, limit << PAGE_SHIFT);
>  					ret = -ENOMEM;
>  					goto unpin_out;
>  				}
> -				lock_acct++;
> +				lock_acct += lock_acct_step;
>  			}
>  
> -			pinned++;
> -			npage--;
> -			vaddr += PAGE_SIZE;
> -			iova += PAGE_SIZE;
> -			batch->offset++;
> -			batch->size--;
> +			pinned += page_step;
> +			npage -= page_step;
> +			vaddr += PAGE_SIZE * page_step;
> +			iova += PAGE_SIZE * page_step;
> +			batch->offset += page_step;
> +			batch->size -= page_step;
>  
>  			if (!batch->size)
>  				break;

Why is something like below (untested) not sufficient?

NB. (vaddr - folio_address()) still needs some scrutiny to determine if
it's valid.

@@ -681,32 +692,40 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		 * and rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
+			struct folio *folio = page_folio(batch->pages[batch->offset]);
+			long nr_pages;
+
 			if (pfn != *pfn_base + pinned ||
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
+			nr_pages = min(batch->size, folio_nr_pages(folio) -
+						    (vaddr - folio_address(folio)) >> PAGE_SHIFT);
+			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
+				nr_pages = 1;
+
 			/*
 			 * Reserved pages aren't counted against the user,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (!rsvd && (nr_pages > 1 || !vfio_find_vpfn(dma, iova))) {
 				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
+				    mm->locked_vm + lock_acct + nr_pages > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
+				lock_acct += nr_pages;
 			}
 
-			pinned++;
-			npage--;
-			vaddr += PAGE_SIZE;
-			iova += PAGE_SIZE;
-			batch->offset++;
-			batch->size--;
+			pinned += nr_pages;
+			npage -= nr_pages;
+			vaddr += PAGE_SIZE * nr_pages;
+			iova += PAGE_SIZE * nr_pages;
+			batch->offset += nr_pages;
+			batch->size -= nr_pages;
 
 			if (!batch->size)
 				break;


