Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7AE10CD58
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 17:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfK1Q41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 11:56:27 -0500
Received: from foss.arm.com ([217.140.110.172]:38608 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfK1Q41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 11:56:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66F851FB;
        Thu, 28 Nov 2019 08:56:26 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A1623F6C4;
        Thu, 28 Nov 2019 08:56:25 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 10/18] arm/arm64: selftest: Add prefetch
 abort test
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
 <20191127142410.1994-11-alexandru.elisei@arm.com>
 <20191127184756.encuqdupgwcky6ys@kamzik.brq.redhat.com>
 <82684f76-2157-e96a-00e2-a30451619751@arm.com>
Message-ID: <cf3736f3-57eb-b8be-1ea9-e98d34f2aa9b@arm.com>
Date:   Thu, 28 Nov 2019 16:56:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <82684f76-2157-e96a-00e2-a30451619751@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/28/19 9:59 AM, Alexandru Elisei wrote:
> Hi,
>
> On 11/27/19 6:47 PM, Andrew Jones wrote:
>> On Wed, Nov 27, 2019 at 02:24:02PM +0000, Alexandru Elisei wrote:
>>> When a guest tries to execute code from MMIO memory, KVM injects an
>>> external abort into that guest. We have now fixed the psci test to not
>>> fetch instructions from the I/O region, and it's not that often that a
>>> guest misbehaves in such a way. Let's expand our coverage by adding a
>>> proper test targetting this corner case.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  lib/arm64/asm/esr.h |  3 ++
>>>  arm/selftest.c      | 97 +++++++++++++++++++++++++++++++++++++++++++--
>>>  2 files changed, 97 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
>>> index 8e5af4d90767..8c351631b0a0 100644
>>> --- a/lib/arm64/asm/esr.h
>>> +++ b/lib/arm64/asm/esr.h
>>> @@ -44,4 +44,7 @@
>>>  #define ESR_EL1_EC_BKPT32	(0x38)
>>>  #define ESR_EL1_EC_BRK64	(0x3C)
>>>  
>>> +#define ESR_EL1_FSC_MASK	(0x3F)
>>> +#define ESR_EL1_FSC_EXTABT	(0x10)
>>> +
>>>  #endif /* _ASMARM64_ESR_H_ */
>>> diff --git a/arm/selftest.c b/arm/selftest.c
>>> index e9dc5c0cab28..caad524378fc 100644
>>> --- a/arm/selftest.c
>>> +++ b/arm/selftest.c
>>> @@ -16,6 +16,8 @@
>>>  #include <asm/psci.h>
>>>  #include <asm/smp.h>
>>>  #include <asm/barrier.h>
>>> +#include <asm/mmu.h>
>>> +#include <asm/pgtable.h>
>>>  
>>>  static cpumask_t ready, valid;
>>>  
>>> @@ -68,6 +70,7 @@ static void check_setup(int argc, char **argv)
>>>  static struct pt_regs expected_regs;
>>>  static bool und_works;
>>>  static bool svc_works;
>>> +static bool pabt_works;
>>>  #if defined(__arm__)
>>>  /*
>>>   * Capture the current register state and execute an instruction
>>> @@ -91,7 +94,7 @@ static bool svc_works;
>>>  		"str	r1, [r0, #" xstr(S_PC) "]\n"		\
>>>  		excptn_insn "\n"				\
>>>  		post_insns "\n"					\
>>> -	:: "r" (&expected_regs) : "r0", "r1")
>>> +	:: "r" (&expected_regs) : "r0", "r1", "r2")
>>>  
>>>  static bool check_regs(struct pt_regs *regs)
>>>  {
>>> @@ -171,6 +174,45 @@ static void user_psci_system_off(struct pt_regs *regs)
>>>  {
>>>  	__user_psci_system_off();
>>>  }
>>> +
>>> +static void check_pabt_exit(void)
>>> +{
>>> +	install_exception_handler(EXCPTN_PABT, NULL);
>>> +
>>> +	report("pabt", pabt_works);
>>> +	exit(report_summary());
>>> +}
>>> +
>>> +static void pabt_handler(struct pt_regs *regs)
>>> +{
>>> +	expected_regs.ARM_pc = 0;
>>> +	pabt_works = check_regs(regs);
>>> +
>>> +	regs->ARM_pc = (unsigned long)&check_pabt_exit;
>>> +}
>>> +
>>> +static void check_pabt(void)
>>> +{
>>> +	unsigned long sctlr;
>>> +
>>> +	/* Make sure we can actually execute from a writable region */
>>> +	asm volatile("mrc p15, 0, %0, c1, c0, 0": "=r" (sctlr));
>>> +	if (sctlr & CR_ST) {
>>> +		sctlr &= ~CR_ST;
>>> +		asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
>>> +		isb();
>>> +		/*
>>> +		 * Required according to the sequence in ARM DDI 0406C.d, page
>>> +		 * B3-1358.
>>> +		 */
>>> +		flush_tlb_all();
>>> +	}
>>> +
>>> +	install_exception_handler(EXCPTN_PABT, pabt_handler);
>>> +
>>> +	test_exception("mov r2, #0x0", "bx r2", "");
>>> +	__builtin_unreachable();
>>> +}
>>>  #elif defined(__aarch64__)
>>>  
>>>  /*
>>> @@ -212,7 +254,7 @@ static void user_psci_system_off(struct pt_regs *regs)
>>>  		"stp	 x0,  x1, [x1]\n"			\
>>>  	"1:"	excptn_insn "\n"				\
>>>  		post_insns "\n"					\
>>> -	:: "r" (&expected_regs) : "x0", "x1")
>>> +	:: "r" (&expected_regs) : "x0", "x1", "x2")
>>>  
>>>  static bool check_regs(struct pt_regs *regs)
>>>  {
>>> @@ -288,6 +330,53 @@ static bool check_svc(void)
>>>  	return svc_works;
>>>  }
>>>  
>>> +static void check_pabt_exit(void)
>>> +{
>>> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
>>> +
>>> +	report("pabt", pabt_works);
>>> +	exit(report_summary());
>>> +}
>>> +
>>> +static void pabt_handler(struct pt_regs *regs, unsigned int esr)
>>> +{
>>> +	bool is_extabt;
>>> +
>>> +	expected_regs.pc = 0;
>>> +	is_extabt = (esr & ESR_EL1_FSC_MASK) == ESR_EL1_FSC_EXTABT;
>>> +	pabt_works = check_regs(regs) && is_extabt;
>>> +
>>> +	regs->pc = (u64)&check_pabt_exit;
>>> +}
>>> +
>>> +static void check_pabt(void)
>>> +{
>>> +	enum vector v = check_vector_prep();
>>> +	unsigned long sctlr;
>>> +
>>> +	/*
>>> +	 * According to ARM DDI 0487E.a, table D5-33, footnote c, all regions
>>> +	 * writable at EL0 are treated as PXN. Clear the user bit so we can
>>> +	 * execute code from the bottom I/O space (0G-1G) to simulate a
>>> +	 * misbehaved guest.
>>> +	 */
>>> +	mmu_clear_user(current_thread_info()->pgtable, 0);
>>> +
>>> +	/* Make sure we can actually execute from a writable region */
>>> +	sctlr = read_sysreg(sctlr_el1);
>>> +	if (sctlr & SCTLR_EL1_WXN) {
>>> +		write_sysreg(sctlr & ~SCTLR_EL1_WXN, sctlr_el1);
>>> +		isb();
>>> +		/* SCTLR_EL1.WXN is permitted to be cached in a TLB. */
>>> +		flush_tlb_all();
>>> +	}
>>> +
>>> +	install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
>>> +
>>> +	test_exception("mov x2, xzr", "br x2", "");
>>> +	__builtin_unreachable();
>>> +}
>>> +
>>>  static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
>>>  {
>>>  	__user_psci_system_off();
>>> @@ -298,7 +387,9 @@ static void check_vectors(void *arg __unused)
>>>  {
>>>  	report("und", check_und());
>>>  	report("svc", check_svc());
>>> -	if (is_user()) {
>>> +	if (!is_user()) {
>>> +		check_pabt();
>>> +	} else {
>>>  #ifdef __arm__
>>>  		install_exception_handler(EXCPTN_UND, user_psci_system_off);
>>>  #else
>>> -- 
>>> 2.20.1
>>>
>> Did you also test with QEMU? Because this new test dies on an unhandled
>> unknown exception for me. Both with KVM and with TCG, and both arm64 and
>> arm32 (KVM:aarch32 or TCG:arm).
> To my chagrin, I forgot to test it on qemu. Tried it now and indeed it causes an
> unknown exception. I'll try to figure out why it breaks on qemu and not on kvmtool.

I ran qemu under strace and it turns out that qemu registers with KVM the first
128MB (addresses 0-128MB) as two separate 64MB memory regions marked as read-only
(KVM_MEM_READONLY). When kvm-unit-tests tries to execute from address 0 it will
try to execute instruction 0x00000000, which is what I think triggers the unknown
exception.

I have tested this by modifying the address used to cause a prefetch abort, and
with another address the test passes on both qemu and kvmtool. I'll spin a v2 with
the fix.

Thanks,
Alex
> Thanks,
> Alex
>> Thanks,
>> drew
>>
