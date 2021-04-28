Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23EC36E1E9
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 01:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhD1W5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 18:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhD1W5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 18:57:41 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A29C06138C
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 15:56:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q10so45795373pgj.2
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 15:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j9J2Po6hg3Mws0Z8zIwA8YZmExUPMEbAlxsDVmpECto=;
        b=SGHxTwJlAK0ItXxEiNEHiyNq3bXcziNwt3q7yMHZXQWirJm5OGHF9HpvFMFKu4WSMp
         cKOyLBBhQrRV7g+JB2K3l6iUNdzCnw60IZDl+o1vVyRReZWT3cXzqR2YD/rpsDzOpiXS
         wBw6UVG52xR46FbG7sIwRJc1OOu1lnvuUQNK3GwLHF5V7fXkTaapTqy/Exvd05tF0Wkr
         wV5Z3r3tmE2YG9Zx4XIOq3FRm7x0fC+fWs/h0j5Or/z0X8psw2O9RAvGykngkvrG3dxs
         sRn7v8L1XI09Nl++tUaFZXtyfwt0ZOlAmgbz3f1snSOBBRx7fW5ieOkwbMVsfTSpTNSB
         bHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j9J2Po6hg3Mws0Z8zIwA8YZmExUPMEbAlxsDVmpECto=;
        b=oM+BQxA1OjHGH8uI6zCl5L5Z2/brLCWazZfMLG1i/fWGyRi/5ZxSUJ1rP5CJ5b0pla
         1rjNmORlyT8lnTAxl+0MeCwk21RE5MOw9iSwTi1uI3RSH8niCRi9MNUeXMgaMmovaLbr
         Dr06t07CQnGqQA0oHw4I1at2Zx0wSlhZQa31l/eAE/R8yV5teflsxxOzMqW44R2C0VSD
         MMC3LdSPWo1nBKcV78wtfPsIgIE6CCGrbv6P7zYlEiqzw7HTOAQxUg37bfHQdnN93U1R
         t++X0d1M078pMrIJ/DYORjz4RSHYRzLL7/lwaIAeTewCFOXuYz//WPj4dm6puhv7JDGf
         5+Sw==
X-Gm-Message-State: AOAM530H14u5MLCfaJe0ydwAnwaINqDtaMYc7gcIMWtRXHJ9dHKRCGE9
        GeU3TfjTv9Rto4JNWyP6KlADQA==
X-Google-Smtp-Source: ABdhPJx3OHZ8/hqLcVrY04nhXjnyxBow7PNlgjM6c+e7FkP3QPRVl0499+CVQL3qqh83h+bBiiUtOg==
X-Received: by 2002:a62:170e:0:b029:1fa:7161:fd71 with SMTP id 14-20020a62170e0000b02901fa7161fd71mr29938355pfx.35.1619650614924;
        Wed, 28 Apr 2021 15:56:54 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e5sm142067pgj.91.2021.04.28.15.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 15:56:54 -0700 (PDT)
Date:   Wed, 28 Apr 2021 22:56:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Accurately guarantee busy wait for timer to
 expire when using hv_timer
Message-ID: <YInoMjNJRgm3gUYX@google.com>
References: <1619608082-4187-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619608082-4187-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Commit ee66e453db13d (KVM: lapic: Busy wait for timer to expire when 
> using hv_timer) tries to set ktime->expired_tscdeadline by checking 
> ktime->hv_timer_in_use since lapic timer oneshot/periodic modes which 
> are emulated by vmx preemption timer also get advanced, they leverage 
> the same vmx preemption timer logic with tsc-deadline mode. However, 
> ktime->hv_timer_in_use is cleared before apic_timer_expired() handling, 
> let's delay this clearing in preemption-disabled region.
> 
> Fixes: ee66e453db13d (KVM: lapic: Busy wait for timer to expire when using hv_timer)

Well that's embarassing.  I suspect/hope I tested the case where start_hv_timer()
detects the timer already expired.  On the plus side, start_hv_timer() calls
cancel_hv_timer() after apic_timer_expired(), so there are unlikely to be hidden
side effects (and cancel_hv_timer() is tiny).

> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 152591f..c0ebef5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1913,8 +1913,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
>  	if (!apic->lapic_timer.hv_timer_in_use)
>  		goto out;
>  	WARN_ON(rcuwait_active(&vcpu->wait));
> -	cancel_hv_timer(apic);
>  	apic_timer_expired(apic, false);
> +	cancel_hv_timer(apic);
>  
>  	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
>  		advance_periodic_target_expiration(apic);
> -- 
> 2.7.4
> 
