Return-Path: <kvm+bounces-19713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D44290932E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D52B1C22C1F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204491A3BA1;
	Fri, 14 Jun 2024 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sbU4BXEF"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281A1A0AE3
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718395697; cv=none; b=ecHdLDAS6uyCFH2EXDK2pfXeImPKwI3LzcsW78pENG6ZHIuLWqvmUdXoBaU06PxiMRscFIzOROI8FuyZ9f0Yk9dwAn0vnGoSu94pRYAUOs/cFKXLp7E/7KlxbKmyts0FKPQkfwh1w5DyH6gc7x8baHMtYrC8hFnvrGrF/8oufcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718395697; c=relaxed/simple;
	bh=ARn99ayGOByz5828trMCNiCuJqqnebiOKD8orqwrTEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdrA8EYun4UfyWs8+DMk4PGgQ9JAiF0wraZff+ymqQG8AKhlapoXe7N+TgSUqletcdRLkPzeKtKvhErJchqi0zjtA3nTK7D+05fl0fBcaZQP59x3KolenTenXLiJ7pD5iii6IsDxI+lI79HXPjCVwjVDoETBZrAWiGp2hknX+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sbU4BXEF; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718395692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1GDFydq7c3Kjtuw3GQ/jFq8L4bmMO5C4T7yisMBOxn0=;
	b=sbU4BXEFdm4lC2Jie97D2Nj+y6MCCleLX+6chFICh14Rj/J2jNF0tzeoiZzhIb2loh3pTS
	7RiaAxdlExJQyJ2rs0B0XXhZqzYKfMR0gL1KW0K8RYGWX0uywI8D5kYv2LA9j/i0crEQ9g
	/nu9pph49KIGzTaEwtefHHH0qrM60NU=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
Date: Fri, 14 Jun 2024 20:08:05 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 05/15] KVM: arm64: nv: Load guest hyp's ZCR into EL1
 state
Message-ID: <ZmyjJaz2uvtIx3f6@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
 <20240613201756.3258227-6-oliver.upton@linux.dev>
 <87a5jn3hex.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5jn3hex.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 14, 2024 at 12:14:30PM +0100, Marc Zyngier wrote:
> On Thu, 13 Jun 2024 21:17:46 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Load the guest hypervisor's ZCR_EL2 into the corresponding EL1 register
> > when restoring SVE state, as ZCR_EL2 affects the VL in the hypervisor
> > context.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       | 4 ++++
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 8170c04fde91..e01e6de414f1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -844,6 +844,10 @@ struct kvm_vcpu_arch {
> >  
> >  #define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> >  
> > +#define vcpu_sve_zcr_el1(vcpu)						\
> > +	(unlikely(is_hyp_ctxt(vcpu)) ? __vcpu_sys_reg(vcpu, ZCR_EL2) :	\
> > +				       __vcpu_sys_reg(vcpu, ZCR_EL1))
> > +
> 
> I have the feeling this abstracts the access at the wrong level. It's
> not that it gives the wrong result, but it hides the register and is
> only concerned with the *value*.

Agreed, this was done out of hacky convenience for myself and I didn't
revisit.

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index aeb1c567dfad..2c3eff0031eb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -845,9 +845,8 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
>  
> -#define vcpu_sve_zcr_el1(vcpu)						\
> -	(unlikely(is_hyp_ctxt(vcpu)) ? __vcpu_sys_reg(vcpu, ZCR_EL2) :	\
> -				       __vcpu_sys_reg(vcpu, ZCR_EL1))
> +#define vcpu_sve_zcr_elx(vcpu)						\
> +	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
>  
>  #define vcpu_sve_state_size(vcpu) ({					\
>  	size_t __size_ret;						\
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index bb2ef3166c63..947486a111e1 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -179,10 +179,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  			 * If the vCPU is in the hyp context then ZCR_EL1 is
>  			 * loaded with its vEL2 counterpart.
>  			 */
> -			if (is_hyp_ctxt(vcpu))
> -				__vcpu_sys_reg(vcpu, ZCR_EL2) = zcr;
> -			else
> -				__vcpu_sys_reg(vcpu, ZCR_EL1) = zcr;
> +			__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)) = zcr;
>  
>  			/*
>  			 * Restore the VL that was saved when bound to the CPU,
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 0a6935a18490..ad8dec0b450b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -330,7 +330,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
>  	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))
>  		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
>  
> -	write_sysreg_el1(vcpu_sve_zcr_el1(vcpu), SYS_ZCR);
> +	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
>  }
>  
>  /*
> 
> which makes the helper select the correct guest register for the
> context, and only that. In turn, the write side is much cleaner and
> symmetry is restored.

LGTM, I'll squash it in.

-- 
Thanks,
Oliver

