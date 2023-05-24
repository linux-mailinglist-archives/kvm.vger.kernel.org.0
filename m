Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547CE710005
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 23:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjEXVah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 17:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjEXVag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 17:30:36 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED5EC5
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:30:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae64580e9fso20295ad.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684963834; x=1687555834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2+uYBM7vhcZmnf3eRsoO9c1MdM84v2xsik1061w3BU=;
        b=303m9Llrp6cfxOdtK60TR0oaqqRB2ACyQFV7cV3rxGv8aVqoho39Sqj7AGcKq5A/DD
         6Sw2vu+7TxqxiqG5KVsxm3YbmUwaONCcn2RFl2G1EmqB0M6oXwj0uBwjshI7oEN5rp9a
         dkOI+cQBI85rSr27inftspFiR3yffYEV17N/ypfmSOCpDjDilGar7hHGn2x2Xh4fyZjV
         p/J/sodZI7aw3e8vLoA6EtKP7r4eRuMGH2PXzEkfk1KktA29Iy94lwGf/bGSvSb6M03t
         kInAp2jRO1+y8NE26awFbtyfzAfolKWsi6yGwR2E5orPdlaJaR49Tfl4IhwCCGxo7gIf
         5pRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684963834; x=1687555834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2+uYBM7vhcZmnf3eRsoO9c1MdM84v2xsik1061w3BU=;
        b=YIABJkRcdM2NODXnmlZh6jRuh2lotJyKjAXLuTy6RA40jH73ENBNVTL6TiSxlFOIWj
         n89e+Eebs0ZbQbUghN6b4ccXNZEs165rM5nI4FVwiP7SY73dfIHVBesZ+vjJLDcngexn
         NJYvOKWS3Yyp6WeLljYwMvbk2+sC1Yh+BDh2Mfaubjlc5hDvpXf5Bdf8yA9VBCymRPH9
         vLp2d5QXPoqTjIgyARv3BEwWe3k97RhlJZezCbcRYvLMSB953+F/GGKl0MPtF63Ku3gk
         QKhhvBbQd05dRpo5Q3eo4yDulv6PJzJA1Vy8ED4xMQPzVOWfVYUvXYnnz+DLgpSyV4b4
         iWfA==
X-Gm-Message-State: AC+VfDz1X0DfOpmx9m8LvSFhNCWiMuuHIuzDPtaHbdlTtuDx/1BFTtj9
        FgM28IAFUfxAiTZXX3YUKQe7/uiArUaGMzMzmZ2ehg==
X-Google-Smtp-Source: ACHHUZ6+1ieC3oV2pkDDB18X32nt/PqbrPCNaRs6RWDzSSJW2g1XT8mV6g1SQYhASRcjSt3XuUxfC9xfD1XBnF2oJoI=
X-Received: by 2002:a17:902:e746:b0:1a8:df:f3c6 with SMTP id
 p6-20020a170902e74600b001a800dff3c6mr73961plf.2.1684963833783; Wed, 24 May
 2023 14:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
 <ZG6AUjci2J9WpT2z@google.com>
In-Reply-To: <ZG6AUjci2J9WpT2z@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 24 May 2023 14:30:22 -0700
Message-ID: <CALMp9eSe+kx8s5rkypvHWjFr45L_foXiDi1Vdp3R=AmRwA3RAQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Sean Christopherson <seanjc@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, May 24, 2023 at 2:23=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Mar 10, 2023, Like Xu wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index adb92fc4d7c9..d6fcbf233cb3 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -561,6 +561,10 @@ struct kvm_pmu {
> >        */
> >       u64 host_cross_mapped_mask;
> >
> > +     /* Flags to track any HW quirks that need to be fixed by vPMU. */
> > +     u64 quirk_flags;
> > +     DECLARE_BITMAP(hide_vmrun_pmc_idx, X86_PMC_IDX_MAX);
>
> Since it sounds like AMD isn't changing the behavior, let's forego the qu=
irk and
> just hardcode the fixup.
>
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 2a0504732966..315dca021d57 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -254,6 +254,7 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
> >       counter +=3D perf_event_pause(pmc->perf_event, true);
> >       pmc->counter =3D counter & pmc_bitmask(pmc);
> >       pmc->is_paused =3D true;
> > +     kvm_mark_pmc_is_quirky(pmc);
> >  }
> >
> >  static bool pmc_resume_counter(struct kvm_pmc *pmc)
> > @@ -822,6 +823,19 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *=
kvm, void __user *argp)
> >       return r;
> >  }
> >
> > +static inline bool event_is_branch_instruction(struct kvm_pmc *pmc)
>
> How about pmc_is_counting_branches()?  The "event" itself isn't a branch
> instruction.

Note that there's a bug in the original code for this that has
probably never been fixed: it ignores CMASK and INV in the PerfEvtSel.

