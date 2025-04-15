Return-Path: <kvm+bounces-43347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1FBA89E7B
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 14:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C5F3B048F
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 12:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46EC9296D39;
	Tue, 15 Apr 2025 12:45:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BBE22F01;
	Tue, 15 Apr 2025 12:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744721135; cv=none; b=k6Jv4qJlj/MS2pLlC5OXiy3zxpZ/GMsVEbCYaIFlHPkVembEYIh3k2JYKL+uS3lzfNFWa6gjdRTCtdKPITKePTrTPaHxd8OoDi8NUgmLiLD24I/GPa4rh6dCj8hFhYDnPCRAtaRNos26ItgJghFgxF2fSRYrIr1MboICrGe5LcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744721135; c=relaxed/simple;
	bh=E5XQcw4IEaB0LKYRVD7ZDLH2kh1PfwrDrSF+4CKaanw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DGsijTsC2fBPEP2QGzcylRWKtPJpNFCAVqonJXR2YlUvg0iTmktJBv7Xbqd8VEPvs8J7fgbu9zyBv8XyNcbq+no5o0lOeD5OrYjfI6id9B1KE/ZTveWWkbarE3kFYPkHzRZg1aj0XpIJdURkCcDZWCk/MkL+clG8YUEc9OwMbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZcP374bdHz1R7gs;
	Tue, 15 Apr 2025 20:43:31 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id D4EBE1A016C;
	Tue, 15 Apr 2025 20:45:27 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Apr 2025 20:45:27 +0800
Message-ID: <28772dbe-1ae9-4ff7-91ef-c45d174b88d6@huawei.com>
Date: Tue, 15 Apr 2025 20:45:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: alloc_pages_bulk: support both simple and
 full-featured API
To: Chuck Lever <chuck.lever@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, Yishai Hadas <yishaih@nvidia.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>, Josef
 Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Gao Xiang
	<xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
	Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>, Olga
 Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong
 Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo
	<haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
	<anna@kernel.org>
CC: Luiz Capitulino <luizcap@redhat.com>, Mel Gorman
	<mgorman@techsingularity.net>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-mm@kvack.org>, <linux-nfs@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
	<netdev@vger.kernel.org>
References: <20250414120819.3053967-1-linyunsheng@huawei.com>
 <18713073-342e-48b2-9864-24004445e234@oracle.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <18713073-342e-48b2-9864-24004445e234@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/4/15 1:39, Chuck Lever wrote:
> On 4/14/25 8:08 AM, Yunsheng Lin wrote:
>> As mentioned in [1], it seems odd to check NULL elements in
>> the middle of page bulk allocating, and it seems caller can
>> do a better job of bulk allocating pages into a whole array
>> sequentially without checking NULL elements first before
>> doing the page bulk allocation for most of existing users
>> by passing 'page_array + allocated' and 'nr_pages - allocated'
>> when calling subsequent page bulk alloc API so that NULL
>> checking can be avoided, see the pattern in mm/mempolicy.c.
>>
>> Through analyzing of existing bulk allocation API users, it
>> seems only the fs users are depending on the assumption of
>> populating only NULL elements, see:
>> commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")
>> commit d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
>> commit f6e70aab9dfe ("SUNRPC: refresh rq_pages using a bulk page allocator")
>> commit 88e4d41a264d ("SUNRPC: Use __alloc_bulk_pages() in svc_init_buffer()")
>>
>> The current API adds a mental burden for most users. For most
>> users, their code would be much cleaner if the interface accepts
>> an uninitialised array with length, and were told how many pages
>> had been stored in that array, so support one simple and one
>> full-featured to meet the above different use cases as below:
>> - alloc_pages_bulk() would be given an uninitialised array of page
>>   pointers and a required count and would return the number of
>>   pages that were allocated.
>> - alloc_pages_bulk_refill() would be given an initialised array
>>   of page pointers some of which might be NULL. It would attempt
>>   to allocate pages for the non-NULL pointers, return 0 if all
>>   pages are allocated, -EAGAIN if at least one page allocated,
>>   ok to try again immediately or -ENOMEM if don't bother trying
>>   again soon, which provides a more consistent semantics than the
>>   current API as mentioned in [2], at the cost of the pages might
>>   be getting re-ordered to make the implementation simpler.
>>
>> Change the existing fs users to use the full-featured API, except
>> for the one for svc_init_buffer() in net/sunrpc/svc.c. Other
>> existing callers can use the simple API as they seems to be passing
>> all NULL elements via memset, kzalloc, etc, only remove unnecessary
>> memset for existing users calling the simple API in this patch.
>>
>> The test result for xfstests full test:
>> Before this patch:
>> btrfs/default: 1061 tests, 3 failures, 290 skipped, 13152 seconds
>>   Failures: btrfs/012 btrfs/226
>>   Flaky: generic/301: 60% (3/5)
>> Totals: 1073 tests, 290 skipped, 13 failures, 0 errors, 12540s
>>
>> nfs/loopback: 530 tests, 3 failures, 392 skipped, 3942 seconds
>>   Failures: generic/464 generic/551
>>   Flaky: generic/650: 40% (2/5)
>> Totals: 542 tests, 392 skipped, 12 failures, 0 errors, 3799s
>>
>> After this patch:
>> btrfs/default: 1061 tests, 2 failures, 290 skipped, 13446 seconds
>>   Failures: btrfs/012 btrfs/226
>> Totals: 1069 tests, 290 skipped, 10 failures, 0 errors, 12853s
>>
>> nfs/loopback: 530 tests, 3 failures, 392 skipped, 4103 seconds
>>   Failures: generic/464 generic/551
>>   Flaky: generic/650: 60% (3/5)
>> Totals: 542 tests, 392 skipped, 13 failures, 0 errors, 3933s
> 
> Hi -
> 
> The "after" run for NFS took longer, and not by a little bit. Can you
> explain the difference?

