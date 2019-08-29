Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680B8A1381
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH2ISi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:18:38 -0400
Received: from foss.arm.com ([217.140.110.172]:40498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfH2ISi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:18:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C78728;
        Thu, 29 Aug 2019 01:18:37 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D0483F246;
        Thu, 29 Aug 2019 01:18:36 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add
 prefetch abort test
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        andre.przywara@arm.com, pbonzini@redhat.com
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
 <20190828140925.GC41023@lakrids.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e6b8a3c9-2e11-c806-da5b-8b66d8f63ce3@arm.com>
Date:   Thu, 29 Aug 2019 09:18:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828140925.GC41023@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/28/19 3:09 PM, Mark Rutland wrote:
> On Wed, Aug 28, 2019 at 02:38:19PM +0100, Alexandru Elisei wrote:
>> When a guest tries to execute code from MMIO memory, KVM injects an
>> external abort into that guest. We have now fixed the psci test to not
>> fetch instructions from the I/O region, and it's not that often that a
>> guest misbehaves in such a way. Let's expand our coverage by adding a
>> proper test targetting this corner case.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>> The fault injection path is broken for nested guests [1]. You can use the
>> last patch from the thread [2] to successfully run the test at EL2.
>>
>> [1] https://www.spinics.net/lists/arm-kernel/msg745391.html
>> [2] https://www.spinics.net/lists/arm-kernel/msg750310.html
>>
>>  lib/arm64/asm/esr.h |  3 ++
>>  arm/selftest.c      | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 96 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
>> index 8e5af4d90767..8c351631b0a0 100644
>> --- a/lib/arm64/asm/esr.h
>> +++ b/lib/arm64/asm/esr.h
>> @@ -44,4 +44,7 @@
>>  #define ESR_EL1_EC_BKPT32	(0x38)
>>  #define ESR_EL1_EC_BRK64	(0x3C)
>>  
>> +#define ESR_EL1_FSC_MASK	(0x3F)
>> +#define ESR_EL1_FSC_EXTABT	(0x10)
>> +
>>  #endif /* _ASMARM64_ESR_H_ */
>> diff --git a/arm/selftest.c b/arm/selftest.c
>> index 176231f32ee1..18cc0ad8f729 100644
>> --- a/arm/selftest.c
>> +++ b/arm/selftest.c
>> @@ -16,6 +16,8 @@
>>  #include <asm/psci.h>
>>  #include <asm/smp.h>
>>  #include <asm/barrier.h>
>> +#include <asm/mmu.h>
>> +#include <asm/pgtable.h>
>>  
>>  static void __user_psci_system_off(void)
>>  {
>> @@ -60,9 +62,38 @@ static void check_setup(int argc, char **argv)
>>  		report_abort("missing input");
>>  }
>>  
>> +extern pgd_t *mmu_idmap;
>> +static void prep_io_exec(void)
>> +{
>> +	pgd_t *pgd = pgd_offset(mmu_idmap, 0);
>> +	unsigned long sctlr;
>> +
>> +	/*
>> +	 * AArch64 treats all regions writable at EL0 as PXN.
> I didn't think that was the case, and I can't find wording to that
> effect in the ARM ARM (looking at ARM DDI 0487E.a). Where is that
> stated?

It's in ARM DDI 0487E.a, table D5-33, footnote c: "Not executable, because
AArch64 execution treats all regions writable at EL0 as being PXN". I'll update
the comment to include the quote.

>
>> Clear the user bit
>> +	 * so we can execute code from the bottom I/O space (0G-1G) to simulate
>> +	 * a misbehaved guest.
>> +	 */
>> +	pgd_val(*pgd) &= ~PMD_SECT_USER;
>> +	flush_dcache_addr((unsigned long)pgd);
> The virtualization extensions imply coherent page table walks, so I
> don't think the cache maintenance is necessary (provided
> TCR_EL1.{SH*,ORGN*,IRGN*} are configured appropriately.

I was following the pattern from lib/arm/mmu.c. You are correct, and Linux
doesn't do any dcache maintenance either (judging by looking at both set_pte
(for arm64) and various implementations for set_pte_ext (for armv7)).

For future reference, ARM DDI 0487E.a, in section D13.2.72, states about the
ID_MMFR3_EL1 register:

"CohWalk, bits [23:20]

Coherent Walk. Indicates whether Translation table updates require a clean to
the Point of Unification. Defined values are:
0b0000 Updates to the translation tables require a clean to the Point of
Unification to ensure visibility by subsequent translation table walks.
0b0001 Updates to the translation tables do not require a clean to the Point of
Unification to ensure visibility by subsequent translation table walks.

In Armv8-A the only permitted value is 0b0001."

For armv7, ARM DDI 0406C.d states in section B3.3.1 Translation table walks:

"If an implementation includes the Multiprocessing Extensions, translation table
walks must access data or unified caches, or data and unified caches, of other
agents participating in the coherency protocol, according to the shareability
attributes described in the  TTBR. These shareability attributes must be
consistent with the shareability attributes for the translation tables themselves."

and in section B1.7 that virtualization extensions require the multiprocessing
extensions.

So the dcache maintenance operations are not needed, I'll remove them, thank you
for pointing this out.

Thanks,
Alex
>
>> +	flush_tlb_page(0);
>> +
>> +	/* Make sure we can actually execute from a writable region */
>> +#ifdef __arm__
>> +	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
>> +	sctlr &= ~CR_ST;
>> +	asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
>> +#else
>> +	sctlr = read_sysreg(sctlr_el1);
>> +	sctlr &= ~SCTLR_EL1_WXN;
>> +	write_sysreg(sctlr, sctlr_el1);
>> +#endif
>> +	isb();
>> +}
> Thanks,
> Mark.
