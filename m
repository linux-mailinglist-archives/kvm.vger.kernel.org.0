Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1BD683911
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjAaWKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjAaWKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:10:06 -0500
Received: from out-92.mta0.migadu.com (out-92.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0AF5A824
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 14:10:04 -0800 (PST)
Date:   Tue, 31 Jan 2023 22:09:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675203002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S8R6dRX63xPA5DjHb6DqdmOndQN9/0JU0PO7uTkzMT8=;
        b=qVKIj7kinVwdF8Mibg20xjp5SP+3XncPl/VnhOIgFPsIBFPYg/Wz5LjiPw+76hW9D15kgF
        Ur4P2Iy1ZGUoCMTWQ0qf78aJW7g0mkBlzvbdXLQysDmtpe/HfOwi/Hxc6N44OzTF/GbT+a
        AB+Pi6Gh/Wwxb+QGWsfKEmXSbtyxhoM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 09/69] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2
 to sane values
Message-ID: <Y9mRsWbKVi4sEit5@google.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-10-maz@kernel.org>
 <Y9l3bofl5nMWy3wZ@google.com>
 <87zg9ycqdj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zg9ycqdj.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 10:04:40PM +0000, Marc Zyngier wrote:
> On Tue, 31 Jan 2023 20:17:50 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Jan 31, 2023 at 09:24:04AM +0000, Marc Zyngier wrote:
> > > From: Christoffer Dall <christoffer.dall@arm.com>
> > > 
> > > The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
> > > let's be nice to a guest hypervisor behaving foolishly and reset these
> > > to something reasonable anyway.
> > 
> > Must we be so kind? :)
> > 
> > In all seriousness, I've found the hexspeak value of reset_unknown() to
> > be a rather useful debugging aid. And I can promise you that I'll use NV
> > to debug my own crap changes!
> > 
> > Any particular reason against just using reset_unknown()?
> 
> Because debugging NV itself is hell when all you have is a model!

Blech!

> As we were trying to debug the early code base, we really wanted to
> make it easy to run tiny guests without much setup, and work out of
> the box. That's how this sort of changes came about.
> 
> In any case, something like this the hack below works as well (I just
> booted an L1 and a couple of L2s with it, and nothing caught fire).

LGTM, mind squashing it into the previous patch?

-- 
Thanks,
Oliver

> 	M.
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 924afc40ab8b..c1016a35a996 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -924,16 +924,6 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), MPIDR_EL1);
>  }
>  
> -static void reset_vmpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> -{
> -	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), VMPIDR_EL2);
> -}
> -
> -static void reset_vpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> -{
> -	vcpu_write_sys_reg(vcpu, read_cpuid_id(), VPIDR_EL2);
> -}
> -
>  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>  				   const struct sys_reg_desc *r)
>  {
> @@ -2678,8 +2668,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
>  	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
>  
> -	EL2_REG(VPIDR_EL2, access_rw, reset_vpidr, 0),
> -	EL2_REG(VMPIDR_EL2, access_rw, reset_vmpidr, 0),
> +	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
> +	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
>  	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
>  	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
> 
> -- 
> Without deviation from the norm, progress is not possible.
