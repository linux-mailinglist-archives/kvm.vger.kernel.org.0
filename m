Return-Path: <kvm+bounces-20040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8BF90FC20
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 07:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06B3F1F24B2C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 05:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1111C2CCA3;
	Thu, 20 Jun 2024 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IJIWG1G+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150D3628;
	Thu, 20 Jun 2024 05:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718860524; cv=none; b=n/w9M4aNe9lBfIetgPX6ctj3Rzq+z6ou/udlDWbqpDC9RkckT+kSu3uQxWiXuqVygiQ9N0Y5i0IyJujxKYhPAKjxGGfDsvb0Xi2kPIXaPUxt4RPxc1qF+XrcjaeEoMs5x7qyjs/cDFb9+9hbQ3KzUDNqqIDGBifvTB0M89YHIUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718860524; c=relaxed/simple;
	bh=fSwtWaRh8l3f8fNP+pxqdr7ap4896TNtS2rWH7jZV5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A7FPPWVpRDRX5ExArsF+PrYmki7iUy1FAs/qbjmlYRQTjx4CzRAOnRlOpK6ZmtyktDZImC2X4WazKgrHZwnb7i8R96sc7AzReEcyPJSHLIgLKkR54lUeNeqZwu+TkdUgsF8+l3EoZQhdfitOkc+YcUrRFlWvgKllzYNkfPVBEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IJIWG1G+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718860523; x=1750396523;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fSwtWaRh8l3f8fNP+pxqdr7ap4896TNtS2rWH7jZV5A=;
  b=IJIWG1G+C0UYNIgXgqMaFOd1lw/oOJC41XzkqTRRYA9rn9/bT37jFsY7
   erXDMIMcxM9DoXCeuTiFIPkSjDAbHkUOXbP3P7w3bsuzBngS2H1LGdm+R
   qUysFN1NlfgxEuAifz53VCrG28DTmHKorLWbd/YLIsLwACjijO2B9FCiZ
   PpqBuxBTBB8wSc0IcbNW2S1TYXA7KYp9xKpo8qIUvbhaN+EAAA5NQj2no
   W5DNDWg2TxWGqqtpEg9l0yrddvu8A4NS6O7PPIh4V9OxhP6s6lAPpsLH9
   jwLWEL6lDySxhA1EuN6QjlianorATTFdXwC/fQWn9K8pMDIc6KoOthE71
   w==;
X-CSE-ConnectionGUID: oXlxbnwuQk+R0+kuvPtteQ==
X-CSE-MsgGUID: bXkP8Vn6QeK/cqY/E+LDFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15649790"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15649790"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 22:15:22 -0700
X-CSE-ConnectionGUID: EYr1u9baSqOlyCE4C701/Q==
X-CSE-MsgGUID: dkX2JczPSeK+ALyVFhIy1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="42004429"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.224.116]) ([10.124.224.116])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 22:15:18 -0700
Message-ID: <e59e5e1a-a7bc-4649-abbe-f0e64fbfcff3@linux.intel.com>
Date: Thu, 20 Jun 2024 13:15:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/17] KVM: x86/tdp_mmu: Propagate building mirror page
 tables
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, dmatlack@google.com, erdemaktas@google.com,
 isaku.yamahata@gmail.com, linux-kernel@vger.kernel.org, sagis@google.com,
 yan.y.zhao@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-16-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240619223614.290657-16-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/20/2024 6:36 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Integrate hooks for mirroring page table operations for cases where TDX
> will set PTEs or link page tables.
>
> Like other Coco technologies, TDX has the concept of private and shared
> memory. For TDX the private and shared mappings are managed on separate
> EPT roots. The private half is managed indirectly though calls into a
> protected runtime environment called the TDX module, where the shared half
> is managed within KVM in normal page tables.
>
> Since calls into the TDX module are relatively slow, walking private page
> tables by making calls into the TDX module would not be efficient. Because
> of this, previous changes have taught the TDP MMU to keep a mirror root,
> which is separate, unmapped TDP root that private operations can be
> directed to. Currently this root is disconnected from any actual guest
> mapping. Now add plumbing to propagate changes to the "external" page
> tables being mirrored. Just create the x86_ops for now, leave plumbing the
> operations into the TDX module for future patches.
>
> Add two operations for setting up external page tables, one for linking
> new page tables and one for setting leaf PTEs. Don't add any op for
> configuring the root PFN, as TDX handles this itself. Don't provide a
> way to set permissions on the PTEs also, as TDX doesn't support it.
>
> This results is MMU "mirroring" support that is very targeted towards TDX.
                ^
                extra "is"?
