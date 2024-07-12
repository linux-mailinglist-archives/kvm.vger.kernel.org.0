Return-Path: <kvm+bounces-21490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4BDF92F71C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 661252828BB
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703421422D2;
	Fri, 12 Jul 2024 08:40:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DFA13D891
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773642; cv=none; b=mMj3kGwoUxV6gEQ2Px1xcj3ck8K0VGuNvkD4mL8dQ9ihi1DXFemqRe394OnCPUbV0RhjCWfl3vg3jqtFvRqol3MCShxiXq6vQlpkebFDNW8CMSMZ463Q35UQdK9VubH78gjZfm++Gc4CMtRkhPRUED97RrpRul3U0pkFhyLmUfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773642; c=relaxed/simple;
	bh=ltLjDfKdWvKKz9H6nMh77gNr8vD1HxpJwvrK6q/HV6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2kgIGsN0klwx+Z5KjCmsktCplZGvq3ly3yUeGOsFxM7IMeK6V1IMmGzu4lI7NX4rTqt5mTGqMJCD6qclVF8sDXVkoYyffYq8LpX/7OXsrIxbSEvwvoMT3CQbTPndV4tvdZdyXRw8eriypMPX3Ya2QX/rr1uodn6hFDeg3nS9Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CB931007;
	Fri, 12 Jul 2024 01:41:03 -0700 (PDT)
Received: from [10.162.16.42] (a077893.blr.arm.com [10.162.16.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8634B3F762;
	Fri, 12 Jul 2024 01:40:35 -0700 (PDT)
Message-ID: <e298568d-7b9a-4e01-95c1-ef98e1f50c82@arm.com>
Date: Fri, 12 Jul 2024 14:10:32 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] KVM: arm64: nv: Honor absence of FEAT_PAN2
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-5-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240625133508.259829-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 19:05, Marc Zyngier wrote:
> If our guest has been configured without PAN2, make sure that
> AT S1E1{R,W}P will generate an UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 832c6733db307..06c39f191b5ec 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4585,6 +4585,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  						HFGITR_EL2_TLBIRVAAE1OS	|
>  						HFGITR_EL2_TLBIRVAE1OS);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
> +		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
> +						HFGITR_EL2_ATS1E1WP);
> +
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
>  		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
>  						HFGxTR_EL2_nPIR_EL1);
As you had explained earlier about FGT UNDEF implementation, the above
code change makes sense.

FWIW

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

