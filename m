Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F72E6CA858
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbjC0O6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjC0O6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:58:37 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F102540CA
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:58:35 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-177ca271cb8so9551947fac.2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679929115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcL6+3tvjdTW9fIDzgsbGrc6U5hGI9RcOR9ewIIRrxU=;
        b=LzcQMdM9A6OT62XULX11p/ZaWBKvoAUOMEBaYR/G/OGaOEJkZaOvm+AITolNSJOWgI
         XFo3+59nxCia9pcoW0bmAv/uNk1Tnygb36jy/Aj70LJnkrELl5Z8CRmU4OapnR+uTszp
         nMnYXkHv0r8dLwz/IpPv8/qu08xsyOvEkr10MxXjoS2+INEjvWJ+uCwOqjKFs2V3Y0yQ
         0ClU429ty9HawUZuwGM2nHnW/Yni0JU7kIFYLBySzOqvzK8lrplJHs69ZoMr/5bEnNkd
         BhwLkOOst7Jy20gw7K/JfQkK51TXhjnxZ+6CrC0miEJsfGGSPRI8rFM9K5lx7g763Zau
         cOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679929115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcL6+3tvjdTW9fIDzgsbGrc6U5hGI9RcOR9ewIIRrxU=;
        b=JWOyMZT8RgVlo2eCaw5rn9FmgyTgy9Lv+/y3C+iHgMxmYbLqhWNhnry/KrbgyR422J
         g6USKyxYgQbJeo5/kc4eOF1//E8ZlH/8LyhYy1Hfgc/ndE50g9NUmJewIsvYFZN1FaOh
         LBPOYRhUoXYRSQwB3v8qEou+w/UD6FOjCSSon8uAW78mhlNF6RoMNEzfIuSg1mdD+3kM
         SN3E7UvAsX17hoK3r7Uajz5dz44AJAwD8e48/HGD6nfYdruFu9LaW3K8mwA/clzuFrgM
         witg+2AiriOtJv3p9Qs96xjltEn+1qk7Z9sq5QqKEpMBxc7fFs0R4RXv+nSokN/wuYg1
         3VbA==
X-Gm-Message-State: AAQBX9dcccCM0I0iue+SHsT/6p2FKNsTdMOJhGeGFPafeWOt/5h1HCwG
        k9UX+e9PqOL5dlQhS0RsCJPhrtiD1dcV7YbgH5KTdQ==
X-Google-Smtp-Source: AKy350YX+e2311N/053mtKzk6ZxA9sDg3bXuVcG868al8EjpekHZsXTzJAaYufHn6ulfzLNxo8wtDNFX2tox7KXBLU8=
X-Received: by 2002:a05:6871:4d03:b0:17d:1287:1b5c with SMTP id
 ug3-20020a0568714d0300b0017d12871b5cmr4109751oab.9.1679929115028; Mon, 27 Mar
 2023 07:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230321112742.25255-1-likexu@tencent.com> <CALMp9eT0SrXCLriBN+nBv5fFQQ3n+b4Guq=-yLsFFQjeQ-nczA@mail.gmail.com>
 <e002f554-b69d-cedf-162c-271bc3609a39@gmail.com>
