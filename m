Return-Path: <kvm+bounces-12705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 759CC88C832
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B8061F27943
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 15:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B69113C8EC;
	Tue, 26 Mar 2024 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dM6mSoOO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC586AF85;
	Tue, 26 Mar 2024 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711468602; cv=none; b=Yj7k+fcaQL5xAxWNokjAtwHMJTNDJ2kNOK2MgQfbrodyCjKZ22Lim9zn2qTNBF9nsvWDUswtEX7RFh8SDiumXpn5llKCzpQ1eTsAvn8HrlH5jaFS2MMG5RsGfwqSxwGOpP5GNZJS6CWmwbnL77Slk2LPEXDta2JIMVDtbICu16E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711468602; c=relaxed/simple;
	bh=7zSnmZvqIpBKuNdtr4g7033y1zN+MsTfLVhiT3kPAG0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nfEZ9cBdG6vdAdFh5gVBw5n6wcU4hhPLRaJy0FDLHvlfygCedj5N4H/2kMgeb4O2E/C6xoQwRsziuiOcOP12VU1o7c9wCzYKIf3OjKXILcnm9AqY3Giff2fuOT+utHQe1WOfvOtcEK+wi0ziIKq5Qc71p2VZ7XU6D22XnCxHRg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dM6mSoOO; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711468601; x=1743004601;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=7zSnmZvqIpBKuNdtr4g7033y1zN+MsTfLVhiT3kPAG0=;
  b=dM6mSoOOjGlWaHtC/TpoNVO2zrut/HYR9uc/b65fRfFxPiBR51cNYh4w
   xT8mSTmkT6Fe7d9hoh2IV9nte3e3t1W02JypNUMfvyPPOoxa1ug/xb5qV
   WfNRoChWBbtVMFp7Tx5led/fh77fiQkPBDqBjhGDo3XujiF3xQtn4rSRk
   6RppdIlHXoJ/M9VSJOJF9yWavxuztjiAeV8JUiqsEPEH8z4W0cz9Szr61
   X2+F3EJriQwIZtWfj0huXZInV+zcGKxYhg4JmrF2mW4wWrtQBfH9fuAOj
   71jW80ecph+tQ2DNQD2g0m7/BpJLhx96vWqzErCSjzDH+zZ+6cFq320NA
   g==;
X-CSE-ConnectionGUID: rphYpOdLSu223Zei2Py9Zg==
X-CSE-MsgGUID: yAIhvQGCRmmqFCtRnk3jrw==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6634265"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="6634265"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 08:56:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="16039150"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 08:56:38 -0700
Message-ID: <4d0d9f64-4cc4-4c1e-ba27-ff70c9827570@linux.intel.com>
Date: Tue, 26 Mar 2024 23:56:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/21] KVM: Allow page-sized MMU caches to be initialized
 with custom 64-bit values
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-3-pbonzini@redhat.com>
 <6bd61607-9491-4517-8fc8-8d61d9416cab@linux.intel.com>
In-Reply-To: <6bd61607-9491-4517-8fc8-8d61d9416cab@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/5/2024 2:55 PM, Binbin Wu wrote:
>
>
> On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Add support to MMU caches for initializing a page with a custom 64-bit
>> value, e.g. to pre-fill an entire page table with non-zero PTE values.
>> The functionality will be used by x86 to support Intel's TDX, which 
>> needs
>> to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
>> faults from getting reflected into the guest (Intel's EPT Violation #VE
>> architecture made the less than brilliant decision of having the per-PTE
>> behavior be opt-out instead of opt-in).
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Message-Id: 
>> <5919f685f109a1b0ebc6bd8fc4536ee94bcc172d.1705965635.git.isaku.yamahata@intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   include/linux/kvm_types.h |  1 +
>>   virt/kvm/kvm_main.c       | 16 ++++++++++++++--
>>   2 files changed, 15 insertions(+), 2 deletions(-)
>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
>>
>> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
>> index d93f6522b2c3..827ecc0b7e10 100644
>> --- a/include/linux/kvm_types.h
>> +++ b/include/linux/kvm_types.h
>> @@ -86,6 +86,7 @@ struct gfn_to_pfn_cache {
>>   struct kvm_mmu_memory_cache {
>>       gfp_t gfp_zero;
>>       gfp_t gfp_custom;
>> +    u64 init_value;
>>       struct kmem_cache *kmem_cache;
>>       int capacity;
>>       int nobjs;
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 9c99c9373a3e..c9828feb7a1c 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
>>   static inline void *mmu_memory_cache_alloc_obj(struct 
>> kvm_mmu_memory_cache *mc,
>>                              gfp_t gfp_flags)
>>   {
>> +    void *page;
>> +
>>       gfp_flags |= mc->gfp_zero;
>>         if (mc->kmem_cache)
>>           return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
>> -    else
>> -        return (void *)__get_free_page(gfp_flags);
>> +
>> +    page = (void *)__get_free_page(gfp_flags);
>> +    if (page && mc->init_value)
>> +        memset64(page, mc->init_value, PAGE_SIZE / 
>> sizeof(mc->init_value));

Do we need a static_assert() to make sure mc->init_value is 64bit?

>> +    return page;
>>   }
>>     int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, 
>> int capacity, int min)
>> @@ -421,6 +426,13 @@ int __kvm_mmu_topup_memory_cache(struct 
>> kvm_mmu_memory_cache *mc, int capacity,
>>           if (WARN_ON_ONCE(!capacity))
>>               return -EIO;
>>   +        /*
>> +         * Custom init values can be used only for page allocations,
>> +         * and obviously conflict with __GFP_ZERO.
>> +         */
>> +        if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || 
>> mc->gfp_zero)))
>> +            return -EIO;
>> +
>>           mc->objects = kvmalloc_array(capacity, sizeof(void *), gfp);
>>           if (!mc->objects)
>>               return -ENOMEM;
>
>


