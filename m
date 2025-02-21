Return-Path: <kvm+bounces-38840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC839A3F065
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 10:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8C697AB375
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 09:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30ECD204C37;
	Fri, 21 Feb 2025 09:34:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFBD2045BC;
	Fri, 21 Feb 2025 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740130475; cv=none; b=nkn5hnSjvnb1hnRAD/aQEN5qR+Sl0X80VAslbPS4y4el6CvUu9wJ/BtRzeVCUw59TD9+PPr2SSzcwqkpLtxF3m0f8ThvfhyIUxK64PFI5d/9OhtMq6BAUwEpFzFV3TAdCVT8QiYcm/SIzZCkAEMswIKhba583JUjU9fVDwF2yko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740130475; c=relaxed/simple;
	bh=UrE4zNeA6rGUajNEitvvWzIh6MglysOpeI2P5JxANP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WU55k9ffti/1mCydPUJ82xGOQpXMrMkL5tnQreBqwBJyw/yr5pNBA/VfG6kTwdGxpgmd+hwh+OoTse7BVfPFREkMsWM7KmPnya/X3cLlI1v7OoD4ttF1EeXO8+KXe9RXjdijPcO5BNcAROYNCi1I7irotd+LMukh7XNENgOq3mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YzlG03WHwzdb9B;
	Fri, 21 Feb 2025 17:29:44 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 57A03140158;
	Fri, 21 Feb 2025 17:34:23 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Feb 2025 17:34:22 +0800
Message-ID: <e55e4dd4-9f80-4b2b-a84e-4bcfa4cf40be@huawei.com>
Date: Fri, 21 Feb 2025 17:34:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: alloc_pages_bulk: remove assumption of populating only
 NULL elements
To: Chuck Lever <chuck.lever@oracle.com>, Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
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
	<anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>
CC: Luiz Capitulino <luizcap@redhat.com>, Mel Gorman
	<mgorman@techsingularity.net>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-xfs@vger.kernel.org>, <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>
References: <20250217123127.3674033-1-linyunsheng@huawei.com>
 <abc3ae0b-620a-4e4a-8dd8-f8e7d3764b3a@oracle.com>
 <cc6fc730-e5f4-485b-b0b6-ec70374b3ab1@huawei.com>
 <7b7492c0-a3a7-470b-b7aa-697ac790a94b@oracle.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <7b7492c0-a3a7-470b-b7aa-697ac790a94b@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/2/18 22:17, Chuck Lever wrote:
> On 2/18/25 4:16 AM, Yunsheng Lin wrote:
>> On 2025/2/17 22:20, Chuck Lever wrote:
>>> On 2/17/25 7:31 AM, Yunsheng Lin wrote:
>>>> As mentioned in [1], it seems odd to check NULL elements in
>>>> the middle of page bulk allocating,
>>>
>>> I think I requested that check to be added to the bulk page allocator.
>>>
>>> When sending an RPC reply, NFSD might release pages in the middle of
>>
>> It seems there is no usage of the page bulk allocation API in fs/nfsd/
>> or fs/nfs/, which specific fs the above 'NFSD' is referring to?
> 
> NFSD is in fs/nfsd/, and it is the major consumer of
> net/sunrpc/svc_xprt.c.
> 
> 
>>> the rq_pages array, marking each of those array entries with a NULL
>>> pointer. We want to ensure that the array is refilled completely in this
>>> case.
>>>
>>
>> I did some researching, it seems you requested that in [1]?
>> It seems the 'holes are always at the start' for the case in that
>> discussion too, I am not sure if the case is referring to the caller
>> in net/sunrpc/svc_xprt.c? If yes, it seems caller can do a better
>> job of bulk allocating pages into a whole array sequentially without
>> checking NULL elements first before doing the page bulk allocation
>> as something below:
>>
>> +++ b/net/sunrpc/svc_xprt.c
>> @@ -663,9 +663,10 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>>                 pages = RPCSVC_MAXPAGES;
>>         }
>>
>> -       for (filled = 0; filled < pages; filled = ret) {
>> -               ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
>> -               if (ret > filled)
>> +       for (filled = 0; filled < pages; filled += ret) {
>> +               ret = alloc_pages_bulk(GFP_KERNEL, pages - filled,
>> +                                      rqstp->rq_pages + filled);
>> +               if (ret)
>>                         /* Made progress, don't sleep yet */
>>                         continue;
>>
>> @@ -674,7 +675,7 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>>                         set_current_state(TASK_RUNNING);
>>                         return false;
>>                 }
>> -               trace_svc_alloc_arg_err(pages, ret);
>> +               trace_svc_alloc_arg_err(pages, filled);
>>                 memalloc_retry_wait(GFP_KERNEL);
>>         }
>>         rqstp->rq_page_end = &rqstp->rq_pages[pages];
>>
>>
>> 1. https://lkml.iu.edu/hypermail/linux/kernel/2103.2/09060.html
> 
> I still don't see what is broken about the current API.

As mentioned in [1], the page bulk alloc API before this patch may
have some space for improvement from performance and easy-to-use
perspective as the most existing calllers of page bulk alloc API
are trying to bulk allocate the page for the whole array sequentially.

1. https://lore.kernel.org/all/c9950a79-7bcb-41c2-a59e-af315dc6d7ff@huawei.com/

> 
> Anyway, any changes in svc_alloc_arg() will need to be run through the
> upstream NFSD CI suite before they are merged.

Is there any web link pointing to the above NFSD CI suite, so that I can
test it if removing assumption of populating only NULL elements is indeed
possible?

Look more closely, it seems svc_rqst_release_pages()/svc_rdma_save_io_pages()
does set rqstp->rq_respages[i] to NULL based on rqstp->rq_next_page,
and the original code before using the page bulk alloc API does seem to only
allocate page for NULL elements as can see from the below patch：
https://lore.kernel.org/all/20210325114228.27719-8-mgorman@techsingularity.net/T/#u

The clearing of rqstp->rq_respages[] to NULL does seems sequentially, is it
possible to only pass NULL elements in rqstp->rq_respages[] to alloc_pages_bulk()
so that bulk alloc API does not have to do the NULL checking and use the array only
as output parameter?

> 
> 

