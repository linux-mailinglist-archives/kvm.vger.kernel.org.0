Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71B245AB52
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 19:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbhKWSho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 13:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238991AbhKWShn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 13:37:43 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14636C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 10:34:35 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id j2so25354650ybg.9
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 10:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UmZP7s6Y3y+BF7GQWu/5PpGCQsbzEywMQfIlhCqz6v4=;
        b=SuRvNQDEpRXjhYRiHyMdceZXXKR3Z4OeeeYGs+ivzUHHISqbE0trWtDfeES/aCdUOG
         eBMlA3WvaZkYfviPwMbULEhwyAayAEf4agFQEEIAdreoNvDpVyh7mJS2vf7AbKsUuR3O
         WG6KrCHo5HZuwb61ivG0wsgOANUTL2bGmgDExNZlLK2A/CEj1gVFSuNW7iu+K8eFZMUY
         PvESzMBpz23xewRjRCbJEgvsFMv0XMb169rolHM/MsSijsoVo3/1EdZLcYTSf5gFPZ/0
         g8gqH0ANsD72hNDM256lxo+4XBPREY/1EttLu6gBD6877ym32hLX9gE/o5np3TKLtP/S
         7XjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UmZP7s6Y3y+BF7GQWu/5PpGCQsbzEywMQfIlhCqz6v4=;
        b=39rtIfq/NhErRwxRPas/WIOOBFJiYwVoAVjjH90kIhuFQ56ikD8Ilw+d/nLYG7tuOE
         ZJkFOzsAatOcxHFhdg2Dxro5orqi9ZmZm/C10KtxXz9OhVKdHcztb5izLS+PiyhtYb/H
         NXLDaGCHrNp7ACFUeBXAwBID7giJuA/hrs9+G6up2KKchaLSN5ATLuY3IAfUQnhAwf1v
         w4xNq4cUa6faq1fgkwGIrkw6PisbghJ5H4Qewpzgd3/aaqEQGDhptTg172PkJiHKvsl/
         P3A1oxTdtmxmPypFEzXU/aiWV9YTFModlsa0QkRnSxDChoR+qV2geDd/0ULem/RTVs0M
         d9QQ==
X-Gm-Message-State: AOAM533LCzpIeQJvqgqbzioY6tMIM0bqrtP7RgUftgK0brEUss7Y8Bck
        ycjJ7dL+7YDZ+hC8poEP47xEBxRHw9ndPU8D8XR//Q==
X-Google-Smtp-Source: ABdhPJyKBOjqFxhrIYRb6WnTjSnZAzj3R5xLYdyizgpOGHfTaxFkY8la+ITvpHJBc+r+AAKzCz2HVpYbWN52w0dOQXk=
X-Received: by 2002:a25:2c92:: with SMTP id s140mr8704685ybs.308.1637692473922;
 Tue, 23 Nov 2021 10:34:33 -0800 (PST)
MIME-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com> <20211113012234.1443009-5-rananta@google.com>
 <87wnl0cdfn.wl-maz@kernel.org>
