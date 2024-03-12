Return-Path: <kvm+bounces-11608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5032D878C05
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:49:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E621BB212E7
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 00:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5340C15BF;
	Tue, 12 Mar 2024 00:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACcM5M9b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B623663A;
	Tue, 12 Mar 2024 00:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710204546; cv=none; b=Z27mzcof5WElEaewsn4FGrnAoqoxWPP35WK5r/OmSV4qwKQyhTaJqbx6wbUHk6mskUL/PMl3AJ+duiICqRX/3Us8N8Psvuv5XPd1jaZWreJLZO+ipCesdV4+UU9WWOT0neeXE2RkyynrVOEo8fG8zwNjt+4M/V3pRRMd0s0QbyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710204546; c=relaxed/simple;
	bh=9TL859kAz6MNTwXWb2gchLa6ho+GqIpgMKGxXDR4m0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpwcMK1/0OR15aObnGPyfkUrvANPtOXs/1aE0TlPwGYiLEDkJSSX+pizzk/OeBOh48IBksqWk6c3VmdR0iFS1UOYrBi+TYtjMt2mUKFEt4frDd3TJqgrcaR7iT8R8BT8+OhkelfCGq5k2XiyIyrTSx2ZjK/xv3Pdik4Y6SENgLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACcM5M9b; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710204545; x=1741740545;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9TL859kAz6MNTwXWb2gchLa6ho+GqIpgMKGxXDR4m0g=;
  b=ACcM5M9bDmj5totl969sIKxJVIHzmTw/iYMt2YAFcaSsMEqOsxy+fncU
   QfaWF3+3dWIGw0AJrz68zVa/NyOmJVzby71n8GhGd0+YLmy1D22jtbnyD
   wyWbnbUgfvcYo7BrUJEpz8ODts5G4t1HlkeKeJvOp35OsPymkM3+tazxe
   5hl0TPgp/ozaEJG8vPf3n1kk1PsZ9ATU0Z/HIMmLTSLAXU2QO8Ltcy0fu
   0KBvUL5K+P83CQ5+necbuiMikUZfVdDmQrsAj4ZeBjKOEefmLkO865HKm
   T/BckppnLpzXxQnNNPwIP02uphRkMRLsXr5fHM8vQzybvT9HbyMB0T+Wj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="8656546"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="8656546"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 17:49:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11259989"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 17:49:02 -0700
Message-ID: <35bc4582-8a03-413b-be0e-4cc419715772@linux.intel.com>
Date: Tue, 12 Mar 2024 08:48:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/21] KVM: x86: Add gmem hook for determining max NPT
 mapping level
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-22-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240227232100.478238-22-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:21 AM, Paolo Bonzini wrote:
> From: Michael Roth <michael.roth@amd.com>
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
>
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
>
> Add a hook to determine the max NPT mapping size in situations like
> this.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Message-Id: <20231230172351.574091-31-michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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

Since it's named "gmem_validate_fault", can we just passed in the 
"fault" as
an argument to avoid passing in pfn, gfn, max_level individually?
I noticed in Isaku's TDX patch set, fault->private would also need to be
passed in.

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


