Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182863EA292
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhHLJ6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhHLJ6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED9960F57;
        Thu, 12 Aug 2021 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628762269;
        bh=HxmpIxZ8vP71X/haLXmLN6MBqTPWJ4X2U98Wz3faOco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qi3GtSC95NtI+T6MxxcNybLmWFslRHvRU4ZDmPgyAoXbqx4EgyXqEnLVndjdRYaUe
         /Wgt8tZ9n4FTy+sfler2nLtrTLmuML0Uoj/RttYKi+nE9x8SQJepidfJYmEemGOfgP
         UGRkBZqW/HX9AsEjDgBGf7hq1/A7IJsqTRL03YUn/hMtiY7hwctM+HqysiEQXlfqBJ
         ZHCWU+Qo1HSJE/NFdGC1ZsUTImBJZp7yHuEziSB43FNJN0XHeBIigL2okY/EjPR9ok
         sL1F0NCCNRHHUEcQ7PQ4eXre5RZGobzyfcWG5dsVno/9VK3AMkNHeTLHg4PxMHD8l1
         izwVzHr89iTrg==
Date:   Thu, 12 Aug 2021 10:57:44 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
Message-ID: <20210812095743.GL5912@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-15-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-15-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:45PM +0100, Fuad Tabba wrote:
> Protected KVM does not support protected AArch32 guests. However,
> it is possible for the guest to force run AArch32, potentially
> causing problems. Add an extra check so that if the hypervisor
> catches the guest doing that, it can prevent the guest from
> running again by resetting vcpu->arch.target and returning
> ARM_EXCEPTION_IL.
> 
> Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> AArch32 systems")
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8431f1514280..f09343e15a80 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -23,6 +23,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_fixed_config.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
>  	}
>  
> +	/*
> +	 * Protected VMs might not be allowed to run in AArch32. The check below
> +	 * is based on the one in kvm_arch_vcpu_ioctl_run().
> +	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> +	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
> +	 * CPU. If the hypervisor spots a guest in such a state ensure it is
> +	 * handled, and don't trust the host to spot or fix it.
> +	 */
> +	if (unlikely(is_nvhe_hyp_code() &&
> +		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> +		     FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> +			       PVM_ID_AA64PFR0_ALLOW) <
> +			     ID_AA64PFR0_ELx_32BIT_64BIT &&
> +		     vcpu_mode_is_32bit(vcpu))) {
> +		/*
> +		 * As we have caught the guest red-handed, decide that it isn't
> +		 * fit for purpose anymore by making the vcpu invalid.
> +		 */
> +		vcpu->arch.target = -1;
> +		*exit_code = ARM_EXCEPTION_IL;
> +		goto exit;
> +	}

Would this be better off inside the nvhe-specific run loop? Seems like we
could elide fixup_guest_exit() altogether if we've detect that we're in
AArch32 state when we shouldn't be and it would keep the code off the shared
path.

Will
