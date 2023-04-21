Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C776EA6DD
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjDUJZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbjDUJZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:25:31 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8612C10D0
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 02:25:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23F0C1480;
        Fri, 21 Apr 2023 02:26:13 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99BDB3F5A1;
        Fri, 21 Apr 2023 02:25:27 -0700 (PDT)
Date:   Fri, 21 Apr 2023 10:25:24 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: pmu: pmu-chain-promotion:
 Improve debug messages
Message-ID: <ZEJWhPtA2xaaqV54@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-2-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110725.1215523-2-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Mar 15, 2023 at 12:07:20PM +0100, Eric Auger wrote:
> The pmu-chain-promotion test is composed of several subtests.
> In case of failures, the current logs are really dificult to
> analyze since they look very similar and sometimes duplicated
> for each subtest. Add prefixes for each subtest and introduce
> a macro that prints the registers we are mostly interested in,
> namerly the 2 first counters and the overflow counter.

One possible typo below.

Ran pmu-chain-promotion with and without this patch applied, the
improvement is very noticeable, it makes it very easy to match the debug
message with the subtest being run:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c | 63 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index f6e95012..dad7d4b4 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -715,6 +715,11 @@ static void test_chained_sw_incr(bool unused)
>  	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
> +#define PRINT_REGS(__s) \
> +	report_info("%s #1=0x%lx #0=0x%lx overflow=0x%lx", __s, \
> +		    read_regn_el0(pmevcntr, 1), \
> +		    read_regn_el0(pmevcntr, 0), \
> +		    read_sysreg(pmovsclr_el0))
>  
>  static void test_chain_promotion(bool unused)
>  {
> @@ -725,6 +730,7 @@ static void test_chain_promotion(bool unused)
>  		return;
>  
>  	/* Only enable CHAIN counter */
> +	report_prefix_push("subtest1");
>  	pmu_reset();
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> @@ -732,83 +738,81 @@ static void test_chain_promotion(bool unused)
>  	isb();
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	PRINT_REGS("post");
>  	report(!read_regn_el0(pmevcntr, 0),
>  		"chain counter not counting if even counter is disabled");
> +	report_prefix_pop();
>  
>  	/* Only enable even counter */
> +	report_prefix_push("subtest2");
>  	pmu_reset();
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>  	isb();
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	PRINT_REGS("post");
>  	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
>  		"odd counter did not increment on overflow if disabled");
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> -	report_info("CHAIN counter #1 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 1));
> -	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
> +	report_prefix_pop();
>  
>  	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
> +	report_prefix_push("subtest3");
>  	pmu_reset();
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>  	isb();
> +	PRINT_REGS("init");
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> +	PRINT_REGS("After 1st loop");
>  
>  	/* disable the CHAIN event */
>  	write_sysreg_s(0x2, PMCNTENCLR_EL0);
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> +	PRINT_REGS("After 2d loop");

Hmm.. was that supposed to be "after 2**n**d loop" (matches the "after 1st
loop" message)? A few more instances below.

Thanks,
Alex

>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>  		"should have triggered an overflow on #0");
>  	report(!read_regn_el0(pmevcntr, 1),
>  		"CHAIN counter #1 shouldn't have incremented");
> +	report_prefix_pop();
>  
>  	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
>  
> +	report_prefix_push("subtest4");
>  	pmu_reset();
>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>  	isb();
> -	report_info("counter #0 = 0x%lx, counter #1 = 0x%lx overflow=0x%lx",
> -		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
> -		    read_sysreg(pmovsclr_el0));
> +	PRINT_REGS("init");
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> +	PRINT_REGS("After 1st loop");
>  
>  	/* enable the CHAIN event */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> +
> +	PRINT_REGS("After 2d loop");
>  
>  	report((read_regn_el0(pmevcntr, 1) == 1) &&
>  		(read_sysreg(pmovsclr_el0) == 0x1),
>  		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
> -
> -	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> -		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> +	report_prefix_pop();
>  
>  	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
> +	report_prefix_push("subtest5");
>  	pmu_reset();
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>  	isb();
> +	PRINT_REGS("init");
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> +	PRINT_REGS("After 1st loop");
>  
>  	/* 0 becomes CHAINED */
>  	write_sysreg_s(0x0, PMCNTENSET_EL0);
> @@ -817,37 +821,34 @@ static void test_chain_promotion(bool unused)
>  	write_regn_el0(pmevcntr, 1, 0x0);
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> -		    read_regn_el0(pmevcntr, 0));
> +	PRINT_REGS("After 2d loop");
>  
>  	report((read_regn_el0(pmevcntr, 1) == 1) &&
>  		(read_sysreg(pmovsclr_el0) == 0x1),
>  		"32b->64b: CHAIN counter incremented and overflow");
> -
> -	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> -		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> +	report_prefix_pop();
>  
>  	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
> +	report_prefix_push("subtest6");
>  	pmu_reset();
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	PRINT_REGS("init");
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> -	report_info("counter #0=0x%lx, counter #1=0x%lx",
> -			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> +	PRINT_REGS("After 1st loop");
>  
>  	write_sysreg_s(0x0, PMCNTENSET_EL0);
>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	PRINT_REGS("After 2d loop");
>  	report(read_sysreg(pmovsclr_el0) == 1,
>  		"overflow is expected on counter 0");
> -	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
> -			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
> -			read_sysreg(pmovsclr_el0));
> +	report_prefix_pop();
>  }
>  
>  static bool expect_interrupts(uint32_t bitmap)
> -- 
> 2.38.1
> 
