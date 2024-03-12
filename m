Return-Path: <kvm+bounces-11607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5EA5878BF9
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59E76282457
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D14915BF;
	Tue, 12 Mar 2024 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TYeK7gbU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C15063C;
	Tue, 12 Mar 2024 00:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710204004; cv=none; b=aAveOlbGuNVA5abAlIXVRTX1CFGFazN/kNeQ9CjPMwexl/9AkKxhd/tUbpzuI3P+2506pz/USbZ4QOnoHRfKOr5GfUIoR0mD7OCMPid5msMsUjh2IfxNG/c0d2qzpdwnLK6Qndf3qxKlud/aYTDxh7JPMfXADoPMRmCkftPyvLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710204004; c=relaxed/simple;
	bh=TVP1c9LRa4PI7mhKO6pbClkiwq07NdPr2Iczsma9oJg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=X+E+m1RSxxN6U8FaDClwRkhLYisQBRmxGG3S01eQgwGcC64khd3WeBIShUPdpx4J2VTasBZzNHmBQYQpw2sSjsWCYK+GT7lMdYdtCVyrMzbdjEczYAh8hoiDwTbFdOa8bahMZgUwP3QhxponKjoKdPCq7UgIb2baCbM5H/iRdWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TYeK7gbU; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710204002; x=1741740002;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=TVP1c9LRa4PI7mhKO6pbClkiwq07NdPr2Iczsma9oJg=;
  b=TYeK7gbU7gnoI33tXvGWqcxtew1sDQCvx0rBZURx1HxuD6aV26TXJqpw
   Tty9ntKKPSWFt7WKHEn7mBTuajGmWMkl99FbJbsSWpKZ7ZABlE+HyZDTB
   l3FESIZC4byJkAcmPfIwPkJsXvgnkb5Z7ycrJMcO9XyOBQ/uhteWbb2tP
   wlAurUc4g3LHQD1ttxHX+CTR7zcikpTzVRy8KCACKaXr8LH6KVV4xr26I
   9iDyUn1BFWOlRoBqFdYDeyozAVPVJ6k9zXIlD2wL5C0UbyUOlRUocAExf
   cqWTxiYUU9hjCGlSiMVU13/nsKodn71nNE6Qez/XS2tZY4zbgRqhWo2xB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5078310"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="5078310"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 17:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="15835061"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 17:39:59 -0700
Message-ID: <d20abcde-2d54-45cb-b821-1ff1af5cbb86@linux.intel.com>
Date: Tue, 12 Mar 2024 08:39:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 21/21] KVM: x86: Add gmem hook for determining max NPT
 mapping level
To: Paolo Bonzini <pbonzini@redhat.com>, michael.roth@amd.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-22-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-22-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:21 AM, Paolo Bonzini wrote:
> From: Michael Roth<michael.roth@amd.com>
>
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
>
>    - gmem allocates 2MB page
>    - guest issues PVALIDATE on 2MB page
>    - guest later converts a subpage to shared
>    - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>    - KVM MMU splits NPT mapping to 4K

Is here a sentence missing that "guest converts the shared subpage back
to private"?
Otherwise, it conflicts with the following statement "there are no mixed
attributes".


> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
>
> Add a hook to determine the max NPT mapping size in situations like
> this.
>
> Signed-off-by: Michael Roth<michael.roth@amd.com>
> Message-Id:<20231230172351.574091-31-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h | 1 +
>   arch/x86/include/asm/kvm_host.h    | 1 +
>   arch/x86/kvm/mmu/mmu.c             | 7 +++++++
>   3 files changed, 9 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 42474acb7375..436e3c157fae 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -140,6 +140,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>   KVM_X86_OP_OPTIONAL(get_untagged_addr)
>   KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> +KVM_X86_OP_OPTIONAL_RET0(gmem_validate_fault)
>   KVM_X86_OP_OPTIONAL(gmem_invalidate)
>   
>   #undef KVM_X86_OP
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e523b204697d..259e6bb1e447 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1806,6 +1806,7 @@ struct kvm_x86_ops {
>   	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
>   	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
>   };
>   
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6b4cb71668df..bcf12ac489f9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4339,6 +4339,13 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   			       fault->max_level);
>   	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>   
> +	r = static_call(kvm_x86_gmem_validate_fault)(vcpu->kvm, fault->pfn,
> +						     fault->gfn, &fault->max_level);
> +	if (r) {
> +		kvm_release_pfn_clean(fault->pfn);
> +		return r;
> +	}
> +
>   	return RET_PF_CONTINUE;
>   }
>   


