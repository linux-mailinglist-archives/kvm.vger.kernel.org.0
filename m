Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13BC48BE0A
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 06:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344403AbiALFMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 00:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiALFMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 00:12:10 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DCC06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 21:12:10 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i6so2527756pla.0
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 21:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lwg5LiyNS/uTeMsNwNkwcptlrNr8emtVHm+x1BBpWc4=;
        b=DeziYi2v8qa7do38Ti8jZZsWGqmX40rnzEVKTWnYmQXrfHzvxJLJZcMczFS+e2r4bf
         ElUMUmgN5eiviFLfpkrk8PnbVfM6GkUwg0zFp4ZhGnVRlGrW/QXi6BnD6dfXU4t/5fnK
         bt9yyGD3I0gVEvzC42LzRmd38P9hCn0ZVOUSlrRTks3qTepmaMb8Iepd0Qhiyi7hT9V0
         c4wjhEemR+WCcAXhGWFybJ/IWqDaB5hrNh26snosJ7XLcelLO6r2CTk+5XCfKvFq7I9W
         z/3qxZn7Xvcu9R+15EL0DKLboxwgMTqD67Ah3IltLkt328KU0ob6kBNa+UE6+wkjljLs
         c6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lwg5LiyNS/uTeMsNwNkwcptlrNr8emtVHm+x1BBpWc4=;
        b=Xp7nhtkdgi2rgGbNQ53k3fssSZyRVM13P+dPVKZds/TgjwLcYKYnoRvJyCTgcTV3rj
         VJoGxgP3a32Yw+l+zM5BUeM+E8aBSlsLi2C0ITvod+A7M9pEqWaD0mPPvyPfhl3oRTsq
         n3TVnU4FrTR+xOVZn0SrwVboxFnNmip8ccTH2azUgXvnEwPMeIDGYkDfFgsotlfXAz/u
         kPt4CcFrmvt2h86VECDG6VSSHOSTdI4P8oP3RMUIuMpNQz1ij9d3gLnL2S7WKtcgHhws
         55kki/J1cpwRDVQMNikbmmfauDPMhB2imqH8V0ZkBpUTDcfQ4b+BecH+urK3kzhxYuCK
         8LQg==
X-Gm-Message-State: AOAM531Lhufr2K6X/JlVfBq39Vtj0+qEdi+ficTMCzRT+IiNRmVwxBxj
        e/nP7O/QZgfxW4rh0EnDCpdRDhfpcDhDtjFsHOBvPw==
X-Google-Smtp-Source: ABdhPJy7qWmnAXU2Ky0ISQYMl+AuzGhdATOSwiVTbGvUjPNn2mnMQvxldrCL/JSgINKqtj3wOCf0tONcqoI3mEc/jZk=
X-Received: by 2002:a63:7d4e:: with SMTP id m14mr7198814pgn.514.1641964328864;
 Tue, 11 Jan 2022 21:12:08 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-5-rananta@google.com>
 <CAAeT=FztkibSajKjnpRfObx+D1r8H1s_8-5MmqjemJTfmb2mpg@mail.gmail.com> <CAJHc60ywYgAPfG11Ljkj3qzLoUn9mZPKnPH0P-HYS-pfs+A__g@mail.gmail.com>
