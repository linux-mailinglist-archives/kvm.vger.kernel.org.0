Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BFC66071E
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 20:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjAFT3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 14:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjAFT3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 14:29:05 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532B26E0C9
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 11:29:03 -0800 (PST)
Date:   Fri, 6 Jan 2023 19:28:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673033341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXDHeC7704u3jwtTSi+/q3L7bguB9Hm9yDT2bH4uWxg=;
        b=FOVvO6BfYU70vDpFMUoI7emATWuED3kBPOQLnSX25Md1raEAPm+XS9/GzQIH1AM6eda/iM
        BOAjbVKYdz5BHjO5VvUSp7DEohbmsWxwKuMnKZB/R39RCJsNvGQXWVZnxYxlF7ftHXFJ+v
        bg87+oCMuSh0N0trHuyksn5xHDlhK/A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y7h2eQp5oFd/DN7A@google.com>
References: <20221220031032.2648701-1-ricarkol@google.com>
 <20221220031032.2648701-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220031032.2648701-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Tue, Dec 20, 2022 at 03:10:29AM +0000, Ricardo Koller wrote:
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
>  arm/pmu.c | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index cd47b14..1b55e20 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -54,10 +54,13 @@
>  #define EXT_COMMON_EVENTS_LOW	0x4000
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
> -#define ALL_SET			0xFFFFFFFF
> -#define ALL_CLEAR		0x0
> -#define PRE_OVERFLOW		0xFFFFFFF0
> -#define PRE_OVERFLOW2		0xFFFFFFDC
> +#define ALL_SET			0x00000000FFFFFFFFULL
> +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
> +#define ALL_CLEAR		0x0000000000000000ULL
> +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> +
> +#define ALL_SET_AT(_64b)       (_64b ? ALL_SET_64 : ALL_SET)

AFAICT, ALL_SET is mostly used to toggle all PMCs in a configuration
register. Using it for PMEVCNTR<n> seems a bit odd to me. How about
introducing a helper for getting the counter mask to avoid the
open-coded version check?

static uint64_t pmevcntr_mask(void)
{
	/*
	 * Bits [63:0] are always incremented for 64-bit counters,
	 * even if the PMU is configured to generate an overflow at
	 * bits [31:0]
	 *
	 * See DDI0487I.a, section D11.3 ("Behavior on overflow") for
	 * more details.
	 */
	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
		return ~0;

	return (uint32_t)~0;
}

I've always found the PMU documentation to be a bit difficult to grok,
and the above citation only mentions the intended behavior in passing.
Please feel free to update with a better citation if it exists.

>  #define PMU_PPI			23
>  
> @@ -538,6 +541,7 @@ static void test_mem_access(void)
>  static void test_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> +	uint64_t cntr0;
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -572,9 +576,11 @@ static void test_sw_incr(void)
>  		write_sysreg(0x3, pmswinc_el0);
>  
>  	isb();
> -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> -	report(read_regn_el0(pmevcntr, 1)  == 100,
> -		"counter #0 after + 100 SW_INCR");
> +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
> +		(uint32_t)PRE_OVERFLOW + 100 :
> +		(uint64_t)PRE_OVERFLOW + 100;

With the above suggestion, it would be nice to rewrite like so:

	cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();

If you do go this route, then you'll probably want to drop all the other
open-coded PMUv3p5 checks in favor of the helper.

--
Thanks,
Oliver