> > +{
> > +     return eventsel_match_perf_hw_id(pmc, PERF_COUNT_HW_INSTRUCTIONS)=
 ||
> > +             eventsel_match_perf_hw_id(pmc,
> > +                                       PERF_COUNT_HW_BRANCH_INSTRUCTIO=
NS);
>
> Let this poke out.
>
> > +}
> > +
> > +static inline bool quirky_pmc_will_count_vmrun(struct kvm_pmc *pmc)
> > +{
> > +     return event_is_branch_instruction(pmc) && event_is_allowed(pmc) =
&&
> > +             !static_call(kvm_x86_get_cpl)(pmc->vcpu);
> > +}
> > +
> >  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> > @@ -837,6 +851,10 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
> >
> >               reprogram_counter(pmc);
> >               kvm_pmu_handle_pmc_overflow(pmc);
> > +
> > +             if (vcpu_has_pmu_quirks(vcpu) &&
> > +                 quirky_pmc_will_count_vmrun(pmc))
> > +                     set_bit(pmc->idx, pmu->hide_vmrun_pmc_idx);
>
> Doesn't this need to adjust the count _before_ handling overflow?  I.e. i=
sn't it
> possible for the bogus counts to cause bogus overflow?
>
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index a47b579667c6..30f6f58f4c38 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -18,6 +18,9 @@
> >  #define VMWARE_BACKDOOR_PMC_REAL_TIME                0x10001
> >  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME    0x10002
> >
> > +#define X86_PMU_COUNT_VMRUN  BIT_ULL(0)
> > +#define X86_PMU_QUIRKS_MASK  X86_PMU_COUNT_VMRUN
> > +
> >  struct kvm_pmu_ops {
> >       bool (*hw_event_available)(struct kvm_pmc *pmc);
> >       bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
> > @@ -54,14 +57,33 @@ static inline void kvm_pmu_request_counter_reprogra=
m(struct kvm_pmc *pmc)
> >       kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> >  }
> >
> > +static inline bool vcpu_has_pmu_quirks(struct kvm_vcpu *vcpu)
> > +{
> > +     return vcpu_to_pmu(vcpu)->quirk_flags & X86_PMU_QUIRKS_MASK;
> > +}
> > +
> > +/*
> > + * The time to mark pmc is when the accumulation value returned
> > + * by perf API based on a HW counter has just taken effect.
> > + */
> > +static inline void kvm_mark_pmc_is_quirky(struct kvm_pmc *pmc)
> > +{
> > +     if (!vcpu_has_pmu_quirks(pmc->vcpu))
> > +             return;
> > +
> > +     kvm_pmu_request_counter_reprogram(pmc);
> > +}
> > +
> >  static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> >  {
> >       u64 counter, enabled, running;
> >
> >       counter =3D pmc->counter;
> > -     if (pmc->perf_event && !pmc->is_paused)
> > +     if (pmc->perf_event && !pmc->is_paused) {
> >               counter +=3D perf_event_read_value(pmc->perf_event,
> >                                                &enabled, &running);
> > +             kvm_mark_pmc_is_quirky(pmc);
> > +     }
> >       /* FIXME: Scaling needed? */
> >       return counter & pmc_bitmask(pmc);
> >  }
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index 5fa939e411d8..130991a97f22 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -187,6 +187,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
> >       pmu->nr_arch_fixed_counters =3D 0;
> >       pmu->global_status =3D 0;
> >       bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
> > +     pmu->quirk_flags |=3D X86_PMU_COUNT_VMRUN;
> >  }
> >
> >  static void amd_pmu_init(struct kvm_vcpu *vcpu)
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index f41d96e638ef..f6b33d172481 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3919,6 +3919,31 @@ static fastpath_t svm_exit_handlers_fastpath(str=
uct kvm_vcpu *vcpu)
> >       return EXIT_FASTPATH_NONE;
> >  }
> >
> > +static void pmu_hide_vmrun(struct kvm_vcpu *vcpu)
>
> This needs to be noinstr.
>
> > +{
> > +     struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> > +     struct kvm_pmc *pmc;
> > +     unsigned int i;
> > +
> > +     for_each_set_bit(i, pmu->hide_vmrun_pmc_idx, X86_PMC_IDX_MAX) {
> > +             clear_bit(i, pmu->hide_vmrun_pmc_idx);
>
> Clearing the bit will hide only the first VMRUN after the guest attempts =
to read
> the counter, no?  The fixup needs to apply to every VMRUN that is execute=
d after
> the PMC is programmed.  Or am I misreading the patch?
>
> > +
> > +             /* AMD doesn't have fixed counters at now. */
> > +             if (i >=3D pmu->nr_arch_gp_counters)
> > +                     continue;
> > +
> > +             /*
> > +              * The prerequisite for fixing HW quirks is that there is=
 indeed
> > +              * HW working and perf has no chance to retrieve the coun=
ter.
>
> I don't follow the "perf has no chance to retrieve the counter" part.
>
> > +              */
> > +             pmc =3D &pmu->gp_counters[i];
> > +             if (!pmc->perf_event || pmc->perf_event->hw.idx < 0)
> > +                     continue;
> > +
> > +             pmc->counter--;
> > +     }
> > +}
> > +
> >  static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool sp=
ec_ctrl_intercepted)
> >  {
> >       struct vcpu_svm *svm =3D to_svm(vcpu);
> > @@ -3986,6 +4011,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct =
kvm_vcpu *vcpu)
> >
> >       kvm_wait_lapic_expire(vcpu);
> >
> > +     if (vcpu->kvm->arch.enable_pmu && vcpu_has_pmu_quirks(vcpu))
> > +             pmu_hide_vmrun(vcpu);
> > +
> >       /*
> >        * If this vCPU has touched SPEC_CTRL, restore the guest's value =
if
> >        * it's non-zero. Since vmentry is serialising on affected CPUs, =
there
> > --
> > 2.39.2
> >
