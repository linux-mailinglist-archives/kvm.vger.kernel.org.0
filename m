Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E46250E61F
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 18:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbiDYQuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 12:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiDYQuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 12:50:01 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7EF1EAC3
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:46:52 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2ec42eae76bso154727617b3.10
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L9fGRxhawFdrYhsvhwooo+YGdA+UoOp4ka5tzN6FrdA=;
        b=rWv768on9ODCP4EKdGlwSHlk03bmBcRKodtSujHfAGgLSCu7Zu8WSEMo6X9d91zlhv
         kGYDzlPkX/UNxpufz4xZWRrG8AreRvtN/bFXOcp/TIAM0Tse9JTAhjAzTQjHkHXbWgOB
         /gtGLI2BtSuciHqL/g0o2zVHuHLjJwtA/Lu8tSxzSj39r8SgEhvXQLwJZvRk8lYSn7aY
         W6OcIuQBfAdSrzKqjg6aCPiEs/NDirxbJftgPjDyeyYaP4MjiUjAEUXCBUB2hJXmNm9h
         80vupDfFqnYKhMbXfAUeDYzyku7Nm7m5gSBTkZoUO9bdG9qNM980fFjMkqk6vQtLZL5Z
         gCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L9fGRxhawFdrYhsvhwooo+YGdA+UoOp4ka5tzN6FrdA=;
        b=jVYBVcP6xW/HLH5em+jlZ71ik5HXibh/lPzQo4ywdzTtVphQhPwQy9cE/FsRu5dOXf
         d4sb+wHbE+CX7sM0Qb0BarHrTUlkFm6nP23UnRVgcC86iMFJ/aDRLHoMk0ZuhndK3yze
         zua6pyvAl+iqkG5PB6fSRFtG78krE0gVV40na5Z3pmwS60oLJ4UpAhiEx74+i9lCu868
         MC8O2zzHCkltdyzhRZesZHgH0gmDtGGjAeUL0wZk3EwKcXodH2PyByUzpVsFtCHQTI5C
         K5QnBI1kCtIeWOSn9VoG+oQ9OSFqEnWBGUDgAKzr4nAWUbNex5Ccd6ZpeOvxuG8X2QD+
         Q+ag==
X-Gm-Message-State: AOAM531a7Adj6GiqHJgJbMthFyPjGQvOUNnfYwO4CGU03ySmx/iY5PHL
        EAi72AMqAtMVCQeJIGidMsjf2AWSRy+6X7GRvCCXZg==
X-Google-Smtp-Source: ABdhPJw6YZ3UGXMavJ0ODMg9iXmYc7V1/rYq9U85PrmDkyUCFCKrbcZnj9TodTTttP0/N58ZN9/6FPnkTk5e8E8/ki4=
X-Received: by 2002:a81:d12:0:b0:2f4:e6c6:9caf with SMTP id
 18-20020a810d12000000b002f4e6c69cafmr16175400ywn.91.1650905211186; Mon, 25
 Apr 2022 09:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-3-rananta@google.com>
 <CAAeT=Fyv2Hc1oPb=UiDUvCSpzS9iYbEPBCvXuskBniTcOKfA5g@mail.gmail.com>
In-Reply-To: <CAAeT=Fyv2Hc1oPb=UiDUvCSpzS9iYbEPBCvXuskBniTcOKfA5g@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 25 Apr 2022 09:46:40 -0700
Message-ID: <CAJHc60z3kiQMkdj4wQ2ixmd-MaA5bQT0SwDQYcUbACMaAOWrSg@mail.gmail.com>
Subject: Re: [PATCH v6 2/9] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

Hi Reiji,

