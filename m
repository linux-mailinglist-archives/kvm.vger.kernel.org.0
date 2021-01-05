Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5AF2EA2D4
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 02:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbhAEBPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 20:15:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbhAEBPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 20:15:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1051Allk039242;
        Tue, 5 Jan 2021 01:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cbdo+HzzL9PlbE+XjCwF1+TtuivyKznXExVgahDtHpM=;
 b=egblUOj7QhceqCg1s0gPsF0uV/wthPx/RyRXvfGOkYNH3gsCpcLEg68jBMNPiXF0fzYB
 SWRT1LtfnT8onqA3iiwG+JaL9E8t2tUmOJgH8GhwBhIMyQoef8PyVC14wDVyOnZYLlMi
 bgzws6yTbablKlq7noAOGFqApek99HOrCZzAjPI9MQo3kEo6V1QOJamcczH0sjZannAE
 Eezk6TFjSTG7nNopkNq6yYwH1aVnRSpf9h3cvZCejDpwu5k+3r5QuMIGLX2AwG9gXOyz
 /7wgyZ/bkLX0ZeEYkw+AmMhXADC2mvr+iAcZjddYTPrlcLE65vPhiyAWNbjQSrKuYoPw lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35tg8qxtbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 01:15:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1051AmWZ088871;
        Tue, 5 Jan 2021 01:15:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35v1f80p5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 01:15:05 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1051F47G031860;
        Tue, 5 Jan 2021 01:15:04 GMT
