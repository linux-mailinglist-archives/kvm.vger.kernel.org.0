Return-Path: <kvm+bounces-24084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9088951194
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BA1E1F24688
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03BD17997;
	Wed, 14 Aug 2024 01:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxJR+gCW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069D3D304;
	Wed, 14 Aug 2024 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723598859; cv=none; b=l59fKsZ7bUje3HcAmcK3q96czufLA7Uqe642M0PNiNJZqK47WWDwwk6N40uX64+eQaSv1Sv4Ft9c8CBf5em+Q+nDKlWt7/Wz40ugSMhQKD3289jnhOq1AJ5phHsFPn1H+z+eY/YoTCdJ7x4vl1e6K0Y7en58LQ89pJA2AwDOTkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723598859; c=relaxed/simple;
	bh=uqBY6NITDHdDx25k5NhRmqQM5OL1V3U69O8kcelCmvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o/yv92jps9CMX2+O3GH4mSEXYgB+nqr07zHP27Rvw4/4OFa5FUUsrPcopbivoyEmWXH3mPDwuWPAQszf8SoLgsZkSHXagkjGQwGN164On3FH3DaR07HQuN57zuBaKNr86LRiZb9Th3A2C22hvBLT89QbZbpqZEGvn7DlqjHFAC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxJR+gCW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723598858; x=1755134858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uqBY6NITDHdDx25k5NhRmqQM5OL1V3U69O8kcelCmvU=;
  b=MxJR+gCWG9nA5HjYDulwuj7BeSnAckX6PZ1aMdGppA0VW3m/upHWc/HL
   GhfYNRc9CsavfvSx4HC8GZhu6Kc4XUQZ4HfvFddWevkIanqSoteA1jLBx
   PiZeqIWEZ4k5uhYpXw9QJn2Ol66Uqmy0nykJyViOgkSWuYFDsjbdrGZZ2
   mrwtWuU9etSxb+xZtIt4NSwxm+OPuEX4gOiuzRpZh8Fc6blQP5+jdQXr+
   gOQZqgpb+Cc4NhzAllueSwWTLQBv6vNT2gXId4fs7e5nawVoU+D9fXX15
   6OSwwljBayTqaTC1lMpzDIMpFENeZo/+TUX4E6QdE1Lh+KkJEksBSAjPQ
   g==;
X-CSE-ConnectionGUID: cbb2gbtgQKOCXMXBIAPczw==
X-CSE-MsgGUID: och83KOlSFODhfEhRNQD+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21950285"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21950285"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 18:27:37 -0700
X-CSE-ConnectionGUID: H/CqfpQjSJCC+KCSHIz2AA==
X-CSE-MsgGUID: nwrmRXJPQcijHenWhiLMew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="58784510"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 18:27:35 -0700
Message-ID: <037da3c6-638d-49c8-bc0d-066c3400c4b1@linux.intel.com>
Date: Wed, 14 Aug 2024 09:27:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Isaku Yamahata <isaku.yamahata@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, michael.roth@amd.com
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
 <b58771a0-352e-4478-b57d-11fa2569f084@intel.com>
 <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/14/2024 8:52 AM, Isaku Yamahata wrote:
> On Wed, Aug 14, 2024 at 11:11:29AM +1200,
> "Huang, Kai" <kai.huang@intel.com> wrote:
>
>>
>> On 14/08/2024 5:50 am, Isaku Yamahata wrote:
>>> On Tue, Aug 13, 2024 at 01:12:55PM +0800,
>>> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>
>>>> Check whether a KVM hypercall needs to exit to userspace or not based on
>>>> hypercall_exit_enabled field of struct kvm_arch.
>>>>
>>>> Userspace can request a hypercall to exit to userspace for handling by
>>>> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
>>>> hypercall_exit_enabled.  Make the check code generic based on it.
>>>>
>>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>>> ---
>>>>    arch/x86/kvm/x86.c | 4 ++--
>>>>    arch/x86/kvm/x86.h | 7 +++++++
>>>>    2 files changed, 9 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index af6c8cf6a37a..6e16c9751af7 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>>    	cpl = kvm_x86_call(get_cpl)(vcpu);
>>>>    	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>>>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>>>> -		/* MAP_GPA tosses the request to the user space. */
>>>> +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
>>>> +		/* The hypercall is requested to exit to userspace. */
>>>>    		return 0;
>>>>    	if (!op_64_bit)
>>>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>>>> index 50596f6f8320..0cbec76b42e6 100644
>>>> --- a/arch/x86/kvm/x86.h
>>>> +++ b/arch/x86/kvm/x86.h
>>>> @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>>>    			 unsigned int port, void *data,  unsigned int count,
>>>>    			 int in);
>>>> +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
>>>> +{
>>>> +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
>>>> +		return false;
>>> Is this to detect potential bug? Maybe
>>> BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
>>>                !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
>>> Overkill?
My intention was to catch issue when KVM_HC_* grows and exceeds 32.
I was looking a compile time check, but didn't find a proper one.

>> I don't think this is the correct way to use __builtin_constant_p(), i.e. it
>> doesn't make sense to use __builtin_constant_p() in BUILD_BUG_ON().
>>
>> IIUC you need some build time guarantee here, but __builtin_constant_p() can
>> return false, in which case the above BUILD_BUG_ON() does nothing, which
>> defeats the purpose.
> It depends on what we'd like to detect.  BUILT_BUG_ON(__builtin_constant_p())
> can detect the usage in the patch 2/2,
> is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE).  The potential
> future use of is_kvm_hc_exit_enabled(, KVM_HC_MAP_future_hypercall).
>
> Although this version doesn't help for the one in kvm_emulate_hypercall(),
> !ret check is done first to avoid WARN_ON_ONCE() to hit here.
Even !ret is checked first, it's still possible to hit the warning
if KVM_HC_furture_hypercall >=32.

>
> Maybe we can just drop this WARN_ON_ONCE().

Agree that a warning may not be a good option.
What I wanted to guarantee was that "KVM_HC_* < 32" when
hypercall_exit_enabled is u32.


