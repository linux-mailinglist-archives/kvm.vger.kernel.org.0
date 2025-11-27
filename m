Return-Path: <kvm+bounces-64823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFE5C8CE29
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 06:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 92BC74E27EE
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 05:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741A6285C9F;
	Thu, 27 Nov 2025 05:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XgfgsGm0"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C7C27A460
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 05:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764223058; cv=none; b=q3qYpHi7+u7aDjDcfz3RXrsG3Sf74Mnt9CFi+aqBGthL3vaVf2jXCHAaNgGjGuiPOAg0uMJfoylddGQjQwIvyzAR8Ks3jwgEvCECvkjIGhTQyRZdfAzauMWjVJVQNQMTDgQjyIv1Qiiemxmfzw4A0u+8z2UV7ix1Fa5S8QyzfaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764223058; c=relaxed/simple;
	bh=5r9eZwZ6KTr5agpykZihNFQhd97KIwo36+xrKGwxqpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hpz+O+pWsB4yTRDt5/CxVJGrZEGFaQwdCNTwcmGS5Xugpf55PBUATcDcxqzpSbJVtIN+Rzv+Hz4bRqFdT3dDkLIDcnmvZkrYyY7eGfSafzbjH5bELTr1dssbWCk/5CxkFDyVGSnLx/7DxrkaNg2ebn49+NaTJgo/oua/wRQgi2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XgfgsGm0; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764223045; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=4QKv6ZOvX2SBICDdmwi+E+eWq1SX0cudMyw17vPaerg=;
	b=XgfgsGm0CRSvGFqDKUjo/SPiX0SmdXhP2iZexrOJVSN3r8GJgZT7Td0cuy8QBHiH6OQlWp4o+8q7UIDWo0qh6rmDmUUulmGg7c65Bplebq2+8339+UsVNw+WoVPEIDSdrD4aXn0MDlIKYNlc77beukkpwEiNa7/7uHGGi7Lj+KM=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WtVwrDT_1764223044 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Nov 2025 13:57:24 +0800
Date: Thu, 27 Nov 2025 13:57:24 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add a generic synchronous exception
 injection primitive
Message-ID: <5f65l5sg5xxxzoh3uuqixwqrvkuwfvaqhkz2u4mme2jw2rcfzq@oq4lhswlquxt>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126155951.1146317-4-maz@kernel.org>

On Wed, Nov 26, 2025 at 03:59:49PM +0800, Marc Zyngier wrote:
> Maybe in a surprising way, we don't currently have a generic way
> to inject a synchronous exception at the EL the vcpu is currently
> running at.

Hi Marc,

Thanks for bring this in generic way.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Extract such primitive from the UNDEF injection code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  1 +
>  arch/arm64/kvm/inject_fault.c        | 10 +++++++---
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c9eab316398e2..df20d47f0d256 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -45,6 +45,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
>  void kvm_skip_instr32(struct kvm_vcpu *vcpu);
>
>  void kvm_inject_undefined(struct kvm_vcpu *vcpu);
> +void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr);
>  int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
>  int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
>  void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index dfcd66c655179..7102424a3fa5e 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -162,12 +162,16 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>  	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
>  }
>
> +void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr)
> +{
> +	pend_sync_exception(vcpu);
> +	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
> +}
> +
>  static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
>  	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
>
> -	pend_sync_exception(vcpu);
> -
>  	/*
>  	 * Build an unknown exception, depending on the instruction
>  	 * set.
> @@ -175,7 +179,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_trap_il_is32bit(vcpu))
>  		esr |= ESR_ELx_IL;
>
> -	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
> +	kvm_inject_sync(vcpu, esr);
>  }
>
>  #define DFSR_FSC_EXTABT_LPAE	0x10
> --
> 2.47.3
>

