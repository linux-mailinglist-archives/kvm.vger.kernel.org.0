Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16730441F05
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 18:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhKARNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 13:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKARNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 13:13:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA3AC061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 10:10:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o10-20020a17090a3d4a00b001a6555878a8so4998015pjf.1
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 10:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJRILEKcyZsBqsai0nBG3Iw7aOUJwH2kLDUKUGrJ8og=;
        b=iz01bHvBjNQOpUyaZgqzZRbGOV1RGIPnOUFM2uHQUJfsi8e1vPudftj7hGHdRsYa7p
         zZ1l7v64pZ5K7vbMyqsnetCDFlNURQnP5RdP5M5QVeuscxTj/VD4F6LFjoUghiRp3/5c
         e0AMMI61KGhCQHfpw6UvPo+Qx177/w3kKpt/d4Y8guTy+veu6z7yQKcSPxBjojVL1+A1
         ambLN2S5wwzq+36iIaMIENvlGTv7/OrjClnxdWlbaYsbC9nG0waN12dougYKfYvzaDQM
         6CCI2R4uS1sfsA1U4mULg9EH1Vyp55Ra53OyGEzzJZlFcRrauNIBeSPmWcKslgaPg87S
         7BZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJRILEKcyZsBqsai0nBG3Iw7aOUJwH2kLDUKUGrJ8og=;
        b=CzJ6NmP0NHARp8LwDcx7sD0d/XJowdtZTqQfJKwDVuU11PSf0514yqQ+mKhVM+JutJ
         gtgQkyuFDgEHAHIdnYWMvdYjEbIuIQZyqBBN9um8CuagpuYuhgJ6s39DZC1ymhZKiWzW
         TIiiMAHWkCG72DfLKZnwDcbiqsuukOBmp2f0vEkh4FTQSk/8T/zh+Qbmw6mIdz3EEH1s
         GS4pmqsRqOGLsLYnxhM50Rp/kbaUIB9RCO3N8jeRtX7h9JXFUlCC2Au5BvHus3pA2L3H
         dIGDxvqA+cA1XTEK55+rcszypKBvk5FasVICGRcJFequULWD9A3vFwB+49Rn5NQ0iDZa
         /lNw==
X-Gm-Message-State: AOAM531C8HKDZ6/7OykeiynqvxAub7FUo+KTBbZILNIz7gcY6p1Rrdfj
        RKfBFFjbF4Ct2+G8gHh3Xe/DVvH8UzvSUzWeXX8HbQ==
X-Google-Smtp-Source: ABdhPJwbb2w5dfP9WoOR5K7JQSkFA+O0JaYFUOQuVvUHuPhrLEBDk4VXfPs3OFWMP1BdAgnea4AIOKArTjimvxVKEoY=
X-Received: by 2002:a17:90a:55cb:: with SMTP id o11mr217715pjm.244.1635786627332;
 Mon, 01 Nov 2021 10:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211029214759.1541992-1-aaronlewis@google.com>
 <YXx6K9l2QTwbLYng@google.com> <CALMp9eSKVn2233GzCtWMEHmeN-WVCot2X44v1PSPEiZp8bH7hw@mail.gmail.com>
 <CAAAPnDE0f79zjjGHa9ROb1J9ZN9ACgMtT8yfEgZbhmO4pQWMvg@mail.gmail.com>
In-Reply-To: <CAAAPnDE0f79zjjGHa9ROb1J9ZN9ACgMtT8yfEgZbhmO4pQWMvg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 1 Nov 2021 10:10:16 -0700
Message-ID: <CALMp9eQvAU_hjCmF=cBJYT_1FDav9OG=qL=h6+ADvjj9OZVOAA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Look up the PTE rather than assuming it
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 1, 2021 at 8:00 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> On Fri, Oct 29, 2021 at 11:00 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Oct 29, 2021 at 3:48 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Oct 29, 2021, Aaron Lewis wrote:
> > > > Rather than assuming which PTE the SMEP test is running on, look it up
> > > > to ensure we have the correct entry.  If this test were to run on a
> > > > different page table (ie: run in an L2 test) the wrong PTE would be set.
> > > > Switch to looking up the PTE to avoid this from happening.
> > > >
> > > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > > > ---
> > > >  x86/access.c   | 9 ++++++---
> > > >  x86/cstart64.S | 1 -
> > > >  2 files changed, 6 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/x86/access.c b/x86/access.c
> > > > index 4725bbd..a4d72d9 100644
> > > > --- a/x86/access.c
> > > > +++ b/x86/access.c
> > > > @@ -204,7 +204,7 @@ static void set_cr0_wp(int wp)
> > > >  static unsigned set_cr4_smep(int smep)
> > > >  {
> > > >      unsigned long cr4 = shadow_cr4;
> > > > -    extern u64 ptl2[];
> > > > +    pteval_t *pte;
> > > >      unsigned r;
> > > >
> > > >      cr4 &= ~CR4_SMEP_MASK;
> > > > @@ -213,11 +213,14 @@ static unsigned set_cr4_smep(int smep)
> > > >      if (cr4 == shadow_cr4)
> > > >          return 0;
> > > >
> > > > +    pte = get_pte(phys_to_virt(read_cr3()), set_cr4_smep);
> > >
> > > What guarantees are there that set_cr4_smep() and the rest of the test are mapped
> > > by the same PTE?  I 100% agree the current code is ugly, e.g. I can't remember how
> > > ptl2[2] is guaranteed to be used, but if we're going to fix it then we should aim
> > > for a more robust solution.
> >
> > One possible solution is to put labels around the code that has to run
> > with SMEP and then to implement a function to modify the PTEs for a
> > range of addresses, using gcc's double-ampersand syntax to get the
> > addresses of the labels.
> >
>
> Would it be safer to just mark the start and end of the text section,
> then I could remove the PT_USER_MASK flags from that whole range?

That sounds ideal. There's already an stext, so you would just have to
add etext.

> > > > +    assert(pte);
> > > > +
> > > >      if (smep)
> > > > -        ptl2[2] &= ~PT_USER_MASK;
> > > > +        *pte &= ~PT_USER_MASK;
> > > >      r = write_cr4_checking(cr4);
> > > >      if (r || !smep) {
> > > > -        ptl2[2] |= PT_USER_MASK;
> > > > +        *pte |= PT_USER_MASK;
> > > >
> > > >       /* Flush to avoid spurious #PF */
> > > >       invlpg((void *)(2 << 21));
> > >
> > > This invlpg() should be updated as well.
>
> Good catch.  I'll update this.
>
> > >
> > > > diff --git a/x86/cstart64.S b/x86/cstart64.S
> > > > index 5c6ad38..4ba9943 100644
> > > > --- a/x86/cstart64.S
> > > > +++ b/x86/cstart64.S
> > > > @@ -26,7 +26,6 @@ ring0stacktop:
> > > >  .data
> > > >
> > > >  .align 4096
> > > > -.globl ptl2
> > > >  ptl2:
> > > >  i = 0
> > > >       .rept 512 * 4
> > > > --
> > > > 2.33.1.1089.g2158813163f-goog
> > > >
