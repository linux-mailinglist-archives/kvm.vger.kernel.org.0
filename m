Return-Path: <kvm+bounces-38568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E42A3BC9E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 12:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF4CC188FB86
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 11:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA081DF24B;
	Wed, 19 Feb 2025 11:20:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76931A2C29;
	Wed, 19 Feb 2025 11:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739964017; cv=none; b=SjRp+tjus/YljY2w3us9Z+beFFPokMLgjLJHXAJla2T/6Hszcmw7oTIOQM1KAkIoZ5ZR5C2ZvyrC5PdSR/VzBiIwarhA+5T/zSwlsaJY8iR6S94pErd0mvLYpwQWTSE3ukyefAiWN3H1+ZN06+ZmdZIvh29BPviJgaOdglWP1rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739964017; c=relaxed/simple;
	bh=21iMGn5nmMgxSUhNifIphPXQHgu7d4Uv/JM64va/VIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=h03P3jDI85tkEjeyDEeMH4ti1+gir/Xp45EUV1LFayAIk9vwxTpwfr/R8XAoxPzElLjImwvq/rKY7XELruu3NQ3aLkKSp7KPCylqVntHjkOHggbRRRv1XSq1KefjWntls3WZj4V6c5TpAOYDca7GPTwnGk9jmmz4WzQRnanU31Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YyYpr37n2z22kst;
	Wed, 19 Feb 2025 19:20:36 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 9333E140360;
	Wed, 19 Feb 2025 19:20:05 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Feb 2025 19:20:05 +0800
Message-ID: <c9950a79-7bcb-41c2-a59e-af315dc6d7ff@huawei.com>
Date: Wed, 19 Feb 2025 19:20:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: alloc_pages_bulk: remove assumption of populating only
 NULL elements
To: Dave Chinner <david@fromorbit.com>
CC: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Chris
 Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba
	<dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Trond Myklebust
	<trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
	<chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Luiz Capitulino
	<luizcap@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-xfs@vger.kernel.org>,
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>
References: <20250217123127.3674033-1-linyunsheng@huawei.com>
 <Z7Oqy2j4xew7FW9Z@dread.disaster.area>
 <cf270a65-c9fa-453a-b7a0-01708063f73e@huawei.com>
 <Z7T4NZAn4wD_DLTl@dread.disaster.area>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <Z7T4NZAn4wD_DLTl@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/2/19 5:14, Dave Chinner wrote:
