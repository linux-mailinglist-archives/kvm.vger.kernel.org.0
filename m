Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20243377E2A
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhEJI2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230247AbhEJI1N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0LDfY9700IqpGbDm7Kn8n10AJobSAnYMBp1/E/7x2o=;
        b=XsQrBetOGEfrtLQi/sIp0GEI2mVD2oFOuZlxcw4VoTpLZrFcx/JR7lXs6L+Na210vVFYOP
        6EDsAl/A7Zc5jBxpiucgShTWr20MTIedQo+c9miXPpiz7iOKh25qmXI7FjeLBA2BaliQ2G
        ZO+Z5GqGKnWjrBkzxBOGtHvGe20yZZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-v4ln569LPrOEURXFpoNjgw-1; Mon, 10 May 2021 04:26:03 -0400
X-MC-Unique: v4ln569LPrOEURXFpoNjgw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F402F800D62;
        Mon, 10 May 2021 08:26:01 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF4EB70580;
        Mon, 10 May 2021 08:25:58 +0000 (UTC)
Message-ID: <b279981a9e49539ae3c18ace9c49042771e15eaa.camel@redhat.com>
Subject: Re: [PATCH 10/15] KVM: VMX: Use common x86's uret MSR list as the
 one true list
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:25:57 +0300
In-Reply-To: <20210504171734.1434054-11-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Drop VMX's global list of user return MSRs now that VMX doesn't resort said
> list to isolate "active" MSRs, i.e. now that VMX's list and x86's list have
> the same MSRs in the same order.
> 
> In addition to eliminating the redundant list, this will also allow moving
> more of the list management into common x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 97 ++++++++++++++-------------------
>  arch/x86/kvm/x86.c              | 12 ++++
>  3 files changed, 53 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a02c9bf3f7f1..c9452472ed55 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1778,6 +1778,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  		    unsigned long icr, int op_64_bit);
>  
>  void kvm_define_user_return_msr(unsigned index, u32 msr);
> +int kvm_find_user_return_msr(u32 msr);
>  int kvm_probe_user_return_msr(u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6caabcd5037e..4b432d2bbd06 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -454,26 +454,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
>  
>  static unsigned long host_idt_base;
>  
> -/*
> - * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
> - * will emulate SYSCALL in legacy mode if the vendor string in guest
> - * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
> - * support this emulation, MSR_STAR is included in the list for i386,
> - * but is never loaded into hardware.  MSR_CSTAR is also never loaded
> - * into hardware and is here purely for emulation purposes.
> - */
> -static u32 vmx_uret_msrs_list[] = {
> -#ifdef CONFIG_X86_64
> -	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
> -#endif
> -	MSR_EFER, MSR_TSC_AUX, MSR_STAR,
> -	MSR_IA32_TSX_CTRL,
> -};
> -
> -/*
> - * Number of user return MSRs that are actually supported in hardware.
> - * vmx_uret_msrs_list is modified when KVM is loaded to drop unsupported MSRs.
> - */
> +/* Number of user return MSRs that are actually supported in hardware. */
>  static int vmx_nr_uret_msrs;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> @@ -703,22 +684,11 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	return r;
>  }
>  
> -static inline int __vmx_find_uret_msr(u32 msr)
> -{
> -	int i;
> -
> -	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> -		if (vmx_uret_msrs_list[i] == msr)
> -			return i;
> -	}
> -	return -1;
> -}
> -
>  struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
>  {
>  	int i;
>  
> -	i = __vmx_find_uret_msr(msr);
> +	i = kvm_find_user_return_msr(msr);
>  	if (i >= 0)
>  		return &vmx->guest_uret_msrs[i];
>  	return NULL;
> @@ -1086,7 +1056,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
>  		return false;
>  	}
>  
> -	i = __vmx_find_uret_msr(MSR_EFER);
> +	i = kvm_find_user_return_msr(MSR_EFER);
>  	if (i < 0)
>  		return false;
>  
> @@ -6922,6 +6892,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
>  
>  static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  {
> +	struct vmx_uret_msr *tsx_ctrl;
>  	struct vcpu_vmx *vmx;
>  	int i, cpu, err;
>  
> @@ -6946,29 +6917,25 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
>  		vmx->guest_uret_msrs[i].data = 0;
> -
> -		switch (vmx_uret_msrs_list[i]) {
> -		case MSR_IA32_TSX_CTRL:
> -			/*
> -			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
> -			 * interception.  Keep the host value unchanged to avoid
> -			 * changing CPUID bits under the host kernel's feet.
> -			 *
> -			 * hle=0, rtm=0, tsx_ctrl=1 can be found with some
> -			 * combinations of new kernel and old userspace.  If
> -			 * those guests run on a tsx=off host, do allow guests
> -			 * to use TSX_CTRL, but do not change the value on the
> -			 * host so that TSX remains always disabled.
> -			 */
> -			if (boot_cpu_has(X86_FEATURE_RTM))
> -				vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> -			else
> -				vmx->guest_uret_msrs[i].mask = 0;
> -			break;
> -		default:
> -			vmx->guest_uret_msrs[i].mask = -1ull;
> -			break;
> -		}
> +		vmx->guest_uret_msrs[i].mask = -1ull;
> +	}
> +	tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> +	if (tsx_ctrl) {
> +		/*
> +		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
> +		 * Keep the host value unchanged to avoid changing CPUID bits
> +		 * under the host kernel's feet.
> +		 *
> +		 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations
> +		 * of new kernel and old userspace.  If those guests run on a
> +		 * tsx=off host, do allow guests to use TSX_CTRL, but do not
> +		 * change the value on the host so that TSX remains always
> +		 * disabled.
> +		 */
> +		if (boot_cpu_has(X86_FEATURE_RTM))
> +			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> +		else
> +			vmx->guest_uret_msrs[i].mask = 0;
>  	}
>  
>  	err = alloc_loaded_vmcs(&vmx->vmcs01);
> @@ -7829,6 +7796,22 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  static __init void vmx_setup_user_return_msrs(void)
>  {
> +
> +	/*
> +	 * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
> +	 * will emulate SYSCALL in legacy mode if the vendor string in guest
> +	 * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
> +	 * support this emulation, MSR_STAR is included in the list for i386,
> +	 * but is never loaded into hardware.  MSR_CSTAR is also never loaded
> +	 * into hardware and is here purely for emulation purposes.
> +	 */
> +	const u32 vmx_uret_msrs_list[] = {
> +	#ifdef CONFIG_X86_64
> +		MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
> +	#endif
> +		MSR_EFER, MSR_TSC_AUX, MSR_STAR,
> +		MSR_IA32_TSX_CTRL,
> +	};
>  	u32 msr;
>  	int i;
>  
> @@ -7841,7 +7824,7 @@ static __init void vmx_setup_user_return_msrs(void)
>  			continue;
>  
>  		kvm_define_user_return_msr(vmx_nr_uret_msrs, msr);
> -		vmx_uret_msrs_list[vmx_nr_uret_msrs++] = msr;
> +		vmx_nr_uret_msrs++;
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4516d303413..90ef340565a4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -364,6 +364,18 @@ void kvm_define_user_return_msr(unsigned slot, u32 msr)
>  }
>  EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
>  
> +int kvm_find_user_return_msr(u32 msr)
> +{
> +	int i;
> +
> +	for (i = 0; i < user_return_msrs_global.nr; ++i) {
> +		if (user_return_msrs_global.msrs[i] == msr)
> +			return i;
> +	}
> +	return -1;
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
> +
>  static void kvm_user_return_msr_cpu_online(void)
>  {
>  	unsigned int cpu = smp_processor_id();


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky <mlevitsk@redhat.com>


