Return-Path: <kvm+bounces-11497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B00E877ACA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 06:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DDC11C214F7
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27463DDB6;
	Mon, 11 Mar 2024 05:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWbVlM1t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49888AD55;
	Mon, 11 Mar 2024 05:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710136228; cv=none; b=ZKc+l8Xm4NAWN6HhqQFNn39MW1wA0ZSaiSzlD6LvWnONLnLSL0BNg7Yz3JfEz0b52azzN22QKTCC0Xh1mNL2akJXV71k9hb571lJWQZkCn9Qj/lCNuuxD0g3q4ipsIvnKOzz8VIm8HuPFsjJzSBrQpAc8fTmh6HfT36rRySxpX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710136228; c=relaxed/simple;
	bh=tFTkwIHFbMWF1tG+3qp3PfDm3XDtdHkyKYz9/9EFam0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cPxyVRIldYI6N/YjQSQFZ6kzElFU/7lUP4QR4OfGB/3wgIJNDXEy15sgR7qIdtVnWZD1m7vzXDkocN11mjNEUgajS2kpVAImhp7lMhT7mUG/yff2OxovOIItJatOtOtOSxWgthhqlXpZR2xfE3KXj3JXZfHK4Bw6NbzjWHg3rEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OWbVlM1t; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710136225; x=1741672225;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tFTkwIHFbMWF1tG+3qp3PfDm3XDtdHkyKYz9/9EFam0=;
  b=OWbVlM1tCE2rB3GofoblqhgrhrN6pTzilUaOhiNRqqDQwq4BJ7h107Zx
   4HpAEW0kcvZ7sJOEzJsGbpnim8549JAUyyG687qW9ypNASSSTNEHoWg3w
   RGLDG4Cji+cU5oQ072YLuPLzxnGw3B1j6GibJ4iKGUiVwRoDE2kS/rJY/
   Ju8ZrVLSHzj2c3QjZn84Uq6FyXejpHkW1z57LO7B6Ni7KHnd18eZ8Yyg0
   cUSer9GkkTdCiDE28+AhpFqkaOnU60EiMoDCr5RaCQqipbFlzIe0T2rU5
   nbNOiOLAnIG6cyNVeKv2PDPWG5gkIOut1rKtBnIzI4ZLo5S+WHyCzynM7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="27252741"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="27252741"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 22:50:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15757161"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.198]) ([10.238.8.198])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 22:50:16 -0700
Message-ID: <75151ba8-87fe-444a-b855-0d2e21b36e05@linux.intel.com>
Date: Mon, 11 Mar 2024 13:50:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 28/35] KVM: SEV: Implement gmem hook for initializing
 private pages
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231230172351.574091-1-michael.roth@amd.com>
 <20231230172351.574091-29-michael.roth@amd.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20231230172351.574091-29-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/31/2023 1:23 AM, Michael Roth wrote:
> This will handle RMP table updates and direct map changes needed to put
> a page into a private state before mapping it into an SEV-SNP guest.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  1 +
>   virt/kvm/guest_memfd.c |  4 +-
>   5 files changed, 104 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 4ec53d6d5773..79c002e1bb5c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -125,6 +125,7 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select KVM_GENERIC_PRIVATE_MEM
> +	select HAVE_KVM_GMEM_PREPARE
>   	help
>   	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
>   	  with Encrypted State (SEV-ES) on AMD processors.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2ac696c436a..91f53f4a6059 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4154,3 +4154,101 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn = start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
> +				 __func__, pfn, start, end, rmp_level);
> +			return false;
> +		}
> +
> +		pfn++;

rmp_level can be got from snp_lookup_rmpentry().
I think the pfn can be updated according to rmp_level to avoid unnecessary
loops for 2MB large page, right?

> +	}
> +
> +	return true;
> +}
> +
> +static u8 max_level_for_order(int order)
> +{
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
> +{
> +	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +
> +	/*
> +	 * If this is a large folio, and the entire 2M range containing the
> +	 * PFN is currently shared, then the entire 2M-aligned range can be
> +	 * set to private via a single 2M RMP entry.
> +	 */
> +	if (max_level_for_order(order) > PG_LEVEL_4K &&
> +	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
> +		return true;
> +
> +	return false;
> +}
> +
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level = PG_LEVEL_2M;
> +		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level = PG_LEVEL_4K;
> +		pfn_aligned = pfn;
> +		gfn_aligned = gfn;
> +	}
> +
> +	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 240518f8d6c7..32cef8626b57 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5065,6 +5065,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>   	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare = sev_gmem_prepare,
>   };
>   
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d953ae41c619..9ece9612dbb9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -725,6 +725,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>   struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>   void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   
>   /* vmenter.S */
>   
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index feec0da93d98..ddea45279fef 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -66,8 +66,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>   		gfn = slot->base_gfn + index - slot->gmem.pgoff;
>   		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}