Ah, I overlooked the difference as I was not looking to have a performance
comparasion using xfstest full test due to possible noise, so the above test
might be done with other job like kernel compiling behind the scenes as it
was tested with the same machine where I was doing some kernel compiling.

And I used a temporary patch to enable the using of full-featured API in
page_pool to test if the full-featured API will cause performance regression
for the existing users in fs as mentioned at the end of commit log.

> 
> You can expunge the flakey test (generic/650) to help make the results
> more directly comparable. 650 is a CPU hot-plugging test.

I retested in a newer and more powerful machine without obvious heavy job
behind the scenes based on linux-next-20250411, and the flakey test seems
gone too.

before:
-------------------- Summary report
KERNEL:    kernel 6.15.0-rc1-next-20250411-xfstests #369 SMP PREEMPT_DYNAMIC Tue Apr 15 16:17:08 CST 2025 x86_64
CMDLINE:   full
CPUS:      2
MEM:       1972.54

nfs/loopback: 539 tests, 4 failures, 400 skipped, 2364 seconds
  Failures: generic/169 generic/363 generic/464 generic/551
Totals: 555 tests, 400 skipped, 20 failures, 0 errors, 2205s

after:
-------------------- Summary report
KERNEL:    kernel 6.15.0-rc1-next-20250411-xfstests-00001-g316d17a7f7bb #370 SMP PREEMPT_DYNAMIC Tue Apr 15 19:57:48 CST 2025 x86_64
CMDLINE:   full
CPUS:      2
MEM:       1972.54

nfs/loopback: 539 tests, 4 failures, 400 skipped, 2327 seconds
  Failures: generic/169 generic/363 generic/464 generic/551
Totals: 555 tests, 400 skipped, 20 failures, 0 errors, 2148s

> 
> 
>> The stress test also suggest there is no regression for the erofs
>> too.
>>
>> Using the simple API also enable the caller to not zero the array
>> before calling the page bulk allocating API, which has about 1~2 ns
>> performance improvement for time_bench_page_pool03_slow() test case
>> of page_pool in a x86 vm system, this reduces some performance impact
>> of fixing the DMA API misuse problem in [3], performance improves
>> from 87.886 ns to 86.429 ns.
>>
>> Also a temporary patch to enable the using of full-featured API in
>> page_pool suggests that the new full-featured API doesn't seem to have
>> noticeable performance impact for the existing users, like SUNRPC, btrfs
>> and erofs.
>>
>> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
>> 2. https://lore.kernel.org/all/180818a1-b906-4a0b-89d3-34cb71cc26c9@huawei.com/
>> 3. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
>> CC: Jesper Dangaard Brouer <hawk@kernel.org>
>> CC: Luiz Capitulino <luizcap@redhat.com>
>> CC: Mel Gorman <mgorman@techsingularity.net>
>> Suggested-by: Neil Brown <neilb@suse.de>
>> Acked-by: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> V3:
>> 1. Provide both simple and full-featured API as suggested by NeilBrown.
>> 2. Do the fs testing as suggested in V2.
>>
>> V2:
>> 1. Drop RFC tag.
>> 2. Fix a compile error for xfs.
>> 3. Defragmemt the page_array for SUNRPC and btrfs.

