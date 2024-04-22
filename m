Return-Path: <kvm+bounces-15518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 752668AD003
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 16:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12013B21408
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F238315252A;
	Mon, 22 Apr 2024 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d7ijfhJr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B15152190;
	Mon, 22 Apr 2024 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713797850; cv=none; b=q3nPlO1HWu2qNsYmo9/TOKXdR948weIwPJZaOCnt58Ub7xEI6N90+wih77U+ffb8YsX5Ys9iYfsZjCyrKv5XlPy/uCJBTvSrv/EgQHyzklKAKFy2CBSsbgP7ruVhFgYxkOF7aNk+8LCpOAMgdY7qcdMvuoHfqtEwUkFWiAnZwZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713797850; c=relaxed/simple;
	bh=YvcLfVhuM+fUHjKKw8VfVZI423ddk6yCUt2tSKwwS8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXNfLeuuZee6fAODv33pjUHPirq/d10r+VrPAbvScKbR5uyTsflBfA3Dq6O7Mf5v4GUifA+KRMz0hPMlDojzb3y0ct1iSg7c/lYds9M4AuxaBVjqUnZgcCyqEM/6YPx1+78Ci5YGvrAkyJW/1I9KQsKSLFzBVkmHCRPalyw2G6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d7ijfhJr; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713797849; x=1745333849;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YvcLfVhuM+fUHjKKw8VfVZI423ddk6yCUt2tSKwwS8I=;
  b=d7ijfhJrLVX++Dcd0K1PQv04fgdK0yI1BKgG2AaeezOP582bwMaD2qLF
   IjEAsnqoPDzw/rtr1svtsGMaXBMpMtHzi9nyt11FfserD8rQ1JCyD9pKB
   9jbH84cEj8XhjNBpFIt75vU5lsaXslPsDqaJl36+ZWcDyfgTDdQZx6cYP
   NGj8JJz+3yi2GfyXlFmE7wAl/EzaPgUbsPW88FMdl3j+NeD2ui1FBterz
   wHHlZOi2P/7FS9zrQlQhzg54JH1y/wuf0yE7y6QC+52hvpBKbmkmGpMxs
   Wvht1QnZKj+JtdNG3TZNeDPS0XX1vhQHuG/3wgFNzAxE5tAsbeYlooXzy
   Q==;
X-CSE-ConnectionGUID: 1t+V6pQvStS8YmU9csPW+g==
X-CSE-MsgGUID: /yHXD6+LQZmo0MBOpYno5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9460314"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="9460314"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 07:57:29 -0700
X-CSE-ConnectionGUID: +umTZGt+RFSo0lTn3SHPTQ==
X-CSE-MsgGUID: unGuH3jnRLS6TH6s7L8MGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="54975794"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 22 Apr 2024 07:57:27 -0700
Date: Mon, 22 Apr 2024 22:52:07 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com
Subject: Re: [PATCH 11/11] KVM: x86: Add gmem hook for determining max NPT
 mapping level
Message-ID: <ZiZ5l6Czq0JUo2Cn@yilunxu-OptiPlex-7050>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-12-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404185034.3184582-12-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 02:50:33PM -0400, Paolo Bonzini wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
> 
>   - gmem allocates 2MB page
>   - guest issues PVALIDATE on 2MB page
>   - guest later converts a subpage to shared
>   - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>   - KVM MMU splits NPT mapping to 4K
> 
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.

Just curious how the mapping could be promoted back in this case?

Thanks,
Yilun

> 
> Add a hook to determine the max NPT mapping size in situations like
> this.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-Id: <20231230172351.574091-31-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 1 +
>  arch/x86/include/asm/kvm_host.h    | 2 ++
>  arch/x86/kvm/mmu/mmu.c             | 8 ++++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c81990937ab4..2db87a6fd52a 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
>  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>  KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_validate_fault)
>  KVM_X86_OP_OPTIONAL(gmem_invalidate)
>  
>  #undef KVM_X86_OP
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 59c7b95034fc..67dc108dd366 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1811,6 +1811,8 @@ struct kvm_x86_ops {
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
> +				   u8 *max_level);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 992e651540e8..13dd367b8af1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4338,6 +4338,14 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  			       fault->max_level);
>  	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>  
> +	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
> +						     fault->gfn, fault->is_private,
> +						     &fault->max_level);
> +	if (r) {
> +		kvm_release_pfn_clean(fault->pfn);
> +		return r;
> +	}
> +
>  	return RET_PF_CONTINUE;
>  }
>  
> -- 
> 2.43.0
> 
> 

