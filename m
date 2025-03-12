Return-Path: <kvm+bounces-40812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 250CBA5D42B
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 02:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B17227AB2F1
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 01:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24483152532;
	Wed, 12 Mar 2025 01:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="T4p5PI+/"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7668450FE;
	Wed, 12 Mar 2025 01:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741743925; cv=none; b=KydgK9htvCh0cRZwZBoBDHIRAC4M+w5rX1HJkwo8Cjqidwb2RdjYZfWi5nLaAnu05KExFXr0jbgj8M/T/PGOLtBt1oMdM+UaamQ2yKgP2fngTweHcxp+Scs2op+oE/rJ+dLk1X8uUzLRCakvDe7b1MQXVtsy3whPyVyfMTY4bdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741743925; c=relaxed/simple;
	bh=4Y06xikukVUFXhu/yWSYxg9Jt8t+JmAK+tfE6/N7nT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsfjjuPgKSCXakNGDjr8p4Db4mZMsTwgWE0+Zjvv4OGTCetondUEjVC9QjMzS7QXZy55B0K3hncroYueCvf3P06n28l46aNGaOQwUFW7fXA+4rma4hpNRZsYWffZV8oZ9nXDh/JubDZoUbaNZRKKlMlP0TMkfZq+XRhpf5sFaKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=T4p5PI+/; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741743914; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pJsIAiBQwxxlPupaINFvaIjtvwWgE2QzMrLd5G9yQKs=;
	b=T4p5PI+/FFra7ELZyIkX3qB9kIUPLMqTU+Lu5jAlgNbcKuMOLcUHiWqEkGV//CS3XtBi/1wFch7sxaBmeH7QAQJ46VD9lBJ+Rom3mmNcX9ZZrFBxUANwDqReKGsWyvrdfxDzy9Hj+NxOHiYYKS1D+NccfdmSxUAtCVoAnc8s7JY=
Received: from 30.74.129.75(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WRAiBpj_1741743910 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Mar 2025 09:45:11 +0800
Message-ID: <14ef70cc-beba-4abb-b206-e9fb29381023@linux.alibaba.com>
Date: Wed, 12 Mar 2025 09:45:10 +0800
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
Cc: Yunsheng Lin <linyunsheng@huawei.com>,
 Yunsheng Lin <yunshenglin0825@gmail.com>, Dave Chinner
 <david@fromorbit.com>, Yishai Hadas <yishaih@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
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
 Jeff Layton <jlayton@kernel.org>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Luiz Capitulino <luizcap@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
References: <> <316d62c1-0e56-4b11-aacf-86235fba808d@linux.alibaba.com>
 <174173371062.33508.12685894810362310394@noble.neil.brown.name>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <174173371062.33508.12685894810362310394@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/3/12 06:55, NeilBrown wrote:
> On Mon, 10 Mar 2025, Gao Xiang wrote:
>>
>>    - Your new api covers narrow cases compared to the existing
>>      api, although all in-tree callers may be converted
>>      properly, but it increases mental burden of all users.
>>      And maybe complicate future potential users again which
>>      really have to "check NULL elements in the middle of page
>>      bulk allocating" again.
> 
> I think that the current API adds a mental burden for most users.  For
> most users, their code would be much cleaner if the interface accepted
> an uninitialised array with length, and were told how many pages had
> been stored in that array.> 
> A (very) few users benefit from the complexity.  So having two
> interfaces, one simple and one full-featured, makes sense.

Ok, I think for this part, diferrent people has different
perference on API since there is no absolutely right and
wrong in the API design area.

But I have no interest to follow this for now.

Thanks,
Gao Xiang

