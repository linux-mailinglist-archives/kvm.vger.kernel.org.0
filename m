Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50242A0A8A
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgJ3P77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:59:59 -0400
Received: from foss.arm.com ([217.140.110.172]:38464 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJ3P77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 11:59:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1738F1435;
        Fri, 30 Oct 2020 08:59:47 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 522143F719;
        Fri, 30 Oct 2020 08:59:46 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 4/5] lib: arm/arm64: Add function to
 unmap a page
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, Andrew Jones <drjones@redhat.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-5-alexandru.elisei@arm.com>
 <a4ea8427-2894-12b3-7b63-e551eec57a96@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3e0f4f35-12d2-6d47-dd06-a42d3c194c9e@arm.com>
Date:   Fri, 30 Oct 2020 16:00:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a4ea8427-2894-12b3-7b63-e551eec57a96@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 10/30/20 3:46 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 10/27/20 6:19 PM, Alexandru Elisei wrote:
>> Being able to cause a stage 1 data abort might be useful for future tests.
>> Add a function that unmaps a page from the translation tables.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm/asm/mmu-api.h |  1 +
>>  lib/arm/mmu.c         | 32 ++++++++++++++++++++++++++++++++
>>  2 files changed, 33 insertions(+)
>>
>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
>> index 2bbe1faea900..305f77c6501f 100644
>> --- a/lib/arm/asm/mmu-api.h
>> +++ b/lib/arm/asm/mmu-api.h
>> @@ -23,4 +23,5 @@ extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>>  			       phys_addr_t phys_start, phys_addr_t phys_end,
>>  			       pgprot_t prot);
>>  extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
>> +extern void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr);
>>  #endif
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 540a1e842d5b..72ac0be8d146 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -232,3 +232,35 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>>  out_flush_tlb:
>>  	flush_tlb_page(vaddr);
>>  }
>> +
>> +void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr)
>> +{
>> +	pgd_t *pgd;
>> +	pmd_t *pmd;
>> +	pte_t *pte;
>> +
>> +	if (!mmu_enabled())
>> +		return;
>> +
>> +	pgd = pgd_offset(pgtable, vaddr);
>> +	if (!pgd_valid(*pgd))
>> +		return;
>> +
>> +	pmd = pmd_offset(pgd, vaddr);
>> +	if (!pmd_valid(*pmd))
>> +		return;
>> +
>> +	if (pmd_huge(*pmd)) {
>> +		WRITE_ONCE(*pmd, 0);
>> +		goto out_flush_tlb;
>> +	} else {
> is the else needed?

No, not needed. Will remove.

>> +		pte = pte_offset(pmd, vaddr);
>> +		if (!pte_valid(*pte))
>> +			return;
>> +		WRITE_ONCE(*pte, 0);
>> +		goto out_flush_tlb;
>> +	}
>> +
>> +out_flush_tlb:
>> +	flush_tlb_page(vaddr);
>> +}
>>
> This code is very similar to mmu_clear_user() besides the bit to invalidate
> Just wondering if we couldn't use the same code and pass a bit offset.
> It seems the offsets in PMD and PTE are same for USER bit and valid bit.

Yes, I will look into it and see what I can come up with.

>
> But maybe this is far-fetched and not worth the sharing.
> I see Drew is not in CC, + Drew

Yeah... I somehow missed adding Drew to CC for the entire series.

>
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,

Alex

>
> Thanks
>
> Eric
>
