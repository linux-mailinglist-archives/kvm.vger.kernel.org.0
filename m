Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38CF20582C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbgFWRCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733025AbgFWRCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 13:02:36 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45041C061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:02:36 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c21so12072446lfb.3
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ErZpBSQ0MQ4t5qJWKxu0MivyKlEOznBzalp0OHBKpc=;
        b=cXKoDs1L2QsIbJ7vOAQYIFVR3WNW82LzasZ+AYXi7cZAKw5mMH9jDK5mECS49Fg0uX
         1mkJkW7xADufF8sqqha8wGyQuedKYnGIyoHJJX1JTzenKVbMplVm8y225N4n/kTCvhIG
         2F30MSOLiF4QPoHWj8KWEXPxjP5a8Q4DYKGd9MP0UoQeB3ckkh/mMFy7JIY2Nn+lXMMa
         MuEtpM0wAp+Si2KeJ1mHP8uaM8znSkFB2orXOndY73UgDEVqMhKxGoRU62zaIWV2emdh
         8KhebtriRNq6+Lc8qjWulkiWf7uGcCHCbLdleJY9C8SQNYbop5yNO+pVj7ApJ6D0WeMf
         RC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ErZpBSQ0MQ4t5qJWKxu0MivyKlEOznBzalp0OHBKpc=;
        b=g1vHvrOMX7W87xdebtzvY34rxP9UXkyzYqUu0VotepjB//NANybyRp9q3z3qjCUOpk
         1brjBoyEJZBfExrgzpWO7EBeEQkuN5vJX12c61IqD2+V2js6Ch5hSizU8p5EveONL+MT
         PKFv3BXl8VCUT7tr/w4mIWz7ZFkbSqAeA8MxSoLc1AhA6xTdLGskuCt9HQ1XWSchmkoX
         LuYHM2deT/oZgJ2nSi+0nrdtGXPo2mNmxy/KH55RdBf2UNvYrYl8FWIzABwMlYgk+wvh
         kIzNATp6+oBmDAbt5ztp82/OJYfq0wjT/lC3uU8p0xGGYnj64+p9qUJzwSeK9OiB6gC8
         8UMA==
X-Gm-Message-State: AOAM5313MaKNE22KKmtpwod0ApQ4N3F9f3E2Da3+OrmC+bbbYclf/F3C
        UotOTqFoFQKFRQ5fC7CF9KafCbNjCKRRXBMAsrWaxw==
X-Google-Smtp-Source: ABdhPJy5OAQL6gEoW7k643+j8zR2DF/U/Iz1fzPHcxs/CWMvSHWybWyPEWjVzBWRurnCMnRCj1Bmekh+EGMvLUEoXqk=
X-Received: by 2002:a19:e93:: with SMTP id 141mr13204605lfo.107.1592931754332;
 Tue, 23 Jun 2020 10:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200615230750.105008-1-jmattson@google.com> <05fe5fcb-ef64-3592-48a2-2721db52b4e3@redhat.com>
 <CALMp9eR4Ny1uaXmOFGTr2JoGqwTw1SUeY34OyEoLpD8oe2n=6w@mail.gmail.com>
 <3818ac9f-79fb-c5b3-dcd2-663f21be9caf@redhat.com> <CALMp9eRosjUvqkYPRfM2vMiLhM1KZcjrwvX5dTapGGDJnC-kxg@mail.gmail.com>
In-Reply-To: <CALMp9eRosjUvqkYPRfM2vMiLhM1KZcjrwvX5dTapGGDJnC-kxg@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 23 Jun 2020 10:02:21 -0700
Message-ID: <CAOQ_QsjVsVrjAw6z9LvyEQoz3iFcpdmSDQVT_B2NJ6Nywk8ogg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization generations
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 10:00 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Jun 22, 2020 at 4:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 23/06/20 00:36, Jim Mattson wrote:
> > > On Mon, Jun 22, 2020 at 3:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >>
> > >> On 16/06/20 01:07, Jim Mattson wrote:
> > >>> +             } else if (vcpu->arch.this_tsc_generation !=
> > >>> +                        kvm->arch.cur_tsc_generation) {
> > >>>                       u64 tsc_exp = kvm->arch.last_tsc_write +
> > >>>                                               nsec_to_cycles(vcpu, elapsed);
> > >>>                       u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
> > >>
> > >> Can this cause the same vCPU to be counted multiple times in
> > >> nr_vcpus_matched_tsc?  I think you need to keep already_matched (see
> > >> also the commit message for 0d3da0d26e3c, "KVM: x86: fix TSC matching",
> > >> 2014-07-09, which introduced that variable).
> > >
> > > No. In the case where we previously might have counted the vCPU a
> > > second time, we now start a brand-new generation, and the vCPU is the
> > > first to be counted for the new generation.
> >
> > Right, because synchronizing is false.  But I'm worried that a migration
> > at the wrong time would cause a wrong start of a new generation.
> >
> > start:
> >         all TSCs are 0
> >
> > mid of synchronization
> >         some TSCs are adjusted by a small amount, gen 1 is started
> >
> > ----------------- migration -------------
> >
> > start:
> >         all TSCs are 0
> >
> > restore state
> >         all TSCs are written with KVM_SET_MSR, gen 1 is started and
> >         completed
> >
> > after execution restarts
> >         guests finishes updating TSCs, gen 2 starts
> >
> > and now nr_vcpus_matched_tsc never reaches the maximum.
> >
> > Paolo
>
> Hmmm...
>
> Perhaps these heuristics are, in fact, irreparable. I'll ask Oliver to
> upstream our ioctls for {GET,SET}_TSC_OFFSET. These ioctls don't help
> on ancient Intel CPUs without TSC offsetting, but they do the trick on
> most CPUs.

Indeed, I'll rebase and send these out soon.
