Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B2F6CC832
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjC1QjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjC1QjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:39:05 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698B977E
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:39:03 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id cm7-20020a056830650700b006a11f365d13so5378356otb.0
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680021542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kBfDOkLpG6hikV608JINDtCSthbfnxHO543G7BGPuA=;
        b=A/eD/go7ClEtmJWDskIdc1JS8/KEST8EyDb/UxTH6FDcb31TgHBm1lJ4OjzByFFHPZ
         IklAPlT1eTBjypz3WaJ7Q8/tzc/F3oQU3x9wBWEVsrOb1B2XHi7Gw5qpgxJ5+fdrP2XH
         EK/m6Bdien2A20Z4Xnrw8woEuD/+UIuf+K+VCyx6MEfl9kTEL1wGawHihSGD16HMKmh9
         7+xJ/7QDLl1yd+/gW3++Zm6x0qzxCzS0w8ADXydamkElroQLIGv767psVtFsO5XebcIo
         ZOweBvREUK02KCf3K4pVNLUpVSzyMP+HeyzHsFhiKFEUsaIt80+8mUh8fCYuu687itRe
         F8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680021542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kBfDOkLpG6hikV608JINDtCSthbfnxHO543G7BGPuA=;
        b=QxGYeP4eOPE6cU2u1P0DcBzaGHYHJKSixQqKCSAVxn0azWLqMRmPcyoI3QBitfg4Z3
         wtNzgin0V1gcOxHkxa2iw2ySB58QrGhoLaSUkCzeIVwUtfB9IIDSQCbH3UaiNehQfuWB
         AROkSkC/umjOKrahKMQsLYvCePYut4GApo2MvfRJenOBOLDd7L/7Yi8KkdCckR4a0v0z
         Q/dNSXzVjy+0XAhcIp+KRu+6py4eGGCVejuuANffEUzTkFAl8r6+FVCW9EaaCcgjXiFR
         CRff4WhH2WEUkN/6+sWHGxtlzoF6egDWMZajck1t2tQdJqUhqf4H3lgEF8eCTfETF9r+
         260w==
X-Gm-Message-State: AO0yUKVW+bELnjjhcWz5WrN9n92nl7cXSAvUOFVhQcwIJiyJXPkF1JQ0
        P8T/NTXefHBIQ7+bdtZAty1lnIJWYE3X3jKORhg45ZWIOBRroH95hmA=
X-Google-Smtp-Source: AK7set97hUk9wU6iaSXYhcAwA60MYzw6g1HSCdQc375zwrAyFJv8DGlFFQ52G0vzxqgMFLqP/x9m1PMus1GaxPyuB7A=
X-Received: by 2002:a05:6830:1c4:b0:69d:66f0:a34e with SMTP id
 r4-20020a05683001c400b0069d66f0a34emr5066206ota.2.1680021542077; Tue, 28 Mar
 2023 09:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230321112742.25255-1-likexu@tencent.com> <CALMp9eT0SrXCLriBN+nBv5fFQQ3n+b4Guq=-yLsFFQjeQ-nczA@mail.gmail.com>
 <e002f554-b69d-cedf-162c-271bc3609a39@gmail.com> <CALMp9eQVnk8gkOpX5AHhaCr8-5Fe=qNuX8PUP1Gv2H5FSYmHSw@mail.gmail.com>
 <cff6147a-9e57-0f8f-9dce-372f3992f17d@gmail.com>
In-Reply-To: <cff6147a-9e57-0f8f-9dce-372f3992f17d@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Mar 2023 09:38:50 -0700
Message-ID: <CALMp9eT9bMGCNan2sQQyJpJvaTqn8hQjuzCASkHWufVtyksD5A@mail.gmail.com>
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

