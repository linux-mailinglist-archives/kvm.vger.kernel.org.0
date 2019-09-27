Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21B1BFD31
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfI0C32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:29:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:33414 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbfI0C31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:29:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:29:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="201864379"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 26 Sep 2019 19:29:23 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
To:     Peter Xu <peterx@redhat.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190925052157.GL28074@xz-x1>
 <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
 <20190926034905.GW28074@xz-x1>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <52778812-129b-0fa7-985d-5814e9d84047@linux.intel.com>
Date:   Fri, 27 Sep 2019 10:27:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190926034905.GW28074@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 9/26/19 11:49 AM, Peter Xu wrote:
> On Thu, Sep 26, 2019 at 10:35:24AM +0800, Lu Baolu wrote:
> 
> [...]
> 
>>>> @@ -0,0 +1,342 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/**
>>>> + * intel-pgtable.c - Intel IOMMU page table manipulation library
>>>
>>> Could this be a bit misleading?  Normally I'll use "IOMMU page table"
>>> to refer to the 2nd level page table only, and I'm always
>>> understanding it as "the new IOMMU will understand MMU page table as
>>> the 1st level".  At least mention "IOMMU 1st level page table"?
>>>
>>
>> This file is a place holder for all code that manipulating iommu page
>> tables (both first level and second level). Instead of putting
>> everything in intel_iommu.c, let's make the code more structured so that
>> it's easier for reading and maintaining. This is the motivation of this
>> file.
> 
> I see.
> 
>>
>>>> + *
>>>> + * Copyright (C) 2019 Intel Corporation
>>>> + *
>>>> + * Author: Lu Baolu <baolu.lu@linux.intel.com>
>>>> + */
>>>> +
>>>> +#define pr_fmt(fmt)     "DMAR: " fmt
>>>> +#include <linux/vmalloc.h>
>>>> +#include <linux/mm.h>
>>>> +#include <linux/sched.h>
>>>> +#include <linux/io.h>
>>>> +#include <linux/export.h>
>>>> +#include <linux/intel-iommu.h>
>>>> +#include <asm/cacheflush.h>
>>>> +#include <asm/pgtable.h>
>>>> +#include <asm/pgalloc.h>
>>>> +#include <trace/events/intel_iommu.h>
>>>> +
>>>> +#ifdef CONFIG_X86
>>>> +/*
>>>> + * mmmap: Map a range of IO virtual address to physical addresses.
>>>
>>> "... to physical addresses using MMU page table"?
>>>
>>> Might be clearer?
>>
>> Yes.
>>
>>>
>>>> + */
>>>> +#define pgtable_populate(domain, nm)					\
>>>> +do {									\
>>>> +	void *__new = alloc_pgtable_page(domain->nid);			\
>>>> +	if (!__new)							\
>>>> +		return -ENOMEM;						\
>>>> +	smp_wmb();							\
>>>
>>> Could I ask what's this wmb used for?
>>
>> Sure. This is answered by a comment in __pte_alloc() in mm/memory.c. Let
>> me post it here.
>>
>>          /*
>>           * Ensure all pte setup (eg. pte page lock and page clearing) are
>>           * visible before the pte is made visible to other CPUs by being
>>           * put into page tables.
>>           *
>>           * The other side of the story is the pointer chasing in the page
>>           * table walking code (when walking the page table without locking;
>>           * ie. most of the time). Fortunately, these data accesses consist
>>           * of a chain of data-dependent loads, meaning most CPUs (alpha
>>           * being the notable exception) will already guarantee loads are
>>           * seen in-order. See the alpha page table accessors for the
>>           * smp_read_barrier_depends() barriers in page table walking code.
>>           */
>>          smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
> 
> Ok.  I don't understand the rationale much behind but the comment
> seems to make sense...  Could you help to comment above, like "please
> reference to comment in __pte_alloc" above the line?

Yes.

> 
>>
>>>
>>>> +	spin_lock(&(domain)->page_table_lock);				\
>>>
>>> Is this intended to lock here instead of taking the lock during the
>>> whole page table walk?  Is it safe?
>>>
>>> Taking the example where nm==PTE: when we reach here how do we
>>> guarantee that the PMD page that has this PTE is still valid?
>>
>> We will always keep the non-leaf pages in the table,
> 
> I see.  Though, could I ask why?  It seems to me that the existing 2nd
> level page table does not keep these when unmap, and it's not even use
> locking at all by leveraging cmpxchg()?

I still need some time to understand how cmpxchg() solves the race issue
when reclaims pages. For example.

Thread A				Thread B
-A1: check all PTE's empty		-B1: up-level PDE valid
-A2: clear the up-level PDE
-A3: reclaim the page			-B2: populate the PTEs

Both (A1,A2) and (B1,B2) should be atomic. Otherwise, race could happen.

Actually, the iova allocator always packs IOVA ranges close to the top
of the address space. This results in requiring a minimal number of
pages to map the allocated IOVA ranges, which makes memory onsumption
by IOMMU page tables tolerable. Hence, we don't need to reclaim the
pages until the whole page table is about to tear down. The real data
on my test machine also improves this.

> 
>> hence we only need
>> a spin lock to serialize multiple tries of populating a entry for pde.
>> As for pte, we can assume there is only single thread which can access
>> it at a time because different mappings will have different iova's.
> 
> Ah yes sorry nm will never be pte here... so do you mean the upper
> layer, e.g., the iova allocator will make sure the ranges to be mapped
> will never collapse with each other so setting PTEs do not need lock?

Yes.

> 
>>
>>>
>>>> +	if (nm ## _present(*nm)) {					\
>>>> +		free_pgtable_page(__new);				\
>>>> +	} else {							\
>>>> +		set_##nm(nm, __##nm(__pa(__new) | _PAGE_TABLE));	\
>>>
>>> It seems to me that PV could trap calls to set_pte().  Then these
>>> could also be trapped by e.g. Xen?  Are these traps needed?  Is there
>>> side effect?  I'm totally not familiar with this, but just ask aloud...
>>
>> Good catch. But I don't think a vIOMMU could get a chance to run in a PV
>> environment. I might miss something?
> 
> I don't know... Is there reason to not allow a Xen guest to use 1st
> level mapping?

I was thinking that a PV driver should be used in the PV environment. So
the vIOMMU driver (which is for full virtualization) would never get a
chance to run in PV environment.

> 
> While on the other side... If the PV interface will never be used,
> then could native_set_##nm() be used directly?

But, anyway, as you pointed out, native_set_##nm() looks better.

> 
> [...]
> 
>>>> +static struct page *
>>>> +mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
>>>> +		  unsigned long addr, unsigned long end,
>>>> +		  struct page *freelist, bool reclaim)
>>>> +{
>>>> +	int i;
>>>> +	unsigned long start;
>>>> +	pte_t *pte, *first_pte;
>>>> +
>>>> +	start = addr;
>>>> +	pte = pte_offset_kernel(pmd, addr);
>>>> +	first_pte = pte;
>>>> +	do {
>>>> +		set_pte(pte, __pte(0));
>>>> +	} while (pte++, addr += PAGE_SIZE, addr != end);
>>>> +
>>>> +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
>>>> +
>>>> +	/* Add page to free list if all entries are empty. */
>>>> +	if (reclaim) {
>>>
>>> Shouldn't we know whether to reclaim if with (addr, end) specified as
>>> long as they cover the whole range of this PMD?
>>
>> Current policy is that we don't reclaim any pages until the whole page
>> table will be torn down.
> 
> Ah OK.  But I saw that you're passing in relaim==!start_addr.
> Shouldn't that errornously trigger if one wants to unmap the 1st page
> as well even if not the whole address space?

IOVA 0 is assumed to be reserved by the allocator. Otherwise, we have no
means to check whether a IOVA is valid.

> 
>> The gain is that we don't have to use a
>> spinlock when map/unmap a pmd entry anymore.
> 
> So this question should also related to above on the locking - have
> you thought about using the same way (IIUC) as the 2nd level page
> table to use cmpxchg()?  AFAIU that does not need any lock?
> 
> For me it's perfectly fine to use a lock at least for initial version,
> I just want to know the considerations behind in case I missed
> anything important.

I agree that we can use cmpxchg() to replace spinlock when populating
a page directory entry.

Best regards,
Baolu
