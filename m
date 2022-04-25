Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF89950E631
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 18:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243634AbiDYQzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiDYQzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 12:55:13 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEC21A048
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:52:08 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2f7b90e8b37so77432087b3.6
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFVXbK88HMZ7irS1EV3QbO6i92VJWq/msMeGHj6PNxc=;
        b=bUVEaQ2wIuKybo7kKQmoFYoEvIZ5UirP/KvquexNzuYtWoi/ArniVP0TSRhp/xPvF4
         pjO88yRVQp/fFable34gX1YDVyJpMA9C9G2vEf8Kz486GPzw+RzufdXY/0jM7gTVCCsg
         PidMDRcF1CNXJn+3SjKJOWvA3RIB/cb9JqrhsFBu+iWytoAeilSrA/RMTgGjycGiMs+r
         5N3rDehjoLGsJNyxZeUrYK3zFPcD2g2ZEbJpTAcnk8wQD7D/F/BZsTof8SScGzFdqDS7
         6k9Kc58dLAu+v9oHuXu7fYVxWXbc48epu/owuKJq0cWH+V02p84jlw6M/HppCcWvNYzi
         MMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFVXbK88HMZ7irS1EV3QbO6i92VJWq/msMeGHj6PNxc=;
        b=cNseLRePQXSfDh0u6VQ3bZlvgrLzMB+/7x6jBpK1zWvjuqp7c9LJP+AqJdbht5eIL3
         Jk2uPtkrzavFBPyfDnObBLh4l/7UsVyR19sEQBAdc5JUfRFs6JS+ttQvlgyFImVbR4mY
         7cJ+BY+MJY7CGYGcYrtZ+2PLQJLs9eAYc2ws+FvBR7o2OHQZF/JRU2WadGW61dc5MUo6
         vhyaGe8br4a6yxEbV6HrdaeBMj8vuqlNHa1oW00mMEXNu/vmQT5ZfXHwoaYD3LB94Tsb
         cyTSw+PnevIjhaZIvsqT7JDdzdRYZRlDeoWOJrE4J+FMLryxwrExKx8tjqYskT2Ojxuc
         Aagw==
X-Gm-Message-State: AOAM530J5O7HE9+WrBGGF5gMf2YZ+4mOGcU0vdPRmnDqgEQOKw9vxUnG
        pn9xHBKBNTU2EDzfvxTafLVVN2LKfMyRUhgdlR/zSCoO/MOteA==
X-Google-Smtp-Source: ABdhPJxTfEfeqBKHmxyw2CtMbyEAYltfx7GpPViRfckEPW8IinZNEjDVmPt5S7rAbMebL6fc8qUZBmNt0weWMmdOubU=
X-Received: by 2002:a0d:f007:0:b0:2f4:ce96:514b with SMTP id
 z7-20020a0df007000000b002f4ce96514bmr17915775ywe.148.1650905527631; Mon, 25
 Apr 2022 09:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-5-rananta@google.com>
 <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com>
In-Reply-To: <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 25 Apr 2022 09:51:56 -0700
Message-ID: <CAJHc60zR4Pa=y-Y4Dp27FoAvqpBrONCN727KbnhSoxNGRiBGuA@mail.gmail.com>
Subject: Re: [PATCH v6 4/9] KVM: arm64: Add vendor hypervisor firmware register
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

