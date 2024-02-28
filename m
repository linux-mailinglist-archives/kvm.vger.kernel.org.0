Return-Path: <kvm+bounces-10305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A3886B912
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 21:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62DF828A645
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 20:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A066C1474CF;
	Wed, 28 Feb 2024 20:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BR6G5g8I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9F75E068;
	Wed, 28 Feb 2024 20:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709152150; cv=none; b=ag5PH8astIBaqBE3lwAx88GrTIzp9jdCWXgtLEfZMMKLPKNRoVZldkfKnRKMhBnKraW4ir0kFNkricRiEJz/6a5/IUlD6rTlJMIcq9XaHMGJe7vENLBjsx8/u7cUq4qCusmujOYct/UeihVR8DsyMutJUp89PjItmTfw2M8MGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709152150; c=relaxed/simple;
	bh=TWmXO+E2jGYeoRyN3F8HU+r+G7vutEdFGwwl2ryKsSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mb8lL0X+z0SMlOZM4rgLFLYBMJescoSmMIiJ2BSHfzsN9Ra8ug+SK3LB+FyM+egTZPM1PizbMUbLaGBXAiiLUD1wYc19GoWf6V5R0gsvcc47nuNscJY9U6eYkjwkW3RoJdp48ky+3Ziek1JAU+T+m6GCQ/iB8kjO4PwvcTJk9XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BR6G5g8I; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709152148; x=1740688148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TWmXO+E2jGYeoRyN3F8HU+r+G7vutEdFGwwl2ryKsSk=;
  b=BR6G5g8Iei5lsWcjr3sIKYLki3sQSDgemZaTO9Lah5lbUWEfjygWkueb
   MxGWXTFDEku0a0GdvsJ0G+pTyyuQhRu0dBE1GYGXmOK1XclQ17j1pLiPb
   2Ytr4H9e5aCBkmihPyr30RkaMk8Oi2UdLLLRCc8rt9oDIaM8607u4bFNM
   Jzasp7xhUsIlCPIr9L8puBp/HFuIqSzxELdCW4RLkVs4OStrc7PQ2jtji
   o5aYujY21vWtmj/Q7tcgz/Cjb7GfFamexHQ+cMN501uNwnLaTrXP/1DMW
   Ml8LHJwoC9zIf1qj+Uo4BHTGo/xUe8MPSf4+26Al+igos8R1qnbf/rpQT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="26048805"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="26048805"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 12:29:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="45083738"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 12:29:08 -0800
Date: Wed, 28 Feb 2024 12:29:06 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 18/21] KVM: x86: Add gmem hook for initializing memory
Message-ID: <20240228202906.GB10568@ls.amr.corp.intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-19-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240227232100.478238-19-pbonzini@redhat.com>

