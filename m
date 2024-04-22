Return-Path: <kvm+bounces-15459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2984B8AC3CE
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAE361F23140
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 05:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8322418633;
	Mon, 22 Apr 2024 05:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hyt8zL4G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46CB1B28D;
	Mon, 22 Apr 2024 05:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713764354; cv=none; b=nMo54oHE9B1AbkJ+ieeFjTxMOEWrh7v3oQOnmysNyHcnVpWRL5KcaC75MquKDINbXB//vR6z0NdYxCobw2FYeZwdVpqzEH48ebTdVtsC1hnI0X70hTx0UCMCwSkC/hwg0lbkkm7d5FdV4u+XuL+mAgl/p1J3tTHnXzwr3VtNK/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713764354; c=relaxed/simple;
	bh=PwRlfmFL0A20Bn/UpcXWftSODIls4zVkTUN+qcIImE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pBsPnZm7l9KUGphyvpML4AlgTpcdeDtNedWhFcgev8LjZyoPSHybiUY1k7s66ZuuPvXJuaAZubkFLkqKL5faVhnDZA5NxEOE7uH2WU3lk/jtqmqkTpZGUXjK9eOlgrcdYsIE3FL948hxQJwGF4PxsfDXyjlf6y+fK2L0nd53XYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hyt8zL4G; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713764352; x=1745300352;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PwRlfmFL0A20Bn/UpcXWftSODIls4zVkTUN+qcIImE0=;
  b=Hyt8zL4GLJhJsJT2T58mJcCu8GXFeMadGnMt4SD6koXj5rcTBKDYOMl1
   K7ug9dCuO06ZgFjZFXXlhdW0x3L9jDUUaHNdKuKfsqjIVxAPsldcVkywZ
   kTKJ/5t4bz1sJaCSngC+C4ipCDba/8qRdHvdm0IH1v/nI1Ta8dEh5Gt7z
   hDqXlSSQe1ClUbRVz89tLncZr2qpmoPGg2AIMb4gmPTooeg228KteetpA
   /b9aVIMLOpOUTVLkUijSS64sdbXfK9ZCWbHbVCG2/qJuF+vcxD9Ec67TD
   oosxUqP6RDORkfdVZuS/YSJmUDfXcs1BNL/GAZARgKp+4eCNFBELCfWC4
   Q==;
X-CSE-ConnectionGUID: l2nIYUqzRQabdv75T6Ky1g==
X-CSE-MsgGUID: 9FAxnZVYTyWffTP+r9gDOg==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="26805473"
X-IronPort-AV: E=Sophos;i="6.07,219,1708416000"; 
   d="scan'208";a="26805473"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2024 22:39:12 -0700
X-CSE-ConnectionGUID: r0gCqIvCTOO0Y8aR6kP6cw==
X-CSE-MsgGUID: xwhOHT8nSMu7a7h+Z3dngQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,219,1708416000"; 
   d="scan'208";a="24348637"
Received: from unknown (HELO [10.238.8.201]) ([10.238.8.201])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2024 22:39:10 -0700
Message-ID: <eb7c7982-2445-4968-892c-c36f5b38fabe@linux.intel.com>
Date: Mon, 22 Apr 2024 13:39:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, seanjc@google.com,
 rick.p.edgecombe@intel.com
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-3-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240419085927.3648704-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a new ioctl KVM_PRE_FAULT_MEMORY in the KVM common code. It iterates on the
> memory range and calls the arch-specific function.  Add stub arch function
> as a weak symbol.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <819322b8f25971f2b9933bfa4506e618508ad782.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   include/linux/kvm_host.h |  5 ++++
>   include/uapi/linux/kvm.h | 10 +++++++
>   virt/kvm/Kconfig         |  3 ++
>   virt/kvm/kvm_main.c      | 63 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 81 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8dea11701ab2..9e9943e5e37c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2478,4 +2478,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
>   void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>   #endif
>   
> +#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> +long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> +				    struct kvm_pre_fault_memory *range);
> +#endif
> +
>   #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2190adbe3002..917d2964947d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -917,6 +917,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_MEMORY_ATTRIBUTES 233
>   #define KVM_CAP_GUEST_MEMFD 234
>   #define KVM_CAP_VM_TYPES 235
> +#define KVM_CAP_PRE_FAULT_MEMORY 236
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
> @@ -1548,4 +1549,13 @@ struct kvm_create_guest_memfd {
>   	__u64 reserved[6];
>   };
>   
> +#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
> +
> +struct kvm_pre_fault_memory {
> +	__u64 gpa;
> +	__u64 size;
> +	__u64 flags;
> +	__u64 padding[5];
> +};
> +
>   #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 754c6c923427..b14e14cdbfb9 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -67,6 +67,9 @@ config HAVE_KVM_INVALID_WAKEUPS
>   config KVM_GENERIC_DIRTYLOG_READ_PROTECT
>          bool
>   
> +config KVM_GENERIC_PRE_FAULT_MEMORY
> +       bool
> +
>   config KVM_COMPAT
>          def_bool y
>          depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 38b498669ef9..51d8dbe7e93b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4379,6 +4379,55 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>   	return fd;
>   }
>   
> +#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> +static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> +				     struct kvm_pre_fault_memory *range)
> +{
> +	int idx;
> +	long r;
> +	u64 full_size;
> +
> +	if (range->flags)
> +		return -EINVAL;
> +
> +	if (!PAGE_ALIGNED(range->gpa) ||
> +	    !PAGE_ALIGNED(range->size) ||
> +	    range->gpa + range->size <= range->gpa)
> +		return -EINVAL;
> +
> +	if (!range->size)
> +		return 0;

range->size equals 0 can be covered by "range->gpa + range->size <= 
range->gpa"

If we want to return success when size is 0 (, though I am not sure it's 
needed),
we need to use "range->gpa + range->size < range->gpa" instead.


> +
> +	vcpu_load(vcpu);
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	full_size = range->size;
> +	do {
> +		if (signal_pending(current)) {
> +			r = -EINTR;
> +			break;
> +		}
> +
> +		r = kvm_arch_vcpu_pre_fault_memory(vcpu, range);
> +		if (r < 0)
> +			break;
> +
> +		if (WARN_ON_ONCE(r == 0))
> +			break;
> +
> +		range->size -= r;
> +		range->gpa += r;
> +		cond_resched();
> +	} while (range->size);
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	vcpu_put(vcpu);
> +
> +	/* Return success if at least one page was mapped successfully.  */
> +	return full_size == range->size ? r : 0;
> +}
> +#endif
> +
>   static long kvm_vcpu_ioctl(struct file *filp,
>   			   unsigned int ioctl, unsigned long arg)
>   {
> @@ -4580,6 +4629,20 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   		r = kvm_vcpu_ioctl_get_stats_fd(vcpu);
>   		break;
>   	}
> +#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> +	case KVM_PRE_FAULT_MEMORY: {
> +		struct kvm_pre_fault_memory range;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&range, argp, sizeof(range)))
> +			break;
> +		r = kvm_vcpu_pre_fault_memory(vcpu, &range);
> +		/* Pass back leftover range. */
> +		if (copy_to_user(argp, &range, sizeof(range)))
> +			r = -EFAULT;
> +		break;
> +	}
> +#endif
>   	default:
>   		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
>   	}


