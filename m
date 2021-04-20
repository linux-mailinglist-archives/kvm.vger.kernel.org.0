Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6138365B96
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 16:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhDTO6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhDTO6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 10:58:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65299C06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 07:57:40 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h10so45416528edt.13
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 07:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7f/SI7ay0C3hZVzBkfrUcoxIbociU4NyC2GvcdsJoYk=;
        b=p/xTnkL5fnlDewCFJd8J+V5k5n5Lob/sNXu8MvEgkvcRktl7FWL7J4ZgIMYeFJXoCK
         p4NF2OVUf0G34a+6HiAtn9ax8+fp6rj75evVY4j7zDZTYj9b59AgMfDOQnz6omFyDtdh
         vDBJ5BQRVJ3jjwcbQFzlz4a0lnuxTu+yo/9qGmAFStMo/G+u/RRIw70CzGGP1fVzgWry
         1z2NDm5Uyv5it4AsK5gmq29eTJApB9Jkx0xLCeeOiFjnKt1mOyrtQ+vqM83p1NXvowpP
         uACWmp1R5kzLg5dytZLhZQ43AXtyy4aZnFPEHe0JKiN5Q9AYshIQyGyvNTAUgAtyam0Y
         LIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7f/SI7ay0C3hZVzBkfrUcoxIbociU4NyC2GvcdsJoYk=;
        b=fbpSeNj9JBM1e8bV9nJcl7keniVmAODa5SrAEpOQK6d90BpM9ef3NKDpZ8AB5T1D8g
         f89VGnTBbww+KpyTDLD/+XU7asRq0gc6irBNtohxm8Ft+yfarXDyvHShdC9S81ZkKxkX
         ZLsm927l9gVGOYb47BriDbP/KspOOjRuLT8NmnlZHRnRql4sgzU8cZEJGw7tpXSJxQ8v
         rAg8Ie440BYtAh34vWjN5UyiwrRfL5qeCQegNUAFp+OwBoKKQAF5qSxuyTnDLygMcf+i
         IfF91IVyTGA6UjGAlZjCJlwYPg4hnysuuGFhqpfmQQ45/jchJURieCglaPCU8usKz0+f
         QNnA==
X-Gm-Message-State: AOAM533VqRx+CvQo65LxphbEORY68yzl+ne7+vsNEbBBPo077HSs//0q
        1RcWepbp5MzEctMgWkQqhInYEJY5cOPcasKTKrsrDA==
X-Google-Smtp-Source: ABdhPJza6tVcruMv6x8OXcS6DZcdey2i/+qSrDLdq9B0Y1lZxdMixJrDIaySSD7fatkvRAgvGrX8/fWelifaJp3x2Fg=
X-Received: by 2002:a05:6402:1907:: with SMTP id e7mr15491079edz.313.1618930658970;
 Tue, 20 Apr 2021 07:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <cunblaaqwe0.fsf@dme.org> <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
 <cunzgxtctgj.fsf@dme.org>
In-Reply-To: <cunzgxtctgj.fsf@dme.org>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 20 Apr 2021 07:57:27 -0700
Message-ID: <CAAAPnDGnY76C-=FppsiL=OFY-ei8kHeJhfK_tNV8of3JHBZ0FA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 12:21 AM David Edmondson <dme@dme.org> wrote:
>
> On Monday, 2021-04-19 at 09:47:19 -07, Aaron Lewis wrote:
>
> >> > Add a fallback mechanism to the in-kernel instruction emulator that
> >> > allows userspace the opportunity to process an instruction the emulator
> >> > was unable to.  When the in-kernel instruction emulator fails to process
> >> > an instruction it will either inject a #UD into the guest or exit to
> >> > userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> >> > not know how to proceed in an appropriate manner.  This feature lets
> >> > userspace get involved to see if it can figure out a better path
> >> > forward.
> >>
> >> Given that you are intending to try and handle the instruction in
> >> user-space, it seems a little odd to overload the
> >> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION exit reason/sub
> >> error.
> >>
> >> Why not add a new exit reason, particularly given that the caller has to
> >> enable the capability to get the relevant data? (It would also remove
> >> the need for the flag field and any mechanism for packing multiple bits
> >> of detail into the structure.)
> >
> > I considered that, but I opted for the extensibility of the exiting
> > KVM_EXIT_INTERNAL_ERROR instead.  To me it was six of one or half a
> > dozen of the other.  With either strategy I still wanted to provide
> > for future extensibility, and had a flags field in place.  That way we
> > can add to this in the future if we find something that is missing
> > (ie: potentially wanting a way to mark dirty pages, possibly passing a
> > fault address, etc...)
>
> How many of the flag based optional fields do you anticipate needing for
> any one particular exit scenario?
>
> If it's one, then using the flags to disambiguate the emulation failure
> cases after choosing to stuff all of the cases into
> KVM_EXIT_INTERNAL_ERROR / KVM_INTERNAL_ERROR_EMULATION would be odd.
>
> (I'm presuming that it's not one, but don't understand the use case.)
>

The motivation was to allow for maximum flexibility in the future, and
not be tied down to something we potentially missed now.  I agree the
flags aren't needed if we are only adding to what's currently there,
but they are needed if we want to remove something or pack something
differently.  I didn't see how I could achieve that without adding a
flags field.  Seemed like low overhead to be more future proof.

> >> > +/*
> >> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> >> > + * to describe what is contained in the exit struct.  The flags are used to
> >> > + * describe it's contents, and the contents should be in ascending numerical
> >> > + * order of the flag values.  For example, if the flag
> >> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> >> > + * length and instruction bytes would be expected to show up first because this
> >> > + * flag has the lowest numerical value (1) of all the other flags.
> >> > + */
> >> > +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> >> > +
> >> >  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
> >> >  struct kvm_run {
> >> >       /* in */
> >> > @@ -382,6 +393,14 @@ struct kvm_run {
> >> >                       __u32 ndata;
> >> >                       __u64 data[16];
> >> >               } internal;
> >> > +             /* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
> >> > +             struct {
> >> > +                     __u32 suberror;
> >> > +                     __u32 ndata;
> >> > +                     __u64 flags;
> >> > +                     __u8  insn_size;
> >> > +                     __u8  insn_bytes[15];
> >> > +             } emulation_failure;
> >> > +/*
> >> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> >> > + * to describe what is contained in the exit struct.  The flags are used to
> >> > + * describe it's contents, and the contents should be in ascending numerical
> >> > + * order of the flag values.  For example, if the flag
> >> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> >> > + * length and instruction bytes would be expected to show up first because this
> >> > + * flag has the lowest numerical value (1) of all the other flags.
> >>
> >> When adding a new flag, do I steal bytes from insn_bytes[] for my
> >> associated payload? If so, how many do I have to leave?
> >>
> >
> > The emulation_failure struct mirrors the internal struct, so if you
> > are just adding to what I have, you can safely add up to 16 __u64's.
> > I'm currently using the size equivalent to 3 of them (flags,
> > insn_size, insn_bytes), so there should be plenty of space left for
> > you to add what you need to the end.  Just add the fields you need to
> > the end of emulation_failure struct, increase 'ndata' to the new
> > count, add a new flag to 'flags' so we know its contents.
>
> My apologies, I mis-read the u8 as u64, so figured that you'd eaten all
> of the remaining space.
>
> dme.
> --
> I walk like a building, I never get wet.
