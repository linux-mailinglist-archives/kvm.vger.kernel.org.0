Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81EE7AE022
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 21:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjIYTzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 15:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYTza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 15:55:30 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42D210F
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:55:22 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1a28de15c8aso4208228fac.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695671721; x=1696276521; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQQDJGTD3aJOyuegIu11J9uTVFLMdLvv5YX4MQ57KjY=;
        b=CVe6lCDcFQwS0mFc48wIjVamy068acf4E2kCdYrs7Y8WYVDhesh2FcNDzgdG/dUzRX
         wuXBM5uUg4xYB3eVB+wd187QXgf8GOU+DOUK/3RCNoxsoGPQmATXmTi3/XVJXE6dkkpr
         Pe5xsJzhxMOtk/5YtzA1pXsKSIwapXdtjyiKqCo4eZ6arNWGW3lNPjWlFM9sUrAKb01x
         4dSvPYoKrfwYs30H1ndsIiLd98XGIvaQ7MsTb5FB59oQnggj/SMDmNdc51M2EIZtou+P
         AKnDTVzx6mDGwhOOwN5vaUBc3fQK7vbZWqUe7YV8skgsH6D7PGqldAbNwX6cvMADCq2v
         uLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695671721; x=1696276521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQQDJGTD3aJOyuegIu11J9uTVFLMdLvv5YX4MQ57KjY=;
        b=abza125za3MsFgErdjaN63p+pJhlOAnJCVwuwPxz8nvW/cJ9dSScUog74E8NLSfMAh
         NmO8GDIloif9Mah0qe1uG+HTQklhutRb2AUv1vgKBEs2EcG4+UikANjzQdvaZMGjFHs9
         MZ0C6GL1uP4Cm31pTLoeqzmwHISLzqEtLNQeuMZPEXYkS2oNmZtE8u+0ZqY7HJQRtPDW
         nAjWkKJGlqmnsQuA4YcYnFXvyq1ubrasFRJA3qFOXZcrQ+acVaG/BlwEmZy6dU5P9rqa
         8pQZVm8NhVzJek8y+/xhYYl8syhEPSyiwv+X/YNqFwa7i/TxQVwdv/p/Y8mdwNvfM8kj
         4sQg==
X-Gm-Message-State: AOJu0YzUxqu9IR3W8v+O3JV9KkbQcjNq9yM5gbjVRbk9uyyF6yog7xZL
        xLOL7LdxQCg4sNul4jK85ItOxDJdfr01WSVr6YfcQw==
X-Google-Smtp-Source: AGHT+IEcsPQKiIn+2maamahapEKL/dR1xp0t0HkktEzsPj4/l4tiukNxXQ0Vxzg18It3eFc6Hb8/z71IogHBJBDuXGM=
X-Received: by 2002:a05:6870:5b92:b0:1d6:5a39:5ffb with SMTP id
 em18-20020a0568705b9200b001d65a395ffbmr8433653oab.20.1695671721043; Mon, 25
 Sep 2023 12:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4A4KaSyygKHDUI@google.com>
In-Reply-To: <ZQ4A4KaSyygKHDUI@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 25 Sep 2023 12:54:45 -0700
Message-ID: <CAL715WJnNrBp1EEuVn=YOfDXMdgSpJpEGNkabu7mGB57mSTgMg@mail.gmail.com>
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 2:02=E2=80=AFPM Mingwei Zhang <mizhang@google.com> =
wrote:
>
> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > On Fri, Sep 22, 2023 at 1:34=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> > > > On Fri, Sep 22, 2023 at 12:21=E2=80=AFPM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > On Fri, Sep 22, 2023, Jim Mattson wrote:
> > > > > > On Fri, Sep 22, 2023 at 11:46=E2=80=AFAM Sean Christopherson <s=
eanjc@google.com> wrote:
> > > > > > >
> > > > > > > On Fri, Sep 01, 2023, Jim Mattson wrote:
> > > > > > > > When the irq_work callback, kvm_pmi_trigger_fn(), is invoke=
d during a
> > > > > > > > VM-exit that also invokes __kvm_perf_overflow() as a result=
 of
> > > > > > > > instruction emulation, kvm_pmu_deliver_pmi() will be called=
 twice
