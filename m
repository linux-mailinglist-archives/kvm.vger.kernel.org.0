Return-Path: <kvm+bounces-10987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 126B587208D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C343C287880
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98058612E;
	Tue,  5 Mar 2024 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NvSLPpzu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472DF5676A;
	Tue,  5 Mar 2024 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646174; cv=none; b=T++4P9ztkMoA/MGtuixdzjvX+azGOrxcJgF+v+TWCc1cMRTeqOzrszghPa06SIgiHrMIlX0BaBRmm+h8+TihobGI7N864kp1H7Qip0lRIkswN9S3F1CHRbxloWBL7hcYMdB5FmvgrBuuQIyq1xYu1nLpGXYak3Cyxco//eK331E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646174; c=relaxed/simple;
	bh=1TUXrK0mJ+n0Z9W20paGt+AZeDVv0d+6JACKRbEJcIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qu32RHlxh8XqsbFeSIjeZievhJUnYGCDV8BXy6vgZhKkDAaHpLN9MnBuqlzzi0rWFF3ZjbzH7v1I3BT2OTTu/0r6vmR2QcZ6fpwvQLiL/CcXsh7EZLCUR9EacNxrr8KdRw1vynpZKZ8advzwHctrbhmdwPgGzFjDxlVnRj3UMP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NvSLPpzu; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709646172; x=1741182172;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1TUXrK0mJ+n0Z9W20paGt+AZeDVv0d+6JACKRbEJcIU=;
  b=NvSLPpzuFE+wpZr4vmargD2hixWj3PKpnirSb7Wwi2y6Fww1xMfbbTDZ
   szNlxbZWTaoSDXiGyqlVYYO6iBkdtMvV0zheQ3VvG5Ij9AHe0+0xR9q5l
   m+LjHB+Js2Ww9ruFVdo7O7dG0o06RL5x66NVvyN0U5IblKX0NIGtbfwlS
   rb3AtySDFSZvl87RA5uLRy0OBuwC079SMw8jeYlzYtXJDUsEQQnKTQZ30
   +dlUpmEpoLVX2skhoA5rnof1sBwMwoN+YafM+6z46O1GpAYcxRZHhm+HM
   7wYIwlhhJbyYI//CWlIMVLcvb/oxnHq/qJ/78IpCD+aMfmkKrBfVGRAel
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4055200"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4055200"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 05:42:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9321527"
Received: from peizhenz-mobl2.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 05:42:49 -0800
Message-ID: <15567943-817b-4fb8-a4ab-2d97ce2c827a@linux.intel.com>
Date: Tue, 5 Mar 2024 21:42:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: VMX: Modify NMI and INTR handlers to take
 intr_info as function argument
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-10-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240227232100.478238-10-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> TDX uses different ABI to get information about VM exit.  Pass intr_info to
> the NMI and INTR handlers instead of pulling it from vcpu_vmx in
> preparation for sharing the bulk of the handlers with TDX.
>
> When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
> exit qualification etc rather than the VMCS fields because VMM doesn't have
> access to the VMCS.  The eventual code will be
>
> VMX:
>    - get exit reason, intr_info, exit_qualification, and etc from VMCS
>    - call NMI/INTR handlers (common code)
>
> TDX:
>    - get exit reason, intr_info, exit_qualification, and etc from guest
>      registers
>    - call NMI/INTR handlers (common code)
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <0396a9ae70d293c9d0b060349dae385a8a4fbcec.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3d8a7e4c8e37..8aedfe0fd78c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7000,24 +7000,22 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
>   		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
>   }
>   
> -static void handle_exception_irqoff(struct vcpu_vmx *vmx)
> +static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
>   {
> -	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
> -
>   	/* if exit due to PF check for async PF */
>   	if (is_page_fault(intr_info))
> -		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
>   	/* if exit due to NM, handle before interrupts are enabled */
>   	else if (is_nm_fault(intr_info))
> -		handle_nm_fault_irqoff(&vmx->vcpu);
> +		handle_nm_fault_irqoff(vcpu);
>   	/* Handle machine checks before interrupts are enabled */
>   	else if (is_machine_check(intr_info))
>   		kvm_machine_check();
>   }
>   
> -static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> +static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
> +					     u32 intr_info)
>   {
> -	u32 intr_info = vmx_get_intr_info(vcpu);
>   	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
>   	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>   
> @@ -7040,9 +7038,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>   		return;
>   
>   	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> -		handle_external_interrupt_irqoff(vcpu);
> +		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> -		handle_exception_irqoff(vmx);
> +		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
>   }
>   
>   /*