In-Reply-To: <e002f554-b69d-cedf-162c-271bc3609a39@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 27 Mar 2023 07:58:23 -0700
Message-ID: <CALMp9eQVnk8gkOpX5AHhaCr8-5Fe=qNuX8PUP1Gv2H5FSYmHSw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Add Intel PMU supported fixed counters bit mask
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 12:47=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> =
wrote:
>
> On 25/3/2023 7:19 am, Jim Mattson wrote:
> > On Tue, Mar 21, 2023 at 4:28=E2=80=AFAM Like Xu <like.xu.linux@gmail.co=
m> wrote:
> >>
> >> From: Like Xu <likexu@tencent.com>
> >>
> >> Per Intel SDM, fixed-function performance counter 'i' is supported if:
> >>
> >>          FxCtr[i]_is_supported :=3D ECX[i] || (EDX[4:0] > i);
> >>
> >> which means that the KVM user space can use EDX to limit the number of
> >> fixed counters and at the same time, using ECX to enable part of other
> >> KVM supported fixed counters.
> >>
> >> Add a bitmap (instead of always checking the vcpu's CPUIDs) to keep tr=
ack
> >> of the guest available fixed counters and perform the semantic checks.
> >>
> >> Signed-off-by: Like Xu <likexu@tencent.com>
> >> ---
> >>   arch/x86/include/asm/kvm_host.h |  2 ++
> >>   arch/x86/kvm/pmu.h              |  8 +++++
> >>   arch/x86/kvm/vmx/pmu_intel.c    | 53 +++++++++++++++++++++----------=
--
> >>   3 files changed, 44 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
> >> index a45de1118a42..14689e583127 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -565,6 +565,8 @@ struct kvm_pmu {
> >>           */
> >>          bool need_cleanup;
> >>
> >> +       DECLARE_BITMAP(supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
> >> +
> >>          /*
> >>           * The total number of programmed perf_events and it helps to=
 avoid
> >>           * redundant check before cleanup if guest don't use vPMU at =
all.
> >> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> >> index be62c16f2265..9f4504e5e9d5 100644
> >> --- a/arch/x86/kvm/pmu.h
> >> +++ b/arch/x86/kvm/pmu.h
> >> @@ -111,6 +111,11 @@ static inline struct kvm_pmc *get_gp_pmc(struct k=
vm_pmu *pmu, u32 msr,
> >>          return NULL;
> >>   }
> >>
> >> +static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsign=
ed int idx)
> >> +{
> >> +       return test_bit(idx, pmu->supported_fixed_pmc_idx);
> >> +}
> >> +
> >>   /* returns fixed PMC with the specified MSR */
> >>   static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32=
 msr)
> >>   {
> >> @@ -120,6 +125,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct=
 kvm_pmu *pmu, u32 msr)
> >>                  u32 index =3D array_index_nospec(msr - base,
> >>                                                 pmu->nr_arch_fixed_cou=
nters);
> >>
> >> +               if (!fixed_ctr_is_supported(pmu, index))
> >> +                       return NULL;
> >> +
> >>                  return &pmu->fixed_counters[index];
> >>          }
> >>
> >> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel=
.c
> >> index e8a3be0b9df9..12f4b2fe7756 100644
> >> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >> @@ -43,13 +43,16 @@ static int fixed_pmc_events[] =3D {1, 0, 7};
> >>   static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
> >>   {
> >>          struct kvm_pmc *pmc;
> >> -       u8 old_fixed_ctr_ctrl =3D pmu->fixed_ctr_ctrl;
> >> +       u8 new_ctrl, old_ctrl, old_fixed_ctr_ctrl =3D pmu->fixed_ctr_c=
trl;
> >>          int i;
> >>
> >>          pmu->fixed_ctr_ctrl =3D data;
> >>          for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >> -               u8 new_ctrl =3D fixed_ctrl_field(data, i);
> >> -               u8 old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl, i=
);
> >> +               if (!fixed_ctr_is_supported(pmu, i))
> >> +                       continue;
> >> +
> >> +               new_ctrl =3D fixed_ctrl_field(data, i);
> >> +               old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl, i);
> >>
> >>                  if (old_ctrl =3D=3D new_ctrl)
> >>                          continue;
> >> @@ -125,6 +128,9 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vc=
pu *vcpu, unsigned int idx)
> >>
> >>          idx &=3D ~(3u << 30);
> >>
> >> +       if (fixed && !fixed_ctr_is_supported(pmu, idx))
> >> +               return false;
> >> +
> >>          return fixed ? idx < pmu->nr_arch_fixed_counters
> >>                       : idx < pmu->nr_arch_gp_counters;
> >>   }
> >> @@ -145,7 +151,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(stru=
ct kvm_vcpu *vcpu,
> >>                  counters =3D pmu->gp_counters;
> >>                  num_counters =3D pmu->nr_arch_gp_counters;
> >>          }
> >> -       if (idx >=3D num_counters)
> >> +       if (idx >=3D num_counters || (fixed && !fixed_ctr_is_supported=
(pmu, idx)))
> >>                  return NULL;
> >>          *mask &=3D pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_P=
MC_GP];
> >>          return &counters[array_index_nospec(idx, num_counters)];
> >> @@ -500,6 +506,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pm=
u *pmu)
> >>          int i;
> >>
> >>          for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >> +               if (!fixed_ctr_is_supported(pmu, i))
> >> +                       continue;
> >> +
> >>                  pmc =3D &pmu->fixed_counters[i];
> >>                  event =3D fixed_pmc_events[array_index_nospec(i, size=
)];
> >>                  pmc->eventsel =3D (intel_arch_events[event].unit_mask=
 << 8) |
