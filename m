Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135587CD505
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 09:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbjJRHFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 03:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344581AbjJRHFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 03:05:12 -0400
Received: from out-201.mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF47FA
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 00:05:08 -0700 (PDT)
Date:   Wed, 18 Oct 2023 07:05:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697612706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TPkWzURlXqNO3Jdfyg8dZtOx24VKCQt6HkN8xUCCTA0=;
        b=WAge37IEZTIiqaajtmbd5vjDKip/5NIyfNRuDmAXbMn+G2QEaKbcy1XxndmPkW+qUQpoXt
        qGD3yoZlosu00eu6xWbmZReIjTMh0ogYfR3sLkoMEwpeifp3goLFV2fzJPI8doqrqbrjZH
        IkNWVs0NYmoVPJQELeewveYdUBQpshs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Restore the stage-2 context in VHE's
 __tlb_switch_to_host()
Message-ID: <ZS-DnsM4JFXZ7a_H@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
 <20231012205422.3924618-3-oliver.upton@linux.dev>
 <5563bffd-0b27-ac95-9e87-24f5b8c71fb7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5563bffd-0b27-ac95-9e87-24f5b8c71fb7@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 03:00:42PM +0800, Zenghui Yu wrote:
> On 2023/10/13 4:54, Oliver Upton wrote:
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > An MMU notifier could cause us to clobber the stage-2 context loaded on
> > a CPU when we switch to another VM's context to invalidate. This isn't
> > an issue right now as the stage-2 context gets reloaded on every guest
> > entry, but is disastrous when moving __load_stage2() into the
> > vcpu_load() path.
> > 
> > Restore the previous stage-2 context on the way out of a TLB
> > invalidation if we installed something else. Deliberately do this after
> > TGE=1 is synchronized to keep things safe in light of the speculative AT
> > errata.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/vhe/tlb.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> > index f3f2e142e4f4..ef21153ce5fa 100644
> > --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> > @@ -11,18 +11,25 @@
> >  #include <asm/tlbflush.h>
> >  struct tlb_inv_context {
> > -	unsigned long	flags;
> > -	u64		tcr;
> > -	u64		sctlr;
> > +	struct kvm_s2_mmu	*mmu;
> > +	unsigned long		flags;
> > +	u64			tcr;
> > +	u64			sctlr;
> >  };
> >  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
> >  				  struct tlb_inv_context *cxt)
> >  {
> > +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> >  	u64 val;
> >  	local_irq_save(cxt->flags);
> > +	if (vcpu && mmu != vcpu->arch.hw_mmu)
> > +		cxt->mmu = mmu;
> 
> Shouldn't this be
> 
> cxt->mm = vcpu->arch.hw_mmu (the "previous" S2 context)?

It absolutely should, and Marc had it right the first time.

-- 
Thanks,
Oliver
