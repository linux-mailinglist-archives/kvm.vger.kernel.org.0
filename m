Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B496638D2
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 06:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjAJFw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 00:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjAJFwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 00:52:06 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8383941D70
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 21:50:35 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h7so3765808pfq.4
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 21:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JOUhOZSlmXFHrfw3S1GaBPaFMlh3z5ZEWqn41g9S5Ko=;
        b=UaycJRgTsqOzVALgtWgM56Ei4nmGn5Q3uZXaA4EexEuuDjZjCiylhl2zJXf7j/oNX7
         +a/ZwP52116qTxu0kJcdU3ICt3P+LoMeY2KfkGEwOSkwnwSBSpYlF7c6uizTgVp0rsdg
         07iqzbJIv4nie+SyXz/KKrvWwO6jqNSeGGeGPhedBOvvGBZ8NljIOv9wla80O0xqvtC7
         Sl9idgpSWAO/WCn8qJMdm71A6lOwUO+uBa8t6XgomgKhDodfar6mlopAqw3SASe6cagJ
         DIp7HtYTM/P27sd9hTpm1E1+JAil0LhGqNzC8obfspIeiLWwuoOEjcSggHbbAfQ6zRBp
         6USA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOUhOZSlmXFHrfw3S1GaBPaFMlh3z5ZEWqn41g9S5Ko=;
        b=eX9wWQGBvgV+OW88WSMsKMekMxhXxpVaZZZlXyPBhA4FulHklrrB8khbNcnKMVY44W
         ViVqIFirEw7api0XxZUsxfhkHdskkHFy2ZmrfT9fUyiqojPEhgRSK2yLCLrTXD5BZo32
         0RRngeBIPIBXJ+V/bpQEcfp3uDrtfNNrs2C05azVMXo6hPSdTyGKVuTvnq3wgWpI0lrU
         Jx483pg3sBnPxLYOR4RmQ3RO06tFFmEsgz15QnAS5uLY74NgcYuR65zioANWQAPAFXcd
         hdxmv6SzwDdqIUlqI62m5f/v0VhDJvkaimtLg6+IfIuo5r51Hjbg+QASLHSDkG81oOic
         nauQ==
X-Gm-Message-State: AFqh2krq3y4ijtVot5qapjs48pn7ahuO8tBrFFvmxjAoxeFtl3DqFf0W
        WwXgpoG/pyAUEpWcpm0iMAXTBAVFGKyIwJJJwWP2oe0Gd0WoU9gbiCs=
X-Google-Smtp-Source: AMrXdXuiSTzgHe3ZlWnQSlCLlfsU67QOuqUdkb3Vh86x1KlYT9Dm7UrWXt5myDp5MN0bTM7uJTy2K61dylYmwPBX0eY=
X-Received: by 2002:a62:5283:0:b0:576:a748:8fa3 with SMTP id
 g125-20020a625283000000b00576a7488fa3mr5121698pfb.37.1673329834528; Mon, 09
 Jan 2023 21:50:34 -0800 (PST)
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <20221230035928.3423990-2-reijiw@google.com>
 <Y7sUggVq+D6R82qK@thinky-boi>
In-Reply-To: <Y7sUggVq+D6R82qK@thinky-boi>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 9 Jan 2023 21:50:18 -0800
Message-ID: <CAAeT=FwRO49JdANRWGJBj41ef+YyokOw6rw6VO174ESJrcKv7A@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
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

Hi Oliver,

On Sun, Jan 8, 2023 at 11:07 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Dec 29, 2022 at 07:59:22PM -0800, Reiji Watanabe wrote:
> > On vCPU reset, PMCNTEN{SET,CLR}_EL1 and PMOVS{SET,CLR}_EL1 for
> > a vCPU are reset by reset_pmu_reg(). This function clears RAZ bits
> > of those registers corresponding to unimplemented event counters
> > on the vCPU, and sets bits corresponding to implemented event counters
> > to a predefined pseudo UNKNOWN value (some bits are set to 1).
> >
> > The function identifies (un)implemented event counters on the
> > vCPU based on the PMCR_EL1.N value on the host. Using the host
> > value for this would be problematic when KVM supports letting
> > userspace set PMCR_EL1.N to a value different from the host value
> > (some of the RAZ bits of those registers could end up being set to 1).
> >
> > Fix reset_pmu_reg() to clear the registers so that it can ensure
> > that all the RAZ bits are cleared even when the PMCR_EL1.N value
> > for the vCPU is different from the host value.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 10 +---------
> >  1 file changed, 1 insertion(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c6cbfe6b854b..ec4bdaf71a15 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> >
> >  static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >  {
> > -     u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > -
> >       /* No PMU available, any PMU reg may UNDEF... */
> >       if (!kvm_arm_support_pmu_v3())
> >               return;
> >
> > -     n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > -     n &= ARMV8_PMU_PMCR_N_MASK;
> > -     if (n)
> > -             mask |= GENMASK(n - 1, 0);
> > -
> > -     reset_unknown(vcpu, r);
> > -     __vcpu_sys_reg(vcpu, r->reg) &= mask;
> > +     __vcpu_sys_reg(vcpu, r->reg) = 0;
>
> I've personally found KVM's UNKNOWN reset value to be tremendously
> useful in debugging guest behavior, as seeing that value is quite a
> 'smoking gun' IMO.
>
> Rather than zeroing the entire register, is it possible to instead
> derive the mask based on what userspace wrote to PMCR_EL1.N instead of
> what's in hardware?

Yeah, it's feasible.
Then, I am considering having KVM to clear new RAZ bits of those
registers based on the new PMCR_EL0.N value that userspace sets
when userspace updates PMCR_EL0.N, as clearing the new RAZ bits
should be done anyway by either KVM or userspace.
What do you think ?

Thank you,
Reiji
