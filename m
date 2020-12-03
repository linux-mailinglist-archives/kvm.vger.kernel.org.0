Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA72CD9B4
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgLCO7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbgLCO7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:59:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AEF2206D6;
        Thu,  3 Dec 2020 14:58:31 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kkq3v-00FhMk-F6; Thu, 03 Dec 2020 14:58:27 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 14:58:27 +0000
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
Subject: Re: [PATCH v2 1/2] clocksource: arm_arch_timer: Use stable count
 reader in erratum sne
In-Reply-To: <20200818032814.15968-2-zhukeqian1@huawei.com>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-2-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <c8e0506a7976deef0427a30b0d10e35b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steven.price@arm.com, drjones@redhat.com, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-18 04:28, Keqian Zhu wrote:
> In commit 0ea415390cd3 ("clocksource/arm_arch_timer: Use 
> arch_timer_read_counter
> to access stable counters"), we separate stable and normal count reader 
> to omit
> unnecessary overhead on systems that have no timer erratum.
> 
> However, in erratum_set_next_event_tval_generic(), count reader becomes 
> normal
> reader. This converts it to stable reader.
> 
> Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use
>        arch_timer_read_counter to access stable counters")

On a single line.

> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index 6c3e841..777d38c 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -396,10 +396,10 @@ static void
> erratum_set_next_event_tval_generic(const int access, unsigned long
>  	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
> 
>  	if (access == ARCH_TIMER_PHYS_ACCESS) {
> -		cval = evt + arch_counter_get_cntpct();
> +		cval = evt + arch_counter_get_cntpct_stable();
>  		write_sysreg(cval, cntp_cval_el0);
>  	} else {
> -		cval = evt + arch_counter_get_cntvct();
> +		cval = evt + arch_counter_get_cntvct_stable();
>  		write_sysreg(cval, cntv_cval_el0);
>  	}

With that fixed:

Acked-by: Marc Zyngier <maz@kernel.org>

This should go via the clocksource tree.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
