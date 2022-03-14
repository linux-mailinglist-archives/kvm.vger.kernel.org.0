Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3594D8E18
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 21:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbiCNU1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242949AbiCNU1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:27:24 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1379396AF
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:26:12 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w27so29342166lfa.5
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eihO5sN1DzjFLWydv0KyFef5/tArlyyikl3LHZPr+T8=;
        b=D29Z559Cl8BjB3EHoOl2pmpvo18qOIA8zUi4pmCL7JfWmJI7fwqV1R4FaYk22RgQv3
         yA2WMKiCjAn2+warAzhZVRH3uzRMu/qbrcublW2yCHhgwMxed15B6gSK0uP5uCT5hmoO
         jkoofOjVo3EKOi67rkGZUPnejxDy/o6T+rISePg9vTRa5/w6lVRgqbvftNP/ABC1dEM3
         tNPClowmQ2+M48uIBfNWJkFFag2GhBiLHBOUWFiVAffdUO1ZtWmz0/0KtBq/3p3cgvA8
         PtDnGx8wFurTR3AuM4wI9/Y6IYqSVo2Y1kWZ6hJsWF+4ISIpIm4g66iHLeHkUjpRHEYB
         ghMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eihO5sN1DzjFLWydv0KyFef5/tArlyyikl3LHZPr+T8=;
        b=bke9BnPY/anKnSeqk+7/54MUiUf/qwcCo/ymcOnEykfOkSsiBUHtzVpMePDquilFcw
         PYK4uzeNDZqtsxrkL+dDh6LBeRlS5j8UE25wCbYJ+tKBLF3tzd3RAG+3/KxISdCJmcBf
         iPUfFnUa4TSUDd7cvk5/sAOcibMYx4WCd9k2Q+sMcPKR+d3kHKC1X34zwQBvUIwAdrp3
         8qfPzBtYc4nkShMwmDPlyxp1TirnBrQ92fBzfk7bQOLGztAnlK7A5poy+4NuvLv8r6tK
         cTmNvqZ7FK1DdPsJSba56MJnQg1zDOx8jmH4ziY6n7D3pPQ1lY9NQUBh/7wpm6CDhpZp
         tGuw==
X-Gm-Message-State: AOAM533KBbcbjGoC/miqN2sZkaqFBPqFIqUPccRMQ0jCjLWDAykcYazJ
        5NaegUEhWT1TQu7e3unvl1dvDx21sFhYM7/V/GX/9g==
X-Google-Smtp-Source: ABdhPJw2yPwl8VIFLl3qk3bH7lZoOg+blH1MukCoTPJ4ld7/36XPTiUPQ/2M9+yBMLTff6/SRgsq1BkdloZZCe9YhqM=
X-Received: by 2002:a05:6512:1301:b0:439:73a2:7ca3 with SMTP id
 x1-20020a056512130100b0043973a27ca3mr14339848lfu.685.1647289570672; Mon, 14
 Mar 2022 13:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com> <20220224172559.4170192-6-rananta@google.com>
 <Yi+aTs4ufnxHXg4r@google.com>
