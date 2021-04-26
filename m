Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB97036B4C4
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhDZOWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:22:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34410 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhDZOWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:22:03 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619446880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJ6EOI6m5aMtbVSyjGx8P9B6cH6gCK1DbxS5kxDcTwI=;
        b=Qm6325BMyee6Edzoz1xvthynaLYkXLggmi0oO4aRuKO8nNMGIskj9zRTet9/4FEVuo7LM6
        Ko3+9g+NRo3cnPSiiNsKnGzzWzNV13DjMuT4XFzNHGbMnbQyzbuLdygJmQBzzw+ylo+OjL
        vKxFpPMHiA8xll1S5ZJLhuKrBTwv2mzxcjLVDY4zN9dpC98t/QH6zn9uBJJ99HhmYFefbs
        4KbCbNwPLf7MDyXMM0Q4txG2vXKoJX42/RcqP5xyhYkbWWzt5uAHFwkwEZYA6rO3ut9WT6
        Xu5A8pfYD5PufM8B2c9jXQZdaTwPGJlAMl2FAWzss9YieGOdplpRvdQN3pAlAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619446880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJ6EOI6m5aMtbVSyjGx8P9B6cH6gCK1DbxS5kxDcTwI=;
        b=c7fOkmvGbRyRpgY6VCsiH/tbCpAMe/hN2vAOuS17HNIhTe2DUK89BNdoYoDe9LdUX7vBAM
        SubDH6mOYy3QlkDA==
To:     Hikaru Nishida <hikalium@chromium.org>, kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC PATCH 6/6] x86/kvm: Add a guest side support for virtual suspend time injection
In-Reply-To: <20210426090644.2218834-7-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org> <20210426090644.2218834-7-hikalium@chromium.org>
Date:   Mon, 26 Apr 2021 16:21:20 +0200
Message-ID: <87mttlt9cv.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26 2021 at 18:06, Hikaru Nishida wrote:
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
> +/*
> + * timekeeping_inject_suspend_time - Inject virtual suspend time
> + * if it is requested by kvm host.
> + * This function should be called under holding timekeeper_lock and
> + * only from timekeeping_advance().
> + */
> +static void timekeeping_inject_virtual_suspend_time(struct timekeeper *tk)
> +{
> +	struct timespec64 delta;
> +	u64 suspend_time;
> +
> +	suspend_time = kvm_get_suspend_time();
> +	if (suspend_time <= tk->suspend_time_injected) {
> +		/* Sufficient amount of suspend time is already injected. */

What's a sufficient amount of suspend time?

> +		return;
> +	}
> +	delta = ns_to_timespec64(suspend_time - tk->suspend_time_injected);
> +	__timekeeping_inject_sleeptime(tk, &delta);
> +	tk->suspend_time_injected = suspend_time;
> +}
> +#endif
>
> +
>  /*
>   * timekeeping_advance - Updates the timekeeper to the current time and
>   * current NTP tick length
> @@ -2143,6 +2166,10 @@ static void timekeeping_advance(enum timekeeping_adv_mode mode)
>  	/* Do some additional sanity checking */
>  	timekeeping_check_update(tk, offset);
>  
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST

There are better ways than slapping #ifdefs into the code.

> +	timekeeping_inject_virtual_suspend_time(tk);
> +#endif

So this is invoked on every tick? How is that justified?

The changelog is silent about this, but that's true for most of your
changelogs as they describe what the patch is doing and not the WHY,
which is the most important information. Also please do a

grep 'This patch' Documentation/process

the match there will lead you also to documentation about changelogs in
general.

Now to the overall approach, which works only for a subset of host
systems:

  Host resumes
      timekeeping_resume()

        delta = get_suspend_time_if_possible(); <----- !!

        kvm_arch_timekeeping_inject_sleeptime(delta)
            TSC offset adjustment on all vCPUs
            and prepare for magic injection

So this fails to work on host systems which cannot calculate the suspend
time in timekeeping_resume() because the clocksource stops in suspend
and some other source, e.g. RTC, is not accessible at that point in
time. There is a world outside of x86.

So on the host side the notification for the hypervisor has to be in
__timekeeping_inject_sleeptime() obviously.

Also I explicitely said hypervisor as we really don't want anything KVM
only here because there are other hypervisors which might want to have
the same functionality. We're not going to add a per hypervisor call
just because.

Now to the guest side:

  Guest is unfrozen

   clocksource in guest restarts at the point of freeze (TSC on x86)

     All CLOCK ids except CLOCK_MONOTONIC continue from the state of
     freeze up to the point where the first tick() after unfreeze
     happens in the guest.
     
     Now that first tick does sleep time injection which makes all
     clocks except CLOCK_MONOTONIC jump forward by the amount of time
     which was spent in suspend on the host.

     But why is this gap correct? The first tick after unfreeze might be
     up to a jiffie away.

Again the changelog is silent about this. 

Also for the guest side there has to be a better way than lazily polling
a potential suspend injection on every tick and imposing the overhead
whether it's needed or not.

That's a one off event and really should be handled by some one off
injection mechanism which then invokes the existing
timekeeping_inject_sleeptime64(). There is no need for special
KVM/hypervisor magic in the core timekeeping code at all.

Seriously, if the only way to handle one off event injection from
hypervisor to guest is by polling, then there is a fundamental design
flaw in KVM or whatever hypervisor.

Thanks,

        tglx
