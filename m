Return-Path: <kvm+bounces-21647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA6B93179B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B804D2831B6
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 15:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F07618EA96;
	Mon, 15 Jul 2024 15:30:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F5AF9EC
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721057427; cv=none; b=LS+Re9TNmhzHkUfturY715uAbbgsznwXolbPVX7G00adWODQ1nkKRBtgmzL3/SAs61VHHgV5BPI2m3HzVRTfeAeZmWliifI8+47WpJLS2PwqFJHilvwAmoKrLtBG5ctzMcMOcF8mMpFyTdj50YKrZa2PKD/pqHJ9V4qQDxArkAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721057427; c=relaxed/simple;
	bh=Ua0TixMisYOMP+2/kcGneZ3sAe3B3FbBT/ElZNVEyH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMdz0q44JfaOFTE0+FcSUFMFLaGGxRdQWeDt+8/JTO7g7Muu5+A5KVdoUvXrbANL8cuMacz2vImCcslchluZT66jzXD5KHl86X4c7yOnPagFuw2dgKIWPB8CzQ75FqmMdpsV7+PYcAG5ipAyvVKKAle9dKZecvvyAJUtvptrZzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49991FEC;
	Mon, 15 Jul 2024 08:30:49 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89C843F766;
	Mon, 15 Jul 2024 08:30:22 -0700 (PDT)
Date: Mon, 15 Jul 2024 16:30:19 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZpVAi3dqOOysMMnE@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
 <Zo+6TYIP3FNssR/b@arm.com>
 <874j8wp1hx.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874j8wp1hx.wl-maz@kernel.org>

Hi Marc,