In-Reply-To: <Yi+aTs4ufnxHXg4r@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 14 Mar 2022 13:25:59 -0700
Message-ID: <CAOQ_QshAA7N7gzLvBS_FRHbUmp1eqh0pWY66KNyMATV-Rm2Mmw@mail.gmail.com>
Subject: Re: [PATCH v4 05/13] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Mar 14, 2022 at 12:41 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 05:25:51PM +0000, Raghavendra Rao Ananta wrote:
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
> > KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.
> >
> > These firmware registers are categorized based on the service call
> > owners, and unlike the existing firmware psuedo-registers, they hold
> > the features supported in the form of a bitmap.
> >
> > During the VM initialization, the registers holds an upper-limit of
> > the features supported by the corresponding registers. It's expected
> > that the VMMs discover the features provided by each register via
> > GET_ONE_REG, and writeback the desired values using SET_ONE_REG.
> > KVM allows this modification only until the VM has started.
> >
> > Older userspace code can simply ignore the capability and the
> > hypercall services will be exposed unconditionally to the guests, thus
> > ensuring backward compatibility.
> >
> > In this patch, the framework adds the register only for ARM's standard
> > secure services (owner value 4). Currently, this includes support only
> > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > register representing mandatory features of v1.0. The register is also
> > added to the kvm_arm_vm_scope_fw_regs[] list as it maintains its state
> > per-VM. Other services are momentarily added in the upcoming patches.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 12 +++++
> >  arch/arm64/include/uapi/asm/kvm.h |  8 ++++
> >  arch/arm64/kvm/arm.c              |  8 ++++
> >  arch/arm64/kvm/guest.c            |  1 +
> >  arch/arm64/kvm/hypercalls.c       | 78 +++++++++++++++++++++++++++++++
> >  include/kvm/arm_hypercalls.h      |  4 ++
> >  6 files changed, 111 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index e823571e50cc..1909ced3208f 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +/**
> > + * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
> > + *
> > + * @hvc_std_bmap: Bitmap of standard secure service calls
> > + */
> > +struct kvm_hvc_desc {
>
> nit: maybe call this structure kvm_hypercall_features? When nested comes
> along guests will need to use the SVC conduit as HVC traps are always
> taken to EL2. Same will need to be true for virtual EL2.

actually, I'd recommend using SMCCC as the token instead, so
kvm_smccc_features. It is the one constant between HVC and SMC calls
and governs our whole hypercall ABI anyway.

> > +     u64 hvc_std_bmap;
> > +};
> > +
> >  struct kvm_arch {
> >       struct kvm_s2_mmu mmu;
> >
> > @@ -142,6 +151,9 @@ struct kvm_arch {
> >
> >       /* Capture first run of the VM */
> >       bool has_run_once;
> > +
> > +     /* Hypercall firmware register' descriptor */
> > +     struct kvm_hvc_desc hvc_desc;
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index c35447cc0e0c..2decc30d6b84 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -287,6 +287,14 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED     3
> >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED          (1U << 4)
> >
> > +/* Bitmap firmware registers, extension to the existing psuedo-register space */
> > +#define KVM_REG_ARM_FW_BMAP                  KVM_REG_ARM_FW_REG(0xff00)
>
> What is the motivation for moving the bitmap register indices so far
> away from the rest of the firmware regs?
>
> > +#define KVM_REG_ARM_FW_BMAP_REG(r)           (KVM_REG_ARM_FW_BMAP | (r))
>
> If you are still going to use the index offset, just pass 'r' through to
> the other macro:
>
>   #define KVM_REG_ARM_FW_BMAP_REG(r)            KVM_REG_ARM_FW_REG(0xff00 + r)
>
> > +#define KVM_REG_ARM_STD_BMAP                 KVM_REG_ARM_FW_BMAP_REG(0)
> > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0                BIT(0)
> > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX         0       /* Last valid bit */
>
> Implementation details such as this probably shouldn't live in UAPI
> headers. We'll likely need to bump the value in the future.
>
> > +
> >  /* SVE registers */
> >  #define KVM_REG_ARM64_SVE            (0x15 << KVM_REG_ARM_COPROC_SHIFT)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index f61cd8d57eae..e9f9edb1cf55 100644
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
> > @@ -635,7 +636,14 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >       if (kvm_vm_is_protected(kvm))
> >               kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
> >
> > +     /*
> > +      * Grab kvm->lock such that the reader of has_run_once can finish
> > +      * the necessary operation atomically, such as deciding whether to
> > +      * block the writes to the firmware registers if the VM has run once.
> > +      */
> > +     mutex_lock(&kvm->lock);
> >       kvm->arch.has_run_once = true;
> > +     mutex_unlock(&kvm->lock);
>
> Shouldn't this have just grabbed the kvm lock in patch 04/13?
>
> >       return ret;
> >  }
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index eb061e64a7a5..d66e6c742bbe 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -65,6 +65,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
> >  static const u64 kvm_arm_vm_scope_fw_regs[] = {
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > +     KVM_REG_ARM_STD_BMAP,
> >  };
> >
> >  /**
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 8624e6964940..48c126c3da72 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -58,6 +58,29 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> >       val[3] = lower_32_bits(cycles);
> >  }
> >
> > +static bool kvm_arm_fw_reg_feat_enabled(u64 reg_bmap, u64 feat_bit)
> > +{
> > +     return reg_bmap & feat_bit;
> > +}
> > +
> > +static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +     struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> > +
> > +     switch (func_id) {
> > +     case ARM_SMCCC_TRNG_VERSION:
> > +     case ARM_SMCCC_TRNG_FEATURES:
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +     case ARM_SMCCC_TRNG_RND32:
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
> > +                                             KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> > +     default:
> > +             /* By default, allow the services that aren't listed here */
> > +             return true;
>
> I think your default case should really return false. It keeps people
> honest when they add new patches to set up a new hypercall bit (no bit?
> no call!)
>
> That of course requires that you only return false once all of the
> preexisting hypercalls are enumerated, otherwise such a patch would
> cause a regression in isolation.
>
> > +     }
> > +}
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  {
> >       u32 func_id = smccc_get_function(vcpu);
> > @@ -65,6 +88,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >       u32 feature;
> >       gpa_t gpa;
> >
> > +     if (!kvm_hvc_call_supported(vcpu, func_id))
> > +             goto out;
> > +
> >       switch (func_id) {
> >       case ARM_SMCCC_VERSION_FUNC_ID:
> >               val[0] = ARM_SMCCC_VERSION_1_1;
> > @@ -143,6 +169,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               return kvm_psci_call(vcpu);
> >       }
> >
> > +out:
> >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >       return 1;
> >  }
> > @@ -151,8 +178,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >       KVM_REG_ARM_PSCI_VERSION,
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > +     KVM_REG_ARM_STD_BMAP,
> >  };
> >
> > +void kvm_arm_init_hypercalls(struct kvm *kvm)
> > +{
> > +     struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
> > +
> > +     hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
> > +}
> > +
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> >  {
> >       return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> > @@ -220,6 +255,7 @@ static int get_kernel_wa_level(u64 regid)
> >
> >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> > +     struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> >       void __user *uaddr = (void __user *)(long)reg->addr;
> >       u64 val, reg_id = reg->id;
> >
> > @@ -233,6 +269,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> >               val = get_kernel_wa_level(reg_id) & KVM_REG_FEATURE_LEVEL_MASK;
> >               break;
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             val = READ_ONCE(hvc_desc->hvc_std_bmap);
> > +             break;
> >       default:
> >               return -ENOENT;
> >       }
> > @@ -243,6 +282,43 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       return 0;
> >  }
> >
> > +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> > +{
> > +     int ret = 0;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
> > +     u64 *fw_reg_bmap, fw_reg_features;
>
> nit: use reverse fir tree ordering for locals (longest line first,
> shortest last).
>
> > +     switch (reg_id) {
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             fw_reg_bmap = &hvc_desc->hvc_std_bmap;
> > +             fw_reg_features = ARM_SMCCC_STD_FEATURES;
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
> How about returning -EINVAL instead? We already do this for
> KVM_ARM_VCPU_INIT if userspace uses a different target than the one
> previously set.
>
> > +      */
> > +     if (kvm_arm_vm_has_run_once(&kvm->arch)) {
> > +             ret = *fw_reg_bmap != val ? -EBUSY : 0;
> > +             goto out;
> > +     }
> > +
> > +     WRITE_ONCE(*fw_reg_bmap, val);
> > +out:
> > +     mutex_unlock(&kvm->lock);
> > +     return ret;
> > +}
> > +
> >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >       void __user *uaddr = (void __user *)(long)reg->addr;
> > @@ -321,6 +397,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >                       return -EINVAL;
> >
> >               return 0;
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
> >       default:
> >               return -ENOENT;
> >       }
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index 5d38628a8d04..64d30b452809 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -6,6 +6,9 @@
> >
> >  #include <asm/kvm_emulate.h>
> >
> > +#define ARM_SMCCC_STD_FEATURES \
> > +     GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> > +
>
> This probably needs KVM_ somewhere in its name for the sake of scoping.
>
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > @@ -42,6 +45,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
> >
> >  struct kvm_one_reg;
> >
> > +void kvm_arm_init_hypercalls(struct kvm *kvm);
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
