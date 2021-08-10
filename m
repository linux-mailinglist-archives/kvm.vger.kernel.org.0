Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412863E7CB8
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242144AbhHJPsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242096AbhHJPs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 11:48:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771E6C0613C1;
        Tue, 10 Aug 2021 08:48:04 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628610483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T74u7wivCD+70aSSFcjrY7qzEdPjRIB3i17jgj6Jj7M=;
        b=GQsP4ydZdaizjI7aDD8jal0K4ynFGpb8UgdDtWJ8QCjeKElBVTmFd+w7RcJqsRpZLUGOBM
        uoBElAi/ZAxWJlUNd6UZyFTSLfVn/jNIRVfCwrvbfr+18wYSaGGfWRBhd1FmG8ZrKNq4Bh
        QdNu3/mpxlwba21pm69poQeA1LdON2lLFv6ZYEhwVBDkAlLWEqcuvGWONXHfFROHuryjos
        x6iExbEuT1YUYzbuBgGPm+3bV351Ktg/aFn4CwngkqyCiI6NlghyqmWyRcKHKyAZTPd8ve
        zKLCDIMzlamwgyH77NaHEAVOoGPMoh6PclcFPWAgGch1kn5FBMg1xTlzu08eng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628610483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T74u7wivCD+70aSSFcjrY7qzEdPjRIB3i17jgj6Jj7M=;
        b=XJbcS3rj56HrvStKFW2KEnB/xuskVXpnKbjLsNZtj7rhOXWN6zirJbWraym7MHLHJNCHuK
        hUNnaw9IPLWcutCA==
To:     Hikaru Nishida <hikalium@chromium.org>,
        linux-kernel@vger.kernel.org, dme@dme.org, mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Juergen Gross <jgross@suse.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Mike Travis <mike.travis@hpe.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [v2 PATCH 4/4] x86/kvm: Add guest side support for virtual
 suspend time injection
In-Reply-To: <20210806190607.v2.4.I2cbcd43256eacc3c92274adff6d0458b6a9c15ee@changeid>
References: <20210806100710.2425336-1-hikalium@chromium.org>
 <20210806190607.v2.4.I2cbcd43256eacc3c92274adff6d0458b6a9c15ee@changeid>
Date:   Tue, 10 Aug 2021 17:48:02 +0200
Message-ID: <87lf59qp1p.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06 2021 at 19:07, Hikaru Nishida wrote:
>  arch/x86/Kconfig                    | 13 ++++++++++
>  arch/x86/include/asm/idtentry.h     |  4 +++
>  arch/x86/include/asm/kvm_para.h     |  9 +++++++
>  arch/x86/kernel/kvmclock.c          | 40 +++++++++++++++++++++++++++++
>  include/linux/timekeeper_internal.h |  4 +++
>  kernel/time/timekeeping.c           | 33 ++++++++++++++++++++++++

Again, this wants to be split into infrastructure and usage.

> --- a/include/linux/timekeeper_internal.h
> +++ b/include/linux/timekeeper_internal.h
> @@ -124,6 +124,10 @@ struct timekeeper {
> 	u32			ntp_err_mult;
> 	/* Flag used to avoid updating NTP twice with same second */
> 	u32			skip_second_overflow;
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
> +	/* suspend_time_injected keeps the duration injected through kvm */
> +	u64			suspend_time_injected;

This is KVM only, so please can we have a name for that struct member
which reflects this?

> +#endif
>  #ifdef CONFIG_DEBUG_TIMEKEEPING
> 	long			last_warning;
> 	/*

> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 3ac3fb479981..424c61d38646 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -2125,6 +2125,39 @@ static u64 logarithmic_accumulation(struct timekeeper *tk, u64 offset,
>  	return offset;
>  }
>  
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
> +/*
> + * timekeeping_inject_virtual_suspend_time - Inject virtual suspend time
> + * when requested by the kvm host.

If this is an attempt to provide a kernel-doc comment for this function,
then it's clearly a failed attempt and aside of that malformatted.

> + * This function should be called under irq context.

Why? There is no reason for being called from interrupt context and
nothing inforces it.

> + */
> +void timekeeping_inject_virtual_suspend_time(void)
> +{
> +	/*
> +	 * Only updates shadow_timekeeper so the change will be reflected
> +	 * on the next call of timekeeping_advance().

No. That's broken.

    timekeeping_inject_virtual_suspend_time();

    do_settimeofday() or do_adjtimex()

       timekeeping_update(tk, TK_MIRROR...);

and your change to the shadow timekeeper is gone.

Of course there is also no justification for this approach. What's wrong
with updating it right away?

> +	 */
> +	struct timekeeper *tk = &shadow_timekeeper;
> +	unsigned long flags;
> +	struct timespec64 delta;
> +	u64 suspend_time;

Please sort variables in reverse fir tree order and not randomly as you
see fit.

> +
> +	raw_spin_lock_irqsave(&timekeeper_lock, flags);
> +	suspend_time = kvm_get_suspend_time();
> +	if (suspend_time > tk->suspend_time_injected) {
> +		/*
> +		 * Do injection only if the time is not injected yet.
> +		 * suspend_time and tk->suspend_time_injected values are
> +		 * cummrative, so take a diff and inject the duration.

cummrative?

> +		 */
> +		delta = ns_to_timespec64(suspend_time - tk->suspend_time_injected);
> +		__timekeeping_inject_sleeptime(tk, &delta);
> +		tk->suspend_time_injected = suspend_time;

It's absolutely unclear how this storage and diff magic works and the
comment is not helping someone not familiar with the implementation of
kvm_get_suspend_time() and the related code at all. Please explain
non-obvious logic properly.

Thanks,

        tglx




