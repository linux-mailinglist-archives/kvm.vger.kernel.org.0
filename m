Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC67B8621
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 19:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbjJDRIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 13:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243548AbjJDRIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 13:08:43 -0400
Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [IPv6:2001:41d0:203:375::c5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497D895
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 10:08:40 -0700 (PDT)
Date:   Wed, 4 Oct 2023 17:08:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696439317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oxEbMZBN/i2VVwJjFBHaIQZhAFMYiYRDjGSEG1mONFg=;
        b=g5COsr582BwuSWvweC4vNOp9mxwo086nOLt3za/MgcIK1zVlcEJysTG8w1byOMk2WlrEBx
        GAkUn0pUtqPd6CZfeOGhY+wZO4fEEVfvOUaQWpZ1uHKnjp5tOLrOssMK4HTkLrrgCOhM71
        NgYC7UaZiqnh8vYUhu41xaEdLJMzMyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v11 05/12] KVM: arm64: Bump up the default KVM sanitised
 debug version to v8p8
Message-ID: <ZR2cEYQLrPCStcgy@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
 <20231003230408.3405722-6-oliver.upton@linux.dev>
 <86pm1uojcn.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pm1uojcn.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 09:57:44AM +0100, Marc Zyngier wrote:
> On Wed, 04 Oct 2023 00:04:01 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Since ID_AA64DFR0_EL1 and ID_DFR0_EL1 are now writable from userspace,
> > it is safe to bump up the default KVM sanitised debug version to v8p8.
> > 
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> The SoB sequence looks odd. Either you're the author, and Jing's SoB
> shouldn't be there without a Co-DB tag, or you've lost Jing's
> attribution (which sometimes happens when rebasing and squashing
> patches together).

This is an artifact of me applying Jing's version of the series and
hacking on top of it.

> > ---
> >  arch/arm64/kvm/sys_regs.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 8fbfe61fe7bc..b342c96e08f4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1496,8 +1496,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >  {
> >  	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> >  
> > -	/* Limit debug to ARMv8.0 */
> > -	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, IMP);
> > +	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
> >  
> >  	/*
> >  	 * Only initialize the PMU version if the vCPU was configured with one.
> > @@ -1557,6 +1556,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >  	if (kvm_vcpu_has_pmu(vcpu))
> >  		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
> >  
> > +	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
> > +
> 
> For consistency, you should also repaint DBGDIDR, which has a
> hardcoded '6' (ARMv8) as the supported debug version.

Ah, good point. I'll extract the value from the ID register much like we
do for other fields in DBGDIDR:

commit b92565ca433f611ea0901a6098d72f91be84cdb0
Author: Oliver Upton <oliver.upton@linux.dev>
Date:   Wed Oct 4 17:03:17 2023 +0000

    KVM: arm64: Advertise selected DebugVer in DBGDIDR.Version
    
    Much like we do for other fields, extract the Debug architecture version
    from the ID register to populate the corresponding field in DBGDIDR.
    Rewrite the existing sysreg field extractors to use SYS_FIELD_GET() for
    consistency.
    
    Suggested-by: Marc Zyngier <maz@kernel.org>
    Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cf1b2def53db..57c8190d5438 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2510,12 +2510,13 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	} else {
 		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
 		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
-		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
+		u32 el3 = !!SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr);
 
-		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
-			     (((dfr >> ID_AA64DFR0_EL1_BRPs_SHIFT) & 0xf) << 24) |
-			     (((dfr >> ID_AA64DFR0_EL1_CTX_CMPs_SHIFT) & 0xf) << 20)
-			     | (6 << 16) | (1 << 15) | (el3 << 14) | (el3 << 12));
+		p->regval = ((SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr) << 28) |
+			     (SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr) << 24) |
+			     (SYS_FIELD_GET(ID_AA64DFR0_EL1, CTX_CMPs, dfr) << 20) |
+			     (SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, dfr) << 16) |
+			     (1 << 15) | (el3 << 14) | (el3 << 12));
 		return true;
 	}
 }

-- 
Thanks,
Oliver
