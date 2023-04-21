Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB60D6EA7A3
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjDUJ4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjDUJ4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:56:04 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0C789EC9
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 02:55:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84BBE1480;
        Fri, 21 Apr 2023 02:56:38 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 017CC3F5A1;
        Fri, 21 Apr 2023 02:55:52 -0700 (PDT)
Date:   Fri, 21 Apr 2023 10:55:50 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 2/6] arm: pmu: pmu-chain-promotion:
 Introduce defines for count and margin values
Message-ID: <ZEJdpmTSyf6sp3Yv@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-3-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110725.1215523-3-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Mar 15, 2023 at 12:07:21PM +0100, Eric Auger wrote:
> The pmu-chain-promotion test is composed of separate subtests.
> 
> Some of them apply some settings on a first MEM_ACCESS loop
> iterations, change the settings and run another MEM_ACCESS loop.
> 
> The PRE_OVERFLOW2 MEM_ACCESS counter init value is defined so that
> the first loop does not overflow and the second loop overflows.
> 
> At the moment the MEM_ACCESS count number is hardcoded to 20 and
> PRE_OVERFLOW2 is set to UINT32_MAX - 20 - 15 where 15 acts as a
> margin.
> 
> Introduce defines for the count number and the margin so that it
> becomes easier to change them.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index dad7d4b4..b88366a8 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -55,11 +55,18 @@
>  #define EXT_COMMON_EVENTS_LOW	0x4000
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
> -#define ALL_SET_32			0x00000000FFFFFFFFULL
> +#define ALL_SET_32		0x00000000FFFFFFFFULL
>  #define ALL_CLEAR		0x0000000000000000ULL
>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
> -#define PRE_OVERFLOW2_32	0x00000000FFFFFFDCULL
>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> +#define COUNT 20

test_mem_access (from the test "pmu-mem-access") also uses 20 for
mem_access_loop, in case you want to change the define there too.

I realize I'm bikeshedding here, but it might also help if the define name
held some clue to what is being counted (like ACCESS_COUNT, or something
like that).

> +#define MARGIN 15
> +/*
> + * PRE_OVERFLOW2 is set so that 1st COUNT iterations do not
> + * produce 32b overflow and 2d COUNT iterations do. To accommodate

2**nd** COUNT iterations?

> + * for some observed variability we take into account a given @MARGIN

Some inconsistency here, this variable is referred to with @MARGIN, but
COUNT isn't (missing "@").

> + */
> +#define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)

This is much better, I would have been hard pressed to figure out where the
previous value of 0x00000000FFFFFFDCULL came from.

The patch looks good to me (with or without the comments above):

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  
>  #define PRE_OVERFLOW(__overflow_at_64bits)				\
>  	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> @@ -737,7 +744,7 @@ static void test_chain_promotion(bool unused)
>  	write_sysreg_s(0x2, PMCNTENSET_EL0);
>  	isb();
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("post");
>  	report(!read_regn_el0(pmevcntr, 0),
>  		"chain counter not counting if even counter is disabled");
> @@ -750,13 +757,13 @@ static void test_chain_promotion(bool unused)
>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>  	isb();
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("post");
>  	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
>  		"odd counter did not increment on overflow if disabled");
>  	report_prefix_pop();
>  
> -	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
> +	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
>  	report_prefix_push("subtest3");
>  	pmu_reset();
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> @@ -764,12 +771,12 @@ static void test_chain_promotion(bool unused)
>  	isb();
>  	PRINT_REGS("init");
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
>  	/* disable the CHAIN event */
>  	write_sysreg_s(0x2, PMCNTENCLR_EL0);
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 2d loop");
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>  		"should have triggered an overflow on #0");
> @@ -777,7 +784,7 @@ static void test_chain_promotion(bool unused)
>  		"CHAIN counter #1 shouldn't have incremented");
>  	report_prefix_pop();
>  
> -	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
> +	/* 1st COUNT with CHAIN disabled, next COUNT with CHAIN enabled */
>  
>  	report_prefix_push("subtest4");
>  	pmu_reset();
> @@ -786,13 +793,13 @@ static void test_chain_promotion(bool unused)
>  	isb();
>  	PRINT_REGS("init");
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
>  	/* enable the CHAIN event */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  
>  	PRINT_REGS("After 2d loop");
>  
> @@ -811,7 +818,7 @@ static void test_chain_promotion(bool unused)
>  	isb();
>  	PRINT_REGS("init");
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
>  	/* 0 becomes CHAINED */
> @@ -820,7 +827,7 @@ static void test_chain_promotion(bool unused)
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 1, 0x0);
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 2d loop");
>  
>  	report((read_regn_el0(pmevcntr, 1) == 1) &&
> @@ -837,14 +844,14 @@ static void test_chain_promotion(bool unused)
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	PRINT_REGS("init");
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 1st loop");
>  
>  	write_sysreg_s(0x0, PMCNTENSET_EL0);
>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>  	PRINT_REGS("After 2d loop");
>  	report(read_sysreg(pmovsclr_el0) == 1,
>  		"overflow is expected on counter 0");
> -- 
> 2.38.1
> 
> 
