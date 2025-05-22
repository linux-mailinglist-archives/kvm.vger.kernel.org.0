Return-Path: <kvm+bounces-47346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EBFAC0590
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96B577AA6B4
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 07:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADEE222561;
	Thu, 22 May 2025 07:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VLgMrpju"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68B320F
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 07:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747898579; cv=none; b=U50lIKCxLpPZ0mlHVrWhagVCV86Fv6wWC2izK+cb3FdiDInuHzdoz0aR+BGR4Azp7xt9vRWQPlGpULcX3Stw5agIyffnqKXhj0CMcF3xUYgFlC1AovLecvrMEQCbE38eI9bKO6GVWFJcQtVUHs7Ua9vhCmkcvrdthayQa3lwhRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747898579; c=relaxed/simple;
	bh=mEpY3U9+KI8mwW2+YUrBfvjd3uYgW5Is2q3Rts4wZTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GV7N4m+doyvZe7wKw31zr3ZsoM69j0J1TZe4QMKdOUFsZHroveRIBIf+eRziAeU/2WFFvaTc4cV7I7cFAAt/DE6Zf91F9YCBR4wCrS9DsbJkSO3pmHZGIrLv5XoDI+aPwaqNqh7V1tfq7NxV1djB18lZExJ1CopkdzwgEbQ7VRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VLgMrpju; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747898576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8T6rEFv8aGk2Q7ci/r9ch5/2otyWxKEcaT8dQ33zf/U=;
	b=VLgMrpjumFYNYnolCNl8qldY9To7fGv40uJdNuafWAuHsaKrH2mikervqz5mSXDgEzg5aQ
	0T2fbwczTE1N7IaK4kmhF8Y+XYfelqnwoYJgrlk+XeYrKI2cmGstICG0+DAvLCmMKgWf/d
	7gfdmhkid4H46MuTl9NyXkwwfSJ16EY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-YaV92b28PRuxqRUdqQhpoQ-1; Thu, 22 May 2025 03:22:53 -0400
X-MC-Unique: YaV92b28PRuxqRUdqQhpoQ-1
X-Mimecast-MFC-AGG-ID: YaV92b28PRuxqRUdqQhpoQ_1747898572
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a36bbfbd96so2203367f8f.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747898572; x=1748503372;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8T6rEFv8aGk2Q7ci/r9ch5/2otyWxKEcaT8dQ33zf/U=;
        b=FzB/fZBQmN6cMpmKXdpJ/j8FndulZhJMMLQwOMW82CN8yZ0N1RtAJSRbBUM+060NQb
         bFcaBnwkVM+A+RGR7Y79zdCQ+/e/2taQnefPVCyT+xZRXqz46P56HMwT4kWivn/pW6iI
         2xjjVZP6feZHImxH/ym1vtGvnb6GhWQNlvKLhtxjCRQ3T7Dj1DCpYrAL6A3p7j81ald1
         aooeTCw2FHS5DvqrO3dV/X5JgcV67E898724gEy5WCPlESXer9nF7KMczzIH3O98cAwC
         eH4hCaqAhbcSai0rRQHsMNcWZDeNZ8cBxlrH4hHA9lSUp3BjQYcQ5IjiTdHn3c4j9BAw
         HkTQ==
X-Gm-Message-State: AOJu0YzA+TKLMu6o1S8cCUP7Smy6nzSQE7+Qh9e/A7WJWq+hkGQHu1eU
	CCqWP3RLUz5w5n4TgHN0pYqfFvvK/NCkgufTSrZgt+u+R+NZQ7t+gSs5RjSO9xWHhcpMYgZsDoo
	bQA5bEtq/QcbryVAlLteETJOkkh1FjAZuib1ivpWaBcFjPC6SMDQU3ZwPepqanQ==
X-Gm-Gg: ASbGncsKprvZwDMmI0/yDxm4gP/HOi6BOQ2FwnNCRKrF2XaJ+K3qS9iNf4aaFbHJBZ6
	ofhnASz8wTX9tdnmMapQ+AA4ccNekG7kaC9nDLRcrTsKmlveUkR/guB6GVNskljx7DF7UbypXZd
	GGR53ZUFpdyjGejBpoz9ozXafHkbZy/qwefh0eWq4F1+OxXaeanLXysyKXBhoFloJCuitVa/TO9
	aX6gcxFc+tub2ziIDj1mDBj5cvfiv6YRAGq+mQ80dKeQqrf7ifoSaLqgj5y8PwDSrzkhtSzKRxk
	PNMiF7NrDyOp2IeN0KdSpWpX4wXZ6CLJoWVItk9gxdODn4yE0x0Lo4K92YGTPvMPomQvJyQWwlT
	oayzq0n5W7tS6447FrDbsj0cVgiUOCGETts7zz3I=
