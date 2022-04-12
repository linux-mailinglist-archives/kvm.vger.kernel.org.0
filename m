Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE134FE610
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357754AbiDLQob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343916AbiDLQoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:44:30 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FBD4BFE3
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:42:12 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p65so15831992ybp.9
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 09:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uAePugcgi5o8QTcK8LtKXSDf0e0z0pUy2pyRe/5eKqk=;
        b=p5kTMH0bnMq3gzHGAtBBycsJ6iunAwxInbAcoe8bb7uHzwSrK7OntMX5jsCs90RIvC
         Dkkv11JjJD3BGh/I2Z9v862ZpnuZ9a1oCGIdi8hGy9oaOMbJRRe7lyp1nB+3cEjUtSBq
         fuTJ7LK8EyolNZG0Sl0pGPn7uTAI0QaYFWvtg+uNLfNcPTRjjFt2FbWstGbxpgsdvvFf
         YqpQ+T7+6aaHGc6Tx2isMY8MRiKnw8chy77a8MMW4sN+oAiHB7ljJVXFupAJjSiTHHeR
         umwCgLawLKThycATadiNCong0TpkTRY/oYeobfpKByMY5aJAC+cWVy8tBlbxMFWdkcE8
         AhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uAePugcgi5o8QTcK8LtKXSDf0e0z0pUy2pyRe/5eKqk=;
        b=sV15CrPa/hwKGXbEXMaR1ImgFr5Vpt4CGvdfKHNZNsN6FrpPGdFprIx4WTeDPEMIcI
         g5UzV5B2lEOUNjg1OVznsUNeenSFetw0HcCGVvgeUeot9xLOcxoxjH4VQsxFgOUGrjJj
         CwZbG8LI9Dy852NzpIMt+H4qE5wdZ6r/uXcl9dlF/bexgLNkaWwtieAcwEwcf5J4lIAq
         ag0UO2bYLIW4zWuTD7T3cLiCS79xbWNM7HkUOrvt5lb7IUpvSETV0YQ/JlLumASLszgU
         FCxsXQGyHIY32kUdMdzXfE7aqqCBL0J6HTgzvHok3yPB6UErYREXbYIWym1g7gpMjrxQ
         IMjw==
X-Gm-Message-State: AOAM530EdOoivt4amIcVAlEkwcYX2NxRbNgcl9CHTvqKQdpNr7FrQfyX
        qlfknv75OQrxNpbOn03eX5djzNewMtJIGwswwd8ohA==
X-Google-Smtp-Source: ABdhPJxXRbAEFMJnkuQalyahRsi29VKHQOQ/y9ua8eJpe2COpjPKxb7ojZaHC0tVYKJOIWRJ4MgiqAtlbsGE/dXF41k=
X-Received: by 2002:a25:9387:0:b0:641:32bd:ba72 with SMTP id
 a7-20020a259387000000b0064132bdba72mr10938836ybm.474.1649781731047; Tue, 12
 Apr 2022 09:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com> <20220407011605.1966778-2-rananta@google.com>
 <6797f003-85f2-d1af-c106-c17091268a55@redhat.com>
In-Reply-To: <6797f003-85f2-d1af-c106-c17091268a55@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 12 Apr 2022 09:41:58 -0700
Message-ID: <CAJHc60x82Az_NeiCmPznp6aidT5ER=Gud=KfZQ07mD5w7So8cA@mail.gmail.com>
Subject: Re: [PATCH v5 01/10] KVM: arm64: Factor out firmware register
 handling from psci.c
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
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

Hi Gavin,

On Tue, Apr 12, 2022 at 12:07 AM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/7/22 9:15 AM, Raghavendra Rao Ananta wrote:
> > Common hypercall firmware register handing is currently employed
> > by psci.c. Since the upcoming patches add more of these registers,
> > it's better to move the generic handling to hypercall.c for a
> > cleaner presentation.
> >
> > While we are at it, collect all the firmware registers under
> > fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> > kvm_arm_copy_fw_reg_indices() in a generic way. Also, define
> > KVM_REG_FEATURE_LEVEL_MASK using a GENMASK instead.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > ---
> >   arch/arm64/kvm/guest.c       |   2 +-
> >   arch/arm64/kvm/hypercalls.c  | 185 +++++++++++++++++++++++++++++++++++
> >   arch/arm64/kvm/psci.c        | 183 ----------------------------------
> >   include/kvm/arm_hypercalls.h |   7 ++
> >   include/kvm/arm_psci.h       |   7 --
> >   5 files changed, 193 insertions(+), 191 deletions(-)
> >
>
> Apart from the below nits:
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 7e15b03fbdf8..0d5cca56cbda 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -18,7 +18,7 @@
> >   #include <linux/string.h>
> >   #include <linux/vmalloc.h>
> >   #include <linux/fs.h>
> > -#include <kvm/arm_psci.h>
> > +#include <kvm/arm_hypercalls.h>
> >   #include <asm/cputype.h>
> >   #include <linux/uaccess.h>
> >   #include <asm/fpsimd.h>
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 202b8c455724..fa6d9378d8e7 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -158,3 +158,188 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >       return 1;
> >   }
> > +
> > +static const u64 kvm_arm_fw_reg_ids[] = {
> > +     KVM_REG_ARM_PSCI_VERSION,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> > +};
> > +
> > +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> > +}
> > +
> > +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
> > +             if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
> > +                     return -EFAULT;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
>
> Since we're here, I think we can make this function to return 'ARRAY_SIZE(kvm_arm_fw_reg_ids)',
> to be consistent with copy_{core, sve}_reg_indices(). With the return value fixed, additional
> patch can use @ret in kvm_arm_copy_reg_indices().
>
Well we can, however, since this is mostly refactoring, I didn't want
to change the original functionality of the code.
The only caller of this is kvm_arm_copy_reg_indices()
(arch/arm64/kvm/guest.c), which only checks for 'ret < 0'.
Also, do you have a need for it? If yes, I can change it in the next revision.

> > +#define KVM_REG_FEATURE_LEVEL_WIDTH  4
> > +#define KVM_REG_FEATURE_LEVEL_MASK   GENMASK(KVM_REG_FEATURE_LEVEL_WIDTH, 0)
> > +
>
> It seems 'BIT()' is replaced with 'GENMASK' in the movement, but it's not mentioned
> in the commit log. I guess it'd better to mention it if you agree.
>
The last sentence of the commit text mentions this :)
Please let me know if it's not clear.

