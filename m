Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1163037598B
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhEFRmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:42:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F6AC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 10:41:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t4so3787379plc.6
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 10:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RIDKgGDjuruMb0Qu9mNHZG+3Nlcbv33doObWMSwteyg=;
        b=ARbW+0WnA7CWV0dJEOBE6FKE7vEpqb1abKg8E3KJA63Rhh5SZgbjDTfvvwT0zG83qt
         q4sigwB5tJYh7f9joRBQDHBHBdXkA5TYBBnc5WWhzUU5Cvvu8rQ1BbpBenNa/6gdnRHb
         1s3eVhuF7O57vT0FDOzM2c4W0Qrbm3/lZhdDBLfaQYV1uNmfftiQZHuDy/WZAbTVjAJ0
         MNJyTU892cNx6So2PV30WX219s7OCEv16TByKOumWNh6iZy2D+vgLjIYQf4H5oi/5Yja
         Yn0XsCEcaycnSHssFK92/iQK7cWjSo6kSe7uUuOupipQXVf0xxwTUO61LiWfK1g5kCaL
         i70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RIDKgGDjuruMb0Qu9mNHZG+3Nlcbv33doObWMSwteyg=;
        b=YEfT5UNTPPrxPMIHAnqNJ/B+qTK9GFw3nUcUrxyQTcPMt10rR6ULHvrXTo+iaesO7U
         pzE3FogyfwO7PkOm8zAkTVnuvZN6PaBLnWfjAV76GYMnaCBnEEK2hAaH2FUkIO1G2l1y
         z5vMngKvF7YDSBW5+l0NfbeaDW/iy7pkrDGJgt/DhzHsL4eY6oFo90WLWXUT3wwEaEBD
         vWlbgPzIuhf1hVNWjFGK0w8Q555om9QOxFqKHJ8oyvxDCl28ugYHHojhxGcRTxtHBWZq
         p/mcKbeialtjpc9Fqt4Lz1ZzGvuyZ3x6P6g0ikP7dFbzS2XqgmxGq4NLM8m6J240HpIl
         szZg==
X-Gm-Message-State: AOAM531wEVxn7S3x1RFPRbcrcBqvmsYFD9TOR6C2BnY3vCLidz9sWJPP
        lJra4Iv7PsIzCGbEapbssWGzsA==
X-Google-Smtp-Source: ABdhPJzppdt/ru4ADkfO0j+ANVyvTPI6WGZjj+HEMWsVKOoYwEVvgdSgasSuwsaWdyFLkfvHYBMc8Q==
X-Received: by 2002:a17:902:8682:b029:ef:d2:4311 with SMTP id g2-20020a1709028682b02900ef00d24311mr2123508plo.4.1620322898657;
        Thu, 06 May 2021 10:41:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t19sm2398643pgv.75.2021.05.06.10.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 10:41:38 -0700 (PDT)
Date:   Thu, 6 May 2021 17:41:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: Cap halt polling at kvm->max_halt_poll_ns
Message-ID: <YJQqTuduLxwTDOSa@google.com>
References: <20210506152442.4010298-1-venkateshs@chromium.org>
 <YJQVj3GaVp9tvWog@google.com>
 <CALzav=e+6mtPUHTHFLbw1Q=1kgstPbAp=2mg9mi+_fc+iWELGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=e+6mtPUHTHFLbw1Q=1kgstPbAp=2mg9mi+_fc+iWELGA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, David Matlack wrote:
> On Thu, May 6, 2021 at 9:13 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Prefer capitalizing KVM in the shortlog, if only because I'm lazy with grep :-)
> >
> > On Thu, May 06, 2021, Venkatesh Srinivas wrote:
> > > From: David Matlack <dmatlack@google.com>
> > >
> > > When growing halt-polling, there is no check that the poll time exceeds
> > > the per-VM limit. It's possible for vcpu->halt_poll_ns to grow past
> > > kvm->max_halt_poll_ns and stay there until a halt which takes longer
> > > than kvm->halt_poll_ns.
> > >
> >
> > Fixes: acd05785e48c ("kvm: add capability for halt polling")
> >
> > and probably Cc: stable@ too.
> >
> >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > > ---
> > >  virt/kvm/kvm_main.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 2799c6660cce..120817c5f271 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -2893,8 +2893,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
> > >       if (val < grow_start)
> > >               val = grow_start;
> > >
> > > -     if (val > halt_poll_ns)
> > > -             val = halt_poll_ns;
> > > +     if (val > vcpu->kvm->max_halt_poll_ns)
> > > +             val = vcpu->kvm->max_halt_poll_ns;
> >
> > Hmm, I would argue that the introduction of the capability broke halt_poll_ns.
> > The halt_poll_ns module param is writable after KVM is loaded.  Prior to the
> > capability, that meant the admin could adjust the param on the fly and all vCPUs
> > would honor the new value as it was changed.
> >
> > By snapshotting the module param at VM creation, those semantics were lost.
> > That's not necessarily wrong/bad, but I don't see anything in the changelog for
> > the capability that suggests killing the old behavior was intentional/desirable.
> 
> api.rst does say the capability overrides halt_poll_ns.

Ya, I'm more concerned about old userspace that isn't aware of the capability,
e.g. an old userspace that relies on tuning halt_poll_ns while a VM is running
would break when upgrading to a version of KVM that supports the capability.

> see value in changing the semantics to something like:
> 
> - halt_poll_ns sets machine-wide maximum halt poll time.
> - kvm->max_halt_poll_ns sets VM-wide maximum halt poll time.
> - A vCPU will poll for at most min(halt_poll_ns,
> kvm->max_halt_poll_ns) (aside from an in-progress poll when either
> parameter is changed).

Agreed.  That would also provide a good opportunity to clean up the benign
races in kvm_vcpu_block(); since both the module param and the per-VM variable
can be modified at will, they really should only be read once per instance of
kvm_vcpu_block().

> On a related note, the capability and these subtle details should be
> documented in Documentation/virtual/kvm/halt-polling.txt.
> 
> 
> >
> > >
> > >       vcpu->halt_poll_ns = val;
> > >  out:
> > > --
> > > 2.31.1.607.g51e8a6a459-goog
> > >
