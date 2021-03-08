Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0D3308A9
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 08:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhCHHNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 02:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhCHHND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 02:13:03 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7234AC06175F
        for <kvm@vger.kernel.org>; Sun,  7 Mar 2021 23:12:52 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id s7so8373960qkg.4
        for <kvm@vger.kernel.org>; Sun, 07 Mar 2021 23:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C08demyre3kojiX31o1Q1+SA4+m7jyiCUMEVIWTEp4U=;
        b=DorOoQF49lpcIwRZT0Wkw9DqN61pd61/qogSYNxeck5JgfiZKByVfVhsF9gtaH7HXc
         IBPHpmUiLp4VmZphTo2So47jLLq/F8tXH2zYE13lkmYyDi+I1oZQ5LrwJQW2iRT7x4Xw
         cBei59e3u/PJjtGUGfjWbe0YMp9C7bCuB7gAiNt53gxpXMpTq8urUnkxq/hFr3Gs8I3M
         FpCwfIhj9qiMKGc7Xe4a1+6zjOcyjxf6e1z6aOCJpDPAp25UQP5cBhPGsEnqgBBFoXYe
         nWX1SLpJvUMO9s0Q04W5HZdlAm/IXcLFAg/+IcxrJW+rq9wCc0z2EIJPJnjfsSRKdiy3
         CjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C08demyre3kojiX31o1Q1+SA4+m7jyiCUMEVIWTEp4U=;
        b=fPcPVhm4dpe3CecoTeS7rPr2ldVClOQFhCAzh7lkw0VoI6HAhJYy879vgS9U3wucNO
         /5Xae47SLmKthEHwfhT50K6sWXDngXuofsG+/1Ntzp9/jAB4aonU6GVbEprW93QMwp3V
         hay+8CKZlkxLtFKeQfevEjlZDG1i1xscg5xa5XpuiIWpCBmtClMqqCGJ7FI23x3YqRmK
         nA1ZC2rEizXEQXOlfbpPt0HTgwoYiY13SHoTfYjfFH5ydY9ZLF1Iw1qspp8xinhnTkI7
         t4r2h+C9VoMCLafWhwVbOEWYj5UySrzw/Lo9/JBtmXiPOMpaC+rOvGyj7Wlt49Gflhw5
         cpCQ==
X-Gm-Message-State: AOAM531kOTKw3UXgJl9WR2mNDmAZlFilm6PaaRIEObDh/s7AJShU9ndF
        KVK2ho6gDELvkZBMxPwy2DCntF/WxfYSrGdekR8OZw==
X-Google-Smtp-Source: ABdhPJxLghQPyXekh0Nsu/jRTdYDrxaFPxIbTI80ael3XOQY0QngAXAcBGnPr6nYcuFVYLkaHH4SuWOkXm8Q+DnP384=
X-Received: by 2002:a37:4743:: with SMTP id u64mr19589049qka.350.1615187571276;
 Sun, 07 Mar 2021 23:12:51 -0800 (PST)
MIME-Version: 1.0
References: <20210305223331.4173565-1-seanjc@google.com> <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
In-Reply-To: <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 8 Mar 2021 08:12:36 +0100
Message-ID: <CACT4Y+YTjezgnY_KHzey1q_vDYD7jZCEHU6eOmKHnXYXbzUdcA@mail.gmail.com>
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no PMU
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        KVM list <kvm@vger.kernel.org>,
        "Thomas Gleixner
        (x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)
        (x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 8, 2021 at 3:26 AM Xu, Like <like.xu@intel.com> wrote:
>
> On 2021/3/6 6:33, Sean Christopherson wrote:
> > Handle a NULL x86_pmu.guest_get_msrs at invocation instead of patching
> > in perf_guest_get_msrs_nop() during setup.  If there is no PMU, setup
>
> "If there is no PMU" ...
>
> How to set up this kind of environment,
> and what changes are needed in .config or boot parameters ?

Hi Xu,

This can be reproduced in qemu with "-cpu max,-pmu" flag using this reproducer:
https://groups.google.com/g/syzkaller-bugs/c/D8eHw3LIOd0/m/L2G0lVkVBAAJ

> > bails before updating the static calls, leaving x86_pmu.guest_get_msrs
> > NULL and thus a complete nop.
>
> > Ultimately, this causes VMX abort on
> > VM-Exit due to KVM putting random garbage from the stack into the MSR
> > load list.
> >
> > Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
> > Cc: Like Xu <like.xu@linux.intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: kvm@vger.kernel.org
> > Reported-by: Dmitry Vyukov <dvyukov@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/events/core.c | 16 +++++-----------
> >   1 file changed, 5 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > index 6ddeed3cd2ac..ff874461f14c 100644
> > --- a/arch/x86/events/core.c
> > +++ b/arch/x86/events/core.c
> > @@ -671,7 +671,11 @@ void x86_pmu_disable_all(void)
> >
> >   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
> >   {
> > -     return static_call(x86_pmu_guest_get_msrs)(nr);
> > +     if (x86_pmu.guest_get_msrs)
> > +             return static_call(x86_pmu_guest_get_msrs)(nr);
>
> How about using "static_call_cond" per commit "452cddbff7" ?
>
> > +
> > +     *nr = 0;
> > +     return NULL;
> >   }
> >   EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
> >
> > @@ -1944,13 +1948,6 @@ static void _x86_pmu_read(struct perf_event *event)
> >       x86_perf_event_update(event);
> >   }
> >
> > -static inline struct perf_guest_switch_msr *
> > -perf_guest_get_msrs_nop(int *nr)
> > -{
> > -     *nr = 0;
> > -     return NULL;
> > -}
> > -
> >   static int __init init_hw_perf_events(void)
> >   {
> >       struct x86_pmu_quirk *quirk;
> > @@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
> >       if (!x86_pmu.read)
> >               x86_pmu.read = _x86_pmu_read;
> >
> > -     if (!x86_pmu.guest_get_msrs)
> > -             x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
> > -
> >       x86_pmu_static_call_update();
> >
> >       /*
>
