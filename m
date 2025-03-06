Return-Path: <kvm+bounces-40242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADE8A549E3
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 12:47:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90C23188D7B5
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 11:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B7E20C022;
	Thu,  6 Mar 2025 11:43:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5261A20B7F1;
	Thu,  6 Mar 2025 11:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741261413; cv=none; b=X23PlnI0ircUjs7WULp35xxzJiZ3zXScQQ1U3ncuyvBO+x+yh23PmvOmkHJlo5lxlgoUiASBevdQHnGMncHNU1eCofaiI8IcjZS0FcehHUTIiNYKD3A38tLRW9Nv41TroNhGdncRBQJQ2pu1nMIOJX/BRfp+8BII/xPjTpcZLiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741261413; c=relaxed/simple;
	bh=Q3McjjKLJ/px/KaPolwOtAzJP+Ph3x4mOmHfpx1Kogc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kjZQzQMQfR8BpALv6E0eInDkfBHQVaiOtkSEzcWF8kfL9z3O1/0H2tvrnywO6GNdH8G6YlbGHj0wQecWMLbr3RD+Hf6oOqyd89qnuNsmNjZwYIJKOPJRGklY20SutqVqA/PpY4nmNGQNtkXCxHWk8kRBT6VVfNkeUukTa+MW17I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Z7nZM3B73z1R5yB;
	Thu,  6 Mar 2025 19:41:47 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id EF1211A0171;
	Thu,  6 Mar 2025 19:43:25 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 6 Mar 2025 19:43:23 +0800
Message-ID: <f834a7cd-ca0a-4495-a787-134810aa0e4d@huawei.com>
Date: Thu, 6 Mar 2025 19:43:22 +0800
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
References: <> <18c68e7a-88c9-49d1-8ff8-17c63bcc44f4@huawei.com>
 <174121808436.33508.1242845473359255682@noble.neil.brown.name>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <174121808436.33508.1242845473359255682@noble.neil.brown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/6 7:41, NeilBrown wrote:
> On Wed, 05 Mar 2025, Yunsheng Lin wrote:
>>
>> For the existing btrfs and sunrpc case, I am agreed that there
>> might be valid use cases too, we just need to discuss how to
>> meet the requirements of different use cases using simpler, more
>> unified and effective APIs.
> 
> We don't need "more unified".

What I meant about 'more unified' is how to avoid duplicated code as
much as possible for two different interfaces with similar‌ functionality.

The best way I tried to avoid duplicated code as much as possible is
to defragment the page_array before calling the alloc_pages_bulk()
for the use case of btrfs and sunrpc so that alloc_pages_bulk() can
be removed of the assumption populating only NULL elements, so that
the API is simpler and more efficient.

> 
> If there are genuinely two different use cases with clearly different
> needs - even if only slightly different - then it is acceptable to have
> two different interfaces.  Be sure to choose names which emphasise the
> differences.

The best name I can come up with for the use case of btrfs and sunrpc
is something like alloc_pages_bulk_refill(), any better suggestion about
the naming?

> 
> Thanks,
> NeilBrown

