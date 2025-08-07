Return-Path: <kvm+bounces-54255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40EE5B1D854
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 14:56:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C23E722D10
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 12:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3342550DD;
	Thu,  7 Aug 2025 12:55:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD97252287
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754571344; cv=none; b=fE9zIatP9BNuVxFwRJjZMJI4ZcJY8c7vb7nPEzpL6H2LT3E7RdfBngFZNbuCCBh1kXXXXgJhxZzPhE+sqyjprOrII5ibts5qB7DnBDqzXtfCNi9coDOr3MSfgKNFkil/+mqYLyQ5miPuVQlPPs2ke0Qj1bJDssA+at/FBUuZF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754571344; c=relaxed/simple;
	bh=h2H0F3yEEGIlcD1VJmopqC8FoJgWxNjjGL9lY6FErqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP+1wqf498b+coLRq3E1o/GlciVvWtflQazRsBw8RrpAsvycCxCWhXWCKcsXOeO7k2pcqfdWpW29f4fLRvM5WQtXp8/DRjiKh2Lon5xAes4zg2oOUZ8S4GiP2XKh15OCFcEisPwycyOp7Dvo+Lf/JNDMVlM4lw6T/Y6jQb9X0aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C7841713;
	Thu,  7 Aug 2025 05:55:27 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCA5A3F5A1;
	Thu,  7 Aug 2025 05:55:33 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:55:31 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Expose FEAT_RASv1p1 in a canonical
 manner
Message-ID: <20250807125531.GB2351327@e124191.cambridge.arm.com>
References: <20250806165615.1513164-1-maz@kernel.org>
 <20250806165615.1513164-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806165615.1513164-5-maz@kernel.org>

On Wed, Aug 06, 2025 at 05:56:14PM +0100, Marc Zyngier wrote:
> If we have RASv1p1 on the host, advertise it to the guest in the
> "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
> the convoluted RAS+RAS_frac method.
> 
> Note that this also advertises FEAT_DoubleFault, which doesn't
> affect the guest at all, as only EL3 is concerned by this.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1b4114790024e..66e5a733e9628 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1800,6 +1800,18 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>  	if (!vcpu_has_sve(vcpu))
>  		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
>  
> +	/*
> +	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
> +	 * is cleared separately. Note that by advertising RASv1p1 here, we

Where is it cleared? __kvm_read_sanitised_id_reg() is where I would have
expected to see it:

    case SYS_ID_AA64PFR1_EL1:                                                                                                                                                                  
        if (!kvm_has_mte(vcpu->kvm)) {                                                                                                                                                         
            val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);                                                                                                                                   
            val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE_frac);                                                                                                                              
        }                                                                                                                                                                                      
                                                                                                                                                                                               
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);                                                                                                                                       
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_RNDR_trap);                                                                                                                                 
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_NMI);                                                                                                                                       
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_GCS);                                                                                                                                       
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_THE);                                                                                                                                       
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTEX);                                                                                                                                      
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_PFAR);                                                                                                                                      
        val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MPAM_frac);                                                                                                                                 
        break;                                                                  

> +	 * implicitly advertise FEAT_DoubleFault. However, since that last
> +	 * feature is a pure EL3 feature, this is not relevant for the
> +	 * guest, and we save on the complexity.
> +	 */
> +	if (cpus_have_final_cap(ARM64_HAS_RASV1P1_EXTN)) {
> +		val &= ~ID_AA64PFR0_EL1_RAS;
> +		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, V1P1);
> +	}
> +
>  	/*
>  	 * The default is to expose CSV2 == 1 if the HW isn't affected.
>  	 * Although this is a per-CPU feature, we make it global because
> -- 
> 2.39.2
> 

