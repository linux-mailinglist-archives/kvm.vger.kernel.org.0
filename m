Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D2A41DB35
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350977AbhI3Nhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350801AbhI3Nhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 09:37:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23E6961440;
        Thu, 30 Sep 2021 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633008963;
        bh=pjrc9VhsJkOrDhWGJxTk9nMm3AOBxD3Ofrhgi6/53qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HA4bAYfs8MfLop6TpMlT4qc+pOilOHs6jcLMT7k0cyfHNYYd44L34nO3w1h1vTcQC
         UckW2CTk+YbCisOCwe8zzh/1SPZXVogipmoR7Dso3w1JtUsMunW3l4tVkCAsAPOx8o
         NGVwKd8UDCEkIqrvwGppgoyKKOxl9Pvkct1D+COc7dgB+LLVTMOV46kFrE4EDz8IFp
         OjkXLiCjJPj668vQQ0m+CVGWStdfzXc5iMQ5RwIRSoLidMfteDfg4XWFZdkQMG5J/+
         GljbocoGzdOo2PrtdgjkWnA1n/LhZYkB91eyHJhiJ4RQFdvN9u8upZbljsvHr2oAcj
         0J4Qk3xMiX04A==
Date:   Thu, 30 Sep 2021 14:35:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v6 03/12] KVM: arm64: Move early handlers to per-EC
 handlers
Message-ID: <20210930133444.GC23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-4-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922124704.600087-4-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:46:55PM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Simplify the early exception handling by slicing the gigantic decoding
> tree into a more manageable set of functions, similar to what we have
> in handle_exit.c.
> 
> This will also make the structure reusable for pKVM's own early exit
> handling.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 160 ++++++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  17 +++
>  arch/arm64/kvm/hyp/vhe/switch.c         |  17 +++
>  3 files changed, 126 insertions(+), 68 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 54abc8298ec3..0397606c0951 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -136,16 +136,7 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
>  
>  static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  {
> -	u8 ec;
> -	u64 esr;
> -
> -	esr = vcpu->arch.fault.esr_el2;
> -	ec = ESR_ELx_EC(esr);
> -
> -	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
> -		return true;
> -
> -	return __get_fault_info(esr, &vcpu->arch.fault);
> +	return __get_fault_info(vcpu->arch.fault.esr_el2, &vcpu->arch.fault);
>  }
>  
>  static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
> @@ -166,8 +157,13 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
>  	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
>  }
>  
> -/* Check for an FPSIMD/SVE trap and handle as appropriate */
> -static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
> +/*
> + * We trap the first access to the FP/SIMD to save the host context and
> + * restore the guest context lazily.
> + * If FP/SIMD is not implemented, handle the trap and inject an undefined
> + * instruction exception to the guest. Similarly for trapped SVE accesses.
> + */
> +static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	bool sve_guest, sve_host;
>  	u8 esr_ec;
> @@ -185,9 +181,6 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>  	}
>  
>  	esr_ec = kvm_vcpu_trap_get_class(vcpu);
> -	if (esr_ec != ESR_ELx_EC_FP_ASIMD &&
> -	    esr_ec != ESR_ELx_EC_SVE)
> -		return false;
>  
>  	/* Don't handle SVE traps for non-SVE vcpus here: */
>  	if (!sve_guest && esr_ec != ESR_ELx_EC_FP_ASIMD)
> @@ -325,7 +318,7 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
>  
>  DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  
> -static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> +static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	struct kvm_cpu_context *ctxt;
>  	u64 val;
> @@ -350,6 +343,87 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
> +	    handle_tx2_tvm(vcpu))
> +		return true;
> +
> +	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
> +	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
> +		return true;
> +
> +	return false;
> +}
> +
> +static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
> +	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
> +		return true;

I think you're now calling this for the 64-bit CP15 access path, which I
don't think is correct. Maybe have separate handlers for 32-bit v4 64-bit
accesses?

Will
