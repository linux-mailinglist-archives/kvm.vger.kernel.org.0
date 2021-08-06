Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962BE3E2E43
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 18:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhHFQUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 12:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhHFQUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 12:20:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F19CC0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 09:20:13 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q2so7708702plr.11
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lk/rklBGJbLUUQZyoq+gs1+H5iN5EBlS7CuTTnKKDKA=;
        b=Z3015pl6wjzFCtaiptoQofYXucCx2JNzuIpRkBDN/T/0deeTpz66FIaPsdm9qTiMAh
         EHX6DAN50du5HC2tIEmUBFCUw/i18du9l+Sru0/uh/TUezaeTCcs1+Y7+OSUxB1gnij8
         kINmzKoOE/QX1hReUhFX3A7UT5M2Zh0CZHY5fHNhndH2S1Rmqm3501DTrWjCYe9KP3dC
         TWfK5RaSSpWFeaePZYkf5ZawD8wQ6eb0p7XTfViPYX9qgdIwfOgRFaSAq7FcOnfZHyIM
         aPQvG3xBb8TG/4euCYq2rj1iOi+DrmEjSGVnkFc1uZOczxKQOErzL4/N6HwybGHw85UG
         yl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lk/rklBGJbLUUQZyoq+gs1+H5iN5EBlS7CuTTnKKDKA=;
        b=OGVhvEn60rmiSfss7XMDcTeXIAKtgeEh+tEe6XqqadLRnw8b6NGxFQD9PApth7sDV2
         Z/rNEKeBzK9KzHxLwzvm15CZX0t/sStH9f0dXO+bXcUaIaFOXBqFjRdjR4CojHoZ1bO3
         UzY/xz4wJXTphvtwC+EQzUhVmbGUEJnNEA//bfaZwcP6Ylu8lJMakVRzyEVRld/yzCdK
         5AWmoczOm1F1h1BqViYr7Euci+M7ZEUERzRMebNPHalhul1p2tUafB2P8cNYrsf496ax
         mZA3UNd9Q9oH2hZLH+RElMZ69GuNYB4KHSmsYUVNkYEqX1YP1wYV+BGJTxnaHCswRFFE
         J7Og==
X-Gm-Message-State: AOAM531hhy0s2TW0WCKDiuHG6X9rJbTzkbinlyZA5WU2B153bv0i6wcg
        Yq+qXZ8cUbUKbTDLcGZDhWoUMw==
X-Google-Smtp-Source: ABdhPJz8HLbzCuo+RUCF2uZXWWMYbgf4yJo1F05mVL/lyb/S0lk1Bc1PHwS+dR6FuMKX+2qM62ErRA==
X-Received: by 2002:a17:902:f295:b029:12c:a253:7087 with SMTP id k21-20020a170902f295b029012ca2537087mr9252966plc.6.1628266812776;
        Fri, 06 Aug 2021 09:20:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 6sm11553582pfg.108.2021.08.06.09.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 09:20:12 -0700 (PDT)
Date:   Fri, 6 Aug 2021 16:20:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, ssouhlal@freebsd.org,
        hikalium@chromium.org, senozhatsky@chromium.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm,x86: Use the refined tsc rate for the guest tsc.
Message-ID: <YQ1hOJNMnD6gCRjD@google.com>
References: <20210803075914.3070477-1-suleiman@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803075914.3070477-1-suleiman@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"KVM: x86:" is the preferred scope.  And for whatever reason, punctuation at the
end of the shortlog is almost always omitted.

On Tue, Aug 03, 2021, Suleiman Souhlal wrote:
> Prior to this change,

In the changelog proper, please state what change is being made before launching
into the effects of the change.  Oftentimes that does mean restating the shortlog,
but it's very helpful to reviewers/readers to provide a single cohesive/coherent
explanation.

> the initial tsc rate used by kvm would be the unrefined rate, instead of the
> refined rate that is derived later at boot and used for timekeeping. This can
> cause time to advance at different rates between the host and the guest.

This needs a lot more explanation, with a clear statement of the direct effects
of the change and with explicit references to variables and probably functions.
Normally I prefer abstraction over explicit code references, but in this case
there are too many ambiguous terms to understand the intended change without a
lot of staring.  E.g. at first blush, it's not obvious that "boot" refers to the
host kernel boot, especially for those of us that load KVM as a module.

And the statement "the initial tsc rate used by kvm would be the unrefined rate"
will not always hold true, e.g. when KVM is loaded long after boot.  That also
confused me.

IIUC, this "fixes" a race where KVM is initialized before the second call to
tsc_refine_calibration_work() completes.  Fixes in quotes because it doesn't
actually fix the race, it just papers over the problem to get the desired behavior.
If the race can't be truly fixed, the changelog should explain why it can't be
fixed, otherwise fudging our way around the race is not justifiable.

Ideally, we would find a way to fix the race, e.g. by ensuring KVM can't load or
by stalling KVM initialization until refinement completes (or fails).  tsc_khz is
consumed by KVM in multiple paths, and initializing KVM before tsc_khz calibration
is fully refined means some part of KVM will use the wrong tsc_khz, e.g. the VMX
preemption timer.  Due to sanity checks in tsc_refine_calibration_work(), the delta
won't be more than 1%, but it's still far from ideal.

> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/kvm/x86.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4116567f3d44..1e59bb326c10 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2199,6 +2199,7 @@ static atomic_t kvm_guest_has_master_clock = ATOMIC_INIT(0);
>  #endif
>  
>  static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
> +static DEFINE_PER_CPU(bool, cpu_tsc_khz_changed);
>  static unsigned long max_tsc_khz;
>  
>  static u32 adjust_tsc_khz(u32 khz, s32 ppm)
> @@ -2906,6 +2907,14 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
>  		return 1;
>  	}
> +	/*
> +	 * Use the refined tsc_khz instead of the tsc_khz at boot (which was
> +	 * not refined yet when we got it),

As above, this does not hold true in all cases.  And for anyone that isn't familiar
with tsc_refine_calibration_work(), the "refined tsc_khz instead of the tsc_khz"
blurb is borderline nonsensical.

> +	 * If the frequency does change, it does not get refined any further,
> +	 * so it is safe to use the one gotten from the notifiers.
> +	 */
> +	if (!__this_cpu_read(cpu_tsc_khz_changed))
> +		tgt_tsc_khz = tsc_khz;
>  	if (!use_master_clock) {
>  		host_tsc = rdtsc();
>  		kernel_ns = get_kvmclock_base_ns();
> @@ -8086,6 +8095,8 @@ static void tsc_khz_changed(void *data)
>  		khz = freq->new;
>  	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>  		khz = cpufreq_quick_get(raw_smp_processor_id());
> +	if (khz)
> +		__this_cpu_write(cpu_tsc_khz_changed, true);

On a system with a constant TSC and KVM loaded after boot, cpu_tsc_khz_changed
will never be true.  Ditto for the case where refinement fails.  That may not be
a functional issue, but it's confusing.

This also fails to gate other readers of kvm_guest_time_update.  In particular,
KVM_GET_CLOCK -> get_kvmclock_ns() will use the "wrong" frequency when userspace
is retrieving guest TSC.

>  	if (!khz)
>  		khz = tsc_khz;
>  	__this_cpu_write(cpu_tsc_khz, khz);
> -- 
> 2.32.0.554.ge1b32706d8-goog
> 
