Return-Path: <kvm+bounces-7851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 391E1847042
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 13:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C00A2B2864D
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 12:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEBF144631;
	Fri,  2 Feb 2024 12:26:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89076145332;
	Fri,  2 Feb 2024 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876790; cv=none; b=KfqnUXZRkZ4Ql5lZVicWpaart1NQHOZ3sNM43+yLOYB/F36DbgZeRFueB/g4HhFJLYET4BrArKAYB8Xvi+JlQTxiTYROaBzzO14PZUZ18ayydYVKcTHvkh8v2tdzbUkRU9KSP1xza8J7wnIrESi3BC03U9H/FAQNH82JG/CmcHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876790; c=relaxed/simple;
	bh=zTYvDrC3AI1BUd+WmQeEVA4jrbzOrc/cESq1tDOC62Q=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=n5RrVGdDRibJavPVz8mLOmpCaQsbuhwvrrkx97gU7qoTGLY0L1zM//wiEh9oDXKZk2bh5qeSVrEwcaC38WGn0o+XkwgAmJkubONrvY1OIL/RdoBwW/BmnvJyg9WaOszyoqOTXt/hgWmew4KdM93ZQTMkA8pEzaq1LxhyEu+Uw/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TRFMH5sspz1Q8XD;
	Fri,  2 Feb 2024 20:24:27 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 69B37140384;
	Fri,  2 Feb 2024 20:26:20 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 2 Feb
 2024 20:26:20 +0800
Subject: Re: [PATCH net-next v4 2/5] page_frag: unify gfp bits for order 3
 page allocation
To: Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Alexander Duyck
	<alexanderduyck@fb.com>, Alexander Duyck <alexander.duyck@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet
	<edumazet@google.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>
References: <20240130113710.34511-1-linyunsheng@huawei.com>
 <20240130113710.34511-3-linyunsheng@huawei.com>
 <81c37127dda0f2f69a019d67d4420f62c995ee7f.camel@redhat.com>
 <2e8606b1-81c2-6f3f-622c-607db5e90253@huawei.com>
 <868b806f0d6b365334ac79a11a3a1a8a1588cbdf.camel@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <540b1cbf-da9e-eb9e-08ce-39b7f053652c@huawei.com>
Date: Fri, 2 Feb 2024 20:26:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <868b806f0d6b365334ac79a11a3a1a8a1588cbdf.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)

On 2024/2/2 16:36, Paolo Abeni wrote:
> On Fri, 2024-02-02 at 10:10 +0800, Yunsheng Lin wrote:
>> On 2024/2/1 21:16, Paolo Abeni wrote:
>>
>>> from the __page_frag_cache_refill() allocator - which never accesses
>>> the memory reserves.
>>
>> I am not really sure I understand the above commemt.
>> The semantic is the same as skb_page_frag_refill() as explained above
>> as my understanding. Note that __page_frag_cache_refill() use 'gfp_mask'
>> for allocating order 3 pages and use the original 'gfp' for allocating
>> order 0 pages.
> 
> You are right! I got fooled misreading 'gfp' as 'gfp_mask' in there.
> 
>>> I'm unsure we want to propagate the __page_frag_cache_refill behavior
>>> here, the current behavior could be required by some systems.
>>>
>>> It looks like this series still leave the skb_page_frag_refill()
>>> allocator alone, what about dropping this chunk, too? 
>>
>> As explained above, I would prefer to keep it as it is as it seems
>> to be quite obvious that we can avoid possible pressure for mm by
>> not using memory reserve for order 3 pages as we have the fallback
>> for order 0 pages.
>>
>> Please let me know if there is anything obvious I missed.
>>
> 
> I still think/fear that behaviours changes here could have
> subtle/negative side effects - even if I agree the change looks safe.
> 
> I think the series without this patch would still achieve its goals and
> would be much more uncontroversial. What about move this patch as a
> standalone follow-up?

Fair enough, will remove that for now.

> 
> Thanks!
> 
> Paolo
> 
> .
> 

