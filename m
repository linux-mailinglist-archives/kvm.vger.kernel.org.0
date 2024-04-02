Return-Path: <kvm+bounces-13336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0CAC894B4E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2019D1C210BC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8ABA1E87C;
	Tue,  2 Apr 2024 06:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYW9we1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE294224F2;
	Tue,  2 Apr 2024 06:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712038912; cv=none; b=tZT2Ud9nEhAaTbv8ALRnh4Xj4iVZu4f+PsfQpiy0lHmbKX5nM+TBIqwVus4ZDc7yAEOkLzzjcOvZpcewckPYoKXCFImGwbNhSX5EN28IzMWS9oC95erwsZK0V/gwQ3Dqu3BKxrKK9/Z3TbOienrmcy+1M1G6qg7NkOK6DuZy6o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712038912; c=relaxed/simple;
	bh=GkqNJasuDn4TR8A0A0ShB3YK57TMnp9gvDs1CBvhYnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RBDl71hr7+hXvbycwhnmPL7eUrbc0847ijxVF+9ADn1X7baCfPyTapcN/br3auakOyfgtI7PjEoubAWOj19KO0AoOQ8/oxpiY+X2+hxY5+36HNJM/+fHlgRxPpJsfZOrwD7Ygw5TjfdtJBBSAuu7edj5u2gsnWxJ1H0vMzgLnDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYW9we1Y; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712038910; x=1743574910;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GkqNJasuDn4TR8A0A0ShB3YK57TMnp9gvDs1CBvhYnY=;
  b=AYW9we1Y823vkrqdzuewdHAHZGNia1weyme2tOszYjg3RGzuqGAxLRXy
   ov44cFE9+1YqeRxpnH+T3J0xwUwgaaVcTJfUgFu/kXZO0aRmZy6YTcApa
   N4nzMcmTzXiGhNTW8GvwrA3yCpUK1kVYtkiSy2nPVwbeSq7agkc6+X+1p
   9NPqD4auQnJ4AW0PB0jQcWSfAwECyRWdqwDWkZMGA6TaV+opu5oWI1zFj
   9VXFYRoLRWvMBrRS/ELUdH603prCFZ1GeYp5/04BO79eM3KymX8ImYM0c
   dFL5kVgKb5DW+yBQUuSV3blGMfkIrxUKJyk5FozftlwZOmAmZ2UQVFgNs
   g==;
X-CSE-ConnectionGUID: /XovSydaSG2ZRKWf9R+VNw==
X-CSE-MsgGUID: WOR67Jb5QLmY5E4S9MaXNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7029334"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="7029334"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:21:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="22436583"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:21:43 -0700
Message-ID: <bd862ee4-7513-4880-b6e5-466dcfb08f1a@linux.intel.com>
Date: Tue, 2 Apr 2024 14:21:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implement hooks of TDP MMU for TDX backend.  TLB flush, TLB shootdown,
> propagating the change private EPT entry to Secure EPT and freeing Secure
> EPT page. TLB flush handles both shared EPT and private EPT.  It flushes
> shared EPT same as VMX.  It also waits for the TDX TLB shootdown.  For the
> hook to free Secure EPT page, unlinks the Secure EPT page from the Secure
> EPT so that the page can be freed to OS.
>
> Propagate the entry change to Secure EPT.  The possible entry changes are
> present -> non-present(zapping) and non-present -> present(population).  On
> population just link the Secure EPT page or the private guest page to the
> Secure EPT by TDX SEAMCALL. Because TDP MMU allows concurrent
> zapping/population, zapping requires synchronous TLB shoot down with the
> frozen EPT entry.

But for private memory, zapping holds write lock, right?


>    It zaps the secure entry, increments TLB counter, sends
> IPI to remote vcpus to trigger TLB flush, and then unlinks the private
> guest page from the Secure EPT. For simplicity, batched zapping with
> exclude lock is handled as concurrent zapping.

exclude lock -> exclusive lock

How to understand this sentence?
Since it's holding exclusive lock, how it can be handled as concurrent 
zapping?
Or you want to describe the current implementation prevents concurrent 
zapping?


