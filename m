Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E89C4F8644
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiDGRe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346701AbiDGRcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:32:46 -0400
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F225C377E3
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 10:29:43 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id r5so1045479ybd.8
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 10:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UxIETUQzLj37YwcaDZgtW+hcuSBKPfQz6PFagx/GWec=;
        b=jx6hFftNkSDIgg/vhatmPk581BTPgc4Z2bVFL2hZM35yMA/6phrtV3a77jIlt3g9sa
         HxjpFdidZJCnMaV8FlWpD7GXm0qonhfYapuOX1PFemdqwOaJJz7IJ33onFF4IqFXfUtV
         r7w1hiLq8WGo33PQHCTmCyFNimADwCkhWZWKmTEoqSp1s0mZfSknBcbOhyslzigIgXtk
         +J4S9QOb/fm2nx7uH8x8dEDzWWt+CRnKKK83ZGRxmkJjd0zVDtVF6tP/XsFFKLt80S0V
         Qdps5lhDc9eIFEnkoyPSMcolAFTVowTMc4gfu9vEwDux3rtcM/uGHK1mIZ0B7qBhbZSB
         BBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UxIETUQzLj37YwcaDZgtW+hcuSBKPfQz6PFagx/GWec=;
        b=KrmnB15CjhTmXRiPTfs4OxS9RblCvFT9xGH+LnXdha7y/7Z2GkryCekf1AZtgbQqiE
         MtbUn3ikBiWigSHE7Txtu5WfFS3PI5npPgfXx5yOrhrgeP/42krc+Hbvpp8fjQ2832a1
         31piTu0AhcarIULIvai+YdOyQpSdj6wT9ra6ZD0QjIoQHzdgwNfJNLqj7GD3amXrY4y0
         uk5cVvWcjzPKHDpK8ZV4eq/CyplemNgWFHzfpSQPfL2bGHKgMtUFyPddcwqMPX21Zhet
         HCULJOJecqm/nol1XRpqcyBNpXPMvJYL/Nm1MMBG0aiYu+CZMY5uOcwTUx47QiSdxEtd
         mdnw==
X-Gm-Message-State: AOAM532QjcJWNYdcqyz8FBwDBtsHnYfe9fn6Ik5aXtC02q+GRQ2BpaBV
        pIqTpDuOybB+53wryXapG/+URrrUQ49MQeh/YY9wxA==
X-Google-Smtp-Source: ABdhPJzfhzd2NzheiN7g3GpSyicX10ZkSc4FOQDTeaDcZjxlW2Oum8i3jlXwh5rxjLaoD+xGu2M27UnuG3Kz3EIMUu0=
X-Received: by 2002:a25:8a0c:0:b0:63d:d026:ebaa with SMTP id
 g12-20020a258a0c000000b0063dd026ebaamr10066668ybl.509.1649352265166; Thu, 07
 Apr 2022 10:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com> <20220407011605.1966778-3-rananta@google.com>
 <87ilrlb6un.wl-maz@kernel.org>
