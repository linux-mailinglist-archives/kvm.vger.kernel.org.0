Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1927111E0F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 00:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbfLCW7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 17:59:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:2412 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbfLCW7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 17:59:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 14:59:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,275,1571727600"; 
   d="scan'208";a="412367145"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 03 Dec 2019 14:59:19 -0800
Date:   Tue, 3 Dec 2019 14:59:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: vmx: Stop wasting a page for guest_msrs
Message-ID: <20191203225918.GO19877@linux.intel.com>
References: <20191203210825.26827-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203210825.26827-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 01:08:25PM -0800, Jim Mattson wrote:
> We will never need more guest_msrs than there are indices in
> vmx_msr_index. Thus, at present, the guest_msrs array will not exceed
> 168 bytes.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 14 ++------------
>  arch/x86/kvm/vmx/vmx.h |  8 +++++++-
>  2 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1b9ab4166397d..0b3c7524456f1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -443,7 +443,7 @@ static unsigned long host_idt_base;
>   * support this emulation, IA32_STAR must always be included in
>   * vmx_msr_index[], even in i386 builds.
>   */
> -const u32 vmx_msr_index[] = {
> +const u32 vmx_msr_index[NR_GUEST_MSRS] = {

What if we keep this as is and add 

	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS);

in setup_msrs()?  That way the build will fail if someone adds an MSR but
forgets to update the #define.  With this change, gcc only spits out a
warning if the number of elements exceeds the size of the array and
presumably drops the extra elements on the floor.

>  #ifdef CONFIG_X86_64
>  	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
>  #endif
> @@ -6666,7 +6666,6 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
>  	free_vpid(vmx->vpid);
>  	nested_vmx_free_vcpu(vcpu);
>  	free_loaded_vmcs(vmx->loaded_vmcs);
> -	kfree(vmx->guest_msrs);
>  	kvm_vcpu_uninit(vcpu);
>  	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
>  	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
> @@ -6723,13 +6722,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  			goto uninit_vcpu;
>  	}
>  
> -	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> -	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
> -		     > PAGE_SIZE);
> -
> -	if (!vmx->guest_msrs)
> -		goto free_pml;
> -
>  	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
>  		u32 index = vmx_msr_index[i];
>  		u32 data_low, data_high;
> @@ -6760,7 +6752,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  
>  	err = alloc_loaded_vmcs(&vmx->vmcs01);
>  	if (err < 0)
> -		goto free_msrs;
> +		goto free_pml;
>  
>  	msr_bitmap = vmx->vmcs01.msr_bitmap;
>  	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
> @@ -6822,8 +6814,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  
>  free_vmcs:
>  	free_loaded_vmcs(vmx->loaded_vmcs);
> -free_msrs:
> -	kfree(vmx->guest_msrs);
>  free_pml:
>  	vmx_destroy_pml_buffer(vmx);
>  uninit_vcpu:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7c1b978b2df44..08bc24fa59909 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -22,6 +22,12 @@ extern u32 get_umwait_control_msr(void);
>  
>  #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
>  
> +#ifdef CONFIG_X86_64
> +#define NR_GUEST_MSRS	7
> +#else
> +#define NR_GUEST_MSRS	4
> +#endif

As much as I hate the "shared msrs" terminology, "guest msrs" is even
more confusing and misleading.  NR_SHARED_MSRS?

> +
>  #define NR_LOADSTORE_MSRS 8
>  
>  struct vmx_msrs {
> @@ -206,7 +212,7 @@ struct vcpu_vmx {
>  	u32                   idt_vectoring_info;
>  	ulong                 rflags;
>  
> -	struct shared_msr_entry *guest_msrs;
> +	struct shared_msr_entry guest_msrs[NR_GUEST_MSRS];
>  	int                   nmsrs;
>  	int                   save_nmsrs;
>  	bool                  guest_msrs_ready;
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 
