Return-Path: <kvm+bounces-54783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB829B27F23
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 13:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61E3EAE127F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 11:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E114F2FFDF1;
	Fri, 15 Aug 2025 11:25:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF162FF641
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755257140; cv=none; b=DKKLZqyDgRs/K6mTvLCnc2Udyp60IpHNXTfVSlND+URaoQgZsCbyPp3QPig3JacbRTXg/lMQziMHnb9+//m+ixTESRiszTHqvuGfskHzrllS+cqKUn/7FqW4OkLO9tu4WW3Xv0PvYQFjtll9JwDEiYcA1CcJnUgZCOGWZs8sB7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755257140; c=relaxed/simple;
	bh=2lzXOWJ6+CjIHKc6yoYPTTvNgLSZvKjQaVOypXtgbYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WiHDV16fJBqFsT9OzfeIwxMTki/bvGU8Y69Z7Q1UF8DUIFMbf37fAL+qJffi1j3fZsn7qJBpsceLhlsYRuVOIppweqCVA+bzd+FnWbdlBFeKU8TqueaDI0e2Md2IYbpGjD5bbcYuCy/sXxhDC3z8cwkK2QYiR6+jXnBp15jLuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D2B71691;
	Fri, 15 Aug 2025 04:25:30 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB5673F63F;
	Fri, 15 Aug 2025 04:25:36 -0700 (PDT)
Message-ID: <9338d248-1392-414f-8bbe-dedce8cb048c@arm.com>
Date: Fri, 15 Aug 2025 12:25:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Correctly populate FAR_EL2 on nested SEA
 injection
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20250813163747.2591317-1-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250813163747.2591317-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

This patch looks good to me. Just a typo in the commit message.

On 8/13/25 17:37, Marc Zyngier wrote:
> vcoy_write_sys_reg()'s signature is not totally obvious, and it
typo: s/vcoy/vcpu/
> is rather easy to write something that looks correct, except that...
> Oh wait...
> 
> Swap addr and FAR_EL2 to restore some sanity in the nested SEA
> department.
> 
> Fixes: 9aba641b9ec2a ("KVM: arm64: nv: Respect exception routing rules for SEAs")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/emulate-nested.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 90cb4b7ae0ff7..af69c897c2c3a 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2833,7 +2833,7 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
>   			     iabt ? ESR_ELx_EC_IABT_LOW : ESR_ELx_EC_DABT_LOW);
>   	esr |= ESR_ELx_FSC_EXTABT | ESR_ELx_IL;
>   
> -	vcpu_write_sys_reg(vcpu, FAR_EL2, addr);
> +	vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
>   
>   	if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
>   		return kvm_inject_nested(vcpu, esr, except_type_serror);

Thanks,

Ben


