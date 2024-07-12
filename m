Return-Path: <kvm+bounces-21484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E6AB92F6F5
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 476421F22AFF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C12A13F43C;
	Fri, 12 Jul 2024 08:32:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717F1AD52
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773141; cv=none; b=S6OJwQVkh2ZQ/Ssy2h9XnAy5bL04GvrAn+Sj18W7F8QvU+0qKaz/SEA7lKfGnbzY8v5G/cBMXxctU1TCZFDTDJ50hv2inzXEI0dVWszoVFGb84SjT+mwYvcX35rtiVtTl/fIxV8GovV7kX3qWa/AH387gjXGNXQxIHDjKdpoeHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773141; c=relaxed/simple;
	bh=8/xHC05DGQhKEy1hFf/44u7o5nCu4eJYz+7BZesPMWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eY67+ti9r8myIKeHoVo/NfWGve48Qr8fYdGtj5cPquJFtnxZSBEU93ExYiQN6Api7fZmh6l6DPLE0zO9e+/fhjnud9LmqTHED+tJuaXSaD1huYBwNzPdr8L0FtZI0/MoPpq06/KXXwSZw6xSuYGgIlewY8WtbJeWCns45+P7LI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA7D81007;
	Fri, 12 Jul 2024 01:32:42 -0700 (PDT)
Received: from [10.162.16.42] (a077893.blr.arm.com [10.162.16.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F021B3F762;
	Fri, 12 Jul 2024 01:32:14 -0700 (PDT)
Message-ID: <3fc8eccd-21a7-40d8-9851-24941c8414da@arm.com>
Date: Fri, 12 Jul 2024 14:02:12 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] arm64: Add missing APTable and TCR_ELx.HPD masks
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-2-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240625133508.259829-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/24 19:05, Marc Zyngier wrote:
> Although Linux doesn't make use of hierarchical permissions (TFFT!),
> KVM needs to know where the various bits related to this feature
> live in the TCR_ELx registers as well as in the page tables.
> 
> Add the missing bits.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h       | 1 +
>  arch/arm64/include/asm/pgtable-hwdef.h | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b2adc2c6c82a5..c93ee1036cb09 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -108,6 +108,7 @@
>  /* TCR_EL2 Registers bits */
>  #define TCR_EL2_DS		(1UL << 32)
>  #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
> +#define TCR_EL2_HPD		(1 << 24)
>  #define TCR_EL2_TBI		(1 << 20)
>  #define TCR_EL2_PS_SHIFT	16
>  #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 9943ff0af4c96..f75c9a7e6bd68 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -146,6 +146,7 @@
>  #define PMD_SECT_UXN		(_AT(pmdval_t, 1) << 54)
>  #define PMD_TABLE_PXN		(_AT(pmdval_t, 1) << 59)
>  #define PMD_TABLE_UXN		(_AT(pmdval_t, 1) << 60)
> +#define PMD_TABLE_AP		(_AT(pmdval_t, 3) << 61)

APTable bits are also present in all table descriptors at each non-L3
level. Should not corresponding corresponding macros i.e PUD_TABLE_AP,
P4D_TABLE_AP, and PGD_TABLE_AP be added as well ?

>  
>  /*
>   * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
> @@ -307,6 +308,12 @@
>  #define TCR_TCMA1		(UL(1) << 58)
>  #define TCR_DS			(UL(1) << 59)
>  
> +#define TCR_HPD0_SHIFT		41
> +#define TCR_HPD0		BIT(TCR_HPD0_SHIFT)
> +
> +#define TCR_HPD1_SHIFT		42
> +#define TCR_HPD1		BIT(TCR_HPD1_SHIFT)

Should not these new register fields follow the current ascending bit
order in the listing i.e get added after TCR_HD (bit 40).

> +
>  /*
>   * TTBR.
>   */

