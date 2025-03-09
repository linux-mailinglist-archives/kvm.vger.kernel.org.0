Return-Path: <kvm+bounces-40526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 822CDA58437
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 14:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ABBF3AD26D
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 13:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A9A1DCB0E;
	Sun,  9 Mar 2025 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVz46CN7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07722136349;
	Sun,  9 Mar 2025 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741526634; cv=none; b=iLadkb/cLZECY93/3+UenK2YmLHxOuUJ/BnLF2fm7gUlGU5J9/neotwoOVv5UcYlH+6LGqbERyC0+/4NR67EerEpRE55/A4gB+F/qWE5jSLo0/aTSBc+KtX8Aky+IKV+X6wdQXf8CIFhGJQJ5MCG0RDBZJMubLGO9IV+DDSfdeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741526634; c=relaxed/simple;
	bh=amviRZAng65qhSPsIn/ez8PlX5/EY5IcXVvOyQBoCh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZNGvFCWFmn8to73uMN3GfOjykI1pgpoWD0gAsAaqyv/MgeSi4QgEcTuUKpAkkijCaXTEppVADyJGL8MOIjazSryjWGTiGcWW9ptIaMat+vVneLFz3barGNIWcCItoRDQD0W6+HJwBhL76Br1DCzq61GaOtkYKWAxheslRee0uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVz46CN7; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2241053582dso43908715ad.1;
        Sun, 09 Mar 2025 06:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741526632; x=1742131432; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=78f5GfsZLdHs7HcZYqhufn9bqBeaLB9GfsmUNDdGsAU=;
        b=dVz46CN7GFk2MohHsYZ1XpOKSfkjB8WZZklFuVu4dwGXHnMq+/+DPo0NDU9RYZ1nmO
         StWMyWieLWr2EFekLtMfS7OY07T37Wf4p7Yr/k0gtVA8sbmhApmoKVHWdCk05IBBCkO9
         GXgiiPhpbxyuJuhUXrasukPdW+3Y8tNLNp3da5OPzFGDoJ43XvgzFubu6JKCDTDLvRPV
         QT10UjAgCd7URCYnsbTb3I35yAVBvjKQqkwzXkVhhiIIcstF/ga2Hgi3NaHEvnut06iQ
         Zmg7nhaVsPi9r+VH8VlYVXe0xD+YBI/VS3RAkEhQzVLOiKvD8FqlqILpKbYoTiF0Bdli
         Yo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741526632; x=1742131432;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=78f5GfsZLdHs7HcZYqhufn9bqBeaLB9GfsmUNDdGsAU=;
        b=SLujwD/K5KKk51kaKy78olPD9T8e6LllR8SVwYHfc7zfkoqqwLY0MMPft+4ML8hoNn
         N1BixI+htVtWc5MqbHGlU5FpozmEh+ep2lK0Wx9D6bkvqF0PIVr5EcRl3YflN6HGYtsh
         1K3Qz+VSxGwKAS345FSVx/+oz+S46K79gpZY6pmBmhwa/G88fp+02i3OqjKHDn3IVTF2
         cqSr/iOL0ftXc2Aljn0PinAZWucYSdE4pqKWyZ3TnIrMYvTUW1lcqAvoa+34XGAfrtM5
         VnZdpnwWlXYDrCANhRYPqQRP1uBUsmxFqCL04ZoxFKTWNamOahfCsajhJmMUHVYUns5g
         CqjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw8D/2Etaz6O2DIR3WsW5NuKisN1gOcibV2ejKQmVlbM9lWIbO/yNJ9cQMg/MhGtSRD5j8tywT5UpuZFBA@vger.kernel.org, AJvYcCVBZqjFSShKlA9/tRVoCr1HUIT494t2yd5+6g+7ijnbS/3+plWEZDTrlyA6+l0dhOkkpWCkkKy9@vger.kernel.org, AJvYcCVhEoJRBBhprANid+iS7cJntWMmp+eoEX/oA6homJnG8Ej991mKOVS3SEpVJIeP+0S2pdwDcVLHaWNw@vger.kernel.org, AJvYcCWMRG5l8xdXa7bI53NfScdvdVpFHIjFpGST8U/+U9EGJkW1Cz2KP818KoGYmYS9GQhLgY5LdrJWPVeD7i0=@vger.kernel.org, AJvYcCWl8RCmwfTr+gTFwKNxebdtWgGSII1tCp7IXOFdvBZbRGuw5O0x8PWcklhsr0G9xlD6XP7e0A4auu8Z@vger.kernel.org, AJvYcCXwYhBLoHtWchUPd4dhM4v9zMhoDiPgsloe19pqimPMmFntvkcxWUy5xNxsDq0lEQvKKWU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpO6iAPX6wtQylr6LWtgptxI6xDaAfiQvZU2fpt5oXXNu7DfaI
	0DSCcb79f0tkyUT1+pA+vZW6QcTUz6j9v41mb3DsdzlrqPmU9Rsv