> >> @@ -520,6 +529,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcp=
u)
> >>
> >>          pmu->nr_arch_gp_counters =3D 0;
> >>          pmu->nr_arch_fixed_counters =3D 0;
> >> +       bitmap_zero(pmu->supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
> >>          pmu->counter_bitmask[KVM_PMC_GP] =3D 0;
> >>          pmu->counter_bitmask[KVM_PMC_FIXED] =3D 0;
> >>          pmu->version =3D 0;
> >> @@ -551,13 +561,24 @@ static void intel_pmu_refresh(struct kvm_vcpu *v=
cpu)
> >>          pmu->available_event_types =3D ~entry->ebx &
> >>                                          ((1ull << eax.split.mask_leng=
th) - 1);
> >>
> >> -       if (pmu->version =3D=3D 1) {
> >> -               pmu->nr_arch_fixed_counters =3D 0;
> >> -       } else {
> >> +       counter_mask =3D ~(BIT_ULL(pmu->nr_arch_gp_counters) - 1);
> >> +       bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters=
);
> >> +
> >> +       if (pmu->version > 1) {
> >>                  pmu->nr_arch_fixed_counters =3D
> >> -                       min3(ARRAY_SIZE(fixed_pmc_events),
> >> -                            (size_t) edx.split.num_counters_fixed,
> >> -                            (size_t)kvm_pmu_cap.num_counters_fixed);
> >> +                       min_t(int, ARRAY_SIZE(fixed_pmc_events),
> >> +                             kvm_pmu_cap.num_counters_fixed);
> >> +               for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >> +                       /* FxCtr[i]_is_supported :=3D CPUID.0xA.ECX[i]=
 || (EDX[4:0] > i) */
> >
> > This is true only when pmu->version >=3D 5.
>
> This is true in for "Version 5" section, but not mentioned in the CPUID.0=
xA section.
> I would argue that this is a deliberate omission for the instruction impl=
ementation,
> as it does use the word "version>1" in the near CPUID.0xA.EDX section.

Do you have any evidence to support such an argument? The CPUID field
in question was not defined prior to PMU version 5. (Does anyone from
Intel want to chime in?)

> For virtualised use, this feature offers a kind of flexibility as users c=
an
> enable part of
> the fixed counters, don't you think? Or maybe you're more looking forward=
 to the
> patch set that raises the vPMU version number from 2 to 5, that part of t=
he code
> was already in my tree some years ago.

I would not be surprised if a guest OS checked for PMU version 5
before consulting the CPUID fields defined in PMU version 5. Does
Linux even consult the fixed counter bitmask field today?

I'd love to see KVM virtualize PMU version 5!

> >
> >  From the SDM, volume 3, section 20.2.5 Architectural Performance
> > Monitoring Version 5:
> >
> > With Architectural Performance Monitoring Version 5, register
> > CPUID.0AH.ECX indicates Fixed Counter enumeration. It is a bit mask
> > which enumerates the supported Fixed Counters in a processor. If bit
> > 'i' is set, it implies that Fixed Counter 'i' is supported. Software
> > is recommended to use the following logic to check if a Fixed Counter
> > is supported on a given processor: FxCtr[i]_is_supported :=3D ECX[i] ||
> > (EDX[4:0] > i);
> >
> > Prior to PMU version 5, all fixed counters from 0 through <number of
> > fixed counters - 1> are supported.
> >
> >> +                       if (!(entry->ecx & BIT_ULL(i) ||
> >> +                             edx.split.num_counters_fixed > i))
> >> +                               continue;
> >> +
> >> +                       set_bit(i, pmu->supported_fixed_pmc_idx);
> >> +                       set_bit(INTEL_PMC_MAX_GENERIC + i, pmu->all_va=
lid_pmc_idx);
> >> +                       pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i *=
 4));
> >> +                       counter_mask &=3D ~BIT_ULL(INTEL_PMC_MAX_GENER=
IC + i);
> >> +               }
> >>                  edx.split.bit_width_fixed =3D min_t(int, edx.split.bi=
t_width_fixed,
> >>                                                    kvm_pmu_cap.bit_wid=
th_fixed);
> >>                  pmu->counter_bitmask[KVM_PMC_FIXED] =3D
> >> @@ -565,10 +586,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vc=
pu)
> >>                  setup_fixed_pmc_eventsel(pmu);
> >>          }
> >>
> >> -       for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++)
> >> -               pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i * 4));
> >> -       counter_mask =3D ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
> >> -               (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_=
PMC_IDX_FIXED));
> >>          pmu->global_ctrl_mask =3D counter_mask;
> >>          pmu->global_ovf_ctrl_mask =3D pmu->global_ctrl_mask
> >>                          & ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
> >> @@ -585,11 +602,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vc=
pu)
> >>                  pmu->raw_event_mask |=3D (HSW_IN_TX|HSW_IN_TX_CHECKPO=
INTED);
> >>          }
> >>
> >> -       bitmap_set(pmu->all_valid_pmc_idx,
> >> -               0, pmu->nr_arch_gp_counters);
> >> -       bitmap_set(pmu->all_valid_pmc_idx,
> >> -               INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
> >> -
> >>          perf_capabilities =3D vcpu_get_perf_capabilities(vcpu);
> >>          if (cpuid_model_is_consistent(vcpu) &&
> >>              (perf_capabilities & PMU_CAP_LBR_FMT))
> >> @@ -605,6 +617,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcp=
u)
> >>                          pmu->pebs_enable_mask =3D counter_mask;
> >>                          pmu->reserved_bits &=3D ~ICL_EVENTSEL_ADAPTIV=
E;
> >>                          for (i =3D 0; i < pmu->nr_arch_fixed_counters=
; i++) {
> >> +                               if (!fixed_ctr_is_supported(pmu, i))
> >> +                                       continue;
> >> +
> >>                                  pmu->fixed_ctr_ctrl_mask &=3D
> >>                                          ~(1ULL << (INTEL_PMC_IDX_FIXE=
D + i * 4));
> >>                          }
> >>
> >> base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
> >> --
> >> 2.40.0
> >>
