Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750A8F9096
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfKLN0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 08:26:20 -0500
Received: from foss.arm.com ([217.140.110.172]:33924 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfKLN0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 08:26:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CF2A30E;
        Tue, 12 Nov 2019 05:26:19 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 273F53F6C4;
        Tue, 12 Nov 2019 05:26:18 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 04/17] arm: gic: Support no IRQs test case
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-5-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <db89b983-425c-8b45-3f26-1a33b9817836@arm.com>
Date:   Tue, 12 Nov 2019 13:26:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-5-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> For some tests it would be important to check that an IRQ was *not*
> triggered, for instance to test certain masking operations.
>
> Extend the check_added() function to recognise an empty cpumask to
> detect this situation. The timeout duration is reduced, and the "no IRQs

Why is the timeout duration reduced?

> triggered" case is actually reported as a success in this case.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index a114009..eca9188 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -66,9 +66,10 @@ static void check_acked(const char *testname, cpumask_t *mask)
>  	int missing = 0, extra = 0, unexpected = 0;
>  	int nr_pass, cpu, i;
>  	bool bad = false;
> +	bool noirqs = cpumask_empty(mask);
>  
>  	/* Wait up to 5s for all interrupts to be delivered */

This comment needs updating.

> -	for (i = 0; i < 50; ++i) {
> +	for (i = 0; i < (noirqs ? 15 : 50); ++i) {
>  		mdelay(100);
>  		nr_pass = 0;
>  		for_each_present_cpu(cpu) {
> @@ -88,7 +89,7 @@ static void check_acked(const char *testname, cpumask_t *mask)
>  				bad = true;
>  			}
>  		}
> -		if (nr_pass == nr_cpus) {
> +		if (!noirqs && nr_pass == nr_cpus) {

This condition is pretty hard to read - what you are doing here is making sure
that when check_acked tests that no irqs have been received, you do the entire for
loop and wait the entire timeout duration. Did I get that right?

How about this (compile tested only):

+               if (noirqs)
+                       /* Wait for the entire timeout duration. */
+                       continue;
+
                if (nr_pass == nr_cpus) {
                        report("%s", !bad, testname);
                        if (i)

>  			report("%s", !bad, testname);
>  			if (i)
>  				report_info("took more than %d ms", i * 100);
> @@ -96,6 +97,11 @@ static void check_acked(const char *testname, cpumask_t *mask)
>  		}
>  	}
>  
> +	if (noirqs && nr_pass == nr_cpus) {
> +		report("%s", !bad, testname);

bad is true only when bad_sender[cpu] != -1 or bad_irq[cpu] != -1, which only get
set in the irq or ipi handlesr, meaning when you do get an interrupt. If nr_pass
== nr_cpus and noirqs, then you shouldn't have gotten an interrupt. I think it's
safe to write it as report("%s", true, testname). I think a short comment above
explaining why we do this check (timeout expired and we haven't gotten any
interrupts) would also improve readability of the code, but that's up to you.

Thanks,
Alex
> +		return;
> +	}
> +
>  	for_each_present_cpu(cpu) {
>  		if (cpumask_test_cpu(cpu, mask)) {
>  			if (!acked[cpu])
