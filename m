Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230EC20581A
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732971AbgFWRAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732942AbgFWRAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 13:00:20 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A17C061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:00:19 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t8so20067453ilm.7
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbinHYKxCfxgNuSb5t0Ua4WQrnT2wOkzaDaPPQqLc7A=;
        b=f08Dw94m9N48p6YzKCB4REPHKamaUKKQP8wNqeBUu7oN62FGomD/HkqfdSo/9dqGHo
         d7SiFFKTwvTGgOCM9qwliJPwS0mTeilRusfqSi4lEdwifwtuupbKSenIhXfQYhxbwLo2
         1I/D3Ur5LE+W+5cMhkUoWfMksuxkRPJFW6lRscjmcvUblt5YLTtpU+A1gkeayQGHoGs+
         bLDntuQtMvXqX+PInGlFgiIxEK4kPWT87cUaYCzUrXrNmRQ+quN1tXBg2TjrTauvyFKQ
         0f6BUUvF+T2Yt4Z+pX6rDpfLzBwcdWf4wvyRT312lT4ht9zFFR651Flkp/xDfE6DbrKX
         pUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbinHYKxCfxgNuSb5t0Ua4WQrnT2wOkzaDaPPQqLc7A=;
        b=AhPYJO03B+DyFax28xuwUeK6+aLUGfHG1LaSo9I9XKwJk/X+k0XchSqqG49bIfM/FP
         fRShyQMx+bOAUR0bu9eA/k6s2tUVblBcuVLpoNmTJor2ebLFK09GyS4Y+oUTTknrQCC1
         XOSlpHiyFBWGGgqtrp42YrkNX9+2C9M1TD9qeUsCPHuI0vsUzITWQ+v3Nt5d1Q2fhwky
         IX9nJGF9/InCdG3zZxN8aBFR0JtmLVHxw/5Bio488PbqPkerGk0yTuDqrlzwWFTMf3uV
         QdKMTOyJ6sNZxGh4Ao52RUpWPG0Vz801hZhy6WJ5u0Bog9TWgeX6xX7D6t9ItVC32mxH
         00EA==
X-Gm-Message-State: AOAM530z7fKPP70KdkymXp5+DO3AYdrr8UXzuVgyhTOJn7TJH0cHKlry
        t9Mxg9BA8oA6LJYC4VU8tF6wxRKUc4HxiDvTUtdbpw==
X-Google-Smtp-Source: ABdhPJy9ijupsm9jWPNQOP5sCty8cGpxG9sI7bXLjbGrJN/cOtcZD5NvbKzEOaQm6QT+1OEy7secHy5qWmKydvnw/vA=
X-Received: by 2002:a05:6e02:de6:: with SMTP id m6mr11544751ilj.296.1592931618640;
 Tue, 23 Jun 2020 10:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200615230750.105008-1-jmattson@google.com> <05fe5fcb-ef64-3592-48a2-2721db52b4e3@redhat.com>
 <CALMp9eR4Ny1uaXmOFGTr2JoGqwTw1SUeY34OyEoLpD8oe2n=6w@mail.gmail.com> <3818ac9f-79fb-c5b3-dcd2-663f21be9caf@redhat.com>
In-Reply-To: <3818ac9f-79fb-c5b3-dcd2-663f21be9caf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Jun 2020 10:00:07 -0700
Message-ID: <CALMp9eRosjUvqkYPRfM2vMiLhM1KZcjrwvX5dTapGGDJnC-kxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization generations
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 4:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/06/20 00:36, Jim Mattson wrote:
> > On Mon, Jun 22, 2020 at 3:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 16/06/20 01:07, Jim Mattson wrote:
> >>> +             } else if (vcpu->arch.this_tsc_generation !=
> >>> +                        kvm->arch.cur_tsc_generation) {
> >>>                       u64 tsc_exp = kvm->arch.last_tsc_write +
> >>>                                               nsec_to_cycles(vcpu, elapsed);
> >>>                       u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
> >>
> >> Can this cause the same vCPU to be counted multiple times in
> >> nr_vcpus_matched_tsc?  I think you need to keep already_matched (see
> >> also the commit message for 0d3da0d26e3c, "KVM: x86: fix TSC matching",
> >> 2014-07-09, which introduced that variable).
> >
> > No. In the case where we previously might have counted the vCPU a
> > second time, we now start a brand-new generation, and the vCPU is the
> > first to be counted for the new generation.
>
> Right, because synchronizing is false.  But I'm worried that a migration
> at the wrong time would cause a wrong start of a new generation.
>
> start:
>         all TSCs are 0
>
> mid of synchronization
>         some TSCs are adjusted by a small amount, gen 1 is started
>
> ----------------- migration -------------
>
> start:
>         all TSCs are 0
>
> restore state
>         all TSCs are written with KVM_SET_MSR, gen 1 is started and
>         completed
>
> after execution restarts
>         guests finishes updating TSCs, gen 2 starts
>
> and now nr_vcpus_matched_tsc never reaches the maximum.
>
> Paolo

Hmmm...

Perhaps these heuristics are, in fact, irreparable. I'll ask Oliver to
upstream our ioctls for {GET,SET}_TSC_OFFSET. These ioctls don't help
on ancient Intel CPUs without TSC offsetting, but they do the trick on
most CPUs.
