Return-Path: <kvm+bounces-55273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 77912B2F9BD
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 483404E6156
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EAC326D7F;
	Thu, 21 Aug 2025 13:13:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B022D3746
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782038; cv=none; b=WZ3iw9Cel+nKg8jceaa4pSQ5xGyVUzbEDTiOInB/swbu2ZW33T62vZr0rJb4mDzJck6uAWFIlvzp1Eg6f6wAIHTsn/8uNE83LpWcumEKjpQYprFvPaDQBfTbqlgsargZ4m7k04Sh49Q80KhrF/hf55WTEcc0rzt8soyqIT2Ngrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782038; c=relaxed/simple;
	bh=6h4PscvxNqafL2iDhMLLEtrYUEmzx7ivJsKaxJKuD3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P0zGgyTBKcksYJ4mAwhGX0AjJox3X/TgZLC95I249p8VNu5jsm+KVtPyyUkd+1X9feb0MTBRIeUru83cTXtlianmdfcfbsZb7yDumGlZRI7yR/RbX7ZN9F5o7KcxSPDbl55Dmzb9+0X43/VLmaIb/nvrW17MXEIJcSB7lZAGOy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E3F8152B;
	Thu, 21 Aug 2025 06:13:47 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9EFC3F58B;
	Thu, 21 Aug 2025 06:13:53 -0700 (PDT)
Message-ID: <95819606-ef3b-46e1-8201-1abf0219659f@arm.com>
Date: Thu, 21 Aug 2025 14:13:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: arm64: Handle RASv1p1 registers
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-3-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250817202158.395078-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/17/25 21:21, Marc Zyngier wrote:
> FEAT_RASv1p1 system registeres are not handled at all so far.
> KVM will give an embarassed warning on the console and inject
s/embarassed/embarrassed/

> an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.
> 
> Handle these registers similarly to FEAT_RAS, with the added fun
> that there are *two* way to indicate the presence of FEAT_RASv1p1.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 82ffb3b3b3cf7..feb1a7a708e25 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2697,6 +2697,18 @@ static bool access_ras(struct kvm_vcpu *vcpu,
>   	struct kvm *kvm = vcpu->kvm;
>   
>   	switch(reg_to_encoding(r)) {
> +	case SYS_ERXPFGCDN_EL1:
> +	case SYS_ERXPFGCTL_EL1:
> +	case SYS_ERXPFGF_EL1:
> +	case SYS_ERXMISC2_EL1:
> +	case SYS_ERXMISC3_EL1:
> +		if (!(kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
> +		      (kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, IMP) &&
> +		       kvm_has_feat(kvm, ID_AA64PFR1_EL1, RAS_frac, RASv1p1)))) {
> +			kvm_inject_undefined(vcpu);
> +			return false;
> +		}
> +		break;
>   	default:
>   		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
>   			kvm_inject_undefined(vcpu);
The default condition needs updating for the case when 
ID_AA64PFR0_EL1.RAS = b10 otherwise access to the non-v1 specific RAS 
registers will result in an UNDEF being injected.

> @@ -3063,8 +3075,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGF_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGCTL_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGCDN_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXMISC2_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXMISC3_EL1), access_ras },
>   
>   	MTE_REG(TFSR_EL1),
>   	MTE_REG(TFSRE0_EL1),

-- 
Thanks,

Ben


