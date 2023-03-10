Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7576F6B3417
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCJCOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCJCOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:14:35 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E815B5CC
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 18:14:34 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-17671fb717cso4400809fac.8
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 18:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678414474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UM2gsUWwVSpEQWLnAnDEt7Ju3bE40/PbNcNR4oeIX2E=;
        b=czYP0S2zC0Bfx0whBmhspkdXqQsiv9IBS1vTRpN6404GElyuNGqPG2WKbkpw4mry8p
         BRejBew2K3QtczJW2rgu/S44/8c++rZBaCifneLBH6SofnpAIvNclAZxwKRn9mzixySW
         uqUOBf03mC1k4g0ITTiUA/t6sHCJ51v80QPmSoWcgDtdNKC2S6sB0sA6Rt+THLB8xl6U
         EQU+6FT6vmYaQSkyn4mSUvff9Pz/RpKHYa/IB1R2rkkxAC383TfOSlK2Krg7UvnmUNCR
         bUr+2s9RdD6PQsJroiMxQywfRwTfj1FGGGJRZEajW4IIpE0TT4Vs6/CfyDRKWjIfFFbb
         tBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678414474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UM2gsUWwVSpEQWLnAnDEt7Ju3bE40/PbNcNR4oeIX2E=;
        b=oCheCNEJDWLKKZTJyXTeBKnOPeCOpQEfZVH4ILo9WyaYFzlJmL77JaCgSHIzPnv9nn
         6q6ZQDdlwvOZcO7dBBKdPImSzVV93apHjsVUr5tpsQQnyhdDxz1TbrpcyM2TVQMJfK69
         9Rm7MePZ8eAIwPW3jdmUgaUFWv69cUUtbf/sGrR2r69NZ0W0Mvq/Lr5EGkWvK6sG/vvM
         P+PS/p60bdJiMqz47cRAczZBn/Swgg9x12L93i5XdrbdqNcUOqEYc8VxePqH35ElMh00
         5Ffbw8HfsmdgrS0YMT2nFftXjs2iFGWhKTPdaMrxJ0oUvs6ddQ+j9fldeQ46fYHJCy21
         Hqig==
X-Gm-Message-State: AO0yUKURbAeN8IV3210M0azepzmURTaHI2TbG3a2sQVcB5keSbhW+/po
        ElwKYJanaaxQaT57KqD9RlYVkzU5g4Cc1xSNzelEwA==
X-Google-Smtp-Source: AK7set+UZWwWlbF+ncnAtRwRtYIOCwi2htXVbIVui7/Bd76qnjiQJE8YdNXuy7rPQbZmfxWyQgtgs+24KwVDHVVibCU=
X-Received: by 2002:a05:6870:5aa5:b0:175:2698:9a85 with SMTP id
 dt37-20020a0568705aa500b0017526989a85mr8465693oab.11.1678414473836; Thu, 09
 Mar 2023 18:14:33 -0800 (PST)
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-3-jingzhangos@google.com> <ZAe+XettpauZe84X@linux.dev>
In-Reply-To: <ZAe+XettpauZe84X@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 9 Mar 2023 18:14:21 -0800
Message-ID: <CAAdAUtjL-4izpM6fOu7q6OtVav3MCOUED86z-=zX4V6xoz-XsQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] KVM: arm64: Save ID registers' sanitized value per guest
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Hi Oliver,

On Tue, Mar 7, 2023 at 2:44 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Jing,
>
> On Tue, Feb 28, 2023 at 06:22:42AM +0000, Jing Zhang wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > Use the saved ones when ID registers are read by the guest or
> > userspace (via KVM_GET_ONE_REG).
> >
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Co-developed-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 12 +++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/id_regs.c          | 44 ++++++++++++++++++++++++-------
> >  arch/arm64/kvm/sys_regs.c         |  2 +-
> >  arch/arm64/kvm/sys_regs.h         |  1 +
> >  5 files changed, 50 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a1892a8f6032..5c1cec4efa37 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -245,6 +245,16 @@ struct kvm_arch {
> >        * the associated pKVM instance in the hypervisor.
> >        */
> >       struct kvm_protected_vm pkvm;
> > +
> > +     /*
> > +      * Save ID registers for the guest in id_regs[].
> > +      * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > +      * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
> > +      */
> > +#define KVM_ARM_ID_REG_NUM   56
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
> > +#define IDREG(kvm, id)               kvm->arch.id_regs[IDREG_IDX(id)]
>
> I feel like the IDREG(...) macro just obfuscates what is otherwise a
> simple array access.
>
Sure, will use array access.
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
> > +{
> > +     if (sysreg_visible_as_raz(vcpu, r))
> > +             return 0;
> > +
> > +     return kvm_arm_read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
>
> nit: you could probably drop the '_with_encoding' suffix, as I don't
> believe there are any other flavors of accessors.
>
Yes, will do.
> > +}
> > +
> >  /* cpufeature ID register access trap handlers */
> >
> >  static bool access_id_reg(struct kvm_vcpu *vcpu,
> > @@ -504,3 +505,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> >       }
> >       return total;
> >  }
> > +
> > +/*
> > + * Set the guest's ID registers that are defined in id_reg_descs[]
> > + * with ID_SANITISED() to the host's sanitized value.
> > + */
> > +void kvm_arm_set_default_id_regs(struct kvm *kvm)
> > +{
> > +     int i;
> > +     u32 id;
> > +     u64 val;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > +             id = reg_to_encoding(&id_reg_descs[i]);
> > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > +                     /* Shouldn't happen */
> > +                     continue;
>
> Could you instead wire in a check to kvm_sys_reg_table_init() or do
> something similar to it? Benefit of going that route is we outright
> refuse to run KVM with such an egregious bug.
>
The check is already added in the first commit, which is
kvm_arm_check_idreg_table() and improved progressively in later
commits.
> > +
> > +             if (id_reg_descs[i].visibility == raz_visibility)
> > +                     /* Hidden or reserved ID register */
> > +                     continue;
>
> This sort of check works only for registers known to be RAZ at compile
> time, but not for others that depend on runtime configuration. Is it
> possible to reset the ID register values on the first call to
> KVM_ARM_VCPU_INIT?
>
> The set of configured features is available at that point so you can
> actually handle things like SVE and 32-bit ID registers correctly.
>
This function actually will be replaced with another init function as
you suggested in a later commit (6/6), which would be called in
kvm_arch_init_vm.
> --
> Thanks,
> Oliver
