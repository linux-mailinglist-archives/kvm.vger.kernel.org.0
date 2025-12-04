Return-Path: <kvm+bounces-65274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C9BFFCA3521
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 11:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4D6D30DC02D
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 10:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C9C2E88B6;
	Thu,  4 Dec 2025 10:52:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507982E8B67
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 10:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845556; cv=none; b=atvX1aAa7rKsyLnxaRaQ8NruAimV/JHXOLxtQPZERE5DrT88JiyRZApOxNELHGuKSUK/wOOonqBuZzmtawQL2w0cbzKmCTDDn0qbX50N8bAM0v2qq7g8SlTCuOLUdGJATxD+wSv+xkfGySRFzs26K/tMmdEq+CZvXZ/Fhgh/XAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845556; c=relaxed/simple;
	bh=jLgV+Ozu4o70AcCXJA++YR4MO939yACBlwIJ27BPj0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2yJ3XiZER+KSBRqFI4yW/TNOuIu/P1WGO3lV6ucUTKpZ5c3SqwkSAFsvjBAZ8rWQxq8l4vfm3F2rNwUDYnp8iEKWUmKubJWn80m2UMqQVIyOlbgXq6lqGX/0YBx6OX0JIsgJBuARz+w38ZIAs2TjBLTJUQ9Cu9LuYVbyrWh04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5717A339;
	Thu,  4 Dec 2025 02:52:27 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AD8A3F59E;
	Thu,  4 Dec 2025 02:52:32 -0800 (PST)
Date: Thu, 4 Dec 2025 10:52:30 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v3 4/9] KVM: arm64: Handle FEAT_IDST for sysregs without
 specific handlers
Message-ID: <20251204105230.GB98666@e124191.cambridge.arm.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-5-maz@kernel.org>

On Thu, Dec 04, 2025 at 09:48:01AM +0000, Marc Zyngier wrote:
> Add a bit of infrastrtcture to triage_sysreg_trap() to handle the
> case of registers falling into the Feature ID space that do not
> have a local handler.
> 
> For these, we can directly apply the FEAT_IDST semantics and inject
> an EC=0x18 exception. Otherwise, an UNDEF will do.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 616eb6ad68701..fac2707221b47 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2588,6 +2588,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  
>  		params = esr_sys64_to_params(esr);
>  
> +		/*
> +		 * This implements the pseudocode UnimplementedIDRegister()
> +		 * helper for the purpose of fealing with FEAT_IDST.
                                            *dealing

> +		 *
> +		 * The Feature ID space is defined as the System register
> +		 * space in AArch64 with op0==3, op1=={0, 1, 3}, CRn==0,
> +		 * CRm=={0-7}, op2=={0-7}.
> +		 */
> +		if (params.Op0 == 3 &&
> +		    !(params.Op1 & 0b100) && params.Op1 != 2 &&
> +		    params.CRn == 0 &&
> +		    !(params.CRm & 0b1000)) {
> +			if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, IMP))
> +				kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +			else
> +				kvm_inject_undefined(vcpu);
> +
> +			return true;
> +		}
> +
>  		/*
>  		 * Check for the IMPDEF range, as per DDI0487 J.a,
>  		 * D18.3.2 Reserved encodings for IMPLEMENTATION
> -- 
> 2.47.3
> 

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