X-Gm-Gg: ASbGncvS7V1lS8M83grceIJfnJtzNab7Sk1jqr0fL4Tkm3UKu3qtpkL5gIqaq7FlRaH
	qbsDgKCnE5lwgPbpfRmFJOsqkgFyXfEB8+ts5+mfvaEkQgYEoA/FaTsTR4Hl6a6jf0LRl/YbfH4
	h2c2Bc+xtCfeUZJKDENxDq+AiweaYUhs8rXSvF8NyJDQ+2d4p2/VzRZ7ymgFUJaw9b389nQhjar
	4SWQUgcurn14SMuBYFfzuXBF5REMVu3u7pYbQx4DKSYZ478pCHThsl890USCFLlxZztBdSfC/Xx
	hrlU76nK2xkRgcXg5mOL36k9pYkpgXs1XknhNE3FTU4UubSg+p/Mlyj77rTAKYRrfBObJvvZMcp
	1AW38DvjAEA+5gbsEvUrBOwO+SCG8tg7DuctILaZZ
X-Google-Smtp-Source: AGHT+IFtC936bSg/3HregqNsD+RiIvE+I7Cf0Sja++qaGUNlZeLkZuXJlqOzuqqV2Wpl3dx1MeKXQQ==
X-Received: by 2002:a17:902:eb81:b0:220:c86d:d7eb with SMTP id d9443c01a7336-22428ab863cmr167985465ad.36.1741526632153;
        Sun, 09 Mar 2025 06:23:52 -0700 (PDT)
Received: from ?IPV6:2409:8a55:301b:e120:c508:514a:4065:877? ([2409:8a55:301b:e120:c508:514a:4065:877])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d4f20913sm597161b3a.13.2025.03.09.06.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Mar 2025 06:23:51 -0700 (PDT)
Message-ID: <7abb0e8c-f565-48f0-a393-8dabbabc3fe2@gmail.com>
Date: Sun, 9 Mar 2025 21:23:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: NeilBrown <neilb@suse.de>, Yunsheng Lin <linyunsheng@huawei.com>
Cc: Qu Wenruo <wqu@suse.com>, Yishai Hadas <yishaih@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Luiz Capitulino <luizcap@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, Dave Chinner
 <david@fromorbit.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-nfs@vger.kernel.org
References: <> <180818a1-b906-4a0b-89d3-34cb71cc26c9@huawei.com>
 <174138137096.33508.11446632870562394754@noble.neil.brown.name>
Content-Language: en-US
From: Yunsheng Lin <yunshenglin0825@gmail.com>
In-Reply-To: <174138137096.33508.11446632870562394754@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 5:02 AM, NeilBrown wrote:

...

>>
>>>    allocated pages in the array - just like the current
>>>    alloc_pages_bulk().
>>
>> I guess 'the total number of allocated pages in the array ' include
>> the pages which are already in the array before calling the above
>> API?
> 
> Yes - just what the current function does.
> Though I don't know that we really need that detail.
> I think there are three interesting return values:
> 
> - hard failure - don't bother trying again soon:   maybe -ENOMEM
> - success - all pages are allocated:  maybe 0 (or 1?)
> - partial success - at least one page allocated, ok to try again
>    immediately - maybe -EAGAIN (or 0).

Yes, the above makes sense. And I guess returning '-ENOMEM' & '0' &
'-EAGAIN' seems like a more explicit value.

> 
>>

...

>>
> 
> If I were do work on this (and I'm not, so you don't have to follow my
> ideas) I would separate the bulk_alloc into several inline functions and
> combine them into the different interfaces that you want.  This will
> result in duplicated object code without duplicated source code.  The
> object code should be optimal.

Thanks for the detailed suggestion, it seems feasible.
If the 'add to a linked list' dispose was not removed in the [1],
I guess it is worth trying.
But I am not sure if it is still worth it at the cost of the above
mentioned 'duplicated object code' considering the array defragmenting
seem to be able to unify the dispose of 'add to end of array' and
'add to next hole in array'.

I guess I can try with the easier one using array defragmenting first,
and try below if there is more complicated use case.

1. 
https://lore.kernel.org/all/f1c75db91d08cafd211eca6a3b199b629d4ffe16.1734991165.git.luizcap@redhat.com/

> 
> The parts of the function are:
>   - validity checks - fallback to single page allocation
>   - select zone - fallback to single page allocation
>   - allocate multiple pages in the zone and dispose of them
>   - allocate a single page
> 
> The "dispose of them" is one of
>    - add to a linked list
>    - add to end of array
>    - add to next hole in array
> 
> These three could be inline functions that the "allocate multiple pages"
> and "allocate single page" functions call.  We can pass these as
> function arguments and the compile will inline them.
> I imagine these little function would take one page and return
> a bool indicating if any more are wanted.
> 
> The three functions: alloc_bulk_array alloc_bulk_list
> alloc_bulk_refill_array would each look like:
> 
>    validity checks: do we need to allocate anything?
> 
>    if want more than one page &&
>       am allowed to do mulipage (e.g. not __GFP_ACCOUNT) &&
>       zone = choose_zone() {
>          alloc_multi_from_zone(zone, dispose_function)
>    }
>    if nothing allocated
>       alloc_single_page(dispose_function)
> 
> Each would have a different dispose_function and the initial checks
> would be quite different, as would the return value.
> 
> Thanks for working on this.
> 
> NeilBrown
> 


