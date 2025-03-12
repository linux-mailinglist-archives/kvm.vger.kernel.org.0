Return-Path: <kvm+bounces-40825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06A26A5DC4C
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 13:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC15D189A9C4
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 12:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D49243399;
	Wed, 12 Mar 2025 12:06:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C49F1DB124;
	Wed, 12 Mar 2025 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741781159; cv=none; b=D8A/9FWRRkRAk92hYGuCvZsixX9bnt6DIAyjXKh1x6E6UIYlaw+VsoMGeXtZDRtt/ZcgDvWyyPb/DljzBR+PuKseauZtsLBQogWvjHGpSv1aQwqnbf7ImFGUJCWklEVRn4eYmDJATqH8z95kEbTkHjpJVzTRr87ivP2+do4sHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741781159; c=relaxed/simple;
	bh=8LD+UsRzy8LfAVX2BSyNVujQscsLxF7g9+mepAyjx4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WhPFrRKEDS3YWGbWianM6ihQTYW70Pf/vvpayLjkkALmUg/uv4LW1RnYjL/ANpQ/vdDUJdVhgXV73ufZCpuCQF+04BrRaTD7ORnsYrkraAJ9DUamFS1BXluXLB93/cUC1W9ukYk6nK53iZCoSoUIubQl5hn9dVlF4Yro+mBvS5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZCTl019PpzvWs0;
	Wed, 12 Mar 2025 20:02:04 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id BAA7A1401F1;
	Wed, 12 Mar 2025 20:05:54 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 12 Mar 2025 20:05:51 +0800
Message-ID: <c5cdd730-1e11-4440-849d-8841b5ce86ef@huawei.com>
Date: Wed, 12 Mar 2025 20:05:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Gao Xiang <hsiangkao@linux.alibaba.com>, NeilBrown <neilb@suse.de>
CC: Yunsheng Lin <yunshenglin0825@gmail.com>, Dave Chinner
	<david@fromorbit.com>, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik
	<josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Gao Xiang
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
	<luizcap@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-xfs@vger.kernel.org>,
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>
References: <> <316d62c1-0e56-4b11-aacf-86235fba808d@linux.alibaba.com>
 <174173371062.33508.12685894810362310394@noble.neil.brown.name>
 <14ef70cc-beba-4abb-b206-e9fb29381023@linux.alibaba.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <14ef70cc-beba-4abb-b206-e9fb29381023@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/12 9:45, Gao Xiang wrote:
> 
> 
> On 2025/3/12 06:55, NeilBrown wrote:
>> On Mon, 10 Mar 2025, Gao Xiang wrote:
>>>
>>>    - Your new api covers narrow cases compared to the existing
>>>      api, although all in-tree callers may be converted
>>>      properly, but it increases mental burden of all users.
>>>      And maybe complicate future potential users again which
>>>      really have to "check NULL elements in the middle of page
>>>      bulk allocating" again.
>>
>> I think that the current API adds a mental burden for most users.  For
>> most users, their code would be much cleaner if the interface accepted
>> an uninitialised array with length, and were told how many pages had
>> been stored in that array.> A (very) few users benefit from the complexity.  So having two
>> interfaces, one simple and one full-featured, makes sense.

Thanks for the above clear summarization.

> 
> Ok, I think for this part, diferrent people has different
> perference on API since there is no absolutely right and
> wrong in the API design area.
> 
> But I have no interest to follow this for now.

Just to be clearer, as erofs seems to be able to be changed to
use a simple interface, do you prefer to keep using the full-featured
interface or change to use the simple interface?

> 
> Thanks,
> Gao Xiang

