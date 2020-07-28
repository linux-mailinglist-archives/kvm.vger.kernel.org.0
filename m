Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CCF23077D
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 12:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgG1KQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 06:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbgG1KQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 06:16:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BFB320714;
        Tue, 28 Jul 2020 10:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595931409;
        bh=ZfZF4pLvNemxD3En2Fwag4OkbrDfzKVU9SSSrL6fd/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VBdHKzomeWjgG1TMubp9tgrJfSfvIiWmv/K4FkXE5Rs7AJCr+6dTw7JhR+SJdMQYt
         fPlyE+EJ3CP6EqlEzoY0Ft3LE0pMPFyKPhAVwGK3Qo4iqhoODr1mWy8T3OvnA7FuDq
         4MT7WpcnF3emS2LhtbRxOesdw6RmcyTlTn3bQdJM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k0Mf9-00FcMr-Ug; Tue, 28 Jul 2020 11:16:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Jul 2020 11:16:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [RESEND PATCH] drivers: arm arch timer: Correct fault programming
 of CNTKCTL_EL1.EVNTI
In-Reply-To: <20200717092104.15428-1-zhukeqian1@huawei.com>
References: <20200717092104.15428-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <3a95ec8ce3e34d86c09f9b1b4f17d0ad@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-17 10:21, Keqian Zhu wrote:
> ARM virtual counter supports event stream. It can only trigger an event
> when the trigger bit of CNTVCT_EL0 changes from 0 to 1 (or from 1 to 
> 0),
> so the actual period of event stream is 2 ^ (cntkctl_evnti + 1). For
> example, when the trigger bit is 0, then it triggers an event for every
> two cycles.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index ecf7b7db2d05..06d99a4b1b9b 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -799,10 +799,20 @@ static void __arch_timer_setup(unsigned type,
>  static void arch_timer_evtstrm_enable(int divider)
>  {
>  	u32 cntkctl = arch_timer_get_cntkctl();
> +	int cntkctl_evnti;
> +
> +	/*
> +	 * Note that it can only trigger an event when the trigger bit
> +	 * of CNTVCT_EL0 changes from 1 to 0 (or from 0 to 1), so the
> +	 * actual period of event stream is 2 ^ (cntkctl_evnti + 1).
> +	 */
> +	cntkctl_evnti = divider - 1;
> +	cntkctl_evnti = min(cntkctl_evnti, 15);
> +	cntkctl_evnti = max(cntkctl_evnti, 0);
> 
>  	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
>  	/* Set the divider and enable virtual event stream */
> -	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
> +	cntkctl |= (cntkctl_evnti << ARCH_TIMER_EVT_TRIGGER_SHIFT)
>  			| ARCH_TIMER_VIRT_EVT_EN;
>  	arch_timer_set_cntkctl(cntkctl);
>  	arch_timer_set_evtstrm_feature();
> @@ -816,10 +826,11 @@ static void arch_timer_configure_evtstream(void)
>  	/* Find the closest power of two to the divisor */
>  	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
>  	pos = fls(evt_stream_div);
> -	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> +	if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>  		pos--;
> +
>  	/* enable event stream */
> -	arch_timer_evtstrm_enable(min(pos, 15));
> +	arch_timer_evtstrm_enable(pos);
>  }
> 
>  static void arch_counter_set_user_access(void)

This looks like a very convoluted fix. If the problem you are
trying to fix is that the event frequency is at most half of
that of the counter, why isn't the patch below the most
obvious fix?

Thanks,

         M.

diff --git a/drivers/clocksource/arm_arch_timer.c 
b/drivers/clocksource/arm_arch_timer.c
index 6c3e84180146..0a65414b781f 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -824,8 +824,12 @@ static void arch_timer_configure_evtstream(void)
  {
  	int evt_stream_div, pos;

-	/* Find the closest power of two to the divisor */
-	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	/*
+	 * Find the closest power of two to the divisor. As the event
+	 * stream can at most be generated at half the frequency of the
+	 * counter, use half the frequency when computing the divider.
+	 */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
  	pos = fls(evt_stream_div);
  	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
  		pos--;

-- 
Jazz is not dead. It just smells funny...
