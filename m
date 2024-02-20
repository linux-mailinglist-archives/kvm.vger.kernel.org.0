Return-Path: <kvm+bounces-9174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E82E785BAA1
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADE2A2830A3
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F328766B2C;
	Tue, 20 Feb 2024 11:31:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCD7657DF
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708428693; cv=none; b=UuPdmAcDZ7HMxQR0WNGs8gdHR8wCr1KfMpRe1OQ0y5oIA17uF9lcL+hnYWbguUI+nj/46E6zRIR3lVja6TuWbgvzLlNe5bvl5dTFgqJ3xiNwsedD9UIayxJXYsLFKij5Q3URw4Var8a9VSz0C0db1LDN2JoivmJGTvXS56O9RgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708428693; c=relaxed/simple;
	bh=BwHXckH6JmSTNSejoJCBfxff7io4FiEoiaOCjMwDc6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liCCs7hkmePZS6TO4E782c8nk8/RkVNCGSCRVr0hRjPXYRpan2ncxDBp89AJPKlQBKRsPYqPT8Ax+7ECRjtNcvyYSxcqC+RSJ26iJbCZ8wl6erFkPukJr/xD/b00SKh0NJOP+31il/y1NOTVjjTPL8ViVwxlG9stXwoB0yRQMD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56DFE106F;
	Tue, 20 Feb 2024 03:32:10 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA9823F762;
	Tue, 20 Feb 2024 03:31:29 -0800 (PST)
Date: Tue, 20 Feb 2024 11:31:27 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 02/13] KVM: arm64: Clarify ESR_ELx_ERET_ISS_ERET*
Message-ID: <20240220113127.GB16168@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219092014.783809-3-maz@kernel.org>

On Mon, Feb 19, 2024 at 09:20:03AM +0000, Marc Zyngier wrote:
> The ESR_ELx_ERET_ISS_ERET* macros are a bit confusing:
> 
> - ESR_ELx_ERET_ISS_ERET really indicates that we have trapped an
>   ERETA* instruction, as opposed to an ERET
> 
> - ESR_ELx_ERET_ISS_ERETA reallu indicates that we have trapped
>   an ERETAB instruction, as opposed to an ERETAA.
> 
> Repaint the two helpers such as:
> 
> - ESR_ELx_ERET_ISS_ERET becomes ESR_ELx_ERET_ISS_ERETA
> 
> - ESR_ELx_ERET_ISS_ERETA becomes ESR_ELx_ERET_ISS_ERETAB
> 
> At the same time, use BIT() instead of raw values.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I'm somewhat against this, as the original names are what the Arm ARM specifies.

> ---
>  arch/arm64/include/asm/esr.h | 4 ++--
>  arch/arm64/kvm/handle_exit.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 353fe08546cf..72c7810ccf2c 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -290,8 +290,8 @@
>  		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
>  
>  /* ISS field definitions for ERET/ERETAA/ERETAB trapping */
> -#define ESR_ELx_ERET_ISS_ERET		0x2
> -#define ESR_ELx_ERET_ISS_ERETA		0x1
> +#define ESR_ELx_ERET_ISS_ERETA		BIT(1)
> +#define ESR_ELx_ERET_ISS_ERETAB		BIT(0)
>  
>  /*
>   * ISS field definitions for floating-point exception traps
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 617ae6dea5d5..0646c623d1da 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -219,7 +219,7 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
>  
>  static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
> +	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERETA)

If this part is confusing due to the name, maybe introduce a function in esr.h
esr_is_pac_eret() (name pending bikeshedding)?

>  		return kvm_handle_ptrauth(vcpu);
>  
>  	/*

Thanks,
Joey

