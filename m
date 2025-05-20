Return-Path: <kvm+bounces-47165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11154ABE1E4
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B5834C35FF
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41ABE27FD7A;
	Tue, 20 May 2025 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AC54gA3M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D19A2580F7
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 17:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747762732; cv=none; b=AuPf3bvTh4EvKxfhprEpbAfiCgnuSVbk7Mad9FED1+HoXbNJ9p9L/td0YQdSjZm86OvyCdTIOJrlJ/LWrjBLohsmjVJqQqtPfTQO/ZR/LWmuMYYdI2wqEqrX2gl1xCrWDdPmBW7TpieeQHT6Sp2LSjoFK4rz4ura58QNTH2LVgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747762732; c=relaxed/simple;
	bh=adM127C8OavH5jlXjW7zh27SJLJ/bjCHpUPHtojOMUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwOqpD6Zzy/d8LZYoCcLzoYHFZnidhgx4OUqX0JCsWRzW8I9LDUrXDAN5z3+ZU7875uaZ8BWPJbJxmjK1RCuIXgQkl5p8qIJHP+bibUgiwCCVPxF41DWLoEhbAhEpsgx0i+qoEiVn9dJiPawWUOboWz8q4S+Jx1q7pxuIJvZeYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AC54gA3M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747762729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U7onMW/FpYfL9q9r/msFUOtFnxJS/Q6jFLBWTk+GRKI=;
	b=AC54gA3MMtvKl/+TwWF6jNs7Ra39xgPgvhnFvk5k47dwNZUxdBDpq8YI0Za7yWL1e5zLJx
	wg68Swr0IKk243ZHwdxUlLJsSqYaGJWEes5BzXaLEuBZqqbCfpVtzMy2nXFXM0+fopF9ty
	YLPw1DTXcdwVFV9g7oggCWjMnmJoAGs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-V5xQteKzOYONRanRrmyLdw-1; Tue, 20 May 2025 13:38:48 -0400
X-MC-Unique: V5xQteKzOYONRanRrmyLdw-1
X-Mimecast-MFC-AGG-ID: V5xQteKzOYONRanRrmyLdw_1747762727
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a35bf8377fso3939824f8f.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747762727; x=1748367527;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U7onMW/FpYfL9q9r/msFUOtFnxJS/Q6jFLBWTk+GRKI=;
        b=MitcgG6WN3EgGap3C+gb7znZypk4Q7VACyRPXLabsTy3fqo+lF+lthbeZY+HEw4RyK
         /Qzt9lCYodff2pkv70BUuNRc9Ozk5Lec0P2aHv9DXmTLCN2KUkNJ7rb7NaA0V6mPiTgC
         R6/INgn4yNE/vZ9E7HVJpFPE36k5qsiuSfUs9k+wmJ98ygbPp7JXv+M0LeXYKjFWK/S2
         OGD8rDuYlZaIR5sb7pHw2dgpfdeh5PlyLm2the54tQH77Cg8bRGxO/G2mVy1A+DqjTkp
         dRVzTF+8fssLfw37UwFHikOt48mP3Uj3zkA6celP0tvM2TwSlyIvNdgGU2+A5n0NzjW4
         5HGQ==
X-Gm-Message-State: AOJu0YwzfkVfV1r968uYb2qrmEOI4bcCTTrBREHd2rtKpbnQA8l5zO8h
	YQk+pZnad0+2zq2J5pRH1bocLmdd9UyL2VddX1kIa+Sf0R0Qopn5q/t8zJ80maVhrpVWdHWyv8o
	mql9anWaY6rDFc+WyO9ipwXzRyj1ARiEbTtOZkLUdJ0adAWKFbzTZpw==
X-Gm-Gg: ASbGncuN7kkZRtq/9v5ZEbm2YBXUyoAEVHr7nN6fpb604YScif8Rrdeo/HvwOOvmEoM
	2G/7XuPqvlvrRN+BbeqfrmGJo3Bmt+rXGUzQJnffn/Fmdgnh1BzZ2NT0AuxNWYAZaUunmSZUdvc
	VbTRJPbHRAtMNxSsNlWn+OEjdjaXt01qaLC90mx/lPdaqrEbLn7smlxBkqRgjUhy4Rv8Z/qnOZ4
	or+VVQbdbf5701qeMd0dPpi40HHWAxUr4NfaMmW6EpIddXTm6uF+Luo20juMM6mR/nU5vPYaq6w
	XGmXhHnOGKWOiy65PNjagit4FU5u36OSvrJqXbcZyZRsuIHL5ZaX4jZpm1bziqnoaqlChZmGhCZ
	BqvcEA1z6O0nMGY/ZUX9ub9yowkJDXmuxBX8Kprk=
