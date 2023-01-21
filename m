Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A05A6763F9
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 06:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjAUFTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Jan 2023 00:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjAUFTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Jan 2023 00:19:06 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741B014208
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 21:19:05 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 207so5426755pfv.5
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 21:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DyNpUeP8LrX5RTwoNViuIdizAXn2TYK/TN88PZlHTfc=;
        b=a0fYojZF7lirCo5wfVMb07njosq2rsx8vmW9S+Ldb9CYDS2cTtGYzKjmEtuEEdk0al
         3u8Tb+qvEb7mbGw2KmB2yPHO9nbCFbtA3OB4UNkmA+LYjqt7dI9eLgcEG6JckmU1qqG9
         wS+n0Pd6LPYvn7cpE1Im0a1K8TjqkNfm4pBTU3aJqUxIQOQArev6ubYCwwknCFxPX4g1
         PJRu+mc4aTzBhBJqp0FVZG1xQuuwb6aniCkg5bw8HLur4i9mK40Gfd+SKrbGkGbqVhqK
         GZW8frOghj8bS+zND3q8QMpk3hLQEGfcWJM245l/GobI1T1fR9SmRKNsY9B4lSPcCLcJ
         eoog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyNpUeP8LrX5RTwoNViuIdizAXn2TYK/TN88PZlHTfc=;
        b=Q3/Re+uQn4qatHaTOS4M7D42C+bPOUM8gmBmL+5fO0jB6KfhkA7KkZZKdHxao/8kiP
         AgaHpjgOyH9drsfqDWAyucgFM7zVrQj+x0irwt+C4jFpNpfMnhcH2NwWq/EQEsxxkbvB
         WloHKlGhrSyzYkodfaoXhvM0B4CNK06o6ZsT3BDSwjBWmS8ddjP5YDWVIyuBZXDKHADU
         5W/+y8UQPTfM6uHmZVY4HFpooJj2KoGz/7GiZ7x1h3GjFu0waYQ998lcVwPTkr0NSp6l
         zem0wdOILEq7cKTaI+4na2Z0AoPpLad1ZXs2NiTzT3q3j5pOUFjokilRG8xqfA+BpLp3
         ff2w==
X-Gm-Message-State: AFqh2kp/FlFbonL8lfwHNegNGW1XviZ+26sY9HpnvD5+aH1GW41M0T5I
        O6HM31luzjpf5GmJh+hsTOm211a9vte4s7bemKfK6Q==
X-Google-Smtp-Source: AMrXdXsCYe+DDcM1fqeylveJWp68gFcL6rYdmUqbu1E4MOLTTk+dPezFm4XJ0IIPLgsSzECTRLBax6SYWJKxqolSJho=
X-Received: by 2002:a05:6a00:2992:b0:58d:b26a:6238 with SMTP id
 cj18-20020a056a00299200b0058db26a6238mr2033501pfb.84.1674278344660; Fri, 20
 Jan 2023 21:19:04 -0800 (PST)
MIME-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com> <20230117013542.371944-2-reijiw@google.com>
 <86o7qtmher.wl-maz@kernel.org> <86mt6dmh2q.wl-maz@kernel.org>
In-Reply-To: <86mt6dmh2q.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 20 Jan 2023 21:18:48 -0800
Message-ID: <CAAeT=Fx9024AEjKoROWMPxvShfGKijMgKsK4oUB=wbv-iq43BQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
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

Hi Marc,

On Fri, Jan 20, 2023 at 6:11 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 20 Jan 2023 14:04:12 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Tue, 17 Jan 2023 01:35:35 +0000,
> > Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> > > PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
> > > This function clears RAZ bits of those registers corresponding
> > > to unimplemented event counters on the vCPU, and sets bits
> > > corresponding to implemented event counters to a predefined
> > > pseudo UNKNOWN value (some bits are set to 1).
> > >
> > > The function identifies (un)implemented event counters on the
> > > vCPU based on the PMCR_EL1.N value on the host. Using the host
> > > value for this would be problematic when KVM supports letting
> > > userspace set PMCR_EL1.N to a value different from the host value
> > > (some of the RAZ bits of those registers could end up being set to 1).
> > >
> > > Fix reset_pmu_reg() to clear the registers so that it can ensure
> > > that all the RAZ bits are cleared even when the PMCR_EL1.N value
> > > for the vCPU is different from the host value.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 10 +---------
> > >  1 file changed, 1 insertion(+), 9 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index c6cbfe6b854b..ec4bdaf71a15 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> > >
> > >  static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > >  {
> > > -   u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > > -
> > >     /* No PMU available, any PMU reg may UNDEF... */
> > >     if (!kvm_arm_support_pmu_v3())
> > >             return;
> >
> > Is this still true? We remove the PMCR_EL0 access just below.
> >
> > >
> > > -   n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > > -   n &= ARMV8_PMU_PMCR_N_MASK;
> > > -   if (n)
> > > -           mask |= GENMASK(n - 1, 0);
> > > -
> > > -   reset_unknown(vcpu, r);
> > > -   __vcpu_sys_reg(vcpu, r->reg) &= mask;
> > > +   __vcpu_sys_reg(vcpu, r->reg) = 0;
> > >  }
> >
> > At the end of the day, this function has no dependency on the host at
> > all, and only writes 0 to the per-vcpu register.
> >
> > So why not get rid of it altogether and have:
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c6cbfe6b854b..1d1514b89d75 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -976,7 +976,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> >
> >  #define PMU_SYS_REG(r)                                               \
> > -     SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
> > +     SYS_DESC(r), .visibility = pmu_visibility
> >
> >  /* Macro to expand the PMEVCNTRn_EL0 register */
> >  #define PMU_PMEVCNTR_EL0(n)                                          \
> >
> > which would fall-back the specified reset value (zero by default)?
>
> Scratch that, we need:
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c6cbfe6b854b..6f6a928c92ec 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -976,7 +976,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>           trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
>
>  #define PMU_SYS_REG(r)                                         \
> -       SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
> +       SYS_DESC(r), .reset = reset_val, .visibility = pmu_visibility
>
>  /* Macro to expand the PMEVCNTRn_EL0 register */
>  #define PMU_PMEVCNTR_EL0(n)                                            \
>
> But otherwise, this should be enough.

Yes, that's true.  I will fix that in v3.

Thank you!
Reiji
