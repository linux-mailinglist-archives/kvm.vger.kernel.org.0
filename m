Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0F150D885
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 06:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbiDYE4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 00:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbiDYEz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 00:55:59 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16FE5E74E
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 21:52:54 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id r14-20020a9d750e000000b00605446d683eso10028259otk.10
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 21:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxr8P/8LYAjImRUJY9isuo5GyoJq9tiUp/5nOt8Z3Ko=;
        b=tQq4KslXbk4UqwnlJXx2G+rWNdJZduOq4oltSWaVFircBc6GW0cd1GS5NzKTIfzltG
         lNHlAIcMUPjrW/I7wuF4Qb1nRKwzOuVZpp6Fl0RqF1D6g2LE6VrqPxVmFFRQpexNz8H4
         QYuq29rSPqSz76IcY5hB9DuO+7kNNSOdXWDINUdX8Iak1i6JmbKf7cLVzuqk/5WrXOr1
         wxKIT/1EeUDQDJ5+3DaDeOgIaP3dBxCE+8yUkpiN1CIH4UysbNyBUF9zVX1FqJAfIvd+
         9xFExKheL8wFZ7u6IXvFxRQ9H1AHVRIidZqf00qgKoHkVFUn/Lqm64e/Hfh+jMT0dmiP
         13ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxr8P/8LYAjImRUJY9isuo5GyoJq9tiUp/5nOt8Z3Ko=;
        b=Ml+9/1d5o2jKuhA2AHIy3gP7Reu66XGBD4qQT65q+f2Ds3gcBTsNkzHnJwyjh08g14
         GiyYOERtr6Sr9QnmhjMgjm6B6VQvZsE44mYQOjcoP9R0XQocB4S2IcZFfzq1Fjv3WfwA
         w8NN4rpMUhDV7WQubD2tPYbPfmNR82lArU4NZ2GAJhkzMxH7c6RRQD0TGNnWhB8xl/4o
         U894llMUgLdzojIUNvhQIFrAl5KRFK4lfQtaIG7s7bz3r3F4Z/NEqNo4V5kYaZ5MHNtW
         irGOF1gPFO6a8gLPfjMzjunkgs95Yqdu+CqZBHjbFkicgA9iIi+KhjmW8X3Fvq/qgAMn
         U59A==
X-Gm-Message-State: AOAM532IUd3+W8LU+D3v8QCVB09TtZH7UOXlnARBzFYqoxnCDOwW8qM4
        Xbw8px6PN2Teh4o8l6/MZTW278IT32AN8CjCz9R4FA==
X-Google-Smtp-Source: ABdhPJzo13f47F8TfeyzclCIJeQ7/YIn41atGyvT5OinvOB8BhQb4008gvlcSoiB7RDWEuTgPv5gk0lNXAdL0S6QvYY=
X-Received: by 2002:a05:6830:18d:b0:605:4cfb:19cd with SMTP id
 q13-20020a056830018d00b006054cfb19cdmr5690723ota.177.1650862373909; Sun, 24
 Apr 2022 21:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-3-rananta@google.com>
In-Reply-To: <20220423000328.2103733-3-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 24 Apr 2022 21:52:38 -0700
Message-ID: <CAAeT=Fyv2Hc1oPb=UiDUvCSpzS9iYbEPBCvXuskBniTcOKfA5g@mail.gmail.com>
Subject: Re: [PATCH v6 2/9] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
To:     Raghavendra Rao Ananta <rananta@google.com>
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

Hi Raghu,

