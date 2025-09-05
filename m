Return-Path: <kvm+bounces-56873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E488B4564E
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C36451C20114
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 11:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFB7343D62;
	Fri,  5 Sep 2025 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CnmtDgbf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8684E342CA2
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757071618; cv=none; b=u47EWDt92C3p29zfTtQawx71oE4QdC8VBxkE9U/Gd7tT7liK1yptyLPYdUnlSUEFpwB+npcWCNDOolggdS+asTBumLpycfmzUQ+NFgFjSE/SlDb3F3mRF0w5VGdunGs/oJH0HyahCoDgcuME6zLroHOUzh9yYvAVSCcbQcD38u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757071618; c=relaxed/simple;
	bh=izaO1BR35Fqya77sIICkCHEPey84lEeqJmCseg1mS9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDs/5FOYaV8on0OZVy/jVZSpR1jKAX4oZmCW4mm8NmbbKx+kM1o3aZqROPjRSvESjpEWf2oftHt9wHetVLua8+/EcUoV5uHc7TBELJLAM6Yy2FeKfmqVwnFGFP8dDfXC/jEjNEFMpALDt5eZ16FBlubzrKZj2bGGppxglExckco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CnmtDgbf; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e96d8722c6eso2224075276.3
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 04:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757071615; x=1757676415; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yNzF16PbnrymzXw8XwNj1X2cjJHo1hQQnEraT/RlzJM=;
        b=CnmtDgbfe5tx1THODz/ci1n4In1WFrcRusjah2wZs+jf2hB56JQjXfJ7ATtpVom76c
         61hqjlMZi1VFPhasNBrwfMHh9u/meMHuv3TN01wxweWG/qm/nxbbiEwDD5AOCKb+8F1J
         kqf3SLR5bFzPbJ66alN0+i5bf3paHUZgZnveUXtd/dKpZA89r+cvj5GhEPawFzrOqIGe
         BFTrneTpqHaT3P0E8di18lRVlobqmkBYoANZyLpCHBsruQuELWugu9BuisPtgQT3CPKc
         ldGSg6HF51kNkdeuhoPWeW/TZrB5OLZSUJIMA+AXIAsWJ5Cw+nfCxuAyZ2Y68HdN8Sjs
         o/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757071615; x=1757676415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNzF16PbnrymzXw8XwNj1X2cjJHo1hQQnEraT/RlzJM=;
        b=BulHvgkEa6sEWbfE6n5CV16Ur/Xk2EWbrSvlDa1j6/xK8atzsVqKVrRL22EsUCYgvF
         JF2DfAPkKSIFI2OsVhJY2cdV2S+x7AnVb1A2elVyHk/PBNkQl9mgOval3eBBDxTnT/uy
         1zQRZRP4Lh1Q386rC1QuMGBe75W+VJZCP5Xd1jkml7+A6tDeOpluZLQs3+WanOP1yCNF
         OPhaKGW/iDtsvj2cqwFkIX8CCt57LSwwxgrkFbywRL1rDB1HNFfOB2UjeV/p9oPPSWMI
         DS4+I1T38eWTm+184KFd790IXeCuk0hVVPTEhnsnbTzI5wfnkEntTxT7Ry+h1rSlTCJv
         9nMA==
X-Forwarded-Encrypted: i=1; AJvYcCWUIh7NXZKV00wwfJDxm5YOiY6Fmc500xCVL4yZ9UF+6LLFG51neZEeUWsO+E+McBhJ6cE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy04AJywdCncVgpGKbSMSgULU6ue5fB3LNRxnGZVlrCmiF14HjA
	Ya6ghpIbkyKqkeUbiJ1eAnFMG3bv6S2Ag3LzUARmtxGs2K/4Vy4RpkOyRn+PxOF2C2w=
