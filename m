Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186CC58998B
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 10:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiHDIyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 04:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbiHDIyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 04:54:31 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB1C2222A3
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 01:54:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4EAA11FB;
        Thu,  4 Aug 2022 01:54:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 822803F70D;
        Thu,  4 Aug 2022 01:54:26 -0700 (PDT)
Date:   Thu, 4 Aug 2022 09:55:01 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] arm: pmu: Add missing isb()'s
 after sys register writing
Message-ID: <YuuJZf9QPW5p/sbx@monolith.localdoman>
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803182328.2438598-2-ricarkol@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Aug 03, 2022 at 11:23:26AM -0700, Ricardo Koller wrote:
> There are various pmu tests that require an isb() between enabling
> counting and the actual counting. This can lead to count registers
> reporting less events than expected; the actual enabling happens after
> some events have happened.  For example, some missing isb()'s in the
> pmu-sw-incr test lead to the following errors on bare-metal:
> 
> 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> 	PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> 	FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> 	FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> 	INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> 	PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> 	SUMMARY: 4 tests, 2 unexpected failures
> 
> Add the missing isb()'s on all failing tests, plus some others that seem
> required:
> - after clearing the overflow signal in the IRQ handler to avoid
>   spurious interrupts.

Nitpick, but it doesn't avoid (eliminates) spurious interrupts, it makes
them less likely.

> - after direct writes to PMSWINC_EL0 for software to read the correct
>   value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 15c542a2..76156f78 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> [..]
> @@ -821,10 +832,13 @@ static void test_overflow_interrupt(void)
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>  
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	isb();
> +
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x2, pmswinc_el0);
>  
>  	set_pmcr(pmu.pmcr_ro);
> +	isb();

A context synchronization event affects system register writes that come
before the context synchronization event in program order, but if there are
multiple system register writes, it doesn't perform them in program order
(if that makes sense).

So it might happen that the CPU decides to perform the write to PMCR_EL1
which disables the PMU *before* the writes to PMSWINC_EL0. Which means that
even if PMINTENSET_EL1 allows the PMU to assert interrupts when it
shouldn't (thus causing the test to fail), those interrupt won't be
asserted by the PMU because the PMU is disabled and the test would pass.

You need an ISB after the PMSWINC_EL0 writes and before disabling the PMU.

Thanks,
Alex

>  	report(expect_interrupts(0), "no overflow interrupt after counting");