X-Received: by 2002:a05:6000:400f:b0:3a0:b4f1:8bd5 with SMTP id ffacd0b85a97d-3a35fe67aa7mr13790414f8f.18.1747762726675;
        Tue, 20 May 2025 10:38:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHilD1QVPZgF2Tu9J05/HFut+8uHCPuoVe/pP7lVX5n8AO1SO1by4RXC8L32oHdmQcAkoJAJQ==
X-Received: by 2002:a05:6000:400f:b0:3a0:b4f1:8bd5 with SMTP id ffacd0b85a97d-3a35fe67aa7mr13790387f8f.18.1747762726283;
        Tue, 20 May 2025 10:38:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:7c00:a95e:ac49:f2ad:ab84? (p200300d82f287c00a95eac49f2adab84.dip0.t-ipconnect.de. [2003:d8:2f28:7c00:a95e:ac49:f2ad:ab84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f23bfdd9sm37859685e9.18.2025.05.20.10.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 10:38:45 -0700 (PDT)
Message-ID: <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
Date: Tue, 20 May 2025 19:38:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
To: lizhe.67@bytedance.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520070020.6181-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 09:00, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>

Subject: "huge folio" -> "large folios"

> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes huge folios, the function currently performs individual

Similar, we call it a "large" f

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
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
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
>    and use a variable with a default value of 1 to indicate the number
>    of consecutive pages.
> 
> v2 patch: https://lore.kernel.org/all/20250519070419.25827-1-lizhe.67@bytedance.com/
> v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
> 
>   drivers/vfio/vfio_iommu_type1.c | 48 +++++++++++++++++++++++++--------
>   1 file changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac56072af9f..48f06ce0e290 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -319,15 +319,22 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>   /*
>    * Helper Functions for host iova-pfn list
>    */
> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +
> +/*
> + * Find the first vfio_pfn that overlapping the range
> + * [iova, iova + PAGE_SIZE * npage) in rb tree.
> + */
> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> +		dma_addr_t iova, unsigned long npage)
>   {
>   	struct vfio_pfn *vpfn;
>   	struct rb_node *node = dma->pfn_list.rb_node;
> +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
>   
>   	while (node) {
>   		vpfn = rb_entry(node, struct vfio_pfn, node);
>   
> -		if (iova < vpfn->iova)
> +		if (end_iova <= vpfn->iova)
>   			node = node->rb_left;
>   		else if (iova > vpfn->iova)
>   			node = node->rb_right;
> @@ -337,6 +344,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>   	return NULL;
>   }
>   
> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +{
> +	return vfio_find_vpfn_range(dma, iova, 1);
> +}
> +
>   static void vfio_link_pfn(struct vfio_dma *dma,
>   			  struct vfio_pfn *new)
>   {
> @@ -681,32 +693,46 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>   		 * and rsvd here, and therefore continues to use the batch.
>   		 */
>   		while (true) {
> +			struct folio *folio = page_folio(batch->pages[batch->offset]);
> +			long nr_pages;
> +
>   			if (pfn != *pfn_base + pinned ||
>   			    rsvd != is_invalid_reserved_pfn(pfn))
>   				goto out;
>   
> +			/*
> +			 * Note: The current nr_pages does not achieve the optimal
> +			 * performance in scenarios where folio_nr_pages() exceeds
> +			 * batch->capacity. It is anticipated that future enhancements
> +			 * will address this limitation.
> +			 */
> +			nr_pages = min((long)batch->size, folio_nr_pages(folio) -
> +						folio_page_idx(folio, batch->pages[batch->offset]));
> +			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
> +				nr_pages = 1;


You seem to assume that the batch really contains the consecutive pages 
of that folio.

This is not the case if we obtained the pages through GUP and we have

(a) A MAP_PRIVATE mapping

(b) We span multiple different VMAs


Are we sure we can rule out (a) and (b)?

A more future-proof approach would be at least looking whether the 
pages/pfns are actually consecutive.

-- 
Cheers,

David / dhildenb


