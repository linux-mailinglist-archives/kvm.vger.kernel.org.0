Return-Path: <kvm+bounces-56953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B56B469A6
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 08:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D68E91CC62B5
	for <lists+kvm@lfdr.de>; Sat,  6 Sep 2025 06:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441632C2347;
	Sat,  6 Sep 2025 06:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFSh2Efd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57202C11F8
	for <kvm@vger.kernel.org>; Sat,  6 Sep 2025 06:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757141868; cv=none; b=REaP0YY6uUkgF8arNc6xIlvzUyGt9gBYndjPv2igFS38NBrTcvBk581Qnn4fhSs98Tk1jhdVV8D55ouPxU/9keMYziznmh9jFZUUbM67WLK8YFHzXCVTyPZWeHkNfWoJU1rej4OakhcQ9d4SbkhOKskNzxLtc1MHgh5GSsEqaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757141868; c=relaxed/simple;
	bh=pNvwgSKVbeXKD3LSnOw6y6WMf26i8ENFj6GcKsQPGIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BN5XUQsu2O7qZL9Aq5CzLSSVH1D8SGLSieZzRcaCo+kfOluQpdyUchBDz1mVwnp5OC8i/ykj7sR6J2At3esAbvvi1EVQE2nyBDPJoZ5TwHvbzkmbCyl6AqRmuKUWYwHjs2Z+SMtSJYZmGrfkdl1PTc3B45Bj0T+r7zfY2SquCOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFSh2Efd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757141864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CCJs31gS3SmY6gT03ZW9SqmlSjC26seB+xyCx6US3Ag=;
	b=IFSh2EfdGppfeq4GeY0J0xB4q5d+wOrOayF6sliBVxyG0sBcnqW4rqxOEex1cj20LfDUE8
	MrcNNxqEG3zmXnDH272aQRj88zOViWoHuQiSxnLVY509ZoAVY3K1KNoLpyvjrSojHXkq/f
	utwStpE1CxZm84wkN2m4Qd2kzU1WU7s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-ZIXqGI-DOpGA0y1Zf54ClA-1; Sat, 06 Sep 2025 02:57:43 -0400
X-MC-Unique: ZIXqGI-DOpGA0y1Zf54ClA-1
X-Mimecast-MFC-AGG-ID: ZIXqGI-DOpGA0y1Zf54ClA_1757141862
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso17231005e9.0
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 23:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757141862; x=1757746662;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCJs31gS3SmY6gT03ZW9SqmlSjC26seB+xyCx6US3Ag=;
        b=TfS9oYc4e5zgiSLeqRrcwXOkvIteHjTFve9w82Bqmn+09bfdDRg5fqYlOMgmcuxKX8
         HJFbdxnldgmqeMaZm2b1di5trhHfFKBRxxDQP+EsuFoiHLkeIsCgLfzc2Y3s72P8WrLp
         8fiXBAelSNkOj1vEKBgoOXfU7W0K8AB4yPoq/shGZj9qsN45E++2tH2VQNL+PQIHD5D/
         piI2hgQH2fK2LCtx03mfsRbEy/Q6oMVKdYs4ydSrCV2/4VpPBOqln3x6ZpcYxxGUmbdg
         aA6thE3G7u0gp2D3ALAo7Q/uzOnjQzHIaOuJ1Ihb/5T5mjZ5jGNKSDwSXn9yX35p3Aiq
         6ypQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwEKthZ/ZeKS4oUpkwBxOJBoKGHWgBKG/ugH0UuucKETgPRBFWqNc+Jtghthi5QcT51Bc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu7C6eXK5gsUgRomrN26wnbUEYuEkh/ELn1F26k6ENmA29R8sC
	1uQ2514hPaSkukU3pGz2kRPixyBETgM1lWHIty9kS8olaiUPmNKS/LRgo0fK3qhTqEiATH/29gC
	9svirPIQQ1pZ+MPz9ZMhkgqOg3U125PZNDPopstp0DWtnxlQDFhpc+w==
X-Gm-Gg: ASbGncvMBmDQBHs1kkxFBCb6d2uIub9dHiw5nRxoplezL3aj/fqvpExv6qKkM2KvZQE
	wZM1FPNbm1rKSxdfWTlIk2QWACB3hu4xRz7XBWgRXH1HpRojmKxNoq62lcpNdkOGIyEvtFsU1/7
	T4O9yuBOvv8KY+Ps82IDL/z7J1bRy+sZo9inKQNbfBpdEH6+xmRjNrs6wRBSlwELvCyXxtfQC6Q
	WaEaSAOMCa+B+uwj/4CfxZO1DDktDj+tb+m5rWqu6i55GgT6DcMCk3GnxseJWhuS+Wo5vAMkRsZ
	uZWqZFoFflbr5uSfxcQPfz47ft2WtygTh8IOhaDpCTb0RO8SVFHH+12l65H9UKTneD/AM+TqiJy
	xOvlN6prs59FnNsRYDUKWzFAcBPPgkZYDlqOJtkpttRR99O9++dSkeZqTOy2ofJ/x6/c=
