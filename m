Return-Path: <kvm+bounces-13975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE7389D4E9
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 10:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 426E82818FE
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 08:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B3B7F46A;
	Tue,  9 Apr 2024 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZNOtIG0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17427E794;
	Tue,  9 Apr 2024 08:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712652784; cv=none; b=ljQT2V1oEWfpTAMHettgKVnc6dpIRA3GhH9P+91PpiS2oFgii9Z6+RpMyFv8LPL8S7e7TjNYWo7WR/8RTCXXdL1C7SnfGc/pz6kLw6tQO2ST2BjG30ZeTlZoU+NzoeLuilghqxpfpbo7s2jF5pPel7klMiuE6HL/7BHwTHKDJTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712652784; c=relaxed/simple;
	bh=LXkNVlRuW9flSn9i9Am3TH+MFAtd0G+t2OWUcoL9zg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iYHBiK6I4OQx+G2tIWM7rQDIc8hWSylEO38xVsXyCDfL8kxVmEgei/34qpV+2hCYYT0qgXko4F9QR4SCJgmzIFxRrtMZms3KyAyBv5UyGfkNoiznkn+E3t6EJgWmW40W8Rc83romlG/zBaxzxAst5PODztrjCNX8/lAT3anhTgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZNOtIG0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712652783; x=1744188783;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LXkNVlRuW9flSn9i9Am3TH+MFAtd0G+t2OWUcoL9zg8=;
  b=PZNOtIG0bYb8RwdkHnHtDuJHqJuSc1NsffEanhru/kA+rz6UjtNaFCjb
   TYP38UUcXXU9x9fMLLRuTu13AQByji82eXzO9LKkj4m+ZJS7DcrYSffDI
   EBH4Xvks/Yth6bxgaWvWbAWR7FVkoTn6nQCMd16d9Sos/eQC2q2hIOORP
   WzDjfYccnHGpSeJO9Np+gPVajPZSi1euB2f7Vo5PoZ0lm/4C98XrUm54q
   BqD7NYQgMHP+HAS2a+oIOUWV+5MHQAy/9xZmsGDBcENP8uLrWi/gv0pq7
   HBbE0Xh64a6MxXV9FPSShZ3EWSsxtLTt3EOeT8jyMAKwPJfUcLcB305RX
   A==;
X-CSE-ConnectionGUID: rFSTUaXaShKf8o9y3HgyIQ==
X-CSE-MsgGUID: E24n8qbPTiuyZtc+RQar9g==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="18563303"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="18563303"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 01:53:02 -0700
X-CSE-ConnectionGUID: 89x2+YlKRTaKym0zn3MeNQ==
X-CSE-MsgGUID: kXKIZc6NS7iIB7ucFUO7IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="24898864"
Received: from unknown (HELO [10.238.9.252]) ([10.238.9.252])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 01:52:58 -0700
Message-ID: <bb05156c-a143-4257-b5a3-4af05429e07f@linux.intel.com>
Date: Tue, 9 Apr 2024 16:52:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 096/130] KVM: VMX: Move NMI/exception handler to
 common helper
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b709dc92da98e6bd0ba15c80c1f291beafc9dada.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b709dc92da98e6bd0ba15c80c1f291beafc9dada.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX mostly handles NMI/exception exit mostly the same to VMX case.  The
> difference is how to retrieve exit qualification.  To share the code with
> TDX, move NMI/exception to a common header, common.h.

