Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D11A7431B9
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 02:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjF3Abe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 20:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjF3Abc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 20:31:32 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7581FCB
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 17:31:30 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-40079620a83so136421cf.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 17:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688085090; x=1690677090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqBBEtn5jMdxb009LiWKpd4UBE2fGjEHD6QUuwOapDA=;
        b=gfE8rlY0AAs9w3RfyENQ1a/gezAyx8mMQljD4cx+Zi8XXj37/8T526Fhy6xx0ngbtA
         Y1/tcv02ElA+oFeugj6GxPPpF0yOl/Q8vv0GD/+jUulvVC46ra4DjUCRqMEJiXBXFfn0
         Lsqwdns/AN07u/FO9Mpo0eUmUXR6x58oX8DA75dskQ1rhphV/A4nnmvj363GUVsPEbo4
         NjriXBDxHYddp7/hdWubK5/UiyO/2PxIvvFZBqsQCisdNNFTz7iKWncOPRFnrYz8nMII
         LGAprjOO7HCQu0dKQTau9jp9TwIXHJ/69yr6brj6KCXTJX+QEcANOGVMcpcP1aqZpSyG
         /NzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688085090; x=1690677090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CqBBEtn5jMdxb009LiWKpd4UBE2fGjEHD6QUuwOapDA=;
        b=iF3Hu1UKFvHAC3jyCwmZKXvo+33VKfVgkU2q3gItXcDgPcsjVRJIm6C95bFlSaLooR
         uAU9fn+02CxJ5SA9PwvQK+AD88JPEI/WJ9NRfoRdzBeOAsO5hfePbGvjgd3PL1SumrkB
         MQ6YgPYNN9+OEfav0M2N4k2iMJGQEGBpeDHIQLLF3Uk0baKrtq6WtCc/osKIC5k/LEM0
         9D9TiyYJJldjbNE60HEl32eSZUKgPqa9G+d3HV6cPDrCyUBv8M3QmDYLKKSYuDEcVKcK
         1KR0bcH7n+ts8w7DIIMKW6u5H3UbFlNdKlRF3gDDmwT9wOdQx6IhzMTxGiZV/jsQR6fE
         AYTw==
X-Gm-Message-State: AC+VfDyUhT8jWn+GpKIDn/GXbgeM34E3jtoxrradeZzdwr76Fv/bih26
        rCcYTGy85/zV64Vo7E9we2Rps+CpErCxo7fF8nmh4A==
X-Google-Smtp-Source: ACHHUZ4jn7K46CXEE0VMj7HQ5ntCspnNqAjqcrgs+LB0qddqnM22NocvdoMWSNfCrFVg256xKvwcK5TYlsJl6vcwjOw=
X-Received: by 2002:a05:622a:188e:b0:3fa:45ab:22a5 with SMTP id
 v14-20020a05622a188e00b003fa45ab22a5mr603359qtc.27.1688085089643; Thu, 29 Jun
 2023 17:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com> <ZJ4dmrQSduY8aWap@google.com>
In-Reply-To: <ZJ4dmrQSduY8aWap@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Jun 2023 17:31:18 -0700
Message-ID: <CALMp9eQh=KWFYvDDqchb_ztjMnqda2NQawwgJg+r7L+FY_q6kA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>,
        Roman Kagan <rkagan@amazon.de>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 5:11=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +Mingwei
