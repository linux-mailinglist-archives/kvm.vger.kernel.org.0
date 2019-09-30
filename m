Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E19C23F1
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbfI3PJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:09:57 -0400
Received: from foss.arm.com ([217.140.110.172]:56552 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbfI3PJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:09:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 289D728;
        Mon, 30 Sep 2019 08:09:56 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38C553F706;
        Mon, 30 Sep 2019 08:09:55 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, mark.rutland@arm.com,
        andre.przywara@arm.com
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-3-alexandru.elisei@arm.com>
 <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a33705e8-fd12-86db-be64-dca9900a5555@arm.com>
Date:   Mon, 30 Sep 2019 16:09:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/30/19 3:53 PM, Andrew Jones wrote:

> On Mon, Sep 30, 2019 at 03:25:07PM +0100, Alexandru Elisei wrote:
>> The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
>> (EL0, on arm64, or PL0, on arm) can read and write from that memory
>> location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
>> when is set [3]. Add a function to clear the bit which we can use when we
>> want to execute code from that page or the prevent access from lower
>> exception levels.
>>
>> Make it available to arm too, in case someone needs it at some point.
>>
>> [1] ARM DDI 0406C.d, Table B3-6
>> [2] ARM DDI 0487E.a, table D5-28
>> [3] ARM DDI 0487E.a, table D5-33
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>   lib/arm/asm/mmu-api.h |  1 +
>>   lib/arm/mmu.c         | 15 +++++++++++++++
>>   2 files changed, 16 insertions(+)
>>
>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
>> index df3ccf7bc7e0..8fe85ba31ec9 100644
>> --- a/lib/arm/asm/mmu-api.h
>> +++ b/lib/arm/asm/mmu-api.h
>> @@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>>   extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>>   			       phys_addr_t phys_start, phys_addr_t phys_end,
>>   			       pgprot_t prot);
>> +extern void mmu_clear_user(unsigned long vaddr);
>>   #endif
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 3d38c8397f5a..78db22e6af14 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>>   	assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
>>   	return addr;
>>   }
>> +
>> +void mmu_clear_user(unsigned long vaddr)
>> +{
>> +	pgd_t *pgtable;
>> +	pteval_t *pte;
>> +
>> +	if (!mmu_enabled())
>> +		return;
>> +
>> +	pgtable = current_thread_info()->pgtable;
>> +	pte = get_pte(pgtable, vaddr);
>> +
>> +	*pte &= ~PTE_USER;
>> +	flush_tlb_page(vaddr);
>> +}
>> -- 
>> 2.20.1
>>
> This is fine, but I think you could just export get_pte() and then
> implement the PTE_USER clearing in the cache unit test instead. Anyway,

I thought about that, but I opted to make this a library function 
because I would like to modify it to also act on block mappings and use 
it in patch #4 from the EL2 series (the patch that adds the prefetch 
abort test), and send that change as part of the EL2 series. I am 
assuming that this patch set will get merged before the EL2 series.

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
