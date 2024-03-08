Return-Path: <kvm+bounces-11349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D778875D59
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2207FB22471
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 04:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED49E2E642;
	Fri,  8 Mar 2024 04:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FfgQrOcX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9BC2D608;
	Fri,  8 Mar 2024 04:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709873918; cv=none; b=eb7B+wQXuLPVh+H7g4ZJvgQaAMVeX0VB7Wg51n+eONPd+pRzx2sntaHQiJxQClLpp9pe7GrZE20ugMQK1aP6EWHV4idIJosGj+fxMQKLLFMDBtpUKNOrOmOz8rWOqj75KsUWWJ5vImSCEjdUkpcS0QPVtrKEnAUzRzNP7rUTaNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709873918; c=relaxed/simple;
	bh=jy0XW6HpXLjNKng6SUOk46z3P56Zbsjo+182MvNZfNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdWd+2u2kqlRVjQOMUj6+oOTnKRf9krIAxosZ/PeJ78nfK6yKJmqr4xqcexmxTSxdOsF/Kq2R7IvlmZmD0OmsNGg9FR7kALTryzIwEXBYn3eUQ6zJB7PgNrq25tTdVLwKvza90VfLlI9+YtETwrJfM5Awkyq5DVgpJjzUovZlVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FfgQrOcX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709873916; x=1741409916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jy0XW6HpXLjNKng6SUOk46z3P56Zbsjo+182MvNZfNQ=;
  b=FfgQrOcXxMJKfCJC8EBFf2vjhn/q1GqXnsy6QZ05oGtlpZjPK0XqyB6Q
   qYWhGwwOzEUQVrycKb7t5NiKIVOb9FJgII9ON1+sfqFznBWK9BNJE1+UX
   4CIh978wR6+LYW2oKI8MFTqVwLi9gxZNTc9kxsAbBNOSXKL6Hpf1Kuzgu
   faeGsZb5C3uXtRIHOkjhX5JJ+ju1FvmsWgx9Q+cZk2CmNeGiFvbznu9o9
   m7KIx9Z7JizbBPHvPjynR3HS0NY+C/uWJaMEVI/bfFyieJFkymuyS9OQ0
   ONn/HALPK5Ly/u0RRMn8qgrDNXnqc2b1wxCBopCggbSsuaq9ouvFtX1w8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="16013259"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="16013259"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 20:58:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15022427"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 07 Mar 2024 20:58:33 -0800
Date: Fri, 8 Mar 2024 12:54:16 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
Message-ID: <ZeqZ+BDTN5bIx0rm@yilunxu-OptiPlex-7050>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228024147.41573-10-seanjc@google.com>

On Tue, Feb 27, 2024 at 06:41:40PM -0800, Sean Christopherson wrote:
> Prioritize private vs. shared gfn attribute checks above slot validity
> checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> userspace if there is no memslot, but emulate accesses to the APIC access
> page even if the attributes mismatch.
> 
> Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
> Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> Cc: Chao Peng <chao.p.peng@linux.intel.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9206cfa58feb..58c5ae8be66c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4365,11 +4365,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> -		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> -		return -EFAULT;
> -	}
> -
>  	if (fault->is_private)
>  		return kvm_faultin_pfn_private(vcpu, fault);
>  
> @@ -4410,6 +4405,16 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> +	/*
> +	 * Check for a private vs. shared mismatch *after* taking a snapshot of
> +	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
> +	 * invalidation notifier.

I didn't see how mmu_invalidate_seq influences gfn attribute judgement.
And there is no synchronization between the below check and
kvm_vm_set_mem_attributes(), the gfn attribute could still be changing
after the snapshot.  So why this comment?

Thanks,
Yilun

> +	 */
> +	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return -EFAULT;
> +	}
> +
>  	/*
>  	 * Check for a relevant mmu_notifier invalidation event before getting
>  	 * the pfn from the primary MMU, and before acquiring mmu_lock.
> -- 
> 2.44.0.278.ge034bb2e1d-goog
> 
> 

