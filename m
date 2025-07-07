Return-Path: <kvm+bounces-51660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F13AFAD14
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 09:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4206D16A725
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 07:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154CC28688A;
	Mon,  7 Jul 2025 07:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E3hcciIW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E3D278E63
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 07:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751873379; cv=none; b=lDMPjv+Cg6rr0ZcedEeONddkCSHVnxxtNMzt3VQZ/nEuNK9mgPYeUSUZmKalXdo7P13gitKTJBrjGTHCQ+5X2U8mlW7H+LINj1LGaEOdZkkepMdR30wdM6KQpkDeYdswIMv0ve0xRFmhR6qwmJ3pQ9DQN7hc8QZPcPR0OqKOQCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751873379; c=relaxed/simple;
	bh=oqnnEgK6RFVD7FtUKlR3QdTM5hsomoyMk03OZYmhHnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4otTQClXjn0fQ97LVTVN5lbAlkOZ10J6VghVumosLdPElGyCnI/aafLNru4gTcEOaf9qay9D+BAp6urdByDYGgmt4YQdBsELzK0wqdhGRA17zEblWQfxY6Pq9rOoJjYWj9cAOdPaxAzPWxjQjpNqklY8qHpVHrIx3G/o1Lj3Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E3hcciIW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751873375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UniRdOeAILwBv1NP0bui+CugXDW/jLDR72O3UtptutA=;
	b=E3hcciIWJ6g2IjtkDwIYBZS62SXxq329VTeTeB4bEUpNsjrhQDD2B9LtRthsrrcIBQQk61
	u6dfoOk4Jnk/XQOhsINQl4UbiG7TnivtcIDjStbvw0Xf6jDHWFBhd16blC0SRgDq86WNxr
	CY3gXLOXZd3q6xX4MaFWt74clNtRkgs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-CoZPZEOPPdKVxUS0w5gMZw-1; Mon, 07 Jul 2025 03:29:34 -0400
X-MC-Unique: CoZPZEOPPdKVxUS0w5gMZw-1
X-Mimecast-MFC-AGG-ID: CoZPZEOPPdKVxUS0w5gMZw_1751873373
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450de98b28eso17395675e9.0
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 00:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751873373; x=1752478173;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UniRdOeAILwBv1NP0bui+CugXDW/jLDR72O3UtptutA=;
        b=cZ4/wp6Y23KhD27YWrUjlgelaHi4LdDMtiP/FoNmSwoUVFKaV+bn+1XBziWNiDFXtM
         LLJaYUYxkN7r1Qc2953hdSxWrunftC4jtlEiqwKpvz6JQ3oNRJBqMakeUw42SZv7ABWf
         qgR5df8S2MWdJ8gzYfBh253Vd6URzospt+T5IK33QIG7EZ01p14H/R7+Bh4Bcz/XONM7
         3znYDwRat0AFDEaddOKyC0xzfj7ikUchB7GIVAd7+Z6KLxiuRdEiltlZvJSdeBD56/3h
         OGHOPAN6m9vHJZiXO7TBmo71k5/HeKc5ufU/yWolkO2V2Exg99SDSyKZzH4jCjyH2k9b
         V8YA==
X-Gm-Message-State: AOJu0Yx7CF3i0YGa1rU8BCz8bgPJr0P7CCN+kwzTB/vPQZAitnDdd/6S
	eLq1dPZ/oAFPBMWtxWbBmibBxb1ldTpM0ApoUTE66proagfDyw+gFQrA/4Zs3pX3r7bs/WUfdSy
	dE8kjvKRcffUqaa3LcBvVo6dfsbHgY40nJeAc8fX82jz48Yc2IaUYJQ==
X-Gm-Gg: ASbGncuEzI0jTd8pfW936p/vNsXOveH5f/BNZqrwfBngV6yrszjEwiTsuP1M6GjNkh+
	SAo3ce6Gsc+fEkvGACC6i/oJ8GHOgV74wank8zEVVsawP/ZVAQmRt15Fd0o5b2jV9Byyz/GdUTX
	Z7SeyksqEQEW5f528DOtluXDi68ULb58Z12O6Cpgxe08DwHeqWfjPikqy0OTKSM/gddgI+1gEAL
	zptDOZwY6pyiawWwUncKTxbERQm6JsTZ7wJPI1JrYlpsvrz/mrolAFdb+AMer/HaVhKqvMIow1V
	aUsF8RC4vPqXJSyK1N3asgFVdDcFbPyMrRdLCMLHux5NIH1GZyN3cqRLzd+4wjctfpz6TPOv6nV
	fQ8+/Yx4sjr6Bk6ofuPu9nIlY4w2xbyVtt4o5jNGLzByCgcstSw==
