Return-Path: <kvm+bounces-17319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 712B58C4297
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 15:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22BE61F22273
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 13:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4352B153587;
	Mon, 13 May 2024 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E21Yv4Cj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D87114EC7A;
	Mon, 13 May 2024 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715608548; cv=none; b=EsSwsmV85mKLhWJ9s5Ybbc/SQTGqsWXcppE0hapDC3z8MVklhz+dNCopqHgHo7majWSM5Fuo89CfpDeb7G3O3J1dbHuaBTyqF0VbnDQA4qvd/8ubV97ycU/AydVUxPXlm5ird4UV2fqxb/W31fbxlVKt2jtYILkgFP2DfFgtbak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715608548; c=relaxed/simple;
	bh=+zJygHwJDYYbEHrrcyWnil8v90ICcXTefv5dJxPZ8lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaK/zgNVaLN1PfzCEAX8eIl/SDJG5XUiRPtuKlEZBfWmFpfwmYPP4NY9Vfjp7Jg9ntqm4+l/lfsoiHleG4euHrYSqcPGZqFvDJDs8e0rfJBbwHHC6WDJVdfpuYEqQE2nR8iV2sUIKaIRxOHZtdtZSsAgs6Y0d3GfNDjASJrwQYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E21Yv4Cj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A774C113CC;
	Mon, 13 May 2024 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715608548;
	bh=+zJygHwJDYYbEHrrcyWnil8v90ICcXTefv5dJxPZ8lI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E21Yv4CjfRNH9NPlgkc8u7W1/WiUPP+/YhrSUmG92G6vgADSfsWECEKcpOMhyEfG/
	 RbpGvEBPmK4qhlTtTRp18c/c2Jrxg3/HEXhg+XtU8DkruSan+t5ct+a5eT+JVNHYwX
	 zdSNb5naXaJBpBrUHam4L8u7AWMjMWLYLSJgzmwDspv4ZIpr9G3mSLUAyB8hdyj1P0
	 cnBcw+sEKShIvp4QsrAxO4WElLFWhUjjALm8Y4SHCqARkdqLGA93RFa6KbJLaCKGBD
	 bz814/nJPG09eFFTbVOMRuUZDnPshBl60b1iZD/ykTEnQTXxJMI5FwPdNoeDAmF+b1
	 iDbl+22GqOMHA==
Date: Mon, 13 May 2024 14:55:42 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: Fix clobbered ELR in sync
 abort/SError
Message-ID: <20240513135542.GA28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-2-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-2-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:30PM +0100, Pierre-Clément Tosi wrote:
> When the hypervisor receives a SError or synchronous exception (EL2h)
> while running with the __kvm_hyp_vector and if ELR_EL2 doesn't point to
> an extable entry, it panics indirectly by overwriting ELR with the
> address of a panic handler in order for the asm routine it returns to to
> ERET into the handler.
> 
> However, this clobbers ELR_EL2 for the handler itself. As a result,
> hyp_panic(), when retrieving what it believes to be the PC where the
> exception happened, actually ends up reading the address of the panic
> handler that called it! This results in an erroneous and confusing panic
> message where the source of any synchronous exception (e.g. BUG() or
> kCFI) appears to be __guest_exit_panic, making it hard to locate the
> actual BRK instruction.
> 
> Therefore, store the original ELR_EL2 in the per-CPU kvm_hyp_ctxt and
> point the sysreg to a routine that first restores it to its previous
> value before running __guest_exit_panic.
> 
> Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kernel/asm-offsets.c         | 1 +
>  arch/arm64/kvm/hyp/entry.S              | 9 +++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 81496083c041..27de1dddb0ab 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -128,6 +128,7 @@ int main(void)
>    DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
> +  DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2]));
>    DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
>    DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
>    DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index f3aa7738b477..bcaaf1a11b4e 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -83,6 +83,15 @@ alternative_else_nop_endif
>  	eret
>  	sb
>  
> +SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
> +	// x0-x29,lr: hyp regs
> +
> +	stp	x0, x1, [sp, #-16]!
> +	adr_this_cpu x0, kvm_hyp_ctxt, x1
> +	ldr	x0, [x0, #CPU_ELR_EL2]
> +	msr	elr_el2, x0
> +	ldp	x0, x1, [sp], #16

Why do you have to preserve x0 and x1 here? afaict, we fall into
__guest_exit_panic(), which clobbers them both immediately because it's
going to pull them off the stack (they get saved _very_ early during
exception entry).

Will

