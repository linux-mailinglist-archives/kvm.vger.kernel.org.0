Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B280E2A2C8B
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 15:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgKBOSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 09:18:24 -0500
Received: from foss.arm.com ([217.140.110.172]:60070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgKBOSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 09:18:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA62630E;
        Mon,  2 Nov 2020 06:18:20 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F065E3F66E;
        Mon,  2 Nov 2020 06:18:19 -0800 (PST)
Subject: Re: [PATCH 5/8] KVM: arm64: Turn host HVC handling into a dispatch
 table
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-6-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d7b32bda-1d2d-2f63-3cf1-81baa336efa5@arm.com>
Date:   Mon, 2 Nov 2020 14:19:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026095116.72051-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/26/20 9:51 AM, Marc Zyngier wrote:
> Now that we can use function pointer, use a dispatch table to call
> the individual HVC handlers, leading to more maintainable code.
>
> Further improvements include helpers to declare the mapping of
> local variables to values passed in the host context.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/image-vars.h     |   1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 227 +++++++++++++++++------------
>  2 files changed, 134 insertions(+), 94 deletions(-)
>
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 61684a500914..b5b0fdd1043c 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -64,6 +64,7 @@ __efistub__ctype		= _ctype;
>  /* Alternative callbacks for init-time patching of nVHE hyp code. */
>  KVM_NVHE_ALIAS(kvm_patch_vector_branch);
>  KVM_NVHE_ALIAS(kvm_update_va_mask);
> +KVM_NVHE_ALIAS(kvm_update_kimg_phys_offset);
>  
>  /* Global kernel state accessed by nVHE hyp code. */
>  KVM_NVHE_ALIAS(kvm_vgic_global_state);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e2eafe2c93af..2af8a5e902af 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -12,106 +12,145 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> -#include <kvm/arm_hypercalls.h>
> -
> -static void handle_host_hcall(unsigned long func_id,
> -			      struct kvm_cpu_context *host_ctxt)
> -{
> -	unsigned long ret = 0;
> -
> -	switch (func_id) {
> -	case KVM_HOST_SMCCC_FUNC(__kvm_vcpu_run): {
> -		unsigned long r1 = host_ctxt->regs.regs[1];
> -		struct kvm_vcpu *vcpu = (struct kvm_vcpu *)r1;
> -
> -		ret = __kvm_vcpu_run(kern_hyp_va(vcpu));
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__kvm_flush_vm_context):
> -		__kvm_flush_vm_context();
> -		break;
> -	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid_ipa): {
> -		unsigned long r1 = host_ctxt->regs.regs[1];
> -		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
> -		phys_addr_t ipa = host_ctxt->regs.regs[2];
> -		int level = host_ctxt->regs.regs[3];
> -
> -		__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
> -		unsigned long r1 = host_ctxt->regs.regs[1];
> -		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
> -
> -		__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
> -		unsigned long r1 = host_ctxt->regs.regs[1];
> -		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
> -
> -		__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
> -		u64 cntvoff = host_ctxt->regs.regs[1];
> -
> -		__kvm_timer_set_cntvoff(cntvoff);
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__kvm_enable_ssbs):
> -		__kvm_enable_ssbs();
> -		break;
> -	case KVM_HOST_SMCCC_FUNC(__vgic_v3_get_ich_vtr_el2):
> -		ret = __vgic_v3_get_ich_vtr_el2();
> -		break;
> -	case KVM_HOST_SMCCC_FUNC(__vgic_v3_read_vmcr):
> -		ret = __vgic_v3_read_vmcr();
> -		break;
> -	case KVM_HOST_SMCCC_FUNC(__vgic_v3_write_vmcr): {
> -		u32 vmcr = host_ctxt->regs.regs[1];
> -
> -		__vgic_v3_write_vmcr(vmcr);
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__vgic_v3_init_lrs):
> -		__vgic_v3_init_lrs();
> -		break;
> -	case KVM_HOST_SMCCC_FUNC(__kvm_get_mdcr_el2):
> -		ret = __kvm_get_mdcr_el2();
> -		break;
> -	case KVM_HOST_SMCCC_FUNC(__vgic_v3_save_aprs): {
> -		unsigned long r1 = host_ctxt->regs.regs[1];
> -		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
> -
> -		__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> -		break;
> -	}
> -	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
> -		unsigned long r1 = host_ctxt->regs.regs[1];
> -		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
> -
> -		__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
> -		break;
> -	}
> -	default:
> -		/* Invalid host HVC. */
> -		host_ctxt->regs.regs[0] = SMCCC_RET_NOT_SUPPORTED;
> -		return;
> -	}
> -
> -	host_ctxt->regs.regs[0] = SMCCC_RET_SUCCESS;
> -	host_ctxt->regs.regs[1] = ret;
> +#define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
> +#define DECLARE_REG(type, name, ctxt, reg)	\
> +				type name = (type)cpu_reg(ctxt, (reg))
> +
> +static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> +
> +	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
> +}
> +
> +static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
> +{
> +	__kvm_flush_vm_context();
> +}
> +
> +static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
> +	DECLARE_REG(int, level, host_ctxt, 3);
> +
> +	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
> +}
> +
> +static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +
> +	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
> +}
> +
> +static void handle___kvm_tlb_flush_local_vmid(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +
> +	__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
> +}
> +
> +static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
> +{
> +	__kvm_timer_set_cntvoff(cpu_reg(host_ctxt, 1));
> +}
> +
> +static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
> +{
> +	__kvm_enable_ssbs();
> +}
> +
> +static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
> +{
> +	cpu_reg(host_ctxt, 1) = __vgic_v3_get_ich_vtr_el2();
> +}
> +
> +static void handle___vgic_v3_read_vmcr(struct kvm_cpu_context *host_ctxt)
> +{
> +	cpu_reg(host_ctxt, 1) = __vgic_v3_read_vmcr();
> +}
> +
> +static void handle___vgic_v3_write_vmcr(struct kvm_cpu_context *host_ctxt)
> +{
> +	__vgic_v3_write_vmcr(cpu_reg(host_ctxt, 1));
> +}
> +
> +static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
> +{
> +	__vgic_v3_init_lrs();
> +}
> +
> +static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
> +{
> +	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
> +}
> +
> +static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> +
> +	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> +}
> +
> +static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> +
> +	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
> +}
> +
> +#define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = handle_##x
> +
> +typedef void (*hcall_t)(struct kvm_cpu_context *);
> +
> +static const hcall_t host_hcall[] = {
> +	HANDLE_FUNC(__kvm_vcpu_run),
> +	HANDLE_FUNC(__kvm_flush_vm_context),
> +	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> +	HANDLE_FUNC(__kvm_tlb_flush_vmid),
> +	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
> +	HANDLE_FUNC(__kvm_timer_set_cntvoff),
> +	HANDLE_FUNC(__kvm_enable_ssbs),
> +	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
> +	HANDLE_FUNC(__vgic_v3_read_vmcr),
> +	HANDLE_FUNC(__vgic_v3_write_vmcr),
> +	HANDLE_FUNC(__vgic_v3_init_lrs),
> +	HANDLE_FUNC(__kvm_get_mdcr_el2),
> +	HANDLE_FUNC(__vgic_v3_save_aprs),
> +	HANDLE_FUNC(__vgic_v3_restore_aprs),
> +};
> +
> +static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(unsigned long, id, host_ctxt, 0);
> +	unsigned long ret = SMCCC_RET_NOT_SUPPORTED;
> +	hcall_t hcall;
> +
> +	id -= KVM_HOST_SMCCC_ID(0);
> +
> +	if (unlikely(id >= ARRAY_SIZE(host_hcall)))
> +		goto inval;
> +
> +	hcall = host_hcall[id];
> +	if (unlikely(!hcall))
> +		goto inval;
> +
> +	hcall = kimg_hyp_va(hcall);
> +
> +	hcall(host_ctxt);
> +	ret = SMCCC_RET_SUCCESS;
> +
> +inval:
> +	cpu_reg(host_ctxt, 0) = ret;
>  }
>  
>  void handle_trap(struct kvm_cpu_context *host_ctxt)
>  {
>  	u64 esr = read_sysreg_el2(SYS_ESR);
> -	unsigned long func_id;
>  
> -	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
> +	if (unlikely(ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64))
>  		hyp_panic();
>  
> -	func_id = host_ctxt->regs.regs[0];
> -	handle_host_hcall(func_id, host_ctxt);
> +	handle_host_hcall(host_ctxt);
>  }

I checked that the function handlers are the same as the cases in the switch
statements. In kvm_asm.h there is no restriction regarding function ids not being
consecutive numbers, but handle_host_hcall() checks that hcall is not NULL, so
we're safe against that, or function ids disappearing in the future.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

