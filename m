Return-Path: <kvm+bounces-56042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B76F9B395D0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3E9A200848
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 07:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D772D6E7C;
	Thu, 28 Aug 2025 07:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMd5HmQD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B312D661E
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 07:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756367078; cv=none; b=ZMiyx6vU/83nyWhz9IHQJ5OV3BgI15KbiTDIUMFOdZqtsjLStHXVSgoDXWLsru6fx3Q767P/z0e7Gq2/hKXIowkk/pvpTB5kVnSCRrUJAuufF87Bt0IeL7Hlk0XrHo/RVUxhDTLYnuDjBqFWoJkjMKFiMEItL0SbW2vUQT6AgKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756367078; c=relaxed/simple;
	bh=LPT74/tGhKQ3ye+BUqg+d+LsutJvnlasD4TgSt/ejpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQWjtd9iLXzBX/PN1T7qbyF9YQL4iQsYnuTJcMG1kNEjOS8L+wlKffoZPfWFlmAN1q5fvBXpg0CrBWafgxPV58ekdNH14GSwQXLlmr+78m9CedE0jIcMhH6P6SKdVlka8OYteflzfygtyFp6+CJeZ+VSFtxICjUzwvj/Q3UAGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DMd5HmQD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756367074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dhK+BxA/iOgcFdCxhcrFsJ9ic9ebRUg2wIpkT+UYj24=;
	b=DMd5HmQD2ktaSlU6LjNM00uPyQ+CoCkIwMqaAjkJRiepsUmwZ9YJ5OoB9m44zz1bPhGO2b
	NVUyeOIyq8vsvgk2cVG7ydz6+yVYrnIgg+ct3Zu0sCWSVZ0ny1OtoKOk2bsb2ZMf+K2agN
	IaBH+DbkXJq4mI7jzI+DhJON05Uy/8w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551--uuqi2MxNDG-YBhq__yy5Q-1; Thu, 28 Aug 2025 03:44:33 -0400
X-MC-Unique: -uuqi2MxNDG-YBhq__yy5Q-1
X-Mimecast-MFC-AGG-ID: -uuqi2MxNDG-YBhq__yy5Q_1756367071
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c7aa4cf187so421885f8f.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 00:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756367071; x=1756971871;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dhK+BxA/iOgcFdCxhcrFsJ9ic9ebRUg2wIpkT+UYj24=;
        b=qeqseAbqxhhp7U7eTOZh9EgIJVasZTUKYx5a5iCCEBj4Ttl8wBa2nbvXTMcoPYaYDv
         K3bu6zYsmTOD4LikwhTTmMi+dimpjFrG8CagvwwzT46wDCGJHvzN30g/XmR4zQxkbnvt
         j7bMaG53aDn0dQ9itMxpCbMx558dBYuuzKqdgcc9GRA3NiGwxPlYPTK76tZQ8QVFhxVE
         r06NYBK/akOVSBMyunrxVvpZZdGFIkOGX24xwhxakjkJLQmgLCgMSNQ0Zy2703A5SpGy
         lH9KgP/8sH4axA/KxEXZhOdSEiL33mchAfZ7MPO+o7k0n+8OmQJDj/EC97BaBDGT22Hw
         mgBw==
X-Forwarded-Encrypted: i=1; AJvYcCUXw/ejfeK661kw7IbZvxd44VWUz88tynBKW7pMxn/tX0mj1GC9JKBG89in/orTNJPo3LA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIh7rpVWdhcvXdAQB7QhsVVjamVknEUfBuxxv3JDw6fabwhITH
	spF7WDEApLkLYYT6yEGHfaZtOc4DxnlzLBBRllXoUjGzyNxRxGlTh71wn1nbKtEmwM7kLZepq/+
	jTNiFv8ODMALNee3gr2DXtDIkzOnFDoL+yqte1zO17wxY0saDpyEGeQ==
X-Gm-Gg: ASbGncvwrnDghcgnw66j3EPNsueaNMn8UoD9SR4SclohE5cguTq5JJewKvnp1E4pqCx
	K5lgzjugGijse8yF/DWY8u55MhcB+0cj3kLIEAmIjDjF2RBtxlHpwxrtmzN99XrAhensaw2J/xA
	ph2qPeay5/Rdk9LvhjmPCrsZGeN8Mu5kl7J4bX+FfVg17fCajq/cwcX74RHzgjTzQdxVW09AFU0
	GcqUCeoBd5u3gsQoy4jUzn+QUBOawofQj/MOXTAWhY6GT45Nb6H99quiAGkWbc8/EMNRdU2MXwZ
	lgdmpaYXPEbTalwDc9pOvmL7Hgm0tk+avugcspbr9uGZB9RcaF5j0uJONPc6IB7EAitiC+3Ylwd
	YJ09HOHgSuyj1sUToFPQsh6rDl2hHO2jytWBDlfG16rAr1FY5E/GxoJqlWfOcV9B+xTI=
X-Received: by 2002:a5d:5d0a:0:b0:3b8:f358:e80d with SMTP id ffacd0b85a97d-3c5db8ab097mr18866986f8f.5.1756367070812;
        Thu, 28 Aug 2025 00:44:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXm6ZHFF1yBgYNSUrsi9TF+wDF8WO4dw6T2lJHPZ3voQni8d+w8tpOsvfzaL30mwHhRdMyBw==
X-Received: by 2002:a5d:5d0a:0:b0:3b8:f358:e80d with SMTP id ffacd0b85a97d-3c5db8ab097mr18866962f8f.5.1756367070322;
        Thu, 28 Aug 2025 00:44:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cd2e01dd9dsm4501230f8f.60.2025.08.28.00.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 00:44:29 -0700 (PDT)
Message-ID: <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
Date: Thu, 28 Aug 2025 09:44:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com> <aLADXP89cp6hAq0q@kernel.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLADXP89cp6hAq0q@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 09:21, Mike Rapoport wrote:
> On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
>> We can now safely iterate over all pages in a folio, so no need for the
>> pfn_to_page().
>>
>> Also, as we already force the refcount in __init_single_page() to 1,
>> we can just set the refcount to 0 and avoid page_ref_freeze() +
>> VM_BUG_ON. Likely, in the future, we would just want to tell
>> __init_single_page() to which value to initialize the refcount.
>>
>> Further, adjust the comments to highlight that we are dealing with an
>> open-coded prep_compound_page() variant, and add another comment explaining
>> why we really need the __init_single_page() only on the tail pages.
>>
>> Note that the current code was likely problematic, but we never ran into
>> it: prep_compound_tail() would have been called with an offset that might
>> exceed a memory section, and prep_compound_tail() would have simply
>> added that offset to the page pointer -- which would not have done the
>> right thing on sparsemem without vmemmap.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/hugetlb.c | 20 ++++++++++++--------
>>   1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4a97e4f14c0dc..1f42186a85ea4 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>   {
>>   	enum zone_type zone = zone_idx(folio_zone(folio));
>>   	int nid = folio_nid(folio);
>> +	struct page *page = folio_page(folio, start_page_number);
>>   	unsigned long head_pfn = folio_pfn(folio);
>>   	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>> -	int ret;
>> -
>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
>> -		struct page *page = pfn_to_page(pfn);
>>   
>> +	/*
>> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
>> +	 * so these pages are completely uninitialized.
> 
>                               ^ not? ;-)

Can you elaborate?

-- 
Cheers

David / dhildenb


