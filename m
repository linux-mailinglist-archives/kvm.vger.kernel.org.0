Return-Path: <kvm+bounces-49825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2973BADE566
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 10:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE54C17AE75
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158EE27F015;
	Wed, 18 Jun 2025 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Up6e6XAG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BE71BCA0E
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 08:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750234855; cv=none; b=Q1GolhNC6B2r8ER3L2IElj5KgWOrsNsbaG3xU2pAksGRT2/Hsb9FK0bpvQQGZsvEkKbYNMiUxkMLpKPQmjVhfq8xUXkGI8w5415GmDvLeYGP/j19c7zCHiZ/gg6nZhlRa59HJhveQOFXMmiaV8wY90z2/1QFRjQgA186bwlsLmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750234855; c=relaxed/simple;
	bh=j/cmGic9C1esUWQoErNEm5HmeHtI1O9Ix32eRobxcj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4kcDIeXjUMSRCV78oQXFEc/41+NRfTRRiRyTKtk/JC5SULWnmp/b/zbblUFhzn9Av21xBRiCZ3kPlJQhXCBxb0HJATJdXCibyvalGDT3vbTnjMa88CEGCpfhDZBcq6BIsnCTApV2QVixRmMaxw0DtuUOmG57vnUKgcWVKnqlGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Up6e6XAG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750234852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LBhYV9k9KeT6OsgTMg9dQH6Ku3lWlrWw3bTdhHVaJvs=;
	b=Up6e6XAGzL7twd1rJxZMnPbZQ93DFU2Q4DmBd2PLI5SMg5KL5GKhDOu3HdGi2idS8CYqTN
	dvFJ9aLNKX/sThgrW78Lti2NNpz6a5YDWHRM6+4vQ/8n56u3JN9rZaXc1TXA6QFqvQZlPf
	ysux+LpxX87vivU3opyhSVuGQofqM/Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-M1_gF4AVNxKoYPdFqjF8zw-1; Wed, 18 Jun 2025 04:20:49 -0400
X-MC-Unique: M1_gF4AVNxKoYPdFqjF8zw-1
X-Mimecast-MFC-AGG-ID: M1_gF4AVNxKoYPdFqjF8zw_1750234848
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43eed325461so41909035e9.3
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 01:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750234848; x=1750839648;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LBhYV9k9KeT6OsgTMg9dQH6Ku3lWlrWw3bTdhHVaJvs=;
        b=cbXMKuNxOBvXfzXlgemrsCe6YJ9Iai76blcCjKNHg+xBByHS2Wj2I1VY1NTM9YRlIM
         Hc/cb+ZdP9csyIjNHt3saYN0Q9XEI4USULGEKyRiGrTbYtm5kczhQ1rYbv47pAYEsDJW
         /FDDRmf3/dO/eqTj0UfruyuiVjZXJxkVurDs8wzuCmuoyS4tMktBvTUAvdvL/qrUvJku
         lDWuL3HFVQ6HUHeWNZqSXfURwZiWSHJqnuyqU1BlvsWUV4gfAMFkFaWqRwvGvWu4wu+V
         Ai5wAeQIlfG/xUcp0W0T4Pf93mdYHnpVGA2ze39XEEpEsKr3M1vjhfghAjXhpseYfu+Y
         603A==
X-Forwarded-Encrypted: i=1; AJvYcCU2ZI3tlfSHZdAheVsK1hIg1nMZQ9de9DaXkwehoME++GlIpky+E2EljDULe8jnvv1wmWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXVN0rP1Dw0bzhxOfFH4ocTNQ7D5tt+UUkGs+gMNUE9E8wQBGU
	tr2xs3ZrNeXViOQWztNhExH8Fb543I1hZy6bYNvxdlLE1VxysLn9TKbMQiWdjeXkglEXbVxBfYI
	eta1fMlpizxfNQF2/chAobqPlm7myKRh6f7gi8gQ04r7YM6HLShaL0A==
