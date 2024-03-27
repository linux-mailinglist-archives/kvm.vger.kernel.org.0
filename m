Return-Path: <kvm+bounces-12872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6169688E788
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14B7E300D5A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF6513118E;
	Wed, 27 Mar 2024 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WW8NhqAS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED586FC2;
	Wed, 27 Mar 2024 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711548570; cv=none; b=t5wDrh6Mu2YsKairp3alk2BZRcKSfDCktuPG2/BFoxr2HEwNg8QqcOyk6AgbDYAFKP0ePZ5MwCrtoHG/6Yxfn2C2cyDTjk0J3a8DGnLY/ylD78QfAxwEfVFeCixPJ4XnmhJhbDMgt3Fos9pNoliOGRIHixvoMFbmco+n4v/ZgGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711548570; c=relaxed/simple;
	bh=lFo6CayJr3bn7um+nsNwcJD9J6nuJeNUotXXO++8fAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDHh3gxgMPND8fuuhr0ImtAhFv/U0Erjocg8KLqzezNfp0upLnM2Vu2nVM0Xti9ch257qp9kXQLLuQG3YmANw8dwHphkTaQZzMdWndlDFbBVbU0nsADn45tBggYwYF2emxGHpKVyzjPGMW/wrWBGYizg2itrVxD4wOKjcyi1drk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WW8NhqAS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711548569; x=1743084569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lFo6CayJr3bn7um+nsNwcJD9J6nuJeNUotXXO++8fAE=;
  b=WW8NhqAS9AwEHFLsidgVcuWjX9cX6Un3jtgSY1kUvY5DYdyYL+4VAbFS
   iB7zXljbsmB1MrLBEe82ZJNS9Krs/WBEpEmoGXSWirBIp91Po8s7d/Spg
   ByETN4veWyovOso40f2GriWWY4lVP9xLh1F+rJ06I+nBgvAZSbbtuzeYO
   Euz40tUxYO+lCuQwKAe4Lu/VBP7siY8mTZ5w8PmvqXSvwbiHj4tPOhimn
   1lnl1YskNRCBH4+ra7budpWLQ1DPz6mI9irhKTsuWOoCmmuRgox83T2cu
   cGncSWoz47gsDuUR1tS29YL5TztDlkEU+2WYRJ66ewm57NkLTQlljXQLM
   g==;
X-CSE-ConnectionGUID: cmU7qda0RN6+97kSML4HWA==
X-CSE-MsgGUID: QaIjldYZS1aJEpFLLtW9rg==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="24141735"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="24141735"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 07:09:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="20949910"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 07:09:24 -0700
Message-ID: <6052c6cd-635e-483a-90e2-d66beb1bb91b@linux.intel.com>
Date: Wed, 27 Mar 2024 22:09:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 046/130] KVM: x86/mmu: Add address conversion
 functions for TDX shared bit of GPA
To: Chenyi Qiang <chenyi.qiang@intel.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <973a3e06111fe84f2b1e971636cbaa3facf7b120.1708933498.git.isaku.yamahata@intel.com>
 <b07d0749-8a72-4a0a-a0ad-808d7ea2b922@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b07d0749-8a72-4a0a-a0ad-808d7ea2b922@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/27/2024 11:08 AM, Chenyi Qiang wrote:
>
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
>> indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
>> GPA.shared is set, GPA is covered by the existing conventional EPT pointed
>> by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
>> VMM has to issue SEAMCALLs to operate.
>>
>> Add a member to remember GPA shared bit for each guest TDs, add address
>> conversion functions between private GPA and shared GPA and test if GPA
>> is private.
>>
>> Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
>> kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
>> the new member to remember GPA shared bit is guaranteed to be zero with
>> this patch unless it's initialized explicitly.
>>
>> 			default or SEV-SNP	TDX: S = (47 or 51) - 12
>> gfn_shared_mask		0			S bit
>> kvm_is_private_gpa()	always false		true if GFN has S bit set
> TDX: true if GFN has S bit clear?
>
>> kvm_gfn_to_shared()	nop			set S bit
>> kvm_gfn_to_private()	nop			clear S bit
>>
>> fault.is_private means that host page should be gotten from guest_memfd
>> is_private_gpa() means that KVM MMU should invoke private MMU hooks.
>>
>> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> v19:
>> - Add comment on default vm case.
>> - Added behavior table in the commit message
>> - drop CONFIG_KVM_MMU_PRIVATE
>>
>> v18:
>> - Added Reviewed-by Binbin
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  2 ++
>>   arch/x86/kvm/mmu.h              | 33 +++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/vmx/tdx.c          |  5 +++++
>>   3 files changed, 40 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 5da3c211955d..de6dd42d226f 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1505,6 +1505,8 @@ struct kvm_arch {
>>   	 */
>>   #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>>   	struct kvm_mmu_memory_cache split_desc_cache;
>> +
>> +	gfn_t gfn_shared_mask;
>>   };
>>   
>>   struct kvm_vm_stat {
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index d96c93a25b3b..395b55684cb9 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -322,4 +322,37 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>>   		return gpa;
>>   	return translate_nested_gpa(vcpu, gpa, access, exception);
>>   }
>> +
>> +/*
>> + *			default or SEV-SNP	TDX: where S = (47 or 51) - 12
>> + * gfn_shared_mask	0			S bit
>> + * is_private_gpa()	always false		if GPA has S bit set

Also here,
TDX: true if GFN has S bit cleared

>> + * gfn_to_shared()	nop			set S bit
>> + * gfn_to_private()	nop			clear S bit
>> + *
>> + * fault.is_private means that host page should be gotten from guest_memfd
>> + * is_private_gpa() means that KVM MMU should invoke private MMU hooks.
>> + */
>> +static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
>> +{
>> +	return kvm->arch.gfn_shared_mask;
>> +}
>> +
>> +static inline gfn_t kvm_gfn_to_shared(const struct kvm *kvm, gfn_t gfn)
>> +{
>> +	return gfn | kvm_gfn_shared_mask(kvm);
>> +}
>> +
>> +static inline gfn_t kvm_gfn_to_private(const struct kvm *kvm, gfn_t gfn)
>> +{
>> +	return gfn & ~kvm_gfn_shared_mask(kvm);
>> +}
>> +
>> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
>> +{
>> +	gfn_t mask = kvm_gfn_shared_mask(kvm);
>> +
>> +	return mask && !(gpa_to_gfn(gpa) & mask);
>> +}
>> +
>>   #endif
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index aa1da51b8af7..54e0d4efa2bd 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -906,6 +906,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>>   	kvm_tdx->attributes = td_params->attributes;
>>   	kvm_tdx->xfam = td_params->xfam;
>>   
>> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
>> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
>> +	else
>> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
>> +
>>   out:
>>   	/* kfree() accepts NULL. */
>>   	kfree(init_vm);


