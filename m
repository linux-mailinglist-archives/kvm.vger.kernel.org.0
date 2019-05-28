Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6328D2C107
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 10:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfE1IS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 04:18:26 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51710 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfE1IS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 04:18:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA68C341;
        Tue, 28 May 2019 01:18:25 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 149EB3F59C;
        Tue, 28 May 2019 01:18:22 -0700 (PDT)
Subject: Re: [PATCH v2 07/15] arm64: KVM: split debug save restore across
 vm/traps activation
To:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-8-sudeep.holla@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <84eba64a-899f-e231-0873-c3ccfeb2201d@arm.com>
Date:   Tue, 28 May 2019 09:18:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190523103502.25925-8-sudeep.holla@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sudeep,

On 23/05/2019 11:34, Sudeep Holla wrote:
> If we enable profiling buffer controls at EL1 generate a trap exception
> to EL2, it also changes profiling buffer to use EL1&0 stage 1 translation
> regime in case of VHE. To support SPE both in the guest and host, we
> need to first stop profiling and flush the profiling buffers before
> we activate/switch vm or enable/disable the traps.
> 
> In prepartion to do that, lets split the debug save restore functionality
> into 4 steps:
> 1. debug_save_host_context - saves the host context
> 2. debug_restore_guest_context - restore the guest context
> 3. debug_save_guest_context - saves the guest context
> 4. debug_restore_host_context - restores the host context
> 
> Lets rename existing __debug_switch_to_{host,guest} to make sure it's
> aligned to the above and just add the place holders for new ones getting
> added here as we need them to support SPE in guests.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  6 ++++--
>  arch/arm64/kvm/hyp/debug-sr.c    | 25 ++++++++++++++++---------
>  arch/arm64/kvm/hyp/switch.c      | 12 ++++++++----
>  3 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 782955db61dd..1c5ed80fcbda 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -164,8 +164,10 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
>  void __sysreg32_save_state(struct kvm_vcpu *vcpu);
>  void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
>  
> -void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
> -void __debug_switch_to_host(struct kvm_vcpu *vcpu);
> +void __debug_save_host_context(struct kvm_vcpu *vcpu);
> +void __debug_restore_guest_context(struct kvm_vcpu *vcpu);
> +void __debug_save_guest_context(struct kvm_vcpu *vcpu);
> +void __debug_restore_host_context(struct kvm_vcpu *vcpu);
>  
>  void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index fa51236ebcb3..618884df1dc4 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -149,20 +149,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
>  	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
>  }
>  
> -void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
> +void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
>  	struct kvm_guest_debug_arch *host_dbg;
>  	struct kvm_guest_debug_arch *guest_dbg;
>  
> -	/*
> -	 * Non-VHE: Disable and flush SPE data generation
> -	 * VHE: The vcpu can run, but it can't hide.
> -	 */
> -	if (!has_vhe())
> -		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
> -
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
>  
> @@ -175,7 +168,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>  	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
>  }
>  
> -void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
> +void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)

In the current state of the sources, __debug_switch_to_host() seems to
save the guest debug state before restoring the host's:

	__debug_save_state(vcpu, guest_dbg, guest_ctxt);

Since you're splitting the switch_to into save/restore operations, it
feels like this would fit better __debug_save_guest_context() (currently
empty) rather than __debug_restore_host_context().

Cheers,

-- 
Julien Thierry
