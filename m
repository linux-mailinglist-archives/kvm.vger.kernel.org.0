Return-Path: <kvm+bounces-48308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A191ACCA42
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AEDC3A4727
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4149523C515;
	Tue,  3 Jun 2025 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ApP+cVUh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353B522FE02
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748964722; cv=none; b=t7EyWqCnpSyHJ0HthbuYYGo+I2fWjOhNZRjzJf/Gpgkfm5yTsIYyYb+12yzeu7R9cOQeM10L7Cv/MxDiFKbOU+q1d9dfvqVGUHtRtNaWHX+5MeuJwGYmfHtrBS9c3T6SG3I6qqeXNyD4Bv7j/AaNfjSnHeJumknuXGnYqbkgaOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748964722; c=relaxed/simple;
	bh=FaKpJR92FYKwrFzDdNvsIRCSUqaTqILalsYWRqoVEog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AExmcYFuljXxn5gQQkunVBL6DjC5s1erFsWJXyrb/kEMw2N0Kslg+Fn5eUBSNFlAAgp+n1pq1v+YAYTUklShHeeDwZxDUGriO4iXDuq0M8/moJcFiS+TtNKOqEY60OrcWCR9TV+WievajjveSsLag0vw0VJt3Lva64PIJNRc5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ApP+cVUh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748964720; x=1780500720;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FaKpJR92FYKwrFzDdNvsIRCSUqaTqILalsYWRqoVEog=;
  b=ApP+cVUhSvluDcdArZlevfdCA5wzRMO+PD90FEbCApng/aCIznfmDqQH
   gaTRYAFEQbnmJIJ2We7LrTY9coh5JVc+n7cjyUDXpSmeJEO5HKEgkK5FI
   JnSAUbmNAYxw91zk/iIpQYkgJbZrElP0JxTLQRhRSQoTOSHp/jfwykcYB
   cnWVcVnYePZmD+K0kFWnhg/pfMy8dpGLE6zlDYvvpftAgQftt7Ze3G7Ie
   WScxfPDicvQcR7z7BqTBnabtbhn2HNU9NP2oCk7fVqpVFZQXIGj71B7aJ
   NGuj459y35DyZ7XHvGg68EYyPdkcfLeEyCzGHwJTJSsbK1IbPcRHB0D5m
   A==;
X-CSE-ConnectionGUID: 5NyHGJq1Q8mXq9eRW/Tb8g==
X-CSE-MsgGUID: ArnvWlodQQeEL0ddfGhDvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61632047"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="61632047"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 08:31:57 -0700
X-CSE-ConnectionGUID: kAyvpBaKQbOil1kptopFJA==
X-CSE-MsgGUID: 0LPSJby8Tfau3DHAS0PZqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="149669955"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 08:31:55 -0700
Message-ID: <9962b691-056e-4ee0-8345-5b5657c5376b@intel.com>
Date: Tue, 3 Jun 2025 23:31:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
To: Paolo Bonzini <pbonzini@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Michael Roth <michael.roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
 <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
 <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
 <d0983ba3-383b-4c81-9cfd-b5b0d26a5d17@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <d0983ba3-383b-4c81-9cfd-b5b0d26a5d17@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/2025 11:00 PM, Paolo Bonzini wrote:
