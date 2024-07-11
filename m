Return-Path: <kvm+bounces-21402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6014E92E53B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 12:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 214D5285272
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 10:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8271B159217;
	Thu, 11 Jul 2024 10:56:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B74B158A1E
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 10:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720695381; cv=none; b=UTMIWMdqdYVFFGQ2lNzzmz+3fwj3SdodZ+YwV5X2sJxzg12eoUkXEYj4SM3eQB6uxn8yk5XujjFLITZWk5QD/ohLDR7/CHEVDnxSi07r96LczZyvlJbrgKrJi32HkobBb3Jx0B+JroX6Dy5jHIlg5YUdNkuiWy1thjpM+7Ftzhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720695381; c=relaxed/simple;
	bh=DIBuYb4gqtVfXndiTDycUcqF9WPL156MVLpoUiXj0VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7b7UpQyAJEjNntMY+ojFPeL9krZXRTiAMl9jLuafkEeMdD7IUndJIs5VvjCbUBFmFXwmScX96hiHgwUjxXvWinj764c5Wx6ui5qnmyxY91mmIPIUnkU/4FfHyLnCi083ZMDSkaTGXvAXEKF1ItBxRJIvKSw+ZWfwJRQ+vD213o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2A7C1007;
	Thu, 11 Jul 2024 03:56:42 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 350073F762;
	Thu, 11 Jul 2024 03:56:16 -0700 (PDT)
Date: Thu, 11 Jul 2024 11:56:13 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <Zo+6TYIP3FNssR/b@arm.com>
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

Hi,

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
> [..]
>  	switch (op) {
>  	case OP_AT_S1E1RP:
>  	case OP_AT_S1E1WP:
> +		retry_slow = false;
>  		fail = check_at_pan(vcpu, vaddr, &par);
>  		break;
>  	default:
>  		goto nopan;
>  	}

For context, this is what check_at_pan() does:

static int check_at_pan(struct kvm_vcpu *vcpu, u64 vaddr, u64 *res)
{
        u64 par_e0;
        int error;

        /*
         * For PAN-involved AT operations, perform the same translation,
         * using EL0 this time. Twice. Much fun.
         */
        error = __kvm_at(OP_AT_S1E0R, vaddr);
        if (error)
                return error;

        par_e0 = read_sysreg_par();
        if (!(par_e0 & SYS_PAR_EL1_F))
                goto out;

        error = __kvm_at(OP_AT_S1E0W, vaddr);
        if (error)
                return error;

        par_e0 = read_sysreg_par();
out:
        *res = par_e0;
        return 0;
}

I'm having a hard time understanding why KVM is doing both AT S1E0R and AT S1E0W
regardless of the type of the access (read/write) in the PAN-aware AT
instruction. Would you mind elaborating on that?

> +	if (fail) {
> +		vcpu_write_sys_reg(vcpu, SYS_PAR_EL1_F, PAR_EL1);
> +		goto nopan;
> +	}
> [..]
> +	if (par & SYS_PAR_EL1_F) {
> +		u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> +
> +		/*
> +		 * If we get something other than a permission fault, we
> +		 * need to retry, as we're likely to have missed in the PTs.
> +		 */
> +		if ((fst & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_PERM)
> +			retry_slow = true;
> +	} else {
> +		/*
> +		 * The EL0 access succeded, but we don't have the full
> +		 * syndrom information to synthetize the failure. Go slow.
> +		 */
> +		retry_slow = true;
> +	}

This is what PSTATE.PAN controls:

If the Effective value of PSTATE.PAN is 1, then a privileged data access from
any of the following Exception levels to a virtual memory address that is
accessible to data accesses at EL0 generates a stage 1 Permission fault:

- A privileged data access from EL1.
- If HCR_EL2.E2H is 1, then a privileged data access from EL2.

With that in mind, I am really struggling to understand the logic.

If AT S1E0{R,W} (from check_at_pan()) failed, doesn't that mean that the virtual
memory address is not accessible to EL0? Add that to the fact that the AT
S1E1{R,W} (from the beginning of __kvm_at_s1e01()) succeeded, doesn't that mean
that AT S1E1{R,W}P should succeed, and furthermore the PAR_EL1 value should be
the one KVM got from AT S1E1{R,W}?

Thanks,
Alex

>  nopan:
>  	__mmu_config_restore(&config);
>  out:
>  	local_irq_restore(flags);
>  
>  	write_unlock(&vcpu->kvm->mmu_lock);
> +
> +	/*
> +	 * If retry_slow is true, then we either are missing shadow S2
> +	 * entries, have paged out guest S1, or something is inconsistent.
> +	 *
> +	 * Either way, we need to walk the PTs by hand so that we can either
> +	 * fault things back, in or record accurate fault information along
> +	 * the way.
> +	 */
> +	if (retry_slow) {
> +		par = handle_at_slow(vcpu, op, vaddr);
> +		vcpu_write_sys_reg(vcpu, par, PAR_EL1);
> +	}
>  }
>  
>  void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> @@ -433,6 +931,10 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  
> +	/* We failed the translation, let's replay it in slow motion */
> +	if (!fail && (par & SYS_PAR_EL1_F))
> +		par = handle_at_slow(vcpu, op, vaddr);
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  }
>  
> -- 
> 2.39.2
> 
> 

