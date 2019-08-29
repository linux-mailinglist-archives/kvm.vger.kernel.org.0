Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58D2A13E0
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfH2IhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:37:00 -0400
Received: from foss.arm.com ([217.140.110.172]:40696 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfH2Ig7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:36:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24C8D28;
        Thu, 29 Aug 2019 01:36:59 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BD0D3F246;
        Thu, 29 Aug 2019 01:36:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 14/16] lib: arm64: Add support for
 disabling and re-enabling VHE
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        andre.przywara@arm.com, pbonzini@redhat.com
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-15-git-send-email-alexandru.elisei@arm.com>
 <20190828141927.GD41023@lakrids.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <0b6c5a95-b8ea-f034-0826-ceb67d0a0ff4@arm.com>
Date:   Thu, 29 Aug 2019 09:36:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828141927.GD41023@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/28/19 3:19 PM, Mark Rutland wrote:
> On Wed, Aug 28, 2019 at 02:38:29PM +0100, Alexandru Elisei wrote:
>> Add a function to disable VHE and another one to re-enable VHE. Both
>> functions work under the assumption that the CPU had VHE mode enabled at
>> boot.
>>
>> Minimal support to run with VHE has been added to the TLB invalidate
>> functions and to the exception handling code.
>>
>> Since we're touch the assembly enable/disable MMU code, let's take this
>> opportunity to replace a magic number with the proper define.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm/asm/processor.h       |   8 ++
>>  lib/arm64/asm/mmu.h           |  11 ++-
>>  lib/arm64/asm/pgtable-hwdef.h |  53 +++++++++---
>>  lib/arm64/asm/processor.h     |  44 +++++++++-
>>  lib/arm/processor.c           |  11 +++
>>  lib/arm/setup.c               |   2 +
>>  lib/arm64/processor.c         |  67 ++++++++++++++-
>>  arm/cstart64.S                | 186 +++++++++++++++++++++++++++++++++++++++++-
>>  8 files changed, 364 insertions(+), 18 deletions(-)
>> +extern void asm_disable_vhe(void);
>> +void disable_vhe(void)
>> +{
>> +	u64 sp, sp_phys, sp_base, sp_base_phys;
>> +
>> +	assert(current_level() == CurrentEL_EL2 && vhe_enabled());
>> +
>> +	sp = current_stack_pointer;
>> +	sp_phys = __virt_to_phys(sp);
>> +	sp_base = sp & THREAD_MASK;
>> +	sp_base_phys = sp_phys & THREAD_MASK;
>> +
>> +	/*
>> +	 * We will disable, then enable the MMU, make sure the exception
>> +	 * handling code works during the small window of time when the MMU is
>> +	 * off.
>> +	 */
>> +	dcache_clean_inval_range(sp_base, sp_base + THREAD_SIZE);
>> +	dcache_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
>> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp_phys));
>> +
>> +	asm_disable_vhe();
>> +
>> +	dcache_clean_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
>> +	dcache_inval_range(sp_base, sp_base + THREAD_SIZE);
>> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp));
>> +}
> This sequence is not safe. The compiler can spill/reload at any point,
> and the CPU can allocate (clean) lines into the cache while the MMU is
> enabled.
>
> I think you need to move the entire sequence to assembly, and should
> perform any cache maintenance while the MMU is off.

You are correct. I was being extra careful here. The fact is, the stack isn't
used at all when the MMU is off. The only way the stack would get used if an
exception is triggered, and that can only happen if we mess up our code. I'll
remove the stack pointer swap, and make sure that interrupts are disabled.

>
>> +extern void asm_enable_vhe(void);
>> +void enable_vhe(void)
>> +{
>> +	u64 sp, sp_phys, sp_base, sp_base_phys;
>> +
>> +	assert(current_level() == CurrentEL_EL2 && !vhe_enabled());
>> +
>> +	sp = current_stack_pointer;
>> +	sp_phys = __virt_to_phys(sp);
>> +	sp_base = sp & THREAD_MASK;
>> +	sp_base_phys = sp_phys & THREAD_MASK;
>> +
>> +	dcache_clean_inval_range(sp_base, sp_base + THREAD_SIZE);
>> +	dcache_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
>> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp_phys));
>> +
>> +	asm_enable_vhe();
>> +
>> +	dcache_clean_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
>> +	dcache_inval_range(sp_base, sp_base + THREAD_SIZE);
>> +	asm volatile(	"mov	sp, %0\n" : :"r" (sp));
>> +}
> Likewise.
>
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index d4b20267a7a6..dc9e634e2307 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -104,6 +104,13 @@ exceptions_init:
>>  
>>  .text
>>  
>> +exceptions_init_nvhe:
>> +	adrp	x0, vector_table_nvhe
>> +	add	x0, x0, :lo12:vector_table_nvhe
>> +	msr	vbar_el2, x0
>> +	isb
>> +	ret
>> +
>>  .globl get_mmu_off
>>  get_mmu_off:
>>  	adrp	x0, auxinfo
>> @@ -204,7 +211,7 @@ asm_mmu_enable:
>>  		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
>>  		     TCR_SHARED
>>  	mrs	x2, id_aa64mmfr0_el1
>> -	bfi	x1, x2, #32, #3
>> +	bfi	x1, x2, #TCR_EL1_IPS_SHIFT, #3
>>  	msr	tcr_el1, x1
>>  
>>  	/* MAIR */
>> @@ -229,6 +236,33 @@ asm_mmu_enable:
>>  
>>  	ret
>>  
>> +asm_mmu_enable_nvhe:
>> +	ic      iallu
>> +	tlbi    alle2is
>> +	dsb     ish
> why is the IC local, but the TLBI broadcast?
>
> If this only needs ot be local, a DSB NSH will be sufficient.

That's a good question. This part was directly copied from the existing function
asm_mmu_enable. As far as I can tell, the TLBI and DSB should be local when
enabling the MMU. We should only need the inner shareable versions of the
operations (followed by an isb) when we modify the translation table used by all
CPUs.

>
> Thanks,
> Mark.