X-Gm-Gg: ASbGncvIM5Qg/bXiLzUxDRVVLbbmkL12OMceVD36gm0j7LPAEHP/dat33rlE/WECy6H
	PbakE7q0PMw4HrfC/7jO/l8b8eCb7oxKCfksOPr2sMnGXfxotQ+2hOZCTLYsnGfjzkTQJJm2eDt
	1uEoEmzd657Mk0rFMpFmOGhNR8eghHXrRhPxAi3Sn2JF3cLqUAKt8hTs/spxCedimcvhEbJCHvc
	zgUK3Yn08I2NrOEbBMH3W9zB08PeHrpiQJrRnnlZjdfonBLeJqwAv3wGZPpZkC4u2VXf5ZDE/U2
	G1QsmEHDds7JZ7CLdF2/JGEWch5d5MZhJqOldOH6eCO27CBXk0v1pPtSZKMJ1jtjAqxyrU4aZNf
	mWS72qArl0subxYdXsU/LOkGJqJEy6XWy/nbMK9MeobTokl4=
X-Received: by 2002:a05:600c:3513:b0:453:a95:f086 with SMTP id 5b1f17b1804b1-45343d2c0c4mr141770195e9.12.1750234847963;
        Wed, 18 Jun 2025 01:20:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyZwcfG8Crxxelq6mFOYe2ppW5H6yz4v1Ci/xgNUQ8CxoknbuH/NzdmMPo6KHsgWenCeTQyg==
X-Received: by 2002:a05:600c:3513:b0:453:a95:f086 with SMTP id 5b1f17b1804b1-45343d2c0c4mr141769695e9.12.1750234847518;
        Wed, 18 Jun 2025 01:20:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b79f45sm16165095f8f.101.2025.06.18.01.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 01:20:47 -0700 (PDT)
Message-ID: <c485543e-8450-448e-9db3-d459f2096496@redhat.com>
Date: Wed, 18 Jun 2025 10:20:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
To: lizhe.67@bytedance.com, jgg@ziepe.ca
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 peterx@redhat.com
References: <20250617152210.GA1552699@ziepe.ca>
 <20250618062820.8477-1-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250618062820.8477-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.06.25 08:28, lizhe.67@bytedance.com wrote:
> On Tue, 17 Jun 2025 12:22:10 -0300, jgg@ziepe.ca wrote:
>   
>> Weird, but I would not expect this as a general rule, not sure we
>> should rely on it.
>>
>> I would say exported function should not get automatically
>> inlined. That throws all the kprobes into chaos :\
>>
>> BTW, why can't the other patches in this series just use
>> unpin_user_page_range_dirty_lock? The way this stuff is supposed to
>> work is to combine adjacent physical addresses and then invoke
>> unpin_user_page_range_dirty_lock() on the start page of the physical
>> range. This is why we have the gup_folio_range_next() which does the
>> segmentation in an efficient way.
>>
>> Combining adjacent physical is basically free math.
>>
>> Segmenting to folios in the vfio side doesn't make a lot of sense,
>> IMHO.
>>
>>   drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++----
>>   1 file changed, 31 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index e952bf8bdfab..159ba80082a8 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -806,11 +806,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>>   				    bool do_accounting)
>>   {
>>   	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>> -	long i;
>>   
>> -	for (i = 0; i < npage; i++)
>> -		if (put_pfn(pfn++, dma->prot))
>> -			unlocked++;
>> +	while (npage) {
>> +		long nr_pages = 1;
>> +
>> +		if (!is_invalid_reserved_pfn(pfn)) {
>> +			struct page *page = pfn_to_page(pfn);
>> +			struct folio *folio = page_folio(page);
>> +			long folio_pages_num = folio_nr_pages(folio);
>> +
>> +			/*
>> +			 * For a folio, it represents a physically
>> +			 * contiguous set of bytes, and all of its pages
>> +			 * share the same invalid/reserved state.
>> +			 *
>> +			 * Here, our PFNs are contiguous. Therefore, if we
>> +			 * detect that the current PFN belongs to a large
>> +			 * folio, we can batch the operations for the next
>> +			 * nr_pages PFNs.
>> +			 */
>> +			if (folio_pages_num > 1)
>> +				nr_pages = min_t(long, npage,
>> +					folio_pages_num -
>> +					folio_page_idx(folio, page));
>> +
>> +			unpin_user_folio_dirty_locked(folio, nr_pages,
>> +					dma->prot & IOMMU_WRITE);
> 
> Are you suggesting that we should directly call
> unpin_user_page_range_dirty_lock() here (patch 3/3) instead?
> 
> BTW, it appears that implementing unpin_user_folio_dirty_locked()
> as an inline function may not be viable for vfio, given that
> gup_put_folio() is not exported.

The compiler seems to properly inline like before, so I think we can 
keep that. @Jason correct me if I am wrong.

-- 
Cheers,

David / dhildenb


