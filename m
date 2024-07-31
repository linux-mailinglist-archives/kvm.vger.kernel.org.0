Return-Path: <kvm+bounces-22797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 531779433D6
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 18:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3039B25DBD
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 16:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AE71BC083;
	Wed, 31 Jul 2024 16:05:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A651BBBC7
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722441929; cv=none; b=hXUikM2Xn/h7N3ClyCPY4+t43GP6RsAvJypPvarBhBStScDPXCuZIX/udeAc5tW0lrtWWCOAH0hUDVJLACr9ce4rcGFFiE/pvC6vqhE4tiBcIVTbi+e3d3jo8IP0U236JIrT1TVCEphhXp2nACmkqAZUMpFx+4w8s6dz7Ji708M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722441929; c=relaxed/simple;
	bh=u3EFQ8M28u9qY6CANyuFcamS2Vh7fWSDEBXMErYDl/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D68+8VavPFJLCfbiUDzI0XqeEYHvmiPbfxjPtjgKeJcx84q0e9F6vl2NzZP3puqBdyIpqXcywgCFUn9cAhLzJMRoEwthE94zd+jkQXzpRjUKa0vIOPXRf71Tl7pNQafMmVRrH6ZvWozasV9S23xoci49rP10IEQP9wPewwPPhMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05E7D1007;
	Wed, 31 Jul 2024 09:05:52 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC8E73F5A1;
	Wed, 31 Jul 2024 09:05:24 -0700 (PDT)
Date: Wed, 31 Jul 2024 17:05:21 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZqpgwaNzZbE-seyC@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
 <ZqpLNT8bVFDB6oWJ@raptor>
 <86r0b91sa3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0b91sa3.wl-maz@kernel.org>

Hi Marc,

On Wed, Jul 31, 2024 at 04:43:16PM +0100, Marc Zyngier wrote:
> On Wed, 31 Jul 2024 15:33:25 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
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
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/at.c | 538 ++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 520 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > > index 71e3390b43b4c..8452273cbff6d 100644
> > > --- a/arch/arm64/kvm/at.c
> > > +++ b/arch/arm64/kvm/at.c
> > > @@ -4,9 +4,305 @@
> > >   * Author: Jintack Lim <jintack.lim@linaro.org>
> > >   */
> > >  
> > > +#include <linux/kvm_host.h>
> > > +
> > > +#include <asm/esr.h>
> > >  #include <asm/kvm_hyp.h>
> > >  #include <asm/kvm_mmu.h>
> > >  
> > > +struct s1_walk_info {
> > > +	u64	     baddr;
> > > +	unsigned int max_oa_bits;
> > > +	unsigned int pgshift;
> > > +	unsigned int txsz;
> > > +	int 	     sl;
> > > +	bool	     hpd;
> > > +	bool	     be;
> > > +	bool	     nvhe;
> > > +	bool	     s2;
> > > +};
> > > +
> > > +struct s1_walk_result {
> > > +	union {
> > > +		struct {
> > > +			u64	desc;
> > > +			u64	pa;
> > > +			s8	level;
> > > +			u8	APTable;
> > > +			bool	UXNTable;
> > > +			bool	PXNTable;
> > > +		};
> > > +		struct {
> > > +			u8	fst;
> > > +			bool	ptw;
> > > +			bool	s2;
> > > +		};
> > > +	};
> > > +	bool	failed;
> > > +};
> > > +
> > > +static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
> > > +{
> > > +	wr->fst		= fst;
> > > +	wr->ptw		= ptw;
> > > +	wr->s2		= s2;
> > > +	wr->failed	= true;
> > > +}
> > > +
> > > +#define S1_MMU_DISABLED		(-127)
> > > +
> > > +static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> > > +			 struct s1_walk_result *wr, const u64 va, const int el)
> > > +{
> > > +	u64 sctlr, tcr, tg, ps, ia_bits, ttbr;
> > > +	unsigned int stride, x;
> > > +	bool va55, tbi;
> > > +
> > > +	wi->nvhe = el == 2 && !vcpu_el2_e2h_is_set(vcpu);
> > > +
> > > +	va55 = va & BIT(55);
> > > +
> > > +	if (wi->nvhe && va55)
> > > +		goto addrsz;
> > > +
> > > +	wi->s2 = el < 2 && (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_VM);
> > > +
> > > +	switch (el) {
> > > +	case 1:
> > > +		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> > > +		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL1);
> > > +		ttbr	= (va55 ?
> > > +			   vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
> > > +			   vcpu_read_sys_reg(vcpu, TTBR0_EL1));
> > > +		break;
> > > +	case 2:
> > > +		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> > > +		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL2);
> > > +		ttbr	= (va55 ?
> > > +			   vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
> > > +			   vcpu_read_sys_reg(vcpu, TTBR0_EL2));
> > > +		break;
> > > +	default:
> > > +		BUG();
> > > +	}
> > > +
> > > +	/* Let's put the MMU disabled case aside immediately */
> > > +	if (!(sctlr & SCTLR_ELx_M) ||
> > > +	    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> > > +		if (va >= BIT(kvm_get_pa_bits(vcpu->kvm)))
> > 
> > As far as I can tell, if TBI, the pseudocode ignores bits 63:56 when checking
> > for out-of-bounds VA for the MMU disabled case (above) and the MMU enabled case
> > (below). That also matches the description of TBIx bits in the TCR_ELx
> > registers.
> 
> Right. Then the check needs to be hoisted up and the VA sanitised
> before we compare it to anything.
> 
> Thanks for all your review comments, but I am going to ask you to stop
> here. You are reviewing a pretty old code base, and although I'm sure
> you look at what is in my tree, I'd really like to post a new version
> for everyone to enjoy.

Got it.

Thanks,
Alex

