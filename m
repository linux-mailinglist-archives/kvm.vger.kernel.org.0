Return-Path: <kvm+bounces-10766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C1186FB55
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:10:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 309CC1C21AD8
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12351754B;
	Mon,  4 Mar 2024 08:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aq/h+PJf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A052171BC;
	Mon,  4 Mar 2024 08:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709539797; cv=none; b=nPXpGneqBoIYGHGIeRTyecfLSqkau4GgA6CZl5fu3B8foOrJZc65/foYsNOBt53ayLJjHktxSh7DavqR3Bh0oP62OfI7Dkje0pywgfbDRWUg1hm1GF3A3X44y9aG4KkOPlIc4nYsJ3lp5zM90eUl3iKELDe9hagNwsgW468CVK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709539797; c=relaxed/simple;
	bh=3T1qL87IxDrdy133md9CkPirpgpaqMjtsA4PEXQOKGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cPSvZMNV95XymCZiFfQmNEg/OhbTNHctTAcXJ4a2qSi2rmlHG1TtcYBJ2h0YhwsfjYoBnYOJubPm5gi6cltqSAwN8//yp4+Rs3dCJOy3uLaNDRJzEpPbLrPwitKOl46MxNIQkfAorEl2B5QtCAkSRC2xqTsntJp02PPE2bKvJbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aq/h+PJf; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709539795; x=1741075795;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3T1qL87IxDrdy133md9CkPirpgpaqMjtsA4PEXQOKGU=;
  b=aq/h+PJfx7FbZWfzlvGiqa+zBPh18dF1n4l82M655cfBWbkIF314qkXA
   6kn9HtoXEUP3XqSGKopTUdoQF2GjXBmMW7GkifvMmDnEK1AbqL8Xpc6ha
   IiQ3CnCPP8daltEaTav7U+R0cjQotGlsuWAHHdtVPX1Q0L20FrvqM4Pcp
   7Ib3S3+T8RVnxt/qvdc4baMM23jK69rrOiF7zOIduoOAV7z9hQuBjxNg4
   U/Qbl/B6Y5L9lw6Zw7A3f54kTCOs4YrWalWdBuMloeAwjDAkx2hsGO0g0
   rEkVhaWe4Rwp3ZDci5UPDWpBE3rwe0WI2IMoo2/kGQ+P+Sbvb+JRGFjbX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="3872843"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="3872843"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="8861439"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:09:52 -0800
Message-ID: <7ea4d33a-9c0b-47ca-9b02-ae1e79fd015b@intel.com>
Date: Mon, 4 Mar 2024 16:09:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: VMX: Modify NMI and INTR handlers to take
 intr_info as function argument
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-10-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

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


