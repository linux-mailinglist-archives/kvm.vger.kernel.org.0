Return-Path: <kvm+bounces-7432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2D4841D31
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 09:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE3DE1C23BC6
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0D254F8E;
	Tue, 30 Jan 2024 08:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UrIpYgAD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1F354670;
	Tue, 30 Jan 2024 08:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706601962; cv=none; b=riSvlOHySWVog2n5zs6YCSFBBRo+YNcEdJ6NCsYQEvTxxFFI/h1JtrskZRatUdIfYSEI4L5d9H5tdslw6M9bFzAd/ROTAWuLH44SPQfFVkU0s1yJm9ln0SMQ2hD8kcLDruZlxcAxcjVYBN7zGOtjSCyqlGKSOWN0WXB4l/rhg40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706601962; c=relaxed/simple;
	bh=pK7Jgy0qFlf90hL/T8Gsgk+YVtWCcPOYVfBWpUth5TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjoYxwgr+6M/mZlSzEAWkiexw2Ilfa0NkEK9Q2ahR3cmLTBL6eLSUIjAPYcLDzYYCupRiDV28b9ei+NIsOZPCRl2VvRvZGbTNWh0shkzzK6hqRyzh93lqTVZL1JiyuwOER/t1qOM3YU30nmKuARxu5g2ugfuDfXuEo8sorw+lCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UrIpYgAD; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706601959; x=1738137959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pK7Jgy0qFlf90hL/T8Gsgk+YVtWCcPOYVfBWpUth5TA=;
  b=UrIpYgADMglGCpCSHSNoLZ/RP37F227WBznShd2WiutQlK12aXwK4fTE
   WdQj70IQNT8eV9O8Ov0fOmM16xUMffWmNlycZcb98oAHzt8i5QuYFeaYC
   lgFzrFJtaIH83vWewUOQB5y8t52+enO8bIez4Ahvj6lJLPxGb7FgWLf++
   60f8aKI9jIYO1Vgu4ToaH3cbAHrt83Bp9uJymxIX9OMam2BzQdh0mIKsS
   ao2KOghl0sSFxdr3DVaUSxSBsP0IyKAusOxGtdUAQTmVBllcf2jSsDuZP
   ORYIwzanZWKqZ7QZyMY43U6Rx6G+6rT0/szvlIe6v/hCMwQkZUK6QnEDs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="400339571"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="400339571"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 00:05:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="30070427"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa001.fm.intel.com with ESMTP; 30 Jan 2024 00:05:55 -0800
Date: Tue, 30 Jan 2024 16:05:54 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v17 055/116] KVM: TDX: TDP MMU TDX support
Message-ID: <20240130080554.6j5fcn3yzllv6r7l@yy-desk-7060>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <6a477bd89cd9237134793387c68ccbfc86720fc6.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a477bd89cd9237134793387c68ccbfc86720fc6.1699368322.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Tue, Nov 07, 2023 at 06:56:21AM -0800, isaku.yamahata@intel.com wrote:
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
> frozen EPT entry.  It zaps the secure entry, increments TLB counter, sends
> IPI to remote vcpus to trigger TLB flush, and then unlinks the private
> guest page from the Secure EPT. For simplicity, batched zapping with
> exclude lock is handled as concurrent zapping.  Although it's inefficient,
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
> v15 -> v16:
> - Add the handling of TD_ATTR_SEPT_VE_DISABLE case.
>
> v14 -> v15:
> - Implemented tdx_flush_tlb_current()
> - Removed unnecessary invept in tdx_flush_tlb().  It was carry over
>   from the very old code base.
> ---
>  arch/x86/kvm/mmu/spte.c    |   3 +-
>  arch/x86/kvm/vmx/main.c    |  71 +++++++-
>  arch/x86/kvm/vmx/tdx.c     | 342 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     |   7 +
>  arch/x86/kvm/vmx/x86_ops.h |   6 +
>  5 files changed, 424 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 318135daf685..83926a35ea47 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -74,7 +74,8 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  	u64 spte = generation_mmio_spte_mask(gen);
>  	u64 gpa = gfn << PAGE_SHIFT;
>
> -	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
> +		     !kvm_gfn_shared_mask(vcpu->kvm));
>
>  	access &= shadow_mmio_access_mask;
>  	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 457310186255..d1387e7b2362 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -28,6 +28,7 @@ static int vt_max_vcpus(struct kvm *kvm)
>
>  	return kvm->max_vcpus;
>  }
> +static int vt_flush_remote_tlbs(struct kvm *kvm);
>
>  static int vt_hardware_enable(void)
>  {
> @@ -70,8 +71,22 @@ static __init int vt_hardware_setup(void)
>  		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
>  	}
>
> +	/*
> +	 * TDX KVM overrides flush_remote_tlbs method and assumes
> +	 * flush_remote_tlbs_range = NULL that falls back to
> +	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
> +	 */
> +	if (vt_x86_ops.flush_remote_tlbs ||
> +	    vt_x86_ops.flush_remote_tlbs_range) {

these 2 fields are defined for CONFIG_HYPERV,
so this leads to compiling errors when !CONFIG_HYPERV.

Is that possible to select CONFIG_HYPERV if this is
*must* have dependency ?

> +		enable_tdx = false;
> +		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
> +	}
> +
>  	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
>
> +	if (enable_tdx)
> +		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;

