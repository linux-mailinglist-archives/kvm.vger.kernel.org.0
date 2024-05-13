Return-Path: <kvm+bounces-17323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BBFF8C4345
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4E6B1F24ACF
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE09153BF3;
	Mon, 13 May 2024 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7WPT6zc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69617153823;
	Mon, 13 May 2024 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715610447; cv=none; b=n5vwDsaYBg7a53oEhVPqpkLFKCZnbccJJ91LCmUQ3c+Xa0zoyqo2AKa/2XrwHUHFGZ5B2w88OHCN3KSJmflLs+C3S55EPAaCriqARhSLadkhSIV3Io3GYK1xxI26Cw3dL4xdEhA6FeRY70+UK8cw+pl+hj4pF5pl3G41TcL045o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715610447; c=relaxed/simple;
	bh=HVHpf2elAFBZKACu2uMRIpTn32N6FD85xEHkCXA62ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGT6aPN8px9oS2cbOJOfhRAXYzV7k+pE6DC+5lYzQYCHNm/hZ1CJlI4QQmYpJu0LGXVIgYtu0pBqtpEMVtWMJO1PXy6lnPLYDCi4dhT0NLE3mw7M46puHap6hmSBA3WlciYsIRrQKHcOPOfVUar8Ng8/ef8Ob6y6Y47KeZUNun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7WPT6zc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B1BC113CC;
	Mon, 13 May 2024 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715610447;
	bh=HVHpf2elAFBZKACu2uMRIpTn32N6FD85xEHkCXA62ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J7WPT6zcUxFB0eamH4r3GjQ57QdCbcAjyoGlx0an1ZgEqclUPJhPpXqmTaS6tmn4J
	 BJTA4UCLe/ghr5ErZZ9OPqmblk0RYfl8FB3SrsLFd1DYCEqbpXAg6quhI8zOn+inOB
	 /EJ3Y1MlVLVzI/jSp1v8Ig+5Tdchp1J/Asc6cHtahWF992zNlm+l/HFsuUA/LWgZUp
	 eARAmeIGp7Yz5p/qt5XClS3DOG6CXmOGNAAoZ8RcTAH0wijxQOCDpwNoPkd+HMOl+o
	 CW/GlKCVf4ukgexcDeSQc0l4J+Z1eNSp8yjmaRKfPQdPbGTxQAKzoQ1lYAWvs4zSzy
	 gHEDoJEegQq/Q==
Date: Mon, 13 May 2024 15:27:22 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 04/12] KVM: arm64: nVHE: Remove __guest_exit_panic path
Message-ID: <20240513142721.GD28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-5-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-5-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:33PM +0100, Pierre-Clément Tosi wrote:
> In invalid_host_el2_vect (i.e. EL2{t,h} handlers in nVHE guest context),
> remove the duplicate vCPU context check that __guest_exit_panic also
> performs, allowing an unconditional branch to it.
> 
> Rename __guest_exit_panic to __hyp_panic to better reflect that it might
> not exit through the guest but will always (directly or indirectly) end
> up executing hyp_panic(). Fix its wrong (probably bitrotten) ABI doc to
> reflect the ABI expected by VHE and (now) nVHE.
>
> Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().
> 
> Restore x0, x1 before calling hyp_panic when __hyp_panic is executed in
> host context (i.e. called from __kvm_hyp_vector).

Please don't mix cosmetic changes with functional changes. It really
makes the reviewer's life more difficult, especially when the diff is
nearly all in asm!

> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index bcaaf1a11b4e..6a1ce9d21e5b 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -83,7 +83,7 @@ alternative_else_nop_endif
>  	eret
>  	sb
>  
> -SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
> +SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
>  	// x0-x29,lr: hyp regs
>  
>  	stp	x0, x1, [sp, #-16]!
> @@ -92,13 +92,15 @@ SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
>  	msr	elr_el2, x0
>  	ldp	x0, x1, [sp], #16
>  
> -SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
> -	// x2-x29,lr: vcpu regs
> -	// vcpu x0-x1 on the stack
> +SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
> +	// x0-x29,lr: vcpu regs
> +
> +	stp	x0, x1, [sp, #-16]!
>  
>  	// If the hyp context is loaded, go straight to hyp_panic
>  	get_loaded_vcpu x0, x1
>  	cbnz	x0, 1f
> +	ldp	x0, x1, [sp], #16
>  	b	hyp_panic

Aren't these new stack accesses unnecessary for the case where the vector
is valid?

>  
>  1:
> @@ -110,10 +112,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
>  	// accurate if the guest had been completely restored.
>  	adr_this_cpu x0, kvm_hyp_ctxt, x1
>  	adr_l	x1, hyp_panic
> -	str	x1, [x0, #CPU_XREG_OFFSET(30)]
> +	str	x1, [x0, #CPU_LR_OFFSET]
>  
>  	get_vcpu_ptr	x1, x0
>  
> +	// Keep x0-x1 on the stack for __guest_exit

Didn't these get pushed twice? Once by the valid_vect macro and then
again by your stp in __hyp_panic?

I feel like I must be missing something here, but I don't really see why
this patch is needed.

Will

