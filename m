Return-Path: <kvm+bounces-5791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2E3826968
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17D1BB2141C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 08:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBD9BA38;
	Mon,  8 Jan 2024 08:25:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB833C139;
	Mon,  8 Jan 2024 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4T7nCc0ZBmz1gx9K;
	Mon,  8 Jan 2024 16:24:12 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 07150140384;
	Mon,  8 Jan 2024 16:25:42 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 8 Jan
 2024 16:25:41 +0800
Subject: Re: [PATCH net-next 2/6] page_frag: unify gfp bits for order 3 page
 allocation
To: Alexander H Duyck <alexander.duyck@gmail.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>, <linux-mm@kvack.org>
References: <20240103095650.25769-1-linyunsheng@huawei.com>
 <20240103095650.25769-3-linyunsheng@huawei.com>
 <d4947ef05bca8525d04f9943e92b4e43ec82c583.camel@gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1d40427d-78e3-ef40-a63f-206c0697bda2@huawei.com>
Date: Mon, 8 Jan 2024 16:25:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d4947ef05bca8525d04f9943e92b4e43ec82c583.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)

On 2024/1/5 23:35, Alexander H Duyck wrote:
> On Wed, 2024-01-03 at 17:56 +0800, Yunsheng Lin wrote:
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
>>  		if (likely(pfrag->page)) {
>>  			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 9a16305cf985..1f0b36dd81b5 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4693,8 +4693,8 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
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
>> index 446e945f736b..d643332c3ee5 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2900,7 +2900,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
>>  		/* Avoid direct reclaim but allow kswapd to wake */
>>  		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
>>  					  __GFP_COMP | __GFP_NOWARN |
>> -					  __GFP_NORETRY,
>> +					  __GFP_NORETRY | __GFP_NOMEMALLOC,
>>  					  SKB_FRAG_PAGE_ORDER);
>>  		if (likely(pfrag->page)) {
>>  			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
> 
> Looks fine to me.
> 
> One thing you may want to consider would be to place this all in an
> inline function that could just consolidate all the code.

Do you think it is possible to further unify the implementations of the
'struct page_frag_cache' and 'struct page_frag', so adding a inline
function for above is unnecessary?

> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> 
> .
> 

