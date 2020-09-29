Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD7F27BFE2
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgI2IqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2IqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 04:46:10 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B281C061755;
        Tue, 29 Sep 2020 01:46:10 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y2so4098240ila.0;
        Tue, 29 Sep 2020 01:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqasPU0VTgDOjftRYb33fkCM/mcGSCP5hFAdcfFu3Qs=;
        b=h4jfakIbLmtoIZQgwfODLpQOqZ0D/JGDiYXFXyAr0LUfWzYyrEq3Cy+ZLYglTWamnm
         cB3/fOLECvQ8m1qVZM7ym0vkm+us7YSrLOX0nkaCiqQJe8IQQnY+HSLqh4SMURBiY2XQ
         8TAYDbfs2tbezgMkMwFslBpqEB93TmQjWEB5+fSNjbn+JzCqDqpQcBjCEbaZpRgc5PjU
         8joKadQFZj/bS3e1reM1Tjg89620OIUbmLOM0kYu7ivMRM3IUQ56+hc5FfifoIX/zaC0
         7X1fmVpX0JWXAzrgKbtcGUUJSBJQWSAlps0Wwh4qkjEbAZYK1sZ1lnHVqu7ZC11WFzUw
         cu+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqasPU0VTgDOjftRYb33fkCM/mcGSCP5hFAdcfFu3Qs=;
        b=PNMqjTq8Y8NwdKyzo3DFoXK5Mm/AE4npqXP62DNKPI89sCFSqr2l4ivcqFMLDyJEQJ
         YgTc9LVYkDo46OU/CCAiY4v3AvhXiRGsSINFfxG33fCY0N5WnJq4wJx4LsqcS/sGcFYj
         AvWDEIlc9psWCswHpaX4XilsP7I7+Z7V4lgNOWSWc3UCfbkEK5OYJi4QUVVcgOv+dquI
         RxfnU0bNivmr6x2bz1cftoO9J2HBQ9jxINRzeRBXwFL8cikJLS7bP1+1e19ho3gxVk1i
         edd3beZ2FigouL44wU+zS1jNH7bR3Qc7UqCHJrd42cTVzN9qfpX8i9b8+bL93RixYhzN
         MdwQ==
X-Gm-Message-State: AOAM5332Iwh6eWinzRbTaZH+LcVkDkLgZFTwGHf60kokmpabiO8GyWLY
        MIEmXvyQrENiADOgZSlOSGoTfdHiv8c+odnyvrs=
X-Google-Smtp-Source: ABdhPJxxnetet3gwsQH0J2537J8Nh6WVO1nfD5ys/cuDyVzQryY6RuyfBrfRuvNETtUBLrTqpxBR/NVG0HGSGApbIZA=
X-Received: by 2002:a05:6e02:13c4:: with SMTP id v4mr1983118ilj.94.1601369169786;
 Tue, 29 Sep 2020 01:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200928083047.3349-1-jiangshanlai@gmail.com> <20200928162417.GA28825@linux.intel.com>
 <CAJhGHyAYXARENZ7OExenZO6tiWAaSQ=jzEG+7j0rjCsa9e5-dA@mail.gmail.com> <20200929083250.GM353@linux.intel.com>
In-Reply-To: <20200929083250.GM353@linux.intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 29 Sep 2020 16:45:58 +0800
Message-ID: <CAJhGHyAzHXtKw7CuzP6=nPYNBEeup2w_V3qyLVU9rAiy6pjKeg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] kvm/x86: intercept guest changes to X86_CR4_LA57
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 4:32 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Sep 29, 2020 at 01:32:45PM +0800, Lai Jiangshan wrote:
> > On Tue, Sep 29, 2020 at 12:24 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Mon, Sep 28, 2020 at 04:30:46PM +0800, Lai Jiangshan wrote:
> > > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > > >
> > > > When shadowpaping is enabled, guest should not be allowed
> > > > to toggle X86_CR4_LA57. And X86_CR4_LA57 is a rarely changed
> > > > bit, so we can just intercept all the attempts to toggle it
> > > > no matter shadowpaping is in used or not.
> > > >
> > > > Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
> > > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > > > ---
> > > >   No test to toggle X86_CR4_LA57 in guest since I can't access to
> > > >   any CPU supports it. Maybe it is not a real problem.
> > >
> >
> >
> > Hello
> >
> > Thanks for reviewing.
> >
> > > LA57 doesn't need to be intercepted.  It can't be toggled in 64-bit mode
> > > (causes a #GP), and it's ignored in 32-bit mode.  That means LA57 can only
> > > take effect when 64-bit mode is enabled, at which time KVM will update its
> > > MMU context accordingly.
> > >
> >
> > Oh, I missed that part which is so obvious that the patch
> > seems impertinent.
> >
> > But X86_CR4_LA57 is so fundamental that it makes me afraid to
> > give it over to guests. And it is rarely changed too. At least,
> > there is no better reason to give it to the guest than
> > intercepting it.
> >
> > There might be another reason that this patch is still needed with
> > an updated changelog.
> >
> > When a user (via VMM such as qemu) launches a VM with LA57 disabled
> > in its cpuid on a LA57 enabled host. The hypervisor, IMO, needs to
> > intercept guest's changes to X86_CR4_LA57 even when the guest is still
> > in the non-paging mode. Otherwise the hypervisor failed to detective
> > such combination when the guest changes paging mode later.
> >
> > Anyway, maybe it is still not a real problem.
>
> Oof, the above is a KVM bug, though in a more generic manner.  All reserved
> bits should be intercepted, not just LA57.  LA57 is the only affected bit at
> the moment, but proper support is needed as the follow-on patch to let the
> guest toggle FSGSBASE would introduce the same bug.
>
> Sadly, fixing this is a bit of a mess.  Well, fixing LA57 is easy, e.g. this
> patch will do the trick.  But actually refreshing the CR4 guest/host mask when
> the guest's CPUID is updated is a pain, and that's what's needed for proper
> FSGSBASE support.
>
> I'll send a series, bookended by these two RFC patches, with patches to

Thanks for illustrating deep inside.
I'm looking forward to the series.

> intercept CR4 reserved bits smushed in between.  I agree there's no point in
> letting the guest write LA57 directly, it's almost literally a once-per-boot
> thing.  I wouldn't be surprised if intercepting it is a net win (but still
> inconsequential), e.g. due to the MMU having to grab CR4 out of the VMCS.
