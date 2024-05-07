Return-Path: <kvm+bounces-16842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6118BE6B4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 825861F2346E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABEB1607B8;
	Tue,  7 May 2024 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuFx7JZy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A7747F;
	Tue,  7 May 2024 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715093859; cv=none; b=rkDZ8VYDKPR7vG9OdvNvpKORy8TA+q96k7ypizjUFcemWPqIjeIo2U68QhY+4ByG2YXopWttVs1dHgAz50t2rirnP2/lLEwxA6L5YeC3PZ90opVNkneS0MY4mcr4xlrNnDLCF6H8Pr1VOkNgwfPZgGYhu07yyyTeP0nFiN/bfpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715093859; c=relaxed/simple;
	bh=sOYKJAaNjyz5tc9w5JMsbSZzmPQw/hxRG+nTJcqDj98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ek/Datuw+lEhmBvRiXCzo7tMhm5zgHNsHrHu9iQx//GJtbr5v81dEPGWfz+dMekkqvuCMFYcl7n6pWmdWkoJLVUnoxxLlLld5OVKCCxfB2AOjwfpXtLCHYpG5becOLKuynfSKbw3wo9g/RIyBRkbiLnQHwwG4uq0vESYluA9AQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuFx7JZy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E94AC2BBFC;
	Tue,  7 May 2024 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715093859;
	bh=sOYKJAaNjyz5tc9w5JMsbSZzmPQw/hxRG+nTJcqDj98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuFx7JZyqH5uR3thtGzntatMszyZ3KlB2lRy43ps3A5Vdzmj8iyd2wCAutuGDAT39
	 406qxn1vyD7yHKbvle4n8eCtgCbDbdmC5LC9Lvf3e9IS3qlOcDNoyumD/XO6dN2VWZ
	 bMYSHPejOf2/WTHII/NusNWASnqddAwgqTWwlccdZTGvywMkjgCXL97qm6XoPY1dwm
	 8z4ZBJUtT5fixmkk+62gvjkpkqZaKsX7WHEwRjEwzjCN45OIvf2WBsarF861sIVOXK
	 pfTzaM4LMyt4Is4CwFRDivBzccGlXC8eJJbjWPAN0Enj1TmhlwOQwjI42lyk/fJOi7
	 QGyLknVYQtWmQ==
Date: Tue, 7 May 2024 15:57:34 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Correct BTYPE/SS in host SMC emulation
Message-ID: <20240507145733.GB22453@willie-the-truck>
References: <20240502180020.3215547-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502180020.3215547-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, May 02, 2024 at 07:00:20PM +0100, Marc Zyngier wrote:
> When taking a trap for an SMC instruction on the host, we must
> stau true to the letter of the architecture and perform all the

typo: stay

> actions that the CPU would otherwise do. Among those are clearing
> the BTYPE and SS bits.
> 
> Just do that.
> 
> Fixes: a805e1fb3099 ("KVM: arm64: Add SMC handler in nVHE EL2")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> index 4fdfeabefeb4..b1afb7b59a31 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> @@ -47,7 +47,13 @@ static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
>   */
>  static inline void kvm_skip_host_instr(void)
>  {
> +	u64 spsr = read_sysreg_el2(SYS_SPSR);
> +
>  	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
> +
> +	spsr &= ~(PSR_BTYPE_MASK | DBG_SPSR_SS);
> +
> +	write_sysreg_el2(spsr, SYS_SPSR);

The handling of SS looks correct to me, but I think the BTYPE
manipulation could do with a little more commentary as it looks quite
subtle when the SMC is in a guarded page. Am I right in thinking:

   * If the SMC is in a guarded page, the Branch Target exception is
     higher priority (12) than the trap to EL2 and so the host will
     handle it.

   * Therefore if a trapping SMC is in a guarded page, BTYPE must be
     zero and we don't have to worry about injecting a Branch Target
     exception.

   * Otherwise, if the SMC is in a non-guarded page, we should clear it
     to 0 per the architecture (R_YWFHD).

?

Having said that, I can't actually find the priority of an SMC trapped
to EL2 by HCR_EL2.TSC in the Arm ARM. Trapped HVCs are priority 15 and
SMCs trapped to EL3 are priority 23.

Will