X-Received: by 2002:a05:600c:a43:b0:45d:d944:e763 with SMTP id 5b1f17b1804b1-45dddef8abemr11582605e9.33.1757141861916;
        Fri, 05 Sep 2025 23:57:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9de71akgKQMTH3Yad6UmnskyHOcTJBFrvjc1jDcnRZYiXZrAsp4/fGMOazHSvHvTFxb0cMA==
X-Received: by 2002:a05:600c:a43:b0:45d:d944:e763 with SMTP id 5b1f17b1804b1-45dddef8abemr11582145e9.33.1757141861401;
        Fri, 05 Sep 2025 23:57:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e740369f1esm87090f8f.11.2025.09.05.23.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 23:57:40 -0700 (PDT)
Message-ID: <64fe4c61-f9cc-4a5a-9c33-07bd0f089e94@redhat.com>
Date: Sat, 6 Sep 2025 08:57:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: Eric Biggers <ebiggers@kernel.org>
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
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com> <20250905230006.GA1776@sol>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905230006.GA1776@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.09.25 01:00, Eric Biggers wrote:
> On Fri, Sep 05, 2025 at 08:41:23AM +0200, David Hildenbrand wrote:
>> On 01.09.25 17:03, David Hildenbrand wrote:
>>> We can just cleanup the code by calculating the #refs earlier,
>>> so we can just inline what remains of record_subpages().
>>>
>>> Calculate the number of references/pages ahead of times, and record them
>>> only once all our tests passed.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>    mm/gup.c | 25 ++++++++-----------------
>>>    1 file changed, 8 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index c10cd969c1a3b..f0f4d1a68e094 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>>>    #ifdef CONFIG_MMU
>>>    #ifdef CONFIG_HAVE_GUP_FAST
>>> -static int record_subpages(struct page *page, unsigned long sz,
>>> -			   unsigned long addr, unsigned long end,
>>> -			   struct page **pages)
>>> -{
>>> -	int nr;
>>> -
>>> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
>>> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>>> -		pages[nr] = page++;
>>> -
>>> -	return nr;
>>> -}
>>> -
>>>    /**
>>>     * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>>>     * @page:  pointer to page to be grabbed
>>> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>>    	if (pmd_special(orig))
>>>    		return 0;
>>> -	page = pmd_page(orig);
>>> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
>>> +	refs = (end - addr) >> PAGE_SHIFT;
>>> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>>    	folio = try_grab_folio_fast(page, refs, flags);
>>>    	if (!folio)
>>> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>>    	}
>>>    	*nr += refs;
>>> +	for (; refs; refs--)
>>> +		*(pages++) = page++;
>>>    	folio_set_referenced(folio);
>>>    	return 1;
>>>    }
>>> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>>    	if (pud_special(orig))
>>>    		return 0;
>>> -	page = pud_page(orig);
>>> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
>>> +	refs = (end - addr) >> PAGE_SHIFT;
>>> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>>    	folio = try_grab_folio_fast(page, refs, flags);
>>>    	if (!folio)
>>> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>>    	}
>>>    	*nr += refs;
>>> +	for (; refs; refs--)
>>> +		*(pages++) = page++;
>>>    	folio_set_referenced(folio);
>>>    	return 1;
>>>    }
>>
>> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
>> pages pointer, getting rid of the "*nr" parameter.
>>
>> For the time being, the following should do the trick:
>>
>> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
>> Author: David Hildenbrand <david@redhat.com>
>> Date:   Fri Sep 5 08:38:43 2025 +0200
>>
>>      fixup: mm/gup: remove record_subpages()
>>      pages is not adjusted by the caller, but idnexed by existing *nr.
>>      Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 010fe56f6e132..22420f2069ee1 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>                  return 0;
>>          }
>> +       pages += *nr;
>>          *nr += refs;
>>          for (; refs; refs--)
>>                  *(pages++) = page++;
>> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>                  return 0;
>>          }
>> +       pages += *nr;
>>          *nr += refs;
>>          for (; refs; refs--)
>>                  *(pages++) = page++;
> 
> Can this get folded in soon?  This bug is causing crashes in AF_ALG too.

Andrew immediately dropped the original patch, so it's gone from 
mm-unstable and should be gone from next soon (today?).

-- 
Cheers

David / dhildenb