X-Received: by 2002:a05:6000:2405:b0:3a0:b8b0:4407 with SMTP id ffacd0b85a97d-3a35fe961demr20203791f8f.33.1747898572029;
        Thu, 22 May 2025 00:22:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtO0x7LuetOYm1J9m1Rnt1VlZw5L3WrRT7l9tP5nHoiPlIlBPxhglJ5kk6LpY+1lGxZry0MQ==
X-Received: by 2002:a05:6000:2405:b0:3a0:b8b0:4407 with SMTP id ffacd0b85a97d-3a35fe961demr20203765f8f.33.1747898571700;
        Thu, 22 May 2025 00:22:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:2e00:6e71:238a:de9f:e396? (p200300d82f222e006e71238ade9fe396.dip0.t-ipconnect.de. [2003:d8:2f22:2e00:6e71:238a:de9f:e396])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d224sm22776583f8f.12.2025.05.22.00.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 00:22:51 -0700 (PDT)
Message-ID: <81d73c4c-28c4-4fa0-bc71-aef6429e2c31@redhat.com>
Date: Thu, 22 May 2025 09:22:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for large
 folio
To: lizhe.67@bytedance.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev,
 peterx@redhat.com
References: <20250521131711.4e0d3f2f.alex.williamson@redhat.com>
 <20250522034956.56617-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250522034956.56617-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.05.25 05:49, lizhe.67@bytedance.com wrote:
> On Wed, 21 May 2025 13:17:11 -0600, alex.williamson@redhat.com wrote:
> 
>>> From: Li Zhe <lizhe.67@bytedance.com>
>>>
>>> When vfio_pin_pages_remote() is called with a range of addresses that
>>> includes large folios, the function currently performs individual
>>> statistics counting operations for each page. This can lead to significant
>>> performance overheads, especially when dealing with large ranges of pages.
>>>
>>> This patch optimize this process by batching the statistics counting
>>> operations.
>>>
>>> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
>>> obtained through trace-cmd, are as follows. In this case, the 8G virtual
>>> address space has been mapped to physical memory using hugetlbfs with
>>> pagesize=2M.
>>>
>>> Before this patch:
>>> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
>>>
>>> After this patch:
>>> funcgraph_entry:      # 16071.378 us |  vfio_pin_map_dma();
>>>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>
>> Given the discussion on v3, this is currently a Nak.  Follow-up in that
>> thread if there are further ideas how to salvage this.  Thanks,
> 
> How about considering the solution David mentioned to check whether the
> pages or PFNs are actually consecutive?
> 
> I have conducted a preliminary attempt, and the performance testing
> revealed that the time consumption is approximately 18,000 microseconds.
> Compared to the previous 33,000 microseconds, this also represents a
> significant improvement.
> 
> The modification is quite straightforward. The code below reflects the
> changes I have made based on this patch.
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index bd46ed9361fe..1cc1f76d4020 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -627,6 +627,19 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>          return ret;
>   }
>   
> +static inline long continuous_page_num(struct vfio_batch *batch, long npage)
> +{
> +       long i;
> +       unsigned long next_pfn = page_to_pfn(batch->pages[batch->offset]) + 1;
> +
> +       for (i = 1; i < npage; ++i) {
> +               if (page_to_pfn(batch->pages[batch->offset + i]) != next_pfn)
> +                       break;
> +               next_pfn++;
> +       }
> +       return i;
> +}


What might be faster is obtaining the folio, and then calculating the 
next expected page pointer, comparing whether the page pointers match.

Essentially, using folio_page() to calculate the expected next page.

nth_page() is a simple pointer arithmetic with CONFIG_SPARSEMEM_VMEMMAP, 
so that might be rather fast.


So we'd obtain

start_idx = folio_idx(folio, batch->pages[batch->offset]);

and then check for

batch->pages[batch->offset + i] == folio_page(folio, start_idx + i)

-- 
Cheers,

David / dhildenb


