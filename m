Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC3DDCC0C
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409377AbfJRQ5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 12:57:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:42333 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405642AbfJRQ5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 12:57:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 09:57:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="221800591"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2019 09:57:11 -0700
Date:   Fri, 18 Oct 2019 09:57:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: VMX: Move vmcs related resetting out of
 vmx_vcpu_reset()
Message-ID: <20191018165711.GD26319@linux.intel.com>
References: <20191018093723.102471-1-xiaoyao.li@intel.com>
 <20191018093723.102471-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018093723.102471-2-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 18, 2019 at 05:37:21PM +0800, Xiaoyao Li wrote:
> Move vmcs related codes into a new function vmx_vmcs_reset() from
> vmx_vcpu_reset(). So that it's more clearer which data is related with
> vmcs and can be held in vmcs.
> 
> Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 65 ++++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e660e28e9ae0..ef567df344bf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4271,33 +4271,11 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  	}
>  }
>  
> -static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +static void vmx_vmcs_reset(struct kvm_vcpu *vcpu, bool init_event)

I'd strongly prefer to keep the existing code.  For me, "vmcs_reset" means
zeroing out the VMCS, i.e. reset the VMCS to a virgin state.  "vcpu_reset"
means exactly that, stuff vCPU state to emulate RESET/INIT.

And the split is arbitrary and funky, e.g. EFER is integrated into the
VMCS on all recent CPUs, but here it's handled in vcpu_reset.  

>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	struct msr_data apic_base_msr;
>  	u64 cr0;
>  
> -	vmx->rmode.vm86_active = 0;
> -	vmx->spec_ctrl = 0;
> -
> -	vmx->msr_ia32_umwait_control = 0;
> -
> -	vcpu->arch.microcode_version = 0x100000000ULL;
> -	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> -	vmx->hv_deadline_tsc = -1;
> -	kvm_set_cr8(vcpu, 0);
> -
> -	if (!init_event) {
> -		apic_base_msr.data = APIC_DEFAULT_PHYS_BASE |
> -				     MSR_IA32_APICBASE_ENABLE;
> -		if (kvm_vcpu_is_reset_bsp(vcpu))
> -			apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> -		apic_base_msr.host_initiated = true;
> -		kvm_set_apic_base(vcpu, &apic_base_msr);
> -	}
> -
> -	vmx_segment_cache_clear(vmx);
> -
>  	seg_setup(VCPU_SREG_CS);
>  	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
>  	vmcs_writel(GUEST_CS_BASE, 0xffff0000ul);
> @@ -4340,8 +4318,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	if (kvm_mpx_supported())
>  		vmcs_write64(GUEST_BNDCFGS, 0);
>  
> -	setup_msrs(vmx);
> -
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>  
>  	if (cpu_has_vmx_tpr_shadow() && !init_event) {
> @@ -4357,19 +4333,52 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	if (vmx->vpid != 0)
>  		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
>  
> +	vpid_sync_context(vmx->vpid);
> +
>  	cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
> -	vmx->vcpu.arch.cr0 = cr0;
> +	vcpu->arch.cr0 = cr0;
>  	vmx_set_cr0(vcpu, cr0); /* enter rmode */
>  	vmx_set_cr4(vcpu, 0);
> -	vmx_set_efer(vcpu, 0);
>  
>  	update_exception_bitmap(vcpu);
>  
> -	vpid_sync_context(vmx->vpid);
>  	if (init_event)
>  		vmx_clear_hlt(vcpu);
>  }
>  
> +static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct msr_data apic_base_msr;
> +
> +	vmx->rmode.vm86_active = 0;
> +	vmx->spec_ctrl = 0;
> +
> +	vmx->msr_ia32_umwait_control = 0;
> +
> +	vcpu->arch.microcode_version = 0x100000000ULL;
> +	kvm_rdx_write(vcpu, get_rdx_init_val());
> +	vmx->hv_deadline_tsc = -1;
> +	kvm_set_cr8(vcpu, 0);
> +
> +	if (!init_event) {
> +		apic_base_msr.data = APIC_DEFAULT_PHYS_BASE |
> +				     MSR_IA32_APICBASE_ENABLE;
> +		if (kvm_vcpu_is_reset_bsp(vcpu))
> +			apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> +		apic_base_msr.host_initiated = true;
> +		kvm_set_apic_base(vcpu, &apic_base_msr);
> +	}
> +
> +	vmx_segment_cache_clear(vmx);
> +
> +	setup_msrs(vmx);
> +
> +	vmx_set_efer(vcpu, 0);

Setting EFER before CR0/CR4 is a functional change, and likely wrong, e.g.
vmx_set_cr0() queries EFER_LME to trigger exit_lmode() if INIT/RESET is
received while the vCPU is in long mode.

> +	vmx_vmcs_reset(vcpu, init_event);
> +}
> +
>  static void enable_irq_window(struct kvm_vcpu *vcpu)
>  {
>  	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_VIRTUAL_INTR_PENDING);
> -- 
> 2.19.1
> 
