Return-Path: <kvm+bounces-37863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6AAA30BD0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84B091665A1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EBF1FF1A7;
	Tue, 11 Feb 2025 12:36:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F321F0E2B
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739277401; cv=none; b=hQ4z3jjqQ3NJ6EUZp52Pjkuq7P27rhpxXOkU55TejnRkrBFNl5CJT1MzMSQuBeYx8h973GKzqQUsjOIhDpVLdMZ98YYPUQzvfaYHPR+y4ulig5t5L0cOIzfS3R0hVHAEc+lyN6PKyqbjWm4g7U44XWnVr3yYiPkxYGAem3bHKDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739277401; c=relaxed/simple;
	bh=Ttmeqgnv2ilpTlQqlY790DVU6ka7haU77u2bRHQqzc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ywo8ptIcDRia+G6w1d/1ZJN4P6UkaxX9nxB0LeCaR1C5e+DnUXh66zCBjXujw/3uUtl8aR8vXmC7h0P16BRrW1tEjrc38EQ//taRgDiJD2O1OF0pJ1rkrrQfMvI/VSeCLuCR52SDaifwHxRlBNJXtNdXtnb9ywxOYkL/PxK9gHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F48D1424;
	Tue, 11 Feb 2025 04:37:00 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8A6C3F6A8;
	Tue, 11 Feb 2025 04:36:37 -0800 (PST)
Date: Tue, 11 Feb 2025 12:36:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 06/18] KVM: arm64: Plug FEAT_GCS handling
Message-ID: <Z6tEUzwcHVHALIdu@J2N7QTR9R3>
References: <20250210184150.2145093-1-maz@kernel.org>
 <20250210184150.2145093-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210184150.2145093-7-maz@kernel.org>

On Mon, Feb 10, 2025 at 06:41:37PM +0000, Marc Zyngier wrote:
> We don't seem to be handling the GCS-specific exception class.
> Handle it by delivering an UNDEF to the guest, and populate the
> relevant trap bits.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 11 +++++++++++
>  arch/arm64/kvm/sys_regs.c    |  8 ++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 4f8354bf7dc5f..624a78a99e38a 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -294,6 +294,16 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
> +{
> +	/* We don't expect GCS, so treat it with contempt */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> +		WARN_ON_ONCE(1);

Just to check / better my understanging, do we enforce that this can't
be exposed to the guest somewhere?

I see __kvm_read_sanitised_id_reg() masks it out, and the sys_reg_descs
table has it filtered, but I'm not immediately sure whether that
prevents host userspace maliciously setting this?

Otherwise this looks good to me.

Mark.

> +
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
>  static int handle_ls64b(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -384,6 +394,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
>  	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
>  	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
> +	[ESR_ELx_EC_GCS]	= kvm_handle_gcs,
>  };
>  
>  static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 18721c773475d..2ecd0d51a2dae 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5056,6 +5056,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  						HFGITR_EL2_nBRBIALL);
>  	}
>  
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP)) {
> +		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nGCS_EL0 |
> +						HFGxTR_EL2_nGCS_EL1);
> +		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nGCSPUSHM_EL1 |
> +						HFGITR_EL2_nGCSSTR_EL1 |
> +						HFGITR_EL2_nGCSEPP);
> +	}
> +
>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);
> -- 
> 2.39.2
> 

