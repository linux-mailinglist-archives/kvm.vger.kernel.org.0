Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A173A2CD9B3
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgLCO6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLCO6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:58:05 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2E4206D6;
        Thu,  3 Dec 2020 14:57:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kkq2r-00FhLT-G9; Thu, 03 Dec 2020 14:57:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 14:57:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH v2 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
In-Reply-To: <20200818032814.15968-3-zhukeqian1@huawei.com>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-3-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b232d02b2d9c3e29898914bd9bbb8dc5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steven.price@arm.com, drjones@redhat.com, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-18 04:28, Keqian Zhu wrote:
> ARM virtual counter supports event stream, it can only trigger an event
> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 
> changes,
> so the actual period of event stream is 2^(cntkctl_evnti + 1). For 
> example,
> when the trigger bit is 0, then virtual counter trigger an event for 
> every
> two cycles.
> 
> Fixes: 037f637767a8 ("drivers: clocksource: add support for
>        ARM architected timer event stream")

Fixes: tags should on a single line.

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index 777d38c..e3b2ee0 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -824,10 +824,14 @@ static void arch_timer_configure_evtstream(void)
>  {
>  	int evt_stream_div, pos;
> 
> -	/* Find the closest power of two to the divisor */
> -	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
> +	/*
> +	 * Find the closest power of two to the divisor. As the event
> +	 * stream can at most be generated at half the frequency of the
> +	 * counter, use half the frequency when computing the divider.
> +	 */
> +	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
>  	pos = fls(evt_stream_div);
> -	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> +	if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>  		pos--;

You don't explain why you are special-casing pos == 1.

>  	/* enable event stream */
>  	arch_timer_evtstrm_enable(min(pos, 15));

Also, please Cc the subsystem maintainers:

CLOCKSOURCE, CLOCKEVENT DRIVERS
M:      Daniel Lezcano <daniel.lezcano@linaro.org>
M:      Thomas Gleixner <tglx@linutronix.de>
L:      linux-kernel@vger.kernel.org
S:      Supported
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 
timers/core
F:      Documentation/devicetree/bindings/timer/
F:      drivers/clocksource/

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
