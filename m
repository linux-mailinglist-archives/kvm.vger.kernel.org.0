Return-Path: <kvm+bounces-40155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4685A4FE7C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 13:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 391B53A8B64
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 12:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0E9245036;
	Wed,  5 Mar 2025 12:18:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF6124060E;
	Wed,  5 Mar 2025 12:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741177087; cv=none; b=c1bs5X++ttFZ/kLWfx+WW214F97aNWDYjr+QABetDrvpk1KtUYchlnSv0sh/DHSEBCJjnc5vr7IcKS4RI8NFcYidjzAlS3RbV/9t2H08C6+eGHuUy19sFmhNT9XG5itRZz3xZNp/61+8SIjP+gPwWV70limnnuFFgSZqd1duxA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741177087; c=relaxed/simple;
	bh=2l5BK6BIIKBvzAzekAB/HIgAAJ8CjsnHPnqO0JmxTPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mneCjGiyBBkRT4YXOP7GgmqH1CyK2BOGPAozwoqv2Ev+bifhrZnymFbpeetyv9KzOjz8VZcz+ib70nf2IoiKSxC0IjY7Q5ynr/x6pwsL0RVPjmwip8dNttQxvfn9Q15AWHLpckiYpDZrUNlLhSJE0muGgUzdZq8Z5dxvs9kV2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Z7BJz4R0yzwWy8;
	Wed,  5 Mar 2025 20:13:07 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 2AA2318009E;
	Wed,  5 Mar 2025 20:18:02 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Mar 2025 20:17:59 +0800
Message-ID: <18c68e7a-88c9-49d1-8ff8-17c63bcc44f4@huawei.com>
Date: Wed, 5 Mar 2025 20:17:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Qu Wenruo <wqu@suse.com>, Yishai Hadas <yishaih@nvidia.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>, Josef
 Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Gao Xiang
	<xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
	<anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
	<jlayton@kernel.org>, Neil Brown <neilb@suse.de>, Olga Kornievskaia
	<okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>
CC: Luiz Capitulino <luizcap@redhat.com>, Mel Gorman
	<mgorman@techsingularity.net>, Dave Chinner <david@fromorbit.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-xfs@vger.kernel.org>,
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <6f4017dc-2b3d-4b1a-b819-423acb42d999@suse.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <6f4017dc-2b3d-4b1a-b819-423acb42d999@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/4 17:17, Qu Wenruo wrote:
> 
> 
> 在 2025/2/28 20:14, Yunsheng Lin 写道:
>> As mentioned in [1], it seems odd to check NULL elements in
>> the middle of page bulk allocating, and it seems caller can
>> do a better job of bulk allocating pages into a whole array
>> sequentially without checking NULL elements first before
>> doing the page bulk allocation for most of existing users.
>>
>> Through analyzing of bulk allocation API used in fs, it
>> seems that the callers are depending on the assumption of
>> populating only NULL elements in fs/btrfs/extent_io.c and
>> net/sunrpc/svc_xprt.c while erofs and btrfs don't, see:

I should have said 'while erofs and xfs don't depend on the
assumption of populating only NULL elements'.

>> commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")
> 
> If you want to change the btrfs part, please run full fstests with SCRATCH_DEV_POOL populated at least.

The above is a helpful suggestion/comment to someone like me, who
is not very familiar with fs yet, thanks for the suggestion.

But I am not sure about some of the other comments below.

> 
> [...]
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index f0a1da40d641..ef52cedd9873 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -623,13 +623,26 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
>>                  bool nofail)
>>   {
>>       const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
>> -    unsigned int allocated;
>> +    unsigned int allocated, ret;
>>   -    for (allocated = 0; allocated < nr_pages;) {
>> -        unsigned int last = allocated;
>> +    /* Defragment page_array so pages can be bulk allocated into remaining
>> +     * NULL elements sequentially.
>> +     */
>> +    for (allocated = 0, ret = 0; ret < nr_pages; ret++) {
>> +        if (page_array[ret]) {
> 
> You just prove how bad the design is.
> 

Below is the reason you think the design is bad? If not, it would be
good to be more specific about why it is a bad design.

> All the callers have their page array members to initialized to NULL, or do not care and just want alloc_pages_bulk() to overwrite the uninitialized values.

Actually there are two use cases here as mentioned in the commit log:
1. Allocating an array of pages sequentially by providing an array as
   output parameter.
2. Refilling pages to NULL elements in an array by providing an array
   as both input and output parameter.

Most of users calling the bulk alloc API is allocating an array of pages
sequentially except btrfs and sunrpc, the current page bulk alloc API
implementation is not only doing the unnecessay NULL checking for most
users, but also require most of its callers to pass all NULL array via
memset, kzalloc, etc, which is also unnecessary overhead.

That means there is some space for improvement from performance and
easy-to-use perspective for most existing use cases here, this patch
just change alloc_pages_bulk() API to treat the page_array as only
the output parameter by mirroring kmem_cache_alloc_bulk() API.

For the existing btrfs and sunrpc case, I am agreed that there
might be valid use cases too, we just need to discuss how to
meet the requirements of different use cases using simpler, more
unified and effective APIs.

> 
> The best example here is btrfs_encoded_read_regular().
> Now your code will just crash encoded read.

It would be good to be more specific about the 'crash' here,
as simple testing mentioned in below seems fine for btrfs fs
too, but I will do more testing by running full fstests with
SCRATCH_DEV_POOL populated after I learn how to use the fstests.

https://lore.kernel.org/all/91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com/

> 
> Read the context before doing stupid things.
> 
> I find it unacceptable that you just change the code, without any testing, nor even just check all the involved callers.

What exactly is the above 'context' is referring to? If it is a good advice,
I think I will take it seriously.

May I suggest that it might be better to be more humble and discuss
more before jumpping to conclusion here as it seems hard for one
person to be familiar with all the subsystem in the kernel?

> 
>> +            page_array[allocated] = page_array[ret];
>> +            if (ret != allocated)
>> +                page_array[ret] = NULL;
>> +
>> +            allocated++;
>> +        }
>> +    }
>>   -        allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
>> -        if (unlikely(allocated == last)) {
>> +    while (allocated < nr_pages) {
>> +        ret = alloc_pages_bulk(gfp, nr_pages - allocated,
>> +                       page_array + allocated);
> 
> I see the new interface way worse than the existing one.
> 
> All btrfs usage only wants a simple retry-until-all-fulfilled behavior.

As above, I am agreed that the above might be what btrfs usage want, so
let's discuss how to meet the requirements of different use cases using
simpler, more unified and effective API, like introducing a function like
alloc_pages_refill_array() to meet the above requirement as mentioned in
below?
https://lore.kernel.org/all/74827bc7-ec6e-4e3a-9d19-61c4a9ba6b2c@huawei.com/

> 
> NACK for btrfs part, and I find you very unresponsible not even bother running any testsuit and just submit such a mess.
> 
> Just stop this, no one will ever take you serious anymore.
> 
> Thanks,
> Qu
> 
> 