In-Reply-To: <87wnl0cdfn.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 23 Nov 2021 10:34:23 -0800
Message-ID: <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/11] KVM: arm64: Setup a framework for hypercall
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 13 Nov 2021 01:22:27 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > KVM regularly introduces new hypercall services to the guests without
> > any consent from the Virtual Machine Manager (VMM). This means, the
> > guests can observe hypercall services in and out as they migrate
> > across various host kernel versions. This could be a major problem
> > if the guest discovered a hypercall, started using it, and after
> > getting migrated to an older kernel realizes that it's no longer
> > available. Depending on how the guest handles the change, there's
> > a potential chance that the guest would just panic.
> >
> > As a result, there's a need for the VMM to elect the services that
> > it wishes the guest to discover. VMM can elect these services based
> > on the kernels spread across its (migration) fleet. To remedy this,
> > extend the existing firmware psuedo-registers, such as
> > KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.
> >
> > These firmware registers are categorized based on the service call
> > owners, and unlike the existing firmware psuedo-registers, they hold
> > the features supported in the form of a bitmap. During VM (vCPU)
> > initialization, the registers shows an upper-limit of the features
> > supported by the corresponding registers. The VMM can simply use
> > GET_ONE_REG to discover the features. If it's unhappy with any of
> > the features, it can simply write-back the desired feature bitmap
> > using SET_ONE_REG.
> >
> > KVM allows these modification only until a VM has started. KVM also
> > assumes that the VMM is unaware of a register if a register remains
> > unaccessed (read/write), and would simply clear all the bits of the
> > registers such that the guest accidently doesn't get exposed to the
> > features. Finally, the set of bitmaps from all the registers are the
> > services that are exposed to the guest.
> >
> > In order to provide backward compatibility with already existing VMMs,
> > a new capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is introduced. To enable
> > the bitmap firmware registers extension, the capability must be
> > explicitly enabled. If not, the behavior is similar to the previous
> > setup.
> >
> > In this patch, the framework adds the register only for ARM's standard
> > secure services (owner value 4). Currently, this includes support only
> > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > register representing mandatory features of v1.0. Other services are
> > momentarily added in the upcoming patches.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  16 +++
> >  arch/arm64/include/uapi/asm/kvm.h |   4 +
> >  arch/arm64/kvm/arm.c              |  23 +++-
> >  arch/arm64/kvm/hypercalls.c       | 217 +++++++++++++++++++++++++++++-
> >  arch/arm64/kvm/trng.c             |   9 +-
> >  include/kvm/arm_hypercalls.h      |   7 +
> >  include/uapi/linux/kvm.h          |   1 +
> >  7 files changed, 262 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 02dffe50a20c..1546a2f973ef 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -102,6 +102,19 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +struct hvc_fw_reg_bmap {
> > +     bool accessed;
> > +     u64 reg_id;
> > +     u64 bmap;
> > +};
> > +
> > +struct hvc_reg_desc {
> > +     spinlock_t lock;
> > +     bool fw_reg_bmap_enabled;
> > +
> > +     struct hvc_fw_reg_bmap hvc_std_bmap;
> > +};
>
> Please document what these data structures track. Without any
> documentation, it is pretty difficult to build a mental picture of how
> this all fits together.
>
Sure, will do.
> > +
> >  struct kvm_arch {
> >       struct kvm_s2_mmu mmu;
> >
> > @@ -137,6 +150,9 @@ struct kvm_arch {
> >
> >       /* Memory Tagging Extension enabled for the guest */
> >       bool mte_enabled;
> > +
> > +     /* Hypercall firmware registers' descriptor */
> > +     struct hvc_reg_desc hvc_desc;
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index b3edde68bc3e..d6e099ed14ef 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -281,6 +281,10 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED     3
> >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED          (1U << 4)
> >
> > +#define KVM_REG_ARM_STD_BMAP                 KVM_REG_ARM_FW_REG(3)
> > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0                BIT(0)
> > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX         0       /* Last valid bit */
> > +
> >  /* SVE registers */
> >  #define KVM_REG_ARM64_SVE            (0x15 << KVM_REG_ARM_COPROC_SHIFT)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 0cc148211b4e..f2099e4d1109 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -81,26 +81,32 @@ int kvm_arch_check_processor_compat(void *opaque)
> >  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                           struct kvm_enable_cap *cap)
> >  {
> > -     int r;
> > +     int r = 0;
> > +     struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> >
> >       if (cap->flags)
> >               return -EINVAL;
> >
> >       switch (cap->cap) {
> >       case KVM_CAP_ARM_NISV_TO_USER:
> > -             r = 0;
> >               kvm->arch.return_nisv_io_abort_to_user = true;
> >               break;
> >       case KVM_CAP_ARM_MTE:
> >               mutex_lock(&kvm->lock);
> > -             if (!system_supports_mte() || kvm->created_vcpus) {
> > +             if (!system_supports_mte() || kvm->created_vcpus)
> >                       r = -EINVAL;
> > -             } else {
> > -                     r = 0;
> > +             else
> >                       kvm->arch.mte_enabled = true;
> > -             }
> >               mutex_unlock(&kvm->lock);
> >               break;
> > +     case KVM_CAP_ARM_HVC_FW_REG_BMAP:
> > +             if (kvm_vm_has_run_once(kvm))
> > +                     return -EBUSY;
> > +
> > +             spin_lock(&hvc_desc->lock);
>
> Does this really need to be a spin-lock? Are you ever taking it on a
> context where you cannot sleep? And why does it need to be a new lock
> when we already have a plethora of them?
>
I suppose I was going with the fact that we have very small critical
sections and could just go with a spinlock without interfering with
any other paths. But I suppose that's not needed. I can go with the
kvm->lock mutex instead.
> > +             hvc_desc->fw_reg_bmap_enabled = true;
> > +             spin_unlock(&hvc_desc->lock);
> > +             break;
> >       default:
> >               r = -EINVAL;
> >               break;
> > @@ -157,6 +163,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >
> >       set_default_spectre(kvm);
> >
> > +     kvm_arm_init_hypercalls(kvm);
> > +
> >       return ret;
> >  out_free_stage2_pgd:
> >       kvm_free_stage2_pgd(&kvm->arch.mmu);
> > @@ -215,6 +223,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >       case KVM_CAP_SET_GUEST_DEBUG:
> >       case KVM_CAP_VCPU_ATTRIBUTES:
> >       case KVM_CAP_PTP_KVM:
> > +     case KVM_CAP_ARM_HVC_FW_REG_BMAP:
> >               r = 1;
> >               break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> > @@ -622,6 +631,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >       if (kvm_vm_is_protected(kvm))
> >               kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
> >
> > +     kvm_arm_sanitize_fw_regs(kvm);
>
> What is the rational for doing this on first run? Surely this could be
> done at the point where userspace performs the write, couldn't it?
>
> My mental model is that the VMM reads some data, clears some bits if
> it really wants to, and writes it back. There shouldn't be anything to
> sanitise after the facts. Or at least that's my gut feeling so far.
>
I tried to explain things below..

> /me reads on.
>
> > +
> >       return ret;
> >  }
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 9e136d91b470..f5df7bc61146 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -58,6 +58,41 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> >       val[3] = lower_32_bits(cycles);
> >  }
> >
> > +static bool
> > +kvm_arm_fw_reg_feat_enabled(struct hvc_fw_reg_bmap *reg_bmap, u64 feat_bit)
> > +{
> > +     return reg_bmap->bmap & feat_bit;
> > +}
> > +
> > +bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +     struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> > +
> > +     /*
> > +      * To ensure backward compatibility, support all the service calls,
> > +      * including new additions, if the firmware registers holding the
> > +      * feature bitmaps isn't explicitly enabled.
> > +      */
> > +     if (!hvc_desc->fw_reg_bmap_enabled)
> > +             return true;
> > +
> > +     switch (func_id) {
> > +     case ARM_SMCCC_TRNG_VERSION:
> > +     case ARM_SMCCC_TRNG_FEATURES:
> > +     case ARM_SMCCC_TRNG_GET_UUID:
> > +     case ARM_SMCCC_TRNG_RND32:
> > +     case ARM_SMCCC_TRNG_RND64:
> > +             return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_bmap,
> > +                                     KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> > +     default:
> > +             /* By default, allow the services that aren't listed here */
> > +             return true;
> > +     }
> > +
> > +     /* We shouldn't be reaching here */
> > +     return true;
>
> So why have anything at all?
>
I was expecting the compiler might complain, but guess not, I'll remove this.
> > +}
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  {
> >       u32 func_id = smccc_get_function(vcpu);
> > @@ -65,6 +100,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >       u32 feature;
> >       gpa_t gpa;
> >
> > +     if (!kvm_hvc_call_supported(vcpu, func_id))
> > +             goto out;
> > +
> >       switch (func_id) {
> >       case ARM_SMCCC_VERSION_FUNC_ID:
> >               val[0] = ARM_SMCCC_VERSION_1_1;
> > @@ -143,6 +181,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               return kvm_psci_call(vcpu);
> >       }
> >
> > +out:
> >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >       return 1;
> >  }
> > @@ -153,17 +192,178 @@ static const u64 fw_reg_ids[] = {
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> >  };
> >
> > +static const u64 fw_reg_bmap_ids[] = {
> > +     KVM_REG_ARM_STD_BMAP,
> > +};
> > +
> > +static void kvm_arm_fw_reg_init_hvc(struct hvc_reg_desc *hvc_desc,
> > +                                     struct hvc_fw_reg_bmap *fw_reg_bmap,
> > +                                     u64 reg_id, u64 default_map)
> > +{
> > +     fw_reg_bmap->reg_id = reg_id;
> > +     fw_reg_bmap->bmap = default_map;
> > +}
> > +
> > +void kvm_arm_init_hypercalls(struct kvm *kvm)
> > +{
> > +     struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> > +
> > +     spin_lock_init(&hvc_desc->lock);
> > +
> > +     kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_bmap,
> > +                             KVM_REG_ARM_STD_BMAP, ARM_SMCCC_STD_FEATURES);
> > +}
> > +
> > +static void kvm_arm_fw_reg_sanitize(struct hvc_fw_reg_bmap *fw_reg_bmap)
> > +{
> > +     if (!fw_reg_bmap->accessed)
> > +             fw_reg_bmap->bmap = 0;
> > +}
> > +
> > +/*
> > + * kvm_arm_sanitize_fw_regs: Sanitize the hypercall firmware registers
> > + *
> > + * Sanitization, in the case of hypercall firmware registers, is basically
> > + * clearing out the feature bitmaps so that the guests are not exposed to
> > + * the services corresponding to a particular register. The registers that
> > + * needs sanitization is decided on two factors on the user-space part:
> > + *   1. Enablement of KVM_CAP_ARM_HVC_FW_REG_BMAP:
> > + *      If the user-space hasn't enabled the capability, it either means
> > + *      that it's unaware of its existence, or it simply doesn't want to
> > + *      participate in the arrangement and is okay with the default settings.
> > + *      The former case is to ensure backward compatibility.
> > + *
> > + *   2. Has the user-space accessed (read/write) the register? :
> > + *      If yes, it means that the user-space is aware of the register's
> > + *      existence and can set the bits as it sees fit for the guest. A
> > + *      read-only access from user-space indicates that the user-space is
> > + *      happy with the default settings, and doesn't wish to change it.
> > + *
> > + * The logic for sanitizing a register will then be:
> > + * ---------------------------------------------------------------------------
> > + * | CAP enabled | Accessed reg | Clear reg | Comments                       |
> > + * ---------------------------------------------------------------------------
> > + * |      N      |       N      |     N     |                                |
> > + * |      N      |       Y      |     N     | -ENOENT returned during access |
> > + * |      Y      |       N      |     Y     |                                |
> > + * |      Y      |       Y      |     N     |                                |
> > + * ---------------------------------------------------------------------------
> > + */
> > +void kvm_arm_sanitize_fw_regs(struct kvm *kvm)
> > +{
> > +     struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> > +
> > +     spin_lock(&hvc_desc->lock);
> > +
> > +     if (!hvc_desc->fw_reg_bmap_enabled)
> > +             goto out;
> > +
> > +     kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_bmap);
> > +
> > +out:
> > +     spin_unlock(&hvc_desc->lock);
>
> I keep being baffled by this. Why should we track the VMM accesses or
> the VMM writeback? This logic doesn't seem to bring anything useful as
> far as I can tell. All we need to ensure is that what is written to
> the pseudo-register is an acceptable subset of the previous value, and
> I cannot see why this can't be done at write-time.
>
> If you want to hide this behind a capability, fine (although my guts
> feeling is that we don't need that either). But I really want to be
> convinced about all this tracking.
>
The tracking of each owner register is necessary here to safe-guard
the possibility that the user-space may not be aware of a newly
introduced register, and hence, hasn't accessed it. If it had at least
read the register, but not write-back, we assume that the user-space
is happy with the configuration. But the fact that the register has
not even been read would state that user-space is unaware of the
existence of this new register. In such a case, if we don't sanitize
(clear all the bits) this register, the features will be exposed
unconditionally to the guest.

The capability is introduced here to make sure that this new
infrastructure is backward compatible with old VMMs. If the VMMs don't
enable this capability, they are probably unaware of this, and this
will work as it always has- expose new services to the guest
unconditionally as and when they are introduced.
> > +}
> > +
> > +static int kvm_arm_fw_reg_get_bmap(struct kvm *kvm,
> > +                             struct hvc_fw_reg_bmap *fw_reg_bmap, u64 *val)
> > +{
> > +     int ret = 0;
> > +     struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> > +
> > +     spin_lock(&hvc_desc->lock);
> > +
> > +     if (!hvc_desc->fw_reg_bmap_enabled) {
> > +             ret = -ENOENT;
> > +             goto out;
> > +     }
> > +
> > +     fw_reg_bmap->accessed = true;
> > +     *val = fw_reg_bmap->bmap;
> > +out:
> > +     spin_unlock(&hvc_desc->lock);
> > +     return ret;
> > +}
> > +
> > +static int kvm_arm_fw_reg_set_bmap(struct kvm *kvm,
> > +                             struct hvc_fw_reg_bmap *fw_reg_bmap, u64 val)
> > +{
> > +     int ret = 0;
> > +     u64 fw_reg_features;
> > +     struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> > +
> > +     spin_lock(&hvc_desc->lock);
> > +
> > +     if (!hvc_desc->fw_reg_bmap_enabled) {
> > +             ret = -ENOENT;
> > +             goto out;
> > +     }
> > +
> > +     if (fw_reg_bmap->bmap == val)
> > +             goto out;
> > +
> > +     if (kvm_vm_has_run_once(kvm)) {
> > +             ret = -EBUSY;
> > +             goto out;
> > +     }
> > +
> > +     switch (fw_reg_bmap->reg_id) {
> > +     case KVM_REG_ARM_STD_BMAP:
> > +             fw_reg_features = ARM_SMCCC_STD_FEATURES;
> > +             break;
> > +     default:
> > +             ret = -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     /* Check for unsupported feature bit */
> > +     if (val & ~fw_reg_features) {
> > +             ret = -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     fw_reg_bmap->accessed = true;
> > +     fw_reg_bmap->bmap = val;
> > +out:
> > +     spin_unlock(&hvc_desc->lock);
> > +     return ret;
> > +}
> > +
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> >  {
> > -     return ARRAY_SIZE(fw_reg_ids);
> > +     struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> > +     int n_regs = ARRAY_SIZE(fw_reg_ids);
> > +
> > +     spin_lock(&hvc_desc->lock);
> > +
> > +     if (hvc_desc->fw_reg_bmap_enabled)
> > +             n_regs += ARRAY_SIZE(fw_reg_bmap_ids);
> > +
> > +     spin_unlock(&hvc_desc->lock);
> > +
> > +     return n_regs;
> >  }
> >
> >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >  {
> > +     struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> >       int i;
> >
> >       for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> > -             if (put_user(fw_reg_ids[i], uindices))
> > +             if (put_user(fw_reg_ids[i], uindices++))
> > +                     return -EFAULT;
> > +     }
> > +
> > +     spin_lock(&hvc_desc->lock);
> > +
> > +     if (!hvc_desc->fw_reg_bmap_enabled) {
> > +             spin_unlock(&hvc_desc->lock);
> > +             return 0;
> > +     }
> > +
> > +     spin_unlock(&hvc_desc->lock);
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_bmap_ids); i++) {
> > +             if (put_user(fw_reg_bmap_ids[i], uindices++))
> >                       return -EFAULT;
>
> I really don't get what you are trying to achieve with this locking.
> You guard the 'enabled' bit, but you still allow the kernel view to be
> copied to userspace while another thread is writing to it?
>
That's my mistake. Thanks for pointing it out. I'll get rid of the
spinlock and use the existing ones correctly.

Regards,
Raghavendra

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
