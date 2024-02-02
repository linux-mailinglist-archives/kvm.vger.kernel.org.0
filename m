Return-Path: <kvm+bounces-7778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB818465A7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 03:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 243DBB22AD0
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 02:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD669B67C;
	Fri,  2 Feb 2024 02:10:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2881EBE55;
	Fri,  2 Feb 2024 02:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706839814; cv=none; b=POEC7NIP6jDK5EDB5/dJjURccWEeuSCkss4/7AvACzd8gmI8vsvi+9pFTvsCsT2jifn1qB3rCyg6vNWzTeg7E3bilcW6OpfIDc4gZ5pVDT1RGLhUKkvzgZvGfG13qvTRqgiDuykXGL9IfqZNVLg7T2UEQ4Gb7/gXQDfH24AOn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706839814; c=relaxed/simple;
	bh=S1wJ8O2c3yy8xDXZK3UXs+325LgwXfZxjnn5v0hTV8w=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ji95BbYBQiYG/bxFPkHu5yoLoCIKG1Ai4zDJJcS8b7g69tSZKLDBOmjdD/DbYP06Uu5KIGmrLdcaG4ktbyX/46Fn6pc4UwNiyFjNAydeQPPr1wXDowxdYY9ArHj635I33frxQOVLQTzLHkzRQqU/xE+0fhlCkEV/rlxviJhe3lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TQzhj4yq1zXgvp;
	Fri,  2 Feb 2024 10:08:37 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 0296B18007A;
	Fri,  2 Feb 2024 10:10:03 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 2 Feb
 2024 10:10:02 +0800
Subject: Re: [PATCH net-next v4 2/5] page_frag: unify gfp bits for order 3
 page allocation
To: Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Alexander Duyck
	<alexanderduyck@fb.com>, Alexander Duyck <alexander.duyck@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet
	<edumazet@google.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>
References: <20240130113710.34511-1-linyunsheng@huawei.com>
 <20240130113710.34511-3-linyunsheng@huawei.com>
 <81c37127dda0f2f69a019d67d4420f62c995ee7f.camel@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2e8606b1-81c2-6f3f-622c-607db5e90253@huawei.com>
Date: Fri, 2 Feb 2024 10:10:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <81c37127dda0f2f69a019d67d4420f62c995ee7f.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)

On 2024/2/1 21:16, Paolo Abeni wrote:
> On Tue, 2024-01-30 at 19:37 +0800, Yunsheng Lin wrote:
>> Currently there seems to be three page frag implementions
>> which all try to allocate order 3 page, if that fails, it
>> then fail back to allocate order 0 page, and each of them
>> all allow order 3 page allocation to fail under certain
>> condition by using specific gfp bits.
>>
>> The gfp bits for order 3 page allocation are different
>> between different implementation, __GFP_NOMEMALLOC is
>> or'd to forbid access to emergency reserves memory for
>> __page_frag_cache_refill(), but it is not or'd in other
>> implementions, __GFP_DIRECT_RECLAIM is masked off to avoid
>> direct reclaim in skb_page_frag_refill(), but it is not
>> masked off in __page_frag_cache_refill().
>>
>> This patch unifies the gfp bits used between different
>> implementions by or'ing __GFP_NOMEMALLOC and masking off
>> __GFP_DIRECT_RECLAIM for order 3 page allocation to avoid
>> possible pressure for mm.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>> CC: Alexander Duyck <alexander.duyck@gmail.com>
>> ---
>>  drivers/vhost/net.c | 2 +-
>>  mm/page_alloc.c     | 4 ++--
>>  net/core/sock.c     | 2 +-
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index f2ed7167c848..e574e21cc0ca 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -670,7 +670,7 @@ static bool vhost_net_page_frag_refill(struct vhost_net *net, unsigned int sz,
>>  		/* Avoid direct reclaim but allow kswapd to wake */
>>  		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
>>  					  __GFP_COMP | __GFP_NOWARN |
>> -					  __GFP_NORETRY,
>> +					  __GFP_NORETRY | __GFP_NOMEMALLOC,
>>  					  SKB_FRAG_PAGE_ORDER);
> 
>>  		if (likely(pfrag->page)) {
>>  			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index c0f7e67c4250..636145c29f70 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4685,8 +4685,8 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
>>  	gfp_t gfp = gfp_mask;
>>  
>>  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
>> -	gfp_mask |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY |
>> -		    __GFP_NOMEMALLOC;
>> +	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
>> +		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
>>  	page = alloc_pages_node(NUMA_NO_NODE, gfp_mask,
>>  				PAGE_FRAG_CACHE_MAX_ORDER);
>>  	nc->size = page ? PAGE_FRAG_CACHE_MAX_SIZE : PAGE_SIZE;
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 88bf810394a5..8289a3d8c375 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2919,7 +2919,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
>>  		/* Avoid direct reclaim but allow kswapd to wake */
>>  		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
>>  					  __GFP_COMP | __GFP_NOWARN |
>> -					  __GFP_NORETRY,
>> +					  __GFP_NORETRY | __GFP_NOMEMALLOC,
>>  					  SKB_FRAG_PAGE_ORDER);
> 
> This will prevent memory reserve usage when allocating order 3 pages,
> but not when allocating a single page as a fallback. Still different

More accurately, the above ensures memory reserve is always not used
for order 3 pages, whether memory reserve is used for order 0 pages
depending on original 'gfp' flags, if 'gfp' does not have __GFP_NOMEMALLOC
bit set, memory reserve may still be used  for order 0 pages.

> from the __page_frag_cache_refill() allocator - which never accesses
> the memory reserves.

I am not really sure I understand the above commemt.
The semantic is the same as skb_page_frag_refill() as explained above
as my understanding. Note that __page_frag_cache_refill() use 'gfp_mask'
for allocating order 3 pages and use the original 'gfp' for allocating
order 0 pages.

> 
> I'm unsure we want to propagate the __page_frag_cache_refill behavior
> here, the current behavior could be required by some systems.
> 
> It looks like this series still leave the skb_page_frag_refill()
> allocator alone, what about dropping this chunk, too? 

As explained above, I would prefer to keep it as it is as it seems
to be quite obvious that we can avoid possible pressure for mm by
not using memory reserve for order 3 pages as we have the fallback
for order 0 pages.

Please let me know if there is anything obvious I missed.

> 
> Thanks!
> 
> Paolo
> 
> 
> .
> 

