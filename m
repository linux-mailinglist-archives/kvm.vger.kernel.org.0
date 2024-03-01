Return-Path: <kvm+bounces-10655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9F386E515
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FB071C21073
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 16:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A304A70CCF;
	Fri,  1 Mar 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eb5vjprR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300F470030;
	Fri,  1 Mar 2024 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709309783; cv=none; b=qiL7s6pUw1/QP2qiBtZ12epSOcE0xS7IhGJFhBplnfxRShmpwQnkHG+6ntxvOzwx2GCeiuwAcSiPU8tZNxiRE1CEWb1OFN/8SXvqHA0kO8FDOF1a189jbmxKucZTnHCv8LEMySGcGFXsw35yzEurqe0oB3uwNcyXQeaic4sVzzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709309783; c=relaxed/simple;
	bh=n5S1ol70AH6Wm/4ovXpBDCp9DIz877B8wVkhQTych20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bq+fIKYbg+dIkP3XUe60PNBU64HMlOOLIozfxnlBBpv95BA6EqiOHvmU8Gu8tnBkrPp+dc+zpu/losaJULpiEFYqNBJn7Xn6rYQa2nPbWkDtF2mrwYf8qydA2MV10bS5HteM+hrZWWOMexSbf59VA92e/dVcIzZLh30r6p1Bibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eb5vjprR; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709309782; x=1740845782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n5S1ol70AH6Wm/4ovXpBDCp9DIz877B8wVkhQTych20=;
  b=eb5vjprROUiMqyYd33y2SA5JQGTxR2eo7dA6FSBuvJRZTVa+N5txQlL5
   VQnDzHlmgWy4GFbVocOQtlqCcce35Bsddi4wYWxHtDCmqfv3ZeZehM3LW
   XwthZJ7gqCNuYmyjKDNU159ercZ1p0r5DhRA9OKDIF/j0t88kvXztvE4W
   1LrYUAJheFWklEuuA341hyHloNMUiEQvIHADhKtuG4acK54sC1/EyxsY2
   jX6EW4vchsWkdQ58QmzgX6+kL2rGNT6UbaNydPeyOMtxPddtDgD38EMny
   PVKD8Xuy/xJDu/sVqqVaJ0D0ZsgbjdfNaQo4yF8/atezKg+1YlNPV1bBE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="15264465"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="15264465"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 08:16:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12790536"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 08:16:18 -0800
Date: Sat, 2 Mar 2024 00:13:24 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] kvm: wire up KVM_CAP_VM_GPA_BITS for x86
Message-ID: <ZeH+pPO7hhgDNujs@linux.bj.intel.com>
References: <20240301101410.356007-1-kraxel@redhat.com>
 <20240301101410.356007-2-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301101410.356007-2-kraxel@redhat.com>

On Fri, Mar 01, 2024 at 11:14:07AM +0100, Gerd Hoffmann wrote:
> Add new guest_phys_bits field to kvm_caps, return the value to
> userspace when asked for KVM_CAP_VM_GPA_BITS capability.
> 
> Initialize guest_phys_bits with boot_cpu_data.x86_phys_bits.
> Vendor modules (i.e. vmx and svm) can adjust this field in case
> additional restrictions apply, for example in case EPT has no
> support for 5-level paging.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/kvm/x86.h | 2 ++
>  arch/x86/kvm/x86.c | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..e03aec3527f8 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -24,6 +24,8 @@ struct kvm_caps {
>  	bool has_bus_lock_exit;
>  	/* notify VM exit supported? */
>  	bool has_notify_vmexit;
> +	/* usable guest phys bits */
> +	u32  guest_phys_bits;
>  
>  	u64 supported_mce_cap;
>  	u64 supported_xcr0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 48a61d283406..e270b9b708d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4784,6 +4784,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
>  			r |= BIT(KVM_X86_SW_PROTECTED_VM);
>  		break;
> +	case KVM_CAP_VM_GPA_BITS:
> +		r = kvm_caps.guest_phys_bits;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -9706,6 +9709,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>  		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
>  
> +	kvm_caps.guest_phys_bits = boot_cpu_data.x86_phys_bits;

When KeyID_bits is non-zero, MAXPHYADDR != boot_cpu_data.x86_phys_bits
here, you can check in detect_tme().

Thanks,
Tao

> +
>  	r = ops->hardware_setup();
>  	if (r != 0)
>  		goto out_mmu_exit;
> -- 
> 2.44.0
> 
> 