On Thu, Jul 11, 2024 at 01:16:42PM +0100, Marc Zyngier wrote:
> On Thu, 11 Jul 2024 11:56:13 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
> > > In order to plug the brokenness of our current AT implementation,
> > > we need a SW walker that is going to... err.. walk the S1 tables
> > > and tell us what it finds.
> > > 
> > > Of course, it builds on top of our S2 walker, and share similar
> > > concepts. The beauty of it is that since it uses kvm_read_guest(),
> > > it is able to bring back pages that have been otherwise evicted.
> > > 
> > > This is then plugged in the two AT S1 emulation functions as
> > > a "slow path" fallback. I'm not sure it is that slow, but hey.
> > > [..]
> > >  	switch (op) {
> > >  	case OP_AT_S1E1RP:
> > >  	case OP_AT_S1E1WP:
> > > +		retry_slow = false;
> > >  		fail = check_at_pan(vcpu, vaddr, &par);
> > >  		break;
> > >  	default:
> > >  		goto nopan;
> > >  	}
> > 
> > For context, this is what check_at_pan() does:
> > 
> > static int check_at_pan(struct kvm_vcpu *vcpu, u64 vaddr, u64 *res)
> > {
> >         u64 par_e0;
> >         int error;
> > 
> >         /*
> >          * For PAN-involved AT operations, perform the same translation,
> >          * using EL0 this time. Twice. Much fun.
> >          */
> >         error = __kvm_at(OP_AT_S1E0R, vaddr);
> >         if (error)
> >                 return error;
> > 
> >         par_e0 = read_sysreg_par();
> >         if (!(par_e0 & SYS_PAR_EL1_F))
> >                 goto out;
> > 
> >         error = __kvm_at(OP_AT_S1E0W, vaddr);
> >         if (error)
> >                 return error;
> > 
> >         par_e0 = read_sysreg_par();
> > out:
> >         *res = par_e0;
> >         return 0;
> > }
> > 
> > I'm having a hard time understanding why KVM is doing both AT S1E0R and AT S1E0W
> > regardless of the type of the access (read/write) in the PAN-aware AT
> > instruction. Would you mind elaborating on that?
> 
> Because that's the very definition of an AT S1E1{W,R}P instruction
> when PAN is set. If *any* EL0 permission is set, then the translation
> must equally fail. Just like a load or a store from EL1 would fail if
> any EL0 permission is set when PSTATE.PAN is set.
> 
> Since we cannot check for both permissions at once, we do it twice.
> It is worth noting that we don't quite handle the PAN3 case correctly
> (because we can't retrieve the *execution* property using AT). I'll
> add that to the list of stuff to fix.
> 
> > 
> > > +	if (fail) {
> > > +		vcpu_write_sys_reg(vcpu, SYS_PAR_EL1_F, PAR_EL1);
> > > +		goto nopan;
> > > +	}
> > > [..]
> > > +	if (par & SYS_PAR_EL1_F) {
> > > +		u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> > > +
> > > +		/*
> > > +		 * If we get something other than a permission fault, we
> > > +		 * need to retry, as we're likely to have missed in the PTs.
> > > +		 */
> > > +		if ((fst & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_PERM)
> > > +			retry_slow = true;
> > > +	} else {
> > > +		/*
> > > +		 * The EL0 access succeded, but we don't have the full
> > > +		 * syndrom information to synthetize the failure. Go slow.
> > > +		 */
> > > +		retry_slow = true;
> > > +	}
> > 
> > This is what PSTATE.PAN controls:
> > 
> > If the Effective value of PSTATE.PAN is 1, then a privileged data access from
> > any of the following Exception levels to a virtual memory address that is
> > accessible to data accesses at EL0 generates a stage 1 Permission fault:
> > 
> > - A privileged data access from EL1.
> > - If HCR_EL2.E2H is 1, then a privileged data access from EL2.
> > 
> > With that in mind, I am really struggling to understand the logic.
> 
> I don't quite see what you don't understand, you'll have to be more
> precise. Are you worried about the page tables we're looking at, the
> value of PSTATE.PAN, the permission fault, or something else?
> 
> It also doesn't help that you're looking at the patch that contains
> the integration with the slow-path, which is pretty hard to read (I
> have a reworked version that's a bit better). You probably want to
> look at the "fast" path alone.

I was referring to checking both unprivileged read and write permissions.

And you are right, sorry, I managed to get myself terribly confused. For
completeness sake, this matches AArch64.S1DirectBasePermissions(), where if PAN
&& (UnprivRead || UnprivWrite) then PrivRead = False and PrivWrite = False. So
you need to check that both UnprivRead and UnprivWrite are false for the PAN
variants of AT to succeed.

> 
> > 
> > If AT S1E0{R,W} (from check_at_pan()) failed, doesn't that mean that the virtual
> > memory address is not accessible to EL0? Add that to the fact that the AT
> > S1E1{R,W} (from the beginning of __kvm_at_s1e01()) succeeded, doesn't that mean
> > that AT S1E1{R,W}P should succeed, and furthermore the PAR_EL1 value should be
> > the one KVM got from AT S1E1{R,W}?
> 
> There are plenty of ways for AT S1E0 to fail when AT S1E1 succeeded:
> 
> - no EL0 permission: that's the best case, and the PAR_EL1 obtained
>   from the AT S1E1 is the correct one. That's what we return.

Yes, that is correct, the place where VCPUs PAR_EL1 register is set is far
enough from this code that I didn't make the connection.

> 
> - The EL0 access failed, but for another reason than a permission
>   fault. This contradicts the EL1 walk, and is a sure sign that
>   someone is playing behind our back. We fail.
> 
> - exception from AT S1E0: something went wrong (again the guest
>   playing with the PTs behind our back). We fail as well.
> 
> Do you at least agree with these as goals? If you do, what in
> the implementation does not satisfy these goals? If you don't, what in
> these goals seem improper to you?

I agree with the goals.

In this patch, if I'm reading the code right (and I'm starting to doubt myself)
if PAR_EL1.F is set and PAR_EL1 doesn't indicate a permissions fault, then KVM
falls back to walking the S1 tables:

        if (par & SYS_PAR_EL1_F) {
                u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);

                /*
                 * If we get something other than a permission fault, we
                 * need to retry, as we're likely to have missed in the PTs.
                 */
                if ((fst & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_PERM)
                        retry_slow = true;
	}

I suppose that's because KVM cannot distinguish between two very different
reasons for AT failing: 1, because of something being wrong with the stage 1
tables when the AT S1E0* instruction was executed and 2, because of missing
entries at stage 2, as per the comment. Is that correct?

Thanks,
Alex

