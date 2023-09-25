Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73117ACFCC
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjIYGBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 02:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjIYGA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 02:00:59 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA70E3
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 23:00:52 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-64cca551ae2so36408646d6.0
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 23:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695621652; x=1696226452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kX3FAk8WPgdYWvkYOcDpR0tmYCICO8qilzRKipXaN8s=;
        b=VGXDrbJ1LR1Iarr5UjHtMQzaziHeWrqYlsVxFLB5vYxnkfCztLCX34ysP8xv544j1c
         U1fgBqNYW2K4nkxR57XV3Hed8chu78BHLeEsCODpe/MJdMzIv8afQawExkRuuEp/e/G1
         Qb6+eP32eS4LFyE1ndKCeNLTq5L1dCR6sal9dlaFxWDV6LmjAxMDssZO2w62TILFOGfP
         1t/u09exARpjLQ5Gcmnmh1DxO8wE0CgSOa89cTtDn+OF1cZcVvB7YiLFM2te52HHQv7D
         eHrGJRZdMnFu0HaLlNGg0vMeA3oxpk+qxeSrsS2O6orYK8tFmO+CpbKuJGENJWUYxi2u
         aROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695621652; x=1696226452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kX3FAk8WPgdYWvkYOcDpR0tmYCICO8qilzRKipXaN8s=;
        b=lLQptNz67Jpf5pWDTI76WKuJ+W5FOK62XDukKXCA1qzW4twZpFZpsR/cnf1pw5YZX8
         eA39mrzzx8sVGQU5yQmpgBnvq7P/sT21V9weeTIDErQUE3VmGeHKBFX/bKTb+ATd0RxV
         XIJ8IhKOXeZSClTWFTmNW4GEYdtBWOXEHB79Jvc0NET98M6XGRqxIlWdKYUu6TuynvOt
         r5ccBI7x7YYO7YpW4Li9liaP36zgdloXqULQlig5EaPM2X5TPvLy/gYGsX/wD7lj3OU2
         s6/kqNLLFvxphNQPc7YMoPlhJ3CHame4FqE6ibKdezWMAIOQiCHZxFXs29Qoqd94UWQ3
         4jDg==
X-Gm-Message-State: AOJu0YzpaQcTtOlPvuaIFqPloUSUhzKP0iecUnC8JYFxvr+w+KGqf69E
        Qqj8oJztnL21zvCqiOZJxB3zSZSxgSc2Hnd6VpqNOQ==
X-Google-Smtp-Source: AGHT+IEBvNuNr27e4igsdM50xnDVqxTbRwolwBSxMfrZPxsff1mX4YZZG5ez1UFxL4vovMXR8npnDMDFRJHK3KOcK2c=
X-Received: by 2002:a05:6214:a6a:b0:656:28b1:16c6 with SMTP id
 ef10-20020a0562140a6a00b0065628b116c6mr5259978qvb.2.1695621651536; Sun, 24
 Sep 2023 23:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4A4KaSyygKHDUI@google.com> <ZQ4Y1u40/Qml6IaE@google.com>
In-Reply-To: <ZQ4Y1u40/Qml6IaE@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Sun, 24 Sep 2023 23:00:15 -0700
Message-ID: <CAL715WKSG3E2=eE_H9WVYpmxxS1m3o7CcTzmJbrMEQo7TRnLzA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Fri, Sep 22, 2023 at 3:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > My initial testing on both QEMU and our GCP testing environment shows n=
o
> > "Uhhuh..." dmesg in guest.
> >
> > Please take a look...
>
> And now I'm extra confused, I thought the plan was for me to post a prope=
r series
> for the emulated_counter idea[*], get the code base healthy/functional, a=
nd then
> build on top, e.g. improve performance and whatnot.
>
> The below is just a stripped down version of that, and doesn't look quite=
 right.
