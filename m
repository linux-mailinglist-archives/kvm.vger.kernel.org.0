Return-Path: <kvm+bounces-11899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F5787CAAF
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 10:28:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A16D61F231C0
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF5317C6C;
	Fri, 15 Mar 2024 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UI4O34qY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF31799D;
	Fri, 15 Mar 2024 09:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710494923; cv=none; b=AgLxNULnba71ZLY9gfgp7KKey30OZEL8cMSpi9UETBG+W+5I6LxZkwQ0nXs71dbUg6ObvE9XqR+arCPX/YcECc67r3AIe/7qSw3IUErgr+F3J7oseJZSLEWS0IB9MnyLFwXJ6YzTr1DPTphdHxgBnSFO0Boop1oLGaqTPC39S30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710494923; c=relaxed/simple;
	bh=Jw1py/JdYhpsbyL85xC8WpCBa6kvGQQhAkylKoj7qcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xb1E5//mdhMJx9S1CAzzSKuBTOh3wN/SsKXUuBEWREF0dYPd9hE6YPstBNdMG4bKCK/m6rE8x0EHw3Sx9dNMqh4VW4Ak3TlolmArsGDGNy4j8vQpbot6z4C05Q9rWAXdBxNqBughbL2UB4UBjh5jdGceinNjijyNE0Qbg6n1sks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UI4O34qY; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710494921; x=1742030921;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Jw1py/JdYhpsbyL85xC8WpCBa6kvGQQhAkylKoj7qcM=;
  b=UI4O34qYxhklY71jQniQFVxB4TgYlJkJmVP2WnWTCFZ3uGK1xxk3MlUA
   5G5O8tdnGfb+5B3N5HbJ/39Xe4Ddy9pBTbiqAY1PnRv6S4x9AxvJDmo6A
   V623zUncoAnNw0k30QV6Now4o0m/imm3na4RYB0wkAnmmlfyr+eiLtGJR
   6RYJkf6xoQaxvxS6s332PnR+4/ubuUy6ynrDkvtysUUiWM2woKtP6pK5A
   0QtO/jPfuFOaOjg089LXluxIqPxUr5I9Pb95UCUHyj/o5Bgi+OVaGiGcZ
   MKd8F/jSZzGRGumk50l4Pwa+y/FsIPHI6wJTeMrt5BTuQCYzI9cqu3R+8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22874660"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="22874660"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 02:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="43509447"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.80])
  by orviesa002.jf.intel.com with ESMTP; 15 Mar 2024 02:28:38 -0700
Date: Fri, 15 Mar 2024 17:14:13 +0800
From: Chao Peng <chao.p.peng@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Message-ID: <20240315091413.GA221655@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>