X-Gm-Gg: ASbGncu8czyy7TTipvLQ+8KIUThecnIKFXOuxxwpF0v4+xE07+0A5zdNrV/XPRPHKDr
	j/N/QDZ+z3VpEO1FuCp/AD9+Dl2bqAPtuH/BAtLw4mpFH16z/LdW78pNeRhMHbwDWqtO9lbMGu+
	EF5MjWHAXIJiYMHKVUKogjUebK9uQRXdCXps4qQ3R6chQjE9lvMwuWg0D5a2zVfkradP3NUQ6O7
	Sm25F+vZnLVJpNhEuCj1lICM/SLMwg0dz1XQAAEqTGZtpFTdO3oPQ+JkOUHoJ6jsWV+hrDv1xGv
	oKzL0MI4AqtjDp8UrOPU0TyJFzkRP1AfM034/G/1W1vEBaNXf3ww0O+GjXyOMhhhoVKVfz8m1yT
	LKDs1rorL9cbgWXHPDg==
X-Google-Smtp-Source: AGHT+IEXVquWXmj0Yd3oyr4uhZoLxM2opNHaeihf8Xp8KBtnXc2guOYW42U1nSR+kmrTjCZ7Op/enQ==
X-Received: by 2002:a05:6902:18ce:b0:e96:fac0:60bc with SMTP id 3f1490d57ef6-e98a58455f2mr22114649276.41.1757071615282;
        Fri, 05 Sep 2025 04:26:55 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9bbdf504e0sm3031724276.11.2025.09.05.04.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 04:26:54 -0700 (PDT)
Message-ID: <1513d5fd-14ef-4cd0-a9a5-1016e9be6540@kernel.dk>
Date: Fri, 5 Sep 2025 05:26:53 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/25 12:41 AM, David Hildenbrand wrote:
> On 01.09.25 17:03, David Hildenbrand wrote:
>> We can just cleanup the code by calculating the #refs earlier,
>> so we can just inline what remains of record_subpages().
>>
>> Calculate the number of references/pages ahead of times, and record them
>> only once all our tests passed.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/gup.c | 25 ++++++++-----------------
>>   1 file changed, 8 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index c10cd969c1a3b..f0f4d1a68e094 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>>   #ifdef CONFIG_MMU
>>     #ifdef CONFIG_HAVE_GUP_FAST
>> -static int record_subpages(struct page *page, unsigned long sz,
>> -               unsigned long addr, unsigned long end,
>> -               struct page **pages)
>> -{
>> -    int nr;
>> -
>> -    page += (addr & (sz - 1)) >> PAGE_SHIFT;
>> -    for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>> -        pages[nr] = page++;
>> -
>> -    return nr;
>> -}
>> -
>>   /**
>>    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>>    * @page:  pointer to page to be grabbed
>> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>       if (pmd_special(orig))
>>           return 0;
>>   -    page = pmd_page(orig);
>> -    refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
>> +    refs = (end - addr) >> PAGE_SHIFT;
>> +    page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>         folio = try_grab_folio_fast(page, refs, flags);
>>       if (!folio)
>> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>       }
>>         *nr += refs;
>> +    for (; refs; refs--)
>> +        *(pages++) = page++;
>>       folio_set_referenced(folio);
>>       return 1;
>>   }
>> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>       if (pud_special(orig))
>>           return 0;
>>   -    page = pud_page(orig);
>> -    refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
>> +    refs = (end - addr) >> PAGE_SHIFT;
>> +    page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>         folio = try_grab_folio_fast(page, refs, flags);
>>       if (!folio)
>> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>       }
>>         *nr += refs;
>> +    for (; refs; refs--)
>> +        *(pages++) = page++;
>>       folio_set_referenced(folio);
>>       return 1;
>>   }
> 
> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
> pages pointer, getting rid of the "*nr" parameter.
> 
> For the time being, the following should do the trick:
> 
> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Sep 5 08:38:43 2025 +0200
> 
>     fixup: mm/gup: remove record_subpages()
>         pages is not adjusted by the caller, but idnexed by existing *nr.
>         Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 010fe56f6e132..22420f2069ee1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>                 return 0;
>         }
>  
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>                 return 0;
>         }
>  
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> 

Tested as fixing the issue for me, thanks.

-- 
Jens Axboe