On Tue, Mar 28, 2023 at 3:27=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> On 27/3/2023 10:58 pm, Jim Mattson wrote:
> > On Mon, Mar 27, 2023 at 12:47=E2=80=AFAM Like Xu <like.xu.linux@gmail.c=
om> wrote:
> >>
> >> On 25/3/2023 7:19 am, Jim Mattson wrote:
> >>> On Tue, Mar 21, 2023 at 4:28=E2=80=AFAM Like Xu <like.xu.linux@gmail.=
com> wrote:
> >>>>
> >>>> From: Like Xu <likexu@tencent.com>
> >>>>
> >>>> Per Intel SDM, fixed-function performance counter 'i' is supported i=
f:
> >>>>
> >>>>           FxCtr[i]_is_supported :=3D ECX[i] || (EDX[4:0] > i);
> >>>>
> >>>> which means that the KVM user space can use EDX to limit the number =
of
> >>>> fixed counters and at the same time, using ECX to enable part of oth=
er
> >>>> KVM supported fixed counters.
> >>>>
> >>>> Add a bitmap (instead of always checking the vcpu's CPUIDs) to keep =
track
> >>>> of the guest available fixed counters and perform the semantic check=
s.
> >>>>
> >>>> Signed-off-by: Like Xu <likexu@tencent.com>
> >>>> ---
> >>>>    arch/x86/include/asm/kvm_host.h |  2 ++
> >>>>    arch/x86/kvm/pmu.h              |  8 +++++
> >>>>    arch/x86/kvm/vmx/pmu_intel.c    | 53 +++++++++++++++++++++-------=
-----
> >>>>    3 files changed, 44 insertions(+), 19 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/=
kvm_host.h
> >>>> index a45de1118a42..14689e583127 100644
> >>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>> @@ -565,6 +565,8 @@ struct kvm_pmu {
> >>>>            */
> >>>>           bool need_cleanup;
> >>>>
> >>>> +       DECLARE_BITMAP(supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
> >>>> +
> >>>>           /*
> >>>>            * The total number of programmed perf_events and it helps=
 to avoid
> >>>>            * redundant check before cleanup if guest don't use vPMU =
at all.
> >>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> >>>> index be62c16f2265..9f4504e5e9d5 100644
> >>>> --- a/arch/x86/kvm/pmu.h
> >>>> +++ b/arch/x86/kvm/pmu.h
> >>>> @@ -111,6 +111,11 @@ static inline struct kvm_pmc *get_gp_pmc(struct=
 kvm_pmu *pmu, u32 msr,
> >>>>           return NULL;
> >>>>    }
> >>>>
> >>>> +static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsi=
gned int idx)
> >>>> +{
> >>>> +       return test_bit(idx, pmu->supported_fixed_pmc_idx);
> >>>> +}
> >>>> +
> >>>>    /* returns fixed PMC with the specified MSR */
> >>>>    static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, =
u32 msr)
> >>>>    {
> >>>> @@ -120,6 +125,9 @@ static inline struct kvm_pmc *get_fixed_pmc(stru=
ct kvm_pmu *pmu, u32 msr)
> >>>>                   u32 index =3D array_index_nospec(msr - base,
> >>>>                                                  pmu->nr_arch_fixed_=
counters);
> >>>>
> >>>> +               if (!fixed_ctr_is_supported(pmu, index))
> >>>> +                       return NULL;
> >>>> +
> >>>>                   return &pmu->fixed_counters[index];
> >>>>           }
> >>>>
> >>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_int=
el.c
> >>>> index e8a3be0b9df9..12f4b2fe7756 100644
> >>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >>>> @@ -43,13 +43,16 @@ static int fixed_pmc_events[] =3D {1, 0, 7};
> >>>>    static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 dat=
a)
> >>>>    {
> >>>>           struct kvm_pmc *pmc;
> >>>> -       u8 old_fixed_ctr_ctrl =3D pmu->fixed_ctr_ctrl;
> >>>> +       u8 new_ctrl, old_ctrl, old_fixed_ctr_ctrl =3D pmu->fixed_ctr=
_ctrl;
> >>>>           int i;
> >>>>
> >>>>           pmu->fixed_ctr_ctrl =3D data;
> >>>>           for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >>>> -               u8 new_ctrl =3D fixed_ctrl_field(data, i);
> >>>> -               u8 old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl,=
 i);
> >>>> +               if (!fixed_ctr_is_supported(pmu, i))
> >>>> +                       continue;
> >>>> +
> >>>> +               new_ctrl =3D fixed_ctrl_field(data, i);
> >>>> +               old_ctrl =3D fixed_ctrl_field(old_fixed_ctr_ctrl, i)=
;
> >>>>
> >>>>                   if (old_ctrl =3D=3D new_ctrl)
> >>>>                           continue;
> >>>> @@ -125,6 +128,9 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_=
vcpu *vcpu, unsigned int idx)
> >>>>
> >>>>           idx &=3D ~(3u << 30);
> >>>>
> >>>> +       if (fixed && !fixed_ctr_is_supported(pmu, idx))
> >>>> +               return false;
> >>>> +
> >>>>           return fixed ? idx < pmu->nr_arch_fixed_counters
> >>>>                        : idx < pmu->nr_arch_gp_counters;
> >>>>    }
> >>>> @@ -145,7 +151,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(st=
ruct kvm_vcpu *vcpu,
> >>>>                   counters =3D pmu->gp_counters;
> >>>>                   num_counters =3D pmu->nr_arch_gp_counters;
> >>>>           }
> >>>> -       if (idx >=3D num_counters)
> >>>> +       if (idx >=3D num_counters || (fixed && !fixed_ctr_is_support=
ed(pmu, idx)))
> >>>>                   return NULL;
> >>>>           *mask &=3D pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KV=
M_PMC_GP];
> >>>>           return &counters[array_index_nospec(idx, num_counters)];
> >>>> @@ -500,6 +506,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_=
pmu *pmu)
> >>>>           int i;
> >>>>
> >>>>           for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >>>> +               if (!fixed_ctr_is_supported(pmu, i))
> >>>> +                       continue;
> >>>> +
> >>>>                   pmc =3D &pmu->fixed_counters[i];
> >>>>                   event =3D fixed_pmc_events[array_index_nospec(i, s=
ize)];
> >>>>                   pmc->eventsel =3D (intel_arch_events[event].unit_m=
ask << 8) |
> >>>> @@ -520,6 +529,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *v=
cpu)
> >>>>
> >>>>           pmu->nr_arch_gp_counters =3D 0;
> >>>>           pmu->nr_arch_fixed_counters =3D 0;
> >>>> +       bitmap_zero(pmu->supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED)=
;
> >>>>           pmu->counter_bitmask[KVM_PMC_GP] =3D 0;
> >>>>           pmu->counter_bitmask[KVM_PMC_FIXED] =3D 0;
> >>>>           pmu->version =3D 0;
> >>>> @@ -551,13 +561,24 @@ static void intel_pmu_refresh(struct kvm_vcpu =
*vcpu)
> >>>>           pmu->available_event_types =3D ~entry->ebx &
> >>>>                                           ((1ull << eax.split.mask_l=
ength) - 1);
> >>>>
> >>>> -       if (pmu->version =3D=3D 1) {
> >>>> -               pmu->nr_arch_fixed_counters =3D 0;
> >>>> -       } else {
> >>>> +       counter_mask =3D ~(BIT_ULL(pmu->nr_arch_gp_counters) - 1);
> >>>> +       bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counte=
rs);
> >>>> +
> >>>> +       if (pmu->version > 1) {
> >>>>                   pmu->nr_arch_fixed_counters =3D
> >>>> -                       min3(ARRAY_SIZE(fixed_pmc_events),
> >>>> -                            (size_t) edx.split.num_counters_fixed,
> >>>> -                            (size_t)kvm_pmu_cap.num_counters_fixed)=
;
> >>>> +                       min_t(int, ARRAY_SIZE(fixed_pmc_events),
> >>>> +                             kvm_pmu_cap.num_counters_fixed);
> >>>> +               for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) =
{
> >>>> +                       /* FxCtr[i]_is_supported :=3D CPUID.0xA.ECX[=
i] || (EDX[4:0] > i) */
> >>>
> >>> This is true only when pmu->version >=3D 5.
> >>
> >> This is true in for "Version 5" section, but not mentioned in the CPUI=
D.0xA section.
> >> I would argue that this is a deliberate omission for the instruction i=
mplementation,
> >> as it does use the word "version>1" in the near CPUID.0xA.EDX section.
> >
> > Do you have any evidence to support such an argument? The CPUID field
> > in question was not defined prior to PMU version 5. (Does anyone from
> > Intel want to chime in?)
> >
> >> For virtualised use, this feature offers a kind of flexibility as user=
s can
> >> enable part of
> >> the fixed counters, don't you think? Or maybe you're more looking forw=
ard to the
> >> patch set that raises the vPMU version number from 2 to 5, that part o=
f the code
> >> was already in my tree some years ago.
> >
> > I would not be surprised if a guest OS checked for PMU version 5
> > before consulting the CPUID fields defined in PMU version 5. Does
> > Linux even consult the fixed counter bitmask field today?
>
> Yes, this is how host perf developer do it:
>
>         if (version >=3D 5)
>                 x86_pmu.num_counters_fixed =3D fls(fixed_mask);
>
> based on real fresh hardware (always marked as the latest version).
>
> However, our KVM players can construct different valid CPUIDs, as long as=
 the
> hardware is capable,
> to emulate some vPMU devices that match the CPUID semantics but do not ex=
ist in
> the real world.
>
> In the virtualisation world, use cases like "version 2 + fixed ctrs bit m=
ask"
> are perfectly possible
> and should work as expected. One more case, if the forth fixed counter or=
 more
> is enabled in your guest for top-down feature and you may still find the =
guest's
> pmu version number is stuck at 2.
> This naturally does not occur in real hardware but no CPUID semantics her=
e are
> broken.

This is completely irrelevant to the current discussion. Nowhere is it
documented that the number of fixed counters has a specific value for
any given PMU version. However, it *is* documented that the fixed
counter availability bitmask is introduced in PMU version 5. Surely,
you understand the difference.

> As I'm sure you've noticed, the logical relationship between CPUID.0xA.EC=
X and
> PMU version 5
> is necessary but not sufficient. Version 5 mush has fixed counters bit ma=
sk but
> the reverse is not true.

The reverse most certainly is true. You are, as is your wont, making
stuff up again.

>  From the end user's point of view, destroying the flexibility of vHW
> combinations is a design failure.
>
> So I think we can implement this feature in guest version 2, what do you =
think ?

How does the userspace VMM query the capability? Certainly, if
KVM_GET_SUPPORTED_CPUID returns a PMU version >=3D 5, then this bitmap
is supported. But for PMU version 2, up until now, the bitmap has not
been supported.

And do you expect the guest OS to check for the HYPERVISOR bit and the
KVMKVMKVM signature to determine whether or not this bitmap is
meaningful for PMU versions < 5?

> >
> > I'd love to see KVM virtualize PMU version 5!
>
> Great, I've got you and my plan will cover it.
>
> >
> >>>
> >>>   From the SDM, volume 3, section 20.2.5 Architectural Performance
> >>> Monitoring Version 5:
> >>>
> >>> With Architectural Performance Monitoring Version 5, register
> >>> CPUID.0AH.ECX indicates Fixed Counter enumeration. It is a bit mask
> >>> which enumerates the supported Fixed Counters in a processor. If bit
> >>> 'i' is set, it implies that Fixed Counter 'i' is supported. Software
> >>> is recommended to use the following logic to check if a Fixed Counter
> >>> is supported on a given processor: FxCtr[i]_is_supported :=3D ECX[i] =
||
> >>> (EDX[4:0] > i);
> >>>
> >>> Prior to PMU version 5, all fixed counters from 0 through <number of
> >>> fixed counters - 1> are supported.
> >>>
> >>>> +                       if (!(entry->ecx & BIT_ULL(i) ||
> >>>> +                             edx.split.num_counters_fixed > i))
> >>>> +                               continue;
> >>>> +
> >>>> +                       set_bit(i, pmu->supported_fixed_pmc_idx);
> >>>> +                       set_bit(INTEL_PMC_MAX_GENERIC + i, pmu->all_=
valid_pmc_idx);
> >>>> +                       pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i=
 * 4));
