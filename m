Return-Path: <kvm+bounces-28881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA8599E851
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 14:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBE761C2229A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06431EBA09;
	Tue, 15 Oct 2024 12:04:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505031CFEA9;
	Tue, 15 Oct 2024 12:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993860; cv=none; b=lvXbWwLTgGFf63WoguD3Bvd41rw9tcL+hembZRvIrDQY+84x2PR5gQ+gx33Rb4AKaGNy37csJomnCXcVOunD98yveXr2HmQq4zdbNx1EBRbT36AXUV2vLOE6WNERXqejKGHz+kPK/JPtzC1lZ/cHl7kKEsIgaFUV/S9m7rNULoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993860; c=relaxed/simple;
	bh=XMjnB8RwZmkonCHDLqHmGR5FGhVnHjb/lhHRhE0YbNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kv9dFTm312wBJG2IFsESHrUgPeC1o76Kp92BCRIr9yVzxpdiWKJ02bc0W5uKyk8QXbaNx00syVjgSGpoHoAMx85yeAmqJZlEf2XmWGnfHedYfVo+BgjvO9/stERJY95qz30PsdnBDaylWxAPa4mpfreK2PwsN1JGV8oIGY0kHTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258F0C4CEC6;
	Tue, 15 Oct 2024 12:04:14 +0000 (UTC)
Date: Tue, 15 Oct 2024 13:04:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
	cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <Zw5aPAuVi5sxdN5-@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925232425.2763385-2-ankur.a.arora@oracle.com>

On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..fc1204426158 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>  
>  	raw_local_irq_enable();
>  	if (!current_set_polling_and_test()) {
> -		unsigned int loop_count = 0;
>  		u64 limit;
>  
>  		limit = cpuidle_poll_time(drv, dev);
>  
>  		while (!need_resched()) {
> -			cpu_relax();
> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> -				continue;
> -
> -			loop_count = 0;
> +			unsigned int loop_count = 0;
>  			if (local_clock_noinstr() - time_start > limit) {
>  				dev->poll_time_limit = true;
>  				break;
>  			}
> +
> +			smp_cond_load_relaxed(&current_thread_info()->flags,
> +					      VAL & _TIF_NEED_RESCHED ||
> +					      loop_count++ >= POLL_IDLE_RELAX_COUNT);

The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
never set. With the event stream enabled on arm64, the WFE will
eventually be woken up, loop_count incremented and the condition would
become true. However, the smp_cond_load_relaxed() semantics require that
a different agent updates the variable being waited on, not the waiting
CPU updating it itself. Also note that the event stream can be disabled
on arm64 on the kernel command line.

Does the code above break any other architecture? I'd say if you want
something like this, better introduce a new smp_cond_load_timeout()
API. The above looks like a hack that may only work on arm64 when the
event stream is enabled.

A generic option is udelay() (on arm64 it would use WFE/WFET by
default). Not sure how important it is for poll_idle() but the downside
of udelay() that it won't be able to also poll need_resched() while
waiting for the timeout. If this matters, you could instead make smaller
udelay() calls. Yet another problem, I don't know how energy efficient
udelay() is on x86 vs cpu_relax().

So maybe an smp_cond_load_timeout() would be better, implemented with
cpu_relax() generically and the arm64 would use LDXR, WFE and rely on
the event stream (or fall back to cpu_relax() if the event stream is
disabled).

-- 
Catalin

