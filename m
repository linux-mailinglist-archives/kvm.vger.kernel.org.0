Return-Path: <kvm+bounces-23194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C25947788
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 10:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7675BB21723
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 08:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A6B14F9CC;
	Mon,  5 Aug 2024 08:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIa5072W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5353FB3B;
	Mon,  5 Aug 2024 08:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722847489; cv=none; b=TM+KhDA++TG9yM4BCj50MaTo2blEwYXOEZj/VU81Y11zooYfqZe3cLVO4FaDCqeaCgEvoPd6Xza6LlncMgZziJWwSpCooO7VSJoIZwtMMuBq2hiT5QpT9efoZ8Ft8ZeWu8DIZScU54FSV70TEUUyWQZx8jQt+V0ybepHl05iXu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722847489; c=relaxed/simple;
	bh=N79HYclmQON2VhUNIgTSW00mewg34ofoNkg/Ny4Y8No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9tHDjxnD6Hhbtv7nLDHFpQaK/Ta6xeUnnMNbc6odOLMVXavoWA8hIdS6fKgcYDGh0aUtwcgc3ja5qDw1xbWANKdoP8qoPPEEWIaBhAGwoGO6HFf4i+1VdqYKIbhHtYV5aJZ+IdM0gkhOsMg7SqXZ2j4hr0kdmUvTyZmd+aTcso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIa5072W; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722847487; x=1754383487;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N79HYclmQON2VhUNIgTSW00mewg34ofoNkg/Ny4Y8No=;
  b=bIa5072WWQioNDei3es5GlDbX0DsEoyh9Uru88m/zXXN5NFnaxZEjzzm
   85W/lmygoYD74VOsPKX5Z+g72BGSVWLW389UVfXcRSCedGrN7vRpdScKM
   41c6nMLTc0EPaz6b/u9pvEc+w57/PySM+h/QMfXEvQBmvClVvDmNQM086
   SjJYY1wq8MYP2njbeyodpZbj0R1o+PtKlmeBfIbwHQsqWHyznfwCZ8BBi
   IxIHI1avvafnMKnlpMgn4nZBcBuvI96AUL8E+Lpffa4L7dwaV00iwDvWj
   mbB30/YgeCdMWINmmTOSHCJLpBgu5urOjlftjmJ++H3Ksc981Wfufuxm0
   w==;
X-CSE-ConnectionGUID: 7QI0kIX/Tx2T44e1Fwvbjw==
X-CSE-MsgGUID: fdlbQMlRTgGJmG7HAg0raA==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="20938093"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="20938093"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 01:44:47 -0700
X-CSE-ConnectionGUID: TsXedSIpTfiF0e2odHBPIg==
X-CSE-MsgGUID: DPUkaKcDQrmCoapntiX+GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="56041678"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 01:44:45 -0700
Date: Mon, 5 Aug 2024 16:39:47 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: Open code kvm_set_memory_region() into its sole
 caller (ioctl() API)
Message-ID: <ZrCP06W+HrZTb3tr@linux.bj.intel.com>
References: <20240802205003.353672-1-seanjc@google.com>
 <20240802205003.353672-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802205003.353672-2-seanjc@google.com>

On Fri, Aug 02, 2024 at 01:49:58PM -0700, Sean Christopherson wrote:
> Open code kvm_set_memory_region() into its sole caller in preparation for
> adding a dedicated API for setting internal memslots.
> 
> Oppurtunistically use the fancy new guard(mutex) to avoid a local 'r'
> variable.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h |  2 --
>  virt/kvm/kvm_main.c      | 15 ++-------------
>  2 files changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 689e8be873a7..b341d00aae37 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1179,8 +1179,6 @@ enum kvm_mr_change {
>  	KVM_MR_FLAGS_ONLY,
>  };
>  
> -int kvm_set_memory_region(struct kvm *kvm,
> -			  const struct kvm_userspace_memory_region2 *mem);
>  int __kvm_set_memory_region(struct kvm *kvm,
>  			    const struct kvm_userspace_memory_region2 *mem);
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..0557d663b69b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2105,25 +2105,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  }
>  EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
>  
> -int kvm_set_memory_region(struct kvm *kvm,
> -			  const struct kvm_userspace_memory_region2 *mem)
> -{
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -	r = __kvm_set_memory_region(kvm, mem);
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> -}
> -EXPORT_SYMBOL_GPL(kvm_set_memory_region);
> -
>  static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
>  					  struct kvm_userspace_memory_region2 *mem)
>  {
>  	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
>  		return -EINVAL;
>  
> -	return kvm_set_memory_region(kvm, mem);
> +	guard(mutex)(&kvm->slots_lock);
> +	return  __kvm_set_memory_region(kvm, mem);
              ^^
Two spaces are introduced here.

>  }
>  
>  #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -- 
> 2.46.0.rc2.264.g509ed76dc8-goog
> 
> 

