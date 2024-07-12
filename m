Return-Path: <kvm+bounces-21492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF9D92F73B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41EA9B21B92
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C9B142645;
	Fri, 12 Jul 2024 08:52:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02C113DDBA
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720774333; cv=none; b=fLHAm6iApvu8g2GV++kNpWfhP5by4IkL57G60ENELqk7X4Ypot3VJsS4N8sGvubDIgbGsTUYOywxm6u8fj1UHjoXtZeJuPFq7Fd0O5plsBx5mrb/HLTkw8Atp2hHmYnILSna/5K46c8BDOZ+sgOHK4Obni8uBBnBpXeqLm7w7L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720774333; c=relaxed/simple;
	bh=sEF2yAZyYBBQOGvTWiLj4KI3aCdqAq3EYayOkxXFNAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z74PI6pdgmb/ZSxtN53OBdS6GapqPN79HHRjI2MIHUNvt/rhvJ+FOvvgw2rNH9EUdWQ1/ny9qBJpPXylQTjbWxCGIN8fHE2rWDfLhGO140NrdimkLXyGrdDHEHHU9SwalzNvHQm3/oDyY1+MVRqM1Bsl1pScCVNn7IBqT7AaQ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 668C31007;
	Fri, 12 Jul 2024 01:52:36 -0700 (PDT)
Received: from [10.162.16.42] (a077893.blr.arm.com [10.162.16.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72D8B3F641;
	Fri, 12 Jul 2024 01:52:08 -0700 (PDT)
Message-ID: <e4dd81b7-c168-4b71-ae5e-f2dde0609baf@arm.com>
Date: Fri, 12 Jul 2024 14:22:05 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] KVM: arm64: make kvm_at() take an OP_AT_*
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-6-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240625133508.259829-6-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/24 19:05, Marc Zyngier wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> To allow using newer instructions that current assemblers don't know about,
> replace the `at` instruction with the underlying SYS instruction.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h       | 3 ++-
>  arch/arm64/kvm/hyp/include/hyp/fault.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 2181a11b9d925..25f49f5fc4a63 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -10,6 +10,7 @@
>  #include <asm/hyp_image.h>
>  #include <asm/insn.h>
>  #include <asm/virt.h>
> +#include <asm/sysreg.h>
>  
>  #define ARM_EXIT_WITH_SERROR_BIT  31
>  #define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_SERROR_BIT))
> @@ -259,7 +260,7 @@ extern u64 __kvm_get_mdcr_el2(void);
>  	asm volatile(							\
>  	"	mrs	%1, spsr_el2\n"					\
>  	"	mrs	%2, elr_el2\n"					\
> -	"1:	at	"at_op", %3\n"					\
> +	"1:	" __msr_s(at_op, "%3") "\n"				\
>  	"	isb\n"							\
>  	"	b	9f\n"						\
>  	"2:	msr	spsr_el2, %1\n"					\
> diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
> index 9e13c1bc2ad54..487c06099d6fc 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/fault.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
> @@ -27,7 +27,7 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	 * saved the guest context yet, and we may return early...
>  	 */
>  	par = read_sysreg_par();
> -	if (!__kvm_at("s1e1r", far))
> +	if (!__kvm_at(OP_AT_S1E1R, far))
>  		tmp = read_sysreg_par();
>  	else
>  		tmp = SYS_PAR_EL1_F; /* back to the guest */

LGTM, FWIW

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

