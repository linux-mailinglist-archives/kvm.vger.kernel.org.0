Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FDA13927A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 14:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgAMNsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 08:48:36 -0500
Received: from foss.arm.com ([217.140.110.172]:39710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMNsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 08:48:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34BF813D5;
        Mon, 13 Jan 2020 05:48:35 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 622663F68E;
        Mon, 13 Jan 2020 05:48:34 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] arm: expand the timer tests
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20200110160511.17821-1-alex.bennee@linaro.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
Date:   Mon, 13 Jan 2020 13:48:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200110160511.17821-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/10/20 4:05 PM, Alex Bennée wrote:
> This was an attempt to replicate a QEMU bug. However to trigger the
> bug you need to have an offset set in EL2 which kvm-unit-tests is
> unable to do. However it does exercise some more corner cases.
>
> Bug: https://bugs.launchpad.net/bugs/1859021

I'm not aware of any Bug: tags in the Linux kernel. If you want people to follow
the link to the bug, how about referencing something like this:

"This was an attempt to replicate a QEMU bug [1]. [..]

[1] https://bugs.launchpad.net/qemu/+bug/1859021"

Also, are launchpad bug reports permanent? Will the link still work in a years' time?

> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arm/timer.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index f390e8e..ae1d299 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -214,21 +214,46 @@ static void test_timer(struct timer_info *info)
>  	 * still read the pending state even if it's disabled. */
>  	set_timer_irq_enabled(info, false);
>  
> +	/* Verify count goes up */
> +	report(info->read_counter() >= now, "counter increments");
> +
>  	/* Enable the timer, but schedule it for much later */
>  	info->write_cval(later);
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>  	isb();
> -	report(!gic_timer_pending(info), "not pending before");
> +	report(!gic_timer_pending(info), "not pending before 10s");
> +
> +	/* Check with a maximum possible cval */
> +	info->write_cval(UINT64_MAX);
> +	isb();
> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX");
> +
> +	/* also by setting tval */

All the comments in this file seem to start with a capital letter.

> +	info->write_tval(time_10s);
> +	isb();
> +	report(!gic_timer_pending(info), "not pending before 10s (via tval)");

You can remove the "(via tval)" part - the message is unique enough to figure out
which part of the test it refers to.

> +	report_info("TVAL is %d (delta CVAL %ld) ticks",
> +		    info->read_tval(), info->read_cval() - info->read_counter());

I'm not sure what you are trying to achieve with this. You can transform it to
check that TVAL is indeed positive and (almost) equal to cval - cntpct, something
like this:

+	s32 tval = info->read_tval();
+	report(tval > 0 && tval <= info->read_cval() - info->read_counter(), "TVAL measures time to next interrupt");

>  
> +        /* check pending once cval is before now */

This comment adds nothing to the test.

>  	info->write_cval(now - 1);
>  	isb();
>  	report(gic_timer_pending(info), "interrupt signal pending");
> +	report_info("TVAL is %d ticks", info->read_tval());

You can test that TVAL is negative here instead of printing the value.

>  
>  	/* Disable the timer again and prepare to take interrupts */
>  	info->write_ctl(0);
>  	set_timer_irq_enabled(info, true);
>  	report(!gic_timer_pending(info), "interrupt signal no longer pending");
>  
> +	/* QEMU bug when cntvoff_el2 > 0
> +	 * https://bugs.launchpad.net/bugs/1859021 */

This looks confusing to me. From the commit message, I got that kvm-unit-tests
needs qemu to set a special value for CNTVOFF_EL2. But the comments seems to
suggest that kvm-unit-tests can trigger the bug without qemu doing anything
special. Can you elaborate under which condition kvm-unit-tests can trigger the bug?

> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> +	info->write_cval(UINT64_MAX);

The order is wrong - you write CVAL first, *then* enable to timer. Otherwise you
might get an interrupt because of the previous CVAL value.

The previous value for CVAL was now -1, so your change triggers an unwanted
interrupt after enabling the timer. The interrupt handler masks the timer
interrupt at the timer level, which means that as far as the gic is concerned the
interrupt is not pending, making the report call afterwards useless.

> +	isb();
> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX (irqs on)");

This check can be improved. You want to check the timer CTL.ISTATUS here, not the
gic. A device (in this case, the timer) can assert the interrupt, but the gic does
not sample it immediately. Come to think of it, the entire timer test is wrong
because of this.

Thanks,
Alex
> +	info->write_ctl(0);
> +
>  	report(test_cval_10msec(info), "latency within 10 ms");
>  	report(info->irq_received, "interrupt received");
>  
