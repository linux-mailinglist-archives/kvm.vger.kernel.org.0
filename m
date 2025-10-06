Return-Path: <kvm+bounces-59632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CEFBC48AE
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 13:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1D3214E8202
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 11:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9532F6180;
	Wed,  8 Oct 2025 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyLs7KE2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C9A21767A;
	Wed,  8 Oct 2025 11:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922717; cv=none; b=muAIkla89C++IK+nJ+cvg5l4roDwEvUXLdCdCTQjtFFJEjbdUMPahLejzIBD+7zTDhgQip8yWRv+JTbuf0+QKUzBYL5y2m6So2YDqXqP8/21C0zE6Q5/lVgHnQ6fyq/QXghyNYU8VNesLVgDq535cwWNjGi8+PEAQ2b+P4ex97E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922717; c=relaxed/simple;
	bh=Pi1c1mcg1bKSqManVotiqTLKJTKhwZizggas+Uqb/MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hrkl2CRsI3IYxSvBnPaWzaDF3tjpqit/RhHW/hl2sC5b279xbrUQiZJiDHa4UNkgv0QB+oSj/p7EqGBq/nq7gHyiBZLT3SjtkCa81V1BO4dr85J0B6vvfDt0pXOCW3AuWGscwykUQJYuxTpZ+Zhynl6l3d98BLQVv2ktZOCiuf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyLs7KE2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF0AC4CEF4;
	Wed,  8 Oct 2025 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922717;
	bh=Pi1c1mcg1bKSqManVotiqTLKJTKhwZizggas+Uqb/MI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FyLs7KE2q9gyTAnfY/iyKn/jhqWkzzorFI63rO8Ssp/K+AzUveSBS4gpgTLRj4ISF
	 j66k1fLVxrDb3Hnlmt+PhEbCjUJl5qcEiasJvzOuzpWknHPL4wd4kCYN4ck+o0St2I
	 xDl/pb0X7DdaZaX+afRZZCqfA0Ut3rVoiS6HTguwHz9DkGrvELlzQotf64Fv8JATaS
	 GiwDW1DGU3I+bAVPBQfQX91/cWXumKrEPxfML0cDMF4o8J9gl7atqSA0ZwVm0i3fG8
	 anp+bEJotItPxY75jGGmUHz8HG9nGH21WqhTxQ2NfmtlPwtpCoFkszl7KM1d7O8D6E
	 iGVVd4jveKa1Q==
Date: Mon, 6 Oct 2025 21:42:10 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 02/12] KVM: x86: Refactor APIC register mask handling
 to support extended APIC registers
Message-ID: <koech6fbxpzzao3232pf4ozloanas4irecti2n3win2ow7aikj@3r72i5qyaxd4>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052118.209133-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901052118.209133-1-manali.shukla@amd.com>

On Mon, Sep 01, 2025 at 10:51:18AM +0530, Manali Shukla wrote:
> Modify the APIC register mask infrastructure to support both standard
> APIC registers (0x0-0x3f0) and extended APIC registers (0x400-0x530).
> 
> This refactoring:
> - Replaces the single u64 bitmask with a u64[2] array to accommodate
>   the extended register range(128 bitmask)
> - Updates the APIC_REG_MASK macro to handle both standard and extended
>   register spaces
> - Adapts kvm_lapic_readable_reg_mask() to use the new approach
> - Adds APIC_REG_TEST macro to check register validity for standard
>   APIC registers and Exended APIC registers
> - Updates all callers to use the new interface
> 
> This is purely an infrastructure change to support the upcoming
> extended APIC register emulation.
> 
> Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/kvm/lapic.c   | 99 ++++++++++++++++++++++++++----------------
>  arch/x86/kvm/lapic.h   |  2 +-
>  arch/x86/kvm/vmx/vmx.c | 10 +++--
>  3 files changed, 70 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e19545b8cc98..f92e3f53ee75 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1587,53 +1587,77 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
>  	return container_of(dev, struct kvm_lapic, dev);
>  }
>  
> -#define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
> -#define APIC_REGS_MASK(first, count) \
> -	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
> -
> -u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
> -{
> -	/* Leave bits '0' for reserved and write-only registers. */
> -	u64 valid_reg_mask =
> -		APIC_REG_MASK(APIC_ID) |
> -		APIC_REG_MASK(APIC_LVR) |
> -		APIC_REG_MASK(APIC_TASKPRI) |
> -		APIC_REG_MASK(APIC_PROCPRI) |
> -		APIC_REG_MASK(APIC_LDR) |
> -		APIC_REG_MASK(APIC_SPIV) |
> -		APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR) |
> -		APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR) |
> -		APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR) |
> -		APIC_REG_MASK(APIC_ESR) |
> -		APIC_REG_MASK(APIC_ICR) |
> -		APIC_REG_MASK(APIC_LVTT) |
> -		APIC_REG_MASK(APIC_LVTTHMR) |
> -		APIC_REG_MASK(APIC_LVTPC) |
> -		APIC_REG_MASK(APIC_LVT0) |
> -		APIC_REG_MASK(APIC_LVT1) |
> -		APIC_REG_MASK(APIC_LVTERR) |
> -		APIC_REG_MASK(APIC_TMICT) |
> -		APIC_REG_MASK(APIC_TMCCT) |
> -		APIC_REG_MASK(APIC_TDCR);
> +/*
> + * Helper macros for APIC register bitmask handling
> + * 2 element array is being used to represent 128-bit mask, where:
> + * - mask[0] tracks standard APIC registers (0x0-0x3f0)
> + * - mask[1] tracks extended APIC registers (0x400-0x530)
> + */
> +
> +#define APIC_REG_INDEX(reg)	(((reg) < 0x400) ? 0 : 1)
> +#define APIC_REG_BIT(reg)	(((reg) < 0x400) ? ((reg) >> 4) : (((reg) - 0x400) >> 4))
> +
> +/* Set a bit in the mask for a single APIC register. */
> +#define APIC_REG_MASK(reg, mask) do { \
> +	(mask)[APIC_REG_INDEX(reg)] |= (1ULL << APIC_REG_BIT(reg)); \
> +} while (0)
> +
> +/* Set bits in the mask for a range of consecutive APIC registers. */
> +#define APIC_REGS_MASK(first, count, mask) do { \
> +	(mask)[APIC_REG_INDEX(first)] |= ((1ULL << (count)) - 1) << APIC_REG_BIT(first); \
> +} while (0)
> +
> +/* Macro to check whether the an APIC register bit is set in the mask. */
> +#define APIC_REG_TEST(reg, mask) \
> +	((mask)[APIC_REG_INDEX(reg)] & (1ULL << APIC_REG_BIT(reg)))
> +
> +#define APIC_LAST_REG_OFFSET		0x3f0
> +#define APIC_EXT_LAST_REG_OFFSET	0x530
> +
> +void kvm_lapic_readable_reg_mask(struct kvm_lapic *apic, u64 mask[2])
> +{
> +	mask[0] = 0;
> +	mask[1] = 0;

Would it be simpler to use a bitmap for the mask?


- Naveen


