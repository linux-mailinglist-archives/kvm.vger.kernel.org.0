Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AC77440DF
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 19:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjF3RIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 13:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjF3RI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 13:08:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646893C3C
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:08:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-98e011f45ffso231651366b.3
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688144896; x=1690736896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djbszLtoHHDMZ0fSdJiXx0t0hVE4VrfDsRtDQpq854Y=;
        b=3PtJ+g5tJVeNWTN9Ljx1dw7SLn5XosBx138xqjpGi4HRgfV8/lV5msek82vI7WzAcB
         f+nqVrAXRlxGnxi06J3cwEbTEXX3wwlj5znjrhrGTnIne5y6ZvD6Nq0BN7mylz+TnGue
         evW7if1wrjiiFzebMjDtoq5aK56wwaTDeRMNBaRsFv0JKbbQUEVX+GFwnja//KIcMV6h
         pKsLJ+m0Y6HqFVK1283i90jwnAKjuKmLnMFUrzpz2eLId4YHfd0C7s6lOCMP5s8SWi/+
         71aJRE2u3wILt3Nc5SCc/AxjKed6H8/z/zqo/FnNeNibFt2XY4Xz45HwXTytSAotDe7k
         kBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688144896; x=1690736896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djbszLtoHHDMZ0fSdJiXx0t0hVE4VrfDsRtDQpq854Y=;
        b=kEYEqRdbJcjSrhi7yv21qMyg+ICwWw42AveV7FupSqgGKdaI4A67xzANTbXFweVITo
         Habhtd+UFpfCjm7B/81QRk6vFNLiWsYuRcnmv0EMErKBAfij6GqY/SNBZCJMLX7n53z2
         vl9hYcpKnIe0y9Y4F9gDcOScT9d1BQXcb1qC/WERvHwFO63GI4SEb+AM8nWsAPbBszOu
         ys3aATJ8MkoWMJR3yq3bZcP4YYITW4ZWRGIcOktR+ibc6kp1USbMQcnOQdADOxaPUEVp
         OJb1jLWaVJnb4MEhJinej2R2AuRP5PwoKXN+z7bxtmAG0FYjKR1zqwWqU596YRtTJb5L
         OrOg==
X-Gm-Message-State: ABy/qLYdIKegSJxCA3hD5jTNDScCanyTB9tUzfOTqNIQnoEZZW3oIiWW
        fq776xwE9PQLj047nuRQInNHahEVx97JZcwW1ifjWA==
X-Google-Smtp-Source: APBJJlH2EcKJmNRj9FXktydgMJpbVRopfo4XCcmt9cSNSkHsUzW30x5OOmbN17Zos9Bp0lx4mOrobJKBZxi8jM4a7Xw=
X-Received: by 2002:a17:906:9142:b0:958:4c75:705e with SMTP id
 y2-20020a170906914200b009584c75705emr2156152ejw.17.1688144895628; Fri, 30 Jun
 2023 10:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com>
In-Reply-To: <ZJ74gELkj4DgAk4S@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jun 2023 10:07:38 -0700
Message-ID: <CAL715WL9T8Ucnj_1AygwMgDjOJrttNZHRP9o-KUNfpx1aYZnog@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Sean Christopherson <seanjc@google.com>
Cc:     Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>,
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

On Fri, Jun 30, 2023 at 8:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jun 30, 2023, Roman Kagan wrote:
> > On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote=
:
> > > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_=
pmc *pmc)
> > > > >         return counter & pmc_bitmask(pmc);
> > > > >  }
> > > > >
> > > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 va=
l)
> > > > > +{
> > > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > > +
> > > > > +       pmc->counter =3D val;
> > > >
> > > > Doesn't this still have the original problem of storing wider value=
 than
> > > > allowed?
> > >
> > > Yes, this was just to fix the counter offset weirdness.  My plan is t=
o apply your
> > > patch on top.  Sorry for not making that clear.
> >
> > Ah, got it, thanks!
> >
> > Also I'm now chasing a problem that we occasionally see
> >
> > [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> > [3939579.462836] Do you have a strange power saving mode enabled?
> > [3939579.462836] Dazed and confused, but trying to continue
> >
> > in the guests when perf is used.  These messages disappear when
> > 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> > reverted.  I haven't yet figured out where exactly the culprit is.
>
> Can you reverting de0f619564f4 ("KVM: x86/pmu: Defer counter emulated ove=
rflow
> via pmc->prev_counter")?  I suspect the problem is the prev_counter mess.

For sure it is prev_counter issue, I have done some instrumentation as foll=
ows:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 48a0528080ab..946663a42326 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -322,8 +322,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
        if (!pmc_event_is_allowed(pmc))
                goto reprogram_complete;

-       if (pmc->counter < pmc->prev_counter)
+       if (pmc->counter < pmc->prev_counter) {
+               pr_info("pmc->counter: %llx\tpmc->prev_counter: %llx\n",
+                       pmc->counter, pmc->prev_counter);
                __kvm_perf_overflow(pmc, false);
+       }

        if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
                printk_once("kvm pmu: pin control bit is ignored\n");

I find some interesting changes on prev_counter:

[  +7.295348] pmc->counter: 12 pmc->prev_counter: fffffffffb3d
[  +0.622991] pmc->counter: 3 pmc->prev_counter: fffffffffb1a
[  +6.943282] pmc->counter: 1 pmc->prev_counter: fffffffff746
[  +4.483523] pmc->counter: 0 pmc->prev_counter: ffffffffffff
[ +12.817772] pmc->counter: 0 pmc->prev_counter: ffffffffffff
[ +21.721233] pmc->counter: 0 pmc->prev_counter: ffffffffffff

The first 3 logs will generate this:

[ +11.811925] Uhhuh. NMI received for unknown reason 20 on CPU 2.
[  +0.000003] Dazed and confused, but trying to continue

While the last 3 logs won't. This is quite reasonable as looking into
de0f619564f4 ("KVM: x86/pmu: Defer counter emulated overflow via
pmc->prev_counter"), counter and prev_counter should only have 1 diff
in value.

So, the reasonable suspect should be the stale prev_counter. There
might be several potential reasons behind this. Jim's theory is the
highly reasonable one as I did another experiment and found that KVM
may leave pmu->global_status as '0' when injecting an NMI.