On Sun, Apr 24, 2022 at 11:22 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Introduce the firmware register to hold the vendor specific
> > hypervisor service calls (owner value 6) as a bitmap. The
> > bitmap represents the features that'll be enabled for the
> > guest, as configured by the user-space. Currently, this
> > includes support for KVM-vendor features along with
> > reading the UID, represented by bit-0, and Precision Time
> > Protocol (PTP), represented by bit-1.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> >  arch/arm64/kvm/hypercalls.c       | 23 ++++++++++++++++++-----
> >  include/kvm/arm_hypercalls.h      |  2 ++
> >  4 files changed, 26 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 27d4b2a7970e..a025c2ba012a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
> >   *
> >   * @std_bmap: Bitmap of standard secure service calls
> >   * @std_hyp_bmap: Bitmap of standard hypervisor service calls
> > + * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
> >   */
> >  struct kvm_smccc_features {
> >         unsigned long std_bmap;
> >         unsigned long std_hyp_bmap;
> > +       unsigned long vendor_hyp_bmap;
> >  };
> >
> >  struct kvm_arch {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 9eecc7ee8c14..e7d5ae222684 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_STD_HYP_BMAP               KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
> >  #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME                0
> >
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP            KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT   0
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP         1
> > +
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR      0
> >  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index f097bebdad39..76e626d0e699 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -72,9 +72,6 @@ static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> >          */
> >         case ARM_SMCCC_VERSION_FUNC_ID:
> >         case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > -       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > -       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > -       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >                 return true;
> >         default:
> >                 return kvm_psci_func_id_is_valid(vcpu, func_id);
> > @@ -97,6 +94,13 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> >         case ARM_SMCCC_HV_PV_TIME_ST:
> >                 return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
> >                                         KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> > +       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > +       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
> > +                                       KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
> > +       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
> > +                                       KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
> >         default:
> >                 return kvm_hvc_call_default_allowed(vcpu, func_id);
> >         }
> > @@ -189,8 +193,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >                 val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
> >                 break;
> >         case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > -               val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > -               val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> > +               val[0] = smccc_feat->vendor_hyp_bmap;
> >                 break;
> >         case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >                 kvm_ptp_get_time(vcpu, val);
> > @@ -217,6 +220,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> >         KVM_REG_ARM_STD_BMAP,
> >         KVM_REG_ARM_STD_HYP_BMAP,
> > +       KVM_REG_ARM_VENDOR_HYP_BMAP,
> >  };
> >
> >  void kvm_arm_init_hypercalls(struct kvm *kvm)
> > @@ -225,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
> >
> >         smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> >         smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> > +       smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> >  }
> >
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > @@ -317,6 +322,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >         case KVM_REG_ARM_STD_HYP_BMAP:
> >                 val = READ_ONCE(smccc_feat->std_hyp_bmap);
> >                 break;
> > +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +               val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
> > +               break;
> >         default:
> >                 return -ENOENT;
> >         }
> > @@ -343,6 +351,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> >                 fw_reg_bmap = &smccc_feat->std_hyp_bmap;
> >                 fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> >                 break;
> > +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +               fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
> > +               fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> > +               break;
> >         default:
> >                 return -ENOENT;
> >         }
> > @@ -445,6 +457,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >                 return 0;
> >         case KVM_REG_ARM_STD_BMAP:
> >         case KVM_REG_ARM_STD_HYP_BMAP:
> > +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> >                 return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> >         default:
> >                 return -ENOENT;
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index aadd6ae3ab72..4ebfdd26e486 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -9,9 +9,11 @@
> >  /* Last valid bits of the bitmapped firmware registers */
> >  #define KVM_REG_ARM_STD_BMAP_BIT_MAX           0
> >  #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX       0
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX    1
>
> Nit: IMHO perhaps it might be more convenient to define the MAX macro
> in arch/arm64/include/uapi/asm/kvm.h like below for maintenance ?
> (The same comments are applied to other KVM_REG_ARM_*_BMAP_BIT_MAX)
>
> #define KVM_REG_ARM_VENDOR_HYP_BIT_MAX KVM_REG_ARM_VENDOR_HYP_BIT_PTP
>
We have been going back and forth on this :)
It made sense for me to keep it in uapi as well, but I took Oliver's
suggestion of keeping it outside of uapi since this is something that
could be constantly changing [1].

Thank you.
Raghavendra

[1]: https://lore.kernel.org/lkml/CAJHc60wz5WsZWTn66i41+G4-dsjCFuFkthXU_Vf6QeXHkgzrZg@mail.gmail.com/

> Thanks,
> Reiji
>
>
> >
> >  #define KVM_ARM_SMCCC_STD_FEATURES             GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> >  #define KVM_ARM_SMCCC_STD_HYP_FEATURES         GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> > +#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES      GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> >
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
