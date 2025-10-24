Return-Path: <kvm+bounces-61003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D447FC0568A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 11:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 245B11893A3D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BCF30C63C;
	Fri, 24 Oct 2025 09:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aRz+AIt8"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB2C29293D;
	Fri, 24 Oct 2025 09:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761299157; cv=none; b=MRcJRPOdvG7vU9mbZ7qBnMpAMmQbbD8OLuk5MN0pP9nm1sZwN8u/Lb0oIteuq5aGX3dSgCepEQNAPT/qug+P7VlRP0LjiMXJgAzdoP/MMHfUl7/FLoikObLIf8SmcJ6SdcvCRKrFD3iMHdwztp0XnXklcS3oWMtwB5aGQhBCP6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761299157; c=relaxed/simple;
	bh=5vm20h85K03C4kMvIssWzsO97pYAaqIGDGM2Vmjrduw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=U+tKUALOXjQk8fxddT7fvB6XY9OcYo3F9tMQhKLokVfMo+bRe+l223jbr0O5431ucigNsTy0nbZWNlwD/1B0R6qWmKTCEuFJJ+YCVtlsCOxx8igpnqXhofdE7dtNWuXTTGX0jenI5BKkv3C2z8xM36qxI27XtkQzv5emzb9PwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aRz+AIt8; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761299149; h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type;
	bh=8i7IvoUyLwZipphMmlbv7Bm0R6d4DUro9PNdCGClahw=;
	b=aRz+AIt8JQnu0tLicYAm5LxSzSjux4OSWF+UAi5NZw1dem0rtNU6ik0Fuz9bu71+q6/cQrEH/E6lqnrtjvGBaMPVQQq4y25j9t43KwzHj35xqlwO9d9ZDR9f2/Ntx1RJEc33SF04i+7orFaufA2iE5Msqhc0FBucydVNwuTLdbs=
Received: from 30.246.161.241(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqu0ajN_1761299145 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 17:45:47 +0800
Message-ID: <d2550489-834c-4dcd-b41f-d22590880343@linux.alibaba.com>
Date: Fri, 24 Oct 2025 17:45:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shuai Xue <xueshuai@linux.alibaba.com>
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
To: ankita@nvidia.com, aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com,
 mochs@nvidia.com, skolothumtho@nvidia.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, tony.luck@intel.com,
 bp@alien8.de, rafael@kernel.org, guohanjun@huawei.com, mchehab@kernel.org,
 lenb@kernel.org, kevin.tian@intel.com, alex@shazbot.org
Cc: cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, Jonathan.Cameron@huawei.com,
 ira.weiny@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 u.kleine-koenig@baylibre.com, peterz@infradead.org,
 linux-acpi@vger.kernel.org, kvm@vger.kernel.org
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-2-ankita@nvidia.com>
In-Reply-To: <20251021102327.199099-2-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/21 18:23, ankita@nvidia.com 写道:
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

This step depends on PATCH 2. I suggest reordering the patches so that
PATCH 2 comes first, which would make the series easier to review and
understand.

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
> ---
>   MAINTAINERS                    |   1 +
>   include/linux/memory-failure.h |  17 +++++
>   include/linux/mm.h             |   1 +
>   include/ras/ras_event.h        |   1 +
>   mm/Kconfig                     |   1 +
>   mm/memory-failure.c            | 128 ++++++++++++++++++++++++++++++++-
>   6 files changed, 148 insertions(+), 1 deletion(-)
>   create mode 100644 include/linux/memory-failure.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 520fb4e379a3..463d062d0386 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,6 +11359,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
>   R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>   L:	linux-mm@kvack.org
>   S:	Maintained
> +F:	include/linux/memory-failure.h
>   F:	mm/hwpoison-inject.c
>   F:	mm/memory-failure.c
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
> +
> +struct pfn_address_space {
> +	struct interval_tree_node node;
> +	struct address_space *mapping;
> +};
> +
> +int register_pfn_address_space(struct pfn_address_space *pfn_space);
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
> +
> +#endif /* _LINUX_MEMORY_FAILURE_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..0ab4ea82ce9e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4006,6 +4006,7 @@ enum mf_action_page_type {
>   	MF_MSG_DAX,
>   	MF_MSG_UNSPLIT_THP,
>   	MF_MSG_ALREADY_POISONED,
> +	MF_MSG_PFN_MAP,
>   	MF_MSG_UNKNOWN,
>   };
>   
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index c8cd0f00c845..fecfeb7c8be7 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -375,6 +375,7 @@ TRACE_EVENT(aer_event,
>   	EM ( MF_MSG_DAX, "dax page" )					\
>   	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
>   	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
> +	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
>   	EMe ( MF_MSG_UNKNOWN, "unknown page" )
>   
>   /*
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd6cf..0b07219390b9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -777,6 +777,7 @@ config MEMORY_FAILURE
>   	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>   	bool "Enable recovery from hardware memory errors"
>   	select MEMORY_ISOLATION
> +	select INTERVAL_TREE
>   	select RAS
>   	help
>   	  Enables code to recover from some memory failures on systems
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..acfe5a9bde1d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -38,6 +38,7 @@
>   
>   #include <linux/kernel.h>
>   #include <linux/mm.h>
> +#include <linux/memory-failure.h>
>   #include <linux/page-flags.h>
>   #include <linux/sched/signal.h>
>   #include <linux/sched/task.h>
> @@ -154,6 +155,10 @@ static const struct ctl_table memory_failure_table[] = {
>   	}
>   };
>   
> +static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
> +
> +static DEFINE_MUTEX(pfn_space_lock);
> +
>   /*
>    * Return values:
>    *   1:   the page is dissolved (if needed) and taken off from buddy,
> @@ -957,6 +962,7 @@ static const char * const action_page_types[] = {
>   	[MF_MSG_DAX]			= "dax page",
>   	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
>   	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
> +	[MF_MSG_PFN_MAP]                = "non struct page pfn",
>   	[MF_MSG_UNKNOWN]		= "unknown page",
>   };
>   
> @@ -1349,7 +1355,7 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>   {
>   	trace_memory_failure_event(pfn, type, result);
>   
> -	if (type != MF_MSG_ALREADY_POISONED) {
> +	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
>   		num_poisoned_pages_inc(pfn);
>   		update_per_node_mf_stats(pfn, result);
>   	}
> @@ -2216,6 +2222,121 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>   	kill_procs(&tokill, true, pfn, flags);
>   }
>   
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)

I have a design consideration here. Non-struct page PFNs typically
represent device memory managed by device drivers through their own
memory allocators. These drivers are responsible for allocation and
deallocation of this memory.

Rather than having MM maintain metadata about these PFNs, have you
considered adding an operation callback similar to
dev_pagemap_ops->memory_failure? This would allow device memory
allocators to:

- Maintain their own metadata tracking poison status (similar to
   TestSetPageHWPoison())
- Handle device-specific requirements for memory failure
- Provide more flexibility for different types of device memory

Thanks.
Shuai

