Return-Path: <kvm+bounces-15548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E178AD39F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C4731C20F3E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 18:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD230154431;
	Mon, 22 Apr 2024 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dE1E80tn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F69C153BFB;
	Mon, 22 Apr 2024 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808845; cv=none; b=T8rY4kK/IlV9VyJKy3KydQGmpNUf+zD/nawzt9gMzBNt2/WPVsZvsJBv3xfkPRhT6X/qdR7itj+nrkeevw8HuZrRMubRm1qf8qZmPJfeAOpAOSDJqNM+UM8XD0w2vry7I+R59zyL2USlDE+znogP4o6y4rosRsyfwnxWc0+fNao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808845; c=relaxed/simple;
	bh=2sFZp7KsUWLMadv9vVGXyM+rqaCBHfPIhgyCbSModQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQ6AVSBRAp1R3ksE4KFnepo3x1EHm2XR+hP4iqbLh4LjV6DiymNtCFcE1RGa/UPwiqW1gEPLVEn00kv4fBGIxTXO+3fQuytYL+n+iTQ4xcH7hZctwQNS+qsLxL5lWzLSJUlRJJ9YHcB3KwA1E1FGyL0Hf4SWSmV8/f/5eEV7hvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dE1E80tn; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713808844; x=1745344844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2sFZp7KsUWLMadv9vVGXyM+rqaCBHfPIhgyCbSModQM=;
  b=dE1E80tnE8TTXggHD4NKfwAQRnEzjpqcAnuTLuiB0OcbCUiQJoEgt1l4
   1jZe8aYUTX3FRY8EH+v2tDYebj9UdMU5XF5zMupA0J0h9FHwD+PZsy9T/
   TsXXZ7awrRRe30bxzlPZXKUhdsSO2HJL63+SsSiYqgXxeqAwdh14vkgQx
   G5RDTsTkZuAdzPWtb1u+O2TnjIepTaiuU92tXoaMCrcRfhzhn1FaBd0fA
   pvDiBWxgHFdw2lBbtniwsfPW8y8w7qGjruuy+BbYEqCrwzbF0PSDdxhI7
   GCeFCEuAhcwN4TXv9nWXqARlaNLJb1WPPQspz0Sh38LN4Ka6OihMLFRrF
   w==;
X-CSE-ConnectionGUID: hfFcTe3CSUaI34PU7TojFg==
X-CSE-MsgGUID: +8X8XO5HTYidz2lVTxmFzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9529627"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="9529627"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 11:00:43 -0700
X-CSE-ConnectionGUID: ILyTiQNbTB27HrBws3+ufg==
X-CSE-MsgGUID: 9cPlSe1dQpKbvQXOEJOnyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="24134496"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 11:00:42 -0700
Date: Mon, 22 Apr 2024 11:00:41 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 2/6] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
Message-ID: <20240422180041.GN3596705@ls.amr.corp.intel.com>
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240419085927.3648704-3-pbonzini@redhat.com>

On Fri, Apr 19, 2024 at 04:59:23AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

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
>  include/linux/kvm_host.h |  5 ++++
>  include/uapi/linux/kvm.h | 10 +++++++
>  virt/kvm/Kconfig         |  3 ++
>  virt/kvm/kvm_main.c      | 63 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 81 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8dea11701ab2..9e9943e5e37c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2478,4 +2478,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
>  void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  #endif
>  
> +#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> +long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> +				    struct kvm_pre_fault_memory *range);
> +#endif
> +
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2190adbe3002..917d2964947d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -917,6 +917,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_MEMORY_ATTRIBUTES 233
>  #define KVM_CAP_GUEST_MEMFD 234
>  #define KVM_CAP_VM_TYPES 235
> +#define KVM_CAP_PRE_FAULT_MEMORY 236
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1548,4 +1549,13 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
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
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 754c6c923427..b14e14cdbfb9 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -67,6 +67,9 @@ config HAVE_KVM_INVALID_WAKEUPS
>  config KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         bool
>  
> +config KVM_GENERIC_PRE_FAULT_MEMORY
> +       bool
> +
>  config KVM_COMPAT
>         def_bool y
>         depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 38b498669ef9..51d8dbe7e93b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4379,6 +4379,55 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  	return fd;
>  }
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

To keep future extensively, check the padding are zero.
Or will we be rely on flags?

        if (!memchr_inv(range->padding, 0, sizeof(range->padding)))
                return -EINVAL;
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

