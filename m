Return-Path: <kvm+bounces-47133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5465ABDBB1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C68C8C77C1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0F5246775;
	Tue, 20 May 2025 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R+3QNYYU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C581022D7A8
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750049; cv=none; b=cHTKZA1JitV3WovdsAIJagG3UUj0HShOn+9esXPfQ6fif9SsYrRFQU2H2Hs4lUBwNYrQom0BhPqXSiv/7Y5M8l5e/2IlFGCiGE+TCnNDBO469fBhZ6OqPMJ3Mao1vV5D3asSH/pLnuL0BBlpcvkBAugU6zbVKImqhXVO0W+ew9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750049; c=relaxed/simple;
	bh=3VbsCn/8BDdGAoKRiw85VsmQkWPZarb8OY05EU0n5Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ck1fkBo+qyUGsEYbVjY77E6lGQd47IDUe+egD0z2i19GCJ6NfwKpik2mq7SbspDC/ihs4oAh5In9DQV1J+gnJT3cLmcEUAJaWBHHOL6fOKbN1cohDpZdhuqc0McsZWumKgLdMHzmKUO6kfZ0O/VS4hfVUYQLb66J4v3sIRoqdc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R+3QNYYU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747750046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a8m2BRyEw6zS+4OVzo3rpgvhXlNDh0vPuD8aVrI5HC4=;
	b=R+3QNYYUpZcWHJZJuiYMD0I7wdSUG2bRc0jW5Yg498nMGtakaHHokHa8MvxXh84pMfNt8e
	D3nppBV4/hThGQoaqtoN5oOwBzZjzULWOiUhFFlXz5Y8eNYTGqfl8ZLcs5S+4juM7HWTRr
	KAoa5yuG9sx3MYQe4ZInzPVqDMDr1Vk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-Ev7qiHrsOkK6pcpafdZJNQ-1; Tue, 20 May 2025 10:07:25 -0400
X-MC-Unique: Ev7qiHrsOkK6pcpafdZJNQ-1
X-Mimecast-MFC-AGG-ID: Ev7qiHrsOkK6pcpafdZJNQ_1747750044
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3da79c57332so4988825ab.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 07:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747750044; x=1748354844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8m2BRyEw6zS+4OVzo3rpgvhXlNDh0vPuD8aVrI5HC4=;
        b=ICkdwmlNdks3YnuYJXzvSgfuFEV0QpGSOX5tpA6jtDYsxkMBApyzkA5jeOPyPbqqNp
         QYql0EUwpmYkf9OA/aAnh0YdqEsIYqSTJ/Gn0ESSYXwTdjqV0ITxb6JzwCjenX0XKCfP
         mcHT5VrjMdGdS+zhxs/f67ro2MC3OP5Cc954J24a/WOpFtdv2seqIhqK0ajWGt9Igmxl
         8eHkBeD2rPh5xM/wSZDM602/w0RF5/BHJzYqihXnOQlpkK648GxyuyJa0T85HYvt9KyJ
         9tmOqPbQiru2X6VckLfE4dyXIbGsQd9Um3B2g7GKeWdRFjCAPLaYV+I3uR6iXnKSuthN
         cg/w==
X-Gm-Message-State: AOJu0Yy+YMhH6jSO+SnUi+K9RA614l5SP5kqwIarD2j0tgPKdodLPIPt
	gP+a8ahRpONNpijq+dczMB8TxQ41k+67zp05nCTqoajKBN2rpdblhyEhsyDUNCb5TOcQSiPjqM9
	yEnFx6iTZvURDB9hd2D6UNyWDOB2t56Yja4lFdp2amEfa/uqbsaylrVUtG2LCZw==
X-Gm-Gg: ASbGnctYCzGRSIA4DFsys640L9jlZOECZWos0pr7tGCQaxdHR+xzq+4dPmFE20eLrCb
	mpfZ+eFu9E1259am4W1/ch1Y7K4AyohDOpsBBFPivVoklVXeuIrINb7/G9fE2A8X5iumlA2Ff46
	IsWX1iGCySHF0oC/tPqnNtF9y7Mb9TDqUwKq7saAtWi+AJg8Gd/qLhvRw+nPi6EhUkmQR0x8+iT
	mY4KkB4RIERs37z3FCdDIVTymcei1qhk16XkjbUpzN3pJ/MQg5lcho4bJ+TJu9PGrMvtcNFRWd9
	jJHkeiA6ZvFfDR0=
X-Received: by 2002:a05:6e02:220d:b0:3d9:6632:d558 with SMTP id e9e14a558f8ab-3db841c9d47mr56884815ab.0.1747750043546;
        Tue, 20 May 2025 07:07:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2PheKAWR/qCxqwxl2c6DXf4ZDTX/8QqZVzjT+uS1z0BmW9qLjCavouKiqO/6yEvKnuOnhMw==
X-Received: by 2002:a05:6e02:220d:b0:3d9:6632:d558 with SMTP id e9e14a558f8ab-3db841c9d47mr56884655ab.0.1747750042989;
        Tue, 20 May 2025 07:07:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4e9147sm2214645173.133.2025.05.20.07.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 07:07:21 -0700 (PDT)
Date: Tue, 20 May 2025 08:07:19 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, Peter Xu <peterx@redhat.com>, David Hildenbrand
 <david@redhat.com>
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for
 huge folio
Message-ID: <20250520080719.2862017e.alex.williamson@redhat.com>
In-Reply-To: <20250520070020.6181-1-lizhe.67@bytedance.com>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 May 2025 15:00:20 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes huge folios, the function currently performs individual
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

It looks like we're using the same numbers since the initial
implementation, have these results changed?

> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Appreciate the credit, this should probably be Co-developed-by: though.
In general a sign-off is something that needs to be explicitly given.

> ---
> Changelogs:
> 
> v2->v3:
> - Code simplification.
> - Fix some issues in comments.
> 
> v1->v2:
> - Fix some issues in comments and formatting.
> - Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
> - Move the processing logic for huge folio into the while(true) loop
>   and use a variable with a default value of 1 to indicate the number
>   of consecutive pages.
> 
> v2 patch: https://lore.kernel.org/all/20250519070419.25827-1-lizhe.67@bytedance.com/
> v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
> 
>  drivers/vfio/vfio_iommu_type1.c | 48 +++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac56072af9f..48f06ce0e290 100644
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
> +			nr_pages = min((long)batch->size, folio_nr_pages(folio) -
> +						folio_page_idx(folio, batch->pages[batch->offset]));

We should use min_t() here, otherwise it looks good to me.

Peter, David, if you wouldn't mind double checking the folio usage
here, I'd appreciate it.  The underlying assumption used here is that
folios always have physically contiguous pages, so we can increment at
the remainder of the folio_nr_pages() rather than iterate each page.
Thanks,

Alex

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