> > +/*
> > + * Convert the workaround level into an easy-to-compare number, where higher
> > + * values mean better protection.
> > + */
> > +static int get_kernel_wa_level(u64 regid)
> > +{
> > +     switch (regid) {
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > +             switch (arm64_get_spectre_v2_state()) {
> > +             case SPECTRE_VULNERABLE:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> > +             case SPECTRE_MITIGATED:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
> > +             case SPECTRE_UNAFFECTED:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
> > +             }
> > +             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > +             switch (arm64_get_spectre_v4_state()) {
> > +             case SPECTRE_MITIGATED:
> > +                     /*
> > +                      * As for the hypercall discovery, we pretend we
> > +                      * don't have any FW mitigation if SSBS is there at
> > +                      * all times.
> > +                      */
> > +                     if (cpus_have_final_cap(ARM64_SSBS))
> > +                             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > +                     fallthrough;
> > +             case SPECTRE_UNAFFECTED:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> > +             case SPECTRE_VULNERABLE:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > +             }
> > +             break;
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > +             switch (arm64_get_spectre_bhb_state()) {
> > +             case SPECTRE_VULNERABLE:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
> > +             case SPECTRE_MITIGATED:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
> > +             case SPECTRE_UNAFFECTED:
> > +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
> > +             }
> > +             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
> > +     }
> > +
> > +     return -EINVAL;
> > +}
> > +
> > +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > +{
> > +     void __user *uaddr = (void __user *)(long)reg->addr;
> > +     u64 val;
> > +
> > +     switch (reg->id) {
> > +     case KVM_REG_ARM_PSCI_VERSION:
> > +             val = kvm_psci_version(vcpu);
> > +             break;
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > +             val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> > +             break;
> > +     default:
> > +             return -ENOENT;
> > +     }
> > +
> > +     if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> > +             return -EFAULT;
> > +
> > +     return 0;
> > +}
> > +
> > +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > +{
> > +     void __user *uaddr = (void __user *)(long)reg->addr;
> > +     u64 val;
> > +     int wa_level;
> > +
> > +     if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> > +             return -EFAULT;
> > +
> > +     switch (reg->id) {
> > +     case KVM_REG_ARM_PSCI_VERSION:
> > +     {
> > +             bool wants_02;
> > +
> > +             wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
> > +
> > +             switch (val) {
> > +             case KVM_ARM_PSCI_0_1:
> > +                     if (wants_02)
> > +                             return -EINVAL;
> > +                     vcpu->kvm->arch.psci_version = val;
> > +                     return 0;
> > +             case KVM_ARM_PSCI_0_2:
> > +             case KVM_ARM_PSCI_1_0:
> > +             case KVM_ARM_PSCI_1_1:
> > +                     if (!wants_02)
> > +                             return -EINVAL;
> > +                     vcpu->kvm->arch.psci_version = val;
> > +                     return 0;
> > +             }
> > +             break;
> > +     }
> > +
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > +             if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
> > +                     return -EINVAL;
> > +
> > +             if (get_kernel_wa_level(reg->id) < val)
> > +                     return -EINVAL;
> > +
> > +             return 0;
> > +
> > +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > +             if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
> > +                         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
> > +                     return -EINVAL;
> > +
> > +             /* The enabled bit must not be set unless the level is AVAIL. */
> > +             if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
> > +                 (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
> > +                     return -EINVAL;
> > +
> > +             /*
> > +              * Map all the possible incoming states to the only two we
> > +              * really want to deal with.
> > +              */
> > +             switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
> > +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
> > +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
> > +                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > +                     break;
> > +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
> > +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> > +                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> > +                     break;
> > +             default:
> > +                     return -EINVAL;
> > +             }
> > +
> > +             /*
> > +              * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
> > +              * other way around.
> > +              */
> > +             if (get_kernel_wa_level(reg->id) < wa_level)
> > +                     return -EINVAL;
> > +
> > +             return 0;
> > +     default:
> > +             return -ENOENT;
> > +     }
> > +
> > +     return -EINVAL;
> > +}
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 372da09a2fab..bdfa93ca57d1 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -439,186 +439,3 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
> >               return -EINVAL;
> >       }
> >   }
> > -
> > -int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > -{
> > -     return 4;               /* PSCI version and three workaround registers */
> > -}
> > -
> > -int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > -{
> > -     if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
> > -             return -EFAULT;
> > -
> > -     if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
> > -             return -EFAULT;
> > -
> > -     if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
> > -             return -EFAULT;
> > -
> > -     if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3, uindices++))
> > -             return -EFAULT;
> > -
> > -     return 0;
> > -}
> > -
> > -#define KVM_REG_FEATURE_LEVEL_WIDTH  4
> > -#define KVM_REG_FEATURE_LEVEL_MASK   (BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
> > -
> > -/*
> > - * Convert the workaround level into an easy-to-compare number, where higher
> > - * values mean better protection.
> > - */
> > -static int get_kernel_wa_level(u64 regid)
> > -{
> > -     switch (regid) {
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > -             switch (arm64_get_spectre_v2_state()) {
> > -             case SPECTRE_VULNERABLE:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> > -             case SPECTRE_MITIGATED:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
> > -             case SPECTRE_UNAFFECTED:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
> > -             }
> > -             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > -             switch (arm64_get_spectre_v4_state()) {
> > -             case SPECTRE_MITIGATED:
> > -                     /*
> > -                      * As for the hypercall discovery, we pretend we
> > -                      * don't have any FW mitigation if SSBS is there at
> > -                      * all times.
> > -                      */
> > -                     if (cpus_have_final_cap(ARM64_SSBS))
> > -                             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > -                     fallthrough;
> > -             case SPECTRE_UNAFFECTED:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> > -             case SPECTRE_VULNERABLE:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > -             }
> > -             break;
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > -             switch (arm64_get_spectre_bhb_state()) {
> > -             case SPECTRE_VULNERABLE:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
> > -             case SPECTRE_MITIGATED:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
> > -             case SPECTRE_UNAFFECTED:
> > -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
> > -             }
> > -             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
> > -     }
> > -
> > -     return -EINVAL;
> > -}
> > -
> > -int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > -{
> > -     void __user *uaddr = (void __user *)(long)reg->addr;
> > -     u64 val;
> > -
> > -     switch (reg->id) {
> > -     case KVM_REG_ARM_PSCI_VERSION:
> > -             val = kvm_psci_version(vcpu);
> > -             break;
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > -             val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
> > -             break;
> > -     default:
> > -             return -ENOENT;
> > -     }
> > -
> > -     if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> > -             return -EFAULT;
> > -
> > -     return 0;
> > -}
> > -
> > -int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > -{
> > -     void __user *uaddr = (void __user *)(long)reg->addr;
> > -     u64 val;
> > -     int wa_level;
> > -
> > -     if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> > -             return -EFAULT;
> > -
> > -     switch (reg->id) {
> > -     case KVM_REG_ARM_PSCI_VERSION:
> > -     {
> > -             bool wants_02;
> > -
> > -             wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
> > -
> > -             switch (val) {
> > -             case KVM_ARM_PSCI_0_1:
> > -                     if (wants_02)
> > -                             return -EINVAL;
> > -                     vcpu->kvm->arch.psci_version = val;
> > -                     return 0;
> > -             case KVM_ARM_PSCI_0_2:
> > -             case KVM_ARM_PSCI_1_0:
> > -             case KVM_ARM_PSCI_1_1:
> > -                     if (!wants_02)
> > -                             return -EINVAL;
> > -                     vcpu->kvm->arch.psci_version = val;
> > -                     return 0;
> > -             }
> > -             break;
> > -     }
> > -
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
> > -             if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
> > -                     return -EINVAL;
> > -
> > -             if (get_kernel_wa_level(reg->id) < val)
> > -                     return -EINVAL;
> > -
> > -             return 0;
> > -
> > -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > -             if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
> > -                         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
> > -                     return -EINVAL;
> > -
> > -             /* The enabled bit must not be set unless the level is AVAIL. */
> > -             if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
> > -                 (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
> > -                     return -EINVAL;
> > -
> > -             /*
> > -              * Map all the possible incoming states to the only two we
> > -              * really want to deal with.
> > -              */
> > -             switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
> > -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
> > -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
> > -                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
> > -                     break;
> > -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
> > -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> > -                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
> > -                     break;
> > -             default:
> > -                     return -EINVAL;
> > -             }
> > -
> > -             /*
> > -              * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
> > -              * other way around.
> > -              */
> > -             if (get_kernel_wa_level(reg->id) < wa_level)
> > -                     return -EINVAL;
> > -
> > -             return 0;
> > -     default:
> > -             return -ENOENT;
> > -     }
> > -
> > -     return -EINVAL;
> > -}
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index 0e2509d27910..5d38628a8d04 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -40,4 +40,11 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
> >       vcpu_set_reg(vcpu, 3, a3);
> >   }
> >
> > +struct kvm_one_reg;
> > +
> > +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> > +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> > +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > +
> >   #endif
> > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > index 68b96c3826c3..6e55b9283789 100644
> > --- a/include/kvm/arm_psci.h
> > +++ b/include/kvm/arm_psci.h
> > @@ -39,11 +39,4 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
> >
> >   int kvm_psci_call(struct kvm_vcpu *vcpu);
> >
> > -struct kvm_one_reg;
> > -
> > -int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> > -int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> > -int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > -int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> > -
> >   #endif /* __KVM_ARM_PSCI_H__ */
> >
>
> Thanks,
> Gavin
Thank you for the review, Gavin.

Regards,
Raghavendra
>
