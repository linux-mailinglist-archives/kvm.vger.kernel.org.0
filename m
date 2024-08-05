Return-Path: <kvm+bounces-23196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D23DD94778C
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 10:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DC5C2821FC
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 08:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0F414F104;
	Mon,  5 Aug 2024 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFqSEo71"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8F533CA;
	Mon,  5 Aug 2024 08:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722847654; cv=none; b=TdRA8HnnAdis3aTJLrpJWlByA/nj4s3Io8qJV1M/v0cCyRLdraZ2oJ/i+l/nY5YOTsa8opzgxXO6Bn7ketVeuE9UXHUiO7ss3Angy5ucEHaAOwrrqEFZLfsg8klwwDBJ8KxQPrS0apl+KcaSfB1nlzXgLI83IPJXKMuankQXzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722847654; c=relaxed/simple;
	bh=BPmqEJarNiagqJThZ8ITSkvXl/Gofr6X6Mee23Lzj5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+iTFcnhFhXNIs+Ao++8M4HP3otaGIEjYg3Xs05/TyjuA/08pwf3fW+pvClCbcs8tYgng42eWYi273FjA1DoTv3KkLyMnnSLAlJC0FfSD68cr6sKqi9QEN7hctruJCWkKQO+kGn9A7+sxeOM8VmEKeSNg0hBSSdf8sTAQg0SSMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFqSEo71; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722847653; x=1754383653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BPmqEJarNiagqJThZ8ITSkvXl/Gofr6X6Mee23Lzj5M=;
  b=lFqSEo71C0/+YsqMAXZi/bA3MZ/ogEpmnat2B6LkYQP4jVQKjFgkrRYo
   XWB5GR2qcua/7Ced66Nt85csXbvCUQBT+ZACTm03wQvNdDKGxnbtqCs4x
   2oel3D12hO3lMzErno/J32c8VB/PayY8yP7h5NIFEW7xJTDFkIro7dq7l
   28l+bNodp5mmRO3mRFEBl1yKOYsw5yneXALE1N4XYYcWkucBdos9MIsCb
   hUvBmPEmAY+aIMxEs9x4xOWiNlzDco+8lWwJSxENfq7eUOPNMDDwMEzBY
   S8H1GHY3dk0hvdJ5JbekioUMIT3ITWDPnaYqdJpvM+DbdQRBQpg7f4MZZ
   w==;
X-CSE-ConnectionGUID: Ep4gam/YSriorU/eA7wYmA==
X-CSE-MsgGUID: 3F+50hi8R5iGPu4rQH922Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="31453257"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="31453257"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 01:47:32 -0700
X-CSE-ConnectionGUID: Aqa6p/lpRA6Y8oFnIMbzqA==
X-CSE-MsgGUID: tKPaBfNhSuicTlDdnZcgLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="79371481"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 01:47:31 -0700
Date: Mon, 5 Aug 2024 16:42:37 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] KVM: Add a dedicated API for setting KVM-internal
 memslots
Message-ID: <ZrCQffKMMuvuYQT9@linux.bj.intel.com>
References: <20240802205003.353672-1-seanjc@google.com>
 <20240802205003.353672-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802205003.353672-4-seanjc@google.com>

On Fri, Aug 02, 2024 at 01:50:00PM -0700, Sean Christopherson wrote:
> Add a dedicated API for setting internal memslots, and have it explicitly
> disallow setting userspace memslots.  Setting a userspace memslots without
> a direct command from userspace would result in all manner of issues.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h |  4 ++--
>  virt/kvm/kvm_main.c      | 15 ++++++++++++---
>  3 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index af6c8cf6a37a..77949fee13f7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12794,7 +12794,7 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
>  		m.guest_phys_addr = gpa;
>  		m.userspace_addr = hva;
>  		m.memory_size = size;
> -		r = __kvm_set_memory_region(kvm, &m);
> +		r = kvm_set_internal_memslot(kvm, &m);
>  		if (r < 0)
>  			return ERR_PTR_USR(r);
>  	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b341d00aae37..cefa274c0852 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1179,8 +1179,8 @@ enum kvm_mr_change {
>  	KVM_MR_FLAGS_ONLY,
>  };
>  
> -int __kvm_set_memory_region(struct kvm *kvm,
> -			    const struct kvm_userspace_memory_region2 *mem);
> +int kvm_set_internal_memslot(struct kvm *kvm,
> +			     const struct kvm_userspace_memory_region2 *mem);
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
>  void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f202bdbfca9e..63b43644ed9f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1973,8 +1973,8 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
>  	return false;
>  }
>  
> -int __kvm_set_memory_region(struct kvm *kvm,
> -			    const struct kvm_userspace_memory_region2 *mem)
> +static int __kvm_set_memory_region(struct kvm *kvm,
> +				   const struct kvm_userspace_memory_region2 *mem)
>  {
>  	struct kvm_memory_slot *old, *new;
>  	struct kvm_memslots *slots;
> @@ -2097,7 +2097,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	kfree(new);
>  	return r;
>  }
> -EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
> +
> +int kvm_set_internal_memslot(struct kvm *kvm,
> +			     const struct kvm_userspace_memory_region2 *mem)
> +{
> +	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
> +		return -EINVAL;
> +
> +	return  __kvm_set_memory_region(kvm, mem);
              ^^
Two spaces are introduced here.

> +}
> +EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
>  
>  static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
>  					  struct kvm_userspace_memory_region2 *mem)
> -- 
> 2.46.0.rc2.264.g509ed76dc8-goog
> 
> 

