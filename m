Return-Path: <kvm+bounces-55820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E97B1B37740
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 03:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDFC97C4FFB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 01:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A9C1E51EC;
	Wed, 27 Aug 2025 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gImOeSR6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279CC1C4A2D;
	Wed, 27 Aug 2025 01:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756258884; cv=none; b=q9TwVWlXut36De3//YPuN+h+h6OpRptdyTiVQngBttl0ofNSNJK0eCOGJn8Sx7lY1ke0v53NzMQFmU5cVrrreRQkniv4Ecr9ZUVQdXhPdD3BaaDZfUOKq/tXwe+DZhEeX4Y7O65uC436qpCM9yQEI6AxrHfr+AVFpsDGfsAGboY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756258884; c=relaxed/simple;
	bh=5q/Ust8foSKyq6WO+ak6JuWcOY7OhfnIEHWOyJ906RY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kDskp8rulsc8Hmb0MbYsb8dUbpKHbiwaicLyWdmR9EZ+eoyLOHOuZ5SHfQWgkUa8rzqKsKp/cUTqeAFHBHgAH92JuqOMkbmOj0R2aMKGOY3ZAKuZ7qlaZaP0bo4qfVRDc0WXepIlBqWSCqB3t4LlkdfWxlZS5lp5lMRYJ+1bbCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gImOeSR6; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756258882; x=1787794882;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5q/Ust8foSKyq6WO+ak6JuWcOY7OhfnIEHWOyJ906RY=;
  b=gImOeSR6wThi2SFZIPr6IGS0j0LdgI2J1BGhIpxMOKzrq9DbGMBaw1BB
   E3rwdTPwMV5xJrzJ7ivGdkzaTBJJjgo3dXAXYqsUogJe96ND4L0U50l0d
   0T6T35IKNkmmScaVrYj3K+VkCs/vLCMp6UwkWdYGi1WNtPqm4MWUc5r8b
   O9d8IQCh1YkENeFeuU4pCkhMLFTPFLhvd8G6RZ42wXkn/HU4hTgUKaydh
   t8swewDekCBzgpzBNhN9son4HWoJVAuwI893KDzZkIjXfmVXtaM7NDDyq
   n8YM1591SFVTDiGbA4eJePlHjsLc+hp9N3NVIFEV/5JVFQCZeDPRy2lvz
   A==;
X-CSE-ConnectionGUID: Kl6EsD/NSjmJ0E94dqIFbQ==
X-CSE-MsgGUID: lULzFO8aSB+GlhwhWgeGfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="57709292"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="57709292"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 18:41:21 -0700
X-CSE-ConnectionGUID: 5nRBdw2zStmpM56MDnB8EQ==
X-CSE-MsgGUID: ir69S7cYRvGcocswCgFTJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169631845"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.233.111]) ([10.124.233.111])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 18:41:17 -0700
Message-ID: <3d9b21a7-269e-47ef-99e4-889b19e1dbf0@linux.intel.com>
Date: Wed, 27 Aug 2025 09:41:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: TDX: Force split irqchip for TDX at irqchip
 creation time
To: Sagi Shahar <sagis@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org
References: <20250827011726.2451115-1-sagis@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250827011726.2451115-1-sagis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/27/2025 9:17 AM, Sagi Shahar wrote:
> TDX module protects the EOI-bitmap which prevents the use of in-kernel
> I/O APIC. See more details in the original patch [1]
>
> The current implementation already enforces the use of split irqchip for
> TDX but it does so at the vCPU creation time which is generally to late
to late -> too late

> to fallback to split irqchip.
>
> This patch follows Sean's recomendation from [2] and move the check if
recomendation -> recommendation

Also "move the check ..." needs to be updated, since the check during vCPU
creation is still there.

> I/O APIC is supported for the VM at irqchip creation time.


Some nits above.

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


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
> +
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


