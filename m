Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9EE33F66D
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 18:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCQRSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 13:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhCQRRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 13:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87EA864DDA;
        Wed, 17 Mar 2021 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616001464;
        bh=f3UV9P1ez1H29l2EmF0j0dk0b+DNBxiRJEGlA20Jt7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCOwbD4OrXNYihuHcVUWjgB96Cox8G+wQdO8UjpBecet6+c9mVYfBWE96NBhWa6KF
         N6rOyg/RIK28DWvYCjPAudJELrpnPW1bAUnQLHffda+AOY8HGbiJtvdkP2ke8H1Xrw
         iDYaQo27HauVEDJGrIzwEX6gwTb+qGumbdqXvjgRDpqssM8VxiCBzYBLP++jIhfbP4
         iPWbrNEIQw7x9Ojg15j2CFxtbLMQGj+SweOWIkh7FqJmygEPPifeSbcmZAL8Afu481
         BdeP8Ml9tx/JhvR/YwDSJL0ojBN4XRFXsyrGmJicZM8LxBiqiLu9et1MjsX9SjRdXq
         aFC62mSOLlFDw==
Date:   Wed, 17 Mar 2021 17:17:39 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 07/10] KVM: arm64: Save guest's ZCR_EL1 before saving the
 FPSIMD state
Message-ID: <20210317171738.GA5640@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-8-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:09AM +0000, Marc Zyngier wrote:
> Make sure the guest's ZCR_EL1 is saved before we save/flush the
> state. This will be useful in later patches.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 84afca5ed6f2..b5f95abd23f5 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -121,10 +121,10 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> -		fpsimd_save_and_flush_cpu_state();
> -
>  		if (guest_has_sve)
>  			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
> +
> +		fpsimd_save_and_flush_cpu_state();

I _think_ fpsimd_save_and_flush_cpu_state() contains a RDVL instruction
to get at the vector length for sve_get_vl(), and this ends up reading from
ZCR_EL1. So I'm not sure it's save to move it like this.

Will