On Thu, Mar 14, 2024 at 02:29:02PM -0700, Rick Edgecombe wrote:
> Fix KVM_SET_MEMORY_ATTRIBUTES to not overflow lpage_info array and trigger
> KASAN splat, as seen in the private_mem_conversions_test selftest.
> 
> When memory attributes are set on a GFN range, that range will have
> specific properties applied to the TDP. A huge page cannot be used when
> the attributes are inconsistent, so they are disabled for those the
> specific huge pages. For internal KVM reasons, huge pages are also not
> allowed to span adjacent memslots regardless of whether the backing memory
> could be mapped as huge.
> 
> What GFNs support which huge page sizes is tracked by an array of arrays
> 'lpage_info' on the memslot, of ¡®kvm_lpage_info¡¯ structs. Each index of
> lpage_info contains a vmalloc allocated array of these for a specific
> supported page size. The kvm_lpage_info denotes whether a specific huge
> page (GFN and page size) on the memslot is supported. These arrays include
> indices for unaligned head and tail huge pages.
> 
> Preventing huge pages from spanning adjacent memslot is covered by
> incrementing the count in head and tail kvm_lpage_info when the memslot is
> allocated, but disallowing huge pages for memory that has mixed attributes
> has to be done in a more complicated way. During the
> KVM_SET_MEMORY_ATTRIBUTES ioctl KVM updates lpage_info for each memslot in
> the range that has mismatched attributes. KVM does this a memslot at a
> time, and marks a special bit, KVM_LPAGE_MIXED_FLAG, in the kvm_lpage_info
> for any huge page. This bit is essentially a permanently elevated count.
> So huge pages will not be mapped for the GFN at that page size if the
> count is elevated in either case: a huge head or tail page unaligned to
> the memslot or if KVM_LPAGE_MIXED_FLAG is set because it has mixed
> attributes.
> 
> To determine whether a huge page has consistent attributes, the
> KVM_SET_MEMORY_ATTRIBUTES operation checks an xarray to make sure it
> consistently has the incoming attribute. Since level - 1 huge pages are
> aligned to level huge pages, it employs an optimization. As long as the
> level - 1 huge pages are checked first, it can just check these and assume
> that if each level - 1 huge page contained within the level sized huge
> page is not mixed, then the level size huge page is not mixed. This
> optimization happens in the helper hugepage_has_attrs().
> 
> Unfortunately, although the kvm_lpage_info array representing page size
> 'level' will contain an entry for an unaligned tail page of size level,
> the array for level - 1  will not contain an entry for each GFN at page
> size level. The level - 1 array will only contain an index for any
> unaligned region covered by level - 1 huge page size, which can be a
> smaller region. So this causes the optimization to overflow the level - 1
> kvm_lpage_info and perform a vmalloc out of bounds read.
> 
> In some cases of head and tail pages where an overflow could happen,
> callers skip the operation completely as KVM_LPAGE_MIXED_FLAG is not
> required to prevent huge pages as discussed earlier. But for memslots that
> are smaller than the 1GB page size, it does call hugepage_has_attrs(). In
> this case the huge page is both the head and tail page. The issue can be
> observed simply by compiling the kernel with CONFIG_KASAN_VMALLOC and
> running the selftest ¡°private_mem_conversions_test¡±, which produces the
> output like the following:
> 
> BUG: KASAN: vmalloc-out-of-bounds in hugepage_has_attrs+0x7e/0x110
> Read of size 4 at addr ffffc900000a3008 by task private_mem_con/169
> Call Trace:
>   dump_stack_lvl
>   print_report
>   ? __virt_addr_valid
>   ? hugepage_has_attrs
>   ? hugepage_has_attrs
>   kasan_report
>   ? hugepage_has_attrs
>   hugepage_has_attrs
>   kvm_arch_post_set_memory_attributes
>   kvm_vm_ioctl
> 
> It is a little ambiguous whether the unaligned head page (in the bug case 
> also the tail page) should be expected to have KVM_LPAGE_MIXED_FLAG set. 
> It is not functionally required, as the unaligned head/tail pages will 
> already have their kvm_lpage_info count incremented. The comments imply 
> not setting it on unaligned head pages is intentional, so fix the callers 
> to skip trying to set KVM_LPAGE_MIXED_FLAG in this case, and in doing so 
> not call hugepage_has_attrs().
> 
> Cc: stable@vger.kernel.org
> Fixes: 90b4fe17981e ("KVM: x86: Disallow hugepages when memory attributes are mixed")
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Chao Peng <chao.p.peng@linux.intel.com>

> ---
> v2:
>  - Drop function rename (Sean)
>  - Clarify in commit log that this is only head pages that are also tail
>    pages (Sean)
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0544700ca50b..42e7de604bb6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7388,7 +7388,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  			 * by the memslot, KVM can't use a hugepage due to the
>  			 * misaligned address regardless of memory attributes.
>  			 */
> -			if (gfn >= slot->base_gfn) {
> +			if (gfn >= slot->base_gfn &&
> +			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
>  				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
>  					hugepage_clear_mixed(slot, gfn, level);
>  				else
> -- 
> 2.34.1

