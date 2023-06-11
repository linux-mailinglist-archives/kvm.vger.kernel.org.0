Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F48F72B0A6
	for <lists+kvm@lfdr.de>; Sun, 11 Jun 2023 09:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjFKHrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 03:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjFKHra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 03:47:30 -0400
Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com [IPv6:2001:41d0:203:375::27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7671BB
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 00:47:28 -0700 (PDT)
Date:   Sun, 11 Jun 2023 00:47:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686469646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1NGpbUo/gM6H6eBSE2EH01L3jc1cZA5mb5MGiUOMt4=;
        b=chuldjFfWrSHCn+IgRls2M2SAZtSMWKB289cK9WZI/741ov09YbIEe1ksnfAUlyHH+Y5Sg
        IxSnB7y6uMMBqNjc2SsFgc8MuILd+HyqMKDAowvVVW4Dnj+pmGA8nPcnCeZm1eVkGm19Ah
        EQQxN43X3yphskIkWjUp2+6A72X38BQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <ZIV7+yKUdRticwfF@linux.dev>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230611045430.evkcp4py4yuw5qgr@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 10, 2023 at 09:54:30PM -0700, Reiji Watanabe wrote:
> On Sat, Jun 10, 2023 at 05:57:34PM -0700, Oliver Upton wrote:
> > Hi Reiji,
> > 
> > On Sat, Jun 10, 2023 at 12:45:10PM -0700, Reiji Watanabe wrote:
> > > @@ -735,7 +736,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
> > >  		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
> > >  		 * as RAZ
> > >  		 */
> > > -		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
> > > +		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
> > >  			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
> > 
> > I don't think this conditional masking is correct in the first place,
> 
> I'm not sure why this conditional masking is correct.
> Could you please elaborate ?

On second thought, the original code works, but for a rather non-obvious
reason. I was concerned about the case where kvm->arch.arm_pmu->pmuver does
not match the current CPU, but as you say we hide PMU from the guest in this
case.

My concern remains, though, for the proposed fix.

> > and this change would only make it worse.
> > 
> > We emulate reads of PMCEID1_EL0 using the literal value of the CPU. The
> > _advertised_ PMU version has no bearing on the core PMU version. So,
> > assuming we hit this on a v3p5+ part with userspace (stupidly)
> > advertising an older implementation level, we never clear the bit for
> > STALL_SLOT.
> 
> I'm not sure if I understand this comment correctly.
> When the guest's PMUVer is older than v3p4, I don't think we need
> to clear the bit for STALL_SLOT, as PMMIR_EL1 is not implemented
> for the guest (PMMIR_EL1 is implemented only on v3p4 or newer).
> Or am I missing something ?

The guest's PMU version has no influence on the *hardware* value of
PMCEID1_EL0.

Suppose KVM is running on a v3p5+ implementation, but userspace has set
ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
the preceding line would advertise the STALL_SLOT event, and KVM fails
to mask it due to the ID register value. The fact we do not support the
event is an invariant, and in the worst case we wind up clearing a bit
that's already 0.

This is why I'd suggested just unconditionally clearing the bit. While
we're on the topic, doesn't the same reasoning hold for
STALL_SLOT_{FRONTEND,BACKEND}? We probably want to hide those too.

--
Thanks,
Oliver
