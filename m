Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9C44405A0
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 01:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhJ2XCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 19:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhJ2XCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 19:02:37 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B8EC061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 16:00:08 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id s23-20020a056830125700b00553e2ca2dccso10757166otp.3
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 16:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GYEVlalX4SLaDkU0WKyoC1RuJPfLy1LYt4RvHHoipPQ=;
        b=QK3fd35JSRUMGpb1uqofScpOzporq79t08H5VjNIT4hpmjanb6AHZE6Upw6PQv3gPg
         tzs/Cep79x9Qi6Z+In+RwON8OXYtZsyF3kFQzWxPNueR7coQFcuUZAmOukh0U/lcFGXr
         Cwn1MU6A4jykxnT0axhyRzz8KLZCt3R/J/jEswPT1jhIzUtKtMyzhj9GXEfgOmjQWMyL
         nFpMlky9l+6IV51c7BshgbGSda26JTb9/u8pXnhpX2k0I1i7EtGM4xXvhctze8kBbA6j
         RWcu2vy4sl+EoV8MHM0C92AcAi3MvfqHefkEd30WuYxiLKXOqw8q9L4RFdlketOV0SZN
         a8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GYEVlalX4SLaDkU0WKyoC1RuJPfLy1LYt4RvHHoipPQ=;
        b=BHIDJc+jdrSw0s1l3Nae9HyXo1/t5+LDg6tMJ52//ubVxg5sXMYiSD3yQNaAqKRFut
         Te/riiEh/fLx876ZYZMYpiTRCa3ILKLPje99s1V/tBNqnFapELnkQMIJV4Bdh0yWH4cz
         cNTW8UHC4clR+2oubFkEB2o/cfkkqWSk6Nvew6KqDa7ZjlJe3EdTtg71xuxs4aTj6w4G
         BYSQrbcOdudBBQuEHdwOvXSsgV9GnIzZG4HBtTQCvslmYVci9zG5eV+CJX2EB9w6hMp4
         arSC8uFUwey/se5mj5GUtNf8OQ+kL8lrpNBJxq/R1OPHK3f8GzuXdz0Vv2+y5HZuVqdV
         oXQw==
X-Gm-Message-State: AOAM530BObisYSOfq6rr2SsU4Jk6xB7SWmEuZJzuGqb6ltgl7ZyVWNtw
        hE8HB4/TUiDtlRCPvaClvLcMRbb8eGtbn7d5fJbSyL73rjM=
X-Google-Smtp-Source: ABdhPJyhBLrEM8cuq9LGftLa+A0JE2+B2PxUr8JL/zd6OWqwtK2HwraOD6XSoy/XSqY0hAiArTUdwvrLecB0cXmOO44=
X-Received: by 2002:a9d:6e09:: with SMTP id e9mr674131otr.367.1635548407547;
 Fri, 29 Oct 2021 16:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211029214759.1541992-1-aaronlewis@google.com> <YXx6K9l2QTwbLYng@google.com>
In-Reply-To: <YXx6K9l2QTwbLYng@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 29 Oct 2021 15:59:56 -0700
Message-ID: <CALMp9eSKVn2233GzCtWMEHmeN-WVCot2X44v1PSPEiZp8bH7hw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Look up the PTE rather than assuming it
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021 at 3:48 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 29, 2021, Aaron Lewis wrote:
> > Rather than assuming which PTE the SMEP test is running on, look it up
> > to ensure we have the correct entry.  If this test were to run on a
> > different page table (ie: run in an L2 test) the wrong PTE would be set.
> > Switch to looking up the PTE to avoid this from happening.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  x86/access.c   | 9 ++++++---
> >  x86/cstart64.S | 1 -
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/x86/access.c b/x86/access.c
> > index 4725bbd..a4d72d9 100644
> > --- a/x86/access.c
> > +++ b/x86/access.c
> > @@ -204,7 +204,7 @@ static void set_cr0_wp(int wp)
> >  static unsigned set_cr4_smep(int smep)
> >  {
> >      unsigned long cr4 = shadow_cr4;
> > -    extern u64 ptl2[];
> > +    pteval_t *pte;
> >      unsigned r;
> >
> >      cr4 &= ~CR4_SMEP_MASK;
> > @@ -213,11 +213,14 @@ static unsigned set_cr4_smep(int smep)
> >      if (cr4 == shadow_cr4)
> >          return 0;
> >
> > +    pte = get_pte(phys_to_virt(read_cr3()), set_cr4_smep);
>
> What guarantees are there that set_cr4_smep() and the rest of the test are mapped
> by the same PTE?  I 100% agree the current code is ugly, e.g. I can't remember how
> ptl2[2] is guaranteed to be used, but if we're going to fix it then we should aim
> for a more robust solution.

One possible solution is to put labels around the code that has to run
with SMEP and then to implement a function to modify the PTEs for a
range of addresses, using gcc's double-ampersand syntax to get the
addresses of the labels.

> > +    assert(pte);
> > +
> >      if (smep)
> > -        ptl2[2] &= ~PT_USER_MASK;
> > +        *pte &= ~PT_USER_MASK;
> >      r = write_cr4_checking(cr4);
> >      if (r || !smep) {
> > -        ptl2[2] |= PT_USER_MASK;
> > +        *pte |= PT_USER_MASK;
> >
> >       /* Flush to avoid spurious #PF */
> >       invlpg((void *)(2 << 21));
>
> This invlpg() should be updated as well.
>
> > diff --git a/x86/cstart64.S b/x86/cstart64.S
> > index 5c6ad38..4ba9943 100644
> > --- a/x86/cstart64.S
> > +++ b/x86/cstart64.S
> > @@ -26,7 +26,6 @@ ring0stacktop:
> >  .data
> >
> >  .align 4096
> > -.globl ptl2
> >  ptl2:
> >  i = 0
> >       .rept 512 * 4
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
