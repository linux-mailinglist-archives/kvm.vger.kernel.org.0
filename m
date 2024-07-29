Return-Path: <kvm+bounces-22513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB21893F952
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 021FD28372D
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6F5156F46;
	Mon, 29 Jul 2024 15:26:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3861D156875
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722266773; cv=none; b=XTTQQgxEefKC3QTj+6WFiEOvoqb+Lr3jfJkJUkRjGWP+gXwhXTO0pPrGPiIvhxOkhUSTDt9OsUwGV4S816QKE9VuMjqiL0klARrfmq7J/vxP6b2bfdh9rEuX8v9fFc8iUi2tnl5N7qEI7cd3VNuUZlUVos5vk5YxDvpgfmbgwdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722266773; c=relaxed/simple;
	bh=mLrg+0IKo6uYpSaRffHV0UgyaCigABx44CllcBktsEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWarMpDyVwcXsM1IMXvZkrB0u7R90cO0rf93sElZ9jabFHoKjnBsWgCVVFw3O99RtndPRYI3r2zdMKAHIxk0kZms9dUEZjjvoFkxK7iypIxTy64MXFif4IFDQbKaV71gYozDyBG5nwLHMxgRUCIcKsBlALF9rQm+wJnYfG9cQmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 182CF1007;
	Mon, 29 Jul 2024 08:26:36 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E61B83F64C;
	Mon, 29 Jul 2024 08:26:08 -0700 (PDT)
Date: Mon, 29 Jul 2024 16:26:00 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <Zqe0iBtD4389Lhei@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708165800.1220065-1-maz@kernel.org>

Hi Marc,

On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
> In order to plug the brokenness of our current AT implementation,
> we need a SW walker that is going to... err.. walk the S1 tables
> and tell us what it finds.
> 
> Of course, it builds on top of our S2 walker, and share similar
> concepts. The beauty of it is that since it uses kvm_read_guest(),
> it is able to bring back pages that have been otherwise evicted.
> 
> This is then plugged in the two AT S1 emulation functions as
> a "slow path" fallback. I'm not sure it is that slow, but hey.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 538 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 520 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 71e3390b43b4c..8452273cbff6d 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -4,9 +4,305 @@
>   * Author: Jintack Lim <jintack.lim@linaro.org>
>   */
>  
> +#include <linux/kvm_host.h>
> +
> +#include <asm/esr.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +struct s1_walk_info {
> +	u64	     baddr;
> +	unsigned int max_oa_bits;
> +	unsigned int pgshift;
> +	unsigned int txsz;
> +	int 	     sl;
> +	bool	     hpd;
> +	bool	     be;
> +	bool	     nvhe;
> +	bool	     s2;
> +};
> +
> +struct s1_walk_result {
> +	union {
> +		struct {
> +			u64	desc;
> +			u64	pa;
> +			s8	level;
> +			u8	APTable;
> +			bool	UXNTable;
> +			bool	PXNTable;
> +		};
> +		struct {
> +			u8	fst;
> +			bool	ptw;
> +			bool	s2;
> +		};
> +	};
> +	bool	failed;
> +};
> +
> +static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
> +{
> +	wr->fst		= fst;
> +	wr->ptw		= ptw;
> +	wr->s2		= s2;
> +	wr->failed	= true;
> +}
> +
> +#define S1_MMU_DISABLED		(-127)
> +
> +static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> +			 struct s1_walk_result *wr, const u64 va, const int el)
> +{
> +	u64 sctlr, tcr, tg, ps, ia_bits, ttbr;
> +	unsigned int stride, x;
> +	bool va55, tbi;
> +
> +	wi->nvhe = el == 2 && !vcpu_el2_e2h_is_set(vcpu);

Where 'el' is computed in handle_at_slow() as:

	/*
	 * We only get here from guest EL2, so the translation regime
	 * AT applies to is solely defined by {E2H,TGE}.
	 */
	el = (vcpu_el2_e2h_is_set(vcpu) &&
	      vcpu_el2_tge_is_set(vcpu)) ? 2 : 1;

I think 'nvhe' will always be false ('el' is 2 only when E2H is set).

I'm curious about what 'el' represents. The translation regime for the AT
instruction?

Thanks,
Alex

