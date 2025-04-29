Return-Path: <kvm+bounces-44772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FD5AA0D14
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA79E16D35B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920B42D0261;
	Tue, 29 Apr 2025 13:09:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA28130A54
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932159; cv=none; b=EsC/+QKpn2lMvXmOsDDl3HNFRLA/y5/sJ5vky0c+xchEM+MtkMU5T86r1WdiLtUci6ypwvm5cifz7fwzF3ynSeHRI9/MjkvFc3oW+FxEtfzha7al4P6N1UhmMWuiv4uyiqgoA2iGPw7VXX5B4Pbm/xaNXfbfKPvfFz3YHsub8a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932159; c=relaxed/simple;
	bh=4x0LE5ZtLiS2g8ZUvATcBw0Lt+5uO+qiKKF/+mXX2vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uO8c3ZJIeNibwE71uQXAHpKUWwGLGNUi1DnoO6Xk1btIAvPsS/VpiBWWrXbfapgQyysOWZByVOHSOuSuxmVQ8nL9Ey+cbtn0yyiiAoEXCbowA1vmlXBb6iRHF/aWiGY1J4TiE9GbcZYFJlZdvAtv4gkECGp+UQOdeZwC7AaJfO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AF5C1515;
	Tue, 29 Apr 2025 06:09:10 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A5673F673;
	Tue, 29 Apr 2025 06:09:15 -0700 (PDT)
Message-ID: <b956142a-b759-4f5a-b1a9-d8142a622f21@arm.com>
Date: Tue, 29 Apr 2025 14:09:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 41/42] KVM: arm64: Add FGT descriptors for FEAT_FGT2
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-42-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-42-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 4/26/25 13:28, Marc Zyngier wrote:
> Bulk addition of all the FGT2 traps reported with EC == 0x18,
> as described in the 2025-03 JSON drop.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/emulate-nested.c | 83 +++++++++++++++++++++++++++++++++
>   1 file changed, 83 insertions(+)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 9c7ecfccbd6e9..f7678af272bbb 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
[...]
>   	/*
>   	 * HDFGWTR_EL2
>   	 *
> @@ -1896,12 +1972,19 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>   	 * read-side mappings, and only the write-side mappings that
>   	 * differ from the read side, and the trap handler will pick
>   	 * the correct shadow register based on the access type.
> +	 *
> +	 * Same model applies to the FEAT_FGT2 registers.
>   	 */
>   	SR_FGT(SYS_TRFCR_EL1,		HDFGWTR, TRFCR_EL1, 1),
>   	SR_FGT(SYS_TRCOSLAR,		HDFGWTR, TRCOSLAR, 1),
>   	SR_FGT(SYS_PMCR_EL0,		HDFGWTR, PMCR_EL0, 1),
>   	SR_FGT(SYS_PMSWINC_EL0,		HDFGWTR, PMSWINC_EL0, 1),
>   	SR_FGT(SYS_OSLAR_EL1,		HDFGWTR, OSLAR_EL1, 1),
> +
> +	/* HDFGWTR_EL2 */
A missing 2. HDFGWTR_EL2 should be HDFGWTR2_EL2.
> +	SR_FGT(SYS_PMZR_EL0,		HDFGWTR2, nPMZR_EL0, 0),
> +	SR_FGT(SYS_SPMZR_EL0,		HDFGWTR2, nSPMEVCNTRn_EL0, 0),
> +
>   	/*
>   	 * HAFGRTR_EL2
>   	 */

Thanks,

Ben


