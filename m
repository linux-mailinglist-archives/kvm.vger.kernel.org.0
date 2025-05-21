Return-Path: <kvm+bounces-47295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A94ABFAE7
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 18:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D94591C04415
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AC82222BD;
	Wed, 21 May 2025 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYLnUG50"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBD21A420
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747843346; cv=none; b=HOMDcmD5YyU2bFGoM0lpOMwKX7xskf+PrOluLKpJFrlKxJtrwthLHoqaSW6dQ3YHaM3Ir4Xlce54LHZnS37vDdQjsdo5BH6lWAIt0Lvfx4t5TH0eUXBldjqm/yXMOg8mIb5bUCMbU4p/IITUwVg/BEfE/tAKnHlECxVJh7dpSSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747843346; c=relaxed/simple;
	bh=UREKu6qch+HwsQMt1vlqYyRJDWH9laE5S9pm9bS66hE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ewUIkqjJEgdOrNoSoYnyB5eUcpRa793RNrhNRQcGrLoD91eu6JqyqgPelxckbx8JwBIuyXb1eZyqDSiY/SLGc3YPgq71oRaarHfVajLobpCWSzjbZRfetxXW6pvhIx6l5IEYZGrEzxVwb97DCuUUHymvJOEKdZ3xOV2b4LkUJaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYLnUG50; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747843338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9fZhY6wHMdAbKA49Jq994SZ/xqO7IR+BBcalbyYYXIM=;
	b=OYLnUG507WjMIVhuptSi/eg9KkKEalIeTZ0RW6v4fUc7aY3W0hws5Dm7V830FFqu0bWyBr
	3SH7eZ/TSNaBvj0p1d2laocWhE8GRbx3xZf08iWZ1PH/7vsAW74bIrWTsUvkdKfvNC576i
	M4LtYXq6fql52j7JvUW/3M3KhOQiouQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-CRPN8ByaOGCIrFQHYdgQAw-1; Wed, 21 May 2025 12:02:16 -0400
X-MC-Unique: CRPN8ByaOGCIrFQHYdgQAw-1
X-Mimecast-MFC-AGG-ID: CRPN8ByaOGCIrFQHYdgQAw_1747843335
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a364d2d0efso2520142f8f.3
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 09:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747843334; x=1748448134;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9fZhY6wHMdAbKA49Jq994SZ/xqO7IR+BBcalbyYYXIM=;
        b=VX2o8hgP53OrMFmPLSbtbP1doRUtw2Aa2WDWaelGeXGfAnb6eWAl1dZaICChpJ+1Bf
         uomMzz863mYuZ1Mv4dqGQiPVfoWdbjs3U5S8yWyf50njWaRqkiapGeQWKfA1+BdFSDrQ
         wP1PmhqB7QUo+CixA5jrCte2tDNAjeexHqORSvACYRwNDC6bwr7qDpajWVh/X5BZ8WYk
         TBthtrbeSefzUEs3hNa3FO3HlOuH4VoBnc/pKQyXD7OhKAwWur890C9T1mhm77jB8UJV
         tB7Yx09CpzVtVcNAQoyBMRj/j+LaLpU9fkeGoXBBxWRi7xuwFWVGqpAmItGF4mqSo1XK
         AS6g==
X-Forwarded-Encrypted: i=1; AJvYcCWJ1IHOW8qPDRNyLA/NG2h+UOcaUY0kN0N////+x8L2hWk9OJCD5F/08ibpfct5GP7zE40=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrlZrx1yyJ9/LhWvPtzK9sygKBXBBeGESe9mVXMlZfCyamOH4A
	cmtLfYdKkkdg/SNxdeG2wF/EB4m5U9U7+5t2wl9z12aa7+xAIPgndmabWMTmamnMVBTvS7yTx8m
	3LbvYnVCKC18eQ/MNvbk7CJtORjcTqBUTBMfw4xEfm6+FTGYmROnHE2fr/WTkGKhL