X-Received: by 2002:a05:6000:1885:b0:3a5:271e:c684 with SMTP id ffacd0b85a97d-3b49558ac68mr10619511f8f.24.1751873372649;
        Mon, 07 Jul 2025 00:29:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwPSb5edQLRTwGOfVpOm0bfilvCQbmAoa4KXrkeUF5ArI8SkxYDqX8rGSHXn0rf+nVk0uRfg==
X-Received: by 2002:a05:6000:1885:b0:3a5:271e:c684 with SMTP id ffacd0b85a97d-3b49558ac68mr10619487f8f.24.1751873372170;
        Mon, 07 Jul 2025 00:29:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f38:1d00:657c:2aac:ecf5:5df8? (p200300d82f381d00657c2aacecf55df8.dip0.t-ipconnect.de. [2003:d8:2f38:1d00:657c:2aac:ecf5:5df8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b161fb78sm103469475e9.1.2025.07.07.00.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jul 2025 00:29:31 -0700 (PDT)
Message-ID: <9d74e93d-5a5f-4ffa-91fa-eb2061080f94@redhat.com>
Date: Mon, 7 Jul 2025 09:29:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] vfio/type1: optimize vfio_pin_pages_remote()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
 akpm@linux-foundation.org, jgg@ziepe.ca, peterx@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250707064950.72048-1-lizhe.67@bytedance.com>
 <20250707064950.72048-3-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250707064950.72048-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.07.25 08:49, lizhe.67@bytedance.com wrote:
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
> ---
>   drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
>   1 file changed, 71 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1136d7ac6b59..03fce54e1372 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -318,7 +318,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>   /*
>    * Helper Functions for host iova-pfn list
>    */
> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +
> +/*
> + * Find the highest vfio_pfn that overlapping the range
> + * [iova_start, iova_end) in rb tree.
> + */
> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> +		dma_addr_t iova_start, dma_addr_t iova_end)
>   {
>   	struct vfio_pfn *vpfn;
>   	struct rb_node *node = dma->pfn_list.rb_node;
> @@ -326,9 +332,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>   	while (node) {
>   		vpfn = rb_entry(node, struct vfio_pfn, node);
>   
> -		if (iova < vpfn->iova)
> +		if (iova_end <= vpfn->iova)
>   			node = node->rb_left;
> -		else if (iova > vpfn->iova)
> +		else if (iova_start > vpfn->iova)
>   			node = node->rb_right;
>   		else
>   			return vpfn;
> @@ -336,6 +342,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>   	return NULL;
>   }
>   
> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> +{
> +	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> +}
> +
>   static void vfio_link_pfn(struct vfio_dma *dma,
>   			  struct vfio_pfn *new)
>   {
> @@ -614,6 +625,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>   	return ret;
>   }
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
>   /*
>    * Attempt to pin pages.  We really don't want to track all the pfns and
>    * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>   		 * and rsvd here, and therefore continues to use the batch.
>   		 */
>   		while (true) {
> +			long nr_pages, acct_pages = 0;
> +
>   			if (pfn != *pfn_base + pinned ||
>   			    rsvd != is_invalid_reserved_pfn(pfn))
>   				goto out;
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
>   			/*
>   			 * Reserved pages aren't counted against the user,
>   			 * externally pinned pages are already counted against
>   			 * the user.
>   			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (acct_pages) {
>   				if (!dma->lock_cap &&
> -				    mm->locked_vm + lock_acct + 1 > limit) {
> +						mm->locked_vm + lock_acct + acct_pages > limit) {

Weird indentation change.

It should be

if (!dma->lock_cap &&
     mm->locked_vm + lock_acct + acct_pages > limit) {

     ^ aligned here


Please don't drop acks/rbs already given in previous submissions.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


