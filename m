Return-Path: <kvm+bounces-9180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BCD85BB32
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:58:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95D9B1F217AE
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B3467C4C;
	Tue, 20 Feb 2024 11:58:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A50166B2C
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708430292; cv=none; b=HevB/0jhVWon8OPF4ouEZJqL5rq6EQC+0UQQEDhjQ3s9qcNOs51kWXKdg7SEyeL7rgz1zYd/CHp532N+EgwYWtHEsfuTT+Hg7hzcQe6qfsZLSSHPgNuoZwv5w0jq3zCQJFhxfIBjgn64r06MC6MmZheSsEMmEq4/Zw1KHdJ8hCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708430292; c=relaxed/simple;
	bh=DoSyF9oBMF7hKFHPTOjGEgAD/7Q3cAcgAGoQkG7Ph7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBVuafzSJOwmeUqe3LJ1FZQIpTfJImD0zH7pu05tnmPuXIzRfWKMMe5aGBSV7+k1bsO68O/IrNa11uCTrz5MzN8+KUbxvZHtqB/tkluiXB+AVWThQJmIqrH1XLDUNx3pvCIsAk2wXRMx8ZYT8aJPD5tlMwjLbj1eNHKch/siLJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A717FEC;
	Tue, 20 Feb 2024 03:58:49 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E9513F762;
	Tue, 20 Feb 2024 03:58:08 -0800 (PST)
Date: Tue, 20 Feb 2024 11:58:06 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 03/13] KVM: arm64: nv: Drop VCPU_HYP_CONTEXT flag
Message-ID: <20240220115806.GC16168@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219092014.783809-4-maz@kernel.org>

On Mon, Feb 19, 2024 at 09:20:04AM +0000, Marc Zyngier wrote:
> It has become obvious that HCR_EL2.NV serves the exact same use
> as VCPU_HYP_CONTEXT, only in an architectural way. So just drop
> the flag for good.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 --
>  arch/arm64/kvm/hyp/vhe/switch.c   | 7 +------
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a5ec4c7d3966..75eb8e170515 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -816,8 +816,6 @@ struct kvm_vcpu_arch {
>  #define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
>  /* Save TRBE context if active  */
>  #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
> -/* vcpu running in HYP context */
> -#define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
>  
>  /* SVE enabled for host EL0 */
>  #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 1581df6aec87..58415783fd53 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -197,7 +197,7 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * If we were in HYP context on entry, adjust the PSTATE view
>  	 * so that the usual helpers work correctly.
>  	 */
> -	if (unlikely(vcpu_get_flag(vcpu, VCPU_HYP_CONTEXT))) {
> +	if (unlikely(read_sysreg(hcr_el2) & HCR_NV)) {
>  		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
>  
>  		switch (mode) {
> @@ -240,11 +240,6 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> -	if (is_hyp_ctxt(vcpu))
> -		vcpu_set_flag(vcpu, VCPU_HYP_CONTEXT);
> -	else
> -		vcpu_clear_flag(vcpu, VCPU_HYP_CONTEXT);
> -
>  	do {
>  		/* Jump in the fire! */
>  		exit_code = __guest_enter(vcpu);

Makes sense to me.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

