Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1846B7440FB
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjF3RQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 13:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjF3RQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 13:16:35 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769FC3A90
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:16:34 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-4007b5bafceso12671cf.1
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688145393; x=1690737393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZYjbsbti+rVflhaD8niD3Jax2FmXNNOo5d9fcG6uCU=;
        b=a8rX5Jg4cK6o2EwrKI9ZMYQ7nGXlRnt1EjGarsxRoCGSTfKW8GbuPuQV+FLsgSexsW
         ncS83gvPK9qbbFpFqcgFcyW7kUz/wXl5tdIpJvYhXTnpW6MrMGL1OptIn8jvYDALkeBY
         Pu6MLXnYIeTLGlBF/b/iZ9D9+VCzpYRI0sfpWuxwDiFfmx+cnpD+zLXeL+2gvCNwF8hy
         KEPbVpMdBlkHzEHXWs2jLwt0j+OQnl0Wx48yzFMytvxBh8Zi4LSCk6mg6sptCHk4JjRl
         G1VLJS6IbIxTK66w3ojnO0M2TKTa6XQNBicWbtDlrB6pGZOQAlsmQ5xFrJKkhCvxm9G/
         YClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688145393; x=1690737393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZYjbsbti+rVflhaD8niD3Jax2FmXNNOo5d9fcG6uCU=;
        b=iTV//XiqlZEntIUfpyWH2UZBBvz/wH/SMkl1PqjBUW9i+TciKvgDEvhxX5vN4Ktjiv
         4wyGisf6ahOIsbHM/2H3UmcsG1PCHchvrel7GPQDFpUcaV2IBHgW6KWgsyzTT3uJG7QP
         KzAPzFEFazlgbsWw0atpubWbrY54uH7aqNTtp8hjrOiVI/Pi8u6AOdCIRFkg3so569uk
         GntcikEbl7/AD5XD10f+yh7cAKxCfeRcabutdGRu/kRATDeNIjeOiDsn/PlqojFAUzIB
         oZzbnTIPeJCoAWq/gUEnFPfEM7uN3egj1Z8ZAHsi3V8KEPTGANmiELq2fEPBpPyNPL58
         RwrQ==
X-Gm-Message-State: AC+VfDzqYIzHLOEIVYV6YFnAOcDCYI2ulc630sQ+UtBFdPc7yPSRaIbM
        kh4O/W+AQJi/j9n0QoxqLszG9rdLrUGxkUWwjjjU7Q==
X-Google-Smtp-Source: ACHHUZ4Y+04AAzcFvQV2MAlgSLAksud+hKLE4aoReVbH5ER/J/WJhxJzyZwtr8CAuSJ1t1UAYZ/yhAD18d0hZJL1YeA=
X-Received: by 2002:ac8:5882:0:b0:3ef:4319:c6c5 with SMTP id
 t2-20020ac85882000000b003ef4319c6c5mr669071qta.19.1688145393483; Fri, 30 Jun
 2023 10:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com> <CAL715WL9T8Ucnj_1AygwMgDjOJrttNZHRP9o-KUNfpx1aYZnog@mail.gmail.com>
In-Reply-To: <CAL715WL9T8Ucnj_1AygwMgDjOJrttNZHRP9o-KUNfpx1aYZnog@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Jun 2023 10:16:22 -0700
Message-ID: <CALMp9eSQ9uRBVdLDkfCdPbprZ45LpdZY5-5O9i41oJYs-dK7+Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 10:08=E2=80=AFAM Mingwei Zhang <mizhang@google.com>=
 wrote:
>
> On Fri, Jun 30, 2023 at 8:45=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wro=
te:
> > > > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kv=
m_pmc *pmc)
> > > > > >         return counter & pmc_bitmask(pmc);
> > > > > >  }
> > > > > >
> > > > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 =
val)
> > > > > > +{
> > > > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > > > +
> > > > > > +       pmc->counter =3D val;
> > > > >
> > > > > Doesn't this still have the original problem of storing wider val=
ue than
> > > > > allowed?
> > > >
> > > > Yes, this was just to fix the counter offset weirdness.  My plan is=
 to apply your
> > > > patch on top.  Sorry for not making that clear.
> > >
> > > Ah, got it, thanks!
> > >
> > > Also I'm now chasing a problem that we occasionally see
> > >
> > > [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> > > [3939579.462836] Do you have a strange power saving mode enabled?
> > > [3939579.462836] Dazed and confused, but trying to continue
> > >
> > > in the guests when perf is used.  These messages disappear when
> > > 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> > > reverted.  I haven't yet figured out where exactly the culprit is.
> >
> > Can you reverting de0f619564f4 ("KVM: x86/pmu: Defer counter emulated o=
verflow
> > via pmc->prev_counter")?  I suspect the problem is the prev_counter mes=
s.
>
> For sure it is prev_counter issue, I have done some instrumentation as fo=
llows:
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 48a0528080ab..946663a42326 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -322,8 +322,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>         if (!pmc_event_is_allowed(pmc))
>                 goto reprogram_complete;
>
> -       if (pmc->counter < pmc->prev_counter)
> +       if (pmc->counter < pmc->prev_counter) {
> +               pr_info("pmc->counter: %llx\tpmc->prev_counter: %llx\n",
> +                       pmc->counter, pmc->prev_counter);
>                 __kvm_perf_overflow(pmc, false);
> +       }
>
>         if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
>                 printk_once("kvm pmu: pin control bit is ignored\n");
>
> I find some interesting changes on prev_counter:
>
> [  +7.295348] pmc->counter: 12 pmc->prev_counter: fffffffffb3d
> [  +0.622991] pmc->counter: 3 pmc->prev_counter: fffffffffb1a
> [  +6.943282] pmc->counter: 1 pmc->prev_counter: fffffffff746
> [  +4.483523] pmc->counter: 0 pmc->prev_counter: ffffffffffff
> [ +12.817772] pmc->counter: 0 pmc->prev_counter: ffffffffffff
> [ +21.721233] pmc->counter: 0 pmc->prev_counter: ffffffffffff
>
> The first 3 logs will generate this:
>
> [ +11.811925] Uhhuh. NMI received for unknown reason 20 on CPU 2.
> [  +0.000003] Dazed and confused, but trying to continue
>
> While the last 3 logs won't. This is quite reasonable as looking into
> de0f619564f4 ("KVM: x86/pmu: Defer counter emulated overflow via
> pmc->prev_counter"), counter and prev_counter should only have 1 diff
> in value.

prev_counter isn't actually sync'ed at this point, is it? This comes
back to that "setting a running counter" nonsense. We want to add 1 to
the current counter, but we don't actually know what the current
counter is.

My interpretation of the above is that, in the first three cases, PMU
hardware has already detected an overflow. In the last three cases,
software counting has detected an overflow.

If the last three occur while executing the guest's PMI handler (i.e.
NMIs are blocked), then this could corroborate my conjecture about
IA32_DEBUGCTL.Freeze_PerfMon_On_PMI.

> So, the reasonable suspect should be the stale prev_counter. There
> might be several potential reasons behind this. Jim's theory is the
> highly reasonable one as I did another experiment and found that KVM
> may leave pmu->global_status as '0' when injecting an NMI.