> Since it is likely there will be no other user, the main benefit of making
> the support generic is to keep TDX specific *looking* code outside of the
> MMU. As a generic feature it will make enough sense from TDX's
> perspective. For developers unfamiliar with TDX arch it can express the
> general concepts such that they can continue to work in the code.
>
> TDX MMU support will exclude certain MMU operations, so only plug in the
> mirroring x86 ops where they will be needed. For setting/linking, only
> hook tdp_mmu_set_spte_atomic() which is use used for mapping and linking
> PTs. Don't bother hooking tdp_mmu_iter_set_spte() as it is only used for
> setting PTEs in operations unsupported by TDX: splitting huge pages and
> write protecting. Sprinkle a KVM_BUG_ON()s to document as code that these
                             ^
                             extra "a"
> paths are not supported for mirrored page tables. For zapping operations,
> leave those for near future changes.
>
> Many operations in the TDP MMU depend on atomicity of the PTE update.
> While the mirror PTE on KVM's side can be updated atomically, the update
> that happens inside the external operations (S-EPT updates via TDX module
> call) can't happen atomically with the mirror update. The following race
> could result during two vCPU's populating private memory:
>
> * vcpu 1: atomically update 2M level mirror EPT entry to be present
> * vcpu 2: read 2M level EPT entry that is present
> * vcpu 2: walk down into 4K level EPT
> * vcpu 2: atomically update 4K level mirror EPT entry to be present
> * vcpu 2: set_exterma;_spte() to update 4K secure EPT entry => error
>            because 2M secure EPT entry is not populated yet
> * vcpu 1: link_external_spt() to update 2M secure EPT entry
>
> Prevent this by setting the mirror PTE to FROZEN_SPTE while the reflect
> operations are performed. Only write the actual mirror PTE value once the
             ^
             maybe "are being"
> reflect operations has completed. When trying to set a PTE to present and
> encountering a removed SPTE, retry the fault.
                 ^
                 frozen
>
> By doing this the race is prevented as follows:
> * vcpu 1: atomically update 2M level EPT entry to be FROZEN_SPTE
> * vcpu 2: read 2M level EPT entry that is FROZEN_SPTE
> * vcpu 2: find that the EPT entry is frozen
>            abandon page table walk to resume guest execution
> * vcpu 1: link_external_spt() to update 2M secure EPT entry
> * vcpu 1: atomically update 2M level EPT entry to be present (unfreeze)
> * vcpu 2: resume guest execution
>            Depending on vcpu 1 state, vcpu 2 may result in EPT violation
>            again or make progress on guest execution
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU Prep v3:
>   - Rename mirrored->external (Paolo)
>   - Better comment on logic that bugs if doing tdp_mmu_set_spte() on
>     present PTE. (Paolo)
>   - Move zapping KVM_BUG_ON() to proper patch
>   - Use spte_to_child_sp() (Paolo)
>   - Drop unnessary comment in __tdp_mmu_set_spte_atomic() (Paolo)
>   - Rename pfn->pfn_for_gfn to match remove_external_pte in next patch.
>   - Rename REMOVED_SPTE to FROZEN_SPTE (Paolo)
>
> TDX MMU Prep v2:
>   - Split from "KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU"
>   - Rename x86_ops from "private" to "reflect"
>   - In response to "sp->mirrored_spt" rename helpers to "mirrored"
>   - Drop unused old_pfn and new_pfn in handle_changed_spte()
>   - Drop redundant is_shadow_present_pte() check in __tdp_mmu_set_spte_atomic
>   - Adjust some warnings and KVM_BUG_ONs
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  2 +
>   arch/x86/include/asm/kvm_host.h    |  7 +++
>   arch/x86/kvm/mmu/tdp_mmu.c         | 98 ++++++++++++++++++++++++++----
>   3 files changed, 94 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 566d19b02483..3ef19fcb5e42 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -95,6 +95,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
> +KVM_X86_OP_OPTIONAL(link_external_spt)
> +KVM_X86_OP_OPTIONAL(set_external_spte)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d67e88a69fc4..12ff04135a0e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1738,6 +1738,13 @@ struct kvm_x86_ops {
>   	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   			     int root_level);
>   
> +	/* Update external mapping with page table link */
Nit: Add "." at the end of the sentence.

> +	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				void *mirrored_spt);
> +	/* Update the external page table from spte getting set */
Ditto.

> +	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				 kvm_pfn_t pfn_for_gfn);
> +
>   	bool (*has_wbinvd_exit)(void);
>   
>   	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 582e5a045bb7..bc1ad127046d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -244,7 +244,7 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
>   	struct kvm_mmu_page *root;
>   
>   	if (mirror)
> -		role.is_mirror = 1;
> +		role.is_mirror = true;
If this is needed, it's better to be done in "KVM: x86/tdp_mmu: Support 
mirror root for TDP MMU".

>   
>   	/*
>   	 * Check for an existing root before acquiring the pages lock to avoid
> @@ -440,6 +440,59 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>   }
>   
[...]

