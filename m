Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C6B3E7C04
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhHJPVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbhHJPVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 11:21:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258DDC0613C1;
        Tue, 10 Aug 2021 08:21:11 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628608865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yjOcV1ZbXoMI3ihNX/ApFO+OW54UPsBBZl6UAIAhwY=;
        b=4Chk8a2+U/WWTDyk/+PMixeOBzg4lW03Dm0iUXG+6fGvFrMNgdSQ+IJqjY3Ghz1VJQ8vZF
        cjC2nAJIHj4nAC/yOAalSxryuVca0HXvy6kmBaCY2IXjNbV5KhGIIgpqeirqPM8YBpjDIY
        1qQd8E8JqNXQIzcjGfJMIowCo4pqDlhmRs/8x8izYyPCTFREtMb1mzZ7LDnjxrcC1+iTkA
        OAtLgesBc8MWojMsTyQQV436Wbq6dcwGCG4gPQZ2+niO4LTs7gD6X9DODh5JYcLqpABSCZ
        +jIvaFA09gZVCxConiLNphZK7B6uRnerctgkbrF/DA4oLZiLdFrqSBMvIpGJNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628608865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yjOcV1ZbXoMI3ihNX/ApFO+OW54UPsBBZl6UAIAhwY=;
        b=pPQpEwirM7CTsd7+xaOMWrJbqqOYQXwVfNzR4SUFQYPPztovwpBINaMGm6Ps1Obp47g/dL
        8WAzYRrjPmj2PsCA==
To:     Hikaru Nishida <hikalium@chromium.org>,
        linux-kernel@vger.kernel.org, dme@dme.org, mlevitsk@redhat.com
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
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [v2 PATCH 3/4] x86/kvm: Add host side support for virtual
 suspend time injection
In-Reply-To: <20210806190607.v2.3.Ib0cb8ecae99f0ccd0e2814b310adba00b9e81d94@changeid>
References: <20210806100710.2425336-1-hikalium@chromium.org>
 <20210806190607.v2.3.Ib0cb8ecae99f0ccd0e2814b310adba00b9e81d94@changeid>
Date:   Tue, 10 Aug 2021 17:21:05 +0200
Message-ID: <87r1f1qqam.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06 2021 at 19:07, Hikaru Nishida wrote:

> This patch implements virtual suspend time injection support for kvm

git grep 'This patch' Documentation/process/

> hosts.
>
> If this functionality is enabled and the guest requests it, the host
> will stop all the clocks observed by the guest during the host's
> suspension and report the duration of suspend to the guest through
> struct kvm_host_suspend_time to give a chance to adjust CLOCK_BOOTTIME
> to the guest. This mechanism can be used to align the guest's clock
> behavior to the hosts' ones.
>
> Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
> ---
>
>  arch/x86/include/asm/kvm_host.h |   5 ++
>  arch/x86/kvm/Kconfig            |  13 ++++
>  arch/x86/kvm/cpuid.c            |   4 ++
>  arch/x86/kvm/x86.c              | 109 +++++++++++++++++++++++++++++++-
>  include/linux/kvm_host.h        |   8 +++
>  kernel/time/timekeeping.c       |   3 +

Please split this into adding the infrastructure and then implementing
the x86 side of it.

>  
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
> +void kvm_arch_timekeeping_inject_sleeptime(const struct timespec64 *delta);
 +#else
 +static inline void kvm_arch_timekeeping_inject_sleeptime(const struct timespec64 *delta){}
> +#endif /* CONFIG_KVM_VIRT_SUSPEND_TIMING */
> +
>  #endif
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 233ceb6cce1f..3ac3fb479981 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1797,6 +1797,9 @@ void timekeeping_resume(void)
>  	if (inject_sleeptime) {
>  		suspend_timing_needed = false;
>  		__timekeeping_inject_sleeptime(tk, &ts_delta);
> +#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
> +		kvm_arch_timekeeping_inject_sleeptime(&ts_delta);
> +#endif

which get's rid of these ugly ifdefs.

Also this is the wrong place because sleep time can be injected from
other places as well. This should be in __timekeeping_inject_sleeptime()
if at all.

Thanks,

        tglx
