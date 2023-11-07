Return-Path: <kvm+bounces-864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635A87E3826
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67B091C20B85
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F7312E5D;
	Tue,  7 Nov 2023 09:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD1B12B91
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:51:27 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05DCCF3
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:51:26 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 638E5FEC;
	Tue,  7 Nov 2023 01:52:10 -0800 (PST)
Received: from monolith (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 818D83F703;
	Tue,  7 Nov 2023 01:51:24 -0800 (PST)
Date: Tue, 7 Nov 2023 09:52:07 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	andrew.jones@linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	jarichte@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu-overflow-interrupt: Increase
 count values
Message-ID: <ZUoIxznZwPyti254@monolith>
References: <20231103100139.55807-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103100139.55807-1-eric.auger@redhat.com>

Hi Eric,

On Fri, Nov 03, 2023 at 11:01:39AM +0100, Eric Auger wrote:
> On some hardware, some pmu-overflow-interrupt failures can be observed.
> Although the even counter overflows, the interrupt is not seen as
> expected. This happens in the subtest after "promote to 64-b" comment.
> After analysis, the PMU overflow interrupt actually hits, ie.
> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
> as expected. However the PMCR.E is reset by the handle_exit path, at
> kvm_pmu_handle_pmcr() before the next guest entry and
> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
> There, since the enable bit has been reset, kvm_pmu_update_state() does
> not inject the interrupt into the guest.
> 
> This does not seem to be a KVM bug but rather an unfortunate
> scenario where the test disables the PMCR.E too closely to the
> advent of the overflow interrupt.

If I understand correctly, the KVM PMU, after receiving the hardware PMUIRQ and
before injecting the interrupt, checks that the PMU is enabled according to the
pseudocode for the function CheckForPMUOverflow(). CheckForPMUOverflow() returns
false because PMCR_EL1.E is 0, so the KVM PMU decides not to inject the
interrupt.

Is that correct?

Changing the number of SW_INCR events might not be optimal - for example,
COUNT_INT > 100 might hide an error that otherwise would have been triggered if
the number of events were 100. Not very likely, but still a possibility.

Another approach would be to wait for a set amount of time for the CPU to take
the interrupt. There's something similar in timer.c::{test_timer_tval(),
timer_do_wfi()}.

Thanks,
Alex

> 
> Since it looks like a benign and inlikely case, let's resize the number
> of iterations to prevent the PMCR enable bit from being resetted
> at the same time as the actual overflow event.
> 
> COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
> used in this test.
> 
> Reported-by: Jan Richter <jarichte@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index a91a7b1f..acd88571 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -66,6 +66,7 @@
>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>  #define COUNT 250
>  #define MARGIN 100
> +#define COUNT_INT 1000
>  /*
>   * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
>   * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
> @@ -978,13 +979,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  
>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>  
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	isb();
>  
> -	for (i = 0; i < 100; i++)
> +	for (i = 0; i < COUNT_INT; i++)
>  		write_sysreg(0x2, pmswinc_el0);
>  
>  	isb();
> @@ -1002,15 +1003,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>  	isb();
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	isb();
>  
> -	for (i = 0; i < 100; i++)
> +	for (i = 0; i < COUNT_INT; i++)
>  		write_sysreg(0x3, pmswinc_el0);
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
>  	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
>  	report(expect_interrupts(0x3),
>  		"overflow interrupts expected on #0 and #1");
> @@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	isb();
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report(expect_interrupts(0x1), "expect overflow interrupt");
>  
>  	/* overflow on odd counter */
> @@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	write_regn_el0(pmevcntr, 1, all_set);
>  	isb();
> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	if (overflow_at_64bits) {
>  		report(expect_interrupts(0x1),
>  		       "expect overflow interrupt on even counter");
> -- 
> 2.41.0
> 

