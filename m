Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB95A3572
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 09:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiH0HJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 03:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiH0HJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 03:09:48 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F155CF8
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 00:09:44 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id e3so1293076uax.4
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 00:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hOP43ttmkQC9HNoIqURH8XQ98joZKhQ/WbmApXVIzDI=;
        b=cc+De/pHnnseJwJ1fzFU/Jo0du7DszIyB4BPIb3YqH+GyvN57Vn7KVJHwIPHpdIrde
         YIj3FMJCKey9bHezR33TLtCqi5U8+C/5E8VNNd4gHMO8iwtrotv4DIuI07Bp5RBMqLrL
         hA2gVVYsfKxn0zu6nBempwFGWgJbV/kulmHv0WPguyM8pC6Cw7pXWn4ro4riXkh66R7n
         j5AA+dF4oaUa7YVXw3DwY26//92ToWPjIJLD1pi7pTzlcTxD24N4w5DGgWw4vS0eNtIV
         Dtfe1DhquPeJgWvdg5keb3MFDY3h/LRyzdl8jahYO89woRQNBSzAQo/EbXoUQPtQZR2C
         7GdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hOP43ttmkQC9HNoIqURH8XQ98joZKhQ/WbmApXVIzDI=;
        b=ATZaqTTARGAeP47fqkbUewiwFCVFAuqYTElj2OW2Mv+JOMFJFArfhyZY3wUfmzXctw
         y4nwB5e3xc367tGT/MDZgoLXoD1XgCTd66yDGZVN0JsERXNr9rYZkcPe/JQDYGgSaASv
         FHDu/v3sU62cLABzzylpF9jnxifM3y4MeBttZ9oDPbDgpIAIgiE1i3n1nJdmewtuu/Mz
         FE+rPke9Rsys3Q3yMrwHbo0eQYTSTE1ldSUN2q1C9uro/XuoYy4uH/9YQd+om1hBvXZj
         RxPBAg97UO4IkvmI4vDiCTHzvRidtusYi/bWPsVy5/re8+LBLZhjIz+DT9LNP/4Ku9t+
         Ic/Q==
X-Gm-Message-State: ACgBeo0d+GWn2exnC5KOc33SPSMEXHvaEdnhrdQuRQDoiyZrzqgUOYKI
        fRpYuzZJclZODshvIQSxl5j8UDKuVVn9inYRX0W5hA==
X-Google-Smtp-Source: AA6agR4P7MaQO2fX5+HZrXvJcV+khsr2kac7vbPBefszN5df6rtRUpFHJZo9PakcpOptZ5eF33X4f6YvH9J8sEeOvEU=
X-Received: by 2002:ab0:32da:0:b0:39f:61f6:ef6a with SMTP id
 f26-20020ab032da000000b0039f61f6ef6amr1019646uao.106.1661584184002; Sat, 27
 Aug 2022 00:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-9-maz@kernel.org>
 <YvNbPm7WAhUCRkx/@google.com> <87sfm4v45i.wl-maz@kernel.org>
In-Reply-To: <87sfm4v45i.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 27 Aug 2022 00:09:28 -0700
Message-ID: <CAAeT=FxfWO0b8qRPc9kzjJfN1yKxXA=7VuGhWwnizZzC=BrnNA@mail.gmail.com>
Subject: Re: [PATCH 8/9] KVM: arm64: PMU: Implement PMUv3p5 long counter support
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Aug 10, 2022 at 2:28 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 10 Aug 2022 08:16:14 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hi Marc,
> >
> > On Fri, Aug 05, 2022 at 02:58:12PM +0100, Marc Zyngier wrote:
> > > PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
> > > features:
> > >
> > > - All counters are 64bit
> > >
> > > - The overflow point is controlled by the PMCR_EL0.LP bit
> > >
> > > Add the required checks in the helpers that control counter
> > > width and overflow, as well as the sysreg handling for the LP
> > > bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
> > > PMUv3p5 specific handling.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/pmu-emul.c | 8 +++++---
> > >  arch/arm64/kvm/sys_regs.c | 4 ++++
> > >  include/kvm/arm_pmu.h     | 8 ++++++++
> > >  3 files changed, 17 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index 33a88ca7b7fd..b33a2953cbf6 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -50,13 +50,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > >   */
> > >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  {
> > > -   return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > > +   return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
> > >  }
> > >
> > >  static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  {
> > > -   return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > -           __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > +   u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > +
> > > +   return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
> > > +          (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
> > >  }
> > >
> > >  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index c0595f31dab8..2b5e0ec5c100 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > >            | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);

Not directly related to this series, but using 0xdecafbad above
appears to be odd. I think that would lead the bit 3 and 5 to be
unconditionally set in the register's reset value that the guest will
initially see even on the configuration where those should be RES0.

> > >     if (!system_supports_32bit_el0())
> > >             val |= ARMV8_PMU_PMCR_LC;
> > > +   if (!kvm_pmu_is_3p5(vcpu))
> > > +           val &= ~ARMV8_PMU_PMCR_LP;
> > >     __vcpu_sys_reg(vcpu, r->reg) = val;
> > >  }
> > >
> > > @@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > >             val |= p->regval & ARMV8_PMU_PMCR_MASK;
> > >             if (!system_supports_32bit_el0())
> > >                     val |= ARMV8_PMU_PMCR_LC;
> > > +           if (!kvm_pmu_is_3p5(vcpu))
> > > +                   val &= ~ARMV8_PMU_PMCR_LP;
> > >             __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> > >             kvm_pmu_handle_pmcr(vcpu, val);
> > >             kvm_vcpu_pmu_restore_guest(vcpu);
> > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > index 6bda9b071084..846502251923 100644
> > > --- a/include/kvm/arm_pmu.h
> > > +++ b/include/kvm/arm_pmu.h
> > > @@ -89,6 +89,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> > >                     vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
> > >     } while (0)
> > >
> > > +/*
> > > + * Evaluates as true when emulating PMUv3p5, and false otherwise.
> > > + */
> > > +#define kvm_pmu_is_3p5(vcpu)                                               \
> > > +   (vcpu->kvm->arch.dfr0_pmuver >= ID_AA64DFR0_PMUVER_8_5 &&       \
> > > +    vcpu->kvm->arch.dfr0_pmuver != ID_AA64DFR0_PMUVER_IMP_DEF)
> >
> > I don't believe the IMP_DEF condition will ever evaluate to false as
> > dfr0_pmuver is sanitized at initialization and writes from userspace.
>
> Good point. That's a leftover from a previous version. I'll fix that.

With the current series, I think the dfr0_pmuver could be IMP_DEF
due to the same bug that I mentioned for the patch-6.
(https://lore.kernel.org/all/20220214065746.1230608-11-reijiw@google.com/)

Thank you,
Reiji