> On Tue, Feb 18, 2025 at 05:21:27PM +0800, Yunsheng Lin wrote:
>> On 2025/2/18 5:31, Dave Chinner wrote:
>>
>> ...
>>
>>> .....
>>>
>>>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>>>> index 15bb790359f8..9e1ce0ab9c35 100644
>>>> --- a/fs/xfs/xfs_buf.c
>>>> +++ b/fs/xfs/xfs_buf.c
>>>> @@ -377,16 +377,17 @@ xfs_buf_alloc_pages(
>>>>  	 * least one extra page.
>>>>  	 */
>>>>  	for (;;) {
>>>> -		long	last = filled;
>>>> +		long	alloc;
>>>>  
>>>> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
>>>> -					  bp->b_pages);
>>>> +		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
>>>> +					 bp->b_pages + refill);
>>>> +		refill += alloc;
>>>>  		if (filled == bp->b_page_count) {
>>>>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>>>>  			break;
>>>>  		}
>>>>  
>>>> -		if (filled != last)
>>>> +		if (alloc)
>>>>  			continue;
>>>
>>> You didn't even compile this code - refill is not defined
>>> anywhere.
>>>
>>> Even if it did complile, you clearly didn't test it. The logic is
>>> broken (what updates filled?) and will result in the first
>>> allocation attempt succeeding and then falling into an endless retry
>>> loop.
>>
>> Ah, the 'refill' is a typo, it should be 'filled' instead of 'refill'.
>> The below should fix the compile error:
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -379,9 +379,9 @@ xfs_buf_alloc_pages(
>>         for (;;) {
>>                 long    alloc;
>>
>> -               alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
>> -                                        bp->b_pages + refill);
>> -               refill += alloc;
>> +               alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - filled,
>> +                                        bp->b_pages + filled);
>> +               filled += alloc;
>>                 if (filled == bp->b_page_count) {
>>                         XFS_STATS_INC(bp->b_mount, xb_page_found);
>>                         break;
>>
>>>
>>> i.e. you stepped on the API landmine of your own creation where
>>> it is impossible to tell the difference between alloc_pages_bulk()
>>> returning "memory allocation failed, you need to retry" and
>>> it returning "array is full, nothing more to allocate". Both these
>>> cases now return 0.
>>
>> As my understanding, alloc_pages_bulk() will not be called when
>> "array is full" as the above 'filled == bp->b_page_count' checking
>> has ensured that if the array is not passed in with holes in the
>> middle for xfs.
> 
> You miss the point entirely. Previously, alloc_pages_bulk() would
> return a value that would tell us the array is full, even if we
> call it with a full array to begin with.
> 
> Now it fails to tell us that the array is full, and we have to track
> that precisely ourselves - it is impossible to tell the difference
> between "array is full" and "allocation failed". Not being able to
> determine from the allocation return value whether the array is
> ready for use or whether another go-around to fill it is needed is a
> very poor API choice, regardless of anything else.
> 
> You've already demonstrated this: tracking array usage in every
> caller is error-prone and much harder to get right than just having
> alloc_pages_bulk() do everything for us.

While I am agreed that it might be hard to track array usage in every
caller to see if removing assumption of populating only NULL elements
cause problem for them, I still think the page bulk alloc API before
this patch have some space for improvement from performance and
easy-to-use perspective as the most existing calllers of page bulk
alloc API are trying to bulk allocate the page for the whole array
sequentially.

> 
>>> The existing code returns nr_populated in both cases, so it doesn't
>>> matter why alloc_pages_bulk() returns with nr_populated != full, it
>>> is very clear that we still need to allocate more memory to fill it.
>>
>> I am not sure if the array will be passed in with holes in the
>> middle for the xfs fs as mentioned above, if not, it seems to be
>> a typical use case like the one in mempolicy.c as below:
>>
>> https://elixir.bootlin.com/linux/v6.14-rc1/source/mm/mempolicy.c#L2525
> 
> That's not "typical" usage. That is implementing "try alloc" fast
> path that avoids memory reclaim with a slow path fallback to fill
> the rest of the array when the fast path fails.
> 
> No other users of alloc_pages_bulk() is trying to do this.

What I meant by "typical" usage is the 'page_array + nr_allocated'
trick that avoids the NULL checking when page bulk allocation API
is used in mm/mempolicy.c, most of existing callers for page bulk
allocation in other places seems likely to be changed to do the
similar trick as this patch does.

> 
> Indeed, it looks somewhat pointless to do this here (i.e. premature
> optimisation!), because the only caller of
> alloc_pages_bulk_mempolicy_noprof() has it's own fallback slowpath
> for when alloc_pages_bulk() can't fill the entire request.
> 
>>> IOWs, you just demonstrated why the existing API is more desirable
>>> than a highly constrained, slightly faster API that requires callers
>>> to get every detail right. i.e. it's hard to get it wrong with the
>>> existing API, yet it's so easy to make mistakes with the proposed
>>> API that the patch proposing the change has serious bugs in it.
>>
>> IMHO, if the API is about refilling pages for the only NULL elements,
>> it seems better to add a API like refill_pages_bulk() for that, as
>> the current API seems to be prone to error of not initializing the
>> array to zero before calling alloc_pages_bulk().
> 
> How is requiring a well defined initial state for API parameters
> "error prone"?  What code is failing to do the well known, defined
> initialisation before calling alloc_pages_bulk()?
> 
> Allowing uninitialised structures in an API (i.e. unknown initial
> conditions) means we cannot make assumptions about the structure
> contents within the API implementation.  We cannot assume that all
> variables are zero on the first use, nor can we assume that anything
> that is zero has a valid state.

It seems the above is the main differenece we see from the API perspective,
as I see the array as output parameter and you seems to treat the array as
both input and output parameter?

The kmem_cache_alloc_bulk() API related API seems to treat the array as
output parameter too as this patch does, the difference from this patch
is that if there is no enough memory, it will free the allocated memory
and return 0 to the caller while this patch returns already allocated
memory to its caller even when there is no enough memory.

> 
> Again, this is poor API design - structures passed to interfaces
> -should- have a well defined initial state, either set by a *_init()
> function or by defining the initial state to be all zeros (i.e. via
> memset, kzalloc, etc).
> 
> Performance and speed is not an excuse for writing fragile, easy to
> break code and APIs.
> 
> -Dave.

