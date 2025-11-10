Return-Path: <kvm+bounces-62499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9F9C46049
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 11:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01E5518836F1
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 10:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30CE3054F9;
	Mon, 10 Nov 2025 10:40:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E24301010
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762771226; cv=none; b=cqhLEp2fbjan/LZQ7BQYXUbRHS2KP3ILdPERZ+G+ED9chweJAoQZr2wckEoYWdVoA+C/xFvlShhSBSAe4PAf1Uk5KJTdfEWmO/FVIdeWXT5UiyySpqI5c53niSSNc5nGGuTYhF4ipNTFLhWujayhCzuQVBxUrtOw1glRVMtgtdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762771226; c=relaxed/simple;
	bh=8i2zPMoje5Db5aepFhq7c7rk3UWvoR7p+9rsDJZmqGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/zqRcy5eng56to6/PFqV/McbmVnyiQOm7KarAxSqJ+gQ8eJBCqdqCVoCq6GgxiLbq9LSCt5Ulh7elCrrSAn/ssdmq0xiVi0KWWAjjDiJcVj2kxO+K/gl5b5BfI38XbnH/cX9Yc7n1HtoD+B5VUbqdePbGi/sqYtbbM2G6nE3No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78DC8497;
	Mon, 10 Nov 2025 02:40:16 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03D223F66E;
	Mon, 10 Nov 2025 02:40:22 -0800 (PST)
Message-ID: <a914297b-753b-4fa0-8ffc-3a64b006316c@arm.com>
Date: Mon, 10 Nov 2025 10:40:21 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/45] KVM: arm64: Turn vgic-v3 errata traps into a
 patched-in constant
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
 Yao Yuan <yaoyuan@linux.alibaba.com>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-5-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251109171619.1507205-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 09/11/2025 17:15, Marc Zyngier wrote:
> The trap bits are currently only set to manage CPU errata. However,
> we are about to make use of them for purposes beyond beating broken
> CPUs into submission.
> 
> For this purpose, turn these errata-driven bits into a patched-in
> constant that is merged with the KVM-driven value at the point of
> programming the ICH_HCR_EL2 register, rather than being directly
> stored with with the shadow value..
> 
> This allows the KVM code to distinguish between a trap being handled
> for the purpose of an erratum workaround, or for KVM's own need.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

...

> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index ac5f9c5d2b980..0ecadfa00397d 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -164,6 +164,22 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
>   	return ret;
>   }
>   
> +void kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
> +				   __le32 *origptr, __le32 *updptr, int nr_inst);
> +
> +static inline u64 vgic_ich_hcr_trap_bits(void)
> +{
> +	u64 hcr;

minor nit: Do we need a guard to make sure this isn't called before the 
capabilities are finalized (given we may use it outside VM context, e.g. 
VGIC probe). perhaps :

WARN_ON(!system_capabilities_finalized());


> +
> +	/* All the traps are in the bottom 16bits */
> +	asm volatile(ALTERNATIVE_CB("movz %0, #0\n",
> +				    ARM64_ALWAYS_SYSTEM,
> +				    kvm_compute_ich_hcr_trap_bits)
> +		     : "=r" (hcr));


Suzuki

