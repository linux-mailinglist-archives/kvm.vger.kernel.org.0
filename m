Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AAB6487F1
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 18:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLIRrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 12:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLIRr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 12:47:28 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBF1155CA9
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 09:47:27 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B58223A;
        Fri,  9 Dec 2022 09:47:34 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B16663F73D;
        Fri,  9 Dec 2022 09:47:25 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:47:14 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5N0os7zL/BaMBa3@monolith.localdoman>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202045527.3646838-2-ricarkol@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Dec 02, 2022 at 04:55:25AM +0000, Ricardo Koller wrote:
> PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> for overflowing at 32 or 64-bits. The consequence is that tests that check
> the counter values after overflowing should not assume that values will be
> wrapped around 32-bits: they overflow into the other half of the 64-bit
> counters on PMUv3p5.
> 
> Fix tests by correctly checking overflowing-counters against the expected
> 64-bit value.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index cd47b14..eeac984 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -54,10 +54,10 @@
>  #define EXT_COMMON_EVENTS_LOW	0x4000
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
> -#define ALL_SET			0xFFFFFFFF
> -#define ALL_CLEAR		0x0
> -#define PRE_OVERFLOW		0xFFFFFFF0
> -#define PRE_OVERFLOW2		0xFFFFFFDC
> +#define ALL_SET			0x00000000FFFFFFFFULL
> +#define ALL_CLEAR		0x0000000000000000ULL
> +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>  
>  #define PMU_PPI			23
>  
> @@ -538,6 +538,7 @@ static void test_mem_access(void)
>  static void test_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> +	uint64_t cntr0;
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -572,9 +573,9 @@ static void test_sw_incr(void)
>  		write_sysreg(0x3, pmswinc_el0);
>  
>  	isb();
> -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> -	report(read_regn_el0(pmevcntr, 1)  == 100,
> -		"counter #0 after + 100 SW_INCR");
> +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;

Hm... in the Arm ARM it says that counters are 64-bit if PMUv3p5 is
implemented.  But it doesn't say anywhere that versions newer than p5 are
required to implement PMUv3p5.

For example, for PMUv3p7, it says that the feature is mandatory in Arm8.7
implementations. My interpretation of that is that it is not forbidden for
an implementer to cherry-pick this version on older versions of the
architecture where PMUv3p5 is not implemented.

Maybe the check should be pmu.version == ID_DFR0_PMU_V3_8_5, to match the
counter definitions in the architecture?

Also, I found the meaning of those numbers to be quite cryptic. Perhaps
something like this would be more resilient to changes to the value of
PRE_OVERFLOW and easier to understand:

+       cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
+               (uint32_t)PRE_OVERFLOW + 100 :
+               (uint64_t)PRE_OVERFLOW + 100;

I haven't tested the code, would that work?

Thanks,
Alex

> +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
>  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
> @@ -584,6 +585,7 @@ static void test_sw_incr(void)
>  static void test_chained_counters(void)
>  {
>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> +	uint64_t cntr1;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>  		return;
> @@ -618,13 +620,16 @@ static void test_chained_counters(void)
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> +	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> +
>  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
>  static void test_chained_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
> +	uint64_t cntr0, cntr1;
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
>  		write_sysreg(0x1, pmswinc_el0);
>  
>  	isb();
> +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
>  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> -		(read_regn_el0(pmevcntr, 1) == 0) &&
> -		(read_regn_el0(pmevcntr, 0) == 84),
> -		"expected overflows and values after 100 SW_INCR/CHAIN");
> +	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
> +	       (read_regn_el0(pmevcntr, 0) == cntr1),
> +	       "expected overflows and values after 100 SW_INCR/CHAIN");
>  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
> -- 
> 2.39.0.rc0.267.gcb52ba06e7-goog
> 
