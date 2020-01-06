Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851B51310B8
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgAFKmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:42:04 -0500
Received: from foss.arm.com ([217.140.110.172]:42702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAFKmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:42:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FE72328;
        Mon,  6 Jan 2020 02:42:01 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70B0E3F534;
        Mon,  6 Jan 2020 02:42:00 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C code
 without stack or vectors
To:     Andre Przywara <andre.przywara@arm.com>, mark.rutland@arm.com
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <61ea7391-7e65-4548-17b6-7dbd977fa394@arm.com>
Date:   Mon, 6 Jan 2020 10:41:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200102181121.6895344d@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

Thank you for reviewing the patches!

On 1/2/20 6:11 PM, Andre Przywara wrote:
> On Tue, 31 Dec 2019 16:09:37 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
>> done by setting the entry point for the CPU_ON call to the physical address
>> of the C function cpu_psci_cpu_die.
>>
>> The compiler is well within its rights to use the stack when generating
>> code for cpu_psci_cpu_die.
> I am a bit puzzled: Is this an actual test failure at the moment? Or just a potential problem? Because I see it using the stack pointer in the generated code in lib/arm/psci.o. But the psci test seems to pass. Or is that just because the SP is somehow not cleared, because of some KVM implementation specifics?

The test checks for the return value of the CPU_ON function. What the CPU does
while it's live is inconsequential.

> One more thing below ...
>
>>  However, because no stack initialization has
>> been done, the stack pointer is zero, as set by KVM when creating the VCPU.
>> This causes a data abort without a change in exception level. The VBAR_EL1
>> register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
>> and we end up trying to fetch instructions from address 0x200.
>>
>> At this point, a stage 2 instruction abort is generated which is taken to
>> KVM. KVM interprets this as an instruction fetch from an I/O region, and
>> injects a prefetch abort into the guest. Prefetch abort is a synchronous
>> exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
>> which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
>> abort while fetching the instruction to service the said abort.
>>
>> cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
>> provide an assembly implementation for the function which will serve as the
>> entry point for CPU_ON.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/cstart.S   | 7 +++++++
>>  arm/cstart64.S | 7 +++++++
>>  arm/psci.c     | 5 +++--
>>  3 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/cstart.S b/arm/cstart.S
>> index 2c81d39a666b..dfef48e4dbb2 100644
>> --- a/arm/cstart.S
>> +++ b/arm/cstart.S
>> @@ -7,6 +7,7 @@
>>   */
>>  #define __ASSEMBLY__
>>  #include <auxinfo.h>
>> +#include <linux/psci.h>
>>  #include <asm/thread_info.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/pgtable-hwdef.h>
>> @@ -139,6 +140,12 @@ secondary_entry:
>>  	blx	r0
>>  	b	do_idle
>>  
>> +.global asm_cpu_psci_cpu_die
>> +asm_cpu_psci_cpu_die:
>> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
>> +	hvc	#0
>> +	b	.
> I am wondering if this implementation is actually too simple. Both the current implementation and the kernel clear at least the first three arguments to 0.
> I failed to find a requirement for doing this (nothing in the SMCCC or the PSCI spec), but I guess it would make sense when looking at forward compatibility.

The SMC calling convention only specifies the values for the arguments that are
used by a function, not the values for all possible arguments. kvm-unit-tests sets
the other arguments to 0 because the function prototype that does the actual SMC
call takes 4 arguments. The value 0 is a random value that was chosen for those
unused parameters. For example, it could have been a random number on each call.

Let me put it another way. Suggesting that unused arguments should be set to 0 is
the same as suggesting that normal C function that adheres to procedure call
standard for arm64 should always have 8 arguments, and for a particular function
that doesn't use all of them, they should be set to 0 by the caller.

@Mark Rutland has worked on the SMC implementation for the Linux kernel, if he
wants to chime in on this.

Thanks,
Alex
> At the very least it's a change in behaviour (ignoring the missing printf).
> So shall we just clear r1, r2 and r3 here? (Same for arm64 below)
>
> Cheers,
> Andre
>
>> +
>>  .globl halt
>>  halt:
>>  1:	wfi
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index b0e8baa1a23a..c98842f11e90 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -7,6 +7,7 @@
>>   */
>>  #define __ASSEMBLY__
>>  #include <auxinfo.h>
>> +#include <linux/psci.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/ptrace.h>
>>  #include <asm/processor.h>
>> @@ -128,6 +129,12 @@ secondary_entry:
>>  	blr	x0
>>  	b	do_idle
>>  
>> +.globl asm_cpu_psci_cpu_die
>> +asm_cpu_psci_cpu_die:
>> +	ldr	x0, =PSCI_0_2_FN_CPU_OFF
>> +	hvc	#0
>> +	b	.
>> +
>>  .globl halt
>>  halt:
>>  1:	wfi
>> diff --git a/arm/psci.c b/arm/psci.c
>> index 5c1accb6cea4..c45a39c7d6e8 100644
>> --- a/arm/psci.c
>> +++ b/arm/psci.c
>> @@ -72,6 +72,7 @@ static int cpu_on_ret[NR_CPUS];
>>  static cpumask_t cpu_on_ready, cpu_on_done;
>>  static volatile int cpu_on_start;
>>  
>> +extern void asm_cpu_psci_cpu_die(void);
>>  static void cpu_on_secondary_entry(void)
>>  {
>>  	int cpu = smp_processor_id();
>> @@ -79,7 +80,7 @@ static void cpu_on_secondary_entry(void)
>>  	cpumask_set_cpu(cpu, &cpu_on_ready);
>>  	while (!cpu_on_start)
>>  		cpu_relax();
>> -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
>> +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
>>  	cpumask_set_cpu(cpu, &cpu_on_done);
>>  }
>>  
>> @@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
>>  	cpu_on_start = 1;
>>  	smp_mb();
>>  
>> -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
>> +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
>>  	cpumask_set_cpu(0, &cpu_on_done);
>>  
>>  	while (!cpumask_full(&cpu_on_done))
