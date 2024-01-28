Return-Path: <kvm+bounces-7288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2FB83F5A8
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 14:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89F4028337D
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 13:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C9323773;
	Sun, 28 Jan 2024 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eXLj5Q7r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92E123745;
	Sun, 28 Jan 2024 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706449824; cv=none; b=gIXVpO67652fGE9VRWLhJ4H4V3Y9REOGlGOzGUczsw4uXSVPEsFFDx69tMFEv6jULBwCEkKVlSETAfN0KalMaiPFesEuuNz3o+DCmwhI/eW5zg3T7moSNu5pGVFk2FsHNM+ZMtwu2RNUzc35KqdWpR4qWihSiMrwU/ZbWuYpmFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706449824; c=relaxed/simple;
	bh=Qdk+w87TnLufd+Guoc+SksdnxoOt/epacdeFDajSsYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J/8kzpD7pBMWN8abR4lQGNSCwamoAYElzgmWpHpk0xz+YKIAao14bT7J5xdpbMJav2HpvZ1mRgEEHBt6vgBmV/J3O0NWmU31SiUArwjt3jJVxCtUsrLhY6FUAJRTsCzst+BTPIgGI2vliOEwjw2cCw6+51LPmtuBHt37qnN/qzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eXLj5Q7r; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706449822; x=1737985822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qdk+w87TnLufd+Guoc+SksdnxoOt/epacdeFDajSsYo=;
  b=eXLj5Q7rSoe5v99cmRjTIaIJubk5GuENJMi04Kx6q25PgXOoVa3g8eJB
   LyUmL4yT8Jrt6Ifv8GGndV7OjTy+pzI/ZFokbdRsjDzZza+/MziSKCv5I
   mJSi17uFEBix/+lHeOL0mFc63FsXuh6IYgDsoCKVsrTyFQ/21i9mxG3fL
   PSXPlDb0tfqTTKJQ3hhKMITqLztpRH0WXGURRdXiR3TOv1+jshH9DlhU5
   gxA9196/2hbGMQtvSgpU8GNhfods+OKU/blkc+ycCHs2yn2AtkYE0zW6V
   wLB8zDrOpWOKNa5mXo/rfpJwa77N1p2vyM6ux/HJ41BrSuSyYYYbCOAtF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="401641110"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="401641110"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 05:50:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="906809771"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="906809771"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 05:50:18 -0800
Message-ID: <05db1988-fad8-458a-8132-7dbe0f1a3ffa@linux.intel.com>
Date: Sun, 28 Jan 2024 21:50:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 039/121] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <229a18434e5d83f45b1fcd7bf1544d79db1becb6.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <229a18434e5d83f45b1fcd7bf1544d79db1becb6.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
> logic is kept working.  Introduce a separate setter function so that guest
> TD can override later.
>
> Also require mmio spte cachcing for TDX.  Actually this is true case
s/cachcing/caching

> because TDX require EPT and KVM EPT allows mmio spte caching.
s/require/requires

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/mmu.h              |  1 +
>   arch/x86/kvm/mmu/mmu.c          |  8 +++++---
>   arch/x86/kvm/mmu/spte.c         | 10 ++++++++--
>   arch/x86/kvm/mmu/spte.h         |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
>   6 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 96f900386026..430d7bd7c37c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1310,6 +1310,8 @@ struct kvm_arch {
>   	 */
>   	spinlock_t mmu_unsync_pages_lock;
>   
> +	u64 shadow_mmio_value;
> +
>   	struct iommu_domain *iommu_domain;
>   	bool iommu_noncoherent;
>   #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 191b820b7c4f..bad6a1e43a54 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>   }
>   
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f1cec0f8e3d6..b2924bd9b668 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2515,7 +2515,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>   				return kvm_mmu_prepare_zap_page(kvm, child,
>   								invalid_list);
>   		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>   		mmu_spte_clear_no_track(spte);
>   	}
>   	return 0;
> @@ -4184,7 +4184,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>   	if (WARN_ON_ONCE(reserved))
>   		return -EINVAL;
>   
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>   		gfn_t gfn = get_mmio_spte_gfn(spte);
>   		unsigned int access = get_mmio_spte_access(spte);
>   
> @@ -4762,7 +4762,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>   static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>   			   unsigned int access)
>   {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>   		if (gfn != get_mmio_spte_gfn(*sptep)) {
>   			mmu_spte_clear_no_track(sptep);
>   			return true;
> @@ -6282,6 +6282,8 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>   
>   void kvm_mmu_init_vm(struct kvm *kvm)
>   {
> +
> +	kvm->arch.shadow_mmio_value = shadow_mmio_value;
>   	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>   	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
>   	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 02a466de2991..318135daf685 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -74,10 +74,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>   	u64 spte = generation_mmio_spte_mask(gen);
>   	u64 gpa = gfn << PAGE_SHIFT;
>   
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
>   
>   	access &= shadow_mmio_access_mask;
> -	spte |= shadow_mmio_value | access;
> +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
>   	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
>   	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
>   		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -411,6 +411,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>   }
>   EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>   
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
> +{

Is it better to do some check on the mmio_value and warns if the value
is illegal?

> +	kvm->arch.shadow_mmio_value = mmio_value;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
> +
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
>   {
>   	/* shadow_me_value must be a subset of shadow_me_mask */
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 26bc95bbc962..1a163aee9ec6 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -264,9 +264,9 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
>   	return spte_to_child_sp(root);
>   }
>   
> -static inline bool is_mmio_spte(u64 spte)
> +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>   {
> -	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> +	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
>   	       likely(enable_mmio_caching);
>   }
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bdeb23ff9e71..04c6af49c3e8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -462,8 +462,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   		 * impact the guest since both the former and current SPTEs
>   		 * are nonpresent.
>   		 */
> -		if (WARN_ON_ONCE(!is_mmio_spte(old_spte) &&
> -				 !is_mmio_spte(new_spte) &&
> +		if (WARN_ON_ONCE(!is_mmio_spte(kvm, old_spte) &&
> +				 !is_mmio_spte(kvm, new_spte) &&
>   				 !is_removed_spte(new_spte)))
>   			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
>   			       "should not be replaced with another,\n"
> @@ -978,7 +978,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   	}
>   
>   	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -	if (unlikely(is_mmio_spte(new_spte))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
>   		vcpu->stat.pf_mmio_spte_created++;
>   		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
>   				     new_spte);


