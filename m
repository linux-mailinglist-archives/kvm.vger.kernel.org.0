Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E1C58992F
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 10:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbiHDISk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 04:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbiHDISh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 04:18:37 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B290665809
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 01:18:36 -0700 (PDT)
Date:   Thu, 4 Aug 2022 10:18:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659601115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=seOpHxQTGAV4o/tWRX/x5NLAPTnsOGjOKpaAMngHSVE=;
        b=BLJoO79tgsm2AGeJQS3VP+m1EkQvDhdKvKCA8hx12fnOWk/ueIhV9urBsRZd5g7DcQ1rIa
        wTkHvHJ5/uPEsdVCTlZ81dqY8/0CDY9NZiDKQBmQV8XDufBm8vHCbBpvFKiRTAJ2WmoQyw
        3t1qx+MwbP0AU5epGpL8cg6JHN8jA0c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] arm: pmu: Check for overflow in
 the low counter in chained counters tests
Message-ID: <20220804081832.3pyn7nospfdekbz3@kamzik>
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803182328.2438598-4-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 11:23:28AM -0700, Ricardo Koller wrote:
> A chained event overflowing on the low counter can set the overflow flag
> in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> overflow.
> 
> The pmu chain tests fail on bare metal when checking the overflow flag
> of the low counter _not_ being set on overflow.  Fix by checking for
> overflow. Note that this test fails in KVM without the respective fix.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 7c5bc259..258780f4 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -583,7 +583,7 @@ static void test_chained_counters(void)
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  
>  	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
> -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
> +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
>  
>  	/* test 64b overflow */
>  
> @@ -595,7 +595,7 @@ static void test_chained_counters(void)
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
> +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>  	write_regn_el0(pmevcntr, 1, ALL_SET);
> @@ -603,7 +603,7 @@ static void test_chained_counters(void)
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> -	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
> +	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
>  static void test_chained_sw_incr(void)
> @@ -629,8 +629,9 @@ static void test_chained_sw_incr(void)
>  		write_sysreg(0x1, pmswinc_el0);
>  
>  	isb();
> -	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
> -		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> +	report((read_sysreg(pmovsclr_el0) == 0x1) &&
> +		(read_regn_el0(pmevcntr, 1) == 1),
> +		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
>  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  
> @@ -648,10 +649,10 @@ static void test_chained_sw_incr(void)
>  		write_sysreg(0x1, pmswinc_el0);
>  
>  	isb();
> -	report((read_sysreg(pmovsclr_el0) == 0x2) &&
> +	report((read_sysreg(pmovsclr_el0) == 0x3) &&
>  		(read_regn_el0(pmevcntr, 1) == 0) &&
>  		(read_regn_el0(pmevcntr, 0) == 84),
> -		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
> +		"overflow on even and odd counters,  and expected values after 100 SW_INCR/CHAIN");

Besides the extra space, this doesn't read well (to me).

Thanks,
drew
