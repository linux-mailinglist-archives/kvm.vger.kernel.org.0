Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FDE7CCA63
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbjJQSLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjJQSLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:11:04 -0400
Received: from out-199.mta0.migadu.com (out-199.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7FF93
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:11:01 -0700 (PDT)
Date:   Tue, 17 Oct 2023 18:10:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697566259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ble/vKiEcpM72A7rR+OClTCj96F4vXSttqGzdO7ZD1c=;
        b=oPq/EYmfHdlh036e6RWnrEtArG16BZIDe5PDwfwTVTKKB6ijtLpxWKk3qLhZ1if0XQdp2p
        g/cssnyCW7z4DRWItbStBeVDeOLuSNvAIskBgpNdOwK7tZp0/RGo4tTrLX/NQS/hhhEaH5
        9WFFubE7ueM5bThbHHz39o5JCFcn0fA=
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
Message-ID: <ZS7OLRy6BwJljOV8@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
 <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev>
 <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev>
 <CAJHc60zQb0akx2Opbh3_Q8JShBC_9NFNvtAE+bPNi9QqXUGncA@mail.gmail.com>
 <ZS6_tdkS6GyNlt4l@linux.dev>
 <CAJHc60w-CsqdYX8JG-CRutwg0UyWmvk1TyoR-y9JBV_mqWUVKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60w-CsqdYX8JG-CRutwg0UyWmvk1TyoR-y9JBV_mqWUVKw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 10:25:50AM -0700, Raghavendra Rao Ananta wrote:
> On Tue, Oct 17, 2023 at 10:09 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Tue, Oct 17, 2023 at 09:58:08AM -0700, Raghavendra Rao Ananta wrote:
> > > On Mon, Oct 16, 2023 at 10:52 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > >
> > > > On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrote:
> > > >
> > > > [...]
> > > >
> > > > > > What's the point of doing this in the first place? The implementation of
> > > > > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped value.
> > > > > >
> > > > > I guess originally the change replaced read_sysreg(pmcr_el0) with
> > > > > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > > > > But if you and Sebastian feel that it's an overkill and directly
> > > > > getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> > > > > happy to make the change.
> > > >
> > > > No, I'd rather you delete the line where PMCR_EL0.N altogether.
> > > > reset_pmcr() tries to initialize the field, but your
> > > > kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
> > > >
> > > I didn't get this comment. We still do initialize pmcr, but using the
> > > pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
> > > register.
> >
> > You have two bits of code trying to do the exact same thing:
> >
> >  1) reset_pmcr() initializes __vcpu_sys_reg(vcpu, PMCR_EL0) with the N
> >     field set up.
> >
> >  2) kvm_vcpu_read_pmcr() takes whatever is in __vcpu_sys_reg(vcpu, PMCR_EL0),
> >     *masks out* the N field and re-initializes it with vcpu->kvm->arch.pmcr_n
> >
> > Why do you need (1) if you do (2)?
> >
> Okay, I see what you mean now. In that case, let reset_pmcr():
> - Initialize 'pmcr' using  vcpu->kvm->arch.pmcr_n
> - Set ARMV8_PMU_PMCR_LC as appropriate in 'pmcr'
> - Write 'pmcr' to the vcpu reg
> 
> From here on out, kvm_vcpu_read_pmcr() would read off of this
> initialized value, unless of course, userspace updates the pmcr.n.
> Is this the flow that you were suggesting?

Just squash this in:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d1db1f292645..7b54c7843bef 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -743,10 +743,8 @@ static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 pmcr;
+	u64 pmcr = 0;
 
-	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 

-- 
Thanks,
Oliver
