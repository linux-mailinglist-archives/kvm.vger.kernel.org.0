Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC860732F41
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 12:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345590AbjFPK5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 06:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344843AbjFPK5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 06:57:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5723C30D4
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 03:50:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A0831FB;
        Fri, 16 Jun 2023 03:51:13 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 383C73F5A1;
        Fri, 16 Jun 2023 03:50:27 -0700 (PDT)
Date:   Fri, 16 Jun 2023 11:50:24 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/6] arm: pmu: Fix chain counter
 enable/disable sequences
Message-ID: <ZIw-cJJha3OSYSMW@monolith.localdoman>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230531201438.3881600-5-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531201438.3881600-5-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, May 31, 2023 at 10:14:36PM +0200, Eric Auger wrote:
> In some ARM ARM ddi0487 revisions it is said that
> disabling/enabling a pair of counters that are paired
> by a CHAIN event should follow a given sequence:
> 
> Enable the high counter first, isb, enable low counter
> Disable the low counter first, isb, disable the high counter
> 
> This was the case in Fc. However this is not written anymore
> in subsequent revions such as Ia.
> 
> Anyway, just in case, and because it also makes the code a
> little bit simpler, introduce 2 helpers to enable/disable chain
> counters that execute those sequences and replace the existing
> PMCNTENCLR/ENSET calls (at least this cannot do any harm).
> 
> Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
> and replace them by PMCNTENCLR writes since writing 0 in
> PMCNTENSET_EL0 has no effect.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - fix the enable_chain_counter()/disable_chain_counter()
>   sequence, ie. swap n + 1 / n as reported by Alexandru.
> - fix an other comment using the 'low' terminology
> ---
>  arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 74dd4c10..74c9f6f9 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -731,6 +731,22 @@ static void test_chained_sw_incr(bool unused)
>  		    read_regn_el0(pmevcntr, 0), \
>  		    read_sysreg(pmovsclr_el0))
>  
> +static void enable_chain_counter(int even)
> +{
> +	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the high counter first */
> +	isb();
> +	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the low counter */
> +	isb();
> +}
> +
> +static void disable_chain_counter(int even)
> +{
> +	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the low counter first*/
> +	isb();
> +	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the high counter */
> +	isb();
> +}
> +
>  static void test_chain_promotion(bool unused)

Here's what test_chain_promotion() does for the first subtest:

static void test_chain_promotion(bool unused)
{
        uint32_t events[] = {MEM_ACCESS, CHAIN};
        void *addr = malloc(PAGE_SIZE);

        if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
                return;

        /* Only enable CHAIN counter */
        report_prefix_push("subtest1");
        pmu_reset();
        write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
        write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
        write_sysreg_s(0x2, PMCNTENSET_EL0);
        isb();

        mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);

And here's what test_chained_counters() does:

static void test_chained_counters(bool unused)
{
        uint32_t events[] = {CPU_CYCLES, CHAIN};
        uint64_t all_set = pmevcntr_mask();

        if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
                return;

        pmu_reset();

        write_regn_el0(pmevtyper, 0, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
        write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
        /* enable counters #0 and #1 */
        write_sysreg_s(0x3, PMCNTENSET_EL0);
        write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);

        precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);

Why the extra ISB in test_chain_promotion()? Or, if you want to look at it
the other way around, is the ISB missing from test_chained_counters()?

>  {
>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
> @@ -769,16 +785,17 @@ static void test_chain_promotion(bool unused)
>  	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
>  	report_prefix_push("subtest3");
>  	pmu_reset();
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
> -	isb();
> +	enable_chain_counter(0);
>  	PRINT_REGS("init");

Here's how subtest3 ends up looking:

        report_prefix_push("subtest3");
        pmu_reset();
        write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
        enable_chain_counter(0);
        PRINT_REGS("init");

        mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);

And here's something similar from test_chained_counters():

        pmu_reset();
        write_sysreg_s(0x3, PMCNTENSET_EL0);

        write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
        write_regn_el0(pmevcntr, 1, 0x1);
        precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);


Why does test_chain_promotion() use enable_chain_counter() and
test_chained_counters() doesn't?

Could probably find more examples of this in test_chain_promotion().

As an aside, it's extremely difficult to figure out how the counters are
programmed for a subtest. In the example above, you need to go back 2
subtests, to the start of test_chain_promotion(), to figure that out. And
that only gets worse the subtest number increases. test_chain_promotion()
would really benefit from being split into separate functions, each with
each own clear initial state. But that's for another patch, not for this
series.

Thanks,
Alex

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
>  	PRINT_REGS("After 2nd loop");
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
> @@ -799,9 +816,11 @@ static void test_chain_promotion(bool unused)
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
> -	/* enable the CHAIN event */
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	/* Disable the low counter first and enable the chain counter */
> +	write_sysreg_s(0x1, PMCNTENCLR_EL0);
>  	isb();
> +	enable_chain_counter(0);
> +
>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  
>  	PRINT_REGS("After 2nd loop");
> @@ -825,10 +844,10 @@ static void test_chain_promotion(bool unused)
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
>  	PRINT_REGS("After 2nd loop");
> @@ -844,13 +863,13 @@ static void test_chain_promotion(bool unused)
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
