Return-Path: <kvm+bounces-9186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BFA85BCFE
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FD412860CA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C212D6A038;
	Tue, 20 Feb 2024 13:17:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E069E6A02C
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708435076; cv=none; b=feN5cmUEhxHkLwLXDoPGs+qkbIzVozHkaZyAxB1Ch6hd/AOIn2KIrfeExZUdapLohaOIWRUC+XFrKyMzxeNrps5J3MPzcOkaf34kXJpWuFyDBhbm7LzQ2l4t/KwUx+TtoywvnDr2ZWJXLCxHxP3ZVPaLikjR2UgMHTZjdI9wglU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708435076; c=relaxed/simple;
	bh=IQ1IawSk15lvCywSyyjE44czdLRNImvOxZoYSVgiFSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4F5BHjmUAqV770gz913zY6f8NdDkrNbHoywQCkhWT0fA/LJlDkx1kHQvHpp4O6gxLxK7xUbhUCfHkOpNq/CV4LwlijHN/9E/kvP3EDSxkOgyHDRranZE8KBHoG6iNamVlhAH+sJUUmt8tUmVCUk60xooOn8MlCvU9y4L+6ZUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35C2EFEC;
	Tue, 20 Feb 2024 05:18:32 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE1053F73F;
	Tue, 20 Feb 2024 05:17:51 -0800 (PST)
Date: Tue, 20 Feb 2024 13:17:45 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/13] KVM: arm64: Harden __ctxt_sys_reg() against
 out-of-range values
Message-ID: <20240220131745.GA8575@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-2-maz@kernel.org>
 <20240220112031.GA16168@e124191.cambridge.arm.com>
 <8634tn4acv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634tn4acv.wl-maz@kernel.org>

On Tue, Feb 20, 2024 at 11:57:04AM +0000, Marc Zyngier wrote:
> On Tue, 20 Feb 2024 11:20:31 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Mon, Feb 19, 2024 at 09:20:02AM +0000, Marc Zyngier wrote:
> > > The unsuspecting kernel tinkerer can be easily confused into
> > > writing something that looks like this:
> > > 
> > > 	ikey.lo = __vcpu_sys_reg(vcpu, SYS_APIAKEYLO_EL1);
> > > 
> > > which seems vaguely sensible, until you realise that the second
> > > parameter is the encoding of a sysreg, and not the index into
> > > the vcpu sysreg file... Debugging what happens in this case is
> > 
> > type safety :(
> 
> Are you advocating for making everything a struct? Or something else?

No, merely lamenting the situation.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
> > 
> > > an interesting exercise in head<->wall interactions.
> > > 
> > > As they often say: "Any resemblance to actual persons, living
> > > or dead, or actual events is purely coincidental".
> > > 
> > > In order to save people's time, add some compile-time hardening
> > > that will at least weed out the "stupidly out of range" values.
> > > This will *not* catch anything that isn't a compile-time constant.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 181fef12e8e8..a5ec4c7d3966 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -895,7 +895,7 @@ struct kvm_vcpu_arch {
> > >   * Don't bother with VNCR-based accesses in the nVHE code, it has no
> > >   * business dealing with NV.
> > >   */
> > > -static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
> > > +static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
> > 
> > When in doubt, add more underscores!
> 
> That's the one true way.
> 
> > 
> > >  {
> > >  #if !defined (__KVM_NVHE_HYPERVISOR__)
> > >  	if (unlikely(cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> > > @@ -905,6 +905,13 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
> > >  	return (u64 *)&ctxt->sys_regs[r];
> > >  }
> > >  
> > > +#define __ctxt_sys_reg(c,r)						\
> > > +	({								\
> > > +	    	BUILD_BUG_ON(__builtin_constant_p(r) &&			\
> > > +			     (r) >= NR_SYS_REGS);			\
> > > +		___ctxt_sys_reg(c, r);					\
> > > +	})
> > 
> > I'm assuming the extra macro layer is to try make __builtin_constant_p() as
> > effective as possible? Otherwise maybe it relies on the compiler inling the
> > ___ctxt_sys_reg() function?
> 
> It's not about efficiency. It's about making it *work*. Otherwise,
> lack of inlining will screw you over, and you may not check anything.

Thanks,
Joey

