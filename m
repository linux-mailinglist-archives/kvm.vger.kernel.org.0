Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4086EA8A5
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjDUKw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 06:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjDUKw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 06:52:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 937FD83FC
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 03:52:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08FB61480;
        Fri, 21 Apr 2023 03:53:38 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B1CA3F587;
        Fri, 21 Apr 2023 03:52:52 -0700 (PDT)
Date:   Fri, 21 Apr 2023 11:52:45 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 4/6] arm: pmu: Fix chain counter
 enable/disable sequences
Message-ID: <ZEJq_XNHi8Mx3CBy@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-5-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110725.1215523-5-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Mar 15, 2023 at 12:07:23PM +0100, Eric Auger wrote:
> In some ARM ARM ddi0487 revisions it is said that
> disabling/enabling a pair of counters that are paired
> by a CHAIN event should follow a given sequence:
> 
> Disable the low counter first, isb, disable the high counter
> Enable the high counter first, isb, enable low counter
> 
> This was the case in Fc. However this is not written anymore
> in Ia revision.
> 
> Introduce 2 helpers to execute those sequences and replace
> the existing PMCNTENCLR/ENSET calls.
> 
> Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
> and replace them by PMCNTENCLR writes since writing 0 in
> PMCNTENSET_EL0 has no effect.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index dde399e2..af679667 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -730,6 +730,22 @@ static void test_chained_sw_incr(bool unused)
>  		    read_regn_el0(pmevcntr, 0), \
>  		    read_sysreg(pmovsclr_el0))
>  
> +static void enable_chain_counter(int even)
> +{
> +	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the high counter first */
> +	isb();
> +	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the low counter */
> +	isb();
> +}

In ARM DDI 0487F.b, at the bottom of page D7-2727:

"When enabling a pair of counters that are paired by a CHAIN event,
software must:

1. Enable the high counter, by setting PMCNTENCLR_EL0[n+1] to 0 and, if
necessary, setting PMCR_EL0.E to 1.
2. Execute an ISB instruction, or perform another Context synchronization
event.
3. Enable the low counter by setting PMCNTENCLR_EL0[n] to 0."

Which matches the commit message, but not the code above. Am I
misunderstanding what is the high and low counter? In the example from the
Arm ARM, just before the snippet above, the odd numbered countered is
called the high counter.

CHAIN is also defined as:

[..] the odd-numbered event counter n+1 increments when an event increments
the preceding even-numbered counter n on the same PE and causes an unsigned
overflow of bits [31:0] of event counter n.

So it would make sense to enable the odd counter first, then the even, so
no overflows are missed if the sequence was the other way around (even
counter enabled; overflow missed because odd counter disabled; odd counter
enabled).

Same observation with disable_chain_counter().

> +
> +static void disable_chain_counter(int even)
> +{
> +	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the low counter first*/
> +	isb();
> +	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the high counter */
> +	isb();
> +}
> +
>  static void test_chain_promotion(bool unused)
>  {
>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
> @@ -768,16 +784,17 @@ static void test_chain_promotion(bool unused)
>  	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
>  	report_prefix_push("subtest3");
>  	pmu_reset();
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
> -	isb();
> +	enable_chain_counter(0);
>  	PRINT_REGS("init");
>  
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
>  	/* disable the CHAIN event */
> -	write_sysreg_s(0x2, PMCNTENCLR_EL0);
> +	disable_chain_counter(0);
> +	write_sysreg_s(0x1, PMCNTENSET_EL0); /* Enable the low counter */
> +	isb();
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 2d loop");
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
> @@ -798,9 +815,11 @@ static void test_chain_promotion(bool unused)
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
> -	/* enable the CHAIN event */
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	/* Disable the even counter and enable the chain counter */
> +	write_sysreg_s(0x1, PMCNTENCLR_EL0); /* Disable the low counter first */

The comment says disable the even counter, but the odd counter is disabled.
Which Arm ARM refers to as the high counter. I'm properly confused about
the naming.

Thanks,
Alex

>  	isb();
> +	enable_chain_counter(0);
> +
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  
>  	PRINT_REGS("After 2d loop");
> @@ -824,10 +843,10 @@ static void test_chain_promotion(bool unused)
>  	PRINT_REGS("After 1st loop");
>  
>  	/* 0 becomes CHAINED */
> -	write_sysreg_s(0x0, PMCNTENSET_EL0);
> +	write_sysreg_s(0x3, PMCNTENCLR_EL0);
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 1, 0x0);
> +	enable_chain_counter(0);
>  
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 2d loop");
> @@ -843,13 +862,13 @@ static void test_chain_promotion(bool unused)
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	enable_chain_counter(0);
>  	PRINT_REGS("init");
>  
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
> -	write_sysreg_s(0x0, PMCNTENSET_EL0);
> +	disable_chain_counter(0);
>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -- 
> 2.38.1
> 
> 
