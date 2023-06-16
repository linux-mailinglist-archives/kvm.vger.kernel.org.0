Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF545733074
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 13:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344696AbjFPLwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 07:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343845AbjFPLw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 07:52:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A45E2D5D
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 04:52:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DBC91FB;
        Fri, 16 Jun 2023 04:53:08 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 340133F71E;
        Fri, 16 Jun 2023 04:52:22 -0700 (PDT)
Date:   Fri, 16 Jun 2023 12:52:19 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
Message-ID: <ZIxM8-z0WdhbVq64@monolith.localdoman>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230531201438.3881600-6-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531201438.3881600-6-eric.auger@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The test looks much more readable now, some comments below.

On Wed, May 31, 2023 at 10:14:37PM +0200, Eric Auger wrote:
> Add a new basic test that runs MEM_ACCESS loop over
> 100 iterations and make sure the number of measured
> MEM_ACCESS never overflows the margin. Some other
> pmu tests rely on this pattern and if the MEM_ACCESS
> measurement is not reliable, it is better to report
> it beforehand and not confuse the user any further.
> 
> Without the subsequent patch, this typically fails on
> ThunderXv2 with the following logs:
> 
> INFO: pmu: pmu-mem-access-reliability: 32-bit overflows:
> overflow=1 min=21 max=41 COUNT=20 MARGIN=15
> FAIL: pmu: pmu-mem-access-reliability: 32-bit overflows:
> mem_access count is reliable
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - use mem-access instead of memaccess as suggested by Mark
> - simplify the logic and add comments in the test loop
> ---
>  arm/pmu.c         | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |  6 +++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 74c9f6f9..925f277c 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -56,6 +56,7 @@
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
>  #define ALL_SET_32		0x00000000FFFFFFFFULL
> +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
>  #define ALL_CLEAR		0x0000000000000000ULL
>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> @@ -67,6 +68,10 @@
>   * for some observed variability we take into account a given @MARGIN
>   */
>  #define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
> +#define PRE_OVERFLOW2_64		(ALL_SET_64 - COUNT - MARGIN)
> +
> +#define PRE_OVERFLOW2(__overflow_at_64bits)				\
> +	(__overflow_at_64bits ? PRE_OVERFLOW2_64 : PRE_OVERFLOW2_32)
>  
>  #define PRE_OVERFLOW(__overflow_at_64bits)				\
>  	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> @@ -747,6 +752,56 @@ static void disable_chain_counter(int even)
>  	isb();
>  }
>  
> +/*
> + * This test checks that a mem access loop featuring COUNT accesses
> + * does not overflow with an init value of PRE_OVERFLOW2. It also
> + * records the min/max access count to see how much the counting
> + * is (un)reliable
> + */
> +static void test_mem_access_reliability(bool overflow_at_64bits)
> +{
> +	uint32_t events[] = {MEM_ACCESS};
> +	void *addr = malloc(PAGE_SIZE);
> +	uint64_t count, delta, max = 0, min = pmevcntr_mask();
> +	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> +	bool overflow = false;
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
> +		return;
> +
> +	pmu_reset();
> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> +	for (int i = 0; i < 100; i++) {
> +		pmu_reset();
> +		write_regn_el0(pmevcntr, 0, pre_overflow2);
> +		write_sysreg_s(0x1, PMCNTENSET_EL0);
> +		isb();
> +		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +		count = read_regn_el0(pmevcntr, 0);
> +		if (count >= pre_overflow2) {
> +			/* not counter overflow, as expected */
> +			delta = count - pre_overflow2;

Personally, I find the names confusing. Since the test tries to see how
much the counting is unreliable, I would have have expected delta to be
difference between the expected number of events incremented (i.e., COUNT)
and the actual number of events recorded in the counter. I would rename
count to cntr_val and delta to num_events, but that might be just personal
bias and I leave it up to you if think this might be useful.

> +		} else {
> +			/*
> +			 * unexpected counter overflow meaning the actual
> +			 * mem access count, delta, is count + COUNT + MARGIN
> +			 */
> +			delta = count + COUNT + MARGIN;

This assumes that PRE_OVERFLOW2_{32,64} = ALL_SET{32,64} - COUNT - MARGIN,
which might change in the future.

I think a better way to do that is:

delta = count + all_set - pre_overflow2, where

all_set = overflow_at_64bits ? ALL_SET64 : ALL_SET32.

That is a lot easier to parse for someone who doesn't know exactly how
PRE_OVERFLOW2_* is defined, and more robust.

> +			overflow = true;
> +			report_info("iter=%d count=%ld min=%ld max=%ld overflow!!!",
> +				    i, delta, min, max);

I find this message extremely confusing: it does not print count (the value
read from counter 0) like the text displayed suggests, it prints delta,
which represents the number of events counted by the counter.

Besides those minor issues, the patch looks correct. Also ran the test on a
rockpro64 under KVM + qemu.

Thanks,
Alex

> +		}
> +		/* record extreme value */
> +		max = MAX(delta, max);
> +		min = MIN(delta, min);
> +	}
> +	report_info("overflow=%d min=%ld max=%ld COUNT=%d MARGIN=%d",
> +		    overflow, min, max, COUNT, MARGIN);
> +	report(!overflow, "mem_access count is reliable");
> +}
> +
>  static void test_chain_promotion(bool unused)
>  {
>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
> @@ -1204,6 +1259,9 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>  		run_event_test(argv[1], test_basic_event_count, false);
>  		run_event_test(argv[1], test_basic_event_count, true);
> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
> +		run_event_test(argv[1], test_mem_access_reliability, false);
> +		run_event_test(argv[1], test_mem_access_reliability, true);
>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>  		run_event_test(argv[1], test_mem_access, false);
>  		run_event_test(argv[1], test_mem_access, true);
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 5e67b558..fe601cbb 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -90,6 +90,12 @@ groups = pmu
>  arch = arm64
>  extra_params = -append 'pmu-mem-access'
>  
> +[pmu-mem-access-reliability]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'pmu-mem-access-reliability'
> +
>  [pmu-sw-incr]
>  file = pmu.flat
>  groups = pmu
> -- 
> 2.38.1
> 
