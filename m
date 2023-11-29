Return-Path: <kvm+bounces-2729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6E47FCFCA
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 08:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E18391F21013
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 07:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87176125CE;
	Wed, 29 Nov 2023 07:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDCA91735
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 23:25:13 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB14F1FB;
	Tue, 28 Nov 2023 23:26:00 -0800 (PST)
Received: from [10.163.33.248] (unknown [10.163.33.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 132213F6C4;
	Tue, 28 Nov 2023 23:25:09 -0800 (PST)
Message-ID: <6d26f433-d176-4017-8f87-a1def77c468a@arm.com>
Date: Wed, 29 Nov 2023 12:55:08 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] arm64: Kill detection of VPIPT i-cache policy
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231127172613.1490283-1-maz@kernel.org>
 <20231127172613.1490283-3-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20231127172613.1490283-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/27/23 22:56, Marc Zyngier wrote:
> Since the kernel will never run on a system with the VPIPT i-cache
> policy, drop the detection code altogether.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/cache.h | 6 ------
>  arch/arm64/kernel/cpuinfo.c    | 5 -----
>  2 files changed, 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
> index ceb368d33bf4..06a4670bdb0b 100644
> --- a/arch/arm64/include/asm/cache.h
> +++ b/arch/arm64/include/asm/cache.h
> @@ -58,7 +58,6 @@ static inline unsigned int arch_slab_minalign(void)
>  #define CTR_L1IP(ctr)		SYS_FIELD_GET(CTR_EL0, L1Ip, ctr)
>  
>  #define ICACHEF_ALIASING	0
> -#define ICACHEF_VPIPT		1
>  extern unsigned long __icache_flags;
>  
>  /*
> @@ -70,11 +69,6 @@ static inline int icache_is_aliasing(void)
>  	return test_bit(ICACHEF_ALIASING, &__icache_flags);
>  }
>  
> -static __always_inline int icache_is_vpipt(void)
> -{
> -	return test_bit(ICACHEF_VPIPT, &__icache_flags);
> -}
> -
>  static inline u32 cache_type_cwg(void)
>  {
>  	return SYS_FIELD_GET(CTR_EL0, CWG, read_cpuid_cachetype());
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index a257da7b56fe..47043c0d95ec 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -36,8 +36,6 @@ static struct cpuinfo_arm64 boot_cpu_data;
>  static inline const char *icache_policy_str(int l1ip)
>  {
>  	switch (l1ip) {
> -	case CTR_EL0_L1Ip_VPIPT:
> -		return "VPIPT";
>  	case CTR_EL0_L1Ip_VIPT:
>  		return "VIPT";
>  	case CTR_EL0_L1Ip_PIPT:
> @@ -388,9 +386,6 @@ static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
>  	switch (l1ip) {
>  	case CTR_EL0_L1Ip_PIPT:
>  		break;
> -	case CTR_EL0_L1Ip_VPIPT:
> -		set_bit(ICACHEF_VPIPT, &__icache_flags);
> -		break;
>  	case CTR_EL0_L1Ip_VIPT:
>  	default:
>  		/* Assume aliasing */

