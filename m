Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D5133F29E
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhCQO37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhCQO3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD26164E13;
        Wed, 17 Mar 2021 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615991385;
        bh=pRyeN3C9RR8ZoBn+JDrcnrqSXZm0FGBncn5ju3CW/pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WEtBnbK+2Lv2Z95b90URCO95CaLSHi8BkVGa4AzUCI/lR62SGM/PCdaBk2q7lWEku
         5odB8LN8WIB4VXbZZ9K2RoKnkyc71245IMA30gq0GoD9TiDd8PkUcP7Y7kmcJFQ5CL
         kBbmXPfPb19bsDgc2YtNNaM9YxQuwH0wrK5m28BEo6Vomu6iu3ilAZJGMWtek7h6tg
         KZUT88WgMgnaVzjfI0tujzlvs6jxcbN8KQYHaTEbD5lgx8EQ1aY0/b9Qu+BcpZDpDY
         twx4K3ctZLfZI1M06qYEroOSMX1p+6tx162z7etwaSfS1a6TXhQ8I4479VeAr1DQZ9
         rr3TiqL2M7m5A==
Date:   Wed, 17 Mar 2021 14:29:39 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 05/10] KVM: arm64: Rework SVE host-save/guest-restore
Message-ID: <20210317142938.GA5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-6-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:07AM +0000, Marc Zyngier wrote:
> In order to keep the code readable, move the host-save/guest-restore
> sequences in their own functions, with the following changes:
> - the hypervisor ZCR is now set from C code
> - ZCR_EL2 is always used as the EL2 accessor
> 
> This results in some minor assembler macro rework.
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h   |  8 +++--
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/fpsimd.S             |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 41 +++++++++++++++----------
>  4 files changed, 33 insertions(+), 20 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index fb68271c1a0f..d34dc220a1ce 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -196,6 +196,25 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
> +{
> +	struct thread_struct *thread;
> +
> +	thread = container_of(vcpu->arch.host_fpsimd_state, struct thread_struct,
> +			      uw.fpsimd_state);
> +
> +	__sve_save_state(sve_pffr(thread), &vcpu->arch.host_fpsimd_state->fpsr);
> +}
> +
> +static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
> +{
> +	if (read_sysreg_s(SYS_ZCR_EL2) != (vcpu_sve_vq(vcpu) - 1))

Strictly speaking, we should probably be extracting the LEN field from
ZCR_EL2, otherwise this has the potential to go horribly wrong if any of
the RES0 bits are allocated in future.

Other than that:

Acked-by: Will Deacon <will@kernel.org>

Will
