Return-Path: <kvm+bounces-28353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B3A99760D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:57:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CD841F21C15
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05FD61E22F9;
	Wed,  9 Oct 2024 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hhBUjPzv"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D61E22E3
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728503734; cv=none; b=J5L6gp9ZOEkibu7fEiDKMdZGG27pliu48O0AznlLUvkFLBhmTNmZfoJ4c8dwz6wW1rIdFECjYs3nQVwWCeh1U7QIhcJtadG+lDpyCVUuHEJzUZ7k11H2ZYtMLD2PpFZ64uNvvEaa6K10Iuzb/vY9NqJwI8h/ZLnnCOH6AY65wns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728503734; c=relaxed/simple;
	bh=Sc4nKdsPXx5tCl7kmTjYsRcV+p7U/RIuhom/uIbzdng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPYveirTgS98Vp5yE9vrWwJ0a57OTheeSRG0pqbg6O8EOD6aYYGkH6vrAbrYbCdS1vvfJWNrFtMTFSBM+U+KL+0J31B6WfW1uf7yGxX3qpX56HvGBgNVnVAb7dx1XUjowsqIAxlAclp+eFSEhmqMd04Pzd3+y7z2XsXIQTUg6Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hhBUjPzv; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 9 Oct 2024 12:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728503730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HZO8ZUZ4JIYjAEgdyh9A4+ZHn421cNn46YVdgA+yVeY=;
	b=hhBUjPzv2ppG7U3cT1WxcIVI+Ynk3LJC5aRTUlzkg1L8ZjZfvX8szPPsA7CIni6wh9ZNB3
	cZCmKsQjlK8P2TPb0VN4+w0SsEe56T6uSgi335RaAcOYmdZAWghYnPp64jeCbrYjhNCtcV
	bII/V3+ViQ2fwKsYl5ApipIztcH6Rxo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 07/36] KVM: arm64: nv: Save/Restore vEL2 sysregs
Message-ID: <ZwbfqaxYFoThx_mc@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 07:59:50PM +0100, Marc Zyngier wrote:
> +static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
> +{
> +	u64 val;
> +
> +	/* These registers are common with EL1 */
> +	write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),	par_el1);
> +	write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),	tpidr_el1);
> +
> +	write_sysreg(read_cpuid_id(),				vpidr_el2);

I don't think we need to restore VPIDR_EL2 here, so long as we do it on
vcpu_put() when leaving a nested VM context. That seems like the right
place to have it, as we could be running a mix of nested and non-nested
VMs and don't ever poke VPIDR_EL2 for non-NV VMs.

> @@ -89,7 +192,29 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
>  	 */
>  	__sysreg32_restore_state(vcpu);
>  	__sysreg_restore_user_state(guest_ctxt);
> -	__sysreg_restore_el1_state(guest_ctxt);
> +
> +	if (unlikely(__is_hyp_ctxt(guest_ctxt))) {
> +		__sysreg_restore_vel2_state(vcpu);
> +	} else {
> +		if (vcpu_has_nv(vcpu)) {
> +			/*
> +			 * Only set VPIDR_EL2 for nested VMs, as this is the
> +			 * only time it changes. We'll restore the MIDR_EL1
> +			 * view on put.
> +			 */

Slightly ambiguous what "VPIDR_EL2" this is referring to (hardware reg
v. guest value). Maybe:

			/*
			 * Use the guest hypervisor's VPIDR_EL2 when in a nested
			 * state. The hardware value of MIDR_EL1 gets restored on
			 * put.
			 */

> +			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
> +
> +			/*
> +			 * As we're restoring a nested guest, set the value
> +			 * provided by the guest hypervisor.
> +			 */
> +			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
> +		} else {
> +			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
> +		}
> +
> +		__sysreg_restore_el1_state(guest_ctxt, mpidr);
> +	}
>  
>  	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
>  }
> @@ -112,12 +237,20 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
>  
>  	host_ctxt = host_data_ptr(host_ctxt);
>  
> -	__sysreg_save_el1_state(guest_ctxt);
> +	if (unlikely(__is_hyp_ctxt(guest_ctxt)))
> +		__sysreg_save_vel2_state(vcpu);
> +	else
> +		__sysreg_save_el1_state(guest_ctxt);
> +
>  	__sysreg_save_user_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  
>  	/* Restore host user state */
>  	__sysreg_restore_user_state(host_ctxt);
>  
> +	/* If leaving a nesting guest, restore MPIDR_EL1 default view */

typo: MIDR_EL1

> +	if (vcpu_has_nv(vcpu))
> +		write_sysreg(read_cpuid_id(),	vpidr_el2);
> +
>  	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
>  }
> -- 
> 2.39.2
> 

-- 
Thanks,
Oliver

