Return-Path: <kvm+bounces-7946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2786848C4B
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 09:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 119711F24568
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 08:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C3E15AE0;
	Sun,  4 Feb 2024 08:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrxWV6AL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A9A14282;
	Sun,  4 Feb 2024 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707036814; cv=none; b=bZgZeg6GjHA3Kf+3bR/hOy0WJ6F2NvkbjVCxPIQWu1zBDg1Z7L4FHFEZhSYdsa07YdnUQwmyZp5j6NV83IhYuVgC2GRydFTORHSR0YgAdFG6Bg/sn6iKXtJM4hMTCTrGR3hTJSsP3Ptg2tHdaibauppRI/cYMCYY30kJm23dRSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707036814; c=relaxed/simple;
	bh=LLHRog0Y5BuI6tuJ+Il3SYEWFoFi5AyuuJd9z97WEi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yf81zpt0qn/YuGXC+ZPpurUyJOw+s4rpNC8p+82Ui9oDtEyaz7Y+VQA58gNoJzvjeFPQLiUIU2Qz7xe+GS+E84hmwVvgkc38BbSheGyw7QdcnW7vzmmLouevJPi05LxFGVetLmONl65/WVKWHyjAEfd7osxVGbw9j8jWEsQDWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrxWV6AL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707036813; x=1738572813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LLHRog0Y5BuI6tuJ+Il3SYEWFoFi5AyuuJd9z97WEi8=;
  b=QrxWV6ALfnyD56hFWqEyKl9sOTgL2NVYJqPYpr6WzTQArUNYrJ5UTvAo
   MYSb/6jKHj6cKAGMWE+dmTdJ1q7DqrLUYdyI9EJkfwp9NVyHZs557Ip3o
   8V96ALAEwv5vYRNPzleAcLrxrkMGczlAWnfWgPsHXxxzr83VZjv25dQ74
   0/Yd1ZgHmZ6ry0DKoP4wTKSpCR9k/MK9zQpN4fXA11FkxD4FtCx/gv+WF
   vivvEAP7UyYJUCNYDAed1RRIaZRTzf9t/e7CCmCKa/YUIv026J2rzwKjG
   6HwuShk3FKTShKZiW80viNUCY5+LrLXDbS54cr7eZg6frfgUMfCrn1gFF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="11022710"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11022710"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 00:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="932886723"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="932886723"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 00:53:29 -0800
Message-ID: <45b6ba60-276e-4826-b3e4-20d3854558b1@linux.intel.com>
Date: Sun, 4 Feb 2024 16:53:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 054/121] KVM: VMX: Split out guts of EPT violation to
 common/exposed function
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <4aa3aaa6d12640ee9948308116c6f57ad3a0c1ba.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4aa3aaa6d12640ee9948308116c6f57ad3a0c1ba.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> The difference of TDX EPT violation is how to retrieve information, GPA,
> and exit qualification.  To share the code to handle EPT violation, split
> out the guts of EPT violation handler so that VMX/TDX exit handler can call
> it after retrieving GPA and exit qualification.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/kvm/vmx/common.h | 33 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c    | 25 +++----------------------
>   2 files changed, 36 insertions(+), 22 deletions(-)
>   create mode 100644 arch/x86/kvm/vmx/common.h
>
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> new file mode 100644
> index 000000000000..235908f3e044
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_X86_VMX_COMMON_H
> +#define __KVM_X86_VMX_COMMON_H
> +
> +#include <linux/kvm_host.h>
> +
> +#include "mmu.h"
> +
> +static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					     unsigned long exit_qualification)
> +{
> +	u64 error_code;
> +
> +	/* Is it a read fault? */
> +	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> +		     ? PFERR_USER_MASK : 0;
> +	/* Is it a write fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> +		      ? PFERR_WRITE_MASK : 0;
> +	/* Is it a fetch fault? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> +		      ? PFERR_FETCH_MASK : 0;
> +	/* ept page table entry is present? */
> +	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
> +		      ? PFERR_PRESENT_MASK : 0;
> +
> +	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> +	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> +
> +	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +}
> +
> +#endif /* __KVM_X86_VMX_COMMON_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 89f31263fe9c..185e22a2e101 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -50,6 +50,7 @@
>   #include <asm/vmx.h>
>   
>   #include "capabilities.h"
> +#include "common.h"
>   #include "cpuid.h"
>   #include "hyperv.h"
>   #include "kvm_onhyperv.h"
> @@ -5779,11 +5780,8 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
>   
>   static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   {
> -	unsigned long exit_qualification;
> +	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>   	gpa_t gpa;
> -	u64 error_code;
> -
> -	exit_qualification = vmx_get_exit_qual(vcpu);
>   
>   	/*
>   	 * EPT violation happened while executing iret from NMI,
> @@ -5798,23 +5796,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   
>   	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>   	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
> -
> -	/* Is it a read fault? */
> -	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
> -		     ? PFERR_USER_MASK : 0;
> -	/* Is it a write fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
> -		      ? PFERR_WRITE_MASK : 0;
> -	/* Is it a fetch fault? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
> -		      ? PFERR_FETCH_MASK : 0;
> -	/* ept page table entry is present? */
> -	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
> -		      ? PFERR_PRESENT_MASK : 0;
> -
> -	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> -	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> -
>   	vcpu->arch.exit_qualification = exit_qualification;
>   
>   	/*
> @@ -5828,7 +5809,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
>   		return kvm_emulate_instruction(vcpu, 0);
>   
> -	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
>   }
>   
>   static int handle_ept_misconfig(struct kvm_vcpu *vcpu)


