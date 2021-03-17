Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CA333F2A8
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhCQObf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhCQObH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D7564F67;
        Wed, 17 Mar 2021 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615991467;
        bh=S3JhTXMjWji0Vcn4IbAXOL+PlkhYOkccvDgq5tIxZqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gd5K9dwWeW2twuwVtOVTybSn0Rqnktu+3VRkcDDcJgl6cF2ca31aWt3NmbaIX1Xbu
         ilH4P4RBMyK1XbcM5G8Dpb24Pl3hNhzT5NTjwWj7SxawhsmPo3ypEcANPLluaSxdI3
         ei7+x9WhQ1cEPUOAFGiehQyU7PYF3tigFiqPPrRgPPflrbED96mHMdDQm7UIS+kQzO
         l1+BtZcDiLs3y3yBuMgZVfzxrAyzeg3EXFgNsOTkEeKTEvnCtuw57XwNK7YstnV7Kb
         3YCo+8iFAP+9mouFphJjh/NtqgxM7QlAxvFU6QR0BvnPmqzqku1+Xcd48EUiL+6B7U
         CVdBJnBOeOnJA==
Date:   Wed, 17 Mar 2021 14:31:01 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 02/10] KVM: arm64: Use {read,write}_sysreg_el1 to access
 ZCR_EL1
Message-ID: <20210317143101.GC5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:04AM +0000, Marc Zyngier wrote:
> Switch to the unified EL1 accessors for ZCR_EL1, which will make
> things easier for nVHE support.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c                 | 3 ++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 3e081d556e81..b7e36a506d3d 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -11,6 +11,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/fpsimd.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>  
> @@ -112,7 +113,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  		fpsimd_save_and_flush_cpu_state();
>  
>  		if (guest_has_sve)
> -			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
> +			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
>  	} else if (host_has_sve) {
>  		/*
>  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 807bc4734828..d762d5bdc2d5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -269,7 +269,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  		__sve_restore_state(vcpu_sve_pffr(vcpu),
>  				    &vcpu->arch.ctxt.fp_regs.fpsr,
>  				    sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
> -		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
> +		write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
>  	} else {
>  		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);

Looks straightforward enough:

Acked-by: Will Deacon <will@kernel.org>

Will
