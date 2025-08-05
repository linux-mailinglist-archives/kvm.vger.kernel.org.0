Return-Path: <kvm+bounces-53998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E767B1B4D9
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5A631831BF
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4DF274B31;
	Tue,  5 Aug 2025 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBkkN/Mv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC80233D9C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754400280; cv=none; b=N8iaokUuWDXP8xove44I4rkROlGkDJLrKtktLcFeY/BQapw8FB9fY75PD+PGivatKh6TAHiC2qnjNRy30sI3upwBy61ZOpgMPakyIwb9ZYbjzSg1bx6zhoirOu6vAFJ7RqtAzebVmiLrCmzM0LMg4REM3pszZ3R4QHNUpYZMMCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754400280; c=relaxed/simple;
	bh=RfLzX4Q4BxbnsHtU4GtgxETLEB/PtabHAd+a1FtlCB4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gfHfZ+Cm2s3QDkFdKwGrvBrNjXVx4mfuVDd6qtQok0nMIgXMBQYrZ1LU1nsmta7JSOhxSPviXsMA9THEvhBrlNlTAeU6fh3irPtiMd55vP0T2J+50+F1XDMtG7UQLF8OPlhgqj6zIlPipo1lK8UAokuRyn7C/ObKVx+IaO4OK/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBkkN/Mv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754400278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XYOJKTILfQciCJhITCN9P/oSYM+SzdAxmdh58NlLZ3c=;
	b=GBkkN/MvyOeHQxuFbwaF0BsxuezUE3c/IYThmOBujn+20LXiYt8gItHTMR636uSjPNgeD3
	LSpjmTlzM+39jq+Rh86nd4rdQTSRflbNTtoE01pSazVSqnhFF1iLIPReJluzRW3HglSo7l
	iceyrwsV9nKg1PCnOtWmINsaD1db/QI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-hm4qRTgtNXu2u8iejEZXLQ-1; Tue, 05 Aug 2025 09:24:32 -0400
X-MC-Unique: hm4qRTgtNXu2u8iejEZXLQ-1
X-Mimecast-MFC-AGG-ID: hm4qRTgtNXu2u8iejEZXLQ_1754400270
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459e4b85895so1426185e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754400269; x=1755005069;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XYOJKTILfQciCJhITCN9P/oSYM+SzdAxmdh58NlLZ3c=;
        b=KbwzDwU0zDGjrF2oR3wb+RCZ3y4w97/HG8le0NxVG98eq1WbeFQl9abGWrnN8UPVzT
         OFiJTpQiuzyAI/toM5qO4zZyM4ro6CeekFWjfdRWL2Wf0D4tQeMf7RMs5J5NmvHmIg9a
         Ug4HHq0UMnnMi/OcUxqTKQUVlmYXNDc8RPvPbz5Q4Y+D0HXNFJOhHHDLYhAtUp0zYHpE
         5JLwChJYZdtNCnslT25+MzdlnqW5dnbxKcmvu7twYd/M45OHWvF44wC4NH/iLvT+rrnE
         7aTZUkLz/grJU5ZtpugormOodEhuAY4//2M5aAn1YwHgwvqWCTFpFim7DCPxQIa80HCL
         JIBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUI3fUZpy4TtuP2xQTl1pRPZX/oiKBmic+wyz8tQS1yWwSPo8AQ4yWCTfnBx38ppvejI9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEZkOTTQfEiw4Rir0pes+1wB70NzM9X1iAAuC32m3trLEvQNc3
	DqIktvgLkz+YTPwo9clY7z8LQ6745EgGlK7REoPWYADHBubq+70WaTu5/QSXwGHbNjpCCVwnNUd
	rV9NPR3D1UABj1ficKAMjoKtUNNjL/C7fjxktFB0SLqS6lU/ve5KhG6YfJHGhMJKr
