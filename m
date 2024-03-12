Return-Path: <kvm+bounces-11664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE2B879526
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 14:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0234F1F2346D
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 13:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC627A704;
	Tue, 12 Mar 2024 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TGMb3hDc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CD779B91;
	Tue, 12 Mar 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710250421; cv=none; b=Ff9qAM/bGMopZO3mkolmTnykdEMiVyrjT4s2vrUvJhV9lT5oiklwpZQdQyIbH1aFdryw4LZjUObFlMxvHoq4pqX/L7sOXx4qGcTDM6T9vUpn062r6KDuCsqEI3cnRcHseSnD1cZFuYSrAN+mnnHf7L4H/j84koR61SXWcQGx3qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710250421; c=relaxed/simple;
	bh=bzbXVrzjpIxE+1u40J+dNUpW+UEPjzDf9Zam2JO9mbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W7OMJlRc5A+6ryoQToCylNmlNnotxoCtDyoNJOye0U+vc5JCCX8zN1MvR+gyK60lUPPaVZynZr+M7HqPIpbw96bs3P0KxVgfl4BOZ0Ilk47gCE0YYk8L/xrRd5cWHkiXvX/Mu8RfX25DXe4ROJPueU5c99CH3kammQQcB8bE6hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TGMb3hDc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710250419; x=1741786419;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bzbXVrzjpIxE+1u40J+dNUpW+UEPjzDf9Zam2JO9mbg=;
  b=TGMb3hDc4IxefPv9idXFn/J2m2h6p+yTRWY8wLwLGGzqpypqEeWxB7Jv
   MJ1RnAvBKYW3BKjTExz/1MdBpw8blyW7bK3TonXbjr7B9iId//hiTiGxs
   c/p3uq6NZhUoNBu4D1BgaRGsWg3o5A8LfBTisMKbgjNHQcEPwjCRUsKPf
   08s0nFFiD32iC+5x5dsOmCqLKyKF4e4uZ+Vjr4T9HfUQi4EXmWeBdr/Tp
   wvnwl5Spyw5Eevjvycxk97cjZvMWBazOqoMGKPvDon3QGhPZhU16QJ8Cb
   DTfJMz5C8K8E16IOxgktpm2RQ2lziV8r4Txfa/fW14FcTqjkFrsMRlMyK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="7904350"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="7904350"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 06:33:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="48978613"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 06:33:35 -0700
Message-ID: <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
Date: Tue, 12 Mar 2024 21:33:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add new members to strut kvm_gfn_range to indicate which mapping
> (private-vs-shared) to operate on.  only_private and only_shared.  Update
> mmu notifier, set memory attributes ioctl or KVM gmem callback to
> initialize them.
>
> It was premature for set_memory_attributes ioctl to call
> kvm_unmap_gfn_range().  Instead, let kvm_arch_ste_memory_attributes()
"kvm_arch_ste_memory_attributes()" -> "kvm_vm_set_mem_attributes()" ?


> handle it and add a new x86 vendor callback to react to memory attribute
> change.  [1]
Which new x86 vendor callback?


>
> - If it's from the mmu notifier, zap shared pages only
> - If it's from the KVM gmem, zap private pages only
> - If setting memory attributes, vendor callback checks new attributes
>    and make decisions.
>    SNP would do nothing and handle it later with gmem callback
>    TDX callback would do as follows.
>    When it converts pages to shared, zap private pages only.
>    When it converts pages to private, zap shared pages only.
>
> TDX needs to know which mapping to operate on.  Shared-EPT vs. Secure-EPT.
> The following sequence to convert the GPA to private doesn't work for TDX
> because the page can already be private.
>
> 1) Update memory attributes to private in memory attributes xarray
> 2) Zap the GPA range irrespective of private-or-shared.
>     Even if the page is already private, zap the entry.
> 3) EPT violation on the GPA
> 4) Populate the GPA as private
>     The page is zeroed, and the guest has to accept the page again.
>
> In step 2, TDX wants to zap only shared pages and skip private ones.
>
> [1] https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com/
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> Changes v18:
> - rebased to kvm-next
>
> Changes v2 -> v3:
> - Drop the KVM_GFN_RANGE flags
> - Updated struct kvm_gfn_range
> - Change kvm_arch_set_memory_attributes() to return bool for flush
> - Added set_memory_attributes x86 op for vendor backends
> - Refined commit message to describe TDX care concretely
>
> Changes v1 -> v2:
> - consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
>    KVM_GFN_RANGE_FLAGS_GMEM.
> - Update the commit message to describe TDX more.  Drop SEV_SNP.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   include/linux/kvm_host.h |  2 ++
>   virt/kvm/guest_memfd.c   |  3 +++
>   virt/kvm/kvm_main.c      | 17 +++++++++++++++++
>   3 files changed, 22 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..0520cd8d03cc 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -264,6 +264,8 @@ struct kvm_gfn_range {
>   	gfn_t start;
>   	gfn_t end;
>   	union kvm_mmu_notifier_arg arg;
> +	bool only_private;
> +	bool only_shared;

IMO, an enum will be clearer than the two flags.

     enum {
         PROCESS_PRIVATE_AND_SHARED,
         PROCESS_ONLY_PRIVATE,
         PROCESS_ONLY_SHARED,
     };


>   	bool may_block;
>   };
>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 0f4e0cf4f158..3830d50b9b67 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -64,6 +64,9 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
>   			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
>   			.slot = slot,
>   			.may_block = true,
> +			/* guest memfd is relevant to only private mappings. */
> +			.only_private = true,
> +			.only_shared = false,
>   		};
>   
>   		if (!found_memslot) {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 10bfc88a69f7..0349e1f241d1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -634,6 +634,12 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>   			 */
>   			gfn_range.arg = range->arg;
>   			gfn_range.may_block = range->may_block;
> +			/*
> +			 * HVA-based notifications aren't relevant to private
> +			 * mappings as they don't have a userspace mapping.
> +			 */
> +			gfn_range.only_private = false;
> +			gfn_range.only_shared = true;
>   
>   			/*
>   			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> @@ -2486,6 +2492,16 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
>   	gfn_range.arg = range->arg;
>   	gfn_range.may_block = range->may_block;
>   
> +	/*
> +	 * If/when KVM supports more attributes beyond private .vs shared, this
> +	 * _could_ set only_{private,shared} appropriately if the entire target
> +	 * range already has the desired private vs. shared state (it's unclear
> +	 * if that is a net win).  For now, KVM reaches this point if and only
> +	 * if the private flag is being toggled, i.e. all mappings are in play.
> +	 */
> +	gfn_range.only_private = false;
> +	gfn_range.only_shared = false;
> +
>   	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
>   		slots = __kvm_memslots(kvm, i);
>   
> @@ -2542,6 +2558,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>   	struct kvm_mmu_notifier_range pre_set_range = {
>   		.start = start,
>   		.end = end,
> +		.arg.attributes = attributes,
>   		.handler = kvm_pre_set_memory_attributes,
>   		.on_lock = kvm_mmu_invalidate_begin,
>   		.flush_on_ret = true,