> On 6/3/25 13:47, Xiaoyao Li wrote:
>> On 6/3/2025 3:41 PM, Xiaoyao Li wrote:
>>> On 3/29/2025 4:30 AM, Tom Lendacky wrote:
>>>> A page state change is typically followed by an access of the 
>>>> page(s) and
>>>> results in another VMEXIT in order to map the page into the nested page
>>>> table. Depending on the size of page state change request, this can
>>>> generate a number of additional VMEXITs. For example, under SNP, when
>>>> Linux is utilizing lazy memory acceptance, memory is typically 
>>>> accepted in
>>>> 4M chunks. A page state change request is submitted to mark the 
>>>> pages as
>>>> private, followed by validation of the memory. Since the guest_memfd
>>>> currently only supports 4K pages, each page validation will result in
>>>> VMEXIT to map the page, resulting in 1024 additional exits.
>>>>
>>>> When performing a page state change, invoke KVM_PRE_FAULT_MEMORY for 
>>>> the
>>>> size of the page state change in order to pre-map the pages and 
>>>> avoid the
>>>> additional VMEXITs. This helps speed up boot times.
>>>
>>> Unfortunately, it breaks TDX guest.
>>>
>>>    kvm_hc_map_gpa_range gpa 0x80000000 size 0x200000 attributes 0x0 
>>> flags 0x1
>>>
>>> For TDX guest, it uses MAPGPA to maps the range [0x8000 0000, 
>>> +0x0x200000] to shared. The call of KVM_PRE_FAULT_MEMORY on such 
>>> range leads to the TD being marked as bugged
>>>
>>> [353467.266761] WARNING: CPU: 109 PID: 295970 at arch/x86/kvm/mmu/ 
>>> tdp_mmu.c:674 tdp_mmu_map_handle_target_level+0x301/0x460 [kvm]
>>
>> It turns out to be a KVM bug.
>>
>> The gpa passed in in KVM_PRE_FAULT_MEMORY, i.e., range->gpa has no 
>> indication for share vs. private. KVM directly passes range->gpa to 
>> kvm_tdp_map_page() in kvm_arch_vcpu_pre_fault_memory(), which is then 
>> assigned to fault.addr
>>
>> However, fault.addr is supposed to be a gpa of real access in TDX 
>> guest, which means it needs to have shared bit set if the map is for 
>> shared access, for TDX case. tdp_mmu_get_root_for_fault() will use it 
>> to determine which root to be used.
>>
>> For this case, the pre fault is on the shared memory, while the 
>> fault.addr leads to mirror_root which is for private memory. Thus it 
>> triggers KVM_BUG_ON().
> So this would fix it?
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7b3f1783ab3c..66f96476fade 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4895,6 +4895,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct 
> kvm_vcpu *vcpu,
>   {
>       u64 error_code = PFERR_GUEST_FINAL_MASK;
>       u8 level = PG_LEVEL_4K;
> +    u64 direct_bits;
>       u64 end;
>       int r;
> 
> @@ -4909,15 +4910,18 @@ long kvm_arch_vcpu_pre_fault_memory(struct 
> kvm_vcpu *vcpu,
>       if (r)
>           return r;
> 
> +    direct_bits = 0;
>       if (kvm_arch_has_private_mem(vcpu->kvm) &&
>           kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
>           error_code |= PFERR_PRIVATE_ACCESS;
> +    else
> +        direct_bits = kvm_gfn_direct_bits(vcpu->kvm);

should be

	direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));

> 
>       /*
>        * Shadow paging uses GVA for kvm page fault, so restrict to
>        * two-dimensional paging.
>        */
> -    r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
> +    r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, 
> &level);
>       if (r < 0)
>           return r;
> 
> 
> 
> I'm applying Tom's patch to get it out of his queue, but will delay sending
> a pull request until the Linux-side fix is accepted.

With above mentioned change, it can fix the issue.

Me synced with Yan offline, and our fix is:

diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 52acf99d40a0..209103bf0f30 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -48,7 +48,7 @@ static inline enum kvm_tdp_mmu_root_types 
kvm_gfn_range_filter_to_root_types(str
  static inline struct kvm_mmu_page *tdp_mmu_get_root_for_fault(struct 
kvm_vcpu *vcpu,
                                                               struct 
kvm_page_fault *fault)
  {
-       if (unlikely(!kvm_is_addr_direct(vcpu->kvm, fault->addr)))
+       if (unlikely(fault->is_private))
                 return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);

         return root_to_sp(vcpu->arch.mmu->root.hpa);

> Paolo
> 
> 


