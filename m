Return-Path: <kvm+bounces-28983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D8F9A0626
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 11:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5AC7B21853
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 09:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F91206069;
	Wed, 16 Oct 2024 09:55:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4A0205E31;
	Wed, 16 Oct 2024 09:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072503; cv=none; b=h8iKaoIT2nZ0Ubi3v6pPYQhrbBN2NCmNn0UO41dF+1a6DwcxGYb6LRYB9lQiD16ERtyOOJDTtevLKFFDdzrERnfcYXCkrhuBEl0hlVzAkMtj7zsNsRmHe+D2pXbWALri4vZ3CRzIs5/d+exyyuP1nnvaWs/DES3aVcqSSAEq+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072503; c=relaxed/simple;
	bh=8M58HS/R4VvqGI6hFuODSqEOAwlVkg+xTN/g/Q6zmBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCyDEGnv5s95+AZrojMy0sP1nz1BAJMZnlXWzAlvtGRwOLBN+yGgV02QOfFk7dHxTul7P99mptq+ayh4wktf8b8p1kYjgrPPbu/6A6i2eTC8tGoMTzVytjOu+rfyIsDzFX3c9lVTIpYMQSyS+8Zi8NVNMh7s6OauUZDroCqTf/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7F1C4CEC5;
	Wed, 16 Oct 2024 09:54:57 +0000 (UTC)
Date: Wed, 16 Oct 2024 10:54:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
	wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
	daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
	lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
	mtosatti@redhat.com, sudeep.holla@arm.com,
	misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <Zw-Nb-o76JeHw30G@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com>
 <87jze9rq15.fsf@oracle.com>
 <95ba9d4a-b90c-c8e8-57f7-31d82722f39e@gentwo.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95ba9d4a-b90c-c8e8-57f7-31d82722f39e@gentwo.org>

On Tue, Oct 15, 2024 at 03:40:33PM -0700, Christoph Lameter (Ampere) wrote:
> Index: linux/arch/arm64/lib/delay.c
> ===================================================================
> --- linux.orig/arch/arm64/lib/delay.c
> +++ linux/arch/arm64/lib/delay.c
> @@ -12,6 +12,8 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/timex.h>
> +#include <linux/sched/clock.h>
> +#include <linux/cpuidle.h>
> 
>  #include <clocksource/arm_arch_timer.h>
> 
> @@ -67,3 +69,27 @@ void __ndelay(unsigned long nsecs)
>  	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
>  }
>  EXPORT_SYMBOL(__ndelay);
> +
> +void cpuidle_wait_for_resched_with_timeout(u64 end)
> +{
> +	u64 start;
> +
> +	while (!need_resched() && (start = local_clock_noinstr()) < end) {
> +
> +		if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
> +
> +			/* Processor supports waiting for a specified period */
> +			wfet(xloops_to_cycles((end - start) * 0x5UL));
> +
> +		} else
> +		if (arch_timer_evtstrm_available() && start + ARCH_TIMER_EVT_STREAM_PERIOD_US * 1000 < end) {
> +
> +			/* We can wait until a periodic event occurs */
> +			wfe();
> +
> +		} else
> +			/* Need to spin until the end */
> +			cpu_relax();
> +	}
> +}

The behaviour above is slightly different from the current poll_idle()
implementation. The above is more like poll every timeout period rather
than continuously poll until either the need_resched() condition is true
_or_ the timeout expired. From Ankur's email, an IPI may not happen so
we don't have any guarantee that WFET will wake up before the timeout.
The only way for WFE/WFET to wake up on need_resched() is to use LDXR to
arm the exclusive monitor. That's what smp_cond_load_relaxed() does.

If you only need the behaviour proposed above, you might as well go for
udelay() directly. Otherwise I think we need to revisit Ankur's
smp_cond_load_timeout() proposal from earlier this year.

-- 
Catalin

