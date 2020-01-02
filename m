Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D460012E9C3
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 19:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgABSL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 13:11:26 -0500
Received: from foss.arm.com ([217.140.110.172]:49166 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgABSLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 13:11:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BD90328;
        Thu,  2 Jan 2020 10:11:25 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C70B3F703;
        Thu,  2 Jan 2020 10:11:24 -0800 (PST)
Date:   Thu, 2 Jan 2020 18:11:21 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200102181121.6895344d@donnerap.cambridge.arm.com>
In-Reply-To: <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
        <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Dec 2019 16:09:37 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
> done by setting the entry point for the CPU_ON call to the physical address
> of the C function cpu_psci_cpu_die.
> 
> The compiler is well within its rights to use the stack when generating
> code for cpu_psci_cpu_die.

I am a bit puzzled: Is this an actual test failure at the moment? Or just a potential problem? Because I see it using the stack pointer in the generated code in lib/arm/psci.o. But the psci test seems to pass. Or is that just because the SP is somehow not cleared, because of some KVM implementation specifics?

One more thing below ...

>  However, because no stack initialization has
> been done, the stack pointer is zero, as set by KVM when creating the VCPU.
> This causes a data abort without a change in exception level. The VBAR_EL1
> register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
> and we end up trying to fetch instructions from address 0x200.
> 
> At this point, a stage 2 instruction abort is generated which is taken to
> KVM. KVM interprets this as an instruction fetch from an I/O region, and
> injects a prefetch abort into the guest. Prefetch abort is a synchronous
> exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
> which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
> abort while fetching the instruction to service the said abort.
> 
> cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
> provide an assembly implementation for the function which will serve as the
> entry point for CPU_ON.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S   | 7 +++++++
>  arm/cstart64.S | 7 +++++++
>  arm/psci.c     | 5 +++--
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 2c81d39a666b..dfef48e4dbb2 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -7,6 +7,7 @@
>   */
>  #define __ASSEMBLY__
>  #include <auxinfo.h>
> +#include <linux/psci.h>
>  #include <asm/thread_info.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/pgtable-hwdef.h>
> @@ -139,6 +140,12 @@ secondary_entry:
>  	blx	r0
>  	b	do_idle
>  
> +.global asm_cpu_psci_cpu_die
> +asm_cpu_psci_cpu_die:
> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> +	hvc	#0
> +	b	.

I am wondering if this implementation is actually too simple. Both the current implementation and the kernel clear at least the first three arguments to 0.
I failed to find a requirement for doing this (nothing in the SMCCC or the PSCI spec), but I guess it would make sense when looking at forward compatibility.

At the very least it's a change in behaviour (ignoring the missing printf).
So shall we just clear r1, r2 and r3 here? (Same for arm64 below)

Cheers,
Andre

> +
>  .globl halt
>  halt:
>  1:	wfi
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index b0e8baa1a23a..c98842f11e90 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -7,6 +7,7 @@
>   */
>  #define __ASSEMBLY__
>  #include <auxinfo.h>
> +#include <linux/psci.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/ptrace.h>
>  #include <asm/processor.h>
> @@ -128,6 +129,12 @@ secondary_entry:
>  	blr	x0
>  	b	do_idle
>  
> +.globl asm_cpu_psci_cpu_die
> +asm_cpu_psci_cpu_die:
> +	ldr	x0, =PSCI_0_2_FN_CPU_OFF
> +	hvc	#0
> +	b	.
> +
>  .globl halt
>  halt:
>  1:	wfi
> diff --git a/arm/psci.c b/arm/psci.c
> index 5c1accb6cea4..c45a39c7d6e8 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -72,6 +72,7 @@ static int cpu_on_ret[NR_CPUS];
>  static cpumask_t cpu_on_ready, cpu_on_done;
>  static volatile int cpu_on_start;
>  
> +extern void asm_cpu_psci_cpu_die(void);
>  static void cpu_on_secondary_entry(void)
>  {
>  	int cpu = smp_processor_id();
> @@ -79,7 +80,7 @@ static void cpu_on_secondary_entry(void)
>  	cpumask_set_cpu(cpu, &cpu_on_ready);
>  	while (!cpu_on_start)
>  		cpu_relax();
> -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
>  	cpumask_set_cpu(cpu, &cpu_on_done);
>  }
>  
> @@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
>  	cpu_on_start = 1;
>  	smp_mb();
>  
> -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
>  	cpumask_set_cpu(0, &cpu_on_done);
>  
>  	while (!cpumask_full(&cpu_on_done))

