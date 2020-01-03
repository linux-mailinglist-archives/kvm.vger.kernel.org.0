Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46B912F8D6
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 14:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgACNhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 08:37:24 -0500
Received: from foss.arm.com ([217.140.110.172]:55670 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgACNhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 08:37:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E23D7328;
        Fri,  3 Jan 2020 05:37:23 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 091643F237;
        Fri,  3 Jan 2020 05:37:22 -0800 (PST)
Date:   Fri, 3 Jan 2020 13:37:20 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 13/18] arm64: timer: Test behavior
 when timer disabled or masked
Message-ID: <20200103133720.05f1bfb2@donnerap.cambridge.arm.com>
In-Reply-To: <1577808589-31892-14-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
        <1577808589-31892-14-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Dec 2019 16:09:44 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
> timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
> set), timer interrupts must not be pending or asserted by the VGIC.
> However, only when the timer interrupt is masked, we can still check
> that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.
> 
> This test was used to discover a bug and test the fix introduced by KVM
> commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
> interrupts on enable").
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/timer.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 67e95ede24ef..a0b57afd4fe4 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -230,9 +230,17 @@ static void test_timer(struct timer_info *info)
>  
>  	/* Disable the timer again and prepare to take interrupts */
>  	info->write_ctl(0);
> +	isb();
> +	info->irq_received = false;
>  	set_timer_irq_enabled(info, true);

Are we too impatient here? There does not seem to be a barrier after the write to the ISENABLER register, so I wonder if we need at least a dsb() here? I think in other occasions (GIC test) we even wait for some significant amount of time to allow interrupts to trigger (or not).

> +	report(!info->irq_received, "no interrupt when timer is disabled");
>  	report(!gic_timer_pending(info), "interrupt signal no longer pending");
>  
> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
> +	isb();
> +	report(!gic_timer_pending(info), "interrupt signal not pending");
> +	report(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS, "timer condition met");
> +
>  	report(test_cval_10msec(info), "latency within 10 ms");
>  	report(info->irq_received, "interrupt received");

Not part of your patch, but is this kind of evaluation of the irq_received actually valid? Does the compiler know that this gets set in another part of the code (the IRQ handler)? Do we need some synchronisation or barrier here to prevent the compiler from optimising or reordering the access to irq_received? 

Cheers,
Andre.
