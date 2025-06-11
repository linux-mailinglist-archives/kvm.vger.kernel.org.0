Return-Path: <kvm+bounces-48971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 214E6AD4C60
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 820133A7F4B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 07:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A685E2309AF;
	Wed, 11 Jun 2025 07:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f7JCeeMF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE9622D9E0;
	Wed, 11 Jun 2025 07:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749626106; cv=none; b=oB/eLU4u0a6fLWz3RkGU5B9HMO9NHlpWHevRk90mMQestPL4MBamtjfYlcEKDzH60VpjbGrmuBzYt6b+/I+M80TWVeJs4Fr1EYLI/MOXPpfxu9TL0dSUfRIpGanUe4cbmdW7OvuQ6QEjuhFsEtSIeSl7Zh+ozoaTg1drn8V3OyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749626106; c=relaxed/simple;
	bh=LBuV2/MkPPLMESpMzqhuYZ2zgNvWeRWkWk8EU9VNXVw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SmtuN/rnQc1kWHMbhn0Rd4iEENp75HVUb62M2AePwmhMyjuwVxjBTt0ptgI04/1b3xSBS7jbBbox5gYPXEvNdWRICQnWWpimqjTKehq009KxB6jOQA7ylIH8XM9JgEHxhWC6iIMnlDBA3bVUh6+l73qFaZjjctfDIpVNyAuHv0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f7JCeeMF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749626105; x=1781162105;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=LBuV2/MkPPLMESpMzqhuYZ2zgNvWeRWkWk8EU9VNXVw=;
  b=f7JCeeMFEgyjCxoLkhzQTn9+g5jWo6JnHXQaRgz41nL5WJV4Z7DRaq/e
   fdc9p0wcU5q3Hs/azDJfkYnXBnR34kZCgQh6uLnYPJ77WHYBGYMf/4kUJ
   fna6P++g4tbm9CvPsHET7aIVis+KUrYqqL1VboimiWzdQdu/P7Au5oH2O
   Ln5WsfT+392Vuv3lfsa19nlI0BT9Ih8aznha8LH9dAr6GjcNC6t8U2aak
   WmKBCb8VIBpqiYEQxp/RKHeoozP5o1IBEgI64p5OIZBjGUAivGZfshAMi
   tZeL4EEQde1LyJ1q+aaPXtKpMtUq99bIu+tu8BfsqQcONGgNZ/ATAr9Mn
   Q==;
X-CSE-ConnectionGUID: 3UznumaHTH6dAR9CdpWONg==
X-CSE-MsgGUID: ZY8YMweDTwGWmrRt0EoPzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51747313"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51747313"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:15:05 -0700
X-CSE-ConnectionGUID: JU3XRYaKR56sOKqNXnoqBQ==
X-CSE-MsgGUID: b9Lg0LNyTAGkxPw6lX9asw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="177997213"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:15:02 -0700
Message-ID: <e86f6cd2-e2ed-4928-8a79-e162068d0f15@linux.intel.com>
Date: Wed, 11 Jun 2025 15:14:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/32] KVM: SVM: Disable interception of SPEC_CTRL iff
 the MSR exists for the guest
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-2-seanjc@google.com>
 <629e0dc3-49b4-45f5-aeaa-8a9109e81d14@linux.intel.com>
Content-Language: en-US
In-Reply-To: <629e0dc3-49b4-45f5-aeaa-8a9109e81d14@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/11/2025 12:38 PM, Binbin Wu wrote:
>
>
> On 6/11/2025 6:57 AM, Sean Christopherson wrote:
>> Disable interception of SPEC_CTRL when the CPU virtualizes (i.e. context
>> switches) SPEC_CTRL if and only if the MSR exists according to the vCPU's
>> CPUID model.  Letting the guest access SPEC_CTRL is generally benign, but
>> the guest would see inconsistent behavior if KVM happened to emulate an
>> access to the MSR.
>>
>> Fixes: d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
>> Reported-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 0ad1a6d4fb6d..21e745acebc3 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1362,11 +1362,14 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>       svm_recalc_instruction_intercepts(vcpu, svm);
>>         /*
>> -     * If the host supports V_SPEC_CTRL then disable the interception
>> -     * of MSR_IA32_SPEC_CTRL.
>> +     * If the CPU virtualizes MSR_IA32_SPEC_CTRL, i.e. KVM doesn't need to
>> +     * manually context switch the MSR, immediately configure interception
>> +     * of SPEC_CTRL, without waiting for the guest to access the MSR.
>>        */
>>       if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> -        set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>> +        set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
>> +                     guest_has_spec_ctrl_msr(vcpu),
>> +                     guest_has_spec_ctrl_msr(vcpu));
> Side topic, not related to this patch directly.
>
> Setting to 1 for set_msr_interception() means to disable interception.
> The name of the function seems a bit counterintuitive to me.
> Maybe some description for the function can help people not familiar with
> SVM code without further checking the implementation?

Oh, please ignore it.

A later patch in this patch set has handled it.

>
>
>>         if (kvm_vcpu_apicv_active(vcpu))
>>           avic_init_vmcb(svm, vmcb);
>
>


