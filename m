Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042B9584718
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiG1UlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiG1UlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:41:20 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD942683E7
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:41:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id iw1so2791304plb.6
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 13:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HFpO6jXv+thLIEQmIbyzTm5jXFu4Gb0lIjJbAQsrEBg=;
        b=aoqiVzJqBUfNWGKmug4CGVbsDsNx+O56FJEyWStkwyukKWyC0Oh9JgPMLicB6uvdAS
         FhJwN8mlZCK1chuNvxIAueX6DRpnawWaKcvjicasit8HCZUKQzDXouMjGsmuKynft9U9
         RE6V3Xx51zrUJnpMcMXN1kPM88/Ld7cBfLoFBaRWZv72mG6a0RuE6j86k7WlV5NWRycI
         STaX6kpYhyLRJFsDJRoskx4z7OLJLa2ddRpg5LxZyJFYIC4nMGaPQoAtIm2MFJWwqHMw
         zY5aD9YNHbIKQ31VtzNXg86MzdDGpzrySC1pMJ8it60kedxFcMSv9JmbGzbosDJGwGQU
         Oxcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HFpO6jXv+thLIEQmIbyzTm5jXFu4Gb0lIjJbAQsrEBg=;
        b=yfR6n+VWr8fsC4IEUX5r+UaVWMexxTAKkMPhp/VxiRTzU35uanJnRHBkeXFbYccYyO
         0bEN9EC4zX1pQuZYQT/szxk4qHlBVo6Dn6QIhfJvKMZRNJtyEshh57XOh9EMxrpsI0hg
         NPWPQjOkHNIB8SGigL5Ij30V1Sx5ULRgBSvE40LqKcCmXR4m68pb8Z4HccNGVBHoDv0i
         XI/sKXYReLH8yzQvrf8wUZ+G2AdAU6zsjJaCZQmCXlqx6vlWHvtR0WVpzqDCQDCUDpXq
         GInbeRGIzQ5bolVyNEfBBPnxJ/nS75R2fsdG7nZD3v5yB4035roybOMveWMx9IV8O1fn
         M7IA==
X-Gm-Message-State: ACgBeo0xSk5YiS8l8WpVvwQZNN1UdG/wHnrMCaO7CD05cc1GffYXIM7+
        dBw3AUzXC1Saciavjh2sW2dWdw==
X-Google-Smtp-Source: AA6agR54UwxPWT+BJOMkCljAJZfwv/32I4EBEEeqIHnPKrlI00ej/DcuGkMtWit4bE0esUs0+oMo5g==
X-Received: by 2002:a17:90a:8c88:b0:1f2:12b0:ae9e with SMTP id b8-20020a17090a8c8800b001f212b0ae9emr1208812pjo.42.1659040878988;
        Thu, 28 Jul 2022 13:41:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b0016daee46b72sm1713570plb.237.2022.07.28.13.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 13:41:18 -0700 (PDT)
Date:   Thu, 28 Jul 2022 20:41:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Coleman Dietsch <dietschc@csp.edu>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86/xen: Fix bug in kvm_xen_vcpu_set_attr()
Message-ID: <YuL0auT3lFhfQHeY@google.com>
References: <20220728194736.383727-1-dietschc@csp.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728194736.383727-1-dietschc@csp.edu>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Be more specific in the shortlog.  "Fix a bug in XYZ" doesn't provide any info
about the bug itself, and can even become frustratingly stale if XYZ is renamed.
I believe we should end up with two patches (see below), e.g.

  KVM: x86/xen: Initialize Xen timer only once (when it's NOT running)

and
  
  KVM: x86/xen: Stop Xen timer before changing the IRQ vector

Note, I'm assuming timer_virq is a vector of some form, I haven't actually looked
that far into the code.

On Thu, Jul 28, 2022, Coleman Dietsch wrote:
> This crash appears to be happening when vcpu->arch.xen.timer is already set

Instead of saying "This crash", provide the actual splat (sanitized to make it
more readable).  That way readers, reviewers, and archaeologists don't need to
open up a hyperlink to get details on what broken.

> and kvm_xen_init_timer(vcpu) is called.

Wrap changelogs at ~75 chars.

> During testing with the syzbot reproducer code it seemed apparent that the
> else if statement in the KVM_XEN_VCPU_ATTR_TYPE_TIMER switch case was not
> being reached, which is where the kvm_xen_stop_timer(vcpu) call is located.

Neither the shortlog nor the changelog actually says anything about what is actually
being changed.

> Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
> Reported-and-tested-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
> Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
> ---
>  arch/x86/kvm/xen.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 610beba35907..4b4b985813c5 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -707,6 +707,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  		break;
>  
>  	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> +		/* Stop current timer if it is enabled */
> +		if (kvm_xen_timer_enabled(vcpu)) {
> +			kvm_xen_stop_timer(vcpu);
> +			vcpu->arch.xen.timer_virq = 0;
> +		}
> +
>  		if (data->u.timer.port) {
>  			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
>  				r = -EINVAL;

I'm not entirely sure this is correct.  Probably doesn't matter, but there's a
subtle ABI change here in that invoking the ioctl with a "bad" priority will
cancel any existing timer.

And there appear to be two separate bugs: initializing the hrtimer while it's
running, and not canceling a running timer before changing timer_virq.

Calling kvm_xen_init_timer() on "every" KVM_XEN_VCPU_ATTR_TYPE_TIMER is odd and
unnecessary, it only needs to be called once during vCPU setup.  If Xen doesn't
have such a hook, then a !ULL check can be done on vcpu->arch.xen.timer.function
to initialize the timer on-demand.

With that out of the way, the code can be streamlined a bit, e.g. something like
this?

	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
		if (data->u.timer.port &&
		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
			r = -EINVAL;
			break;
		}

		if (!vcpu->arch.xen.timer.function)
			kvm_xen_init_timer(vcpu);

		/* Stop the timer (if it's running) before changing the vector. */
		kvm_xen_stop_timer(vcpu);
		vcpu->arch.xen.timer_virq = data->u.timer.port;

		if (data->u.timer.port && data->u.timer.expires_ns)
			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
					    data->u.timer.expires_ns -
					    get_kvmclock_ns(vcpu->kvm));
		r = 0;
		break;

> @@ -720,9 +726,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
>  						    data->u.timer.expires_ns -
>  						    get_kvmclock_ns(vcpu->kvm));
> -		} else if (kvm_xen_timer_enabled(vcpu)) {
> -			kvm_xen_stop_timer(vcpu);
> -			vcpu->arch.xen.timer_virq = 0;
>  		}
>  
>  		r = 0;
> -- 
> 2.34.1
> 
