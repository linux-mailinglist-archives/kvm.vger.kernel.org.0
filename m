Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEC363A13A
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 07:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiK1GbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 01:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiK1GbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 01:31:14 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBB0812D35;
        Sun, 27 Nov 2022 22:31:12 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4CEFD6E;
        Sun, 27 Nov 2022 22:31:18 -0800 (PST)
Received: from [10.162.40.16] (unknown [10.162.40.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37BF83F73D;
        Sun, 27 Nov 2022 22:31:08 -0800 (PST)
Message-ID: <d3bcb8e1-cbf0-e820-47cf-f455128c597a@arm.com>
Date:   Mon, 28 Nov 2022 12:01:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] s390/mm: Use pmd_pgtable_page() helper in
 __gmap_segment_gaddr()
Content-Language: en-US
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221125034502.1559986-1-anshuman.khandual@arm.com>
 <Y4IvaRNLmASfRJiZ@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Y4IvaRNLmASfRJiZ@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/28/22 11:37, Alexander Gordeev wrote:
> On Fri, Nov 25, 2022 at 09:15:02AM +0530, Anshuman Khandual wrote:
> 
> Hi Anshuman,
> 
>> In __gmap_segment_gaddr() pmd level page table page is being extracted from
>> the pmd pointer, similar to pmd_pgtable_page() implementation. This reduces
>> some redundancy by directly using pmd_pgtable_page() instead,  though first
>> making it available.
> 
> [...]
> 
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index 02d15c8dc92e..8947451ae021 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -336,12 +336,11 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
>>  static unsigned long __gmap_segment_gaddr(unsigned long *entry)
>>  {
>>  	struct page *page;
>> -	unsigned long offset, mask;
>> +	unsigned long offset;
>>  
>>  	offset = (unsigned long) entry / sizeof(unsigned long);
>>  	offset = (offset & (PTRS_PER_PMD - 1)) * PMD_SIZE;
>> -	mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>> -	page = virt_to_page((void *)((unsigned long) entry & mask));
>> +	page = pmd_pgtable_page((pmd_t *) entry);
>>  	return page->index + offset;
>>  }
> 
> Looks okay to me.
> 
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e9e387caffac..5ead9e997510 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2403,7 +2403,7 @@ static inline void pgtable_pte_page_dtor(struct page *page)
>>  
>>  #if USE_SPLIT_PMD_PTLOCKS
>>  
>> -static struct page *pmd_pgtable_page(pmd_t *pmd)
>> +static inline struct page *pmd_pgtable_page(pmd_t *pmd)
>>  {
>>  	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>>  	return virt_to_page((void *)((unsigned long) pmd & mask));
> 
> This chunk does not appear to belong to this patch.

Should not this helper be made a 'static inline' before using it else where ?
