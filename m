Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBBD743F26
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjF3Prn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjF3Prl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:47:41 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC1ED1B8
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:47:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB0092F4;
        Fri, 30 Jun 2023 08:48:21 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CB6F3F73F;
        Fri, 30 Jun 2023 08:47:36 -0700 (PDT)
Date:   Fri, 30 Jun 2023 16:47:33 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 4/6] arm: pmu: Fix chain counter
 enable/disable sequences
Message-ID: <ZJ75FRz3aV8hPtcx@monolith.localdoman>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-5-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619200401.1963751-5-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Jun 19, 2023 at 10:03:59PM +0200, Eric Auger wrote:
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
> PMCNTENSET_EL0 has no effect. While at it, aslo removes a useless
> pmevtyper setting in test_chained_sw_incr() since the type of the
> counter is not reset by pmu_reset()

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v2 -> v3:
> - use enable_chain_counter() in test_chain_promotion() and
>   test_chained_sw_incr() as well. This also fix the missing
>   ISB reported by Alexandru.
> - Also removes a useless pmevtyper setting in
>   test_chained_sw_incr()
> 
> v1 -> v2:
> - fix the enable_chain_counter()/disable_chain_counter()
>   sequence, ie. swap n + 1 / n as reported by Alexandru.
> - fix an other comment using the 'low' terminology
> ---
>  arm/pmu.c | 48 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 74dd4c10..0995a249 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -631,6 +631,22 @@ static void test_sw_incr(bool overflow_at_64bits)
>  		"overflow on counter #0 after 100 SW_INCR");
>  }
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
>  static void test_chained_counters(bool unused)
>  {
>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> @@ -643,9 +659,8 @@ static void test_chained_counters(bool unused)
>  
>  	write_regn_el0(pmevtyper, 0, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -	/* enable counters #0 and #1 */
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	enable_chain_counter(0);
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  
> @@ -655,10 +670,10 @@ static void test_chained_counters(bool unused)
>  	/* test 64b overflow */
>  
>  	pmu_reset();
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_regn_el0(pmevcntr, 1, 0x1);
> +	enable_chain_counter(0);
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> @@ -687,8 +702,7 @@ static void test_chained_sw_incr(bool unused)
>  
>  	write_regn_el0(pmevtyper, 0, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -	/* enable counters #0 and #1 */
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	enable_chain_counter(0);
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> @@ -707,10 +721,9 @@ static void test_chained_sw_incr(bool unused)
>  	/* 64b SW_INCR and overflow on CHAIN counter*/
>  	pmu_reset();
>  
> -	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_regn_el0(pmevcntr, 1, ALL_SET_32);
> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	enable_chain_counter(0);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>  	isb();
>  
> @@ -769,16 +782,17 @@ static void test_chain_promotion(bool unused)
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
>  	PRINT_REGS("After 2nd loop");
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
> @@ -799,9 +813,11 @@ static void test_chain_promotion(bool unused)
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
> @@ -825,10 +841,10 @@ static void test_chain_promotion(bool unused)
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
> @@ -844,13 +860,13 @@ static void test_chain_promotion(bool unused)
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