In-Reply-To: <87ilrlb6un.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 7 Apr 2022 10:24:14 -0700
Message-ID: <CAJHc60yFD=osoifUpB4LBNo93eVq9zNV41bnu7uBZ0HsBGbMeA@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Apr 7, 2022 at 2:07 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Raghavendra,
>
> On Thu, 07 Apr 2022 02:15:57 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > KVM regularly introduces new hypercall services to the guests without
> > any consent from the userspace. This means, the guests can observe
> > hypercall services in and out as they migrate across various host
> > kernel versions. This could be a major problem if the guest
> > discovered a hypercall, started using it, and after getting migrated
> > to an older kernel realizes that it's no longer available. Depending
> > on how the guest handles the change, there's a potential chance that
> > the guest would just panic.
> >
> > As a result, there's a need for the userspace to elect the services
> > that it wishes the guest to discover. It can elect these services
> > based on the kernels spread across its (migration) fleet. To remedy
> > this, extend the existing firmware psuedo-registers, such as
>
> nit: pseudo
>
> > KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
> > for all the hypercall services available.
> >
> > These firmware registers are categorized based on the service call
> > owners, but unlike the existing firmware psuedo-registers, they hold
>
> nit: pseudo again
>
> > the features supported in the form of a bitmap.
> >
> > During the VM initialization, the registers are set to upper-limit of
> > the features supported by the corresponding registers. It's expected
> > that the VMMs discover the features provided by each register via
> > GET_ONE_REG, and writeback the desired values using SET_ONE_REG.
>
> nit: write back
>
> > KVM allows this modification only until the VM has started.
> >
> > Some of the standard features are not mapped to any bits of the
> > registers. But since they can recreate the original problem of
> > making it available without userspace's consent, they need to
> > be explicitly added to the hvc_func_default_allowed_list[]. Any
> > function-id that's not enabled via the bitmap, or not listed in
> > hvc_func_default_allowed_list[], will be returned as
> > SMCCC_RET_NOT_SUPPORTED to the guest.
> >
> > Older userspace code can simply ignore the feature and the
> > hypercall services will be exposed unconditionally to the guests,
> > thus ensuring backward compatibility.
> >
> > In this patch, the framework adds the register only for ARM's standard
> > secure services (owner value 4). Currently, this includes support only
> > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > register representing mandatory features of v1.0. Other services are
> > momentarily added in the upcoming patches.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  12 ++++
> >  arch/arm64/include/uapi/asm/kvm.h |   9 +++
> >  arch/arm64/kvm/arm.c              |   1 +
> >  arch/arm64/kvm/guest.c            |   8 ++-
> >  arch/arm64/kvm/hypercalls.c       | 102 ++++++++++++++++++++++++++++++
> >  include/kvm/arm_hypercalls.h      |   7 ++
> >  include/kvm/arm_psci.h            |  12 ++++
> >  7 files changed, 149 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index e3b25dc6c367..6e663383d7b4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +/**
> > + * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
> > + *
> > + * @std_bmap: Bitmap of standard secure service calls
> > + */
> > +struct kvm_smccc_features {
> > +     u64 std_bmap;
>
> Consider using 'unsigned long' for bitmaps.
>
Sure.

> > +};
> > +
> >  struct kvm_arch {
> >       struct kvm_s2_mmu mmu;
> >
> > @@ -140,6 +149,9 @@ struct kvm_arch {
> >
> >       u8 pfr0_csv2;
> >       u8 pfr0_csv3;
> > +
> > +     /* Hypercall features firmware registers' descriptor */
> > +     struct kvm_smccc_features smccc_feat;
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index c1b6ddc02d2f..56e4bc58a355 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_ARM64_SVE_VLS_WORDS      \
> >       ((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> >
> > +/* Bitmap feature firmware registers */
> > +#define KVM_REG_ARM_FW_FEAT_BMAP             (0x0016 << KVM_REG_ARM_COPROC_SHIFT)
> > +#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)              (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> > +                                             KVM_REG_ARM_FW_FEAT_BMAP |      \
> > +                                             ((r) & 0xffff))
> > +
> > +#define KVM_REG_ARM_STD_BMAP                 KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
> > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0                BIT(0)
>
> I'm really in two minds about this. Having one bit per service is easy
> from an implementation perspective, but is also means that this
> disallow fine grained control over which hypercalls are actually
> available. If tomorrow TRNG 1.1 adds a new hypercall and that KVM
> implements both, how does the selection mechanism works? You will
> need a version selector (a la PSCI), which defeats this API somehow
> (and renders the name of the #define invalid).
>
> I wonder if a more correct way to look at this is to enumerate the
> hypercalls themselves (all 5 of them), though coming up with an
> encoding is tricky (RNG32 and RNG64 would clash, for example).
>
> Thoughts?
>
I was on the fence about this too. The TRNG spec (ARM DEN 0098,
Table-4) mentions that v1.0 should have VERSION, FEATURES, GET_UUID,
and RND as mandatory features. Hence, if KVM advertised that it
supports TRNG v1.0, I thought it would be best to expose all or
nothing of v1.0 by guarding them with a single bit.
Broadly, the idea is to have a bit per version. If v1.1 comes along,
we can have another bit for that. If it's not too ugly to implement,
we can be a little more aggressive and ensure that userspace doesn't
enable v1.1 without enabling v1.0.

> > +
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR    0
> >  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS       1
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 523bc934fe2f..a37fadbd617e 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >       kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> >
> >       set_default_spectre(kvm);
> > +     kvm_arm_init_hypercalls(kvm);
> >
> >       return ret;
> >  out_free_stage2_pgd:
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 0d5cca56cbda..8c607199cad1 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >
> >       switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> >       case KVM_REG_ARM_CORE:  return get_core_reg(vcpu, reg);
> > -     case KVM_REG_ARM_FW:    return kvm_arm_get_fw_reg(vcpu, reg);
> > +     case KVM_REG_ARM_FW:
> > +     case KVM_REG_ARM_FW_FEAT_BMAP:
> > +             return kvm_arm_get_fw_reg(vcpu, reg);
> >       case KVM_REG_ARM64_SVE: return get_sve_reg(vcpu, reg);
> >       }
> >
> > @@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >
> >       switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> >       case KVM_REG_ARM_CORE:  return set_core_reg(vcpu, reg);
> > -     case KVM_REG_ARM_FW:    return kvm_arm_set_fw_reg(vcpu, reg);
> > +     case KVM_REG_ARM_FW:
> > +     case KVM_REG_ARM_FW_FEAT_BMAP:
> > +             return kvm_arm_set_fw_reg(vcpu, reg);
> >       case KVM_REG_ARM64_SVE: return set_sve_reg(vcpu, reg);
> >       }
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index fa6d9378d8e7..cf04b5ee5f56 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -58,6 +58,53 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> >       val[3] = lower_32_bits(cycles);
> >  }
> >
> > +/*
> > + * List of function-ids that are not gated with the bitmapped feature
> > + * firmware registers, and are to be allowed for servicing the call by default.
> > + */
> > +static const u32 hvc_func_default_allowed_list[] = {
> > +     ARM_SMCCC_VERSION_FUNC_ID,
> > +     ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> > +     ARM_SMCCC_HV_PV_TIME_FEATURES,
> > +     ARM_SMCCC_HV_PV_TIME_ST,
> > +     ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
> > +     ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
> > +     ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> > +};
> > +
> > +static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +     unsigned int i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(hvc_func_default_allowed_list); i++)
> > +             if (func_id == hvc_func_default_allowed_list[i])
> > +                     return true;
>
> Huh, this really is ugly. This array is bound to become bigger over
> time, meaning that the average hypercall time is going to increase. At
> the very least, this should be turned into a switch/case statement, as
> the compile is pretty good at building a search tree (better than this
> naive loop, for a start), and we have those everywhere else.
>
Makes sense. I'll make it a switch-case.

