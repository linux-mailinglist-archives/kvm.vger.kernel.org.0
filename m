Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6532B56E
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhCCHPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446560AbhCBRaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 12:30:05 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8239C061223
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 09:16:48 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t29so14233415pfg.11
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 09:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ldg8M6N/OFEgwkYYvOKSVPLbYJ0qxhkHRj9/dN3vWoY=;
        b=fhP2FKczCgCGk0pmQY2wn1hzRdo+XpFeRb+x+FuMga49qBJ8BVrJKmQV2rmTX0C7Js
         kJy/Zdr97Dq+p7oiCw9HjXdYY3Q+3UYB+fVA/gl6s0PKBnBm1A32JqFDCMILKXRGKrzB
         B55DIQPf5UGBLEEvoszcN676t8XyXdr2+2gqSerPy1O6z50N/ywiJsYHk+I3CGya8gS7
         vbIllhWSQ+7/7ttkKC4f2T1KfncL7U/dIyeW9naMCLsrD6/Mdv8vs3Z+GeI3sLfktGz3
         usfjr/W5oMFt4FAJ4HKsXvkjqa3gR4vI1/mz7oCJsl7rSUp/jkzqrrrvcSANdyNE0Ngf
         tT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ldg8M6N/OFEgwkYYvOKSVPLbYJ0qxhkHRj9/dN3vWoY=;
        b=TSO5gLlU8oQ51vGzI6qAOjC0QGtbFECnZXLAz+HYhNhyMQZBEZdszFZ8Gr33M4TP+x
         Lnr8ZApmA0xFcGXz0rdGGYLXcOaedvIVjkDBQs3qRr8BOuuTh9f1h0WWXxGGLCIsjhfk
         U9CLC6QjZsatHId6fRBJ2vU0/aKnhduk/0gOQk3cYYVJpYXlFa5sKg+TVutg2Rc+PH/+
         vxUHxwTf/bQw01HrdDCG0JD67OkQmGJvmUgAix6F20JMmkCTyvE41B7W+OdUav7u4dJk
         WZuwezv5P55UnxUtfyXuBOH9zSDTKLDY9X1gcXJZQhpd3zbOt/mAZYbFxZUUQeu9Ry3U
         U+0A==
X-Gm-Message-State: AOAM531hwBpOGQIDdn+7g85xERuMk1ze1u5mKpoBRYbwMeRiyr4GlSeP
        pMZaH3OcmJyF8/5kzyswLbngRw==
X-Google-Smtp-Source: ABdhPJy/7/d0mTvPy7idBBwJCcpwE/oMOpLanp9ksHSGVxAJw9GO2Jgfl3YwqDJfEj50tctZqFULUw==
X-Received: by 2002:a62:16c9:0:b029:1ed:df04:8fcf with SMTP id 192-20020a6216c90000b02901eddf048fcfmr20975877pfw.63.1614705408175;
        Tue, 02 Mar 2021 09:16:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id c29sm20045500pgb.58.2021.03.02.09.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 09:16:47 -0800 (PST)
Date:   Tue, 2 Mar 2021 09:16:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Advancing the timer expiration on guest
 initiated write
Message-ID: <YD5y+W2nqnZt5bRZ@google.com>
References: <1614678202-10808-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614678202-10808-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Advancing the timer expiration should only be necessary on guest initiated 
> writes. Now, we cancel the timer, clear .pending and clear expired_tscdeadline 
> at the same time during state restore.

That last sentence is confusing.  kvm_apic_set_state() already clears .pending,
by way of __start_apic_timer().  I think what you mean is:

  When we cancel the timer and clear .pending during state restore, clear
  expired_tscdeadline as well.

With that, 

Reviewed-by: Sean Christopherson <seanjc@google.com> 


Side topic, I think there's a theoretical bug where KVM could inject a spurious
timer interrupt.  If KVM is using hrtimer, the hrtimer expires early due to an
overzealous timer_advance_ns, and the guest writes MSR_TSCDEADLINE after the
hrtimer expires but before the vCPU is kicked, then KVM will inject a spurious
timer IRQ since the premature expiration should have been canceled by the guest's
WRMSR.

It could also cause KVM to soft hang the guest if the new lapic_timer.tscdeadline
is written before apic_timer_expired() captures it in expired_tscdeadline.  In
that case, KVM will wait for the new deadline, which could be far in the future.


Side topic #2, I'm pretty sure the direct usage of kvm_wait_lapic_expire() in
apic_timer_expired() before kvm_apic_inject_pending_timer_irqs() is broken.
kvm_wait_lapic_expire() requires the interrupt to be pending, but that never
happens if PI is used, and even if PI "fails", the IRQ isn't injected until the
next line, kvm_apic_inject_pending_timer_irqs().  I'll send a patch.

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 45d40bf..f2b6e79 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2595,6 +2595,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  
>  	apic_update_ppr(apic);
>  	hrtimer_cancel(&apic->lapic_timer.timer);
> +	apic->lapic_timer.expired_tscdeadline = 0;
>  	apic_update_lvtt(apic);
>  	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>  	update_divide_count(apic);
> -- 
> 2.7.4
> 
