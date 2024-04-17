Return-Path: <kvm+bounces-15002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 598328A8C30
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C4BC1C21959
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 19:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0862D796;
	Wed, 17 Apr 2024 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQzZQJuG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5022324;
	Wed, 17 Apr 2024 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713382589; cv=none; b=ViFmfgyasL4FCLjs6VEFYaMLWrAhjoOjL9XBXMRGKnEHxsQ+dCXbkwRk19KPPji11Rdhx3W1BFPNlmvIVO+6pgiHid28/ASZzyCofHH9Oc5yaq9mppU9oWiLjTqkRQHRHoksxsnG7xvDv8oZZgPUCk5B8YprHRkgAn2EAtzYkKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713382589; c=relaxed/simple;
	bh=kvVn1y6KfWfgNQcXfn8uFTEgaCjkxD574h3q2Fn7MgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8YFcjwpKET3Cdnj76u2idM/40pSXdrQb1yIWGZ1QOnOXgR3JAuC3+P4mhl/GfVD9PQKfD2+i7RRaSPrPEAKX5Aq98VGgzukZxlaY/MjTrhzXeINgn9JDBWvhppbdXy7kGVGp2pT3g9Soqng0pjfGVvxHV2CE3FmF2LB7u+udOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nQzZQJuG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713382586; x=1744918586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kvVn1y6KfWfgNQcXfn8uFTEgaCjkxD574h3q2Fn7MgM=;
  b=nQzZQJuGdRulfJYr+Q251Nog9qj+0Umq01asybYmkhk1lVBEUCJnSf14
   L31NIJva1ittjoXwBmxqPvGeCpNIjUpufBtW6Blh4juA2ElAwiqWjMXDx
   DkKYoBUtdtt3/LMLU5hDjNkPPsfudwqEyp7+eEoi1vJShoPDDy02GzJ+F
   kbuui54yczS3AB9aF91i1bZ3b/WUntfbJJi8EKmQFBK/+uGUlvsYVzQCr
   Dg6G7aQ5eseH3Km7IRl54F6uyMln66QQVvCTVAHr4gmDwhvMwk6w8VbZw
   SkLtgCSTkkjxmMAkmQea/RT2I+xzikL5Lyydh6HD/rQf8ZjNe1NtOOmA7
   A==;
X-CSE-ConnectionGUID: k4Y5YWhqTgOg5rXbDzBzIw==
X-CSE-MsgGUID: yGbLEnAYQdiF5Q+BnKBKPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9052603"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9052603"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 12:36:26 -0700
X-CSE-ConnectionGUID: hs/igHJsSdmri6AeCXUD8A==
X-CSE-MsgGUID: EYMoiSZATZC7TLwDXPKzPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="27396592"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 12:36:25 -0700
Date: Wed, 17 Apr 2024 12:36:25 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 2/7] KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate
 guest memory
Message-ID: <20240417193625.GJ3039520@ls.amr.corp.intel.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
 <20240417153450.3608097-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240417153450.3608097-3-pbonzini@redhat.com>

On Wed, Apr 17, 2024 at 11:34:45AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a new ioctl KVM_MAP_MEMORY in the KVM common code. It iterates on the
> memory range and calls the arch-specific function.  Add stub arch function
> as a weak symbol.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <819322b8f25971f2b9933bfa4506e618508ad782.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h |  5 ++++
>  include/uapi/linux/kvm.h | 10 +++++++
>  virt/kvm/Kconfig         |  3 ++
>  virt/kvm/kvm_main.c      | 61 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 79 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8dea11701ab2..2b0f0240a64c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2478,4 +2478,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
>  void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  #endif
>  
> +#ifdef CONFIG_KVM_GENERIC_MAP_MEMORY
> +int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +			     struct kvm_map_memory *mapping);
> +#endif
> +
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2190adbe3002..4d233f44c613 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -917,6 +917,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_MEMORY_ATTRIBUTES 233
>  #define KVM_CAP_GUEST_MEMFD 234
>  #define KVM_CAP_VM_TYPES 235
> +#define KVM_CAP_MAP_MEMORY 236
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1548,4 +1549,13 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_MAP_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_map_memory)
> +
> +struct kvm_map_memory {
> +	__u64 base_address;
> +	__u64 size;
> +	__u64 flags;
> +	__u64 padding[5];
> +};
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 754c6c923427..1b94126622e8 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -67,6 +67,9 @@ config HAVE_KVM_INVALID_WAKEUPS
>  config KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         bool
>  
> +config KVM_GENERIC_MAP_MEMORY
> +       bool
> +
>  config KVM_COMPAT
>         def_bool y
>         depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 38b498669ef9..350ead98e9a6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4379,6 +4379,47 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  	return fd;
>  }
>  
> +#ifdef CONFIG_KVM_GENERIC_MAP_MEMORY
> +static int kvm_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +			       struct kvm_map_memory *mapping)
> +{
> +	int idx, r;
> +	u64 full_size;
> +
> +	if (mapping->flags)
> +		return -EINVAL;
> +
> +	if (!PAGE_ALIGNED(mapping->base_address) ||
> +	    !PAGE_ALIGNED(mapping->size) ||
> +	    mapping->base_address + mapping->size <= mapping->base_address)
> +		return -EINVAL;
> +
> +	vcpu_load(vcpu);
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	r = 0;
> +	full_size = mapping->size;
> +	while (mapping->size) {
> +		if (signal_pending(current)) {
> +			r = -EINTR;
> +			break;
> +		}
> +
> +		r = kvm_arch_vcpu_map_memory(vcpu, mapping);
> +		if (r)
> +			break;
> +
> +		cond_resched();
> +	}
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	vcpu_put(vcpu);
> +
> +	/* Return success if at least one page was mapped successfully.  */
> +	return full_size == mapping->size ? r : 0;
> +}
> +#endif
> +
>  static long kvm_vcpu_ioctl(struct file *filp,
>  			   unsigned int ioctl, unsigned long arg)
>  {
> @@ -4580,6 +4621,20 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
>  		break;
>  	}
> +#ifdef CONFIG_KVM_GENERIC_MAP_MEMORY
> +	case KVM_MAP_MEMORY: {
> +		struct kvm_map_memory mapping;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&mapping, argp, sizeof(mapping)))
> +			break;
> +		r = kvm_vcpu_map_memory(vcpu, &mapping);
> +		/* Pass back leftover range. */
> +		if (copy_to_user(argp, &mapping, sizeof(mapping)))
> +			r = -EFAULT;
> +		break;
> +	}
> +#endif
>  	default:
>  		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
>  	}
> @@ -4863,6 +4918,12 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #ifdef CONFIG_KVM_PRIVATE_MEM
>  	case KVM_CAP_GUEST_MEMFD:
>  		return !kvm || kvm_arch_has_private_mem(kvm);
> +#endif
> +#ifdef CONFIG_KVM_GENERIC_MAP_MEMORY
> +	case KVM_CAP_MAP_MEMORY:
> +		if (!kvm)
> +			return 1;
> +		/* Leave per-VM implementation to kvm_vm_ioctl_check_extension().  */

nitpick:
                fallthough;

>  #endif
>  	default:
>  		break;
> -- 
> 2.43.0
> 
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

