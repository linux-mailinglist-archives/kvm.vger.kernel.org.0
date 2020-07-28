Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502BD23043F
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 09:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgG1Hjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 03:39:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50334 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727045AbgG1Hjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 03:39:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7A34D52C142BC77B2F15;
        Tue, 28 Jul 2020 15:39:51 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 15:39:40 +0800
Subject: Re: [RESEND PATCH] drivers: arm arch timer: Correct fault programming
 of CNTKCTL_EL1.EVNTI
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200717092104.15428-1-zhukeqian1@huawei.com>
CC:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <b3d2fe2f-a64b-af37-dea0-fa76a14ac2bc@huawei.com>
Date:   Tue, 28 Jul 2020 15:39:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200717092104.15428-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Friendly ping.
Is this an effective bugfix?

On 2020/7/17 17:21, Keqian Zhu wrote:
> ARM virtual counter supports event stream. It can only trigger an event
> when the trigger bit of CNTVCT_EL0 changes from 0 to 1 (or from 1 to 0),
> so the actual period of event stream is 2 ^ (cntkctl_evnti + 1). For
> example, when the trigger bit is 0, then it triggers an event for every
> two cycles.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
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
> 
