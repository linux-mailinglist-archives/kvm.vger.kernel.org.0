Return-Path: <kvm+bounces-56671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 641CEB415AF
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F29D547881
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11312D8DDA;
	Wed,  3 Sep 2025 06:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NaVn8QUr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9D04F5E0;
	Wed,  3 Sep 2025 06:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882638; cv=none; b=Skj6kHHRG5MLpPr/VMGz+f3NprBEUswHucIjpe9rNOUS8DJvec1R0R55wHl6d1FfoR2kWJbzTIByrCrGZWH+XfiOBoztjHIpUlcqaeSq+OB7sBYQuNNdpgPkrbB4BOzJ6N1NBqMuyYpLUSuGh049Ym1DRt82H1BbSJkyF2yyJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882638; c=relaxed/simple;
	bh=eowqacLwOBP8ZovJRY/OfNzgE9zhES1gAvD8OKkcrtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MOk6Om0jpZBr0usRFp8pvH8tQf+1um4Nf69fZ8Hy1TsUceJ+ZPs9/Ku+OIXaHqvC4ZCJdyUZuWlkJwsWTeplsLXAsX96nf+5a1Z9mFQAeBL533qyRoZrdbJpmbjJ4RtqRa5bO3MAbyFb2I4tQCxmr48ShpmQuaJ354ZoOCcnYGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NaVn8QUr; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882637; x=1788418637;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eowqacLwOBP8ZovJRY/OfNzgE9zhES1gAvD8OKkcrtY=;
  b=NaVn8QUrWsY0kn8dyrJWy1ykZkN8AZsL5rv8ETZqb4WIYzOokdYwxRem
   CGqXRl/Ppa9C6mI/e4vwrXgKn0KMGd5MXki7nwRQfYi2azjAj1yIK5OUC
   qLl5xlZ64LOMOISeyIOYrCtLtIUlUhrwpIoCwrdzmjymyneeXNn+3Apw9
   yAVawZi3tKFL6xRQMNZkTDvgdvDGWwGpRvJNpx0LrzhgWXpQVWuJhViVE
   YQKicRJ3STtrsYbd2MSbfG+MOVUWzLZxLxwr/wLGx2Of38pIr/Luoew8D
   eYCD0EOdikS0lExM2coPOlsJnq3h7QJ9+0/bqLntgepbi21REUxVEVhjb
   Q==;
X-CSE-ConnectionGUID: 3Sn64sskQAi01n3bS8ZXNQ==
X-CSE-MsgGUID: nwn6npJCQVKdqbJPFGLTAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="69886570"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="69886570"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:57:16 -0700
X-CSE-ConnectionGUID: TTpo1gpeRfelzkKSl9lc3A==
X-CSE-MsgGUID: iVhNIXw/TDeBDNqfN98aRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="175873851"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:57:10 -0700
Message-ID: <ac774797-f82c-4717-9c40-8602e799e966@linux.intel.com>
Date: Wed, 3 Sep 2025 14:57:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
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
 <20250807094358.4607-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094358.4607-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:43 PM, Yan Zhao wrote:
> Introduce kvm_split_cross_boundary_leafs() to split huge leaf entries that
> cross the boundary of a specified range.
>
> Splitting huge leaf entries that cross the boundary is essential before
> zapping the range in the mirror root. This ensures that the subsequent zap
> operation does not affect any GFNs outside the specified range. This is
> crucial for the mirror root, as the private page table requires the guest's
> ACCEPT operation after a GFN faults back.
>
> The core of kvm_split_cross_boundary_leafs() leverages the main logic from
> tdp_mmu_split_huge_pages_root(). It traverses the specified root and splits
> huge leaf entries if they cross the range boundary. When splitting is
> necessary, kvm->mmu_lock is temporarily released for memory allocation,
> which means returning -ENOMEM is possible.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Rename the API to kvm_split_cross_boundary_leafs().
> - Make the API to be usable for direct roots or under shared mmu_lock.
> - Leverage the main logic from tdp_mmu_split_huge_pages_root(). (Rick)
>
> RFC v1:
> - Split patch.
> - introduced API kvm_split_boundary_leafs(), refined the logic and
>    simplified the code.
> ---
>   arch/x86/kvm/mmu/mmu.c     | 27 +++++++++++++++
>   arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
>   include/linux/kvm_host.h   |  2 ++
>   4 files changed, 97 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9182192daa3a..13910ae05f76 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1647,6 +1647,33 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
>   				 start, end - 1, can_yield, true, flush);
>   }
>   
> +/*
> + * Split large leafs crossing the boundary of the specified range
> + *
> + * Return value:
> + * 0 : success, no flush is required;
> + * 1 : success, flush is required;
> + * <0: failure.
> + */
> +int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
> +				   bool shared)
> +{
> +	bool ret = 0;
> +
> +	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> +			    lockdep_is_held(&kvm->slots_lock) ||
> +			    srcu_read_lock_held(&kvm->srcu));
> +
> +	if (!range->may_block)
> +		return -EOPNOTSUPP;
> +
> +	if (tdp_mmu_enabled)
> +		ret = kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(kvm, range, shared);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_split_cross_boundary_leafs);
> +
>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
>   	bool flush = false;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ce49cc850ed5..62a09a9655c3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1574,10 +1574,17 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>   	return ret;
>   }
>   
> +static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
> +{
> +	return !(iter->gfn >= start &&
> +		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
> +}
> +
>   static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>   					 struct kvm_mmu_page *root,
>   					 gfn_t start, gfn_t end,
> -					 int target_level, bool shared)
> +					 int target_level, bool shared,
> +					 bool only_cross_bounday, bool *flush)
s/only_cross_bounday/only_cross_boundary

>   {
>   	struct kvm_mmu_page *sp = NULL;
>   	struct tdp_iter iter;
> @@ -1589,6 +1596,13 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>   	 * level into one lower level. For example, if we encounter a 1GB page
>   	 * we split it into 512 2MB pages.
>   	 *
> +	 * When only_cross_bounday is true, just split huge pages above the
> +	 * target level into one lower level if the huge pages cross the start
> +	 * or end boundary.
> +	 *
> +	 * No need to update @flush for !only_cross_bounday cases, which rely
> +	 * on the callers to do the TLB flush in the end.

I think API wise, it's a bit confusing, although it's a local API.
If just look at the API without digging into the function implementation, my
initial thought is *flush will tell whether TLB flush is needed or not.

Just update *flush unconditionally? Or move the comment as the description for
the function to call it out?

I have thought another option to combine the two inputs, i.e., if *flush is a
valid pointer, it means it's for only_cross_boundary. Otherwise, just passing
NULL. But then I felt it was a bit risky to reply on the pointer to indicate the
scenario.

> +	 *
>   	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
>   	 * to visit an SPTE before ever visiting its children, which means we
>   	 * will correctly recursively split huge pages that are more than one
> @@ -1597,12 +1611,19 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>   	 */
>   	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
>   retry:
> -		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> +		if (tdp_mmu_iter_cond_resched(kvm, &iter, *flush, shared)) {
> +			if (only_cross_bounday)
> +				*flush = false;
>   			continue;
> +		}
>   
>   		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
>   			continue;
>   
> +		if (only_cross_bounday &&
> +		    !iter_cross_boundary(&iter, start, end))
> +			continue;
> +
>   		if (!sp) {
>   			rcu_read_unlock();
>   
> @@ -1637,6 +1658,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>   			goto retry;
>   
>   		sp = NULL;
> +		if (only_cross_bounday)
> +			*flush = true;
>   	}
>   
>   	rcu_read_unlock();
[...]

