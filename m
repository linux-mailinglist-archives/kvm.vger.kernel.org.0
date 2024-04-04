Return-Path: <kvm+bounces-13615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE47389908E
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4737A1F23589
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 21:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485C013C3CD;
	Thu,  4 Apr 2024 21:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e8m52NW4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B69713BACF;
	Thu,  4 Apr 2024 21:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712266784; cv=none; b=KGB+TdRynkDRmoFoTYkUCDkFHjNJksh8onLsp6sIAijqqp5eQ/pK7orKwaJ8814MhMDHRorqWRZbZaAH8VUY3DikVunTFnjw15l+5QhsUYZRfiEobWFvwZYHxzayrQSGuGkV/peVnNFqgP5iNJRL17SGk7q9+IHLJUJPGLVYEyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712266784; c=relaxed/simple;
	bh=+RDi3890WN6/xHKRrz0pY9T74zCJtVb0ZaeOjy5zz0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OonmEuFHfl6GpG15rxW76RowydewH8sDePoWRvmU/NtMBy922sh/qVIkHPEwEa+tet4JlSOu/JeKtckGSxq4GYut7IYTU5WSNqjvFEaR0fT+/IWvbUyegj2o4REmOpufqmG2A18SA2nNTi/xv/Hu+czZGdYzMYpga5y776y/L5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e8m52NW4; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712266782; x=1743802782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+RDi3890WN6/xHKRrz0pY9T74zCJtVb0ZaeOjy5zz0o=;
  b=e8m52NW4rIE3TDrNY2bZ7VaZxq3dYkEIuJDqYVv7fX2oo6H6UkYnxXZ2
   fVv9c9E/tMmTkhLmUvteHTagvkuAoZcBLtZszfmocgJlJCO8xnkEpx7LL
   eex1Sk2faTyZqmZ7Nlenjss8vVSydMy+6c0LiVcMFT0njmp9wF/ka3t5z
   1KY1t6+nYyFi0s8qoEa6IS67yL1YDtYS0+EC2cNSJFUWoVELVXW5kdu2W
   v23vQqoF3eo0AdwyXG79ZpgA/otsdq4/DsIRLnvX2nHhH9i1Fu8H0gWoJ
   9Ak/kHofmOVYDIwxeDc5pzhBgfYWfJKlBQrMJMzoUNCKWa9/dbg1FtS24
   g==;
X-CSE-ConnectionGUID: xvPzlsurSneH7NDPhrvZSg==
X-CSE-MsgGUID: V7btD0Y2Tr60GcxiKjUkpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="30050126"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="30050126"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:39:41 -0700
X-CSE-ConnectionGUID: Ie3c6ESYQSSJXt9GBKTHzg==
X-CSE-MsgGUID: 3kv7MuKwS/uKhk6idibTSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="23668909"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:39:41 -0700
Date: Thu, 4 Apr 2024 14:39:41 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
	isaku.yamahata@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Message-ID: <20240404213941.GS2444378@ls.amr.corp.intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
 <20240404121327.3107131-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240404121327.3107131-8-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 08:13:17AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Some VM types have characteristics in common; in fact, the only use
