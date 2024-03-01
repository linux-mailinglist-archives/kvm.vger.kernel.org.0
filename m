Return-Path: <kvm+bounces-10691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92EE686EA25
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 21:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F99F1C24039
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F553C47A;
	Fri,  1 Mar 2024 20:15:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E783C6A4
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709324155; cv=none; b=lTOqKw+6DGPArQqDntQfWqH0frZ5iC/CjV428bKKMEbHKmKpFQAg8QJDaY0peUutAXJ6y/X/LCchdqendlRjF2VecKffg+VGXHlrlFWi4LIKp4k0fXzRgkCdSAu3OhhPlWXTc1448R+v6pVmyID1jNHC3f+dbR+E3oz1cGNRyTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709324155; c=relaxed/simple;
	bh=bE1H3ZR3mcE6l2fGWaCh+j6K68SoFInxbaR7he+rkdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6czQ7+Kyjs4xhuLSWyHVe+6aKQqux0eCsMfLMU/gTtN9b+CZEu+fBsM5kJR+FwgxuGmi91+F+r7KRe/bToWK37lxLMovhGZYQ/bqOlv4mSkuy/rQzlIjhPbLIGDdIX7pv0RC5hvgK0PWA2a7PT5qXg7z/7ZZqMXQC2a/yNUK/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 247511FB;
	Fri,  1 Mar 2024 12:16:29 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CBAB3F73F;
	Fri,  1 Mar 2024 12:15:49 -0800 (PST)
Date: Fri, 1 Mar 2024 20:15:43 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 07/13] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
Message-ID: <20240301201543.GA3968751@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-8-maz@kernel.org>
 <20240301180734.GA3958355@e124191.cambridge.arm.com>
 <861q8t3guf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861q8t3guf.wl-maz@kernel.org>

On Fri, Mar 01, 2024 at 07:14:00PM +0000, Marc Zyngier wrote:
> Hi Joey,
> 
> On Fri, 01 Mar 2024 18:07:34 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Got a question about this one,
> > 
> > On Mon, Feb 26, 2024 at 10:05:55AM +0000, Marc Zyngier wrote:
> > > If the L1 hypervisor decides to trap ERETs while running L2,
> > > make sure we don't try to emulate it, just like we wouldn't
> > > if it had its NV bit set.
> > > 
> > > The exception will be reinjected from the core handler.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > index eaf242b8e0cf..3ea9bdf6b555 100644
> > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > @@ -220,7 +220,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
> > >  	 * Unless the trap has to be forwarded further down the line,
> > >  	 * of course...
> > >  	 */
> > > -	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
> > > +	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
> > > +	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
> > >  		return false;
> > >  
> > >  	spsr = read_sysreg_el1(SYS_SPSR);
> > 
> > Are we missing a forward_traps() call in kvm_emulated_nested_eret() for the
> > HFGITR case?
> > 
> > Trying to follow the code path here, and I'm unsure of where else the
> > HFIGTR_EL2_ERET trap would be forwarded:
> > 
> > kvm_arm_vcpu_enter_exit ->
> > 	ERET executes in guest
> > 	fixup_guest_exit ->
> > 		kvm_hyp_handle_eret (returns false)
> > 
> > handle_exit ->
> > 	kvm_handle_eret ->
> > 		kvm_emulated_nested_eret
> > 			if HCR_NV
> > 				forward traps
> > 			else
> > 				emulate ERET
> 
> There's a bit more happening in kvm_handle_eret().
> 
> > 
> > 
> > And if the answer is that it is being reinjected somewhere, putting that
> > function name in the commit instead of 'core handler' would help with
> > understanding!
> 
> Let's look at the code:
> 
> 	static int kvm_handle_eret(struct kvm_vcpu *vcpu)
> 	{
> 		[...]
> 	
> 		if (is_hyp_ctxt(vcpu))
> 			kvm_emulate_nested_eret(vcpu);
> 
> If we're doing an ERET from guest EL2, then we just emulate it,
> because there is nothing else to do. Crucially, HFGITR_EL2.ERET
> doesn't apply to EL2.
> 
> 		else
> 			kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> 
> In any other case, we simply reinject the trap into the guest EL2,
> because that's the only possible outcome. And that's what you were
> missing.
> 
> 		return 1;
> 	}
> 	

Thanks, that makes sense now! I was forgetting about the crucial fact that
HFGITR_EL2.ERET applies to EL1, which is !is_hyp_ctxt(), so we take the other
branch.

With that cleared up:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> 
> > I need to find the time to get an NV setup set-up, so I can do some experiments
> > myself.
> 
> The FVP should be a good enough environment if you can bare the
> glacial speed. Other than that, I hear that QEMU has grown some NV
> support lately, but I haven't tried it yet. HW-wise, M2 is the only
> machine that can be bought by a human being (everything else is
> vapourware, or they would have already taken my money).
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

