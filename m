Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D89C7A29D5
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 23:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbjIOVyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 17:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbjIOVyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 17:54:19 -0400
Received: from out-222.mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9058D139
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 14:54:12 -0700 (PDT)
Date:   Fri, 15 Sep 2023 21:54:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694814850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IRK5mFLmf/ekVrKw/W6wumPqbLTXGlC7g336g390ZFg=;
        b=HM4B49eRkbN+AztPqOtcIBPQC13taubkjpx98EkeUP/8Y+6/ptecJDrBvfnA/jQphRy9pj
        2LFFJMqKbLJ6s3StvU6XlyXPsr0+lYYUqilCc/R79wnSGIeoyFR+griit9Y7i+qyOq48ee
        oT5hUVuAEb96mZXronFcO5nwBXzvVHI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
Message-ID: <ZQTSffkkI1x5lWIG@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-9-rananta@google.com>
 <ZQTEN664F/5PzyId@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQTEN664F/5PzyId@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 08:53:16PM +0000, Oliver Upton wrote:
> Hi Raghu,
> 
> On Thu, Aug 17, 2023 at 12:30:25AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> > 
> > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > the previous patch, KVM ignores what is written by upserspace).
> 
> typo: userspace
> 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index ce7de6bbdc967..39ad56a71ad20 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> >  	 * while the latter does not.
> >  	 */
> >  	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
> > +	kvm->arch.pmcr_n_limit = arm_pmu->num_events - 1;
> 
> Can't we just get at this through the arm_pmu instance rather than
> copying it into kvm_arch?
> 
> >  	return 0;
> >  }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2075901356c5b..c01d62afa7db4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> >  	return 0;
> >  }
> >  
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> > +		    u64 val)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	u64 new_n, mutable_mask;
> > +	int ret = 0;
> > +
> > +	new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > +
> > +	mutex_lock(&kvm->arch.config_lock);
> > +	if (unlikely(new_n != kvm->arch.pmcr_n)) {
> > +		/*
> > +		 * The vCPU can't have more counters than the PMU
> > +		 * hardware implements.
> > +		 */
> > +		if (new_n <= kvm->arch.pmcr_n_limit)
> > +			kvm->arch.pmcr_n = new_n;
> > +		else
> > +			ret = -EINVAL;
> > +	}
> 
> Hmm, I'm not so sure about returning an error here. ABI has it that
> userspace can write any value to PMCR_EL0 successfully. Can we just
> ignore writes that attempt to set PMCR_EL0.N to something higher than
> supported by hardware? Our general stance should be that system register
> fields responsible for feature identification are immutable after the VM
> has started.

I hacked up my reply and dropped some context; this doesn't read right.
Shaoqin made the point about preventing changes to PMCR_EL0.N after the
VM has started and I firmly agree. The behavior should be:

 - Writes to PMCR always succeed

 - PMCR_EL0.N values greater than what's supported by hardware are
   ignored

 - Changes to N after the VM has started are ignored.

-- 
Thanks,
Oliver
