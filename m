Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46239367
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbfFGRhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:37:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:61857 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbfFGRhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:37:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 10:37:11 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 Jun 2019 10:37:11 -0700
Date:   Fri, 7 Jun 2019 10:37:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: simplify vmx_prepare_switch_to_{guest,host}
Message-ID: <20190607173710.GG9083@linux.intel.com>
References: <1559927301-8124-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559927301-8124-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 07:08:21PM +0200, Paolo Bonzini wrote:
> vmx->loaded_cpu_state can only be NULL or equal to vmx->loaded_vmcs,
> so change it to a bool.  Because the direction of the bool is
> now the opposite of vmx->guest_msrs_dirty, change the direction of
> vmx->guest_msrs_dirty so that they match.
> 
> Finally, do not imply that MSRs have to be reloaded when
> vmx->guest_sregs_loaded is false; instead, set vmx->guest_msrs_loaded
> to false explicitly in vmx_prepare_switch_to_host.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

...

> @@ -1165,13 +1163,15 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>  	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
>  #endif
>  	load_fixmap_gdt(raw_smp_processor_id());
> +	vmx->guest_sregs_loaded = false;
> +	vmx->guest_msrs_loaded = false;
>  }
>  
>  #ifdef CONFIG_X86_64
>  static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
>  {
>  	preempt_disable();
> -	if (vmx->loaded_cpu_state)
> +	if (vmx->guest_sregs_loaded)
>  		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);

This is the hiccup with naming it sregs_loaded.  The split bools is also
kinda wonky since the 32->64 case is a one-off scenario.  I think a
cleaner solution would be to remove guest_msrs_dirty and refresh the MSRs
directly from setup_msrs().  Then loaded_cpu_state -> loaded_guest_state
can be a straight conversion from loaded_vmcs -> bool.  I'll send patches.

>  	preempt_enable();
>  	return vmx->msr_guest_kernel_gs_base;
> @@ -1180,7 +1180,7 @@ static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
>  static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
>  {
>  	preempt_disable();
> -	if (vmx->loaded_cpu_state)
> +	if (vmx->guest_sregs_loaded)

Same issue here, one would expect this to check guest_msrs_loaded.

>  		wrmsrl(MSR_KERNEL_GS_BASE, data);
>  	preempt_enable();
>  	vmx->msr_guest_kernel_gs_base = data;
> @@ -1583,7 +1583,7 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>  		move_msr_up(vmx, index, save_nmsrs++);
>  
>  	vmx->save_nmsrs = save_nmsrs;
> -	vmx->guest_msrs_dirty = true;
> +	vmx->guest_msrs_loaded = false;
>  
>  	if (cpu_has_vmx_msr_bitmap())
>  		vmx_update_msr_bitmap(&vmx->vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index ed65999b07a8..fc369473f9df 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -187,13 +187,23 @@ struct vcpu_vmx {
>  	struct kvm_vcpu       vcpu;
>  	u8                    fail;
>  	u8		      msr_bitmap_mode;
> +
> +	/*
> +	 * If true, host state has been stored in vmx->loaded_vmcs for
> +	 * the CPU registers that only need to be switched when transitioning
> +	 * to/from the kernel, and the registers have been loaded with guest
> +	 * values.  If false, host state is loaded in the CPU registers
> +	 * and vmx->loaded_vmcs->host_state is invalid.
> +	 */
> +	bool		      guest_sregs_loaded;
> +
>  	u32                   exit_intr_info;
>  	u32                   idt_vectoring_info;
>  	ulong                 rflags;
>  	struct shared_msr_entry *guest_msrs;
>  	int                   nmsrs;
>  	int                   save_nmsrs;
> -	bool                  guest_msrs_dirty;
> +	bool                  guest_msrs_loaded;
>  #ifdef CONFIG_X86_64
>  	u64		      msr_host_kernel_gs_base;
>  	u64		      msr_guest_kernel_gs_base;
> @@ -208,14 +218,10 @@ struct vcpu_vmx {
>  	/*
>  	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
>  	 * non-nested (L1) guest, it always points to vmcs01. For a nested
> -	 * guest (L2), it points to a different VMCS.  loaded_cpu_state points
> -	 * to the VMCS whose state is loaded into the CPU registers that only
> -	 * need to be switched when transitioning to/from the kernel; a NULL
> -	 * value indicates that host state is loaded.
> +	 * guest (L2), it points to a different VMCS.
>  	 */
>  	struct loaded_vmcs    vmcs01;
>  	struct loaded_vmcs   *loaded_vmcs;
> -	struct loaded_vmcs   *loaded_cpu_state;
>  
>  	struct msr_autoload {
>  		struct vmx_msrs guest;
> -- 
> 1.8.3.1
> 
