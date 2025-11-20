Return-Path: <kvm+bounces-63866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A4CC74954
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E827B357FAB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 14:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41C227B35F;
	Thu, 20 Nov 2025 14:34:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23E126FA6C
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763649268; cv=none; b=KY0xwwU6Fj8qXqs9CIm4L59bgEiQ2P08X7AmyGe95FWKHzCzXXhNDcgW8Cn8IRLFnA5H9n8IuywiPLWgNPz30n/ybiQq9naffjkgYRuZ7LNJpTJVzLRZeHJ0N5HR47S2r2y5hNgjXiTr//1hu1gMzbriBRD82D6vV+tJ4Z4Oy3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763649268; c=relaxed/simple;
	bh=pQoPTUlu2GUkilY397z/5eMpaFU7yQbOEPxHhgU9k2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdxzfCjXBfw1qBg19btiTSVlmztb5u4/u3EtF6qL+lLYcNpeXJ0bOZ4XKBy0GrnEIsAhtz5OcNzCgY8fUx3f951hJNa8CwPUfH7w388NvgWwNQlpPbPizQdAyjxKrjFHT3KIrxgzEr9J20id3coXEgrdPwSevHG2GMR4fv11cpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C62BB339;
	Thu, 20 Nov 2025 06:34:18 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F8D63F740;
	Thu, 20 Nov 2025 06:34:24 -0800 (PST)
Date: Thu, 20 Nov 2025 14:34:19 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <20251120143419.GA2325986@e124191.cambridge.arm.com>
References: <20251120133202.2037803-1-maz@kernel.org>
 <20251120133202.2037803-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120133202.2037803-3-maz@kernel.org>

On Thu, Nov 20, 2025 at 01:31:59PM +0000, Marc Zyngier wrote:
> If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
> to force GMID_EL1 being trapped.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 84e6f04220589..40f32b017f107 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5558,6 +5558,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_has_mte(vcpu->kvm))
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
> +	else if (id_aa64pfr1_mte(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))
> +		vcpu->arch.hcr_el2 |= HCR_TID5;

This is because we want to enable the trapping regardless of CONFIG_ARM64_MTE
(so we can't use system_supports_mte()).

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

>  
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> -- 
> 2.47.3
> 

