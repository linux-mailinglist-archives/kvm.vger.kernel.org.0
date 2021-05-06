Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DF4375878
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhEFQbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 12:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbhEFQbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 12:31:40 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFB5C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 09:30:42 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z13so8694342lft.1
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 09:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMKGeijkLRftBOYtsZmv6QsareZFL8VpGrNkhWmATc4=;
        b=MMkA5P5PQrc5F3yf+Bm0NXxr1fNtjselNFeGaFqI3X+wFHMKdb3wPBBhRg/I0FiO3m
         eD2b4NCrT/2mGP+PRaRl2z3W+oEBWXSF1zP/N6gzyGtggdVqkH9RJx34K7YntNBr527P
         B/gKxaB6tc/aBw7xX/bf2cfyrUs855XXQxroHl+xOng7U7XC07n5RUSix3dUYJ641Gs6
         rU80Nh201Kt/ENUh0BMMw0H518Wh963SBBYCeJM4t15DrJqS5drpf/niT3kR+/l7A+jF
         QXII3mIlM91F0VhXEHIUioEs0YQKv0kkMwPZ1f+LbJNwzuHlX1tZmlbt/C2sp5cWKAvB
         e3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMKGeijkLRftBOYtsZmv6QsareZFL8VpGrNkhWmATc4=;
        b=CoOVkoeTP7MXdQqlGz9qhrMYbFPj/ny/70q+Li2Q1Ub0tn5++JvEDBbuelENHDsXSw
         4t1mzOy2GjlZaB55UAGYmwDsxTbGngPsUfSZiVdsfdoxrpkRYwVobCOSvpDy/fC1RBmP
         jkN64KEGDp8jNy8i53rLLtRXSSaTLHq5MnZGOkI6I6pdx0ma/NJ5PO6yrdiuCbhFvb5k
         CGP41xcSZN9KuME2SW7PpwldtX1kDustZK07fQ4H8Pee4iq4/D54EwcVVUQepy+iHPUv
         AqCYwud97VLW7mowqqY5h1tk8Yhvr0QNJeO3jeicL41pikGJAAeyVUyE7/avGOUUlkWd
         ZbEw==
X-Gm-Message-State: AOAM531FVOTl5uuqEfDg7aWFOO3DUJfKZ9dg73x2VsnqFFHN33RfdN2S
        FikyEJpwWsyGF9qxWS/3+qmiY/EpEBrz4br6bgI40Q==
X-Google-Smtp-Source: ABdhPJwiGjmpais50NnUwjA5DRgGQNXs54iAdzEQnpCf4DKY4bXy07OakW0dY3mqyEDYCp43niOXxsGH5qQ3y44DS2A=
X-Received: by 2002:a05:6512:20f:: with SMTP id a15mr3511660lfo.531.1620318640352;
 Thu, 06 May 2021 09:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210506152442.4010298-1-venkateshs@chromium.org> <YJQVj3GaVp9tvWog@google.com>
In-Reply-To: <YJQVj3GaVp9tvWog@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 May 2021 09:30:14 -0700
Message-ID: <CALzav=e+6mtPUHTHFLbw1Q=1kgstPbAp=2mg9mi+_fc+iWELGA@mail.gmail.com>
Subject: Re: [PATCH] kvm: Cap halt polling at kvm->max_halt_poll_ns
To:     Sean Christopherson <seanjc@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 9:13 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Prefer capitalizing KVM in the shortlog, if only because I'm lazy with grep :-)
>
> On Thu, May 06, 2021, Venkatesh Srinivas wrote:
> > From: David Matlack <dmatlack@google.com>
> >
> > When growing halt-polling, there is no check that the poll time exceeds
> > the per-VM limit. It's possible for vcpu->halt_poll_ns to grow past
> > kvm->max_halt_poll_ns and stay there until a halt which takes longer
> > than kvm->halt_poll_ns.
> >
>
> Fixes: acd05785e48c ("kvm: add capability for halt polling")
>
> and probably Cc: stable@ too.
>
>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > ---
> >  virt/kvm/kvm_main.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2799c6660cce..120817c5f271 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2893,8 +2893,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
> >       if (val < grow_start)
> >               val = grow_start;
> >
> > -     if (val > halt_poll_ns)
> > -             val = halt_poll_ns;
> > +     if (val > vcpu->kvm->max_halt_poll_ns)
> > +             val = vcpu->kvm->max_halt_poll_ns;
>
> Hmm, I would argue that the introduction of the capability broke halt_poll_ns.
> The halt_poll_ns module param is writable after KVM is loaded.  Prior to the
> capability, that meant the admin could adjust the param on the fly and all vCPUs
> would honor the new value as it was changed.
>
> By snapshotting the module param at VM creation, those semantics were lost.
> That's not necessarily wrong/bad, but I don't see anything in the changelog for
> the capability that suggests killing the old behavior was intentional/desirable.

api.rst does say the capability overrides halt_poll_ns. But I could
see value in changing the semantics to something like:

- halt_poll_ns sets machine-wide maximum halt poll time.
- kvm->max_halt_poll_ns sets VM-wide maximum halt poll time.
- A vCPU will poll for at most min(halt_poll_ns,
kvm->max_halt_poll_ns) (aside from an in-progress poll when either
parameter is changed).

On a related note, the capability and these subtle details should be
documented in Documentation/virtual/kvm/halt-polling.txt.


>
> >
> >       vcpu->halt_poll_ns = val;
> >  out:
> > --
> > 2.31.1.607.g51e8a6a459-goog
> >
