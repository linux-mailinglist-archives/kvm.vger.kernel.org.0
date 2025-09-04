Return-Path: <kvm+bounces-56809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBA0B436D3
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0988F1C24552
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6832EF64E;
	Thu,  4 Sep 2025 09:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jJAWrYlU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD732EE61B;
	Thu,  4 Sep 2025 09:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756977471; cv=none; b=Vb0vYk0/KkcXnBNuW5XYVBT/PDP/mAI7faUZdu5WAWbqB3EBsje843FIlGB5n2aRbRdFJoQSAVJukJB2UAszjXm8FD/sOHeIUZHu5TRXL56MzWItayKK8ccBbjJoe7BT9mura/mVkgj2+QCdHQFNGDbiPCHY8F0w+yczbQFf/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756977471; c=relaxed/simple;
	bh=AQpqNXGuwdtDJvMAxbZ3xMS7HgIncB27vU0YPQtZs+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZEWmLMuG+bhbetXjAnxAofrF02umkpWAODc1UtHVCsBFMGWmz9y7i1X0e7xfa1YHOFOkwJuHzhf7shzKgxuhiw2oILuNy50Udtnc4RBTpm2liWlmxol819eRK5eahlAC9OX2woB3S08YJSLMWSMTohv3gBx6Xan1IIGh5X9v5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jJAWrYlU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756977469; x=1788513469;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AQpqNXGuwdtDJvMAxbZ3xMS7HgIncB27vU0YPQtZs+Y=;
  b=jJAWrYlUcROxGMOEyX6AOQD+5Z6+bEtfanZ+QVV7b38WVwsINgRe8AuM
   Viu/7usp+I1Zwu0eJ608oMjcwH9n+0OwdAcnsJxgsWkl5jtT3Y2l3kRiO
   O1clQF53S4XSGx/yLRqjFDUVg/pj5Rj/W498NEDckxzhOXvtX86K4RIcm
   2EQ1RZM9TP7VHfqLtfI5Kx01bJOfp10t4Rcvh7u2dPbuHmlrfKsyo2E/P
   OhBX7oe3GgyqdexABmhb97KJIUSjLbBHuao9tZ6+PUofiSCUqqbD1DunM
   Srqteef1y3rU70/iaGxXyulBVQcsg/zuxy9Z2oNlr5EOGR864pNAhmycR
   w==;
X-CSE-ConnectionGUID: urXx3idNQvelscylAL/7zg==
X-CSE-MsgGUID: iDijoNqLSIOZBrKvtGfu2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="84739615"
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="84739615"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:17:49 -0700
X-CSE-ConnectionGUID: HgCpv1rpQl2lZdm5XQX84w==
X-CSE-MsgGUID: YQSugCF4Q0S0qKifcCsgZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="177101826"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:17:43 -0700
Message-ID: <1dccc546-65fc-4a73-9414-132299454985@linux.intel.com>
Date: Thu, 4 Sep 2025 17:17:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used
 in split path
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094604.4762-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094604.4762-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/7/2025 5:46 PM, Yan Zhao wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Preallocate a page to be used in the split_external_spt() path.

Not just "a" page.

>
> Kernel needs one PAMT page pair for external_spt and one that provided
> directly to the TDH.MEM.PAGE.DEMOTE SEAMCALL.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Pulled from
>    git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> - Implemented the flow of topup pamt_page_cache in
>    tdp_mmu_split_huge_pages_root() (Yan)
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/mmu/mmu.c          |  1 +
>   arch/x86/kvm/mmu/tdp_mmu.c      | 51 +++++++++++++++++++++++++++++++++
>   3 files changed, 54 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6b6c46c27390..508b133df903 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1591,6 +1591,8 @@ struct kvm_arch {
>   #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>   	struct kvm_mmu_memory_cache split_desc_cache;
>   
> +	struct kvm_mmu_memory_cache pamt_page_cache;
> +
>   	gfn_t gfn_direct_bits;
>   
>   	/*
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f23d8fc59323..e581cee37f64 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6848,6 +6848,7 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
>   	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
>   	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
>   	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> +	kvm_mmu_free_memory_cache(&kvm->arch.pamt_page_cache);
>   }
>   
>   void kvm_mmu_uninit_vm(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index eb758aaa4374..064c4e823658 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1584,6 +1584,27 @@ static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
>   		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
>   }
>   
> +static bool need_topup_mirror_caches(struct kvm *kvm)
> +{
> +	int nr = tdx_nr_pamt_pages() * 2;
> +
> +	return kvm_mmu_memory_cache_nr_free_objects(&kvm->arch.pamt_page_cache) < nr;
> +}
> +
> +static int topup_mirror_caches(struct kvm *kvm)
> +{
> +	int r, nr;
> +
> +	/* One for external_spt, one for TDH.MEM.PAGE.DEMOTE */

The comment is a bit confusing.
IIUC, external_spt is also for TDH.MEM.PAGE.DEMOTE.
and it's "one pair" for PAMT pages.

> +	nr = tdx_nr_pamt_pages() * 2;
> +
> +	r = kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
> +	if (r)
> +		return r;
> +
> +	return 0;

This could be simplified:
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 064c4e823658..35d052aa408c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1593,16 +1593,12 @@ static bool need_topup_mirror_caches(struct kvm *kvm)

  static int topup_mirror_caches(struct kvm *kvm)
  {
-       int r, nr;
+       int nr;

         /* One for external_spt, one for TDH.MEM.PAGE.DEMOTE */
         nr = tdx_nr_pamt_pages() * 2;

-       r = kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
-       if (r)
-               return r;
-
-       return 0;
+       return kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
  }

> +}
> +
>   static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>   					 struct kvm_mmu_page *root,
>   					 gfn_t start, gfn_t end,
> @@ -1656,6 +1677,36 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>   			continue;
>   		}
>   
> +		if (is_mirror_sp(root) && need_topup_mirror_caches(kvm)) {
> +			int r;
> +
> +			rcu_read_unlock();
> +
> +			if (shared)
> +				read_unlock(&kvm->mmu_lock);
> +			else
> +				write_unlock(&kvm->mmu_lock);
> +
> +			r = topup_mirror_caches(kvm);
> +
> +			if (shared)
> +				read_lock(&kvm->mmu_lock);
> +			else
> +				write_lock(&kvm->mmu_lock);
> +
> +			if (r) {
> +				trace_kvm_mmu_split_huge_page(iter.gfn,
> +							      iter.old_spte,
> +							      iter.level, r);
> +				return r;
> +			}
> +
> +			rcu_read_lock();
> +
> +			iter.yielded = true;
> +			continue;
> +		}
> +
>   		tdp_mmu_init_child_sp(sp, &iter);
>   
>   		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))