Suggest to add "No functional change intended." in the changelog.

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/common.h | 59 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c    | 68 +++++----------------------------------
>   2 files changed, 67 insertions(+), 60 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 6f21d0d48809..632af7a76d0a 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -4,8 +4,67 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/traps.h>
> +
>   #include "posted_intr.h"
>   #include "mmu.h"
> +#include "vmcs.h"
> +#include "x86.h"
> +
> +extern unsigned long vmx_host_idt_base;
> +void vmx_do_interrupt_irqoff(unsigned long entry);
> +void vmx_do_nmi_irqoff(void);
> +
> +static inline void vmx_handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
> +	 * MSR value is not clobbered by the host activity before the guest
> +	 * has chance to consume it.
> +	 *
> +	 * Do not blindly read xfd_err here, since this exception might
> +	 * be caused by L1 interception on a platform which doesn't
> +	 * support xfd at all.
> +	 *
> +	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
> +	 * only when xfd contains a non-zero value.
> +	 *
> +	 * Queuing exception is done in vmx_handle_exit. See comment there.
> +	 */
> +	if (vcpu->arch.guest_fpu.fpstate->xfd)
> +		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> +}
> +
> +static inline void vmx_handle_exception_irqoff(struct kvm_vcpu *vcpu,
> +					       u32 intr_info)
> +{
> +	/* if exit due to PF check for async PF */
> +	if (is_page_fault(intr_info))
> +		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +	/* if exit due to NM, handle before interrupts are enabled */
> +	else if (is_nm_fault(intr_info))
> +		vmx_handle_nm_fault_irqoff(vcpu);
> +	/* Handle machine checks before interrupts are enabled */
> +	else if (is_machine_check(intr_info))
> +		kvm_machine_check();
> +}
> +
> +static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
> +							u32 intr_info)
> +{
> +	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> +	gate_desc *desc = (gate_desc *)vmx_host_idt_base + vector;
> +
> +	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
> +	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
> +		return;
> +
> +	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> +	vmx_do_interrupt_irqoff(gate_offset(desc));
> +	kvm_after_interrupt(vcpu);
> +
> +	vcpu->arch.at_instruction_boundary = true;
> +}
>   
>   static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   					     unsigned long exit_qualification)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 29d891e0795e..f8a00a766c40 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -518,7 +518,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
>   	vmx->segment_cache.bitmask = 0;
>   }
>   
> -static unsigned long host_idt_base;
> +unsigned long vmx_host_idt_base;
>   
>   #if IS_ENABLED(CONFIG_HYPERV)
>   static bool __read_mostly enlightened_vmcs = true;
> @@ -4273,7 +4273,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>   	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
>   	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
>   
> -	vmcs_writel(HOST_IDTR_BASE, host_idt_base);   /* 22.2.4 */
> +	vmcs_writel(HOST_IDTR_BASE, vmx_host_idt_base);   /* 22.2.4 */
>   
>   	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
>   
> @@ -5166,7 +5166,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   	intr_info = vmx_get_intr_info(vcpu);
>   
>   	/*
> -	 * Machine checks are handled by handle_exception_irqoff(), or by
> +	 * Machine checks are handled by vmx_handle_exception_irqoff(), or by
>   	 * vmx_vcpu_run() if a #MC occurs on VM-Entry.  NMIs are handled by
>   	 * vmx_vcpu_enter_exit().
>   	 */
> @@ -5174,7 +5174,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		return 1;
>   
>   	/*
> -	 * Queue the exception here instead of in handle_nm_fault_irqoff().
> +	 * Queue the exception here instead of in vmx_handle_nm_fault_irqoff().
>   	 * This ensures the nested_vmx check is not skipped so vmexit can
>   	 * be reflected to L1 (when it intercepts #NM) before reaching this
>   	 * point.
> @@ -6889,59 +6889,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
>   	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
>   }
>   
> -void vmx_do_interrupt_irqoff(unsigned long entry);
> -void vmx_do_nmi_irqoff(void);
> -
> -static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
> -	 * MSR value is not clobbered by the host activity before the guest
> -	 * has chance to consume it.
> -	 *
> -	 * Do not blindly read xfd_err here, since this exception might
> -	 * be caused by L1 interception on a platform which doesn't
> -	 * support xfd at all.
> -	 *
> -	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
> -	 * only when xfd contains a non-zero value.
> -	 *
> -	 * Queuing exception is done in vmx_handle_exit. See comment there.
> -	 */
> -	if (vcpu->arch.guest_fpu.fpstate->xfd)
> -		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> -}
> -
> -static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
> -{
> -	/* if exit due to PF check for async PF */
> -	if (is_page_fault(intr_info))
> -		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> -	/* if exit due to NM, handle before interrupts are enabled */
> -	else if (is_nm_fault(intr_info))
> -		handle_nm_fault_irqoff(vcpu);
> -	/* Handle machine checks before interrupts are enabled */
> -	else if (is_machine_check(intr_info))
> -		kvm_machine_check();
> -}
> -
> -static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
> -					     u32 intr_info)
> -{
> -	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> -	gate_desc *desc = (gate_desc *)host_idt_base + vector;
> -
> -	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
> -	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
> -		return;
> -
> -	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_irqoff(gate_offset(desc));
> -	kvm_after_interrupt(vcpu);
> -
> -	vcpu->arch.at_instruction_boundary = true;
> -}
> -
>   void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -6950,9 +6897,10 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   		return;
>   
>   	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> -		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
> +		vmx_handle_external_interrupt_irqoff(vcpu,
> +						     vmx_get_intr_info(vcpu));
>   	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
> +		vmx_handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   }
>   
>   /*
> @@ -8284,7 +8232,7 @@ __init int vmx_hardware_setup(void)
>   	int r;
>   
>   	store_idt(&dt);
> -	host_idt_base = dt.address;
> +	vmx_host_idt_base = dt.address;
>   
>   	vmx_setup_user_return_msrs();
>   


