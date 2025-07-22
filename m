Return-Path: <kvm+bounces-53072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 834EBB0D150
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC48544934
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545A228C871;
	Tue, 22 Jul 2025 05:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRvFTwwy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE39E28A723;
	Tue, 22 Jul 2025 05:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753162887; cv=none; b=dZVqXQTQAMYGrXWBJvN0uTs4DbrRIkHr2mMBZokOKWmaX16i+tmK108cjXe9q01ThPE5NmL3hJowB4q4wfvGIrrcHhGRy+Ht1hSlAk3b4ur6ZhoCrJC7CspKbYmPUZHlHjv+EVB7eDzpXCZkW62JVVhpdbEZkJHabrZMummnWUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753162887; c=relaxed/simple;
	bh=iBcyx2fSDKLp4DgJonC8/dTTFfildOPqKcy+wY7eDR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TEJpiKSm6n2EYhwrSOX01lyae+dff+hKQcsWU+3Uy12HwJlmQXCfBSUKLixhM6rvNucKAduFdXyyHj0gI81ogjqAdUrxRCt0VSf+YTTEKzDsrWWtm+L+JnbeY3bFhBJ5H4iP2YYvSr4F5TpmHI7rerB8jvyCKXkBCxkwRsVKH3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aRvFTwwy; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753162886; x=1784698886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iBcyx2fSDKLp4DgJonC8/dTTFfildOPqKcy+wY7eDR8=;
  b=aRvFTwwyxAavSnshq5C1uuYZM8omiJ3gfahFpYfz3PVNsw6cKLn8SS8Z
   IihJRpImXmm6KH3f/Cxz2rJjdvHrLyoVQRr2LGKEcBto3ZZmHL24EgFfJ
   OgIo4sKFWFu+vDsQ+WrDBS2iFefC3p7ZKPKE5Os/jPB8W2x82HodQhNA4
   v+o6uVGiHbBIt92ZnkRAAxNolOBx4q9/uGrZw5fcubEnUTsjc4L7symob
   tbXf6t8prJnh+Un9ihuifSBYblsTaUNQB9RkIqV+pnwqHEiHq7tnlV873
   +SXckUQUmXADL/iGzax9ysFRPQsJ6XaOEsriUcWrkMIe88eUl2V/jkz4P
   A==;
X-CSE-ConnectionGUID: gRg2XLPkTvaAdVTc7HshRA==
X-CSE-MsgGUID: DI+DjBFvQMa2MFcODoV9vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="43014904"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="43014904"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:41:25 -0700
X-CSE-ConnectionGUID: bezS+jBDRN+5mqBAM7TZNg==
X-CSE-MsgGUID: vOIeWFnkTQytfKFYUDSdcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="158338964"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:41:09 -0700
Message-ID: <27ac6ed0-f58a-4926-a069-8d9d7d61a41c@intel.com>
Date: Tue, 22 Jul 2025 13:41:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-14-tabba@google.com> <aH5vNqPrUFgtZCqU@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH5vNqPrUFgtZCqU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/2025 12:47 AM, Sean Christopherson wrote:
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Update the KVM MMU fault handler to service guest page faults
>> for memory slots backed by guest_memfd with mmap support. For such
>> slots, the MMU must always fault in pages directly from guest_memfd,
>> bypassing the host's userspace_addr.
>>
>> This ensures that guest_memfd-backed memory is always handled through
>> the guest_memfd specific faulting path, regardless of whether it's for
>> private or non-private (shared) use cases.
>>
>> Additionally, rename kvm_mmu_faultin_pfn_private() to
>> kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
>> pages from guest_memfd for both private and non-private memory,
>> accommodating the new use cases.
>>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Co-developed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 94be15cde6da..ad5f337b496c 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>>   				 r == RET_PF_RETRY, fault->map_writable);
>>   }
>>   
>> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>> -				       struct kvm_page_fault *fault)
>> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>> +				    struct kvm_page_fault *fault)
>>   {
>>   	int max_order, r;
>>   
>> @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>   	return RET_PF_CONTINUE;
>>   }
>>   
>> +static bool fault_from_gmem(struct kvm_page_fault *fault)
> 
> Drop the helper.  It has exactly one caller, and it makes the code *harder* to
> read, e.g. raises the question of what "from gmem" even means.  If a separate
> series follows and needs/justifies this helper, then it can/should be added then.

there is another place requires the same check introduced by your
"KVM: x86/mmu: Extend guest_memfd's max mapping level to shared 
mappings" provided in [*]

[*] https://lore.kernel.org/kvm/aH7KghhsjaiIL3En@google.com/

---
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ff7582d5fae..2d1894ed1623 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c

@@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, 
struct kvm_page_fault *fault,
         if (max_level == PG_LEVEL_4K)
                 return PG_LEVEL_4K;

-       if (is_private)
-               host_level = kvm_max_private_mapping_level(kvm, fault, 
slot, gfn);
+       if (is_private || kvm_memslot_is_gmem_only(slot))
+               host_level = kvm_gmem_max_mapping_level(kvm, fault, 
slot, gfn,
+                                                       is_private);
         else
                 host_level = host_pfn_mapping_level(kvm, gfn, slot);
         return min(host_level, max_level);

>> +{
>> +	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
>> +}
>> +
>>   static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>>   				 struct kvm_page_fault *fault)
>>   {
>>   	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>>   
>> -	if (fault->is_private)
>> -		return kvm_mmu_faultin_pfn_private(vcpu, fault);
>> +	if (fault_from_gmem(fault))
>> +		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>>   
>>   	foll |= FOLL_NOWAIT;
>>   	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
>> -- 
>> 2.50.0.727.gbf7dc18ff4-goog
>>