> > +
> > +     return kvm_psci_func_id_is_valid(vcpu, func_id);
> > +}
> > +
> > +static bool kvm_arm_fw_reg_feat_enabled(u64 reg_bmap, u64 feat_bit)
> > +{
> > +     return reg_bmap & feat_bit;
> > +}
>
> We really don't need to reimplement test_bit().
>
Right, I forgot about test_bit() :)

> > +
> > +static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +     struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> > +
> > +     switch (func_id) {
> > +     case ARM_SMCCC_TRNG_VERSION:
> > +     case ARM_SMCCC_TRNG_FEATURES:
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +     case ARM_SMCCC_TRNG_RND32:
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_bmap,
> > +                                             KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> > +     default:
> > +             return kvm_hvc_call_default_allowed(vcpu, func_id);
> > +     }
> > +}
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  {
> >       u32 func_id = smccc_get_function(vcpu);
> > @@ -65,6 +112,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >       u32 feature;
> >       gpa_t gpa;
> >
> > +     if (!kvm_hvc_call_allowed(vcpu, func_id))
> > +             goto out;
> > +
> >       switch (func_id) {
> >       case ARM_SMCCC_VERSION_FUNC_ID:
> >               val[0] = ARM_SMCCC_VERSION_1_1;
> > @@ -155,6 +205,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               return kvm_psci_call(vcpu);
> >       }
> >
> > +out:
> >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >       return 1;
> >  }
> > @@ -164,8 +215,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> > +     KVM_REG_ARM_STD_BMAP,
> >  };
> >
> > +void kvm_arm_init_hypercalls(struct kvm *kvm)
> > +{
> > +     struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> > +
> > +     smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> > +}
> > +
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> >  {
> >       return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> > @@ -237,6 +296,7 @@ static int get_kernel_wa_level(u64 regid)
> >
> >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> > +     struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> >       void __user *uaddr = (void __user *)(long)reg->addr;
> >       u64 val;
> >
> > @@ -249,6 +309,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> >               val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> >               break;
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             val = READ_ONCE(smccc_feat->std_bmap);
> > +             break;
> >       default:
> >               return -ENOENT;
> >       }
> > @@ -259,6 +322,43 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       return 0;
> >  }
> >
> > +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> > +{
> > +     int ret = 0;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> > +     u64 *fw_reg_bmap, fw_reg_features;
> > +
> > +     switch (reg_id) {
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             fw_reg_bmap = &smccc_feat->std_bmap;
> > +             fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
> > +             break;
> > +     default:
> > +             return -ENOENT;
> > +     }
> > +
> > +     /* Check for unsupported bit */
> > +     if (val & ~fw_reg_features)
> > +             return -EINVAL;
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     /*
> > +      * If the VM (any vCPU) has already started running, return success
> > +      * if there's no change in the value. Else, return -EBUSY.
>
> No, this should *always* fail if a vcpu has started. Otherwise, you
> start allowing hard to spot races.
>
The idea came from the fact that userspace could spawn multiple
threads to configure the vCPU registers. Since we don't have the
VM-scoped registers yet, it may be possible that userspace has issued
a KVM_RUN on one of the vCPU, while the others are lagging behind and
still configuring the registers. The slower threads may see -EBUSY and
could panic. But if you feel that it's an overkill and the userspace
should deal with it, we can return EBUSY for all writes after KVM_RUN.

> > +      */
> > +     if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> > +             ret = *fw_reg_bmap != val ? -EBUSY : 0;
> > +             goto out;
> > +     }
> > +
> > +     WRITE_ONCE(*fw_reg_bmap, val);
>
> I'm not sure what this WRITE_ONCE guards against. Do you expect
> concurrent reads at this stage?
>
Again, the assumption here is that userspace could have multiple
threads reading and writing to these registers. Without the VM scoped
registers in place, we may end up with a read/write to the same memory
location for all the vCPUs.

