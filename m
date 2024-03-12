Return-Path: <kvm+bounces-11625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 991BB878D4A
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DAC228306D
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A67AD5A;
	Tue, 12 Mar 2024 02:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DF2KIUKO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9006E944D;
	Tue, 12 Mar 2024 02:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710212373; cv=none; b=CsYSrGkPCpVkM+9FtK6gKqE8KM4/PsmVILHAUxPYbY17PGpTDXP/KImbFXzRiemnhGX+xUJXkCPCjMq0pH+b0USKPZAVGqJ8qKn1v2DKYxizrfJ42zT9Dj48Av0XOclG1YNgNFG6484ZckOdDtlcBg4kmoTBL12NInsDOs1ZSR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710212373; c=relaxed/simple;
	bh=Sxl6t66ITIwHPGNrR+W7/MelDwyA12T4A8C+abUZIWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BLEYZbLE3mH0shNGKIS+zIkCDPoFmifDqmGFFXN0Ux9FkTF6mZm7E/UOqGHYrgQCmlWdwxyGz4mv7YR7jx7jtfgAOQnzWqrCvzeVVJQgOQPqFdc6DCc96VXOZwAS6OdWwGujfkcwPm+uGKgeHlyn+SUXtDvg1X4Ur0AOiswjb9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DF2KIUKO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710212372; x=1741748372;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Sxl6t66ITIwHPGNrR+W7/MelDwyA12T4A8C+abUZIWo=;
  b=DF2KIUKOB8Uvqa/aC5mBi1HfheMz6twE4gJhm4nVPiilk/9C+68ripJ9
   r6e7SIYQhXFCPKSR280EnDNlvxGqAY7LBmm92LpLQfYgbPGl5iXNhAwxC
   Ny9bMNrQB4LD74R5SHSqvRgT2PzQL5ld8k82Z7ouCct8UpGCSYtSDYPfG
   +2xoxDvoTeaP3GrDCzS9Q8sg3mNs5dKzs89lDg8G0cDiWqE+SN3f3aFh2
   2fdLo7xnqWCEOSm86VtRXbIqpxk8DigQb/Hbb0K2XogzUZr/9tLIA+05U
   SoOycbwSOmItwsPG8EgOjhQYIWy7lPz1ZSWNN4mkRvne2Gp8Ebklfthn/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="16047944"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16047944"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:59:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="42369466"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:59:27 -0700
Message-ID: <6d24f7b1-a271-43de-ba94-847a3c9e0d8c@linux.intel.com>
Date: Tue, 12 Mar 2024 10:59:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if
 private fault hits emulation
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-2-seanjc@google.com>
 <2441bd2a-a0b1-5184-bac8-28c94b151c93@amd.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2441bd2a-a0b1-5184-bac8-28c94b151c93@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/7/2024 8:52 PM, Gupta, Pankaj wrote:
>> Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private 
>> fault
>> triggers emulation of any kind, as KVM doesn't currently support 
>> emulating
>> access to guest private memory.  Practically speaking, private faults 
>> and
>> emulation are already mutually exclusive, but there are edge cases upon
>> edge cases where KVM can return RET_PF_EMULATE, and adding one last 
>> check
>
> edge cases upon edge cases?
>
> Just curious about the details of the edge cases scenarios?

Same question out of curiosity.

>
>> to harden against weird, unexpected combinations is inexpensive.
>>
>> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c          |  8 --------
>>   arch/x86/kvm/mmu/mmu_internal.h | 13 +++++++++++++
>>   2 files changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index e4cc7f764980..e2fd74e06ff8 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4309,14 +4309,6 @@ static inline u8 kvm_max_level_for_order(int 
>> order)
>>       return PG_LEVEL_4K;
>>   }
>>   -static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>> -                          struct kvm_page_fault *fault)
>> -{
>> -    kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
>> -                      PAGE_SIZE, fault->write, fault->exec,
>> -                      fault->is_private);
>> -}
>> -
>>   static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>                      struct kvm_page_fault *fault)
>>   {
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h 
>> b/arch/x86/kvm/mmu/mmu_internal.h
>> index 0669a8a668ca..0eea6c5a824d 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -279,6 +279,14 @@ enum {
>>       RET_PF_SPURIOUS,
>>   };
>>   +static inline void kvm_mmu_prepare_memory_fault_exit(struct 
>> kvm_vcpu *vcpu,
>> +                             struct kvm_page_fault *fault)
>> +{
>> +    kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
>> +                      PAGE_SIZE, fault->write, fault->exec,
>> +                      fault->is_private);
>> +}
>> +
>>   static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, 
>> gpa_t cr2_or_gpa,
>>                       u32 err, bool prefetch, int *emulation_type)
>>   {
>> @@ -320,6 +328,11 @@ static inline int kvm_mmu_do_page_fault(struct 
>> kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>       else
>>           r = vcpu->arch.mmu->page_fault(vcpu, &fault);
>>   +    if (r == RET_PF_EMULATE && fault.is_private) {
>> +        kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
>> +        return -EFAULT;
>> +    }
>> +
>>       if (fault.write_fault_to_shadow_pgtable && emulation_type)
>>           *emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
>
>


