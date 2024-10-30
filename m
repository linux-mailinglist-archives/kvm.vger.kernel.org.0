Return-Path: <kvm+bounces-29989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 685A09B5A2B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 04:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C65A2846CC
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 03:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D946D194AF4;
	Wed, 30 Oct 2024 03:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I80j+7DC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA67E9454;
	Wed, 30 Oct 2024 03:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730257427; cv=none; b=na0g6WCWbDh35dbyOC2mgD5DBMjB2lWD1ndkQ2tkMXyuFd/uG4zqtnV6ez03CRXR18UVVPcpM7lD49czgCxxPlrMGJgWdRURJjyez21r5KRv2/JR/y2NZKnzVd0JWlwnwVrpHdNPI8Z5yjJxV+GtktRySFlUKRrpoK8qifVjorM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730257427; c=relaxed/simple;
	bh=KU8k3FnOxb8v1r7cvCsphwi31r6zyCks3F6SyZ23myQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=okw8BLZRAlVpBE9P6mqs9jtSor+csO+Ub9teTTwwE5CxfHECcE/3p6Baj4YWM2xqPJVJJ9MNd7RmimoQsr8b/vzzjg1Y+eE7ZktXoJHmfO/WoipgnrMLihouCzfKj4IC56Wybsbn0yUm4t6odmdK48y/OGKO2KVrV7iDcuQ5Hb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I80j+7DC; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730257425; x=1761793425;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KU8k3FnOxb8v1r7cvCsphwi31r6zyCks3F6SyZ23myQ=;
  b=I80j+7DCpyq6scVQhsKJ5woGd7q6yd3uRfOHqHtp+wnyb2rT0oQpt33U
   Tcllug8z/3mOBrvPL8VxKa1K0iQJeWIj88pFV4mOb3aQ16m0r/1MILz5W
   zKxhtd83/eBVFk2x7M8ht3ggnzhxjd6G0QbWxiP+Do5DKlvrm+36WymOj
   /eEI9tY2nNHC0WMwQRiwCHAlU/9woeMchx4Uqps+GJRgh+yQwxLGdvQNC
   yo16dpkEXzgjEqfjwi8oQZPGvuIr49+414Hj9+tJbyAUTYPlJ0KcIGV79
   jGgRv2n5lDv1EHMgMvCZb/xYurJ7yCRN+0ITKZ7Q3C8vcBLapD96mz3E2
   w==;
X-CSE-ConnectionGUID: Skdg8clATXeMx2BuZz+dvQ==
X-CSE-MsgGUID: VyTgs+j/Ta21ZfdGjHNSyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="47420117"
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="47420117"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 20:03:44 -0700
X-CSE-ConnectionGUID: Hbhfu/3sS2uzQahYNQ2+Dg==
X-CSE-MsgGUID: 1NcZzNDCRRmHlIGRsuLWoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="82338128"
Received: from unknown (HELO [10.238.4.167]) ([10.238.4.167])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 20:03:42 -0700
Message-ID: <35dc9358-0b1a-4325-818e-27ccdab7669b@linux.intel.com>
Date: Wed, 30 Oct 2024 11:03:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240904030751.117579-15-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 9/4/2024 11:07 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
[...]
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6feb3ab96926..b8cd5a629a80 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -447,6 +447,177 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>   }
>   
> +static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	put_page(page);
Nit: It can be
put_page(pfn_to_page(pfn));


> +}
> +
> +static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> +			    enum pg_level level, kvm_pfn_t pfn)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	u64 entry, level_state;
> +	u64 err;
> +
> +	err = tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
Nit:
Usually, kernel prefers to handle and return for error conditions first.

But for this case, for all error conditions, it needs to unpin the page.
Is it better to return the successful case first, so that it only needs
to call tdx_unpin() once?

> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EAGAIN;
> +	}
> +	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
> +		if (tdx_get_sept_level(level_state) == tdx_level &&
> +		    tdx_get_sept_state(level_state) == TDX_SEPT_PENDING &&
> +		    is_last_spte(entry, level) &&
> +		    spte_to_pfn(entry) == pfn &&
> +		    entry & VMX_EPT_SUPPRESS_VE_BIT) {
Can this condition be triggered?
For contention from multiple vCPUs, the winner has frozen the SPTE,
it shouldn't trigger this.
Could KVM  do page aug for a same page multiple times somehow?


> +			tdx_unpin(kvm, pfn);
> +			return -EAGAIN;
> +		}
> +	}
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> +		tdx_unpin(kvm, pfn);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> +			      enum pg_level level, kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	/* TODO: handle large pages. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return -EINVAL;
> +
> +	/*
> +	 * Because guest_memfd doesn't support page migration with
> +	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> +	 * migration.  Until guest_memfd supports page migration, prevent page
> +	 * migration.
> +	 * TODO: Once guest_memfd introduces callback on page migration,
> +	 * implement it and remove get_page/put_page().
> +	 */
> +	get_page(pfn_to_page(pfn));
> +
> +	if (likely(is_td_finalized(kvm_tdx)))
> +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> +
> +	/*
> +	 * TODO: KVM_MAP_MEMORY support to populate before finalize comes
> +	 * here for the initial memory.
> +	 */
> +	return 0;
Is it better to return error before adding the support?

> +}
> +
[...]