>
> On Thu, Jun 29, 2023, Jim Mattson wrote:
> > On Mon, Jun 5, 2023 at 5:51=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Thu, May 04, 2023, Roman Kagan wrote:
> > > > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > > > index 5c7bbf03b599..6a91e1afef5a 100644
> > > > --- a/arch/x86/kvm/pmu.h
> > > > +++ b/arch/x86/kvm/pmu.h
> > > > @@ -60,6 +60,12 @@ static inline u64 pmc_read_counter(struct kvm_pm=
c *pmc)
> > > >       return counter & pmc_bitmask(pmc);
> > > >  }
> > > >
> > > > +static inline void pmc_set_counter(struct kvm_pmc *pmc, u64 val)
> > > > +{
> > > > +     pmc->counter +=3D val - pmc_read_counter(pmc);
> > >
> > > Ugh, not your code, but I don't see how the current code can possibly=
 be correct.
> > >
> > > The above unpacks to
> > >
> > >         counter =3D pmc->counter;
> > >         if (pmc->perf_event && !pmc->is_paused)
> > >                 counter +=3D perf_event_read_value(pmc->perf_event,
> > >                                                  &enabled, &running);
> > >         pmc->counter +=3D val - (counter & pmc_bitmask(pmc));
> > >
> > > which distills down to
> > >
> > >         counter =3D 0;
> > >         if (pmc->perf_event && !pmc->is_paused)
> > >                 counter +=3D perf_event_read_value(pmc->perf_event,
> > >                                                  &enabled, &running);
> > >         pmc->counter =3D val - (counter & pmc_bitmask(pmc));
> > >
> > > or more succinctly
> > >
> > >         if (pmc->perf_event && !pmc->is_paused)
> > >                 val -=3D perf_event_read_value(pmc->perf_event, &enab=
led, &running);
> > >
> > >         pmc->counter =3D val;
> > >
> > > which is obviously wrong.  E.g. if the guest writes '0' to an active =
counter, the
> > > adjustment will cause pmc->counter to be loaded with a large (in unsi=
gned terms)
> > > value, and thus quickly overflow after a write of '0'.
> >
> > This weird construct goes all the way back to commit f5132b01386b
> > ("KVM: Expose a version 2 architectural PMU to a guests"). Paolo
> > killed it in commit 2924b52117b2 ("KVM: x86/pmu: do not mask the value
> > that is written to fixed PMUs"), perhaps by accident. Eric then
> > resurrected it in commit 4400cf546b4b ("KVM: x86: Fix perfctr WRMSR
> > for running counters").
> >
> > It makes no sense to me. WRMSR should just set the new value of the
> > counter, regardless of the old value or whether or not it is running.
>
> Heh, didn't stop you from giving Eric's patch a thumbs-up[*] :-)

I was smarter then, and probably understood what was going on.

> Thanks to Eric's testcase [Wow, tests do help!  We should try writing mor=
e of them!],
> I finally figured out what's going on.  I wrongly assumed perf_event_read=
_value()
> is destructive, but it's not, it just reads the current value.  So on a W=
RMSR,
> KVM offsets the value with the current perf event, and then *mostly* adju=
sts for
> it when reading the counter.
>
> But that is obviously super fragile because it means pmc->counter must ne=
ver be
> read directly unless the perf event is paused and the accumulated counter=
 has been
> propagated to pmc->counter.  Blech.
>
> I fiddled with a variety of things, but AFAICT the easiest solution is al=
so the
> most obviously correct: set perf's count to the guest's count.  Lightly t=
ested
> patch below.

That seems correct to me. :)

> On a related topic, Mingwei also appears to have found another bug: prev_=
counter
> needs to be set when the counter is written, i.e. my proposed pmc_write_c=
ounter()
> also needs to update prev_counter.
>
> Though that also raises the question of whether or not zeroing prev_count=
er in
> reprogram_counter() is correct.  Unless I'm missing something, reprogram_=
counter()
> should also set pmc->prev_counter to pmc->counter when the counter is suc=
cessfully
> (re)enabled.
>
> And Jim also pointed out that prev_counter needs to be set even when KVM =
fails
> to enable a perf event (software counting should still work).

This whole prev_counter business is a mess. The software counting
increments by at most one per VM-exit. The only time we need to
concern ourselves about overflow is when there has been a software
increment and the paused counter value is -1. That is the only
situation in which software counting can trigger a PMI. Even if the
VM-exit was for a WRMSR to the PMC, assuming that the value just
written by the guest is the value we see when we pause the counter. Or
am I missing something?

