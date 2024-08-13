Return-Path: <kvm+bounces-24021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 537619508FB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85C111C2444E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBC31991BE;
	Tue, 13 Aug 2024 15:25:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37F9368
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562699; cv=none; b=eJfghlc3pRa58ZbgBshdhiUI+mWoWphc6bRkV9rQiN9idq49J4uwdUamjhBcEA7ClxolZ8nozqXGg/Ds4ap74DzCCzMm4lSHIcWMRKW26qImCPr8v+0v1NSsE9t+LddMIo4dw8BRCcfZEccFXUGiIpwUzIfmkzS/ew5eBAmgRMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562699; c=relaxed/simple;
	bh=6a/qfo4Q+D0Uel4fS4iHNUaGWqrYEayNa00t1cToIpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RX3dhZpiPvZUd+HVNuYQwk9c7b7mMYuhOCxeoPpbEaXSMyVDk1FtW1Hf2TGgicTxZ5QFXHYth9yaQ8jVv6ltcyYsc+3U5w8jUeGuA82Au0B1maI8dvebIem+bjteQHIGT9j7a10pw6A5JhAhm4c07T/zIm7qf6OTKGz//SOl1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C6A712FC;
	Tue, 13 Aug 2024 08:25:22 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB0D73F6A8;
	Tue, 13 Aug 2024 08:24:54 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:24:52 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 09/10] KVM: arm64: Handle  PIR{,E0}_EL2 traps
Message-ID: <20240813152452.GD3321997@e124191.cambridge.arm.com>
References: <20240813144738.2048302-1-maz@kernel.org>
 <20240813144738.2048302-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144738.2048302-10-maz@kernel.org>

On Tue, Aug 13, 2024 at 03:47:37PM +0100, Marc Zyngier wrote:
> Add the FEAT_S1PIE EL2 registers the sysreg descriptor array so that
> they can be handled as a trap.
> 
> Access to these registers is conditionned on ID_AA64MMFR3_EL1.S1PIE
> being advertised.
> 
> Similarly to other other changes, PIRE0_EL2 is guaranteed to trap
> thanks to the D22677 update to the architecture..
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 52250db3c122..a5f604e24e05 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -346,6 +346,18 @@ static bool access_rw(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
> +				  struct sys_reg_params *p,
> +				  const struct sys_reg_desc *r)
> +{
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
> +		kvm_inject_undefined(vcpu);
> +		return false;
> +	}
> +
> +	return access_rw(vcpu, p, r);
> +}
> +
>  /*
>   * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
>   */
> @@ -2827,6 +2839,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
>  
>  	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
> +	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
>  	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
>  
>  	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),

I think we should also use this for PIR_EL1 / PIRE0_EL1? We have NULL for their access field.

	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },

