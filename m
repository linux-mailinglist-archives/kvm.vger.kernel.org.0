Return-Path: <kvm+bounces-43819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1A1A96737
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 13:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9D93189D762
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA3927C14D;
	Tue, 22 Apr 2025 11:22:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDD925F96F;
	Tue, 22 Apr 2025 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745320977; cv=none; b=D5I6GIvOpR83Ie6P1ZSFYYs2Xrg1hh61FViZ04QHmigdBXaugMS3JHP0d3o9BTngQgDhwR6i0FWnxa0MS3+NFvC8BEax9edJaNQdKfv/espMU13xdHDvXvVbqDKH6BFh8SvDV965fE0kFnwgh+z+IFC0lAbmljPKHNoTjO+5394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745320977; c=relaxed/simple;
	bh=zTL90bad/j/J03MNrk8iChcdy57GihnCjKQVaL4RKTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=m/jvWasnKwRuHiPUtUSGF+1doyRyVRI6fzvYSTpwo0KTWuYdKHV39WmNLDvUyfMOGVVxvGpbNuVgCnVbERmo1yWtOFZZ/9Fm83420FEMVDp4+XXM+rMMXkmbIROufyAMlJ4S/pRu2tnFTYI6TSMSWO5uijAmPmnAleJyzCFwXtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zhfr23R0RzvWrs;
	Tue, 22 Apr 2025 19:18:42 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 395C9180087;
	Tue, 22 Apr 2025 19:22:51 +0800 (CST)
Received: from [10.67.120.129] (10.67.120.129) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 22 Apr 2025 19:22:50 +0800
Message-ID: <cd6db77d-fcb4-44d9-8f1b-61749b411c33@huawei.com>
Date: Tue, 22 Apr 2025 19:22:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: alloc_pages_bulk: support both simple and
 full-featured API
To: Leon Romanovsky <leon@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Chris
 Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba
	<dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Chuck Lever <chuck.lever@oracle.com>, Jeff
 Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>, Olga Kornievskaia
	<okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
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
	<anna@kernel.org>, Luiz Capitulino <luizcap@redhat.com>, Mel Gorman
	<mgorman@techsingularity.net>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>,
	<linux-mm@kvack.org>, <linux-nfs@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
	<netdev@vger.kernel.org>
References: <20250414120819.3053967-1-linyunsheng@huawei.com>
 <20250420112110.GA32613@unreal>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <20250420112110.GA32613@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/4/20 19:21, Leon Romanovsky wrote:

...

>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 11eda6b207f1..fb094527715f 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -446,8 +446,6 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
>>  		if (ret)
>>  			goto err_append;
>>  		buf->allocated_length += filled * PAGE_SIZE;
>> -		/* clean input for another bulk allocation */
>> -		memset(page_list, 0, filled * sizeof(*page_list));
>>  		to_fill = min_t(unsigned int, to_alloc,
>>  				PAGE_SIZE / sizeof(*page_list));
> 
> If it is possible, let's drop this hunk to reduce merge conflicts.
> The whole mlx5vf_add_migration_pages() is planned to be rewritten.
> https://lore.kernel.org/linux-rdma/076a3991e663fe07c1a5395f5805c514b63e4d94.1744825142.git.leon@kernel.org/

It seems mlx5vf_add_migration_pages() is changed to use the pattern
of passing 'page_array + allocated' and 'nr_pages - allocated' in the
above patch, so I think it is ok to drop the above hunk.

Hi, Andrew
Do you want me to resend this patch without the above hunk or it is
possible that you can drop the above hunk when committing if there
is no other comment need fixing?

> 
> Thanks
> 
> 