Received: from localhost.localdomain (/10.159.130.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 01:15:04 +0000
Subject: Re: [kvm-unit-tests PATCH v1 05/12] lib/alloc_page: fix and improve
 the page allocator
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com, nadav.amit@gmail.com
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
 <20201216201200.255172-6-imbrenda@linux.ibm.com>
 <ddb73d1c-8dc3-50cc-e88a-7434313ade1d@oracle.com>
 <20210104141134.08b85525@ibm-vm>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <70176ea5-4b29-50f1-d1ac-3bcc74cf089a@oracle.com>
Date:   Mon, 4 Jan 2021 17:15:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210104141134.08b85525@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/4/21 5:11 AM, Claudio Imbrenda wrote:
> On Thu, 24 Dec 2020 10:17:06 -0800
> Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>
>> On 12/16/20 12:11 PM, Claudio Imbrenda wrote:
>>> This patch introduces some improvements to the code, mostly
>>> readability improvements, but also some semantic details, and
>>> improvements in the documentation.
>>>
>>> * introduce and use pfn_t to semantically tag parameters as PFNs
>>> * remove the PFN macro, use virt_to_pfn instead
>>> * rename area_or_metadata_contains and area_contains to
>>> area_contains_pfn and usable_area_contains_pfn respectively
>>> * fix/improve comments in lib/alloc_page.h
>>> * move some wrapper functions to the header
>>>
>>> Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page
>>> allocator") Fixes: 34c950651861 ("lib/alloc_page: allow reserving
>>> arbitrary memory ranges")
>>>
>>> Signed-off-by: Claudio Imbrenda<imbrenda@linux.ibm.com>
>>> ---
>>>    lib/alloc_page.h |  49 +++++++++-----
>>>    lib/alloc_page.c | 165
>>> +++++++++++++++++++++++------------------------ 2 files changed,
>>> 116 insertions(+), 98 deletions(-)
>>>
>>> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
>>> index b6aace5..d8550c6 100644
>>> --- a/lib/alloc_page.h
>>> +++ b/lib/alloc_page.h
>>> @@ -8,6 +8,7 @@
>>>    #ifndef ALLOC_PAGE_H
>>>    #define ALLOC_PAGE_H 1
>>>    
>>> +#include <stdbool.h>
>>>    #include <asm/memory_areas.h>
>>>    
>>>    #define AREA_ANY -1
>>> @@ -23,7 +24,7 @@ bool page_alloc_initialized(void);
>>>     * top_pfn is the physical frame number of the first page
>>> immediately after
>>>     * the end of the area to initialize
>>>     */
>>> -void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t
>>> top_pfn); +void page_alloc_init_area(u8 n, phys_addr_t base_pfn,
>>> phys_addr_t top_pfn);
>>>    /* Enables the page allocator. At least one area must have been
>>> initialized */ void page_alloc_ops_enable(void);
>>> @@ -37,9 +38,12 @@ void *memalign_pages_area(unsigned int areas,
>>> size_t alignment, size_t size);
>>>    /*
>>>     * Allocate aligned memory from any area.
>>> - * Equivalent to memalign_pages_area(~0, alignment, size).
>>> + * Equivalent to memalign_pages_area(AREA_ANY, alignment, size).
>>>     */
>>> -void *memalign_pages(size_t alignment, size_t size);
>>> +static inline void *memalign_pages(size_t alignment, size_t size)
>>> +{
>>> +	return memalign_pages_area(AREA_ANY, alignment, size);
>>> +}
>>>    
>>>    /*
>>>     * Allocate naturally aligned memory from the specified areas.
>>> @@ -48,16 +52,22 @@ void *memalign_pages(size_t alignment, size_t
>>> size); void *alloc_pages_area(unsigned int areas, unsigned int
>>> order);
>>>    /*
>>> - * Allocate one page from any area.
>>> - * Equivalent to alloc_pages(0);
>>> + * Allocate naturally aligned memory from any area.
>>
>> This one allocates page size memory and the comment should reflect
>> that.
> I'll fix the comment
>   
>>> + * Equivalent to alloc_pages_area(AREA_ANY, order);
>>>     */
>>> -void *alloc_page(void);
>>> +static inline void *alloc_pages(unsigned int order)
>>> +{
>>> +	return alloc_pages_area(AREA_ANY, order);
>>> +}
>>>    
>>>    /*
>>> - * Allocate naturally aligned memory from any area.
>>> - * Equivalent to alloc_pages_area(~0, order);
>>> + * Allocate one page from any area.
>>> + * Equivalent to alloc_pages(0);
>>>     */
>>> -void *alloc_pages(unsigned int order);
>>> +static inline void *alloc_page(void)
>>> +{
>>> +	return alloc_pages(0);
>>> +}
>>>    
>>>    /*
>>>     * Frees a memory block allocated with any of the memalign_pages*
>>> or @@ -66,23 +76,32 @@ void *alloc_pages(unsigned int order);
>>>     */
>>>    void free_pages(void *mem);
>>>    
>>> -/* For backwards compatibility */
>>> +/*
>>> + * Free one page.
>>> + * Equivalent to free_pages(mem).
>>> + */
>>>    static inline void free_page(void *mem)
>>>    {
>>>    	return free_pages(mem);
>>>    }
>>>    
>>> -/* For backwards compatibility */
>>> +/*
>>> + * Free pages by order.
>>> + * Equivalent to free_pages(mem).
>>> + */
>>>    static inline void free_pages_by_order(void *mem, unsigned int
>>> order) {
>>>    	free_pages(mem);
>>>    }
>>>    
>>>    /*
>>> - * Allocates and reserves the specified memory range if possible.
>>> - * Returns NULL in case of failure.
>>> + * Allocates and reserves the specified physical memory range if
>>> possible.
>>> + * If the specified range cannot be reserved in its entirety, no
>>> action is
>>> + * performed and false is returned.
>>> + *
>>> + * Returns true in case of success, false otherwise.
>>>     */
>>> -void *alloc_pages_special(uintptr_t addr, size_t npages);
>>> +bool alloc_pages_special(phys_addr_t addr, size_t npages);
>>>    
>>>    /*
>>>     * Frees a reserved memory range that had been reserved with
>>> @@ -91,6 +110,6 @@ void *alloc_pages_special(uintptr_t addr, size_t
>>> npages);
>>>     * exactly, it can also be a subset, in which case only the
>>> specified
>>>     * pages will be freed and unreserved.
>>>     */
>>> -void free_pages_special(uintptr_t addr, size_t npages);
>>> +void free_pages_special(phys_addr_t addr, size_t npages);
>>>    
>>>    #endif
>>> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
>>> index ed0ff02..8d2700d 100644
>>> --- a/lib/alloc_page.c
>>> +++ b/lib/alloc_page.c
>>> @@ -17,25 +17,29 @@
>>>    
>>>    #define IS_ALIGNED_ORDER(x,order) IS_ALIGNED((x),BIT_ULL(order))
>>>    #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
>>> -#define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
>>>    
>>>    #define ORDER_MASK	0x3f
>>>    #define ALLOC_MASK	0x40
>>>    #define SPECIAL_MASK	0x80
>>>    
>>> +typedef phys_addr_t pfn_t;
>>> +
>>>    struct mem_area {
>>>    	/* Physical frame number of the first usable frame in the
>>> area */
>>> -	uintptr_t base;
>>> +	pfn_t base;
>>>    	/* Physical frame number of the first frame outside the
>>> area */
>>> -	uintptr_t top;
>>> -	/* Combination of SPECIAL_MASK, ALLOC_MASK, and order */
>>> +	pfn_t top;
>>> +	/* Per page metadata, each entry is a combination *_MASK
>>> and order */ u8 *page_states;
>>>    	/* One freelist for each possible block size, up to
>>> NLISTS */ struct linked_list freelists[NLISTS];
>>>    };
>>>    
>>> +/* Descriptors for each possible area */
>>>    static struct mem_area areas[MAX_AREAS];
>>> +/* Mask of initialized areas */
>>>    static unsigned int areas_mask;
>>> +/* Protects areas and areas mask */
>>>    static struct spinlock lock;
>>>    
>>>    bool page_alloc_initialized(void)
>>> @@ -43,12 +47,24 @@ bool page_alloc_initialized(void)
>>>    	return areas_mask != 0;
>>>    }
>>>    
>>> -static inline bool area_or_metadata_contains(struct mem_area *a,
>>> uintptr_t pfn) +/*
>>> + * Each memory area contains an array of metadata entries at the
>>> very
>>> + * beginning. The usable memory follows immediately afterwards.
>>> + * This function returns true if the given pfn falls anywhere
>>> within the
>>> + * memory area, including the metadata area.
>>> + */
>>> +static inline bool area_contains_pfn(struct mem_area *a, pfn_t pfn)
>>>    {
>>> -	return (pfn >= PFN(a->page_states)) && (pfn < a->top);
>>> +	return (pfn >= virt_to_pfn(a->page_states)) && (pfn <
>>> a->top); }
>>>    
>>> -static inline bool area_contains(struct mem_area *a, uintptr_t pfn)
>>> +/*
>>> + * Each memory area contains an array of metadata entries at the
>>> very
>>> + * beginning. The usable memory follows immediately afterwards.
>>> + * This function returns true if the given pfn falls in the usable
>>> range of
>>> + * the given memory area.
>>> + */
>>> +static inline bool usable_area_contains_pfn(struct mem_area *a,
>>> pfn_t pfn) {
>>>    	return (pfn >= a->base) && (pfn < a->top);
>>>    }
>>> @@ -69,21 +85,19 @@ static inline bool area_contains(struct
>>> mem_area *a, uintptr_t pfn) */
>>>    static void split(struct mem_area *a, void *addr)
>>>    {
>>> -	uintptr_t pfn = PFN(addr);
>>> -	struct linked_list *p;
>>> -	uintptr_t i, idx;
>>> +	pfn_t pfn = virt_to_pfn(addr);
>>> +	pfn_t i, idx;
>>>    	u8 order;
>>>    
>>> -	assert(a && area_contains(a, pfn));
>>> +	assert(a && usable_area_contains_pfn(a, pfn));
>>>    	idx = pfn - a->base;
>>>    	order = a->page_states[idx];
>>>    	assert(!(order & ~ORDER_MASK) && order && (order <
>>> NLISTS)); assert(IS_ALIGNED_ORDER(pfn, order));
>>> -	assert(area_contains(a, pfn + BIT(order) - 1));
>>> +	assert(usable_area_contains_pfn(a, pfn + BIT(order) - 1));
>>>    
>>>    	/* Remove the block from its free list */
>>> -	p = list_remove(addr);
>>> -	assert(p);
>>> +	list_remove(addr);
>>>    
>>>    	/* update the block size for each page in the block */
>>>    	for (i = 0; i < BIT(order); i++) {
>>> @@ -92,9 +106,9 @@ static void split(struct mem_area *a, void *addr)
>>>    	}
>>>    	order--;
>>>    	/* add the first half block to the appropriate free list
>>> */
>>> -	list_add(a->freelists + order, p);
>>> +	list_add(a->freelists + order, addr);
>>>    	/* add the second half block to the appropriate free list
>>> */
>>> -	list_add(a->freelists + order, (void *)((pfn + BIT(order))
>>> * PAGE_SIZE));
>>> +	list_add(a->freelists + order, pfn_to_virt(pfn +
>>> BIT(order))); }
>>>    
>>>    /*
>>> @@ -105,7 +119,7 @@ static void split(struct mem_area *a, void
>>> *addr) */
>>>    static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
>>>    {
>>> -	struct linked_list *p, *res = NULL;
>>> +	struct linked_list *p;
>>>    	u8 order;
>>>    
>>>    	assert((al < NLISTS) && (sz < NLISTS));
>>> @@ -130,17 +144,17 @@ static void *page_memalign_order(struct
>>> mem_area *a, u8 al, u8 sz) for (; order > sz; order--)
>>>    		split(a, p);
>>>    
>>> -	res = list_remove(p);
>>> -	memset(a->page_states + (PFN(res) - a->base), ALLOC_MASK |
>>> order, BIT(order));
>>> -	return res;
>>> +	list_remove(p);
>>> +	memset(a->page_states + (virt_to_pfn(p) - a->base),
>>> ALLOC_MASK | order, BIT(order));
>>> +	return p;
>>>    }
>>>    
>>> -static struct mem_area *get_area(uintptr_t pfn)
>>> +static struct mem_area *get_area(pfn_t pfn)
>>>    {
>>>    	uintptr_t i;
>>>    
>>>    	for (i = 0; i < MAX_AREAS; i++)
>>> -		if ((areas_mask & BIT(i)) && area_contains(areas +
>>> i, pfn))
>>> +		if ((areas_mask & BIT(i)) &&
>>> usable_area_contains_pfn(areas + i, pfn)) return areas + i;
>>>    	return NULL;
>>>    }
>>> @@ -160,17 +174,16 @@ static struct mem_area *get_area(uintptr_t
>>> pfn)
>>>     * - all of the pages of the two blocks must have the same block
>>> size
>>>     * - the function is called with the lock held
>>>     */
>>> -static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn,
>>> uintptr_t pfn2) +static bool coalesce(struct mem_area *a, u8 order,
>>> pfn_t pfn, pfn_t pfn2) {
>>> -	uintptr_t first, second, i;
>>> -	struct linked_list *li;
>>> +	pfn_t first, second, i;
>>>    
>>>    	assert(IS_ALIGNED_ORDER(pfn, order) &&
>>> IS_ALIGNED_ORDER(pfn2, order)); assert(pfn2 == pfn + BIT(order));
>>>    	assert(a);
>>>    
>>>    	/* attempting to coalesce two blocks that belong to
>>> different areas */
>>> -	if (!area_contains(a, pfn) || !area_contains(a, pfn2 +
>>> BIT(order) - 1))
>>> +	if (!usable_area_contains_pfn(a, pfn) ||
>>> !usable_area_contains_pfn(a, pfn2 + BIT(order) - 1)) return false;
>>>    	first = pfn - a->base;
>>>    	second = pfn2 - a->base;
>>> @@ -179,17 +192,15 @@ static bool coalesce(struct mem_area *a, u8
>>> order, uintptr_t pfn, uintptr_t pfn2 return false;
>>>    
>>>    	/* we can coalesce, remove both blocks from their
>>> freelists */
>>> -	li = list_remove((void *)(pfn2 << PAGE_SHIFT));
>>> -	assert(li);
>>> -	li = list_remove((void *)(pfn << PAGE_SHIFT));
>>> -	assert(li);
>>> +	list_remove(pfn_to_virt(pfn2));
>>> +	list_remove(pfn_to_virt(pfn));
>>>    	/* check the metadata entries and update with the new
>>> size */ for (i = 0; i < (2ull << order); i++) {
>>>    		assert(a->page_states[first + i] == order);
>>>    		a->page_states[first + i] = order + 1;
>>>    	}
>>>    	/* finally add the newly coalesced block to the
>>> appropriate freelist */
>>> -	list_add(a->freelists + order + 1, li);
>>> +	list_add(a->freelists + order + 1, pfn_to_virt(pfn));
>>>    	return true;
>>>    }
>>>    
>>> @@ -209,7 +220,7 @@ static bool coalesce(struct mem_area *a, u8
>>> order, uintptr_t pfn, uintptr_t pfn2 */
>>>    static void _free_pages(void *mem)
>>>    {
>>> -	uintptr_t pfn2, pfn = PFN(mem);
>>> +	pfn_t pfn2, pfn = virt_to_pfn(mem);
>>>    	struct mem_area *a = NULL;
>>>    	uintptr_t i, p;
>>>    	u8 order;
>>> @@ -232,7 +243,7 @@ static void _free_pages(void *mem)
>>>    	/* ensure that the block is aligned properly for its size
>>> */ assert(IS_ALIGNED_ORDER(pfn, order));
>>>    	/* ensure that the area can contain the whole block */
>>> -	assert(area_contains(a, pfn + BIT(order) - 1));
>>> +	assert(usable_area_contains_pfn(a, pfn + BIT(order) - 1));
>>>    
>>>    	for (i = 0; i < BIT(order); i++) {
>>>    		/* check that all pages of the block have
>>> consistent metadata */ @@ -268,63 +279,68 @@ void free_pages(void
>>> *mem) spin_unlock(&lock);
>>>    }
>>>    
>>> -static void *_alloc_page_special(uintptr_t addr)
>>> +static bool _alloc_page_special(pfn_t pfn)
>>>    {
>>>    	struct mem_area *a;
>>> -	uintptr_t mask, i;
>>> +	pfn_t mask, i;
>>>    
>>> -	a = get_area(PFN(addr));
>>> -	assert(a);
>>> -	i = PFN(addr) - a->base;
>>> +	a = get_area(pfn);
>>> +	if (!a)
>>> +		return false;
>>> +	i = pfn - a->base;
>>>    	if (a->page_states[i] & (ALLOC_MASK | SPECIAL_MASK))
>>> -		return NULL;
>>> +		return false;
>>>    	while (a->page_states[i]) {
>>> -		mask = GENMASK_ULL(63, PAGE_SHIFT +
>>> a->page_states[i]);
>>> -		split(a, (void *)(addr & mask));
>>> +		mask = GENMASK_ULL(63, a->page_states[i]);
>>> +		split(a, pfn_to_virt(pfn & mask));
>>>    	}
>>>    	a->page_states[i] = SPECIAL_MASK;
>>> -	return (void *)addr;
>>> +	return true;
>>>    }
>>>    
>>> -static void _free_page_special(uintptr_t addr)
>>> +static void _free_page_special(pfn_t pfn)
>>>    {
>>>    	struct mem_area *a;
>>> -	uintptr_t i;
>>> +	pfn_t i;
>>>    
>>> -	a = get_area(PFN(addr));
>>> +	a = get_area(pfn);
>>>    	assert(a);
>>> -	i = PFN(addr) - a->base;
>>> +	i = pfn - a->base;
>>>    	assert(a->page_states[i] == SPECIAL_MASK);
>>>    	a->page_states[i] = ALLOC_MASK;
>>> -	_free_pages((void *)addr);
>>> +	_free_pages(pfn_to_virt(pfn));
>>>    }
>>>    
>>> -void *alloc_pages_special(uintptr_t addr, size_t n)
>>> +bool alloc_pages_special(phys_addr_t addr, size_t n)
>>
>> The convention for these alloc functions seems to be that of
>> returning void *. For example, alloc_pages_area(), alloc_pages() etc.
>>   Probably we should maintain the convention or change all of their
>> return type.
> what if you try to allocate memory that is not directly addressable?
> (e.g. on x86_32)
>
> you pass a phys_addr_t and it succeeds, but you can't get a pointer to
> it, how should I indicate success/failure?


The function can perhaps return an error code via a parameter to 
indicate why NULL was returned.

>
>>>    {
>>> -	uintptr_t i;
>>> +	pfn_t pfn;
>>> +	size_t i;
>>>    
>>>    	assert(IS_ALIGNED(addr, PAGE_SIZE));
>>> +	pfn = addr >> PAGE_SHIFT;
>>>    	spin_lock(&lock);
>>>    	for (i = 0; i < n; i++)
>>> -		if (!_alloc_page_special(addr + i * PAGE_SIZE))
>>> +		if (!_alloc_page_special(pfn + i))
>>
>> Can the PFN macro be used here instead of the 'pfn' variable ?
> I remove the PFN macro in this patch, also addr is not a virtual
> address.
>
>>>    			break;
>>>    	if (i < n) {
>>>    		for (n = 0 ; n < i; n++)
>>> -			_free_page_special(addr + n * PAGE_SIZE);
>>> -		addr = 0;
>>> +			_free_page_special(pfn + n);
>>> +		n = 0;
>>>    	}
>>>    	spin_unlock(&lock);
>>> -	return (void *)addr;
>>> +	return n;
>>>    }
>>>    
>>> -void free_pages_special(uintptr_t addr, size_t n)
>>> +void free_pages_special(phys_addr_t addr, size_t n)
>>>    {
>>> -	uintptr_t i;
>>> +	pfn_t pfn;
>>> +	size_t i;
>>>    
>>>    	assert(IS_ALIGNED(addr, PAGE_SIZE));
>>> +	pfn = addr >> PAGE_SHIFT;
>>>    	spin_lock(&lock);
>>>    	for (i = 0; i < n; i++)
>>> -		_free_page_special(addr + i * PAGE_SIZE);
>>> +		_free_page_special(pfn + i);
>>
>> Can the PFN macro be used here instead of the 'pfn' variable ?
> same as above
>
>>>    	spin_unlock(&lock);
>>>    }
>>>    
>>> @@ -351,11 +367,6 @@ void *alloc_pages_area(unsigned int area,
>>> unsigned int order) return page_memalign_order_area(area, order,
>>> order); }
>>>    
>>> -void *alloc_pages(unsigned int order)
>>> -{
>>> -	return alloc_pages_area(AREA_ANY, order);
>>> -}
>>> -
>>>    /*
>>>     * Allocates (1 << order) physically contiguous aligned pages.
>>>     * Returns NULL if the allocation was not possible.
>>> @@ -370,18 +381,6 @@ void *memalign_pages_area(unsigned int area,
>>> size_t alignment, size_t size) return
>>> page_memalign_order_area(area, size, alignment); }
>>>    
>>> -void *memalign_pages(size_t alignment, size_t size)
>>> -{
>>> -	return memalign_pages_area(AREA_ANY, alignment, size);
>>> -}
>>> -
>>> -/*
>>> - * Allocates one page
>>> - */
>>> -void *alloc_page()
>>> -{
>>> -	return alloc_pages(0);
>>> -}
>>>    
>>>    static struct alloc_ops page_alloc_ops = {
>>>    	.memalign = memalign_pages,
>>> @@ -416,7 +415,7 @@ void page_alloc_ops_enable(void)
>>>     * - the memory area to add does not overlap with existing areas
>>>     * - the memory area to add has at least 5 pages available
>>>     */
>>> -static void _page_alloc_init_area(u8 n, uintptr_t start_pfn,
>>> uintptr_t top_pfn) +static void _page_alloc_init_area(u8 n, pfn_t
>>> start_pfn, pfn_t top_pfn) {
>>>    	size_t table_size, npages, i;
>>>    	struct mem_area *a;
>>> @@ -437,7 +436,7 @@ static void _page_alloc_init_area(u8 n,
>>> uintptr_t start_pfn, uintptr_t top_pfn)
>>>    	/* fill in the values of the new area */
>>>    	a = areas + n;
>>> -	a->page_states = (void *)(start_pfn << PAGE_SHIFT);
>>> +	a->page_states = pfn_to_virt(start_pfn);
>>>    	a->base = start_pfn + table_size;
>>>    	a->top = top_pfn;
>>>    	npages = top_pfn - a->base;
>>> @@ -447,14 +446,14 @@ static void _page_alloc_init_area(u8 n,
>>> uintptr_t start_pfn, uintptr_t top_pfn) for (i = 0; i < MAX_AREAS;
>>> i++) { if (!(areas_mask & BIT(i)))
>>>    			continue;
>>> -		assert(!area_or_metadata_contains(areas + i,
>>> start_pfn));
>>> -		assert(!area_or_metadata_contains(areas + i,
>>> top_pfn - 1));
>>> -		assert(!area_or_metadata_contains(a,
>>> PFN(areas[i].page_states)));
>>> -		assert(!area_or_metadata_contains(a, areas[i].top
>>> - 1));
>>> +		assert(!area_contains_pfn(areas + i, start_pfn));
>>> +		assert(!area_contains_pfn(areas + i, top_pfn - 1));
>>> +		assert(!area_contains_pfn(a,
>>> virt_to_pfn(areas[i].page_states)));
>>> +		assert(!area_contains_pfn(a, areas[i].top - 1));
>>>    	}
>>>    	/* initialize all freelists for the new area */
>>>    	for (i = 0; i < NLISTS; i++)
>>> -		a->freelists[i].next = a->freelists[i].prev =
>>> a->freelists + i;
>>> +		a->freelists[i].prev = a->freelists[i].next =
>>> a->freelists + i;
>>>    	/* initialize the metadata for the available memory */
>>>    	for (i = a->base; i < a->top; i += 1ull << order) {
>>> @@ -473,13 +472,13 @@ static void _page_alloc_init_area(u8 n,
>>> uintptr_t start_pfn, uintptr_t top_pfn) assert(order < NLISTS);
>>>    		/* initialize the metadata and add to the
>>> freelist */ memset(a->page_states + (i - a->base), order,
>>> BIT(order));
>>> -		list_add(a->freelists + order, (void *)(i <<
>>> PAGE_SHIFT));
>>> +		list_add(a->freelists + order, pfn_to_virt(i));
>>>    	}
>>>    	/* finally mark the area as present */
>>>    	areas_mask |= BIT(n);
>>>    }
>>>    
>>> -static void __page_alloc_init_area(u8 n, uintptr_t cutoff,
>>> uintptr_t base_pfn, uintptr_t *top_pfn) +static void
>>> __page_alloc_init_area(u8 n, pfn_t cutoff, pfn_t base_pfn, pfn_t
>>> *top_pfn) { if (*top_pfn > cutoff) {
>>>    		spin_lock(&lock);
>>> @@ -500,7 +499,7 @@ static void __page_alloc_init_area(u8 n,
>>> uintptr_t cutoff, uintptr_t base_pfn, u
>>>     * Prerequisites:
>>>     * see _page_alloc_init_area
>>>     */
>>> -void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t
>>> top_pfn) +void page_alloc_init_area(u8 n, phys_addr_t base_pfn,
>>> phys_addr_t top_pfn) {
>>>    	if (n != AREA_ANY_NUMBER) {
>>>    		__page_alloc_init_area(n, 0, base_pfn, &top_pfn);
>>>   