> >>>> +                       counter_mask &=3D ~BIT_ULL(INTEL_PMC_MAX_GEN=
ERIC + i);
> >>>> +               }
> >>>>                   edx.split.bit_width_fixed =3D min_t(int, edx.split=
.bit_width_fixed,
> >>>>                                                     kvm_pmu_cap.bit_=
width_fixed);
> >>>>                   pmu->counter_bitmask[KVM_PMC_FIXED] =3D
> >>>> @@ -565,10 +586,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *=
vcpu)
> >>>>                   setup_fixed_pmc_eventsel(pmu);
> >>>>           }
> >>>>
> >>>> -       for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++)
> >>>> -               pmu->fixed_ctr_ctrl_mask &=3D ~(0xbull << (i * 4));
> >>>> -       counter_mask =3D ~(((1ull << pmu->nr_arch_gp_counters) - 1) =
|
> >>>> -               (((1ull << pmu->nr_arch_fixed_counters) - 1) << INTE=
L_PMC_IDX_FIXED));
> >>>>           pmu->global_ctrl_mask =3D counter_mask;
> >>>>           pmu->global_ovf_ctrl_mask =3D pmu->global_ctrl_mask
> >>>>                           & ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF =
|
> >>>> @@ -585,11 +602,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *=
vcpu)
> >>>>                   pmu->raw_event_mask |=3D (HSW_IN_TX|HSW_IN_TX_CHEC=
KPOINTED);
> >>>>           }
> >>>>
> >>>> -       bitmap_set(pmu->all_valid_pmc_idx,
> >>>> -               0, pmu->nr_arch_gp_counters);
> >>>> -       bitmap_set(pmu->all_valid_pmc_idx,
> >>>> -               INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
> >>>> -
> >>>>           perf_capabilities =3D vcpu_get_perf_capabilities(vcpu);
> >>>>           if (cpuid_model_is_consistent(vcpu) &&
> >>>>               (perf_capabilities & PMU_CAP_LBR_FMT))
> >>>> @@ -605,6 +617,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *v=
cpu)
> >>>>                           pmu->pebs_enable_mask =3D counter_mask;
> >>>>                           pmu->reserved_bits &=3D ~ICL_EVENTSEL_ADAP=
TIVE;
> >>>>                           for (i =3D 0; i < pmu->nr_arch_fixed_count=
ers; i++) {
> >>>> +                               if (!fixed_ctr_is_supported(pmu, i))
> >>>> +                                       continue;
> >>>> +
> >>>>                                   pmu->fixed_ctr_ctrl_mask &=3D
> >>>>                                           ~(1ULL << (INTEL_PMC_IDX_F=
IXED + i * 4));
> >>>>                           }
> >>>>
> >>>> base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
> >>>> --
> >>>> 2.40.0
> >>>>
