Return-Path: <kvm+bounces-22747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8672E942B47
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B935D1C20D89
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B61F1AAE20;
	Wed, 31 Jul 2024 09:53:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8291A8C19
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722419601; cv=none; b=nPIMJlbe9AvVrFfM2U2mn7reBTQ6fZvnIwjJG8ZCqO31mMIGynTW564FrNyZGAy+bhbeIxqf2g6ph/sj/jami1pRP6rHoAjnD46SJQ7t6KaY0PeijKSdpuHUwu4lRqeXScBjdXBQfrsef8zHSZUyExkOc4+1wx6BGjDqTgnU5X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722419601; c=relaxed/simple;
	bh=OJIosK3Ql2nbnFRp+YXJmhi072hMp3NTP8G7ibcFI9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMe8vyNtGpa65WDsGwUUhM6T7zMPwL5dvE5vGntWp//d9nYDfmgO1f91a+9vv9M36eXTN0l01CsYwjRU2+dWuKj5FL4rZks7GrmVxdnoDieGZUq+z54fUsmYoNEljQSvKigLi1Z6oqcLluCfYysAhj3dK/0uWs3qSq/JE2wd6/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD5831007;
	Wed, 31 Jul 2024 02:53:44 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C40C3F5A1;
	Wed, 31 Jul 2024 02:53:17 -0700 (PDT)
Date: Wed, 31 Jul 2024 10:53:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZqoJiiNPWBtRhRur@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
 <Zqe0iBtD4389Lhei@raptor>
 <86v80m0wlb.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v80m0wlb.wl-maz@kernel.org>

Hi,

On Wed, Jul 31, 2024 at 09:55:28AM +0100, Marc Zyngier wrote:
> On Mon, 29 Jul 2024 16:26:00 +0100,
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
> > 
> > Where 'el' is computed in handle_at_slow() as:
> > 
> > 	/*
> > 	 * We only get here from guest EL2, so the translation regime
> > 	 * AT applies to is solely defined by {E2H,TGE}.
> > 	 */
> > 	el = (vcpu_el2_e2h_is_set(vcpu) &&
> > 	      vcpu_el2_tge_is_set(vcpu)) ? 2 : 1;
> > 
> > I think 'nvhe' will always be false ('el' is 2 only when E2H is
> > set).
> 
> Yeah, there is a number of problems here. el should depend on both the
> instruction (some are EL2-specific) and the HCR control bits. I'll
> tackle that now.

Yeah, also noticed that how sctlr, tcr and ttbr are chosen in setup_s1_walk()
doesn't look quite right for the nvhe case.

> 
> > I'm curious about what 'el' represents. The translation regime for the AT
> > instruction?
> 
> Exactly that.

Might I make a suggestion here? I was thinking about dropping the (el, wi-nvhe*)
tuple to represent the translation regime and have a wi->regime (or similar) to
unambiguously encode the regime. The value can be an enum with three values to
represent the three possible regimes (REGIME_EL10, REGIME_EL2, REGIME_EL20).

Just a thought though, feel free to ignore at your leisure.

*wi->single_range on the kvm-arm64/nv-at-pan-WIP branch.

Thanks,
Alex

