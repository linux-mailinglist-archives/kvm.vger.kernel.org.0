Return-Path: <kvm+bounces-54249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF86B1D66E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 13:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24CED164F69
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E6226CE20;
	Thu,  7 Aug 2025 11:12:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089791F4CA4
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 11:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754565156; cv=none; b=UDLRvuQh3l868tysMEkTCIykYtsnL3JxgPzk9TdThge34rb78kbvtv7LXlB5e/C977Wujj3SBXdJjmfuIeXJqYF6LJpP6hixww2i2ZmyzHpuqaXtxc6VZIqLakBulGIt+HJ5FkA6cNU/Tmey37ioztS8NWgqSl28+7pQCxVd2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754565156; c=relaxed/simple;
	bh=q0eCAjoRl5wMkzBKrrEko5BgJj8BUldNECWhkTCWr+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E93CBzCayOkDx6GO6zD+43i33lsmulKcN/sC8kRLP8WEKHvKvDlVUY3vtI4VlUqv61sK1jjS7z8SFwum1jXUw4lIOsQu+4Gnu5Ne6Xj7IMYaTVJLRhp9VUlIperreNJTa7sJvkeWWJEZmL0T9kzoKcj9leD1jrjbP6x1hKMRmPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5521C302F;
	Thu,  7 Aug 2025 04:12:25 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A78503F5A1;
	Thu,  7 Aug 2025 04:12:31 -0700 (PDT)
Date: Thu, 7 Aug 2025 12:12:26 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Handle RASv1p1 registers
Message-ID: <20250807111226.GA2351327@e124191.cambridge.arm.com>
References: <20250806165615.1513164-1-maz@kernel.org>
 <20250806165615.1513164-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806165615.1513164-3-maz@kernel.org>

Hi!

On Wed, Aug 06, 2025 at 05:56:12PM +0100, Marc Zyngier wrote:
> FEAT_RASv1p1 system registeres are not handled at all so far.
*registers
> KVM will give an embarassed warning on the console and inject
*embarrassed
> an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.
> 
> Handle these registers similarly to FEAT_RAS, with the added fun
> that there are *two* way to indicate the presence of FEAT_RASv1p1.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ad25484772574..1b4114790024e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2695,6 +2695,18 @@ static bool access_ras(struct kvm_vcpu *vcpu,
>  	struct kvm *kvm = vcpu->kvm;
>  
>  	switch(reg_to_encoding(r)) {
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
>  	default:
>  		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
>  			kvm_inject_undefined(vcpu);
> @@ -3058,8 +3070,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
>  	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
>  	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGF_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGCTL_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGCDN_EL1), access_ras },
>  	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
>  	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXMISC2_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXMISC3_EL1), access_ras },
>  
>  	MTE_REG(TFSR_EL1),
>  	MTE_REG(TFSRE0_EL1),
> -- 
> 2.39.2
> 