On Tue, Feb 27, 2024 at 06:20:57PM -0500,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> guest_memfd pages are generally expected to be in some arch-defined
> initial state prior to using them for guest memory. For SEV-SNP this
> initial state is 'private', or 'guest-owned', and requires additional
> operations to move these pages into a 'private' state by updating the
> corresponding entries the RMP table.
> 
> Allow for an arch-defined hook to handle updates of this sort, and go
> ahead and implement one for x86 so KVM implementations like AMD SVM can
> register a kvm_x86_ops callback to handle these updates for SEV-SNP
> guests.
> 
> The preparation callback is always called when allocating/grabbing
> folios via gmem, and it is up to the architecture to keep track of
> whether or not the pages are already in the expected state (e.g. the RMP
> table in the case of SEV-SNP).
> 
> In some cases, it is necessary to defer the preparation of the pages to
> handle things like in-place encryption of initial guest memory payloads
> before marking these pages as 'private'/'guest-owned', so also add a
> helper that performs the same function as kvm_gmem_get_pfn(), but allows
> for the preparation callback to be bypassed to allow for pages to be
> accessed beforehand.
> 
> Link: https://lore.kernel.org/lkml/ZLqVdvsF11Ddo7Dq@google.com/
> Co-developed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-Id: <20231230172351.574091-5-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 |  6 +++
>  include/linux/kvm_host.h           | 14 ++++++
>  virt/kvm/Kconfig                   |  4 ++
>  virt/kvm/guest_memfd.c             | 72 +++++++++++++++++++++++++++---
>  6 files changed, 92 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index ac8b7614e79d..adfaad15e7e6 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -139,6 +139,7 @@ KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
>  
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7de8a3f2a118..6d873d08f739 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1804,6 +1804,7 @@ struct kvm_x86_ops {
>  	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>  
>  	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
> +	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f10a5a617120..eff532ea59c9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13598,6 +13598,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
> +{
> +	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> +}
> +#endif
>  
>  int kvm_spec_ctrl_test_value(u64 value)
>  {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 97afe4519772..03bf616b7308 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2434,6 +2434,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #ifdef CONFIG_KVM_PRIVATE_MEM
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
> +int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> +		            gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
>  #else
>  static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn,
> @@ -2442,6 +2444,18 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  	KVM_BUG_ON(1, kvm);
>  	return -EIO;
>  }
> +
> +static inline int kvm_gmem_get_uninit_pfn(struct kvm *kvm,
> +				          struct kvm_memory_slot *slot, gfn_t gfn,
> +				          kvm_pfn_t *pfn, int *max_order)
> +{
> +	KVM_BUG_ON(1, kvm);
> +	return -EIO;
> +}
>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>  
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
> +#endif
> +
>  #endif
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index a11e9c80fac9..dcce0c3b5b13 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -111,3 +111,7 @@ config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_PRIVATE_MEM
>         bool
> +
> +config HAVE_KVM_GMEM_PREPARE
> +       bool
> +       depends on KVM_PRIVATE_MEM
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index de0d5a5c210c..7ec7afafc960 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -13,12 +13,50 @@ struct kvm_gmem {
>  	struct list_head entry;
>  };
>  
> -static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> +static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
> +{
> +#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> +	struct kvm_gmem *gmem;
> +
> +	list_for_each_entry(gmem, gmem_list, entry) {
> +		struct kvm_memory_slot *slot;
> +		struct kvm *kvm = gmem->kvm;
> +		struct page *page;
> +		kvm_pfn_t pfn;
> +		gfn_t gfn;
> +		int rc;
> +
> +		slot = xa_load(&gmem->bindings, index);
> +		if (!slot)
> +			continue;
> +
> +		page = folio_file_page(folio, index);
> +		pfn = page_to_pfn(page);
> +		gfn = slot->base_gfn + index - slot->gmem.pgoff;
> +		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
> +		if (rc) {
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
> +					    index, rc);
> +			return rc;
> +		}
> +	}
> +
> +#endif
> +	return 0;
> +}

Can we make it conditional?

TDX doesn't need prepare hook to set gmem_parepare = NULL.  With large memory
guest(several hundreds Gbyte) to lookup page cache, this loop slows down guest
startup. I think it would also applies to SW_PROTECTED_VM (and pKVM in future).

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3835732491b9..cafb8d0997b5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -842,6 +842,9 @@ struct kvm {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
        /* Protected by slots_locks (for writes) and RCU (for reads) */
        struct xarray mem_attr_array;
+#endif
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+       bool gmem_need_prepare;
 #endif
        char stats_id[KVM_STATS_NAME_SIZE];
 };
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 74e19170af8a..ab7d0f7d3d38 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -16,6 +16,7 @@ struct kvm_gmem {
 static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+       rc = kvm_arch_gmem_prepare(inode, index, folio);
        struct list_head *gmem_list = &inode->i_mapping->i_private_list;
        struct kvm_gmem *gmem;
 
@@ -27,6 +28,9 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
                gfn_t gfn;
                int rc;
 
+               if (!kvm->gmem_need_prepare)
+                       continue;
+
                slot = xa_load(&gmem->bindings, index);
                if (!slot)
                        continue;

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

