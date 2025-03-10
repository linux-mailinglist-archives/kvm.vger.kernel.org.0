Return-Path: <kvm+bounces-40535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57ECFA589B2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 01:33:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E83016A0C3
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 00:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C015D477;
	Mon, 10 Mar 2025 00:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="l54C/qJC"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B46632;
	Mon, 10 Mar 2025 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741566802; cv=none; b=gnBZT+TQr3TJ3+cRNC3lSSs6+xXeDdDZDIJfNkr5aO+L1mCTg/L2zcByaD6dDwGT9z8+GUJmep+4KO3PdIncjEwBVYJy2FaMElRutH3nDqkMYb6Epta4qx3Hc6mK6mju+t1M6VB3U39OZ882uygesEAE3n4b8wc1hHPampJV8wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741566802; c=relaxed/simple;
	bh=8gtiSOPBeO2O6YcASdsqnV2fsibaolJ2lK9ihz7fKME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Om9I2WGSrpMovl+ToOoYrT42qHy3J0kR/WGMK6+B7rwkh7Qczd9sYjoHm5k1p+7pJINFdNoYnvbQHZ7PPwyxCLkGMFcodpfqYjfMfuVowAQQEsBXUOb3nZSpeXgiLgeyxAvQ/KEeSzZFtMH5s9bxCcEJCjKp+Udk3WerX0X8ANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=l54C/qJC; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741566795; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=i9xoUJAz+Ulc3f5EECn+evsDiO91i2wyeFM4yQAvw+Q=;
	b=l54C/qJCqjoLb2HMsxvD9kS4XgpLrA1qEEH3b8Hoon1p1tNMcRpBf2328jSpdnGZvuHHZf1TOjFufL5ER1O43HgSGrfveqL5OCZ6n/64bq/f8ucP7oJ62CgOza7e5bjBZlwwET39G2OvwMnLHi9ub0TEZ01S1QnFi+EKETryenU=
Received: from 30.134.66.95(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WQy811n_1741566764 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 10 Mar 2025 08:33:11 +0800
Message-ID: <625983f8-7e52-4f6c-97bb-629596341181@linux.alibaba.com>
Date: Mon, 10 Mar 2025 08:32:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Yunsheng Lin <yunshenglin0825@gmail.com>,
 Dave Chinner <david@fromorbit.com>, Yunsheng Lin <linyunsheng@huawei.com>
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <cce03970-d66f-4344-b496-50ecf59483a6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/3/9 21:40, Yunsheng Lin wrote:
> On 3/8/2025 2:43 PM, Dave Chinner wrote:
> 
> ...
> 
>>> I tested XFS using the below cmd and testcase, testing seems
>>> to be working fine, or am I missing something obvious here
>>> as I am not realy familiar with fs subsystem yet:
>>
>> That's hardly what I'd call a test. It barely touches the filesystem
>> at all, and it is not exercising memory allocation failure paths at
>> all.
>>
>> Go look up fstests and use that to test the filesystem changes you
>> are making. You can use that to test btrfs and NFS, too.
> 
> Thanks for the suggestion.
> I used the below xfstests to do the testing in a VM, the smoke testing
> seems fine for now, will do a full testing too:
> https://github.com/tytso/xfstests-bld
> 
> Also, it seems the fstests doesn't support erofs yet?

erofs is an read-only filesystem, and almost all xfstests
cases is unsuitable for erofs since erofs needs to preset
dataset in advance for runtime testing and only
read-related interfaces are cared:

You could check erofs-specfic test cases here:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/log/?h=experimental-tests

Also the stress test:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/commit/?id=6fa861e282408f8df9ab1654b77b563444b17ea1

BTW, I don't like your new interface either, I don't know
why you must insist on this work now that others are
already nak this.  Why do you insist on it so much?

Thanks,
Gao Xiang

> 
>>
>> -Dave.
>>


