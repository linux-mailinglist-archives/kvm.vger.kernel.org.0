Return-Path: <kvm+bounces-38411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B24A396F0
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B3BF169FA7
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60FD23496F;
	Tue, 18 Feb 2025 09:21:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1F422FE0C;
	Tue, 18 Feb 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870496; cv=none; b=qtC2F061rk0OpIfBU2JYml89nsoNSG5JX56M6Q3TN0dd9BHUUCOpQr/ynwD9QdnrYPxbkyZdIBEZzrneu9pd7FWgyc7Yy3STd7a+GjdaePq4BOrq5iwIbbeIvugdtW1tmCuReJdeNLyG1nxWiFk0eEwtf2QG2TPvkcj54dBhycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870496; c=relaxed/simple;
	bh=CzZAcJv9dbjAo8bjJjXHZhCE9Q36XfB/XgaktEm5Lwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bd/GrqhmVsgagw68BMamOEWqNu/GMNjInS9xi5BewTRB/8VM7NZiqyGZntIYi+x5JBL2OqfSNB3b4/NTR9Jb67QyWFZAJr5gvnsDFRE8/nIkeY0mo6pK0dumKv79Pgi3D1Vm9EweKuWupVJ15vRmKhwj93/m0Yr+guyc4o/Jm1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Yxv7P5668z1wn7M;
	Tue, 18 Feb 2025 17:17:37 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id B723E1A016C;
	Tue, 18 Feb 2025 17:21:31 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Feb 2025 17:21:27 +0800
Message-ID: <cf270a65-c9fa-453a-b7a0-01708063f73e@huawei.com>
Date: Tue, 18 Feb 2025 17:21:27 +0800
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
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <Z7Oqy2j4xew7FW9Z@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/2/18 5:31, Dave Chinner wrote:

...

> .....
> 
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 15bb790359f8..9e1ce0ab9c35 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -377,16 +377,17 @@ xfs_buf_alloc_pages(
>>  	 * least one extra page.
>>  	 */
>>  	for (;;) {
>> -		long	last = filled;
>> +		long	alloc;
>>  
>> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
>> -					  bp->b_pages);
>> +		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
>> +					 bp->b_pages + refill);
>> +		refill += alloc;
>>  		if (filled == bp->b_page_count) {
>>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>>  			break;
>>  		}
>>  
>> -		if (filled != last)
>> +		if (alloc)
>>  			continue;
> 
> You didn't even compile this code - refill is not defined
> anywhere.
> 
> Even if it did complile, you clearly didn't test it. The logic is
> broken (what updates filled?) and will result in the first
> allocation attempt succeeding and then falling into an endless retry
> loop.

Ah, the 'refill' is a typo, it should be 'filled' instead of 'refill'.
The below should fix the compile error:
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -379,9 +379,9 @@ xfs_buf_alloc_pages(
        for (;;) {
                long    alloc;

-               alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
-                                        bp->b_pages + refill);
-               refill += alloc;
+               alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - filled,
+                                        bp->b_pages + filled);
+               filled += alloc;
                if (filled == bp->b_page_count) {
                        XFS_STATS_INC(bp->b_mount, xb_page_found);
                        break;

> 
> i.e. you stepped on the API landmine of your own creation where
> it is impossible to tell the difference between alloc_pages_bulk()
> returning "memory allocation failed, you need to retry" and
> it returning "array is full, nothing more to allocate". Both these
> cases now return 0.

As my understanding, alloc_pages_bulk() will not be called when
"array is full" as the above 'filled == bp->b_page_count' checking
has ensured that if the array is not passed in with holes in the
middle for xfs.

> 
> The existing code returns nr_populated in both cases, so it doesn't
> matter why alloc_pages_bulk() returns with nr_populated != full, it
> is very clear that we still need to allocate more memory to fill it.

I am not sure if the array will be passed in with holes in the
middle for the xfs fs as mentioned above, if not, it seems to be
a typical use case like the one in mempolicy.c as below:

https://elixir.bootlin.com/linux/v6.14-rc1/source/mm/mempolicy.c#L2525

> 
> The whole point of the existing API is to prevent callers from
> making stupid, hard to spot logic mistakes like this. Forcing
> callers to track both empty slots and how full the array is itself,
> whilst also constraining where in the array empty slots can occur
> greatly reduces both the safety and functionality that
> alloc_pages_bulk() provides. Anyone that has code that wants to
> steal a random page from the array and then refill it now has a heap
> more complex code to add to their allocator wrapper.

Yes, I am agreed that it might be better to provide a common API or
wrapper if there is some clear use case that need to pass in an array
with holes in the middle by adding a new API like refill_pages_bulk()
as below.

> 
> IOWs, you just demonstrated why the existing API is more desirable
> than a highly constrained, slightly faster API that requires callers
> to get every detail right. i.e. it's hard to get it wrong with the
> existing API, yet it's so easy to make mistakes with the proposed
> API that the patch proposing the change has serious bugs in it.

IMHO, if the API is about refilling pages for the only NULL elements,
it seems better to add a API like refill_pages_bulk() for that, as
the current API seems to be prone to error of not initializing the
array to zero before calling alloc_pages_bulk().

> 
> -Dave.

