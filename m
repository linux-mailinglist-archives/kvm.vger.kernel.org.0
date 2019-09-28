Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270FEC1032
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 10:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfI1IZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 04:25:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:41647 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfI1IZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 04:25:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Sep 2019 01:25:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,558,1559545200"; 
   d="scan'208";a="189686935"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga008.fm.intel.com with ESMTP; 28 Sep 2019 01:25:16 -0700
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
 <52778812-129b-0fa7-985d-5814e9d84047@linux.intel.com>
 <20190927053449.GA9412@xz-x1>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <66823e27-aa33-5968-b5fd-e5221fb1fffe@linux.intel.com>
Date:   Sat, 28 Sep 2019 16:23:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927053449.GA9412@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 9/27/19 1:34 PM, Peter Xu wrote:
> Hi, Baolu,
> 
> On Fri, Sep 27, 2019 at 10:27:24AM +0800, Lu Baolu wrote:
>>>>>> +	spin_lock(&(domain)->page_table_lock);				\
>>>>>
>>>>> Is this intended to lock here instead of taking the lock during the
>>>>> whole page table walk?  Is it safe?
>>>>>
>>>>> Taking the example where nm==PTE: when we reach here how do we
>>>>> guarantee that the PMD page that has this PTE is still valid?
>>>>
>>>> We will always keep the non-leaf pages in the table,
>>>
>>> I see.  Though, could I ask why?  It seems to me that the existing 2nd
>>> level page table does not keep these when unmap, and it's not even use
>>> locking at all by leveraging cmpxchg()?
>>
>> I still need some time to understand how cmpxchg() solves the race issue
>> when reclaims pages. For example.
>>
>> Thread A				Thread B
>> -A1: check all PTE's empty		-B1: up-level PDE valid
>> -A2: clear the up-level PDE
>> -A3: reclaim the page			-B2: populate the PTEs
>>
>> Both (A1,A2) and (B1,B2) should be atomic. Otherwise, race could happen.
> 
> I'm not sure of this, but IMHO it is similarly because we need to
> allocate the iova ranges from iova allocator first, so thread A (who's
> going to unmap pages) and thread B (who's going to map new pages)
> should never have collapsed regions if happening concurrently.  I'm

Although they don't collapse, they might share a same pmd entry. If A
cleared the pmd entry and B goes ahead with populating the pte's. It
will crash.

> referring to intel_unmap() in which we won't free the iova region
> before domain_unmap() completes (which should cover the whole process
> of A1-A3) so the same iova range to be unmapped won't be allocated to
> any new pages in some other thread.
> 
> There's also a hint in domain_unmap():
> 
>    /* we don't need lock here; nobody else touches the iova range */
> 
>>
>> Actually, the iova allocator always packs IOVA ranges close to the top
>> of the address space. This results in requiring a minimal number of
>> pages to map the allocated IOVA ranges, which makes memory onsumption
>> by IOMMU page tables tolerable. Hence, we don't need to reclaim the
>> pages until the whole page table is about to tear down. The real data
>> on my test machine also improves this.
> 
> Do you mean you have run the code with a 1st-level-supported IOMMU
> hardware?  IMHO any data point would be good to be in the cover letter
> as reference.

Yes. Sure! Let me do this since the next version.

> 
> [...]
> 
>>>>>> +static struct page *
>>>>>> +mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
>>>>>> +		  unsigned long addr, unsigned long end,
>>>>>> +		  struct page *freelist, bool reclaim)
>>>>>> +{
>>>>>> +	int i;
>>>>>> +	unsigned long start;
>>>>>> +	pte_t *pte, *first_pte;
>>>>>> +
>>>>>> +	start = addr;
>>>>>> +	pte = pte_offset_kernel(pmd, addr);
>>>>>> +	first_pte = pte;
>>>>>> +	do {
>>>>>> +		set_pte(pte, __pte(0));
>>>>>> +	} while (pte++, addr += PAGE_SIZE, addr != end);
>>>>>> +
>>>>>> +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
>>>>>> +
>>>>>> +	/* Add page to free list if all entries are empty. */
>>>>>> +	if (reclaim) {
>>>>>
>>>>> Shouldn't we know whether to reclaim if with (addr, end) specified as
>>>>> long as they cover the whole range of this PMD?
>>>>
>>>> Current policy is that we don't reclaim any pages until the whole page
>>>> table will be torn down.
>>>
>>> Ah OK.  But I saw that you're passing in relaim==!start_addr.
>>> Shouldn't that errornously trigger if one wants to unmap the 1st page
>>> as well even if not the whole address space?
>>
>> IOVA 0 is assumed to be reserved by the allocator. Otherwise, we have no
>> means to check whether a IOVA is valid.
> 
> Is this an assumption of the allocator?  Could that change in the future?

Yes. And I think it should keep unless no consumer depends on this
optimization.

> 
> IMHO that's not necessary if so, after all it's as simple as replacing
> (!start_addr) with (start == 0 && end == END).  I see that in
> domain_unmap() it has a similar check when freeing pgd:
> 
>    if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw))
> 

Yours looks better. Thank you!

> Thanks,
> 

Best regards,
Baolu