Ditto.

> +
>  	return 0;
>  }
>
> @@ -154,6 +169,54 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vmx_vcpu_reset(vcpu, init_event);
>  }
>
> +static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_flush_tlb(vcpu);
> +		return;
> +	}
> +
> +	vmx_flush_tlb_all(vcpu);
> +}
> +
> +static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_flush_tlb_current(vcpu);
> +		return;
> +	}
> +
> +	vmx_flush_tlb_current(vcpu);
> +}
> +
> +static int vt_flush_remote_tlbs(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return tdx_sept_flush_remote_tlbs(kvm);
> +
> +	/*
> +	 * fallback to KVM_REQ_TLB_FLUSH.
> +	 * See kvm_arch_flush_remote_tlb() and kvm_flush_remote_tlbs().
> +	 */
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vt_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
> +{
> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> +		return;
> +
> +	vmx_flush_tlb_gva(vcpu, addr);
> +}
> +
> +static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_flush_tlb_guest(vcpu);
> +}
> +
>  static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			int pgd_level)
>  {
> @@ -245,10 +308,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.set_rflags = vmx_set_rflags,
>  	.get_if_flag = vmx_get_if_flag,
>
> -	.flush_tlb_all = vmx_flush_tlb_all,
> -	.flush_tlb_current = vmx_flush_tlb_current,
> -	.flush_tlb_gva = vmx_flush_tlb_gva,
> -	.flush_tlb_guest = vmx_flush_tlb_guest,
> +	.flush_tlb_all = vt_flush_tlb_all,
> +	.flush_tlb_current = vt_flush_tlb_current,
> +	.flush_tlb_gva = vt_flush_tlb_gva,
> +	.flush_tlb_guest = vt_flush_tlb_guest,
>
>  	.vcpu_pre_run = vmx_vcpu_pre_run,
>  	.vcpu_run = vmx_vcpu_run,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d26b96cf94f9..5f2a27f72cf1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -7,6 +7,7 @@
>  #include "x86_ops.h"
>  #include "mmu.h"
>  #include "tdx.h"
> +#include "vmx.h"
>  #include "x86.h"
>
>  #undef pr_fmt
> @@ -331,6 +332,22 @@ static int tdx_do_tdh_mng_key_config(void *param)
>
>  int tdx_vm_init(struct kvm *kvm)
>  {
> +	/*
> +	 * Because guest TD is protected, VMM can't parse the instruction in TD.
> +	 * Instead, guest uses MMIO hypercall.  For unmodified device driver,
> +	 * #VE needs to be injected for MMIO and #VE handler in TD converts MMIO
> +	 * instruction into MMIO hypercall.
> +	 *
> +	 * SPTE value for MMIO needs to be setup so that #VE is injected into
> +	 * TD instead of triggering EPT MISCONFIG.
> +	 * - RWX=0 so that EPT violation is triggered.
> +	 * - suppress #VE bit is cleared to inject #VE.
> +	 */
> +	kvm_mmu_set_mmio_spte_value(kvm, 0);
> +
> +	/* TODO: Enable 2mb and 1gb large page support. */
> +	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
> +
>  	/*
>  	 * This function initializes only KVM software construct.  It doesn't
>  	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> @@ -430,6 +447,285 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
>  }
>
> +static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	put_page(page);
> +}
> +
> +static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
> +			     enum pg_level level, kvm_pfn_t pfn)
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
> +			tdx_unpin(kvm, gfn, pfn, level);
> +			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
> +				       TDX_TD_ATTR_SEPT_VE_DISABLE));
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
> +	 * Because restricted mem doesn't support page migration with
> +	 * a_ops->migrate_page (yet), no callback isn't triggered for KVM on
> +	 * page migration.  Until restricted mem supports page migration,
> +	 * prevent page migration.
> +	 * TODO: Once restricted mem introduces callback on page migration,
> +	 * implement it and remove get_page/put_page().
> +	 */
> +	get_page(pfn_to_page(pfn));
> +
> +	if (likely(is_td_finalized(kvm_tdx)))
> +		return tdx_sept_page_aug(kvm, gfn, level, pfn);
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
> +static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
> +				      enum pg_level level)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	/* This can be called when destructing guest TD after freeing HKID. */
> +	if (unlikely(!is_hkid_assigned(kvm_tdx)))
> +		return 0;
> +
> +	/* For now large page isn't supported yet. */
> +	WARN_ON_ONCE(level != PG_LEVEL_4K);
> +	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_RANGE_BLOCK, err, &out);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * TLB shoot down procedure:
> + * There is a global epoch counter and each vcpu has local epoch counter.
> + * - TDH.MEM.RANGE.BLOCK(TDR. level, range) on one vcpu
> + *   This blocks the subsequenct creation of TLB translation on that range.
> + *   This corresponds to clear the present bit(all RXW) in EPT entry
> + * - TDH.MEM.TRACK(TDR): advances the epoch counter which is global.
> + * - IPI to remote vcpus
> + * - TDExit and re-entry with TDH.VP.ENTER on remote vcpus
> + * - On re-entry, TDX module compares the local epoch counter with the global
> + *   epoch counter.  If the local epoch counter is older than the global epoch
> + *   counter, update the local epoch counter and flushes TLB.
> + */
> +static void tdx_track(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +
> +	KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm);
> +	/* If TD isn't finalized, it's before any vcpu running. */
> +	if (unlikely(!is_td_finalized(kvm_tdx)))
> +		return;
> +
> +	/*
> +	 * tdx_flush_tlb() waits for this function to issue TDH.MEM.TRACK() by
> +	 * the counter.  The counter is used instead of bool because multiple
> +	 * TDH_MEM_TRACK() can be issued concurrently by multiple vcpus.
> +	 */
> +	atomic_inc(&kvm_tdx->tdh_mem_track);
> +	/*
> +	 * KVM_REQ_TLB_FLUSH waits for the empty IPI handler, ack_flush(), with
> +	 * KVM_REQUEST_WAIT.
> +	 */
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
> +
> +	do {
> +		/*
> +		 * kvm_flush_remote_tlbs() doesn't allow to return error and
> +		 * retry.
> +		 */
> +		err = tdh_mem_track(kvm_tdx->tdr_pa);
> +	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
> +
> +	/* Release remote vcpu waiting for TDH.MEM.TRACK in tdx_flush_tlb(). */
> +	atomic_dec(&kvm_tdx->tdh_mem_track);
> +
> +	if (KVM_BUG_ON(err, kvm))
> +		pr_tdx_error(TDH_MEM_TRACK, err, NULL);
> +
> +}
> +
> +static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
> +				     enum pg_level level, void *private_spt)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	/*
> +	 * The HKID assigned to this TD was already freed and cache was
> +	 * already flushed. We don't have to flush again.
> +	 */
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return tdx_reclaim_page(__pa(private_spt));
> +
> +	/*
> +	 * free_private_spt() is (obviously) called when a shadow page is being
> +	 * zapped.  KVM doesn't (yet) zap private SPs while the TD is active.
> +	 * Note: This function is for private shadow page.  Not for private
> +	 * guest page.   private guest page can be zapped during TD is active.
> +	 * shared <-> private conversion and slot move/deletion.
> +	 */
> +	KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm);
> +	return -EINVAL;
> +}
> +
> +int tdx_sept_flush_remote_tlbs(struct kvm *kvm)
> +{
> +	if (unlikely(!is_td(kvm)))
> +		return -EOPNOTSUPP;
> +
> +	if (is_hkid_assigned(to_kvm_tdx(kvm)))
> +		tdx_track(kvm);
> +
> +	return 0;
> +}
> +
> +static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> +					 enum pg_level level, kvm_pfn_t pfn)
> +{
> +	/*
> +	 * TDX requires TLB tracking before dropping private page.  Do
> +	 * it here, although it is also done later.
> +	 * If hkid isn't assigned, the guest is destroying and no vcpu
> +	 * runs further.  TLB shootdown isn't needed.
> +	 *
> +	 * TODO: Call TDH.MEM.TRACK() only when we have called
> +	 * TDH.MEM.RANGE.BLOCK(), but not call TDH.MEM.TRACK() yet.
> +	 */
> +	if (is_hkid_assigned(to_kvm_tdx(kvm)))
> +		tdx_track(kvm);
> +
> +	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
> +}
> +
>  static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>  {
>  	struct kvm_tdx_capabilities __user *user_caps;
> @@ -895,6 +1191,39 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	return ret;
>  }
>
> +void tdx_flush_tlb(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Don't need to flush shared EPTP:
> +	 * "TD VCPU TLB Address Spaced Identifier" in the TDX module spec:
> +	 * The TLB entries for TD are tagged with:
> +	 *  SEAM (1 bit)
> +	 *  VPID
> +	 *  Secure EPT root (51:12 bits) with HKID = 0
> +	 *  PCID
> +	 * for *both* Secure-EPT and Shared-EPT.
> +	 * TLB flush with Secure-EPT root by tdx_track() results in flushing
> +	 * the conversion of both Secure-EPT and Shared-EPT.
> +	 */
> +
> +	/*
> +	 * See tdx_track().  Wait for tlb shootdown initiater to finish
> +	 * TDH_MEM_TRACK() so that shared-EPT/secure-EPT TLB is flushed
> +	 * on the next TDENTER.
> +	 */
> +	while (atomic_read(&to_kvm_tdx(vcpu->kvm)->tdh_mem_track))
> +		cpu_relax();
> +}
> +
> +void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * flush_tlb_current() is used only the first time for the vcpu to run.
> +	 * As it isn't performance critical, keep this function simple.
> +	 */
> +	tdx_track(vcpu->kvm);
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -1160,8 +1489,21 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  	on_each_cpu(vmx_off, &vmx_tdx.vmx_enabled, true);
>  	cpus_read_unlock();
>  	free_cpumask_var(vmx_tdx.vmx_enabled);
> +	if (r)
> +		goto out;
> +
> +	x86_ops->link_private_spt = tdx_sept_link_private_spt;
> +	x86_ops->free_private_spt = tdx_sept_free_private_spt;
> +	x86_ops->set_private_spte = tdx_sept_set_private_spte;
> +	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
> +	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
> +
> +	return 0;
>
>  out:
> +	/* kfree() accepts NULL. */
> +	kfree(tdx_mng_key_config_lock);
> +	tdx_mng_key_config_lock = NULL;
>  	return r;
>  }
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index d92a75c78e6e..57ecb83e2f35 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -18,6 +18,7 @@ struct kvm_tdx {
>  	int hkid;
>
>  	bool finalized;
> +	atomic_t tdh_mem_track;
>
>  	u64 tsc_offset;
>  };
> @@ -165,6 +166,12 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
>  	return out.r8;
>  }
>
> +static __always_inline int pg_level_to_tdx_sept_level(enum pg_level level)
> +{
> +	WARN_ON_ONCE(level == PG_LEVEL_NONE);
> +	return level - 1;
> +}
> +
>  #else
>  struct kvm_tdx {
>  	struct kvm kvm;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 7fa6becd5f87..e4cbcf04d7e3 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -153,6 +153,9 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>
> +void tdx_flush_tlb(struct kvm_vcpu *vcpu);
> +void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
> +int tdx_sept_flush_remote_tlbs(struct kvm *kvm);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> @@ -176,6 +179,9 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>
> +static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
> +static inline int tdx_sept_flush_remote_tlbs(struct kvm *kvm) { return 0; }
>  static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
>  #endif
>
> --
> 2.25.1
>
>

