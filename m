Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8586C892E
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 00:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjCXXUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 19:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCXXUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 19:20:04 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54F1D915
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:20:03 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id bi31so2405749oib.9
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679700002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaHai1v0U5AvJP0zHlY3uELem034mHhVuUlCm/v+PZY=;
        b=kd40MgzjAGB6PP0D06mfxR4Tcqv9DmL//VbnljqoS/wxAOZLUyWtpX+I9IvXyXGWIF
         hMPwok/UFrJGDzJj9P1QtSriXPbPoVFXkiWsAuOsAY2OqhRL3AAkN1YbjH+BNBr1wySy
         Y9Qa8MZPQJFMq662bl/ae+pYHHi2WLYrsCCWCwjqqKxDUXTnnl/6fNvxSDQQyygxqf4X
         c7K/PggU9YSDQcbxIt7XwZ8MNJg6gTlRXhlGfAIqIQ96/19h5addx4a7WNqLOYDZfnW4
         Lq9Wk91Yf71Ue3SmGb4P6lPnVOsQBecxGJ7VdvwqeIDNTdUCPXYc9F6bJLXJ7kZYY0wX
         crbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679700002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaHai1v0U5AvJP0zHlY3uELem034mHhVuUlCm/v+PZY=;
        b=0jslfcUBJATTal+gdzAjsKgEJquYJt5L6k/D9Aw8MEQZXT7DNbmmUXgLfzcHNiG/OX
         T2zNuPBrv6kP+oe51DvX7+9yTP9cht6xiChdlcW73WS/WV/IZy/XZ/S0BxyYm54x087s
         Fmd5IGgNcPS7VvsCB7qGHB7oSwWL4um1vOgZfAPVif9syzYRNk26CLLfB58rx8G6E/h4
         SIDW/7POYa3bSQfRlXCSsktpYmS1vqdazOUWbgmpbLAv9ojukoCi2Oz6cTmC4rXoD0FF
         ErFlpvfboJ4j8mviEDtiOgAsZ/Y1KfFZ99BXjLZTv6zCjm1J/l3tLV142XwFd/L8+ji1
         5zOg==
X-Gm-Message-State: AO0yUKUVJalrnSU5uLd0k8brtijLp8q5HVidAqStgnHQt5gZiFflaz/t
        m+BCl78N2liwdT3UAZ05tHKyPvUzzNJojUViNdn4Eg==
X-Google-Smtp-Source: AK7set9fRdl24R/p5ScEBwbGTfBAFif90RPbm+lYCEG1rmPc3XqLIwQjQNVoPtkmn4OwA0N/4mxW3yUUJzHesjVyZvs=
X-Received: by 2002:a05:6808:615:b0:386:9bb5:a786 with SMTP id
 y21-20020a056808061500b003869bb5a786mr996112oih.9.1679700002267; Fri, 24 Mar
 2023 16:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230321112742.25255-1-likexu@tencent.com>
In-Reply-To: <20230321112742.25255-1-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 24 Mar 2023 16:19:51 -0700
Message-ID: <CALMp9eT0SrXCLriBN+nBv5fFQQ3n+b4Guq=-yLsFFQjeQ-nczA@mail.gmail.com>
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

