Return-Path: <kvm+bounces-40324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CF3A56423
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 10:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE72B188E72A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCCB20C033;
	Fri,  7 Mar 2025 09:41:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5641A8F97;
	Fri,  7 Mar 2025 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741340492; cv=none; b=RFG9b4k9da65RdauouB8ggfGXSpYMBkXElxRz/hEssRaKo/JziAxOSuhWXb6IylxfhYN1u49VLuWw9XYaoOwBR6Xh/Ai2L0yuobU5jcsfv4qzwOz1EOcmkcib6mD6MHhnl95lPbb+53D3zP7CFzWUzwhpqUmmunsXiC1Ks2LcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741340492; c=relaxed/simple;
	bh=sHnV9GEozz+Opv61zRjqJ4zv0AEgNaF9oXU1zOBaCs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ndrwAd1fq7Tsl7riwMoA7E/TYOw/91KKBiHw8TrW5ntAe3r89CEiJrCIsb2RaPziauW74h0qYI1CJ1ZwluBRT7mHQ/B3XozrtKFfms8QfQ9/P+ZkjxsjWd5RjR3UMDbrVSDB2uEAReCvP3Wk0J9vcoiKQmHtrXChmT4NvNW29k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Z8LQ532WYz1R6Dn;
	Fri,  7 Mar 2025 17:21:33 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 59CC61402CE;
	Fri,  7 Mar 2025 17:23:12 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Mar 2025 17:23:11 +0800
Message-ID: <180818a1-b906-4a0b-89d3-34cb71cc26c9@huawei.com>
Date: Fri, 7 Mar 2025 17:23:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: NeilBrown <neilb@suse.de>
CC: Qu Wenruo <wqu@suse.com>, Yishai Hadas <yishaih@nvidia.com>, Jason
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
	<jlayton@kernel.org>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Luiz Capitulino
	<luizcap@redhat.com>, Mel Gorman <mgorman@techsingularity.net>, Dave Chinner
	<david@fromorbit.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-xfs@vger.kernel.org>, <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>
References: <> <f834a7cd-ca0a-4495-a787-134810aa0e4d@huawei.com>
 <174129565467.33508.7106343513316364028@noble.neil.brown.name>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <174129565467.33508.7106343513316364028@noble.neil.brown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/7 5:14, NeilBrown wrote:
> On Thu, 06 Mar 2025, Yunsheng Lin wrote:
>> On 2025/3/6 7:41, NeilBrown wrote:
>>> On Wed, 05 Mar 2025, Yunsheng Lin wrote:
>>>>
>>>> For the existing btrfs and sunrpc case, I am agreed that there
>>>> might be valid use cases too, we just need to discuss how to
>>>> meet the requirements of different use cases using simpler, more
>>>> unified and effective APIs.
>>>
>>> We don't need "more unified".
>>
>> What I meant about 'more unified' is how to avoid duplicated code as
>> much as possible for two different interfaces with similar‌ functionality.
>>
>> The best way I tried to avoid duplicated code as much as possible is
>> to defragment the page_array before calling the alloc_pages_bulk()
>> for the use case of btrfs and sunrpc so that alloc_pages_bulk() can
>> be removed of the assumption populating only NULL elements, so that
>> the API is simpler and more efficient.
>>
>>>
>>> If there are genuinely two different use cases with clearly different
>>> needs - even if only slightly different - then it is acceptable to have
>>> two different interfaces.  Be sure to choose names which emphasise the
>>> differences.
>>
>> The best name I can come up with for the use case of btrfs and sunrpc
>> is something like alloc_pages_bulk_refill(), any better suggestion about
>> the naming?
> 
> I think alloc_pages_bulk_refill() is a good name.
> 
> So:
> - alloc_pages_bulk() would be given an uninitialised array of page
>   pointers and a required count and would return the number of pages
>   that were allocated
> - alloc_pages_bulk_refill() would be given an initialised array of page
>   pointers some of which might be NULL.  It would attempt to allocate
>   pages for the non-NULL pointers and return the total number of

You meant 'NULL pointers' instead of 'non-NULL pointers' above?

>   allocated pages in the array - just like the current
>   alloc_pages_bulk().

I guess 'the total number of allocated pages in the array ' include
the pages which are already in the array before calling the above
API?

I guess it is worth mentioning that the current alloc_pages_bulk()
may return different value with the same size of arrays, but with
different layout of the same number of NULL pointers.
For the same size of arrays with different layout for the NULL pointer
below('*' indicate NULL pointer), and suppose buddy allocator is only
able to allocate two pages:
1. P**P*P: will return 4.
2. P*PP**: will return 5.

If the new API do the page defragmentation, then it will always return
the same value for different layout of the same number of NULL pointers.
I guess the new one is the more perfered behavior as it provides a more
defined semantic.

> 
> sunrpc could usefully use both of these interfaces.
> 
> alloc_pages_bulk() could be implemented by initialising the array and
> then calling alloc_pages_bulk_refill().  Or alloc_pages_bulk_refill()
> could be implemented by compacting the pages and then calling
> alloc_pages_bulk().
> If we could duplicate the code and have two similar but different
> functions.
> 
> The documentation for _refill() should make it clear that the pages
> might get re-ordered.

Does 'the pages might get re-ordered' mean defragmenting the page_array?
If yes, it makes sense to make it clear.

> 
> Having looked at some of the callers I agree that the current interface
> is not ideal for many of them, and that providing a simpler interface
> would help.

+1

> 
> Thanks,
> NeilBrown

