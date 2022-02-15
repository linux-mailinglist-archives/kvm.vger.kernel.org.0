Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90C54B77A9
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiBOUYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 15:24:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBOUYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 15:24:30 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9430F1052BB
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 12:24:19 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i6so195358pfc.9
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 12:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuj8MtZiCZ0Lx7DBYb6yz01ZBRhvgxdg2lUl/zU+F6E=;
        b=F2tjYTu3204GP0Z5o5QyWoyBsYLUrrQbbXjjnHfIRCm4Mat4wvsB3Qzlu1x37bvd3p
         ekBrhI2Dco1JbjJcj+7EmWNcirqDVS4dpZ/IatzkIQwSH1gipIe6klukwC2cDNu2HLy1
         xkOZqO+8NKK3VdSxTYi3lt+EuOHFZ821DqL8og503gcMFIp0GSMx7NglBOv1f2ILrsJi
         HozYH5FZ/c8w0YSRxXc1tuGAn84L1fdw3H+GKos2Dj+ou7+lwpn/xjbPA3FPxAfe9upu
         uT+ykjgcSh/d9nlzsauiqjLn3Q/3KT32HkVU7ed0t9e8BxRyT+kuHOsiNALUZyCtB5rL
         3pbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuj8MtZiCZ0Lx7DBYb6yz01ZBRhvgxdg2lUl/zU+F6E=;
        b=MpDKiM7FQk798BV6DXu3/VAYb18OhaZXv7zQC7nsBbvNBnowP7qWwlKfBmC+3yOjDK
         dq7UZhX2/XkrFh+Ggs8GZEKxtoi/pkpj8RmMSE6hRlAlE8OUqukAtfqzZDok4Y0WQ9aM
         /JnEiKJHUPwgV3Ytk57ToI8/iFVhdlcXDnHRC/zNJ68qnhxKMmwkTCUsjCLmwjrdHlQ9
         rCtUXBn5ERuBqnHrV/sMndEL5WR6qRz4icOEIYJmnY1Ben5dQAhYKjdvx6ey5aUd3YU3
         ALSX0t5cQ2hHQ2j35smTTgebRo6KRceu0oBT6Enc6xZw9iWB/AEA7QNGDjdjR55Q3R4R
         2eoA==
X-Gm-Message-State: AOAM531BRigezJTPZZZQAip3ccMohxuvbMIz9e7Smfkg+9epRQ9qV26Z
        O60Bg/GIfAO3MEjKjP7OqiKsEhPi+ko5BpzIWWYrLEgVY/uLng==
X-Google-Smtp-Source: ABdhPJwBHHiPnHNUy6seRtqhk/mvMIeHpjYcsa1WSVFlqUGHC6xAUb+jkxyLvyjFKU7X2vr/JyLAaZJUvuWL0JxMtig=
X-Received: by 2002:a63:2b4d:: with SMTP id r74mr512427pgr.514.1644956658930;
 Tue, 15 Feb 2022 12:24:18 -0800 (PST)
MIME-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com> <20220214065746.1230608-10-reijiw@google.com>
 <Ygv2wS8qdlu1YnA6@google.com>
In-Reply-To: <Ygv2wS8qdlu1YnA6@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 15 Feb 2022 12:24:02 -0800
Message-ID: <CAAeT=FyGPdpBuS_-StugLMkrwX2XrypB5ZktdsjX78K8P6khuQ@mail.gmail.com>
Subject: Re: [PATCH v5 09/27] KVM: arm64: Make ID_AA64MMFR1_EL1 writable
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
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

Hi Oliver,

On Tue, Feb 15, 2022 at 10:53 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Feb 13, 2022 at 10:57:28PM -0800, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_AA64MMFR1_EL1 to make it
> > writable by userspace.
> >
> > Hardware update of Access flag and/or Dirty state in translation
> > table needs to be disabled for the guest to let userspace set
> > ID_AA64MMFR1_EL1.HAFDBS field to a lower value. It requires trapping
> > the guest's accessing TCR_EL1, which KVM doesn't always do (in order
> > to trap it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which
> > also traps many other virtual memory control registers).
> > So, userspace won't be allowed to modify the value of the HAFDBS field.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 4ed15ae7f160..1c137f8c236f 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -570,6 +570,30 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
> > +                                  const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     u64 limit = id_reg->vcpu_limit_val;
> > +     unsigned int hafdbs, lim_hafdbs;
> > +
> > +     hafdbs = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_HADBS_SHIFT);
> > +     lim_hafdbs = cpuid_feature_extract_unsigned_field(limit, ID_AA64MMFR1_HADBS_SHIFT);
> > +
> > +     /*
> > +      * Don't allow userspace to modify the value of HAFDBS.
> > +      * Hardware update of Access flag and/or Dirty state in translation
> > +      * table needs to be disabled for the guest to let userspace set
> > +      * HAFDBS field to a lower value. It requires trapping the guest's
> > +      * accessing TCR_EL1, which KVM doesn't always do (in order to trap
> > +      * it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which also
> > +      * traps many other virtual memory control registers).
> > +      */
> > +     if (hafdbs != lim_hafdbs)
> > +             return -EINVAL;
>
> Are we going to require that any hidden feature be trappable going
> forward? It doesn't seem to me like there's much risk to userspace
> hiding any arbitrary feature so long as identity remains architectural.

That wasn't my intention, and I will drop this patch.
(I wonder why I thought this was needed...)

Thank you for catching this !

Regards,
Reiji

>
> Another example of this is AArch32 at EL0. Without FGT, there is no
> precise trap for KVM to intervene and prevent an AArch32 EL0.
> Nonetheless, userspace might still want to hide this from its guests
> even if a misbehaved guest could still use it.
>
> --
> Thanks,
> Oliver