> of VM types right now is kvm_arch_has_private_mem and it assumes that
> _all_ nonzero VM types have private memory.
> 
> We will soon introduce a VM type for SEV and SEV-ES VMs, and at that
> point we will have two special characteristics of confidential VMs
> that depend on the VM type: not just if memory is private, but
> also whether guest state is protected.  For the latter we have
> kvm->arch.guest_state_protected, which is only set on a fully initialized
> VM.
> 
> For VM types with protected guest state, we can actually fix a problem in
> the SEV-ES implementation, where ioctls to set registers do not cause an
> error even if the VM has been initialized and the guest state encrypted.
> Make sure that when using VM types that will become an error.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 ++-
>  arch/x86/kvm/x86.c              | 93 ++++++++++++++++++++++++++-------
>  2 files changed, 79 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 04c430eb25cf..3d56b5bb10e9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1279,12 +1279,14 @@ enum kvm_apicv_inhibit {
>  };
>  
>  struct kvm_arch {
> -	unsigned long vm_type;
>  	unsigned long n_used_mmu_pages;
>  	unsigned long n_requested_mmu_pages;
>  	unsigned long n_max_mmu_pages;
>  	unsigned int indirect_shadow_pages;
>  	u8 mmu_valid_gen;
> +	u8 vm_type;
> +	bool has_private_mem;
> +	bool has_protected_state;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>  	struct list_head active_mmu_pages;
>  	struct list_head zapped_obsolete_pages;
> @@ -2153,8 +2155,9 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  		       int tdp_max_root_level, int tdp_huge_page_level);
>  
> +
>  #ifdef CONFIG_KVM_PRIVATE_MEM
> -#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.vm_type != KVM_X86_DEFAULT_VM)
> +#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #else
>  #define kvm_arch_has_private_mem(kvm) false
>  #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3934e7682734..d4a8d896798f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5555,11 +5555,15 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> -					     struct kvm_debugregs *dbgregs)
> +static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> +					    struct kvm_debugregs *dbgregs)
>  {
>  	unsigned int i;
>  
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	memset(dbgregs, 0, sizeof(*dbgregs));
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
> @@ -5568,6 +5572,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  
>  	dbgregs->dr6 = vcpu->arch.dr6;
>  	dbgregs->dr7 = vcpu->arch.dr7;
> +	return 0;
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> @@ -5575,6 +5580,10 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  {
>  	unsigned int i;
>  
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	if (dbgregs->flags)
>  		return -EINVAL;
>  
> @@ -5595,8 +5604,8 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  }
>  
>  
> -static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> -					  u8 *state, unsigned int size)
> +static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
> +					 u8 *state, unsigned int size)
>  {
>  	/*
>  	 * Only copy state for features that are enabled for the guest.  The
> @@ -5614,24 +5623,25 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
>  			     XFEATURE_MASK_FPSSE;
>  
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> -		return;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  
>  	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
>  				       supported_xcr0, vcpu->arch.pkru);
> +	return 0;
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> -					 struct kvm_xsave *guest_xsave)
> +static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
> +					struct kvm_xsave *guest_xsave)
>  {
> -	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> -				      sizeof(guest_xsave->region));
> +	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
> +					     sizeof(guest_xsave->region));
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  					struct kvm_xsave *guest_xsave)
>  {
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> -		return 0;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  
>  	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
>  					      guest_xsave->region,
> @@ -5639,18 +5649,23 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  					      &vcpu->arch.pkru);
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
> -					struct kvm_xcrs *guest_xcrs)
> +static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
> +				       struct kvm_xcrs *guest_xcrs)
>  {
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
>  		guest_xcrs->nr_xcrs = 0;
> -		return;
> +		return 0;
>  	}
>  
>  	guest_xcrs->nr_xcrs = 1;
>  	guest_xcrs->flags = 0;
>  	guest_xcrs->xcrs[0].xcr = XCR_XFEATURE_ENABLED_MASK;
>  	guest_xcrs->xcrs[0].value = vcpu->arch.xcr0;
> +	return 0;
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
> @@ -5658,6 +5673,10 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
>  {
>  	int i, r = 0;
>  
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	if (!boot_cpu_has(X86_FEATURE_XSAVE))
>  		return -EINVAL;
>  
> @@ -6040,7 +6059,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_GET_DEBUGREGS: {
>  		struct kvm_debugregs dbgregs;
>  
> -		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> +		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> +		if (r < 0)
> +			break;
>  
>  		r = -EFAULT;
>  		if (copy_to_user(argp, &dbgregs,
> @@ -6070,7 +6091,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		if (!u.xsave)
>  			break;
>  
> -		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
> +		r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
> +		if (r < 0)
> +			break;
>  
>  		r = -EFAULT;
>  		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
> @@ -6099,7 +6122,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		if (!u.xsave)
>  			break;
>  
> -		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
> +		r = kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
> +		if (r < 0)
> +			break;
>  
>  		r = -EFAULT;
>  		if (copy_to_user(argp, u.xsave, size))
> @@ -6115,7 +6140,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		if (!u.xcrs)
>  			break;
>  
> -		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
> +		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
> +		if (r < 0)
> +			break;
>  
>  		r = -EFAULT;
>  		if (copy_to_user(argp, u.xcrs,
> @@ -6259,6 +6286,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	}
>  #endif
>  	case KVM_GET_SREGS2: {
> +		r = -EINVAL;
> +		if (vcpu->kvm->arch.has_protected_state &&
> +		    vcpu->arch.guest_state_protected)
> +			goto out;
> +
>  		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL);
>  		r = -ENOMEM;
>  		if (!u.sregs2)
> @@ -6271,6 +6303,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		break;
>  	}
>  	case KVM_SET_SREGS2: {
> +		r = -EINVAL;
> +		if (vcpu->kvm->arch.has_protected_state &&
> +		    vcpu->arch.guest_state_protected)
> +			goto out;
> +
>  		u.sregs2 = memdup_user(argp, sizeof(struct kvm_sregs2));
>  		if (IS_ERR(u.sregs2)) {
>  			r = PTR_ERR(u.sregs2);
> @@ -11478,6 +11515,10 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  
>  int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  {
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	vcpu_load(vcpu);
>  	__get_regs(vcpu, regs);
>  	vcpu_put(vcpu);
> @@ -11519,6 +11560,10 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  
>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  {
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	vcpu_load(vcpu);
>  	__set_regs(vcpu, regs);
>  	vcpu_put(vcpu);
> @@ -11591,6 +11636,10 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
>  int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>  				  struct kvm_sregs *sregs)
>  {
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	vcpu_load(vcpu);
>  	__get_sregs(vcpu, sregs);
>  	vcpu_put(vcpu);
> @@ -11858,6 +11907,10 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  {
>  	int ret;
>  
> +	if (vcpu->kvm->arch.has_protected_state &&
> +	    vcpu->arch.guest_state_protected)
> +		return -EINVAL;
> +
>  	vcpu_load(vcpu);
>  	ret = __set_sregs(vcpu, sregs);
>  	vcpu_put(vcpu);
> @@ -11975,7 +12028,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  	struct fxregs_state *fxsave;
>  
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> -		return 0;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  
>  	vcpu_load(vcpu);
>  
> @@ -11998,7 +12051,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  	struct fxregs_state *fxsave;
>  
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
> -		return 0;
> +		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
>  
>  	vcpu_load(vcpu);
>  
> @@ -12524,6 +12577,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  		return -EINVAL;
>  
>  	kvm->arch.vm_type = type;
> +	kvm->arch.has_private_mem =
> +		(type == KVM_X86_SW_PROTECTED_VM);
>  
>  	ret = kvm_page_track_init(kvm);
>  	if (ret)
> -- 
> 2.43.0

This works well with TDX KVM patch series.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