> > > > > > > > before the next VM-entry.
> > > > > > > >
> > > > > > > > That shouldn't be a problem. The local APIC is supposed to
> > > > > > > > automatically set the mask flag in LVTPC when it handles a =
PMI, so the
> > > > > > > > second PMI should be inhibited. However, KVM's local APIC e=
mulation
> > > > > > > > fails to set the mask flag in LVTPC when it handles a PMI, =
so two PMIs
> > > > > > > > are delivered via the local APIC. In the common case, where=
 LVTPC is
> > > > > > > > configured to deliver an NMI, the first NMI is vectored thr=
ough the
> > > > > > > > guest IDT, and the second one is held pending. When the NMI=
 handler
> > > > > > > > returns, the second NMI is vectored through the IDT. For Li=
nux guests,
> > > > > > > > this results in the "dazed and confused" spurious NMI messa=
ge.
> > > > > > > >
> > > > > > > > Though the obvious fix is to set the mask flag in LVTPC whe=
n handling
> > > > > > > > a PMI, KVM's logic around synthesizing a PMI is unnecessari=
ly
> > > > > > > > convoluted.
> > > > > > >
> > > > > > > To address Like's question about whether not this is necessar=
y, I think we should
> > > > > > > rephrase this to explicitly state this is a bug irrespective =
of the whole LVTPC
> > > > > > > masking thing.
> > > > > > >
> > > > > > > And I think it makes sense to swap the order of the two patch=
es.  The LVTPC masking
> > > > > > > fix is a clearcut architectural violation.  This is a bit mor=
e of a grey area,
> > > > > > > though still blatantly buggy.
> > > > > >
> > > > > > The reason I ordered the patches as I did is that when this pat=
ch
> > > > > > comes first, it actually fixes the problem that was introduced =
in
> > > > > > commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
> > > > > > instructions"). If this patch comes second, it's less clear tha=
t it
> > > > > > fixes a bug, since the other patch renders this one essentially=
 moot.
