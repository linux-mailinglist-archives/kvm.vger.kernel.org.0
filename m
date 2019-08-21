Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8CA98248
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 20:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfHUSDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 14:03:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33549 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfHUSDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 14:03:53 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so6488567iog.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 11:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rzDwwqgijxGmq79NIp8fz9g7ialyJ+cL6CMDbdqYWnU=;
        b=PDHTroLMo1ZyG1Wjl7+NwtZTgBLINZTlbjPzVl+Xv4l5PDQ3XvP+43+kJ3PJ+8bpt6
         rSYxbq5bWQVBVX/ku/NJo48sqsPlSrNE3XvMwade+81AJIMJnW+q+6cqkGC0JO5xl4wO
         dz+6j6I/tySu92E3spQKiSMZZ6jPdcaN/sQxCKgigVbZKSo27dEqjlSgZLPhnAWFOv7r
         1Tb1SQuwO7TPkdx/F0xFfb39v48wHlFRoxg4v+X5l2Z0owUCJjMMUMebgNVHC9hY9sOf
         7F/hg0MgDYtX+5E3Yb+gqkGoRZGLfAFqN1lVfXcNrB77YixanxCZZ36I/5O+4kxBHhjZ
         PwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rzDwwqgijxGmq79NIp8fz9g7ialyJ+cL6CMDbdqYWnU=;
        b=Ou3i8QqGMUOBJHMMoFkapunmPu9L/P0JmTEYB6jMnedJhkijxvph4cOJ/x/niNo81V
         k7gBAt07ls+4vEkknpbYZ5VR5WkF27aobr9yyqCf4SpNyWTyNo9LLkLG/rmaLsVcGuZ8
         dHXL6zOOijRA8ku7pVw5TBOZzYaBsX0ytkZpRK60xxxoqNR7goXHbkffXUb8ISeCT6pl
         NHdjMsPYrdg6PT2D961QPvcQs2+uv/2uieiLihbptDHJgYsCo7FGqrDdeX6ijsMOZk3Z
         m6I7fCyYc4VM0Y8V9wl0wGS8DB2goOl0fPzFTYIvVpVbyLkBgj/SXw+nvpXx83JEk18A
         AZfA==
X-Gm-Message-State: APjAAAWxIUujnhOWoSuxIVNiL67TuO++RiQ9ID8UKs5y5t2bjLFxfcBT
        xcfrdvt8N1POEvGiyCKHosqfedXH0rKVVTgCnLX2wA==
X-Google-Smtp-Source: APXvYqxTUaZxJ2ZIMhF5u3xFn9lsf2inlMO9U98DaVaarrMsh1bbIsMJFpYP1w7D/p7xDaHwNmJQ/8b7/t43wsPFFZ4=
X-Received: by 2002:a6b:6516:: with SMTP id z22mr15806587iob.7.1566410632477;
 Wed, 21 Aug 2019 11:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190819230422.244888-1-delco@google.com> <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com> <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com> <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
 <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
 <CAHGX9Vr4HsVowENg8CS9pVWMr2n58H_tJqDX823oAHL++L8yHA@mail.gmail.com> <20190821171737.GG29345@linux.intel.com>
In-Reply-To: <20190821171737.GG29345@linux.intel.com>
From:   Matt Delco <delco@google.com>
Date:   Wed, 21 Aug 2019 11:03:40 -0700
Message-ID: <CAHGX9VoDs==RnpO-NL1x3bXj_aCCkvPvfZXa-6_TFsS2-oMBmQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 10:17 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
> On Tue, Aug 20, 2019 at 12:34:20AM -0700, Matt Delco wrote:
> > On Mon, Aug 19, 2019 at 10:09 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > On Tue, 20 Aug 2019 at 12:10, Nadav Amit <nadav.amit@gmail.com> wrote:
> > > > These tests pass on bare-metal.
> > >
> > > Good to know this. In addition, in linux apic driver, during mode
> > > switch __setup_APIC_LVTT() always sets lapic_timer_period(number of
> > > clock cycles per jiffy)/APIC_DIVISOR to APIC_TMICT which can avoid the
> > > issue Matt report. So is it because there is no such stuff in windows
> > > or the windows version which Matt testing is too old?
> >
> > I'm using Windows 10 (May 2019). Multimedia apps on Windows tend to
> > request higher frequency clocks, and this in turn can affect how the
> > kernel configures HW timers.  I may need to examine how Windows
> > typically interacts with the APIC timer and see if/how this changes
> > when Skype is used.  The frequent timer mode changes are not something
> > I'd expect a reasonably behaved kernel to do.
>
> Have you tried analyzing the guest code?  If we're lucky, doing so might
> provide insight into what's going awry.
>
> E.g.:
>
>   Are the LVTT/TMICT writes are coming from a single blob/sequence of code
>   in the guest?
>
>   Is the unpaired LVTT coming from the same code sequence or is it a new
>   rip entirely?
>
>   Can you dump the relevant asm code sequences?

I have changed gears to do runtime behavioral analysis, given the
reports that the code change I proposed would deviate from hardware.
The time between writes for TMICT-then-LVTT is typically quite small,
and much smaller than the average for LVTT-then-TMICT.  On the lead up
to where time stops there's alternating writes to TMICT and LVTT,
where each write to LVTT alternates between setting periodic vs.
one-shot.  The final write to LVTT (which sets periodic) comes more
than 1.5 ms after the prior TMICT (which is about 100x the typical
delay), which might mean the kernel opted to not write to TMICT but
did on the next clock tick.  The host kernel & kvm I've been testing
with seems to be firing the timer callbacks sooner than requested, so
if the guest kernel has optimizations based on whether it thinks
there's time left on the APIC timer then this might be causing
problems.  I'm going to try to pull in some of the newer kvm changes
that appear to compensate for the early delivery and see if that also
makes the time hang symptom disappear (if not then I may start to
examine things from the guest side).  Thanks.