On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> KVM regularly introduces new hypercall services to the guests without
> any consent from the userspace. This means, the guests can observe
> hypercall services in and out as they migrate across various host
> kernel versions. This could be a major problem if the guest
> discovered a hypercall, started using it, and after getting migrated
> to an older kernel realizes that it's no longer available. Depending
> on how the guest handles the change, there's a potential chance that
> the guest would just panic.
>
> As a result, there's a need for the userspace to elect the services
> that it wishes the guest to discover. It can elect these services
> based on the kernels spread across its (migration) fleet. To remedy
> this, extend the existing firmware pseudo-registers, such as
> KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
> for all the hypercall services available.
>
> These firmware registers are categorized based on the service call
> owners, but unlike the existing firmware pseudo-registers, they hold
> the features supported in the form of a bitmap.
>
> During the VM initialization, the registers are set to upper-limit of
> the features supported by the corresponding registers. It's expected
> that the VMMs discover the features provided by each register via
> GET_ONE_REG, and write back the desired values using SET_ONE_REG.
> KVM allows this modification only until the VM has started.
>
> Some of the standard features are not mapped to any bits of the
> registers. But since they can recreate the original problem of
> making it available without userspace's consent, they need to
> be explicitly added to the case-list in
> kvm_hvc_call_default_allowed(). Any function-id that's not enabled
> via the bitmap, or not listed in kvm_hvc_call_default_allowed, will
> be returned as SMCCC_RET_NOT_SUPPORTED to the guest.
>
> Older userspace code can simply ignore the feature and the
> hypercall services will be exposed unconditionally to the guests,
> thus ensuring backward compatibility.
>
> In this patch, the framework adds the register only for ARM's standard
> secure services (owner value 4). Currently, this includes support only
> for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> register representing mandatory features of v1.0. Other services are
> momentarily added in the upcoming patches.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 ++++
>  arch/arm64/include/uapi/asm/kvm.h |  9 +++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/guest.c            |  8 ++-
>  arch/arm64/kvm/hypercalls.c       | 94 +++++++++++++++++++++++++++++++
>  arch/arm64/kvm/psci.c             | 13 +++++
>  include/kvm/arm_hypercalls.h      |  6 ++
>  include/kvm/arm_psci.h            |  2 +-
>  8 files changed, 142 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 94a27a7520f4..df07f4c10197 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
>  struct kvm_arch_memory_slot {
>  };
>
> +/**
> + * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
> + *
> + * @std_bmap: Bitmap of standard secure service calls
> + */
> +struct kvm_smccc_features {
> +       unsigned long std_bmap;
> +};
> +
>  struct kvm_arch {
>         struct kvm_s2_mmu mmu;
>
> @@ -150,6 +159,9 @@ struct kvm_arch {
>
>         u8 pfr0_csv2;
>         u8 pfr0_csv3;
> +
> +       /* Hypercall features firmware registers' descriptor */
> +       struct kvm_smccc_features smccc_feat;
>  };
>
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index c1b6ddc02d2f..0b79d2dc6ffd 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_ARM64_SVE_VLS_WORDS        \
>         ((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
>
> +/* Bitmap feature firmware registers */
> +#define KVM_REG_ARM_FW_FEAT_BMAP               (0x0016 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)                (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> +                                               KVM_REG_ARM_FW_FEAT_BMAP |      \
> +                                               ((r) & 0xffff))
> +
> +#define KVM_REG_ARM_STD_BMAP                   KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
> +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0          0
> +
>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR      0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 523bc934fe2f..a37fadbd617e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>
>         set_default_spectre(kvm);
> +       kvm_arm_init_hypercalls(kvm);
>
>         return ret;
>  out_free_stage2_pgd:
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 0d5cca56cbda..8c607199cad1 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>
>         switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>         case KVM_REG_ARM_CORE:  return get_core_reg(vcpu, reg);
> -       case KVM_REG_ARM_FW:    return kvm_arm_get_fw_reg(vcpu, reg);
> +       case KVM_REG_ARM_FW:
> +       case KVM_REG_ARM_FW_FEAT_BMAP:
> +               return kvm_arm_get_fw_reg(vcpu, reg);
>         case KVM_REG_ARM64_SVE: return get_sve_reg(vcpu, reg);
>         }
>
> @@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>
>         switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>         case KVM_REG_ARM_CORE:  return set_core_reg(vcpu, reg);
> -       case KVM_REG_ARM_FW:    return kvm_arm_set_fw_reg(vcpu, reg);
> +       case KVM_REG_ARM_FW:
> +       case KVM_REG_ARM_FW_FEAT_BMAP:
> +               return kvm_arm_set_fw_reg(vcpu, reg);
>         case KVM_REG_ARM64_SVE: return set_sve_reg(vcpu, reg);
>         }
>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index fa6d9378d8e7..df55a04d2fe8 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -58,6 +58,48 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>         val[3] = lower_32_bits(cycles);
>  }
>
> +static bool kvm_arm_fw_reg_feat_enabled(unsigned long *reg_bmap, unsigned long feat_bit)
> +{
> +       return test_bit(feat_bit, reg_bmap);
> +}
> +
> +static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +       switch (func_id) {
> +       /*
> +        * List of function-ids that are not gated with the bitmapped feature
> +        * firmware registers, and are to be allowed for servicing the call by default.
> +        */
> +       case ARM_SMCCC_VERSION_FUNC_ID:
> +       case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +       case ARM_SMCCC_HV_PV_TIME_FEATURES:
> +       case ARM_SMCCC_HV_PV_TIME_ST:
> +       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> +       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +               return true;
> +       default:
> +               return kvm_psci_func_id_is_valid(vcpu, func_id);
> +       }
> +}
> +
> +static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +       struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> +
> +       switch (func_id) {
> +       case ARM_SMCCC_TRNG_VERSION:
> +       case ARM_SMCCC_TRNG_FEATURES:
> +       case ARM_SMCCC_TRNG_GET_UUID:
> +       case ARM_SMCCC_TRNG_RND32:
> +       case ARM_SMCCC_TRNG_RND64:
> +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
> +                                               KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> +       default:
> +               return kvm_hvc_call_default_allowed(vcpu, func_id);
> +       }
> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>         u32 func_id = smccc_get_function(vcpu);
> @@ -65,6 +107,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>         u32 feature;
>         gpa_t gpa;
>
> +       if (!kvm_hvc_call_allowed(vcpu, func_id))
> +               goto out;
> +
>         switch (func_id) {
>         case ARM_SMCCC_VERSION_FUNC_ID:
>                 val[0] = ARM_SMCCC_VERSION_1_1;
> @@ -155,6 +200,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>                 return kvm_psci_call(vcpu);
>         }
>
> +out:
>         smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>         return 1;
>  }
> @@ -164,8 +210,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> +       KVM_REG_ARM_STD_BMAP,
>  };
>
> +void kvm_arm_init_hypercalls(struct kvm *kvm)
> +{
> +       struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> +
> +       smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> +}
> +
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>  {
>         return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> @@ -237,6 +291,7 @@ static int get_kernel_wa_level(u64 regid)
>
>  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> +       struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
>         void __user *uaddr = (void __user *)(long)reg->addr;
>         u64 val;
>
> @@ -249,6 +304,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>                 val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
>                 break;
> +       case KVM_REG_ARM_STD_BMAP:
> +               val = READ_ONCE(smccc_feat->std_bmap);
> +               break;
>         default:
>                 return -ENOENT;
>         }
> @@ -259,6 +317,40 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         return 0;
>  }
>
> +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> +{
> +       int ret = 0;
> +       struct kvm *kvm = vcpu->kvm;
> +       struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> +       unsigned long *fw_reg_bmap, fw_reg_features;
> +
> +       switch (reg_id) {
> +       case KVM_REG_ARM_STD_BMAP:
> +               fw_reg_bmap = &smccc_feat->std_bmap;
> +               fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
> +               break;
> +       default:
> +               return -ENOENT;
> +       }
> +
> +       /* Check for unsupported bit */
> +       if (val & ~fw_reg_features)
> +               return -EINVAL;
> +
> +       mutex_lock(&kvm->lock);

Why don't you check if the register value will be modified before
getting the lock ? (then there is nothing to do)
It would help reduce unnecessary serialization for live migration
(even without the vm-scoped register capability).



> +
> +       /* Return -EBUSY if the VM (any vCPU) has already started running. */
> +       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> +               ret = -EBUSY;
> +               goto out;
> +       }

