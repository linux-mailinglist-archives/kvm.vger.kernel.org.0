Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D07128960
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 15:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfLUONb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 09:13:31 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:39526 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbfLUONb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 09:13:31 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iifVX-0004U0-4h; Sat, 21 Dec 2019 15:13:27 +0100
Date:   Sat, 21 Dec 2019 14:13:25 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>, <kvm@vger.kernel.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/18] arm64: KVM: enable conditional save/restore
 full SPE profiling buffer controls
Message-ID: <20191221141325.5a177343@why>
In-Reply-To: <20191220143025.33853-10-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-10-andrew.murray@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, Catalin.Marinas@arm.com, Mark.Rutland@arm.com, will@kernel.org, Sudeep.Holla@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 14:30:16 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

[somehow managed not to do a reply all, re-sending]

> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> Now that we can save/restore the full SPE controls, we can enable it
> if SPE is setup and ready to use in KVM. It's supported in KVM only if
> all the CPUs in the system supports SPE.
> 
> However to support heterogenous systems, we need to move the check if
> host supports SPE and do a partial save/restore.

No. Let's just not go down that path. For now, KVM on heterogeneous
systems do not get SPE. If SPE has been enabled on a guest and a CPU
comes up without SPE, this CPU should fail to boot (same as exposing a
feature to userspace).

> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 33 ++++++++++++++++-----------------
>  include/kvm/arm_spe.h         |  6 ++++++
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 12429b212a3a..d8d857067e6d 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -86,18 +86,13 @@
>  	}
>  
>  static void __hyp_text
> -__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> +__debug_save_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  {
>  	u64 reg;
>  
>  	/* Clear pmscr in case of early return */
>  	ctxt->sys_regs[PMSCR_EL1] = 0;
>  
> -	/* SPE present on this CPU? */
> -	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> -						  ID_AA64DFR0_PMSVER_SHIFT))
> -		return;
> -
>  	/* Yes; is it owned by higher EL? */
>  	reg = read_sysreg_s(SYS_PMBIDR_EL1);
>  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
> @@ -142,7 +137,7 @@ __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  }
>  
>  static void __hyp_text
> -__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> +__debug_restore_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
>  {
>  	if (!ctxt->sys_regs[PMSCR_EL1])
>  		return;
> @@ -210,11 +205,14 @@ void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
>  	struct kvm_guest_debug_arch *host_dbg;
>  	struct kvm_guest_debug_arch *guest_dbg;
>  
> +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	guest_ctxt = &vcpu->arch.ctxt;
> +
> +	__debug_restore_spe_context(guest_ctxt, kvm_arm_spe_v1_ready(vcpu));
> +
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
>  
> -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -	guest_ctxt = &vcpu->arch.ctxt;
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
>  
> @@ -232,8 +230,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
>  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> -	if (!has_vhe())
> -		__debug_restore_spe_nvhe(host_ctxt, false);
> +	__debug_restore_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));

So you now do an unconditional save/restore on the exit path for VHE as
well? Even if the host isn't using the SPE HW? That's not acceptable
as, in most cases, only the host /or/ the guest will use SPE. Here, you
put a measurable overhead on each exit.

If the host is not using SPE, then the restore/save should happen in
vcpu_load/vcpu_put. Only if the host is using SPE should you do
something in the run loop. Of course, this only applies to VHE and
non-VHE must switch eagerly.

>  
>  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
>  		return;
> @@ -249,19 +246,21 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
>  
>  void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
>  {
> -	/*
> -	 * Non-VHE: Disable and flush SPE data generation
> -	 * VHE: The vcpu can run, but it can't hide.
> -	 */
>  	struct kvm_cpu_context *host_ctxt;
>  
>  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -	if (!has_vhe())
> -		__debug_save_spe_nvhe(host_ctxt, false);
> +	if (cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> +						 ID_AA64DFR0_PMSVER_SHIFT))
> +		__debug_save_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
>  }
>  
>  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
>  {
> +	bool kvm_spe_ready = kvm_arm_spe_v1_ready(vcpu);
> +
> +	/* SPE present on this vCPU? */
> +	if (kvm_spe_ready)
> +		__debug_save_spe_context(&vcpu->arch.ctxt, kvm_spe_ready);
>  }
>  
>  u32 __hyp_text __kvm_get_mdcr_el2(void)
> diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> index 48d118fdb174..30c40b1bc385 100644
> --- a/include/kvm/arm_spe.h
> +++ b/include/kvm/arm_spe.h
> @@ -16,4 +16,10 @@ struct kvm_spe {
>  	bool irq_level;
>  };
>  
> +#ifdef CONFIG_KVM_ARM_SPE
> +#define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
> +#else
> +#define kvm_arm_spe_v1_ready(v)		(false)
> +#endif /* CONFIG_KVM_ARM_SPE */
> +
>  #endif /* __ASM_ARM_KVM_SPE_H */

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
