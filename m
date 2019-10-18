Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC23DCC4D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634431AbfJRRJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 13:09:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:64001 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393426AbfJRRJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 13:09:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 10:09:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="348140716"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 18 Oct 2019 10:09:05 -0700
Date:   Fri, 18 Oct 2019 10:09:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: VMX: Rename {vmx,nested_vmx}_vcpu_setup()
 and minor cleanup
Message-ID: <20191018170905.GE26319@linux.intel.com>
References: <20191018093723.102471-1-xiaoyao.li@intel.com>
 <20191018093723.102471-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018093723.102471-3-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 18, 2019 at 05:37:22PM +0800, Xiaoyao Li wrote:
> Rename {vmx,nested_vmx}_vcpu_setup() to {vmx,nested_vmx}_vmcs_setup,
> to match what they really do.
> 
> Aslo remove the vmcs unrelated codes to vmx_vcpu_create().

Do this in a separate patch, just in case there is a dependencies we're
missing.

> The initialization of vmx->hv_deadline_tsc can be removed here, because
> it will be called in vmx_vcpu_reset() as the flow:
> 
> kvm_arch_vcpu_setup()
>   -> kvm_vcpu_reset()
>        -> vmx_vcpu_reset()

Definitely needs to be in a separate patch.

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v2:
>   - move out the vmcs unrelated codes
> ---
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  arch/x86/kvm/vmx/vmx.c    | 45 +++++++++++++++++----------------------
>  3 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5e231da00310..7935422d311f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5768,7 +5768,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> -void nested_vmx_vcpu_setup(void)
> +void nested_vmx_vmcs_setup(void)

"vmcs_setup" sounds like we're allocating and loading a VMCS.  Maybe
{nested_,}vmx_set_initial_vmcs_state() a la vmx_set_constant_host_state()?

>  {
>  	if (enable_shadow_vmcs) {
>  		vmcs_write64(VMREAD_BITMAP, __pa(vmx_vmread_bitmap));
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 187d39bf0bf1..2be1ba7482c9 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -11,7 +11,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
>  				bool apicv);
>  void nested_vmx_hardware_unsetup(void);
>  __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
> -void nested_vmx_vcpu_setup(void);
> +void nested_vmx_vmcs_setup(void);
>  void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
>  int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
>  bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ef567df344bf..b083316a598d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4161,15 +4161,10 @@ static void ept_set_mmio_spte_mask(void)
>  
>  #define VMX_XSS_EXIT_BITMAP 0
>  
> -/*
> - * Sets up the vmcs for emulated real mode.
> - */
> -static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
> +static void vmx_vmcs_setup(struct vcpu_vmx *vmx)
>  {
> -	int i;
> -
>  	if (nested)
> -		nested_vmx_vcpu_setup();
> +		nested_vmx_vmcs_setup();
>  
>  	if (cpu_has_vmx_msr_bitmap())
>  		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
> @@ -4178,7 +4173,6 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  
>  	/* Control */
>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
> -	vmx->hv_deadline_tsc = -1;
>  
>  	exec_controls_set(vmx, vmx_exec_control(vmx));
>  
> @@ -4227,21 +4221,6 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
>  		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
>  
> -	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
> -		u32 index = vmx_msr_index[i];
> -		u32 data_low, data_high;
> -		int j = vmx->nmsrs;
> -
> -		if (rdmsr_safe(index, &data_low, &data_high) < 0)
> -			continue;
> -		if (wrmsr_safe(index, data_low, data_high) < 0)
> -			continue;
> -		vmx->guest_msrs[j].index = i;
> -		vmx->guest_msrs[j].data = 0;
> -		vmx->guest_msrs[j].mask = -1ull;
> -		++vmx->nmsrs;
> -	}
> -
>  	vm_exit_controls_set(vmx, vmx_vmexit_ctrl());
>  
>  	/* 22.2.1, 20.8.1 */
> @@ -6710,7 +6689,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  	int err;
>  	struct vcpu_vmx *vmx;
>  	unsigned long *msr_bitmap;
> -	int cpu;
> +	int i, cpu;
>  
>  	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
>  		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
> @@ -6786,9 +6765,25 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  	cpu = get_cpu();
>  	vmx_vcpu_load(&vmx->vcpu, cpu);
>  	vmx->vcpu.cpu = cpu;
> -	vmx_vcpu_setup(vmx);
> +	vmx_vmcs_setup(vmx);
>  	vmx_vcpu_put(&vmx->vcpu);
>  	put_cpu();
> +
> +	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
> +		u32 index = vmx_msr_index[i];
> +		u32 data_low, data_high;
> +		int j = vmx->nmsrs;
> +
> +		if (rdmsr_safe(index, &data_low, &data_high) < 0)
> +			continue;
> +		if (wrmsr_safe(index, data_low, data_high) < 0)
> +			continue;
> +		vmx->guest_msrs[j].index = i;
> +		vmx->guest_msrs[j].data = 0;
> +		vmx->guest_msrs[j].mask = -1ull;
> +		++vmx->nmsrs;
> +	}

I'd put this immediately after guest_msrs is allocated.  Yeah, we'll waste
a few cycles if allocating vmcs01 fails, but that should be a very rare
event.

> +
>  	if (cpu_need_virtualize_apic_accesses(&vmx->vcpu)) {
>  		err = alloc_apic_access_page(kvm);
>  		if (err)
> -- 
> 2.19.1
> 
