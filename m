Return-Path: <kvm+bounces-40648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C33DA59578
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BBC6188DEEE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA11722A4E4;
	Mon, 10 Mar 2025 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nA+4lbcZ"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F722156E;
	Mon, 10 Mar 2025 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741611603; cv=none; b=GZMfzLBXh4miwoojilwe6fXieuBGWVe7I1yCt5tu+p71+HLJmjxO8tSMKahVJL6IjA/PUVyMy+W2/OJFwAq0XUFKpTmJAoquaanO9m0aXaNYZZlNSOApQF308qmqABwytG9J54nuYI4fUUxQdSG9V+eeVT4m1crzwlHHWEqhe8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741611603; c=relaxed/simple;
	bh=suy1czGkUxH4ApgxauOBKdQ6mOTZxtAJl10IVykKPl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LmVFJ9cl8qTw8+wCxbQFrKrSOYxOxQGr0dQZAgWCpvIiSufOcC6GI3JIGYTBfUuWjzb0zR3XX+biYNb0Qd6q9VCzQy1DL6BkSAhkeR6C06D2UjsgeKGTAIr2Mmw+i+t5SfkozdcrKzPDBlletMQirSrOvKvjK7lt6Zt7JVdScMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nA+4lbcZ; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741611590; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RBXViRbgYvu9SyQX3LTahN7Wc3wvAYaCUKId9eKui+E=;
	b=nA+4lbcZa6zBlirYk6vuMbOh8gNs1V2LDvNYx4kgX1uAYEaQaaNzhNE/GlcLeLi8sMuIOklgWTrFeFxa/uwkjbZIG/C3JZQZY98oi5f50YbX1RNuX5XHIyJ5UobTAu2bf9kdGdFozGo5iLW3rClsz4DMUyGxVKE/63FG2AcLe8E=
Received: from 30.74.129.235(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WR3.NYS_1741611585 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Mar 2025 20:59:46 +0800
Message-ID: <316d62c1-0e56-4b11-aacf-86235fba808d@linux.alibaba.com>
Date: Mon, 10 Mar 2025 20:59:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Yunsheng Lin <linyunsheng@huawei.com>,
 Yunsheng Lin <yunshenglin0825@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
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
 Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Luiz Capitulino <luizcap@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
References: <20250228094424.757465-1-linyunsheng@huawei.com>
 <Z8a3WSOrlY4n5_37@dread.disaster.area>
 <91fcdfca-3e7b-417c-ab26-7d5e37853431@huawei.com>
 <Z8vnKRJlP78DHEk6@dread.disaster.area>
 <cce03970-d66f-4344-b496-50ecf59483a6@gmail.com>
 <625983f8-7e52-4f6c-97bb-629596341181@linux.alibaba.com>
 <14170f7f-97d0-40b4-9b07-92e74168e030@huawei.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <14170f7f-97d0-40b4-9b07-92e74168e030@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2025/3/10 20:31, Yunsheng Lin wrote:
> On 2025/3/10 8:32, Gao Xiang wrote:
> 
> ...
> 
>>>
>>> Also, it seems the fstests doesn't support erofs yet?
>>
>> erofs is an read-only filesystem, and almost all xfstests
>> cases is unsuitable for erofs since erofs needs to preset
>> dataset in advance for runtime testing and only
>> read-related interfaces are cared:
>>
>> You could check erofs-specfic test cases here:
>> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/log/?h=experimental-tests
>>
>> Also the stress test:
>> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?id=6fa861e282408f8df9ab1654b77b563444b17ea1
> 
> Thanks.
> 
>>
>> BTW, I don't like your new interface either, I don't know
>> why you must insist on this work now that others are
>> already nak this.  Why do you insist on it so much?
> 
> If the idea was not making any sense to me and it was nack'ed
> with clearer reasoning and without any supporting of the idea,
> I would have stopped working on it.
> 
> The background I started working at is something like below
> in the commit log:
> "As mentioned in [1], it seems odd to check NULL elements in
> the middle of page bulk allocating, and it seems caller can
> do a better job of bulk allocating pages into a whole array
> sequentially without checking NULL elements first before
> doing the page bulk allocation for most of existing users."
> 
> "Remove assumption of populating only NULL elements and treat
> page_array as output parameter like kmem_cache_alloc_bulk().
> Remove the above assumption also enable the caller to not
> zero the array before calling the page bulk allocating API,
> which has about 1~2 ns performance improvement for the test
> case of time_bench_page_pool03_slow() for page_pool in a
> x86 vm system, this reduces some performance impact of
> fixing the DMA API misuse problem in [2], performance
> improves from 87.886 ns to 86.429 ns."
> 
> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
> 
> There is no 'must' here, it is just me taking some of my
> hoppy time and some of my work time trying to make the
> alloc_pages_bulk API simpler and more efficient here, and I
> also learnt a lot during that process.


Here are my own premature thoughts just for reference:

  - If you'd like to provide some performance gain, it would
    be much better to get a better end-to-end case to show
    your improvement is important and attractive to some
    in-tree user (rather than show 1~2ns instruction-level
    micro-benchmark margin, is it really important to some
    end use case? At least, the new api is not important to
    erofs since it may only impact our mount time by only
    1~2ns, which is almost nothing, so I have no interest
    to follow the whole thread) since it involves some api
    behavior changes rather than some trivial cleanups.

  - Your new api covers narrow cases compared to the existing
    api, although all in-tree callers may be converted
    properly, but it increases mental burden of all users.
    And maybe complicate future potential users again which
    really have to "check NULL elements in the middle of page
    bulk allocating" again.

To make it clearer, it's not nak from me. But I don't have
any interest to follow your work due to "the real benefit vs
behavior changes".

Thanks,
Gao Xiang