X-Gm-Gg: ASbGncubGBGEOq19GhLQQLgINuoISOU7YrrefJVy02aTiXJmNJi1Gk3chDLgk0KAH8i
	NhvQlwCQzHbERl82Aco3ovBIJ+pTko1joTZjUBRi/MNP+iAspa6wriOfLCHKRDnxo2I4uKtt0t9
	/etCPeRQE2lKbx/leEW8zVBOeWjJzalfVG33uIEvudMmoAiqEtI5mG/G07ay/f8Y5tJ9mA0mxOX
	tIE4UKg0ZoWJjlFe4n1CfYhkJcsV8/HgEu/rEIc+aPWl91CTGqLTldAtdIoX5zXNVdvpMmw5XHG
	1Xl1cxj0E7SESA9coA9rB2Jg+Xej7zWwDleBCFUAh21HNhD97P5qa3Aw1iDgPUxdPMdHJStctFj
	t+CbFrPN5RVL02hyJW7QlDfgqKj+LiYXOU1KU8eJbiUokPyFUH2Qwim+VqYhSPlBwbWQ=
X-Received: by 2002:a05:600c:1c23:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-459ddada9f2mr41838365e9.25.1754400269647;
        Tue, 05 Aug 2025 06:24:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr02D/Z7RCBEzNWKzAb5ZRGgoaEQj6y+Ky1C5usyKNW+A/uJvyYEO40lI8YVfU7KUse5YlTQ==
X-Received: by 2002:a05:600c:1c23:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-459ddada9f2mr41838175e9.25.1754400269232;
        Tue, 05 Aug 2025 06:24:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm19185818f8f.67.2025.08.05.06.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:24:28 -0700 (PDT)
Message-ID: <65fb1e02-563f-4323-8bc4-a81a6e6ad09e@redhat.com>
Date: Tue, 5 Aug 2025 15:24:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
From: David Hildenbrand <david@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <7f891077-39a2-4c0a-87ec-8ef1a244f7ad@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <7f891077-39a2-4c0a-87ec-8ef1a244f7ad@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:20, David Hildenbrand wrote:
> On 05.08.25 15:00, Linus Torvalds wrote:
>> On Tue, 5 Aug 2025 at 10:47, David Hildenbrand <david@redhat.com> wrote:
>>>
>>> The concern is rather false positives, meaning, you want consecutive
>>> PFNs (just like within a folio), but -- because the stars aligned --
>>> you get consecutive "struct page" that do not translate to consecutive PFNs.
>>
>> So I don't think that can happen with a valid 'struct page', because
>> if the 'struct page's are in different sections, they will have been
>> allocated separately too.
> 
> I think you can end up with two memory sections not being consecutive,
> but the struct pages being consecutive.
> 
> I assume the easiest way to achieve that is having a large-enough memory
> hole (PCI hole?) that spans more than section, and memblock just giving
> you the next PFN range to use as "struct page".
> 
> It's one allocation per memory section, see
> 
> sparse_init_nid()->__populate_section_memmap(prn, PAGES_PER_SECTION) ->
> memmap_alloc()->memblock_alloc().
> 
> With memory hotplug, there might be other weird ways to achieve it I
> suspect.
> 
>>
>> So you can't have two consecutive 'struct page' things without them
>> being consecutive pages.
>>
>> But by all means, if you want to make sure, just compare the page
>> sections. But converting them to a PFN and then converting back is
>> just crazy.
>   > > IOW, the logic would literally be something like (this assumes there
>> is always at least *one* page):
>>
>>           struct page *page = *pages++;
>>           int section = page_to_section(page);
>>
>>           for (size_t nr = 1; nr < nr_pages; nr++) {
>>                   if (*pages++ != ++page)
>>                           break;
>>                   if (page_to_section(page) != section)
>>                           break;
>>           }
>>           return nr;
> 
> I think that would work, and we could limit the section check to the
> problematic case only (sparsemem without VMEMMAP).
> 
>>
>> and yes, I think we only define page_to_section() for
>> SECTION_IN_PAGE_FLAGS, but we should fix that and just have a
>>
>>     #define page_to_section(pg) 0
> 
> Probably yes, have to think about that.

Ah,

#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
#define SECTION_IN_PAGE_FLAGS
#endif

so it will already be optimized out with your proposal, great!

-- 
Cheers,

David / dhildenb