> > > > >
> > > > > Yeah, but as Like pointed out, the way the changelog is worded ju=
st raises the
> > > > > question of why this change is necessary.
> > > > >
> > > > > I think we should tag them both for stable.  They're both bug fix=
es, regardless
> > > > > of the ordering.
> > > >
> > > > Agree. Both patches are fixing the general potential buggy situatio=
n
> > > > of multiple PMI injection on one vm entry: one software level defen=
se
> > > > (forcing the usage of KVM_REQ_PMI) and one hardware level defense
> > > > (preventing PMI injection using mask).
> > > >
> > > > Although neither patch in this series is fixing the root cause of t=
his
> > > > specific double PMI injection bug, I don't see a reason why we cann=
ot
> > > > add a "fixes" tag to them, since we may fix it and create it again.
> > > >
> > > > I am currently working on it and testing my patch. Please give me s=
ome
> > > > time, I think I could try sending out one version today. Once that =
is
> > > > done, I will combine mine with the existing patch and send it out a=
s a
> > > > series.
> > >
> > > Me confused, what patch?  And what does this patch have to do with Ji=
m's series?
> > > Unless I've missed something, Jim's patches are good to go with my ni=
ts addressed.
> >
> > Let me step back.
> >
> > We have the following problem when we run perf inside guest:
> >
> > [ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
> > [ 1437.487330] Dazed and confused, but trying to continue
> >
> > This means there are more NMIs that guest PMI could understand. So
> > there are potentially two approaches to solve the problem: 1) fix the
> > PMI injection issue: only one can be injected; 2) fix the code that
> > causes the (incorrect) multiple PMI injection.
> >
> > I am working on the 2nd one. So, the property of the 2nd one is:
> > without patches in 1) (Jim's patches), we could still avoid the above
> > warning messages.
> >
> > Thanks.
> > -Mingwei
>
> This is my draft version. If you don't have full-width counter support, t=
his
> patch needs be placed on top of this one:
> https://lore.kernel.org/all/20230504120042.785651-1-rkagan@amazon.de/
>
> My initial testing on both QEMU and our GCP testing environment shows no
> "Uhhuh..." dmesg in guest.
>
> Please take a look...
>
> From 47e629269d8b0ff65c242334f068300216cb7f91 Mon Sep 17 00:00:00 2001
> From: Mingwei Zhang <mizhang@google.com>
> Date: Fri, 22 Sep 2023 17:13:55 +0000
> Subject: [PATCH] KVM: x86/pmu: Fix emulated counter increment due to
>  instruction emulation
>
> Fix KVM emulated counter increment due to instruction emulation. KVM
> pmc->counter is always a snapshot value when counter is running. Therefor=
e,
> the value does not represent the actual value of counter. Thus it is
> inappropriate to compare it with other counter values. In existing code
> KVM directly compares pmc->prev_counter and pmc->counter directly. Howeve=
r,
> pmc->prev_counter is a snaphot value assigned from pmc->counter when
> counter may still be running.  So this comparison logic in
> reprogram_counter() will generate incorrect invocations to
> __kvm_perf_overflow(in_pmi=3Dfalse) and generate duplicated PMI injection
> requests.
>
> Fix this issue by adding emulated_counter field and only the do the count=
er
> calculation after we pause
>
> Change-Id: I2d59e68557fd35f7bbcfe09ea42ad81bd36776b7
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/pmu.c              | 15 ++++++++-------
>  arch/x86/kvm/svm/pmu.c          |  1 +
>  arch/x86/kvm/vmx/pmu_intel.c    |  2 ++
>  4 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 1a4def36d5bb..47bbfbc0aa35 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -494,6 +494,7 @@ struct kvm_pmc {
>         bool intr;
>         u64 counter;
>         u64 prev_counter;
> +       u64 emulated_counter;
>         u64 eventsel;
>         struct perf_event *perf_event;
>         struct kvm_vcpu *vcpu;
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..47acf3a2b077 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -240,12 +240,13 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
>  {
>         u64 counter =3D pmc->counter;
>
> -       if (!pmc->perf_event || pmc->is_paused)
> -               return;
> -
>         /* update counter, reset event value to avoid redundant accumulat=
ion */
> -       counter +=3D perf_event_pause(pmc->perf_event, true);
> -       pmc->counter =3D counter & pmc_bitmask(pmc);
> +       if (pmc->perf_event && !pmc->is_paused)
> +               counter +=3D perf_event_pause(pmc->perf_event, true);
> +
> +       pmc->prev_counter =3D counter & pmc_bitmask(pmc);
> +       pmc->counter =3D (counter + pmc->emulated_counter) & pmc_bitmask(=
pmc);
> +       pmc->emulated_counter =3D 0;
>         pmc->is_paused =3D true;
>  }
>
> @@ -452,6 +453,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>  reprogram_complete:
>         clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_=
pmi);
>         pmc->prev_counter =3D 0;
> +       pmc->emulated_counter =3D 0;
>  }
>
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
> @@ -725,8 +727,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>
>  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>  {
> -       pmc->prev_counter =3D pmc->counter;
> -       pmc->counter =3D (pmc->counter + 1) & pmc_bitmask(pmc);
> +       pmc->emulated_counter +=3D 1;
>         kvm_pmu_request_counter_reprogram(pmc);
>  }
>
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index a25b91ff9aea..b88fab4ae1d7 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -243,6 +243,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>
>                 pmc_stop_counter(pmc);
>                 pmc->counter =3D pmc->prev_counter =3D pmc->eventsel =3D =
0;
> +               pmc->emulated_counter =3D 0;
>         }
>
>         pmu->global_ctrl =3D pmu->global_status =3D 0;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 626df5fdf542..d03c4ec7273d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -641,6 +641,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>
>                 pmc_stop_counter(pmc);
>                 pmc->counter =3D pmc->prev_counter =3D pmc->eventsel =3D =
0;
> +               pmc->emulated_counter =3D 0;
>         }
>
>         for (i =3D 0; i < KVM_PMC_MAX_FIXED; i++) {
> @@ -648,6 +649,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>
>                 pmc_stop_counter(pmc);
>                 pmc->counter =3D pmc->prev_counter =3D 0;
> +               pmc->emulated_counter =3D 0;
>         }
>
>         pmu->fixed_ctr_ctrl =3D pmu->global_ctrl =3D pmu->global_status =
=3D 0;
> --
> 2.42.0.515.g380fc7ccd1-goog

Signed-off-by: Mingwei Zhang <mizhang@google.com>
