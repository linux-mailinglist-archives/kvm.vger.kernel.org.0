Return-Path: <kvm+bounces-17362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 616B58C4BAD
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 06:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 924861C21698
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 04:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A671412B89;
	Tue, 14 May 2024 04:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/wxj0XS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C681879;
	Tue, 14 May 2024 04:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715660758; cv=none; b=IY6OAge/yQ+xDvCmNLoiBEhgHtVBRfcvA8e3NlWWW5ytJCHrfS4jHtmIQOtQMrLo56GMWU8PlHpTvbl3r4ALyf4Nt1kv7G8fEXJXasNUVHAnFYXFWU3/wYtjAbViDFSYlljAOxpSP1FAy9jfZtWh1ZDHnAbYw1ucWcbNTd36KU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715660758; c=relaxed/simple;
	bh=lGGF6Zu/yTv80zk6p1pbSg/NpKuwrVgMc2jqi0ss/+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nZPwr1dgbxBGPkww0N6lebwclwFBkFG/TaxrVFf5ZffMrwhkpXJiQn4NKu1zxx7O12uu/MVp7fqdcgqtc99IJYVhjT/I1FSl9n1ZsyNHkwwzGH4SHGRMkVHqD7CpNPgucantPp88nTfaZAQ3cEzQ7l5tvQhWiTGrlMtLJtT+2oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/wxj0XS; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715660756; x=1747196756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lGGF6Zu/yTv80zk6p1pbSg/NpKuwrVgMc2jqi0ss/+g=;
  b=h/wxj0XSHpeJAU99AIkrSqpmZh7mu8GV/U9U8/ESA0U7w773cSydUZ3q
   JZYi2LSs0jGROB9U8HEw5FDlsemmO5gnSm6W4BxhQhGw1cSSIVY/hsPBF
   Mc0etiSBRD/Ur5oxX3+FH1rGbyvXrkMmPSCTXMDAv9wMYbPBNKFX11bDn
   nHkuf5NTTX3ZDAUej16HWvfwj3GLw+JtZ9jgBuEG1okmBOpI0He0/hhKD
   XdT6mguWhbcsbXQq6+6WKklPx81qocGwNJVeQhYfxcPoab3WVLNCSdpSD
   MAm4segydjH7Dzap1yKvRFcY82g22FbwyhREItG58luJhHZL/BRFu62T4
   w==;
X-CSE-ConnectionGUID: 8nuOPs7pR4uorhyioMB7kg==
X-CSE-MsgGUID: isXKuJmuQV+I81NkJaDW0g==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11567206"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11567206"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 21:25:56 -0700
X-CSE-ConnectionGUID: cFfoXh4yTzWpPhDH7ge5Tw==
X-CSE-MsgGUID: ThbL82CCSN2Faz1aJdDJgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35098358"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 21:25:52 -0700
Message-ID: <55d00dc8-bfa3-4cf2-9c6a-1d81e5cfd7b3@intel.com>
Date: Tue, 14 May 2024 12:25:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-5-pbonzini@redhat.com>
 <3b6bc6ac-276f-4a83-8972-68b98db672c7@intel.com>
 <ZkJOb4zJJnOAYnTi@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZkJOb4zJJnOAYnTi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/2024 1:31 AM, Sean Christopherson wrote:
> On Mon, May 13, 2024, Xiaoyao Li wrote:
>> On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Move the sanity check that hardware never sets bits that collide with KVM-
>>> define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
>>> i.e. make the sanity check #NPF specific.  The legacy #PF path already
>>> WARNs if _any_ of bits 63:32 are set, and the error code that comes from
>>> VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
>>> EXIT_QUALIFICATION into error code flags).
>>>
>>> Add a compile-time assert in the legacy #PF handler to make sure that KVM-
>>> define flags are covered by its existing sanity check on the upper bits.
>>>
>>> Opportunistically add a description of PFERR_IMPLICIT_ACCESS, since we
>>> are removing the comment that defined it.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> Reviewed-by: Kai Huang <kai.huang@intel.com>
>>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>>> Message-ID: <20240228024147.41573-8-seanjc@google.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>    arch/x86/include/asm/kvm_host.h |  6 ++++++
>>>    arch/x86/kvm/mmu/mmu.c          | 14 +++-----------
>>>    arch/x86/kvm/svm/svm.c          |  9 +++++++++
>>>    3 files changed, 18 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 58bbcf76ad1e..12e727301262 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -267,7 +267,13 @@ enum x86_intercept_stage;
>>>    #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
>>>    #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
>>>    #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
>>> +
>>> +/*
>>> + * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
>>> + * when emulating instructions that triggers implicit access.
>>> + */
>>>    #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
>>> +#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
>>>    #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>>>    				 PFERR_WRITE_MASK |		\
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index c72a2033ca96..5562d693880a 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4502,6 +4502,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>>>    		return -EFAULT;
>>>    #endif
>>> +	/* Ensure the above sanity check also covers KVM-defined flags. */
>>
>> 1. There is no sanity check above related to KVM-defined flags yet. It has
>> to be after Patch 6.
> 
> Ya, it's not just the comment, the entire changelog expects this patch to land
> after patch 6.
>>
>> 2. I somehow cannot parse the comment properly, though I know it's to ensure
>> KVM-defined PFERR_SYNTHETIC_MASK not contain any bit below 32-bits.
> 
> Hmm, how about this?
> 
> 	/*
> 	 * Ensure that the above sanity check on hardware error code bits 63:32
> 	 * also prevents false positives on KVM-defined flags.
> 	 */
> 

Maybe it's just myself inability, I still cannot interpret it well.

Can't we put it above the sanity check of error code, and just with a 
comment like

	/*
  	 * Ensure KVM-defined flags not occupied any bits below 32-bits,
          * that are used by hardware.
	 * /

