Return-Path: <kvm+bounces-60960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B7DC0480F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 08:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 505211A05270
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 06:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C4E279346;
	Fri, 24 Oct 2025 06:34:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35EA259CB3;
	Fri, 24 Oct 2025 06:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287659; cv=none; b=ki69zGieJG52ojHAkwlW0DKjQr56xfUTgKLFQI2Cs+TP42yZ1mONGBV91H+cbHxd4QvJ6OsWxCZTLyJVSl9drz0UAyMvmKN3EJHl6z5j5kyHLZmS1tEAwbKyNvnxZPF3QYFqU4+PMcKNmN+OF46hSEqlEdxzkXRO+XWm4+sEnkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287659; c=relaxed/simple;
	bh=2EYpIGv3rLA9IKXh+rVikHt9STarqQwCnX6I4i3xSLU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JBeISYbepgtrtH+I5lCKB7MoAqDhFovnGPf8tz4jMm6/lUrbf2ugvsrMBdwdUr+1p3xfFfw5dl8Sq7PJPS8oC02M5+/fBNEllZhe+NkdRv0cn4JiHi4KDQcYeCdikItKJ9JZQogwF7E60dxZfspbji6XH7sHf6VFcNvX5CwfqzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ctClk5glPzvXFZ;
	Fri, 24 Oct 2025 14:33:38 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F085C180B73;
	Fri, 24 Oct 2025 14:34:11 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 14:34:11 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 14:34:09 +0800
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
To: <ankita@nvidia.com>, <aniketa@nvidia.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<nao.horiguchi@gmail.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-2-ankita@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <421a271d-ef7b-7c00-830c-85f18a6a7afa@huawei.com>
Date: Fri, 24 Oct 2025 14:34:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251021102327.199099-2-ankita@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)

On 2025/10/21 18:23, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
> 
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_space
> to determine the mapping VMA.
> 
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> poisoned PFN using kill_procs().
> 
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map in either PMD level. Otherwise, a poison
> to a PFN would need breaking the PMD mapping into PTEs to unmap only
> the poisoned PFN. This will have a major performance impact.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Thanks for your patch. Some comments below.

> ---
>  MAINTAINERS                    |   1 +
>  include/linux/memory-failure.h |  17 +++++
>  include/linux/mm.h             |   1 +
>  include/ras/ras_event.h        |   1 +
>  mm/Kconfig                     |   1 +
>  mm/memory-failure.c            | 128 ++++++++++++++++++++++++++++++++-
>  6 files changed, 148 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/memory-failure.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 520fb4e379a3..463d062d0386 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,6 +11359,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
>  R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	include/linux/memory-failure.h
>  F:	mm/hwpoison-inject.c
>  F:	mm/memory-failure.c
>  
> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
> new file mode 100644
> index 000000000000..bc326503d2d2
> --- /dev/null
> +++ b/include/linux/memory-failure.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MEMORY_FAILURE_H
> +#define _LINUX_MEMORY_FAILURE_H
> +
> +#include <linux/interval_tree.h>
> +
> +struct pfn_address_space;

Do we need this declaration?

> +
> +struct pfn_address_space {
> +	struct interval_tree_node node;
> +	struct address_space *mapping;
> +};
> +

<snip>

> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +	struct interval_tree_node *node;
> +	LIST_HEAD(tokill);
> +
> +	mutex_lock(&pfn_space_lock);
> +	/*
> +	 * Modules registers with MM the address space mapping to the device memory they
> +	 * manage. Iterate to identify exactly which address space has mapped to this
> +	 * failing PFN.
> +	 */
> +	for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
> +	     node = interval_tree_iter_next(node, pfn, pfn)) {
> +		struct pfn_address_space *pfn_space =
> +			container_of(node, struct pfn_address_space, node);
> +
> +		collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
> +	}
> +	mutex_unlock(&pfn_space_lock);
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a different
> +	 * physical page at a given virtual address, so all userspace
> +	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +	 * MF_MUST_KILL)
> +	 */
> +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +	kill_procs(&tokill, true, pfn, flags);
> +

If pfn doesn't belong to any address space mapping, it's still counted as MF_RECOVERED?

> +	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +
>  /**
>   * memory_failure - Handle memory failure of a page.
>   * @pfn: Page Number of the corrupted page
> @@ -2259,6 +2380,11 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (!(flags & MF_SW_SIMULATED))
>  		hw_memory_failure = true;
>  
> +	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {

It's better to have some comments for this case.

> +		res = memory_failure_pfn(pfn, flags);
> +		goto unlock_mutex;
> +	}
> +
>  	p = pfn_to_online_page(pfn);
>  	if (!p) {
>  		res = arch_memory_failure(pfn, flags);

Can we move above memory_failure_pfn block here? I'm worried that too many scenario branches might
lead to confusion.

Thanks.
.