> [*] https://lore.kernel.org/all/CALMp9eRfeFFb6n22Uf4R2Pf8WW7BVLX_Vuf04WFw=
iMtrk14Y-Q@mail.gmail.com
>
> ---
>  arch/x86/kvm/pmu.h           |  8 ++++++++
>  arch/x86/kvm/svm/pmu.c       |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c |  4 ++--
>  include/linux/perf_event.h   |  2 ++
>  kernel/events/core.c         | 11 +++++++++++
>  5 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7d9ba301c090..ba91a78e4dc1 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc=
)
>         return counter & pmc_bitmask(pmc);
>  }
>
> +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> +{
> +       if (pmc->perf_event && !pmc->is_paused)
> +               perf_event_set_count(pmc->perf_event, val);
> +
> +       pmc->counter =3D val;
> +}
> +
>  static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
>  {
>         if (pmc->perf_event) {
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index cef5a3d0abd0..373ff6a6687b 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -160,7 +160,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, str=
uct msr_data *msr_info)
>         /* MSR_PERFCTRn */
>         pmc =3D get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
>         if (pmc) {
> -               pmc->counter +=3D data - pmc_read_counter(pmc);
> +               pmc_write_counter(pmc, data);
>                 pmc_update_sample_period(pmc);
>                 return 0;
>         }
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 80c769c58a87..18a658aa2a8d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -406,11 +406,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu,=
 struct msr_data *msr_info)
>                         if (!msr_info->host_initiated &&
>                             !(msr & MSR_PMC_FULL_WIDTH_BIT))
>                                 data =3D (s64)(s32)data;
> -                       pmc->counter +=3D data - pmc_read_counter(pmc);
> +                       pmc_write_counter(pmc, data);
>                         pmc_update_sample_period(pmc);
>                         break;
>                 } else if ((pmc =3D get_fixed_pmc(pmu, msr))) {
> -                       pmc->counter +=3D data - pmc_read_counter(pmc);
> +                       pmc_write_counter(pmc, data);
>                         pmc_update_sample_period(pmc);
>                         break;
>                 } else if ((pmc =3D get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0)=
)) {
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d5628a7b5eaa..8fcd52a87ba2 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1677,6 +1677,7 @@ extern void perf_event_disable_inatomic(struct perf=
_event *event);
>  extern void perf_event_task_tick(void);
>  extern int perf_event_account_interrupt(struct perf_event *event);
>  extern int perf_event_period(struct perf_event *event, u64 value);
> +extern void perf_event_set_count(struct perf_event *event, u64 count);
>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
>  #else /* !CONFIG_PERF_EVENTS: */
>  static inline void *
> @@ -1760,6 +1761,7 @@ static inline int perf_event_period(struct perf_eve=
nt *event, u64 value)
>  {
>         return -EINVAL;
>  }
> +static inline perf_event_set_count(struct perf_event *event, u64 count) =
{ }
>  static inline u64 perf_event_pause(struct perf_event *event, bool reset)
>  {
>         return 0;
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index db016e418931..d368c283eba5 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5646,6 +5646,17 @@ static void _perf_event_reset(struct perf_event *e=
vent)
>         perf_event_update_userpage(event);
>  }
>
> +void perf_event_set_count(struct perf_event *event, u64 count)
> +{
> +       struct perf_event_context *ctx;
> +
> +       ctx =3D perf_event_ctx_lock(event);
> +       (void)perf_event_read(event, false);
> +       local64_set(&event->count, count);
> +       perf_event_ctx_unlock(event, ctx);
> +}
> +EXPORT_SYMBOL_GPL(perf_event_set_count);
> +
>  /* Assume it's not an event with inherit set. */
>  u64 perf_event_pause(struct perf_event *event, bool reset)
>  {
>
> base-commit: 5ae85a1bd17b959796f6cc4c1153ceada2cf8f24
> --
