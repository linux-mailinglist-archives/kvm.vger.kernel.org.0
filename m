Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D42F377E18
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhEJI1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhEJI0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VP7OxY1nqNC6hZWU/TAr2hXHHO1myebSqQjjAkILYGY=;
        b=Xdkh5zkVPhGB9E65NW24duOCDgnXSeSrPyMFkF4+ivc0Z2cxyD7rNYOBuYqBus/aEm3thN
        ebbjAyZfoohLH8zgqhCmE9wXuwsStessBfgvpMCR3sjlvjgUpKEfffNek4Eivc8SkcbA1U
        Fprm9Yj7vBBi0CWGP48luQq9tLOgpU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-SOd-Msz5NjuRgJ4FjbR4QA-1; Mon, 10 May 2021 04:25:34 -0400
X-MC-Unique: SOd-Msz5NjuRgJ4FjbR4QA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 494991008060;
        Mon, 10 May 2021 08:25:33 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A89C60E3A;
        Mon, 10 May 2021 08:25:29 +0000 (UTC)
Message-ID: <e3ff6ef52a5022b62b98e23960b9bbe85d60182e.camel@redhat.com>
Subject: Re: [PATCH 09/15] KVM: VMX: Use flag to indicate "active" uret MSRs
 instead of sorting list
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:25:28 +0300
In-Reply-To: <20210504171734.1434054-10-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Explicitly flag a uret MSR as needing to be loaded into hardware instead of
> resorting the list of "active" MSRs and tracking how many MSRs in total
> need to be loaded.  The only benefit to sorting the list is that the loop
> to load MSRs during vmx_prepare_switch_to_guest() doesn't need to iterate
> over all supported uret MRS, only those that are active.  But that is a
> pointless optimization, as the most common case, running a 64-bit guest,
> will load the vast majority of MSRs.  Not to mention that a single WRMSR is
> far more expensive than iterating over the list.
> 
> Providing a stable list order obviates the need to track a given MSR's
> "slot" in the per-CPU list of user return MSRs; all lists simply use the
> same ordering.  Future patches will take advantage of the stable order to
> further simplify the related code.

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 80 ++++++++++++++++++++++--------------------
>  arch/x86/kvm/vmx/vmx.h |  2 +-
>  2 files changed, 42 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 68454b0de2b1..6caabcd5037e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -458,8 +458,9 @@ static unsigned long host_idt_base;
>   * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
>   * will emulate SYSCALL in legacy mode if the vendor string in guest
>   * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
> - * support this emulation, IA32_STAR must always be included in
> - * vmx_uret_msrs_list[], even in i386 builds.
> + * support this emulation, MSR_STAR is included in the list for i386,
> + * but is never loaded into hardware.  MSR_CSTAR is also never loaded
> + * into hardware and is here purely for emulation purposes.
>   */
>  static u32 vmx_uret_msrs_list[] = {
>  #ifdef CONFIG_X86_64
> @@ -702,18 +703,12 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	return r;
>  }
>  
> -static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
> +static inline int __vmx_find_uret_msr(u32 msr)
>  {
>  	int i;
>  
> -	/*
> -	 * Note, vmx->guest_uret_msrs is the same size as vmx_uret_msrs_list,
> -	 * but is ordered differently.  The MSR is matched against the list of
> -	 * supported uret MSRs using "slot", but the index that is returned is
> -	 * the index into guest_uret_msrs.
> -	 */
>  	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> -		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].slot] == msr)
> +		if (vmx_uret_msrs_list[i] == msr)
>  			return i;
>  	}
>  	return -1;
> @@ -723,7 +718,7 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
>  {
>  	int i;
>  
> -	i = __vmx_find_uret_msr(vmx, msr);
> +	i = __vmx_find_uret_msr(msr);
>  	if (i >= 0)
>  		return &vmx->guest_uret_msrs[i];
>  	return NULL;
> @@ -732,13 +727,14 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
>  static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
>  				  struct vmx_uret_msr *msr, u64 data)
>  {
> +	unsigned int slot = msr - vmx->guest_uret_msrs;
>  	int ret = 0;
>  
>  	u64 old_msr_data = msr->data;
>  	msr->data = data;
> -	if (msr - vmx->guest_uret_msrs < vmx->nr_active_uret_msrs) {
> +	if (msr->load_into_hardware) {
>  		preempt_disable();
> -		ret = kvm_set_user_return_msr(msr->slot, msr->data, msr->mask);
> +		ret = kvm_set_user_return_msr(slot, msr->data, msr->mask);
>  		preempt_enable();
>  		if (ret)
>  			msr->data = old_msr_data;
> @@ -1090,7 +1086,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
>  		return false;
>  	}
>  
> -	i = __vmx_find_uret_msr(vmx, MSR_EFER);
> +	i = __vmx_find_uret_msr(MSR_EFER);
>  	if (i < 0)
>  		return false;
>  
> @@ -1252,11 +1248,14 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	if (!vmx->guest_uret_msrs_loaded) {
>  		vmx->guest_uret_msrs_loaded = true;
> -		for (i = 0; i < vmx->nr_active_uret_msrs; ++i)
> -			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].slot,
> +		for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> +			if (!vmx->guest_uret_msrs[i].load_into_hardware)
> +				continue;
> +
> +			kvm_set_user_return_msr(i,
>  						vmx->guest_uret_msrs[i].data,
>  						vmx->guest_uret_msrs[i].mask);
> -
> +		}
>  	}
>  
>      	if (vmx->nested.need_vmcs12_to_shadow_sync)
> @@ -1763,19 +1762,16 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>  	vmx_clear_hlt(vcpu);
>  }
>  
> -static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
> +static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
> +			       bool load_into_hardware)
>  {
> -	struct vmx_uret_msr tmp;
> -	int from, to;
> +	struct vmx_uret_msr *uret_msr;
>  
> -	from = __vmx_find_uret_msr(vmx, msr);
> -	if (from < 0)
> +	uret_msr = vmx_find_uret_msr(vmx, msr);
> +	if (!uret_msr)
>  		return;
> -	to = vmx->nr_active_uret_msrs++;
>  
> -	tmp = vmx->guest_uret_msrs[to];
> -	vmx->guest_uret_msrs[to] = vmx->guest_uret_msrs[from];
> -	vmx->guest_uret_msrs[from] = tmp;
> +	uret_msr->load_into_hardware = load_into_hardware;
>  }
>  
>  /*
> @@ -1785,30 +1781,36 @@ static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
>   */
>  static void setup_msrs(struct vcpu_vmx *vmx)
>  {
> -	vmx->guest_uret_msrs_loaded = false;
> -	vmx->nr_active_uret_msrs = 0;
>  #ifdef CONFIG_X86_64
> +	bool load_syscall_msrs;
> +
>  	/*
>  	 * The SYSCALL MSRs are only needed on long mode guests, and only
>  	 * when EFER.SCE is set.
>  	 */
> -	if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
> -		vmx_setup_uret_msr(vmx, MSR_STAR);
> -		vmx_setup_uret_msr(vmx, MSR_LSTAR);
> -		vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK);
> -	}
> +	load_syscall_msrs = is_long_mode(&vmx->vcpu) &&
> +			    (vmx->vcpu.arch.efer & EFER_SCE);
> +
> +	vmx_setup_uret_msr(vmx, MSR_STAR, load_syscall_msrs);
> +	vmx_setup_uret_msr(vmx, MSR_LSTAR, load_syscall_msrs);
> +	vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK, load_syscall_msrs);
>  #endif
> -	if (update_transition_efer(vmx))
> -		vmx_setup_uret_msr(vmx, MSR_EFER);
> +	vmx_setup_uret_msr(vmx, MSR_EFER, update_transition_efer(vmx));
>  
> -	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
> -	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
> -		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
> +	vmx_setup_uret_msr(vmx, MSR_TSC_AUX,
> +			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
> +			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
>  
> -	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> +	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, true);
>  
>  	if (cpu_has_vmx_msr_bitmap())
>  		vmx_update_msr_bitmap(&vmx->vcpu);
> +
> +	/*
> +	 * The set of MSRs to load may have changed, reload MSRs before the
> +	 * next VM-Enter.
> +	 */
> +	vmx->guest_uret_msrs_loaded = false;
>  }
>  
>  static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index d71ed8b425c5..16e4e457ba23 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -36,7 +36,7 @@ struct vmx_msrs {
>  };
>  
>  struct vmx_uret_msr {
> -	unsigned int slot; /* The MSR's slot in kvm_user_return_msrs. */
> +	bool load_into_hardware;
>  	u64 data;
>  	u64 mask;
>  };

This is a very welcomed change, the old code was very complicated
to understand.

However I still feel that it would be nice to have a comment explaining
that vmx->guest_uret_msrs follow the same order now as the (eventually common)
uret msr list, and basically is a parallel array that extends the 
percpu 'user_return_msrs' and the global kvm_uret_msrs_list arrays.

In fact why not to fold the vmx->guest_uret_msrs into the x86 common uret msr list?
There is nothing VMX specific in this list IMHO and SVM can use it as well,
in fact it has 'svm->tsc_aux' which is the 'data' field of a 'struct vmx_uret_msr'


Reviewed-by: Maxim Levitsky <mlevitsk@gmail.com>

Best regards,
	Maxim Levitsky