> Specifically, pmc_write_counter() needs to purge emulated_count (my pseud=
o-patch
> subtly handled that by pausing the counter).
>
> I totally realize I'm moving sloooow, but I pinky swear I'm getting there=
.  My
> compile-tested-only branch can be found at
>
>   https://github.com/sean-jc/linux x86/pmu_refactor
>
> There's a lot more in there, e.g. it has fixes from Roman and Jim, along =
with
> some other found-by-inspection cleanups.

Sean, thanks for the work you have done on the thread:
https://lore.kernel.org/all/ZJ9IaskpbIK9q4rt@google.com

I think the diff you posted helped quite a lot. In fact, Jim also
asked me to try using emulated_counter and I thought that just fixed
the issue. I tried my own version as well as yours. However, neither
could fix this problem at that time. So, Jim took a further look on
the lower level and I was stuck on the performance analysis until
recently I came back and discovered the real fix for this.

Your diff (or I should say your patch) covers lots of things including
the adding of emulated_counter, some refactoring code on pmu reset and
pause-on-wrmsr. In comparison, my code just focuses on the bug fixing
for the duplicate PMI, since that's what I care for production.
Although the code looks somewhat similar, the thought process and
intention are quite different.

Sorry to confuse you. To resolve this issue, I am wondering if adding
you into "Co-developed-by:" would be a valid choice? Or the other way
around like adding me as a co-developer into one patch of your series.

In addition, I have no interest in further refactoring the existing
vPMU code. So for that I will definitely step aside.

Update: it looks like both my patch and Jim's patches (applied
separately) break the kvm-unit-test/pmu with the following error on
SPR:

FAIL: Intel: emulated instruction: instruction counter overflow
FAIL: Intel: full-width writes: emulated instruction: instruction
counter overflow

Not sure whether it is a test error or not.

>
> I dropped the "pause on WRMSR" proposal.  I still don't love the offset a=
pproach,
> but I agree that pausing and reprogramming counters on writes could intro=
duce an
> entirely new set of problems.
>
> I'm logging off for the weekend, but I'll pick this back up next (it's at=
 the
> top of my priority list, assuming guest_memfd doesn't somehow catch fire.
>
> [*] https://lore.kernel.org/all/ZJ9IaskpbIK9q4rt@google.com
>
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index edb89b51b383..47acf3a2b077 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -240,12 +240,13 @@ static void pmc_pause_counter(struct kvm_pmc *pmc=
)
> >  {
> >       u64 counter =3D pmc->counter;
> >
> > -     if (!pmc->perf_event || pmc->is_paused)
> > -             return;
> > -
> >       /* update counter, reset event value to avoid redundant accumulat=
ion */
> > -     counter +=3D perf_event_pause(pmc->perf_event, true);
> > -     pmc->counter =3D counter & pmc_bitmask(pmc);
> > +     if (pmc->perf_event && !pmc->is_paused)
> > +             counter +=3D perf_event_pause(pmc->perf_event, true);
> > +
> > +     pmc->prev_counter =3D counter & pmc_bitmask(pmc);
>
> Honest question, is it actually correct/necessary to mask the counter at =
the
> intermediate steps?  Conceptually, the hardware count and the emulated co=
unt are
> the same thing, just tracked separately.

It is valid because the counter has stopped, and now pmc->counter
contains the valid value. So, it can move into different variables and
do the comparison. Regarding the intermediate steps, I don't think
this is visible to the guest, no? Otherwise, we may have to use tmp
variables and then make the assignment atomic, although I doubt if
that is needed.

>
> > +     pmc->counter =3D (counter + pmc->emulated_counter) & pmc_bitmask(=
pmc);
> > +     pmc->emulated_counter =3D 0;
> >       pmc->is_paused =3D true;
> >  }
> >
> > @@ -452,6 +453,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
> >  reprogram_complete:
> >       clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_=
pmi);
> >       pmc->prev_counter =3D 0;
>
> I don't see any reason to keep kvm_pmc.prev_counter.  reprogram_counter()=
 is the
> only caller of pmc_pause_counter(), and so is effectively the only writer=
 and the
> only reader.  I.e. prev_counter can just be a local variable in reprogram=
_counter(),
> no?

You are right, I will update in the next version.
