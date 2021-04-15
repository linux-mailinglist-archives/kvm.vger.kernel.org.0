Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37C13614A5
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 00:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhDOWPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbhDOWPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 18:15:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF03C061756
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:15:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so8667339pja.5
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 15:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uVqj7VZY1Cf3w1LwGxwJQ9xLnZwQGyxy7mn+rml5pJo=;
        b=kpgxOledReTF8a07zTbARWX2I3wkhKrz9ypgDTDRg3+J1EydMS4Lu/8Mm/sNY+fSg8
         j7DFvkwuDAAaNN4z84Za4zTkFerEy1Bwix1OZtdC6s+BHmRvPNtpT1zXh02FLmgWkKcf
         LB/cLwJSDlQvTWbXZScDCP+8r6owoBWm/TuCaRlw45OYFqrbAHOMxO/ewbervOJyG7AX
         H+FqzWlZSm0k1zWP/ZPjRC3lF3EjXNIRlhNoQv6OWign/XCvzEuV54xzlgKmaWJkKrSX
         U8BHiQPxJn0j/Bx5ufZB+9PiZ+27ryEnynIG9hFeG7AVXz0ZltSql55OKonOodvEONHC
         mrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uVqj7VZY1Cf3w1LwGxwJQ9xLnZwQGyxy7mn+rml5pJo=;
        b=c2n58T8UxHlh/n3wmgQXCnp/u7GqYhCrCzIb5zT6ObjgrZ5dqMV93EiVRoVfGuAGl4
         33KtQ3r4i9xYyq8xj0FQyVam3NAsc/OV/C5fZRIsckG72ntEBjfMdR3T5fgTCCSKrLAW
         NrP4EMbWR/MvYUtika1ATeSgs09hsWm+kgLA1HYuUfDO/yETk4XsWt06sdrFxkJTMrWz
         sLuApxUhWHxE/vfFn8Wk1r5bT8TzeQWh7eo7YswYzNw/F+D7HCi3GgatTEOyHyruZ2n3
         o+3aeffJHkrP5aKi8kZlMmiWxOg4ibKhTTDtIImUeca9Vz+PtNf/t94XLZwsJJ6KC6HJ
         Q1pg==
X-Gm-Message-State: AOAM532sZTE5TRiQEx5NMDKTIhEF6QjsUC9zwdUBDpbQHV+X6hMLdWEk
        s06Q4nfJG6TSeTBk7U37IUjXfqvVBKcZ7g==
X-Google-Smtp-Source: ABdhPJxjZfBpIv21RYEycpOb//LPlDHIjj8rL96tnLsp2qvHau2r/6V7FJIeJVDZ/Z1VaRKAwoFbdA==
X-Received: by 2002:a17:90b:349:: with SMTP id fh9mr6170529pjb.126.1618524911342;
        Thu, 15 Apr 2021 15:15:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k19sm3356192pgl.1.2021.04.15.15.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:15:10 -0700 (PDT)
Date:   Thu, 15 Apr 2021 22:15:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hao Sun <sunhao.th@gmail.com>
Subject: Re: [PATCH 3/3] KVM: Add proper lockdep assertion in I/O bus
 unregister
Message-ID: <YHi66hvVAkhxU4wl@google.com>
References: <20210412222050.876100-1-seanjc@google.com>
 <20210412222050.876100-4-seanjc@google.com>
 <CALMp9eRmpm3HPUjizYXp27drY0xtWhSrsec51W7QkSHWADayNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRmpm3HPUjizYXp27drY0xtWhSrsec51W7QkSHWADayNQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021, Jim Mattson wrote:
> On Mon, Apr 12, 2021 at 3:23 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Convert a comment above kvm_io_bus_unregister_dev() into an actual
> > lockdep assertion, and opportunistically add curly braces to a multi-line
> > for-loop.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ab1fa6f92c82..ccc2ef1dbdda 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4485,21 +4485,23 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> >         return 0;
> >  }
> >
> > -/* Caller must hold slots_lock. */
> >  int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> >                               struct kvm_io_device *dev)
> >  {
> >         int i, j;
> >         struct kvm_io_bus *new_bus, *bus;
> >
> > +       lockdep_assert_held(&kvm->slots_lock);
> > +
> >         bus = kvm_get_bus(kvm, bus_idx);
> >         if (!bus)
> >                 return 0;
> >
> > -       for (i = 0; i < bus->dev_count; i++)
> > +       for (i = 0; i < bus->dev_count; i++) {
> >                 if (bus->range[i].dev == dev) {
> >                         break;
> >                 }
> > +       }
> Per coding-style.rst, neither the for loop nor the if-block should have braces.
> 
> "Do not unnecessarily use braces where a single statement will do."

Doh, the if-statement should indeed not use braces.  I think I meant to clean
that up, and then saw something shiny...

But the for-loop... keep reading :-D

Also, use braces when a loop contains more than a single simple statement:

.. code-block:: c

        while (condition) {
                if (test)
                        do_something();
        }
