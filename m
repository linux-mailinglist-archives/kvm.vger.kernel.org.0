Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A8333F7AB
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 18:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCQR5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 13:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhCQR5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 13:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E07664F0F;
        Wed, 17 Mar 2021 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616003860;
        bh=KLrz/zlZvv0deqnTNA4E5YrAwOuKGvg1QIpXtpi+EK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BY8USoWjrrilAobRONwMs0Nq33hyLtCVksyL4S7NKSyHLT6U/f2Xa3IslxnTdhD07
         cQ6QnOEJlaNLL21vzJ3pgocSZuNvsj0/VKXWFTuJbdUuVVNZcwbDy2KYym4GRIBlfd
         xzMtrcyqT0ww4WtZ8THMiLnJAw2EeMosVV584bglsTQBSZhmiH+VvfwBLw4vLDiTPi
         j7Tws89nEtSJZtqUE6aVbC8hv7gNHKUMJNYECw8+88A7rQr3b260WD1LbSFHT5c9Fq
         rJbLuRDKKRHE78Sv+j2Btar3gYfMyfRuor76510v1pcsX1OUj8+ypsW9OiVlvhjR9N
         PLqFOTfhZhTFQ==
Date:   Wed, 17 Mar 2021 17:57:35 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 09/10] KVM: arm64: Save/restore SVE state for nVHE
Message-ID: <20210317175734.GA5713@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-10-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:11AM +0000, Marc Zyngier wrote:
> Implement the SVE save/restore for nVHE, following a similar
> logic to that of the VHE implementation:
> 
> - the SVE state is switched on trap from EL1 to EL2
> 
> - no further changes to ZCR_EL2 occur as long as the guest isn't
>   preempted or exit to userspace
> 
> - on vcpu_put(), ZCR_EL2 is reset to its default value, and ZCR_EL1
>   restored to the default guest value
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c                 | 15 ++++++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++----------------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +--
>  3 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index b5f95abd23f5..cc6cdea69596 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -121,11 +121,22 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> -		if (guest_has_sve)
> +		if (guest_has_sve) {
>  			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
>  
> +			/* Restore the VL that was saved when bound to the CPU */
> +			if (!has_vhe()) {
> +				u64 zcr;
> +
> +				kvm_call_hyp(__kvm_reset_sve_vq);

What would go wrong if we did this unconditionally on return to the host, or
is it just a performance thing to move work off the fast path where we
return back to the same vCPU?

Will
