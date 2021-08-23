Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A78D3F4E26
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhHWQRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhHWQRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 12:17:41 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418BAC061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:16:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q21so1456601plq.3
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ryhD7Cthvbr45hQrpnqITGrpB6V3gOLxyGixZ7GwrfQ=;
        b=Y/VkN+1gxsoSe3hsQkEe6PMVj7mm2IHbg36U1kjpignPshE6jeCwDWaJ2eGVOcy7fo
         g7HYe8UWQTY8A0vodGIdznQPx5HKdAr+AG1tkba7z+zr6NlXwNJ6puA6ZimMj4O5i72w
         p55fh+Dh7cRtGdX/l8acD/lrMu4AYKWyTqbG1IRPB2uGF4IFb5KA+coz0LB2DMNzGiq4
         YQc6WOXOeRmaSygsObdne7yJZmDvXPV7ZZnNUgDcxlvHF4zwoHNUE4bfnQunQQNH3iEM
         XXBxAwCro3B+wx1+YOs4XTXhOJQQEc4FO1kckqijf+W2SrFQGXSbepi/Zo5z6lM8Ak4I
         GicQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ryhD7Cthvbr45hQrpnqITGrpB6V3gOLxyGixZ7GwrfQ=;
        b=Z+Hkxg+7ou4VSIVV1/ypiTEzDEeNWf+mZ7SbCZD782OnKB7joBx/hz6UFiYP77+/cC
         61VU4mrRt3AHCDhHtkfj7M9GRM1rdpo4oM/up/2RS2gZMIWG7BYexy6jehBemO+au2EX
         vVMlR2pvmKKpMMkB9r9imWlGZdkIizC4PX75Jt1PfzwiLFPUtbloAFcKQKzPruE7Ar9M
         G0jIt4Kj/KDR/i2Cl+eRHsgp6eAFwCDRf50fo7FLykZ+4lA2EOMLxRMFyyJozLsdAQWP
         GAvtQQHLWhIp761TqNidjQA0BW9n/Yxgg9kNRyZAK5l/p09l0YTJzsnPsQ0pzcSFRi5G
         1arA==
X-Gm-Message-State: AOAM532pwEaouzfs8BEgs1AIyYA/b87wHHDYo3DSpOvEuhSbslT1fby5
        e5zMmfwQzAnmi+OQVB3y7+wdRQ==
X-Google-Smtp-Source: ABdhPJzv654+gSOvsBhG6JLFQHFEeDZqCyH0hXgt9M8TwxOdfjcH9xRvORZYmiN8Q7XjIgNcrkTbBw==
X-Received: by 2002:a17:90a:12ca:: with SMTP id b10mr7399333pjg.180.1629735417434;
        Mon, 23 Aug 2021 09:16:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b14sm16201529pfo.76.2021.08.23.09.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 09:16:56 -0700 (PDT)
Date:   Mon, 23 Aug 2021 16:16:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, kvm@vger.kernel.org,
        Artem Kashkanov <artem.kashkanov@intel.com>
Subject: Re: [PATCH] kvm/x86: Fix PT "host mode"
Message-ID: <YSPJ8/PgcFRnp4N9@google.com>
References: <20210823134239.45402-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823134239.45402-1-alexander.shishkin@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021, Alexander Shishkin wrote:
> Regardless of the "pt_mode", the kvm driver installs its interrupt handler
> for Intel PT, which always overrides the native handler, causing data loss
> inside kvm guests, while we're expecting to trace them.
> 
> Fix this by only installing kvm's perf_guest_cbs if pt_mode is set to
> guest tracing.

Uh, regardless of the correctness of such a change (spoiler alert), making an
enormous leap from "one thing is wrong" to "nuke it all!" needs way more
justfication/explanation.  Or more realistically, such a leap should be a good
indication that the proposed change is not correct.

> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Fixes: ff9d07a0e7ce7 ("KVM: Implement perf callbacks for guest sampling")

This should be another clue that the fix isn't correct.  That patch is from 2010,
Intel PT was announced in 2013 and merged in 2019.

> Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
> Tested-by: Artem Kashkanov <artem.kashkanov@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/vmx.c          |  6 ++++++
>  arch/x86/kvm/x86.c              | 10 ++++++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..3ba0001e7388 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -268,6 +268,8 @@ static struct kmem_cache *x86_fpu_cache;
>  
>  static struct kmem_cache *x86_emulator_cache;
>  
> +static int __read_mostly intel_pt_enabled;
> +
>  /*
>   * When called, it means the previous get/set msr reached an invalid msr.
>   * Return true if we want to ignore/silent this failed msr access.
> @@ -8194,7 +8196,10 @@ int kvm_arch_init(void *opaque)
>  
>  	kvm_timer_init();
>  
> -	perf_register_guest_info_callbacks(&kvm_guest_cbs);
> +	if (ops->intel_pt_enabled && ops->intel_pt_enabled()) r

This is not remotely correct.  vmx.c's "pt_mode", which is queried via this path,
is modified by hardware_setup(), a.k.a. kvm_x86_ops.hardware_setup(), which runs
_after_ this code.  And as alluded to above, these are generic perf callbacks,
installing them if and only if Intel PT is enabled in a specific mode completely
breaks "regular" perf.

I'll post a small series, there's a bit of code massage needed to fix this
properly.  The PMI handler can also be optimized to avoid a retpoline when PT is
not exposed to the guest.

> +		perf_register_guest_info_callbacks(&kvm_guest_cbs);
> +		intel_pt_enabled = 1;
> +	}
>  
>  	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>  		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> @@ -8229,7 +8234,8 @@ void kvm_arch_exit(void)
>  		clear_hv_tscchange_cb();
>  #endif
>  	kvm_lapic_exit();
> -	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
> +	if (intel_pt_enabled)
> +		perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
>  
>  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>  		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
> -- 
> 2.32.0
> 