On Sun, Apr 24, 2022 at 9:52 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
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
> > this, extend the existing firmware pseudo-registers, such as
> > KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
> > for all the hypercall services available.
> >
> > These firmware registers are categorized based on the service call
> > owners, but unlike the existing firmware pseudo-registers, they hold
> > the features supported in the form of a bitmap.
> >
> > During the VM initialization, the registers are set to upper-limit of
> > the features supported by the corresponding registers. It's expected
> > that the VMMs discover the features provided by each register via
> > GET_ONE_REG, and write back the desired values using SET_ONE_REG.
> > KVM allows this modification only until the VM has started.
> >
> > Some of the standard features are not mapped to any bits of the
> > registers. But since they can recreate the original problem of
> > making it available without userspace's consent, they need to
> > be explicitly added to the case-list in
> > kvm_hvc_call_default_allowed(). Any function-id that's not enabled
> > via the bitmap, or not listed in kvm_hvc_call_default_allowed, will
> > be returned as SMCCC_RET_NOT_SUPPORTED to the guest.
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
> >  arch/arm64/include/asm/kvm_host.h | 12 ++++
> >  arch/arm64/include/uapi/asm/kvm.h |  9 +++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/guest.c            |  8 ++-
> >  arch/arm64/kvm/hypercalls.c       | 94 +++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/psci.c             | 13 +++++
> >  include/kvm/arm_hypercalls.h      |  6 ++
> >  include/kvm/arm_psci.h            |  2 +-
> >  8 files changed, 142 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 94a27a7520f4..df07f4c10197 100644
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
> > +       unsigned long std_bmap;
> > +};
> > +
> >  struct kvm_arch {
> >         struct kvm_s2_mmu mmu;
> >
> > @@ -150,6 +159,9 @@ struct kvm_arch {
> >
> >         u8 pfr0_csv2;
> >         u8 pfr0_csv3;
> > +
> > +       /* Hypercall features firmware registers' descriptor */
> > +       struct kvm_smccc_features smccc_feat;
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index c1b6ddc02d2f..0b79d2dc6ffd 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_ARM64_SVE_VLS_WORDS        \
> >         ((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
> >
> > +/* Bitmap feature firmware registers */
> > +#define KVM_REG_ARM_FW_FEAT_BMAP               (0x0016 << KVM_REG_ARM_COPROC_SHIFT)
> > +#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)                (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> > +                                               KVM_REG_ARM_FW_FEAT_BMAP |      \
> > +                                               ((r) & 0xffff))
> > +
> > +#define KVM_REG_ARM_STD_BMAP                   KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
> > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0          0
> > +
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR      0
> >  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 523bc934fe2f..a37fadbd617e 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >         kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> >
> >         set_default_spectre(kvm);
> > +       kvm_arm_init_hypercalls(kvm);
> >
> >         return ret;
> >  out_free_stage2_pgd:
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 0d5cca56cbda..8c607199cad1 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >
> >         switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> >         case KVM_REG_ARM_CORE:  return get_core_reg(vcpu, reg);
> > -       case KVM_REG_ARM_FW:    return kvm_arm_get_fw_reg(vcpu, reg);
> > +       case KVM_REG_ARM_FW:
> > +       case KVM_REG_ARM_FW_FEAT_BMAP:
> > +               return kvm_arm_get_fw_reg(vcpu, reg);
> >         case KVM_REG_ARM64_SVE: return get_sve_reg(vcpu, reg);
> >         }
> >
> > @@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >
> >         switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
> >         case KVM_REG_ARM_CORE:  return set_core_reg(vcpu, reg);
> > -       case KVM_REG_ARM_FW:    return kvm_arm_set_fw_reg(vcpu, reg);
> > +       case KVM_REG_ARM_FW:
> > +       case KVM_REG_ARM_FW_FEAT_BMAP:
> > +               return kvm_arm_set_fw_reg(vcpu, reg);
> >         case KVM_REG_ARM64_SVE: return set_sve_reg(vcpu, reg);
> >         }
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index fa6d9378d8e7..df55a04d2fe8 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -58,6 +58,48 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> >         val[3] = lower_32_bits(cycles);
> >  }
> >
> > +static bool kvm_arm_fw_reg_feat_enabled(unsigned long *reg_bmap, unsigned long feat_bit)
> > +{
> > +       return test_bit(feat_bit, reg_bmap);
> > +}
> > +
> > +static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +       switch (func_id) {
> > +       /*
> > +        * List of function-ids that are not gated with the bitmapped feature
> > +        * firmware registers, and are to be allowed for servicing the call by default.
> > +        */
> > +       case ARM_SMCCC_VERSION_FUNC_ID:
> > +       case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +       case ARM_SMCCC_HV_PV_TIME_FEATURES:
> > +       case ARM_SMCCC_HV_PV_TIME_ST:
> > +       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > +       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > +       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +               return true;
> > +       default:
> > +               return kvm_psci_func_id_is_valid(vcpu, func_id);
> > +       }
> > +}
> > +
> > +static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +       struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> > +
> > +       switch (func_id) {
> > +       case ARM_SMCCC_TRNG_VERSION:
> > +       case ARM_SMCCC_TRNG_FEATURES:
> > +       case ARM_SMCCC_TRNG_GET_UUID:
> > +       case ARM_SMCCC_TRNG_RND32:
> > +       case ARM_SMCCC_TRNG_RND64:
> > +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
> > +                                               KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> > +       default:
> > +               return kvm_hvc_call_default_allowed(vcpu, func_id);
> > +       }
> > +}
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  {
> >         u32 func_id = smccc_get_function(vcpu);
> > @@ -65,6 +107,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >         u32 feature;
> >         gpa_t gpa;
> >
> > +       if (!kvm_hvc_call_allowed(vcpu, func_id))
> > +               goto out;
> > +
> >         switch (func_id) {
> >         case ARM_SMCCC_VERSION_FUNC_ID:
> >                 val[0] = ARM_SMCCC_VERSION_1_1;
> > @@ -155,6 +200,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >                 return kvm_psci_call(vcpu);
> >         }
> >
> > +out:
> >         smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >         return 1;
> >  }
> > @@ -164,8 +210,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> > +       KVM_REG_ARM_STD_BMAP,
> >  };
> >
> > +void kvm_arm_init_hypercalls(struct kvm *kvm)
> > +{
> > +       struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> > +
> > +       smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> > +}
> > +
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> >  {
> >         return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> > @@ -237,6 +291,7 @@ static int get_kernel_wa_level(u64 regid)
> >
> >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> > +       struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> >         void __user *uaddr = (void __user *)(long)reg->addr;
> >         u64 val;
> >
> > @@ -249,6 +304,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >         case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> >                 val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> >                 break;
> > +       case KVM_REG_ARM_STD_BMAP:
> > +               val = READ_ONCE(smccc_feat->std_bmap);
> > +               break;
> >         default:
> >                 return -ENOENT;
> >         }
> > @@ -259,6 +317,40 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >         return 0;
> >  }
> >
> > +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> > +{
> > +       int ret = 0;
> > +       struct kvm *kvm = vcpu->kvm;
> > +       struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> > +       unsigned long *fw_reg_bmap, fw_reg_features;
> > +
> > +       switch (reg_id) {
> > +       case KVM_REG_ARM_STD_BMAP:
> > +               fw_reg_bmap = &smccc_feat->std_bmap;
> > +               fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
> > +               break;
> > +       default:
> > +               return -ENOENT;
> > +       }
> > +
> > +       /* Check for unsupported bit */
> > +       if (val & ~fw_reg_features)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&kvm->lock);
>
> Why don't you check if the register value will be modified before
> getting the lock ? (then there is nothing to do)
> It would help reduce unnecessary serialization for live migration
> (even without the vm-scoped register capability).
>
That was the case until v5. Since v6, we return -EBUSY unconditionally
regardless of the incoming value. See Marc's comments in [1].
>
>
> > +
> > +       /* Return -EBUSY if the VM (any vCPU) has already started running. */
> > +       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> > +               ret = -EBUSY;
> > +               goto out;
> > +       }
>
> I just would like to make sure that you are sure that existing
> userspace you know will not run KVM_RUN for any vCPUs until
> KVM_SET_ONE_REG is complete for all vCPUs (even for migration),
> correct ?
>
Since v6, that is something that we are leaving with the userspace to
synchronize. See [1].
>
> > +
> > +       WRITE_ONCE(*fw_reg_bmap, val);
> > +out:
> > +       mutex_unlock(&kvm->lock);
> > +       return ret;
> > +}
> > +
> >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >         void __user *uaddr = (void __user *)(long)reg->addr;
> > @@ -337,6 +429,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >                         return -EINVAL;
> >
> >                 return 0;
> > +       case KVM_REG_ARM_STD_BMAP:
> > +               return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> >         default:
> >                 return -ENOENT;
> >         }
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 346535169faa..67d1273e8086 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -436,3 +436,16 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
> >                 return -EINVAL;
> >         }
> >  }
> > +
> > +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +       /* PSCI 0.1 doesn't comply with the standard SMCCC */
> > +       if (kvm_psci_version(vcpu) == KVM_ARM_PSCI_0_1)
> > +               return (func_id == KVM_PSCI_FN_CPU_OFF || func_id == KVM_PSCI_FN_CPU_ON);
> > +
> > +       if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
> > +               ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
> > +               return true;
>
> For PSCI 0.1, the function checks if the funct_id is valid for
> the vCPU (according to the vCPU's PSCI version).
> For other version of PSCI, the function doesn't care the vCPU's
> PSCI version (although supported functions depend on the PSCI
> version and not all of them are defined yet, the code returns
> true as long as the function id is within the reserved PSCI
> function id range).
> So, the behavior appears to be inconsistent.
> Shouldn't it return the validity of the function id according
> to the vCPU's psci version for non-PSCI 0.1 case as well ?
> (Otherwise, shouldn't it return true if the function id is valid
> for any of the PSCI versions ?)
>
Well, PSCI 1.0 is somewhat of an odd implementation. It doesn't comply
with the SMCCC, hence needed some special handling. Only two func_ids
are currently supported by KVM, and we just check for each. The second
'if' statement is for all the PSCI versions >= 0.2. Thankfully, the
specification defines a range of acceptable PSCI func_ids.

If it's confusing, I can add a comment above the second 'if' that it's
for all PSCI versions >= 0.2.
> Thanks,
> Reiji
>
Thank you.
Raghavendra

[1]: https://lore.kernel.org/lkml/87ilrlb6un.wl-maz@kernel.org/
>
>
> > +
> > +       return false;
> > +}
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index 5d38628a8d04..499b45b607b6 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -6,6 +6,11 @@
> >
> >  #include <asm/kvm_emulate.h>
> >
> > +/* Last valid bits of the bitmapped firmware registers */
> > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX           0
> > +
> > +#define KVM_ARM_SMCCC_STD_FEATURES             GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > @@ -42,6 +47,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
> >
> >  struct kvm_one_reg;
> >
> > +void kvm_arm_init_hypercalls(struct kvm *kvm);
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > index 6e55b9283789..c47be3e26965 100644
> > --- a/include/kvm/arm_psci.h
> > +++ b/include/kvm/arm_psci.h
> > @@ -36,7 +36,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
> >         return KVM_ARM_PSCI_0_1;
> >  }
> >
> > -
> >  int kvm_psci_call(struct kvm_vcpu *vcpu);
> > +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id);
> >
> >  #endif /* __KVM_ARM_PSCI_H__ */
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