X-Gm-Gg: ASbGncvXLMzM59uQinHue1gfoMBtvkQ/T036L8KJIRA4eTNVVmI9hcpR5jurwQ1IcBm
	2qbgsTUWesVYYCPsSxmbPMapci8Op0XtPb6DVodk4ia3EcUnDchkfoF6leTk+vPNGeAwpV0gf9F
	YH+F915GR9sP5Lqhu/3ag3pfV5c/RYdSldFuzzQJOoZn26CVUauGr2E2GJ8SP86CoDTJfYV56Tn
	3qw+ofl0ZJPuAgQplh6HMvHDwlIesEacWYgku6NFAgEi+lLyZIDhG5OskagnIvSPeokr4YrmBhI
	tvQPOpYXvHIjkcEqOq2Ep33sKFU/6S6iyBRGMxDnCwpTZ2OsbBfGh06oGY/4unQcc3xCXKI4K/J
	viqgYZKP5Z9zX+RPX7SSrdejo4X60+fNDWCIu6CM=
X-Received: by 2002:a05:6000:180e:b0:3a3:62e1:a7db with SMTP id ffacd0b85a97d-3a362e1a997mr13218483f8f.3.1747843334506;
        Wed, 21 May 2025 09:02:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVQZhAv284WgoDT4LXe2CAM32OUzc9mP8qdr2b0rFwua5ybh0oAxFZX3kGmiZjGs9lXci0Ng==
X-Received: by 2002:a05:6000:180e:b0:3a3:62e1:a7db with SMTP id ffacd0b85a97d-3a362e1a997mr13218436f8f.3.1747843333942;
        Wed, 21 May 2025 09:02:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca208besm20078586f8f.0.2025.05.21.09.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 09:02:13 -0700 (PDT)
Message-ID: <f2c0f4d0-42d5-4255-a1e4-d782cfb6e50c@redhat.com>
Date: Wed, 21 May 2025 18:02:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
To: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, lizhe.67@bytedance.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
 <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
 <20250520162125.772d003f.alex.williamson@redhat.com>
 <ff914260-6482-41a5-81f4-9f3069e335da@redhat.com> <aC3z_gUxJbY1_JP7@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aC3z_gUxJbY1_JP7@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.05.25 17:40, Peter Xu wrote:
