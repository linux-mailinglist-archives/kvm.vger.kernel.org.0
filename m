Return-Path: <kvm+bounces-17293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 235298C3B42
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1BF01F214B0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31CC1465A8;
	Mon, 13 May 2024 06:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AvLkdU1g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A74C81;
	Mon, 13 May 2024 06:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581351; cv=none; b=tdRFRfRYjSeA79IQVel7xuHxxsSE8lWSlNs+Ji5aNvl8NLn3xmSkKAzVd2LSRPh57TLUxZvWN8ArSIj7+odQeLnQ/a/zAS0mC5YAvFBvTcxJrlBhX2TRAgd4nSDvx5R1lA7UCE0/1rNsj4E5rSqOBDapTpZuCm7mKJmtg4YN3/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581351; c=relaxed/simple;
	bh=87G22HmZGVCVhfo0PHdgnl4NiiTRMH623e5Agi35Xos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPr5K0DDuFVndJhU9w+wjVq66+LGGY+mvcX2nkI7IgR09O/hjsPqBRPfWs/lpLwBPzcYVGbhc+nYv8FEz+aLkOOwS0csscEyqdC2ESenHeieRmmR6OAjDEBxFEGBU/Fm4eNAoe/FKPhO5HLyTqTlioionX1AV6eNbXJT0mIlCaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AvLkdU1g; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715581350; x=1747117350;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=87G22HmZGVCVhfo0PHdgnl4NiiTRMH623e5Agi35Xos=;
  b=AvLkdU1gKblylWsGSx0buSrC2Fg3mUWWs0tTsRHNQ2sxhx013Ir6g/ad
   gTy84irY4MzZEH+wkoGVgcQ0h8VP822uIbNrpZygE8rHQcGyFpp86vJ8f
   3vXZwPLvN4EePuzqVhk/t7sIlkPYF5DuvkOQrjPcki6gtIxsscvwiF8wN
   pRP68ssPzodxV5cfcC69e6dxL6TF5HBLfEgb9ilwSUihZFQWMEgu+HHqH
   OWhNARgLlqmWtU/6wCmoyLcirH/Evt2Pw9fbllOOIpBEbDkVCFijMZmyo
   V+5OG8kE6hiWuYVNNuaG0JCPv3puKNxIaGqCikG1fwywD5ymYEu3WxsDw
   w==;
X-CSE-ConnectionGUID: j0A90InURJClhO0CT3QZtw==
X-CSE-MsgGUID: X3JtK90SR2uN2rGZaoqsnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="28988945"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="28988945"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:22:30 -0700
X-CSE-ConnectionGUID: NTCJnoUuQ1WsDbzwHNiJpw==
X-CSE-MsgGUID: etbcJPqQQ62cA71w6DIwOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="34921657"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:22:27 -0700
Message-ID: <0034bc6b-0349-40ea-b56e-a52037e6fe4e@intel.com>
Date: Mon, 13 May 2024 14:22:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/17] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 Michael Roth <michael.roth@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-11-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-11-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
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
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Message-ID: <20240228024147.41573-10-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0d884d0b0f35..ba50b93e93ed 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4317,11 +4317,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   			return RET_PF_EMULATE;
>   	}
>   
> -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> -		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> -		return -EFAULT;
> -	}
> -
>   	if (fault->is_private)
>   		return kvm_faultin_pfn_private(vcpu, fault);
>   
> @@ -4359,9 +4354,24 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   {
>   	int ret;
>   
> +	/*
> +	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
> +	 * change in attributes.  is_page_fault_stale() will detect an
> +	 * invalidation relate to fault->fn and resume the guest without

s/fault->fn/fault->gfn/

> +	 * installing a mapping in the page tables.
> +	 */
>   	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>   	smp_rmb();
>   
> +	/*
> +	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
> +	 * private vs. shared mismatch.
> +	 */
> +	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return -EFAULT;
> +	}
> +
>   	/*
>   	 * Check for a relevant mmu_notifier invalidation event before getting
>   	 * the pfn from the primary MMU, and before acquiring mmu_lock.