On Tue, Mar 21, 2023 at 4:28=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> From: Like Xu <likexu@tencent.com>
>
> Per Intel SDM, fixed-function performance counter 'i' is supported if:
>
>         FxCtr[i]_is_supported :=3D ECX[i] || (EDX[4:0] > i);
>
> which means that the KVM user space can use EDX to limit the number of
> fixed counters and at the same time, using ECX to enable part of other
> KVM supported fixed counters.
>
> Add a bitmap (instead of always checking the vcpu's CPUIDs) to keep track
> of the guest available fixed counters and perform the semantic checks.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/pmu.h              |  8 +++++
>  arch/x86/kvm/vmx/pmu_intel.c    | 53 +++++++++++++++++++++------------
>  3 files changed, 44 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index a45de1118a42..14689e583127 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -565,6 +565,8 @@ struct kvm_pmu {
>          */
>         bool need_cleanup;
>
> +       DECLARE_BITMAP(supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
> +
>         /*
>          * The total number of programmed perf_events and it helps to avo=
id
>          * redundant check before cleanup if guest don't use vPMU at all.
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index be62c16f2265..9f4504e5e9d5 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -111,6 +111,11 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_=
pmu *pmu, u32 msr,
>         return NULL;
>  }
>
> +static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsigned =
int idx)
> +{
> +       return test_bit(idx, pmu->supported_fixed_pmc_idx);
> +}
> +
>  /* returns fixed PMC with the specified MSR */
>  static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr=
)
>  {
> @@ -120,6 +125,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kv=
m_pmu *pmu, u32 msr)
>                 u32 index =3D array_index_nospec(msr - base,
>                                                pmu->nr_arch_fixed_counter=
s);
>
> +               if (!fixed_ctr_is_supported(pmu, index))
> +                       return NULL;
> +
>                 return &pmu->fixed_counters[index];
>         }
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e8a3be0b9df9..12f4b2fe7756 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -43,13 +43,16 @@ static int fixed_pmc_events[] =3D {1, 0, 7};
>  static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>  {
>         struct kvm_pmc *pmc;
> -       u8 old_fixed_ctr_ctrl =3D pmu->fixed_ctr_ctrl;
> +       u8 new_ctrl, old_ctrl, old_fixed_ctr_ctrl =3D pmu->fixed_ctr_ctrl=
;
>         int i;
>
>         pmu->fixed_ctr_ctrl =3D data;
>         for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> -               u8 new_ctrl =3D fixed_ctrl_field(data, i);
> -               u8 old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl, i);
> +               if (!fixed_ctr_is_supported(pmu, i))
> +                       continue;
> +
> +               new_ctrl =3D fixed_ctrl_field(data, i);
> +               old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl, i);
>
>                 if (old_ctrl =3D=3D new_ctrl)
>                         continue;
> @@ -125,6 +128,9 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu =
*vcpu, unsigned int idx)
>
>         idx &=3D ~(3u << 30);
>
> +       if (fixed && !fixed_ctr_is_supported(pmu, idx))
> +               return false;
> +
>         return fixed ? idx < pmu->nr_arch_fixed_counters
>                      : idx < pmu->nr_arch_gp_counters;
>  }
> @@ -145,7 +151,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct =
kvm_vcpu *vcpu,
>                 counters =3D pmu->gp_counters;
>                 num_counters =3D pmu->nr_arch_gp_counters;
>         }
> -       if (idx >=3D num_counters)
> +       if (idx >=3D num_counters || (fixed && !fixed_ctr_is_supported(pm=
u, idx)))
>                 return NULL;
>         *mask &=3D pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_G=
P];
>         return &counters[array_index_nospec(idx, num_counters)];
> @@ -500,6 +506,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *=
pmu)
>         int i;
>
>         for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> +               if (!fixed_ctr_is_supported(pmu, i))
> +                       continue;
> +
>                 pmc =3D &pmu->fixed_counters[i];
>                 event =3D fixed_pmc_events[array_index_nospec(i, size)];
>                 pmc->eventsel =3D (intel_arch_events[event].unit_mask << =
8) |
> @@ -520,6 +529,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>
>         pmu->nr_arch_gp_counters =3D 0;
>         pmu->nr_arch_fixed_counters =3D 0;
> +       bitmap_zero(pmu->supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
>         pmu->counter_bitmask[KVM_PMC_GP] =3D 0;
>         pmu->counter_bitmask[KVM_PMC_FIXED] =3D 0;
>         pmu->version =3D 0;
> @@ -551,13 +561,24 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu=
)
>         pmu->available_event_types =3D ~entry->ebx &
>                                         ((1ull << eax.split.mask_length) =
- 1);
>
> -       if (pmu->version =3D=3D 1) {
> -               pmu->nr_arch_fixed_counters =3D 0;
> -       } else {
> +       counter_mask =3D ~(BIT_ULL(pmu->nr_arch_gp_counters) - 1);
> +       bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
> +
> +       if (pmu->version > 1) {
>                 pmu->nr_arch_fixed_counters =3D
> -                       min3(ARRAY_SIZE(fixed_pmc_events),
> -                            (size_t) edx.split.num_counters_fixed,
> -                            (size_t)kvm_pmu_cap.num_counters_fixed);
> +                       min_t(int, ARRAY_SIZE(fixed_pmc_events),
> +                             kvm_pmu_cap.num_counters_fixed);
> +               for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> +                       /* FxCtr[i]_is_supported :=3D CPUID.0xA.ECX[i] ||=
 (EDX[4:0] > i) */

This is true only when pmu->version >=3D 5.

From the SDM, volume 3, section 20.2.5 Architectural Performance
Monitoring Version 5:

With Architectural Performance Monitoring Version 5, register
CPUID.0AH.ECX indicates Fixed Counter enumeration. It is a bit mask
which enumerates the supported Fixed Counters in a processor. If bit
'i' is set, it implies that Fixed Counter 'i' is supported. Software
is recommended to use the following logic to check if a Fixed Counter
is supported on a given processor: FxCtr[i]_is_supported :=3D ECX[i] ||
(EDX[4:0] > i);

Prior to PMU version 5, all fixed counters from 0 through <number of
fixed counters - 1> are supported.

> +                       if (!(entry->ecx & BIT_ULL(i) ||
> +                             edx.split.num_counters_fixed > i))
> +                               continue;
> +
> +                       set_bit(i, pmu->supported_fixed_pmc_idx);
> +                       set_bit(INTEL_PMC_MAX_GENERIC + i, pmu->all_valid=
_pmc_idx);
> +                       pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i * 4)=
);
> +                       counter_mask &=3D ~BIT_ULL(INTEL_PMC_MAX_GENERIC =
+ i);
> +               }
>                 edx.split.bit_width_fixed =3D min_t(int, edx.split.bit_wi=
dth_fixed,
>                                                   kvm_pmu_cap.bit_width_f=
ixed);
>                 pmu->counter_bitmask[KVM_PMC_FIXED] =3D
> @@ -565,10 +586,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>                 setup_fixed_pmc_eventsel(pmu);
>         }
>
> -       for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++)
> -               pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i * 4));
> -       counter_mask =3D ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
> -               (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC=
_IDX_FIXED));
>         pmu->global_ctrl_mask =3D counter_mask;
>         pmu->global_ovf_ctrl_mask =3D pmu->global_ctrl_mask
>                         & ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
> @@ -585,11 +602,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>                 pmu->raw_event_mask |=3D (HSW_IN_TX|HSW_IN_TX_CHECKPOINTE=
D);
>         }
>
> -       bitmap_set(pmu->all_valid_pmc_idx,
> -               0, pmu->nr_arch_gp_counters);
> -       bitmap_set(pmu->all_valid_pmc_idx,
> -               INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
> -
>         perf_capabilities =3D vcpu_get_perf_capabilities(vcpu);
>         if (cpuid_model_is_consistent(vcpu) &&
>             (perf_capabilities & PMU_CAP_LBR_FMT))
> @@ -605,6 +617,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>                         pmu->pebs_enable_mask =3D counter_mask;
>                         pmu->reserved_bits &=3D ~ICL_EVENTSEL_ADAPTIVE;
>                         for (i =3D 0; i < pmu->nr_arch_fixed_counters; i+=
+) {
> +                               if (!fixed_ctr_is_supported(pmu, i))
> +                                       continue;
> +
>                                 pmu->fixed_ctr_ctrl_mask &=3D
>                                         ~(1ULL << (INTEL_PMC_IDX_FIXED + =
i * 4));
>                         }
>
> base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
> --
> 2.40.0
>