I just would like to make sure that you are sure that existing
userspace you know will not run KVM_RUN for any vCPUs until
KVM_SET_ONE_REG is complete for all vCPUs (even for migration),
correct ?


> +
> +       WRITE_ONCE(*fw_reg_bmap, val);
> +out:
> +       mutex_unlock(&kvm->lock);
> +       return ret;
> +}
> +
>  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>         void __user *uaddr = (void __user *)(long)reg->addr;
> @@ -337,6 +429,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>                         return -EINVAL;
>
>                 return 0;
> +       case KVM_REG_ARM_STD_BMAP:
> +               return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
>         default:
>                 return -ENOENT;
>         }
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 346535169faa..67d1273e8086 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -436,3 +436,16 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>                 return -EINVAL;
>         }
>  }
> +
> +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +       /* PSCI 0.1 doesn't comply with the standard SMCCC */
> +       if (kvm_psci_version(vcpu) == KVM_ARM_PSCI_0_1)
> +               return (func_id == KVM_PSCI_FN_CPU_OFF || func_id == KVM_PSCI_FN_CPU_ON);
> +
> +       if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
> +               ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
> +               return true;

For PSCI 0.1, the function checks if the funct_id is valid for
the vCPU (according to the vCPU's PSCI version).
For other version of PSCI, the function doesn't care the vCPU's
PSCI version (although supported functions depend on the PSCI
version and not all of them are defined yet, the code returns
true as long as the function id is within the reserved PSCI
function id range).
So, the behavior appears to be inconsistent.
Shouldn't it return the validity of the function id according
to the vCPU's psci version for non-PSCI 0.1 case as well ?
(Otherwise, shouldn't it return true if the function id is valid
for any of the PSCI versions ?)

Thanks,
Reiji



> +
> +       return false;
> +}
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 5d38628a8d04..499b45b607b6 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -6,6 +6,11 @@
>
>  #include <asm/kvm_emulate.h>
>
> +/* Last valid bits of the bitmapped firmware registers */
> +#define KVM_REG_ARM_STD_BMAP_BIT_MAX           0
> +
> +#define KVM_ARM_SMCCC_STD_FEATURES             GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>
>  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> @@ -42,6 +47,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>
>  struct kvm_one_reg;
>
> +void kvm_arm_init_hypercalls(struct kvm *kvm);
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
>  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 6e55b9283789..c47be3e26965 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -36,7 +36,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
>         return KVM_ARM_PSCI_0_1;
>  }
>
> -
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
> +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id);
>
>  #endif /* __KVM_ARM_PSCI_H__ */
> --
> 2.36.0.rc2.479.g8af0fa9b8e-goog
>
