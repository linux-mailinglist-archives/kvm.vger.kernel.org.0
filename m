Return-Path: <kvm+bounces-44771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 876FBAA0D11
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750DE17CF28
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1605F2AE99;
	Tue, 29 Apr 2025 13:08:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D71130A54
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932127; cv=none; b=fCx+/pWaViIOd841TKtKPo+D0et3JTvnffIKD2Y8ghr2aF1aPkHhD8Cu7dc4Xk/9fJZjsc4YbIczoKnNKoB0H1/MSHUmUYBJritRZ+QOjaiMYnhkEyyPu6195FFQ9eZjYmLc/8M4U7RQ3XdC89N81Co46bI8Mu/jqyyH7Q0gGGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932127; c=relaxed/simple;
	bh=aNoZoCHLVEn0I3qZULG97xe9/6aLnQL0LU8tKQfZfk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f/PFvudFfTmu3BIapXwLeg9RTVnFPaM3dW3kuJYxWkRKrGzg8uUWzYso4D6xuQyzxP3+lZwYmHRVUP1VlDSPdyEd5L8zs5RXgP/5DC6hIjQeRY/1cwjum/a0CRVZR+VhLS8cxJW63TfYpMG5n4QNAeQs4obvRmOdUACW3LjvrHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA1A91515;
	Tue, 29 Apr 2025 06:08:38 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2906A3F673;
	Tue, 29 Apr 2025 06:08:44 -0700 (PDT)
Message-ID: <8821ec7f-712e-4d70-b55f-f560b4002e86@arm.com>
Date: Tue, 29 Apr 2025 14:08:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 40/42] KVM: arm64: Allow sysreg ranges for FGT
 descriptors
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-41-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250426122836.3341523-41-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 4/26/25 13:28, Marc Zyngier wrote:
> Just like we allow sysreg ranges for Coarse Grained Trap descriptors,
> allow them for Fine Grain Traps as well.
> 
> This comes with a warning that not all ranges are suitable for this
> particular definition of ranges.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/emulate-nested.c | 120 +++++++++++---------------------
>   1 file changed, 39 insertions(+), 81 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index e2a843675da96..9c7ecfccbd6e9 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -622,6 +622,11 @@ struct encoding_to_trap_config {
>   	const unsigned int		line;
>   };
>   
> +/*
> + * WARNING: using ranges is a treacherous endeavour, as sysregs that
> + * are part of an architectural range are not necessarily contiguous
> + * in the [Op0,Op1,CRn,CRm,Ops] space. Tread carefully.
> + */
>   #define SR_RANGE_TRAP(sr_start, sr_end, trap_id)			\
>   	{								\
>   		.encoding	= sr_start,				\
> @@ -1289,15 +1294,19 @@ enum fg_filter_id {
>   
>   #define FGT(g, b, p)		__FGT(g, b, p, __NO_FGF__)
>   
> -#define SR_FGF(sr, g, b, p, f)					\
> +/* Same warning applies: use carefully */
Nit: The other warning is a few hundred lines away. Consider identifying 
it more precisely.
> +#define SR_FGF_RANGE(sr, e, g, b, p, f)				\
>   	{							\
>   		.encoding	= sr,				\
> -		.end		= sr,				\
> +		.end		= e,				\
>   		.tc		= __FGT(g, b, p, f),		\
>   		.line = __LINE__,				\
>   	} 
Thanks,

Ben


