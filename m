Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7097C7CB339
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjJPTQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJPTQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:16:05 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B9C9F
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:16:02 -0700 (PDT)
Date:   Mon, 16 Oct 2023 19:15:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697483760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aNCjn8kZsLzkn2TfATd/Tc8lLJ9tbwTjRnLW2H/5Bjc=;
        b=NRdd9h+VWrbgIUGM4R3jmxHqx88SFaakKg/7Te5xg/KGj1dAwk2Z6vmwxV3StaAY887AG4
        JAJDTMNcwD4JpEoRrSLACsOhXablsrOtCuDdYSzxS7J4sCXa7Zbshj5rPOjdvqdXd2h8Co
        mexLF+4BOrVRGGYNMsbrRQ97E0sEBGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
Message-ID: <ZS2L6uIlUtkltyrF@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
 <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 12:02:27PM -0700, Raghavendra Rao Ananta wrote:
> On Mon, Oct 16, 2023 at 6:35 AM Sebastian Ott <sebott@redhat.com> wrote:
> >
> > On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > > u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> > > {
> > > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > +     u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> > > +
> > > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> > > }
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index ff0f7095eaca..c750722fbe4a 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > > {
> > >       u64 pmcr;
> > >
> > > -     /* No PMU available, PMCR_EL0 may UNDEF... */
> > > -     if (!kvm_arm_support_pmu_v3())
> > > -             return 0;
> > > -
> > >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > > -     pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> > > +     pmcr = kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> >
> > pmcr = ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> > Would that maybe make it more clear what is done here?
> >
> Since we require the entire PMCR register, and not just the PMCR.N
> field, I think using kvm_vcpu_read_pmcr() would be technically
> correct, don't you think?

No, this isn't using the entire PMCR value, it is just grabbing
PMCR_EL0.N.

What's the point of doing this in the first place? The implementation of
kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped value.

-- 
Thanks,
Oliver