> > +out:
> > +     mutex_unlock(&kvm->lock);
> > +     return ret;
> > +}
> > +
> >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >       void __user *uaddr = (void __user *)(long)reg->addr;
> > @@ -337,6 +437,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >                       return -EINVAL;
> >
> >               return 0;
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> >       default:
> >               return -ENOENT;
> >       }
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index 5d38628a8d04..fd3ff350ee9d 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -6,6 +6,12 @@
> >
> >  #include <asm/kvm_emulate.h>
> >
> > +/* Last valid bits of the bitmapped firmware registers */
> > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX         0
> > +
> > +#define KVM_ARM_SMCCC_STD_FEATURES \
> > +     GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > @@ -42,6 +48,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
> >
> >  struct kvm_one_reg;
> >
> > +void kvm_arm_init_hypercalls(struct kvm *kvm);
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > index 6e55b9283789..d7a87367de56 100644
> > --- a/include/kvm/arm_psci.h
> > +++ b/include/kvm/arm_psci.h
> > @@ -36,6 +36,18 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
> >       return KVM_ARM_PSCI_0_1;
> >  }
> >
> > +static inline bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +     /* PSCI 0.1 doesn't comply with the standard SMCCC */
> > +     if (kvm_psci_version(vcpu) == KVM_ARM_PSCI_0_1)
> > +             return (func_id == KVM_PSCI_FN_CPU_OFF || func_id == KVM_PSCI_FN_CPU_ON);
> > +
> > +     if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
> > +             ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
> > +             return true;
> > +
> > +     return false;
> > +}
>
> Why the inline function? Do you expect this to be shared with
> something else? If not, I'd rather you move it into the caller.
>
Well, no plans to share as of yet. Will move it to psci.c

> >
> >  int kvm_psci_call(struct kvm_vcpu *vcpu);
> >
>

Thanks for the review, Marc. I'll fix all the other nits.

Regards,
Raghavendra

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