In-Reply-To: <CAJHc60ywYgAPfG11Ljkj3qzLoUn9mZPKnPH0P-HYS-pfs+A__g@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 11 Jan 2022 21:11:52 -0800
Message-ID: <CAAeT=FwA9X9eXrF+Q31Wzah=UkM-B8bMJObjJ=oCV0rjLfX6=g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
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
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 4:51 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Sun, Jan 9, 2022 at 10:29 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Raghu,
> >
> > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > KVM regularly introduces new hypercall services to the guests without
> > > any consent from the Virtual Machine Manager (VMM). This means, the
> > > guests can observe hypercall services in and out as they migrate
> > > across various host kernel versions. This could be a major problem
> > > if the guest discovered a hypercall, started using it, and after
> > > getting migrated to an older kernel realizes that it's no longer
> > > available. Depending on how the guest handles the change, there's
> > > a potential chance that the guest would just panic.
> > >
> > > As a result, there's a need for the VMM to elect the services that
> > > it wishes the guest to discover. VMM can elect these services based
> > > on the kernels spread across its (migration) fleet. To remedy this,
> > > extend the existing firmware psuedo-registers, such as
> > > KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.
> > >
> > > These firmware registers are categorized based on the service call
> > > owners, and unlike the existing firmware psuedo-registers, they hold
> > > the features supported in the form of a bitmap.
> > >
> > > The capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is used to announce
> > > this extension, which returns the number of psuedo-firmware
> > > registers supported. During the VM initialization, the registers
> > > holds an upper-limit of the features supported by the corresponding
> > > registers. It's expected that the VMMs discover the features
> > > provided by each register via GET_ONE_REG, and writeback the
> > > desired values using SET_ONE_REG. KVM allows this modification
> > > only until the VM has started.
> > >
> > > Older VMMs can simply ignore the capability and the hypercall services
> > > will be exposed unconditionally to the guests, thus ensuring backward
> > > compatibility.
> > >
> > > In this patch, the framework adds the register only for ARM's standard
> > > secure services (owner value 4). Currently, this includes support only
> > > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > > register representing mandatory features of v1.0. Other services are
> > > momentarily added in the upcoming patches.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |  12 ++++
> > >  arch/arm64/include/uapi/asm/kvm.h |   4 ++
> > >  arch/arm64/kvm/arm.c              |   4 ++
> > >  arch/arm64/kvm/hypercalls.c       | 103 +++++++++++++++++++++++++++++-
> > >  arch/arm64/kvm/trng.c             |   8 +--
> > >  include/kvm/arm_hypercalls.h      |   6 ++
> > >  6 files changed, 129 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 2a5f7f38006f..a32cded0371b 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -102,6 +102,15 @@ struct kvm_s2_mmu {
> > >  struct kvm_arch_memory_slot {
> > >  };
> > >
> > > +/**
> > > + * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
> > > + *
> > > + * @hvc_std_bmap: Bitmap of standard secure service calls
> > > + */
> > > +struct kvm_hvc_desc {
> > > +       u64 hvc_std_bmap;
> > > +};
> > > +
> > >  struct kvm_arch {
> > >         struct kvm_s2_mmu mmu;
> > >
> > > @@ -137,6 +146,9 @@ struct kvm_arch {
> > >
> > >         /* Memory Tagging Extension enabled for the guest */
> > >         bool mte_enabled;
> > > +
> > > +       /* Hypercall firmware register' descriptor */
> > > +       struct kvm_hvc_desc hvc_desc;
> > >  };
> > >
> > >  struct kvm_vcpu_fault_info {
> > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > index b3edde68bc3e..0d6f29c58456 100644
> > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > @@ -281,6 +281,10 @@ struct kvm_arm_copy_mte_tags {
> > >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED       3
> > >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED            (1U << 4)
> > >
> > > +#define KVM_REG_ARM_STD_BMAP                   KVM_REG_ARM_FW_REG(3)
> > > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0          BIT(0)
> > > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX           0       /* Last valid bit */
> > > +
> > >  /* SVE registers */
> > >  #define KVM_REG_ARM64_SVE              (0x15 << KVM_REG_ARM_COPROC_SHIFT)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index e4727dc771bf..56fe81565235 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >         kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> > >
> > >         set_default_spectre(kvm);
> > > +       kvm_arm_init_hypercalls(kvm);
> > >
> > >         return ret;
> > >  out_free_stage2_pgd:
> > > @@ -283,6 +284,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > >         case KVM_CAP_ARM_PTRAUTH_GENERIC:
> > >                 r = system_has_full_ptr_auth();
> > >                 break;
> > > +       case KVM_CAP_ARM_HVC_FW_REG_BMAP:
> > > +               r = kvm_arm_num_fw_bmap_regs();
> > > +               break;
> >
> > Looking at the discussion for the v2 series,
> >
> >  https://lore.kernel.org/kvmarm/20211130101958.fcdqthphyhxzvzla@gator.home/
> >
> > I assume that the number of the pseudo-firmware bitmap registers
> > will be used to clear pseudo firmware bitmap registers that
> > userspace doesn't know.
> > I'm wondering how userspace can identify which pseudo-firmware
> > registers that KVM_GET_REG_LIST provides are the pseudo-firmware
> > bitmap registers that it doesn't know.
> > For instance, suppose pseudo-firmware registers that KVM_GET_REG_LIST
> > provides are KVM_REG_ARM_FW_REG(0) to KVM_REG_ARM_FW_REG(9), userspace
> > doesn't knows KVM_REG_ARM_FW_REG(6) to KVM_REG_ARM_FW_REG(9), and
> > KVM_CAP_ARM_HVC_FW_REG_BMAP returns 5, how can userspace identify
> > remaining two bitmap registers from those 4 (fw-reg #6 to #9)
> > firmware registers ?
> >
> In v3, we leave the decision upto the userspace. If the userspace
> encounters a register that it's unaware, it can choose either to clear
> it or let it get exposed to the guest as is (see the code snipped
> shared by Andrew in the link).
> Trying to understand the question better- are you asking how would
> userspace distinguish between bitmap and regular fw registers with
> intermixed sequence numbers?

Yes, that's my question.


> If yes, do you foresee a reason why they 'unaware' registers needed to
> be treated differently?

Since I'm not sure what the specification of 'unaware' (non-bitmap)
registers will be, it would be safer for us to assume that they might
need to be treated differently from the bitmap registers.
Considering there is KVM_REG_ARM_PSCI_VERSION, which KVM doesn't allow
userspace to set to 0, there might be similar registers that userspace
cannot set to 0 in the future.

BTW, If you assume that all those 'unaware' firmware registers are
treated in the same way, I don't think userspace needs the number of
those bitmap registers from KVM_CAP_ARM_HVC_FW_REG_BMAP (Instead,
I would think it can handle the 'unaware' registers with a list of
firmware registers from KVM_GET_REG_LIST).

> >
> > >         default:
> > >                 r = 0;
> > >         }
> > > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > > index 3c2fcf31ad3d..06243e4670eb 100644
> > > --- a/arch/arm64/kvm/hypercalls.c
> > > +++ b/arch/arm64/kvm/hypercalls.c
> > > @@ -58,6 +58,29 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> > >         val[3] = lower_32_bits(cycles);
> > >  }
> > >
> > > +static bool kvm_arm_fw_reg_feat_enabled(u64 reg_bmap, u64 feat_bit)
> > > +{
> > > +       return reg_bmap & feat_bit;
> > > +}
> > > +
> > > +bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
> > > +{
> > > +       struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> > > +
> > > +       switch (func_id) {
> > > +       case ARM_SMCCC_TRNG_VERSION:
> > > +       case ARM_SMCCC_TRNG_FEATURES:
> > > +       case ARM_SMCCC_TRNG_GET_UUID:
> > > +       case ARM_SMCCC_TRNG_RND32:
> > > +       case ARM_SMCCC_TRNG_RND64:
> > > +               return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
> > > +                                               KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> > > +       default:
> > > +               /* By default, allow the services that aren't listed here */
> > > +               return true;
> > > +       }
> > > +}
> >
> > kvm_hvc_call_supported() could return true even for @func_id that
> > kvm_hvc_call_handler() returns -EINVAL for.  Is this behavior what
> > you really want ?
> Yes. My idea was to let kvm_hvc_call_supported() check for the
> support, while kvm_hvc_call_handler() does the real processing of the
> call.
>
> > If so, IMHO the function name might be a bit mis-leading.
> > "kvm_hvc_call_disabled" (and flip the return value)
> > might be closer to what it does(?).
> >
> Sorry, I'm unclear how flipping is helping. Wouldn't we return 'false'
> if we don't have a case for the func_id, indicating it's NOT disabled,
> but kvm_hvc_call_handler() can still return SMCCC_RET_NOT_SUPPORTED?

Yes, that's fine, too.
Since those services are disabled (because they are enabled by default),
I just thought checking 'disabled' might be closer to what it does than
checking 'enabled'.  But, 'enabled' is also fine.

> >
> > > +
> > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > >  {
> > >         u32 func_id = smccc_get_function(vcpu);
> > > @@ -65,6 +88,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > >         u32 feature;
> > >         gpa_t gpa;
> > >
> > > +       if (!kvm_hvc_call_supported(vcpu, func_id))
> > > +               goto out;
> > > +
> > >         switch (func_id) {
> > >         case ARM_SMCCC_VERSION_FUNC_ID:
> > >                 val[0] = ARM_SMCCC_VERSION_1_1;
> > > @@ -143,6 +169,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > >                 return kvm_psci_call(vcpu);
> > >         }
> > >
> > > +out:
> > >         smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> > >         return 1;
> > >  }
> > > @@ -153,9 +180,25 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> > >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > >  };
> > >
> > > +static const u64 kvm_arm_fw_reg_bmap_ids[] = {
> > > +       KVM_REG_ARM_STD_BMAP,
> > > +};
> > > +
> > > +void kvm_arm_init_hypercalls(struct kvm *kvm)
> > > +{
> > > +       struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
> > > +
> > > +       hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
> > > +}
> > > +
> > > +int kvm_arm_num_fw_bmap_regs(void)
> > > +{
> > > +       return ARRAY_SIZE(kvm_arm_fw_reg_bmap_ids);
> > > +}
> > > +
> > >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > >  {
> > > -       return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> > > +       return ARRAY_SIZE(kvm_arm_fw_reg_ids) + kvm_arm_num_fw_bmap_regs();
> > >  }
> > >
> > >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > > @@ -167,6 +210,11 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > >                         return -EFAULT;
> > >         }
> > >
> > > +       for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_bmap_ids); i++) {
> > > +               if (put_user(kvm_arm_fw_reg_bmap_ids[i], uindices++))
> > > +                       return -EFAULT;
> > > +       }
> > > +
> > >         return 0;
> > >  }
> > >
> > > @@ -211,9 +259,20 @@ static int get_kernel_wa_level(u64 regid)
> > >         return -EINVAL;
> > >  }
> > >
> > > +static void
> > > +kvm_arm_get_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 fw_reg_bmap, u64 *val)
> > > +{
> > > +       struct kvm *kvm = vcpu->kvm;
> > > +
> > > +       mutex_lock(&kvm->lock);
> > > +       *val = fw_reg_bmap;
> > > +       mutex_unlock(&kvm->lock);
> >
> > Why does it need to hold the lock ? (Wouldn't READ_ONCE be enough ?)
> >
> I don't have much experience with READ_ONCE at this point, but do you
> think this read can be protected again the read/write in
> kvm_arm_set_fw_reg_bmap()?

If kvm_arm_set_fw_reg_bmap is changed to use WRITE_ONCE to
update hvc_desc->hvc_*_bmap (kvm_arm_set_fw_reg_bmap still needs
to get the lock to prevent other vCPUs from running KVM_RUN),
I would think using READ_ONCE in kvm_arm_get_fw_reg_bmap() without
getting the lock should work (will see either old or new value).

Thanks,
Reiji


> >
> > > +}
> > > +
> > >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  {
> > >         void __user *uaddr = (void __user *)(long)reg->addr;
> > > +       struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
> > >         u64 val;
> > >
> > >         switch (reg->id) {
> > > @@ -224,6 +283,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >         case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > >                 val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> > >                 break;
> > > +       case KVM_REG_ARM_STD_BMAP:
> > > +               kvm_arm_get_fw_reg_bmap(vcpu, hvc_desc->hvc_std_bmap, &val);
> > > +               break;
> > >         default:
> > >                 return -ENOENT;
> > >         }
> > > @@ -234,6 +296,43 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >         return 0;
> > >  }
> > >
> > > +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> > > +{
> > > +       int ret = 0;
> > > +       struct kvm *kvm = vcpu->kvm;
> > > +       struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
> > > +       u64 *fw_reg_bmap, fw_reg_features;
> > > +
> > > +       switch (reg_id) {
> > > +       case KVM_REG_ARM_STD_BMAP:
> > > +               fw_reg_bmap = &hvc_desc->hvc_std_bmap;
> > > +               fw_reg_features = ARM_SMCCC_STD_FEATURES;
> > > +               break;
> > > +       default:
> > > +               return -ENOENT;
> > > +       }
> > > +
> > > +       /* Check for unsupported bit */
> > > +       if (val & ~fw_reg_features)
> > > +               return -EINVAL;
> > > +
> > > +       mutex_lock(&kvm->lock);
> > > +
> > > +       /*
> > > +        * If the VM (any vCPU) has already started running, return success
> > > +        * if there's no change in the value. Else, return -EBUSY.
> > > +        */
> > > +       if (kvm_vm_has_started(kvm)) {
> > > +               ret = *fw_reg_bmap != val ? -EBUSY : 0;
> > > +               goto out;
> > > +       }
> > > +
> > > +       *fw_reg_bmap = val;
> > > +out:
> > > +       mutex_unlock(&kvm->lock);
> > > +       return ret;
> > > +}
> > > +
> > >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >  {
> > >         void __user *uaddr = (void __user *)(long)reg->addr;
> > > @@ -310,6 +409,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > >                         return -EINVAL;
> > >
> > >                 return 0;
> > > +       case KVM_REG_ARM_STD_BMAP:
> > > +               return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> > >         default:
> > >                 return -ENOENT;
> > >         }
> > > diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
> > > index 99bdd7103c9c..23f912514b06 100644
> > > --- a/arch/arm64/kvm/trng.c
> > > +++ b/arch/arm64/kvm/trng.c
> > > @@ -60,14 +60,8 @@ int kvm_trng_call(struct kvm_vcpu *vcpu)
> > >                 val = ARM_SMCCC_TRNG_VERSION_1_0;
> > >                 break;
> > >         case ARM_SMCCC_TRNG_FEATURES:
> > > -               switch (smccc_get_arg1(vcpu)) {
> > > -               case ARM_SMCCC_TRNG_VERSION:
> > > -               case ARM_SMCCC_TRNG_FEATURES:
> > > -               case ARM_SMCCC_TRNG_GET_UUID:
> > > -               case ARM_SMCCC_TRNG_RND32:
> > > -               case ARM_SMCCC_TRNG_RND64:
> > > +               if (kvm_hvc_call_supported(vcpu, smccc_get_arg1(vcpu)))
> > >                         val = TRNG_SUCCESS;
> >
> > kvm_hvc_call_supported() returns true for any values that are
> > not explicitly listed in kvm_hvc_call_supported() (i.e. it returns
> > true even for @func_id that are not any of ARM_SMCCC_TRNG_*).
> > So, I don't think it can simply use the current kvm_hvc_call_supported.
> >
> You are right. Probably I should leave the case statements as is (or
> think of some better way).
>
>
> Thanks for the review and suggestions.
>
> Regards,
> Raghavendra
> > Thanks,
> > Reiji
> >
> > > -               }
> > >                 break;
> > >         case ARM_SMCCC_TRNG_GET_UUID:
> > >                 smccc_set_retval(vcpu, le32_to_cpu(u[0]), le32_to_cpu(u[1]),
> > > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > > index 5d38628a8d04..8fe68d8d6d96 100644
> > > --- a/include/kvm/arm_hypercalls.h
> > > +++ b/include/kvm/arm_hypercalls.h
> > > @@ -6,6 +6,9 @@
> > >
> > >  #include <asm/kvm_emulate.h>
> > >
> > > +#define ARM_SMCCC_STD_FEATURES \
> > > +       GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> > > +
> > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> > >
> > >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > > @@ -42,9 +45,12 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
> > >
> > >  struct kvm_one_reg;
> > >
> > > +void kvm_arm_init_hypercalls(struct kvm *kvm);
> > > +int kvm_arm_num_fw_bmap_regs(void);
> > >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> > >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> > >  int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > > +bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id);
> > >
> > >  #endif
> > > --
> > > 2.34.1.448.ga2b2bfdf31-goog
> > >
