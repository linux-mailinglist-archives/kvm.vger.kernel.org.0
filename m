Return-Path: <kvm+bounces-21473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A029C92F5EF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61908282FDA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D587713D8B1;
	Fri, 12 Jul 2024 07:06:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539FE13D601
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 07:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720768001; cv=none; b=dAcfNfin1sO69oUAY1OIJ/X28SgoWRug3ZhbIeor3AimJ1MRowJRrSSQEOQruMeraP6iO0UKmeyHpiZbwrKnjoIz7IYa+ckuSYDEff50winnbt24pkhoL5TNAiaGQT2PTodnGHJNM5zfTBcVtNAufb/wmVXkW+sBg4nZ9b4Kkx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720768001; c=relaxed/simple;
	bh=cbQ/K9djjTwY3qgVFPWEXaW7CSFSQKqggIw+V+y5YLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ph6eWIZuG3YOuILQLWXXJhsMQySQ2Dtr9HYwf8wjwKCSqT/ZTCqAi7eT6/MJZjBGhp5nkKKVHo5UAD18lCjbgcBBsRcZ5xh4iPI+RdWkhgAMb0NLPPw0jSPrEwfmfO85o5N+zdwtcbxaGTvcVhCEMnntQQsVESrTHc5MMy34WmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE0461007;
	Fri, 12 Jul 2024 00:07:02 -0700 (PDT)
Received: from [10.162.16.42] (a077893.blr.arm.com [10.162.16.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBED73F762;
	Fri, 12 Jul 2024 00:06:34 -0700 (PDT)
Message-ID: <b9b8775f-8dc1-4a9d-a884-7103f18d68f1@arm.com>
Date: Fri, 12 Jul 2024 12:36:31 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] arm64: Add PAR_EL1 field description
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-3-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240625133508.259829-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/24 19:05, Marc Zyngier wrote:
> As KVM is about to grow a full emulation for the AT instructions,
> add the layout of the PAR_EL1 register in its non-D128 configuration.

Right, there are two variants for PAR_EL1 i.e D128 and non-D128. Probably it makes
sense to define all these PAR_EL1 fields in arch/arm64/include/asm/sysreg.h, until
arch/arm64/tools/sysreg evolves to accommodate different bit field layouts for the
same register.

> 
> Note that the constants are a bit ugly, as the register has two
> layouts, based on the state of the F bit.

Just wondering if it would be better to append 'VALID/INVALID' suffix
for the fields to differentiate between when F = 0 and when F = 1 ?

s/SYS_PAR_EL1_FST/SYS_PAR_INVALID_FST_EL1
s/SYS_PAR_EL1_SH/SYS_PAR_VALID_SH_EL1

Or something similar.

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index be41528194569..15c073359c9e9 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -325,7 +325,25 @@
>  #define SYS_PAR_EL1			sys_reg(3, 0, 7, 4, 0)
>  
>  #define SYS_PAR_EL1_F			BIT(0)
> +/* When PAR_EL1.F == 1 */
>  #define SYS_PAR_EL1_FST			GENMASK(6, 1)
> +#define SYS_PAR_EL1_PTW			BIT(8)
> +#define SYS_PAR_EL1_S			BIT(9)
> +#define SYS_PAR_EL1_AssuredOnly		BIT(12)
> +#define SYS_PAR_EL1_TopLevel		BIT(13)
> +#define SYS_PAR_EL1_Overlay		BIT(14)
> +#define SYS_PAR_EL1_DirtyBit		BIT(15)
> +#define SYS_PAR_EL1_F1_IMPDEF		GENMASK_ULL(63, 48)
> +#define SYS_PAR_EL1_F1_RES0		(BIT(7) | BIT(10) | GENMASK_ULL(47, 16))
> +#define SYS_PAR_EL1_RES1		BIT(11)
> +/* When PAR_EL1.F == 0 */
> +#define SYS_PAR_EL1_SH			GENMASK_ULL(8, 7)
> +#define SYS_PAR_EL1_NS			BIT(9)
> +#define SYS_PAR_EL1_F0_IMPDEF		BIT(10)
> +#define SYS_PAR_EL1_NSE			BIT(11)
> +#define SYS_PAR_EL1_PA			GENMASK_ULL(51, 12)
> +#define SYS_PAR_EL1_ATTR		GENMASK_ULL(63, 56)
> +#define SYS_PAR_EL1_F0_RES0		(GENMASK_ULL(6, 1) | GENMASK_ULL(55, 52))
>  
>  /*** Statistical Profiling Extension ***/
>  #define PMSEVFR_EL1_RES0_IMP	\

