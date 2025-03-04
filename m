Return-Path: <kvm+bounces-40017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFD2A4DD6F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D34A03A461B
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE0620296C;
	Tue,  4 Mar 2025 12:04:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF101FAC50;
	Tue,  4 Mar 2025 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741089855; cv=none; b=ZA06hb44Am6/O/KsheMZyDQ2FdP+l4hx3dTR+RLvwd/HcUo2pkyppvZ/EDZOp6haovVTNR6lzQadB75vGoj+tolvcDrlQDOhIqdf9OZ3Onya0xcplb8Ezxtix9BDhL0p3NpRIIENUBRUKlIuJFdaTYnY2byQswrV6BfzgKAA5g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741089855; c=relaxed/simple;
	bh=u3ffzOOdDBdX+c9H5UtwM0oUgiysJs5s7b+QstcanWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YEfIO/LSWwnmhWpYm347NCz30txeg+murAYlouY9lPo0GELMDlN4LIBYUo2SyajGD4yi2XIjXg6TOeBO6Ly3HOYvJvbg7sgItFlrU+BRu1NDf/fUZ7zMzpCLI3Muz638oAsF+Q8T7d5ILRkZOnZ9whlfq13xrDU1WkiIpAV6s5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Z6Z4d0yVCzvWqQ;
	Tue,  4 Mar 2025 20:00:17 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 37B6C180116;
	Tue,  4 Mar 2025 20:04:04 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Mar 2025 20:04:03 +0800
Message-ID: <74827bc7-ec6e-4e3a-9d19-61c4a9ba6b2c@huawei.com>
Date: Tue, 4 Mar 2025 20:04:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
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
	<mgorman@techsingularity.net>, Dave Chinner <david@fromorbit.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-xfs@vger.kernel.org>,
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <a81f9270-8fa8-4a05-a33a-901dd777a71f@oracle.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <a81f9270-8fa8-4a05-a33a-901dd777a71f@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/4 6:13, Chuck Lever wrote:
> On 2/28/25 4:44 AM, Yunsheng Lin wrote:
>> As mentioned in [1], it seems odd to check NULL elements in
>> the middle of page bulk allocating, and it seems caller can
>> do a better job of bulk allocating pages into a whole array
>> sequentially without checking NULL elements first before
>> doing the page bulk allocation for most of existing users.
> 
> Sorry, but this still makes a claim without providing any data
> to back it up. Why can callers "do a better job"?

What I meant "do a better job" is that callers are already keeping
track of how many pages have been allocated, and it seems convenient
to just pass 'page_array + nr_allocated' and 'nr_pages - nr_allocated'
when calling subsequent page bulk alloc API so that NULL checking
can be avoided, which seems to be the pattern I see in
alloc_pages_bulk_interleave().

> 
> 
>> Through analyzing of bulk allocation API used in fs, it
>> seems that the callers are depending on the assumption of
>> populating only NULL elements in fs/btrfs/extent_io.c and
>> net/sunrpc/svc_xprt.c while erofs and btrfs don't, see:
>> commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")
>> commit d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
>> commit c9fa563072e1 ("xfs: use alloc_pages_bulk_array() for buffers")
>> commit f6e70aab9dfe ("SUNRPC: refresh rq_pages using a bulk page allocator")
>>
>> Change SUNRPC and btrfs to not depend on the assumption.
>> Other existing callers seems to be passing all NULL elements
>> via memset, kzalloc, etc.
>>
>> Remove assumption of populating only NULL elements and treat
>> page_array as output parameter like kmem_cache_alloc_bulk().
>> Remove the above assumption also enable the caller to not
>> zero the array before calling the page bulk allocating API,
>> which has about 1~2 ns performance improvement for the test
>> case of time_bench_page_pool03_slow() for page_pool in a
>> x86 vm system, this reduces some performance impact of
>> fixing the DMA API misuse problem in [2], performance
>> improves from 87.886 ns to 86.429 ns.
>>
>> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
>> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
>> CC: Jesper Dangaard Brouer <hawk@kernel.org>
>> CC: Luiz Capitulino <luizcap@redhat.com>
>> CC: Mel Gorman <mgorman@techsingularity.net>
>> CC: Dave Chinner <david@fromorbit.com>
>> CC: Chuck Lever <chuck.lever@oracle.com>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Acked-by: Jeff Layton <jlayton@kernel.org>
>> ---
>> V2:
>> 1. Drop RFC tag and rebased on latest linux-next.
>> 2. Fix a compile error for xfs.
>> 3. Defragmemt the page_array for SUNRPC and btrfs.
>> ---
>>  drivers/vfio/pci/virtio/migrate.c |  2 --
>>  fs/btrfs/extent_io.c              | 23 +++++++++++++++++-----
>>  fs/erofs/zutil.c                  | 12 ++++++------
>>  fs/xfs/xfs_buf.c                  |  9 +++++----
>>  mm/page_alloc.c                   | 32 +++++--------------------------
>>  net/core/page_pool.c              |  3 ---
>>  net/sunrpc/svc_xprt.c             | 22 +++++++++++++++++----
>>  7 files changed, 52 insertions(+), 51 deletions(-)
> 
> 52:51 is not an improvement. 1-2 ns is barely worth mentioning. The
> sunrpc and btrfs callers are more complex and carry duplicated code.

Yes, the hard part is to find common file to place the common function
as something as below:

void defragment_pointer_array(void** array, int size) {
    int slow = 0;
    for (int fast = 0; fast < size; fast++) {
        if (array[fast] != NULL) {
            swap(&array[fast], &array[slow]);
            slow++;
        }
    }
}

Or introduce a function as something like alloc_pages_refill_array()
for the usecase of sunrpc and xfs and do the array defragment in
alloc_pages_refill_array() before calling alloc_pages_bulk()?
Any suggestion?

> 
> Not an outright objection from me, but it's hard to justify this change.

The above should reduce the number to something like 40:51.

Also, I looked more closely at other callers calling alloc_pages_bulk(),
it seems vm_module_tags_populate() doesn't clear next_page[i] to NULL after
__free_page() when doing 'Clean up and error out', I am not sure if
vm_module_tags_populate() will be called multi-times as vm_module_tags->pages
seems to be only set to all NULL once, see alloc_tag_init() -> alloc_mod_tags_mem().

Cc Suren to see if there is some clarifying for the above.

