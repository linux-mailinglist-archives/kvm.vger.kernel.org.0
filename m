Return-Path: <kvm+bounces-55818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E30B376F3
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 03:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0DB757A901E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 01:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75241C1F12;
	Wed, 27 Aug 2025 01:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UyRF7U3D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496A930CD95;
	Wed, 27 Aug 2025 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756258259; cv=none; b=gdl6f3RzqQOXZgWzaDPNBFpLigIbM4a/CSScctn5N9Jgq7xALocDxyHBACCCCgKi+DB15/IYCN97NoFnEl9qv99RSiUvMH/V2DInEUiDiHfnFlHZ9S69Dy8QwNcnlubyHX4D++apjO0W71c2nXabXxLKwdVU+0xMa/MjsaCeHM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756258259; c=relaxed/simple;
	bh=Ma6zPkLuZOyhRNH2DiEPSmnzmAIv+f//eK9q3sN1l2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PCuWGjxOyxVeQpE1pLah6LWOEdXf1CaGwiifLzm/ubVm70B4KXz8wkfAIgF+7g0JF8OGrWTgDx+3aYTrOu6nioZIR1KCtXV+lzyxD3Wpoa8wX1SFz5qqDZ1H1ipfuSg2nygjye+QVuxrIfxnC+nj+iYtlGHTyMvfaOnhFDvCkjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UyRF7U3D; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756258258; x=1787794258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ma6zPkLuZOyhRNH2DiEPSmnzmAIv+f//eK9q3sN1l2w=;
  b=UyRF7U3D71O8kAKQDmlja0uc3o6BXaN0ij/5c/SwgJ9iphi4YAGZZ4Q4
   c6bpMs5AWHZEGI51b7hmFj7O9k1pdx6KwgXBMhSvj8pnoLbYqk5Pj/PXH
   urg+P9Pzg+DGSqMGkDsNVD1YJaQPGl4r8ODGIw+G9UpmWeA1j7YMAv12Z
   h+ecGinoHAgkWkldE9EzrIzUPRvPJYCF8meSnmJJKFI4NmUenImzMDZQC
   XsAngO26LRraVsF3LEQ178ICJ3XqsXKzFRM2sn2lHrpgQiRbQcZgfyctg
   hTVL3WWV/O4NUdBxSubeu8AgiO+mECPTXGLo1dx7GTgWzlbAWirDOrs/M
   g==;
X-CSE-ConnectionGUID: e0zYEug7TXKomfftKR1spA==
X-CSE-MsgGUID: MCl3OjtrQzarUUu7OkwS2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62344906"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62344906"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 18:30:57 -0700
X-CSE-ConnectionGUID: W9YuCKEqSw24YZWgGcvdYQ==
X-CSE-MsgGUID: TiCAk7ScQg+A51i62HIycg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="174048790"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.233.111]) ([10.124.233.111])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 18:30:54 -0700
Message-ID: <135fa768-c1f5-4936-afa5-509d66364241@linux.intel.com>
Date: Wed, 27 Aug 2025 09:30:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Force split irqchip for TDX at irqchip creation
 time
To: Sagi Shahar <sagis@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org
References: <20250826213455.2338722-1-sagis@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250826213455.2338722-1-sagis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/27/2025 5:34 AM, Sagi Shahar wrote:
> TDX module protects the EOI-bitmap which prevents the use of in-kernel
> I/O APIC. See more details in the original patch [1]
>
> The current implementation already enforces the use of split irqchip for
> TDX but it does so at the vCPU creation time which is generally to late
                                                                 ^
                                                                 too
> to fallback to split irqchip.
>
> This patch follows Sean's recomendation from [2] and move the check if

recomendation -> recommendation

> I/O APIC is supported for the VM at irqchip creation time.
>
> [1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@linux.intel.com/
> [2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/vmx/tdx.c          | 15 ++++++++-------
>   arch/x86/kvm/x86.c              | 10 ++++++++++
>   3 files changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f19a76d3ca0e..cb22fc48cdec 100644
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
> @@ -2284,6 +2285,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   
>   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>   
> +#define kvm_arch_has_protected_eoi(kvm) (!(kvm)->arch.has_protected_eoi)
> +
>   static inline u16 kvm_read_ldt(void)
>   {
>   	u16 ldt;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..8c270a159692 100644
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
> +
>   	kvm_tdx->state = TD_STATE_UNINITIALIZED;
>   
>   	return 0;
> @@ -671,13 +677,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	if (kvm_tdx->state != TD_STATE_INITIALIZED)
>   		return -EIO;
>   
> -	/*
> -	 * TDX module mandates APICv, which requires an in-kernel local APIC.
> -	 * Disallow an in-kernel I/O APIC, because level-triggered interrupts
> -	 * and thus the I/O APIC as a whole can't be faithfully emulated in KVM.
> -	 */
> -	if (!irqchip_split(vcpu->kvm))
> -		return -EINVAL;
> +	/* Split irqchip should be enforced at irqchip creation time. */
> +	KVM_BUG_ON(irqchip_split(vcpu->kvm), vcpu->kvm);

Should be
KVM_BUG_ON(!irqchip_split(vcpu->kvm), vcpu->kvm);

>   
>   	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>   	vcpu->arch.apic->guest_apic_protected = true;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c4..a846dd3dcb23 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6966,6 +6966,16 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   		if (irqchip_in_kernel(kvm))
>   			goto create_irqchip_unlock;
>   
> +		/*
> +		 * Disallow an in-kernel I/O APIC for platforms that has protected
> +		 * EOI (such as TDX). The hypervisor can't modify the EOI-bitmap
> +		 * on these platforms which prevents the proper emulation of
> +		 * level-triggered interrupts.
> +		 */
> +		r = -ENOTTY;
> +		if (kvm_arch_has_protected_eoi(kvm))
> +			goto create_irqchip_unlock;
> +
>   		r = -EINVAL;
>   		if (kvm->created_vcpus)
>   			goto create_irqchip_unlock;


