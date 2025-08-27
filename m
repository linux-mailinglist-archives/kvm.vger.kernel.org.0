Return-Path: <kvm+bounces-55847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A3AB37A40
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E32951B6727D
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 06:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA092DFA3A;
	Wed, 27 Aug 2025 06:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gXDA9Nil"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8279A2BE027;
	Wed, 27 Aug 2025 06:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756275736; cv=none; b=BmjQv/aPE83aKq34XrJRIZFl5Z1vgENmIyU+1519z/Huob8QuOPaIdCkz849Ya3U3G85D0eaqE5ENaAne+s9OYOUv8w/sKS9JjpSuDrMBFFUaWZJl6hAwRwliyI526I6JXr+YrG1RUEEZjkYfukD3FyWbi2APObsdNd8Q5dsrJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756275736; c=relaxed/simple;
	bh=ghqyHuxRn2YZ182BMZRUnoAXRhnwuthZ2gQmVN6HRL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHbPKEgrytBIkMjQxTfVvq9vn+lgnswjC3oVb4awIHb2gMgyPC2RICoZV49HG4smBNNchKMlRfS4qrBR+WuUqhtqFzX8r03GrLjrIfdbOmKbIiedHmqrFfhLs+b9SHI7Fp7KN820/y8P4vB6Zl9BWvqw3FYWkVdJm5ce4dw3BMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gXDA9Nil; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756275735; x=1787811735;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ghqyHuxRn2YZ182BMZRUnoAXRhnwuthZ2gQmVN6HRL8=;
  b=gXDA9NilouEZJlf/QPHqsP00Ty4TVn5YuhCnBF6PsPIqyJW8AT6Jn5pg
   s3ERZJjMzUttPGkndsz8qGA+Ah2UZptOOxrO+LaLCUGjwAL6M1Uw1Yzon
   CBnbUOs2mwwq3XevUhCDMgv9j4zGWeja5/YlI9PIcgxSJNnYLuxldhjxY
   e2F0mc9zqmoE9uKJ/PWN/APtON62BKkIC82xVHUYK5IyuS0Slly5cXUMo
   Dnapr7tFQSlFObF43S4rS6COzgHskoisHVEWfdsc3/hV9gjMGurj79HJO
   I+kRjjOaxuUcHJU0Fq5uQcEKoQrBFNfkddfdPXkJsmjyfzO1HYbGbCHiU
   w==;
X-CSE-ConnectionGUID: wLsczntMRZeiRMyDnmWmxQ==
X-CSE-MsgGUID: e3+WSjyeQ36nx4HIwjQ15Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="62167177"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="62167177"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 23:22:13 -0700
X-CSE-ConnectionGUID: gRB1mM8XS+GLSYvJNO1mxw==
X-CSE-MsgGUID: b5KA2KaPRzStWr4+UE8efw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169942757"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 23:22:07 -0700
Message-ID: <6fe55bc3-dd79-4f7d-9927-7d4f40f7b246@intel.com>
Date: Wed, 27 Aug 2025 14:22:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: TDX: Force split irqchip for TDX at irqchip
 creation time
To: Sagi Shahar <sagis@google.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
References: <20250827011726.2451115-1-sagis@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250827011726.2451115-1-sagis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/2025 9:17 AM, Sagi Shahar wrote:
> TDX module protects the EOI-bitmap which prevents the use of in-kernel
> I/O APIC. See more details in the original patch [1]
> 
> The current implementation already enforces the use of split irqchip for
> TDX but it does so at the vCPU creation time which is generally to late
> to fallback to split irqchip.
> 
> This patch follows Sean's recomendation from [2] and move the check if
> I/O APIC is supported for the VM at irqchip creation time.
> 
> [1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@linux.intel.com/
> [2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/vmx/tdx.c          | 6 ++++++
>   arch/x86/kvm/x86.c              | 9 +++++++++
>   3 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..6a4019d3a184 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1357,6 +1357,7 @@ struct kvm_arch {
>   	u8 vm_type;
>   	bool has_private_mem;
>   	bool has_protected_state;
> +	bool has_protected_eoi;
>   	bool pre_fault_allowed;
>   	struct hlist_head *mmu_page_hash;
>   	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..9637d9da1af1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -658,6 +658,12 @@ int tdx_vm_init(struct kvm *kvm)
>   	 */
>   	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
>   
> +	/*
> +	 * TDX Module doesn't allow the hypervisor to modify the EOI-bitmap,
> +	 * i.e. all EOIs are accelerated and never trigger exits.
> +	 */
> +	kvm->arch.has_protected_eoi = true;

I prefer putting it along with the lines

	kvm->arch.has_protected_state = true;
	kvm->arch.has_private_mem = true;

Otherwise,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>   	kvm_tdx->state = TD_STATE_UNINITIALIZED;
>   
>   	return 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c4..57b4d5ba2568 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6966,6 +6966,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   		if (irqchip_in_kernel(kvm))
>   			goto create_irqchip_unlock;
>   
> +		/*
> +		 * Disallow an in-kernel I/O APIC if the VM has protected EOIs,
> +		 * i.e. if KVM can't intercept EOIs and thus can't properly
> +		 * emulate level-triggered interrupts.
> +		 */
> +		r = -ENOTTY;
> +		if (kvm->arch.has_protected_eoi)
> +			goto create_irqchip_unlock;
> +
>   		r = -EINVAL;
>   		if (kvm->created_vcpus)
>   			goto create_irqchip_unlock;


