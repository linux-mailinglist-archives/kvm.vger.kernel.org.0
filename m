Return-Path: <kvm+bounces-7290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAD783F5BC
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 15:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5678B21FB2
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 14:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D5224208;
	Sun, 28 Jan 2024 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7Kp+V/H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCAC2376C;
	Sun, 28 Jan 2024 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706451143; cv=none; b=IlOfJGEZ6WMMp7yPCB9KYeEFy+pUHkuF87kxaQbyuTPHF64dj6TvtNS1e4Y8yicdf9wdvKPPwCxARt8iJ3x9qGjKK+IqDfx7hktnx2OGWTPBpnDvdw3zlraOMVdiF2lVPRgwiw762CgV/jZKRNLMY7I9+XJPjZEy4ZUHnMftTVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706451143; c=relaxed/simple;
	bh=PscjwXaV7X6sbLlYnE5Vyfx2zMsk7ANyms1ABld3+MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h1+ScO193giRIS2KE9tUr5UmXpDWEkQWnqKhAZHGLU3Zr597f/3rxdRC0FhngQK6BPzP4bKfYKWLsVNJhsDz3KzMfv1v+/Z8DqWLBT0DA5OZTkj1NKEYvgLS/4/IrT45fQqU3bxpW79ebpEraT0eIFTBmH3xbITiF3951370z08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7Kp+V/H; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706451142; x=1737987142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PscjwXaV7X6sbLlYnE5Vyfx2zMsk7ANyms1ABld3+MQ=;
  b=i7Kp+V/HZiLRDjDem8f7tC94GKbniX5nZOE+M3kBUVf2uyJ3zpl0F0r/
   8kI+J8b+Sq21Ec2xfXZAZwMaIvos5FhSrMicaOpRLL4WlH9cql2BVEW9p
   E6ucPW/M+0IJJyVF1D5nW85NIbZqaRJCEAJ50xsm3l5L3K9dJeysOO0mN
   aAgKwa9rfZglCvIZLwnd4hESuSxtoIDEvrgj7f1ykwrdXDCTJBBFg6/da
   nLu7pkPqGrx/MBO+kX5jS9VzrII8Pgcqmfmg6oJxsidsgS8fI7rhiAPR3
   s16CVh4d4IwTEQ1ptF9efaJvbfzetlYAIeSNxxLGajxEQxym93dhkHpsA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="10162187"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="10162187"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 06:12:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="1118697076"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="1118697076"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 06:12:15 -0800
Message-ID: <0f1dda5e-dd70-44b9-afd0-90a54abc086b@linux.intel.com>
Date: Sun, 28 Jan 2024 22:12:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 041/121] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <d99863c474b8a3d9e413fbf940bf6891d2ce319e.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d99863c474b8a3d9e413fbf940bf6891d2ce319e.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX requires special handling to support large private page.  For
> simplicity, only support 4K page for TD guest for now.  Add per-VM maximum
> page level support to support different maximum page sizes for TD guest and
> conventional VMX guest.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/mmu/mmu.c          | 2 ++
>   arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>   3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 430d7bd7c37c..313519edd79e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1283,6 +1283,7 @@ struct kvm_arch {
>   	unsigned long n_requested_mmu_pages;
>   	unsigned long n_max_mmu_pages;
>   	unsigned int indirect_shadow_pages;
> +	int tdp_max_page_level;

Although only TDX need special handling for now, and TDX always use TDP,
but it doesn't necessarily to be TDP, right?
When the value is assigned to kvm_page_fault.max_level, it is also used for
non-TDP code path.

>   	u8 mmu_valid_gen;
>   	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>   	struct list_head active_mmu_pages;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 54d4c8f1ba68..e93bc16a5e9b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6307,6 +6307,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>   
>   	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
>   	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> +
> +	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
>   }
>   
>   static void mmu_free_vm_memory_caches(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0443bfcf5d9c..2b9377442927 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -296,7 +296,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		.nx_huge_page_workaround_enabled =
>   			is_nx_huge_page_enabled(vcpu->kvm),
>   
> -		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +		.max_level = vcpu->kvm->arch.tdp_max_page_level,
>   		.req_level = PG_LEVEL_4K,
>   		.goal_level = PG_LEVEL_4K,
>   	};


