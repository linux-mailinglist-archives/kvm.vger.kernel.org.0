Return-Path: <kvm+bounces-66201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF0D3CCA122
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 03:18:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36651302AFA4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 02:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27602F659F;
	Thu, 18 Dec 2025 02:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="z8xS0Ku0"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9643258ECB;
	Thu, 18 Dec 2025 02:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766024293; cv=none; b=Ym17H5lo69ELhuNL/g6rdxdjtX9nB+ze9ej9TKBegfoQWEcrdGAIb6XvMkRZ42Xaz9whEsKx4WXqDE/scmcxoki2R142WtTQph+y25A4ke7GL+xkkfNc65O+TQ5Gl+mtnIrBarLAbSMnsP+oHWhn0Tcy9TRjPDP3RPvngjbrN/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766024293; c=relaxed/simple;
	bh=c8rJ6JMxZp9DaGNwOiUd7KigxG1YrnCIPSv6q0EhAh4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IWkknJ3RCv14zka4JOIATFUNetBqaQY44qQ9L8x+dK9Jra0994IGa8MK5FzjPd6WZCnvQY/o0JKHnsUrpjBNKcRg9yqbd07b1wFv2GD+7zmJ1O92rGfEGaCdJBkWxo2sOg5mkGFY9x8IpxoYS5pWQr6Irld/iETXoRVDkkGNDuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=z8xS0Ku0; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mU9pFxcO0/m/HH3q3YJxOTDrfSR1HD2/oA7Tnb2zAg0=;
	b=z8xS0Ku07NSfMV0+Eyjw0tVZd+2KlX5/xZ9iNMjLJk7g7Ezu8uLL02LLnDzGNeOgBxj7LLSFL
	pyoGHKtcJlGOTfIO1UHDoVdjdSIj4M7daExWaLqQIJP/W/0uNfuyblKB5WilT14RNWJiKCJnB6D
	VJhJ83pyUdWc45DEopxByOQ=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dWvQ81r27zcb2h;
	Thu, 18 Dec 2025 10:15:12 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F115814022E;
	Thu, 18 Dec 2025 10:18:06 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 10:18:06 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 10:18:05 +0800
Subject: Re: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
To: Ankit Agrawal <ankita@nvidia.com>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
 <20251213044708.3610-2-ankita@nvidia.com>
 <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
 <SA1PR12MB7199065CD785B5FD0BFE6FB9B0ABA@SA1PR12MB7199.namprd12.prod.outlook.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f83bf67a-166e-f224-8b5c-821d8314ca0c@huawei.com>
Date: Thu, 18 Dec 2025 10:18:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <SA1PR12MB7199065CD785B5FD0BFE6FB9B0ABA@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)

On 2025/12/18 2:10, Ankit Agrawal wrote:
>>>        i_mmap_lock_read(mapping);
>>>        rcu_read_lock();
>>> @@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_space *mapping,
>>>                t = task_early_kill(tsk, true);
>>>                if (!t)
>>>                        continue;
>>> -             vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
>>> -                     if (vma->vm_mm == t->mm)
>>> -                             add_to_kill_pfn(t, vma, to_kill, pfn);
>>> +             vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
>>> +                     pgoff_t pgoff;
>>
>> IIUC, all vma will be traversed to find the final pgoff. This might not be a good idea
>> because rcu lock is held and this traversal might take a really long time. Or am I miss
>> something?
> 
> Hi Miaohe, the VMAs on the registered address space will be checked. For the nvgrace-gpu
> user of this API in 3/3, there are only 3 VMAs on the registered address space (that are
> associated with the vfio file).

Oh, I see. Thanks for your explanation. :)

