Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B7A441D03
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 16:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhKAPDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 11:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAPDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 11:03:03 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B259C061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 08:00:30 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id i6so18123109uae.6
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 08:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MP4kDVSYmSrvv9XDxDd+fAiwbJ8rOwh9Wq9OBW6voeU=;
        b=EsOKcPUxM6K2RW6z/uZgZvmS9hmMMjRB6JxOnUz2nINoy85i1QjKDStScbMNbbguK6
         rp7qu0dHR1mRNmXH3CcWGrPv7GKnORidr7+YhvnUvxRoJo6fsYaUcxGpbrEr+iWzNWZ1
         +LJhF0rUICmjBxfapd3mZhk8n5IK8t1R0ArGaeGdSL/FBFm0SmRadwvPSmGds+o+r9pq
         1kysmCYhmc3Fn/J6h9wHo+NGdCwqOuI5TcntTnBOHaY6laYSUqI0JcxmIScRJEliLWag
         ojcWtrj5LBWvvne3y+pG+1F1vafx3pckYbVkqd5kPlATCS9KAtsSIcBmqa7Zb8bt1OZ3
         QWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MP4kDVSYmSrvv9XDxDd+fAiwbJ8rOwh9Wq9OBW6voeU=;
        b=xfS3uR/oFhaq3PyyPqydgevqdsrxKyZK5gOt30/2mLJZ0UvE9tiAuP7qEdUg51oMIx
         fNE35WpvPgRWIDhFIc4+d+qGGHK3HH/u6KnF2teCWNE1Oa2RZMcx+maSOxeNfmI1ZO8h
         1X2yprf+9TsUwdBZidudK+5E4UqJalH3UEc3IZro1TK4aY4aiPt3g0Qn+oIuCTI9pb6A
         usLstbEfQehpV2jzUBnxHX67HOV1xUWH5mGPgt1mRedr0tlKosrXI8DppHsw4WHqqNoh
         ibuAhoCPH107qTWAe0HI1ILdwoh7QuucvRFM2cNYdb0dn9IGPEJowI5AtoptSLG6UQhD
         K7sA==
X-Gm-Message-State: AOAM530YkRVqE6nPxOjMdEOS2zCqYHywU9IQamH0Iz2PJrYwXuzBmREE
        6+5RMmED++8Pk8gQPXwQxdz9RJTEsLrm81t05EyRcw==
X-Google-Smtp-Source: ABdhPJyXUflzK47TmGcI1BtynCL4IlQpL5a8b+1ZJR2HllmbR+0sLjMN+Q7vJxX4F/sD8+6k+lcb49VNy5EGMyTzA8A=
X-Received: by 2002:a05:6102:3589:: with SMTP id h9mr15229210vsu.39.1635778828874;
 Mon, 01 Nov 2021 08:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211029214759.1541992-1-aaronlewis@google.com>
 <YXx6K9l2QTwbLYng@google.com> <CALMp9eSKVn2233GzCtWMEHmeN-WVCot2X44v1PSPEiZp8bH7hw@mail.gmail.com>
In-Reply-To: <CALMp9eSKVn2233GzCtWMEHmeN-WVCot2X44v1PSPEiZp8bH7hw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 1 Nov 2021 15:00:17 +0000
Message-ID: <CAAAPnDE0f79zjjGHa9ROb1J9ZN9ACgMtT8yfEgZbhmO4pQWMvg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Look up the PTE rather than assuming it
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021 at 11:00 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Oct 29, 2021 at 3:48 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Oct 29, 2021, Aaron Lewis wrote:
> > > Rather than assuming which PTE the SMEP test is running on, look it up
> > > to ensure we have the correct entry.  If this test were to run on a
> > > different page table (ie: run in an L2 test) the wrong PTE would be set.
> > > Switch to looking up the PTE to avoid this from happening.
> > >
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > > ---
> > >  x86/access.c   | 9 ++++++---
> > >  x86/cstart64.S | 1 -
> > >  2 files changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/x86/access.c b/x86/access.c
> > > index 4725bbd..a4d72d9 100644
> > > --- a/x86/access.c
> > > +++ b/x86/access.c
> > > @@ -204,7 +204,7 @@ static void set_cr0_wp(int wp)
> > >  static unsigned set_cr4_smep(int smep)
> > >  {
> > >      unsigned long cr4 = shadow_cr4;
> > > -    extern u64 ptl2[];
> > > +    pteval_t *pte;
> > >      unsigned r;
> > >
> > >      cr4 &= ~CR4_SMEP_MASK;
> > > @@ -213,11 +213,14 @@ static unsigned set_cr4_smep(int smep)
> > >      if (cr4 == shadow_cr4)
> > >          return 0;
> > >
> > > +    pte = get_pte(phys_to_virt(read_cr3()), set_cr4_smep);
> >
> > What guarantees are there that set_cr4_smep() and the rest of the test are mapped
> > by the same PTE?  I 100% agree the current code is ugly, e.g. I can't remember how
> > ptl2[2] is guaranteed to be used, but if we're going to fix it then we should aim
> > for a more robust solution.
>
> One possible solution is to put labels around the code that has to run
> with SMEP and then to implement a function to modify the PTEs for a
> range of addresses, using gcc's double-ampersand syntax to get the
> addresses of the labels.
>

Would it be safer to just mark the start and end of the text section,
then I could remove the PT_USER_MASK flags from that whole range?

> > > +    assert(pte);
> > > +
> > >      if (smep)
> > > -        ptl2[2] &= ~PT_USER_MASK;
> > > +        *pte &= ~PT_USER_MASK;
> > >      r = write_cr4_checking(cr4);
> > >      if (r || !smep) {
> > > -        ptl2[2] |= PT_USER_MASK;
> > > +        *pte |= PT_USER_MASK;
> > >
> > >       /* Flush to avoid spurious #PF */
> > >       invlpg((void *)(2 << 21));
> >
> > This invlpg() should be updated as well.

Good catch.  I'll update this.

> >
> > > diff --git a/x86/cstart64.S b/x86/cstart64.S
> > > index 5c6ad38..4ba9943 100644
> > > --- a/x86/cstart64.S
> > > +++ b/x86/cstart64.S
> > > @@ -26,7 +26,6 @@ ring0stacktop:
> > >  .data
> > >
> > >  .align 4096
> > > -.globl ptl2
> > >  ptl2:
> > >  i = 0
> > >       .rept 512 * 4
> > > --
> > > 2.33.1.1089.g2158813163f-goog
> > >