> Although it's inefficient,
> it can be optimized in the future.
>
> For MMIO SPTE, the spte value changes as follows.
> initial value (suppress VE bit is set)
> -> Guest issues MMIO and triggers EPT violation
> -> KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
> -> Guest MMIO resumes.  It triggers VE exception in guest TD
> -> Guest VE handler issues TDG.VP.VMCALL<MMIO>
> -> KVM handles MMIO
> -> Guest VE handler resumes its execution after MMIO instruction
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v19:
> - Compile fix when CONFIG_HYPERV != y.
>    It's due to the following patch.  Catch it up.
>    https://lore.kernel.org/all/20231018192325.1893896-1-seanjc@google.com/
> - Add comments on tlb shootdown to explan the sequence.
> - Use gmem_max_level callback, delete tdp_max_page_level.
>
> v18:
> - rename tdx_sept_page_aug() -> tdx_mem_page_aug()
> - checkpatch: space => tab
>
> v15 -> v16:
> - Add the handling of TD_ATTR_SEPT_VE_DISABLE case.
>
> v14 -> v15:
> - Implemented tdx_flush_tlb_current()
> - Removed unnecessary invept in tdx_flush_tlb().  It was carry over
>    from the very old code base.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/spte.c    |   3 +-
>   arch/x86/kvm/vmx/main.c    |  91 ++++++++-
>   arch/x86/kvm/vmx/tdx.c     | 372 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |   2 +-
>   arch/x86/kvm/vmx/tdx_ops.h |   6 +
>   arch/x86/kvm/vmx/x86_ops.h |  13 ++
>   6 files changed, 481 insertions(+), 6 deletions(-)
>
[...]
> +
> +static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> +			    enum pg_level level, kvm_pfn_t pfn)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	union tdx_sept_level_state level_state;
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	struct tdx_module_args out;
> +	union tdx_sept_entry entry;
> +	u64 err;
> +
> +	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EAGAIN;
> +	}
> +	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
> +		entry.raw = out.rcx;
> +		level_state.raw = out.rdx;
> +		if (level_state.level == tdx_level &&
> +		    level_state.state == TDX_SEPT_PENDING &&
> +		    entry.leaf && entry.pfn == pfn && entry.sve) {
> +			tdx_unpin(kvm, pfn);
> +			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
> +				       TDX_TD_ATTR_SEPT_VE_DISABLE));

to_kvm_tdx(kvm) -> kvm_tdx

Since the implementation requires attributes.TDX_TD_ATTR_SEPT_VE_DISABLE is set, should it check the value passed from userspace?
And the reason should be described somewhere in changelog or/and comment.



> +			return -EAGAIN;
> +		}
> +	}
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
> +		tdx_unpin(kvm, pfn);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> +				     enum pg_level level, kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	/* TODO: handle large pages. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return -EINVAL;
> +
> +	/*
> +	 * Because restricted mem

The term "restricted mem" is not used anymore, right? Should update the 
comment.

> doesn't support page migration with
> +	 * a_ops->migrate_page (yet), no callback isn't triggered for KVM on

no callback isn't -> no callback is

> +	 * page migration.  Until restricted mem supports page migration,

"restricted mem" -> guest_mem


> +	 * prevent page migration.
> +	 * TODO: Once restricted mem introduces callback on page migration,

ditto

> +	 * implement it and remove get_page/put_page().
> +	 */
> +	get_page(pfn_to_page(pfn));
> +
> +	if (likely(is_td_finalized(kvm_tdx)))
> +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> +
> +	/* TODO: tdh_mem_page_add() comes here for the initial memory. */
> +
> +	return 0;
> +}
> +
> +static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> +				       enum pg_level level, kvm_pfn_t pfn)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_module_args out;
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	hpa_t hpa_with_hkid;
> +	u64 err;
> +
> +	/* TODO: handle large pages. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return -EINVAL;
> +
> +	if (unlikely(!is_hkid_assigned(kvm_tdx))) {
> +		/*
> +		 * The HKID assigned to this TD was already freed and cache
> +		 * was already flushed. We don't have to flush again.
> +		 */
> +		err = tdx_reclaim_page(hpa);
> +		if (KVM_BUG_ON(err, kvm))
> +			return -EIO;
> +		tdx_unpin(kvm, pfn);
> +		return 0;
> +	}
> +
> +	do {
> +		/*
> +		 * When zapping private page, write lock is held. So no race
> +		 * condition with other vcpu sept operation.  Race only with
> +		 * TDH.VP.ENTER.
> +		 */
> +		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
> +	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
> +		return -EIO;
> +	}
> +
> +	hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
> +	do {
> +		/*
> +		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
> +		 * this page was removed above, other thread shouldn't be
> +		 * repeatedly operating on this page.  Just retry loop.
> +		 */
> +		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
> +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +		return -EIO;
> +	}
> +	tdx_clear_page(hpa);
> +	tdx_unpin(kvm, pfn);
> +	return 0;
> +}
> +
> +static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> +				     enum pg_level level, void *private_spt)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	hpa_t hpa = __pa(private_spt);
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	err = tdh_mem_sept_add(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);

kvm_tdx is only used here, can drop the local var.

> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_SEPT_ADD, err, &out);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
>