> On Wed, May 21, 2025 at 08:35:47AM +0200, David Hildenbrand wrote:
>> On 21.05.25 00:21, Alex Williamson wrote:
>>> On Tue, 20 May 2025 19:38:45 +0200
>>> David Hildenbrand <david@redhat.com> wrote:
>>>
>>>> On 20.05.25 09:00, lizhe.67@bytedance.com wrote:
>>>>> From: Li Zhe <lizhe.67@bytedance.com>
>>>>
>>>> Subject: "huge folio" -> "large folios"
>>>>
>>>>>
>>>>> When vfio_pin_pages_remote() is called with a range of addresses that
>>>>> includes huge folios, the function currently performs individual
>>>>
>>>> Similar, we call it a "large" f
>>>>
>>>>> statistics counting operations for each page. This can lead to significant
>>>>> performance overheads, especially when dealing with large ranges of pages.
>>>>>
>>>>> This patch optimize this process by batching the statistics counting
>>>>> operations.
>>>>>
>>>>> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
>>>>> obtained through trace-cmd, are as follows. In this case, the 8G virtual
>>>>> address space has been mapped to physical memory using hugetlbfs with
>>>>> pagesize=2M.
>>>>>
>>>>> Before this patch:
>>>>> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
>>>>>
>>>>> After this patch:
>>>>> funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
>>>>>
>>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>> ---
>>>>> Changelogs:
>>>>>
>>>>> v2->v3:
>>>>> - Code simplification.
>>>>> - Fix some issues in comments.
>>>>>
>>>>> v1->v2:
>>>>> - Fix some issues in comments and formatting.
>>>>> - Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
>>>>> - Move the processing logic for huge folio into the while(true) loop
>>>>>      and use a variable with a default value of 1 to indicate the number
>>>>>      of consecutive pages.
>>>>>
>>>>> v2 patch: https://lore.kernel.org/all/20250519070419.25827-1-lizhe.67@bytedance.com/
>>>>> v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
>>>>>
>>>>>     drivers/vfio/vfio_iommu_type1.c | 48 +++++++++++++++++++++++++--------
>>>>>     1 file changed, 37 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>> index 0ac56072af9f..48f06ce0e290 100644
>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>> @@ -319,15 +319,22 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>>>>>     /*
>>>>>      * Helper Functions for host iova-pfn list
>>>>>      */
>>>>> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>>>>> +
>>>>> +/*
>>>>> + * Find the first vfio_pfn that overlapping the range
>>>>> + * [iova, iova + PAGE_SIZE * npage) in rb tree.
>>>>> + */
>>>>> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
>>>>> +		dma_addr_t iova, unsigned long npage)
>>>>>     {
>>>>>     	struct vfio_pfn *vpfn;
>>>>>     	struct rb_node *node = dma->pfn_list.rb_node;
>>>>> +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
>>>>>     	while (node) {
>>>>>     		vpfn = rb_entry(node, struct vfio_pfn, node);
>>>>> -		if (iova < vpfn->iova)
>>>>> +		if (end_iova <= vpfn->iova)
>>>>>     			node = node->rb_left;
>>>>>     		else if (iova > vpfn->iova)
>>>>>     			node = node->rb_right;
>>>>> @@ -337,6 +344,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>>>>>     	return NULL;
>>>>>     }
>>>>> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>>>>> +{
>>>>> +	return vfio_find_vpfn_range(dma, iova, 1);
>>>>> +}
>>>>> +
>>>>>     static void vfio_link_pfn(struct vfio_dma *dma,
>>>>>     			  struct vfio_pfn *new)
>>>>>     {
>>>>> @@ -681,32 +693,46 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>>>>>     		 * and rsvd here, and therefore continues to use the batch.
>>>>>     		 */
>>>>>     		while (true) {
>>>>> +			struct folio *folio = page_folio(batch->pages[batch->offset]);
>>>>> +			long nr_pages;
>>>>> +
>>>>>     			if (pfn != *pfn_base + pinned ||
>>>>>     			    rsvd != is_invalid_reserved_pfn(pfn))
>>>>>     				goto out;
>>>>> +			/*
>>>>> +			 * Note: The current nr_pages does not achieve the optimal
>>>>> +			 * performance in scenarios where folio_nr_pages() exceeds
>>>>> +			 * batch->capacity. It is anticipated that future enhancements
>>>>> +			 * will address this limitation.
>>>>> +			 */
>>>>> +			nr_pages = min((long)batch->size, folio_nr_pages(folio) -
>>>>> +						folio_page_idx(folio, batch->pages[batch->offset]));
>>>>> +			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
>>>>> +				nr_pages = 1;
>>>>
>>>>
>>>> You seem to assume that the batch really contains the consecutive pages
>>>> of that folio.
>>>
>>> I don't think we are.  We're iterating through our batch of pages from
>>> GUP to find consecutive pfns.  We use the page to get the pfn, the
>>> folio, and immediately above, the offset into the folio.  batch->size is
>>> the remaining length of the page array from GUP and batch->offset is our
>>> current index into that array.
>>
>> Let me try again using an example below ....
>>
>>>> This is not the case if we obtained the pages through GUP and we have
>>>>
>>>> (a) A MAP_PRIVATE mapping
>>>>
>>>> (b) We span multiple different VMAs
>>>>
>>>>
>>>> Are we sure we can rule out (a) and (b)?
>>>>
>>>> A more future-proof approach would be at least looking whether the
>>>> pages/pfns are actually consecutive.
>>>
>>> The unmodified (pfn != *pfn_base + pinned) test is where we verify we
>>> have the next consecutive pfn.  Maybe I'm not catching the dependency
>>> you're seeing on consecutive pages, I think there isn't one unless
>>> we're somehow misusing folio_page_idx() to get the offset into the
>>> folio.
>>
>> Assume our page tables look like this (case (a), a partially mapped large
>> pagecache folio mixed with COW'ed anonymous folios):
>>
>>    + page[0] of folio 0
>>    |              + COWed anonymous folio (folio 1)
>>    |              |    + page[4] of folio 0
>>    |              |    |
>>    v              v    v
>> F0P0 F0P1 F0P2 F1P0 F0P4 P0P5 F0P6 F0P7
>>
>> If we GUP that range, we get exactly these pages, except that the PFNs are
>> not consecutive, because F0P3 was replaced by another page. The large folio
>> is partially mapped.
>>
>>
>> Maybe I misunderstand that code, but wouldn't we just "jump" over F1P0
>> because we assume the batch would contain F1P0, where it really contains
>> F0P4?
> 
> Looks like a real issue (even if unlikely setup)..

There are other ways to achieve that (e.g., simply mapping parts of 
multiple files etc.).

Of course, for hugetlb (as you note below) such folios partial mappings 
are impossible.

-- 
Cheers,

David / dhildenb


