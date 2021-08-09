Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952623E4956
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 17:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhHIP5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbhHIP5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 11:57:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8CAC0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 08:57:15 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so355416pjz.0
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 08:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qmKZUENIq51fhuRL35kMmVWqclk5GRvGXJyAk2DQ4tY=;
        b=GPjvTN7fd8PCJickd2j8qbEcp1kxpLCDGv5E8h8xgKzOlYUsKf1aSElz4JUvbAH8by
         Nm7Nlv5+l/LI+9A/R5wiyYOghMhFopxEJg3ltbJr0udNGlhTFaFjCfvbsRHux+0pVsYm
         SMnqTfZnWHL+TMEW6x7N/xJ/K1eTioeLvfKQ21LjHlVHHzSmvNx7YNmoiLd/WtxSxXaH
         6swsvEcd7v1UHaYT0KwYyKE/i5Pl+Y/wDkKjuY0ykYhbpTSR8tqir57W92QxOxEapV3q
         b77/tAtaKX3eIs+XX/1jimBw7POQts4+G3K3gaxgt4dxGlVztyRqmBl0e3M2emPcsVB3
         RWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qmKZUENIq51fhuRL35kMmVWqclk5GRvGXJyAk2DQ4tY=;
        b=Tk0v5IzYFrSuH19ESj501naVHa7UPFk6uyFFp8bF7T1dj1rVpiOihG4sKrKS+HKWja
         /wH/rTkIrTiAltJ/n8iWOatu6XI6wDCAFfFoMZpQ0v2k+lqWlRdE98FFcYd9X1biVg0e
         f9apgqgR37IDXyA7wpW1T+fkuj3kxCjwTTEc5EpAzmCQyLb+sELgEVdp0GVHxGw1/Dtf
         lWo/7gb9cXQeRFOU2S2WOKTv0xUpv3j2huu1ROxJAc31gP9W8IkE/LqyiwuI9YpxcMJQ
         pk0wlVTWBkmYPp9aJfvsnNVuQqNrRre2uVsNbO2KSAi0F51MlZh/rTc9jWvOvEtOCAi2
         oUbw==
X-Gm-Message-State: AOAM533/drSkwzDnT4f+3r87GLctivs+QKDiJ0dvMfqMwlrzX4p8atOh
        FCDNpjcO/RwXeZb433ua6FAAWA==
X-Google-Smtp-Source: ABdhPJzQzmImICh0VNjzcZPOjEsb5viw224s+Sdfd8OJFV/zcpKtUjtxqj/PBW3z4taalyPDiHyEpQ==
X-Received: by 2002:a17:90a:5515:: with SMTP id b21mr14939488pji.142.1628524634304;
        Mon, 09 Aug 2021 08:57:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nv11sm454062pjb.48.2021.08.09.08.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 08:57:13 -0700 (PDT)
Date:   Mon, 9 Aug 2021 15:57:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: KVM's support for non default APIC base
Message-ID: <YRFQVbo90g3sPby3@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
 <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
 <YPXJQxLaJuoF6aXl@google.com>
 <564fd4461c73a4ec08d68e2364401db981ecba3a.camel@redhat.com>
 <YQ2vv7EXGN2jgQBb@google.com>
 <5f991ac11006ae890961a76d35a63b7c9c56b47c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f991ac11006ae890961a76d35a63b7c9c56b47c.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Maxim Levitsky wrote:
> On Fri, 2021-08-06 at 21:55 +0000, Sean Christopherson wrote:
> > Making up our own behavior is almost never the right approach.  E.g. _best_ case
> > scenario for an unexpected #GP is the guest immediately terminates.  Worst case
> > scenario is the guest eats the #GP and continues on, which is basically the status
> > quo, except it's guaranteed to now work, whereas todays behavior can at least let
> > the guest function, for some definitions of "function".
> 
> Well, at least the Intel's PRM does state that APIC base relocation is not guaranteed
> to work on all CPUs, so giving the guest a #GP is like telling it that current CPU doesn't
> support it. In theory, a very well behaving guest can catch the exception and
> fail back to the default base.
> 
> I don't understand what do you mean by 'guaranteed to now work'. If the guest

Doh, typo, it should be "not", i.e. "guaranteed to not work".  As in, allowing the
unsupported WRMSR could work depending on what features KVM is using and what the
guest is doing, whereas injecting #GP is guaranteed to break the guest.

> ignores this #GP and still thinks that APIC base relocation worked, it is its fault.
> A well behaving guest should never assume that a msr write that failed with #GP
> worked.
> 
> > 
> > I think the only viable "solution" is to exit to userspace on the guilty WRMSR.
> > Whether or not we can do that without breaking userspace is probably the big
> > question.  Fully emulating APIC base relocation would be a tremendous amount of
> > effort and complexity for practically zero benefit.
> 
> I have nothing against this as well although I kind of like the #GP approach
> a bit more, and knowing that there are barely any reasons to relocate the
> APIC base, and that it doesn't work well, there is a good chance that no one
> does it anyway (except our kvm unit tests, but that isn't an issue).

Injecting an exception that architecturally should not happen is simply not
acceptable.  Silently (and partially) ignoring the WRMSR isn't acceptable either,
but we can't travel back in time to fix that so we're stuck with it unless we can
change the behavior without anyone complaining.

> > > (we already have a warning when APIC base is set to non default value)
> > 
> > FWIW, that warning is worthless because it's _once(), i.e. won't help detect a
> > misbehaving guest unless it's the first guest to misbehave on a particular
> > instantiation of KVM.   _ratelimited() would improve the situation, but not
> > completely eliminate the possibility of a misbehaving guest going unnoticed.
> > Anything else isn't an option becuase it's obviously guest triggerable.
> 
> 100% agree.
> 
> I'll say I would first make it _ratelimited() for few KVM versions, and then
> if nobody complains, make it a KVM internal error / #GP, and remove all the
> leftovers from the code that pretend that it can work.

I don't see any point in temporarily making it _ratelimited(), (1) the odds of someone
running a guest that relies on APIC base relocation are very low, (2) the odds of
that someone noticing a _ratelimited() and not a _once() are even lower, and (3) the
odds of that prompting a bug report are even lower still.

> And add a comment explaining *why* as you explained, supporting APIC base relocation
> isn't worth it.
> 
> Best regards,
> 	Maxim Levitsky
> 
> > 
> 
> 
