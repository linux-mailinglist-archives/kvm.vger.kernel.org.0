Return-Path: <kvm+bounces-19324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CD8903CF8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37EE8280DD9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 13:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BE317C9F9;
	Tue, 11 Jun 2024 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aYNQKFFc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7079A17C7D1;
	Tue, 11 Jun 2024 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718111920; cv=none; b=EzabcWE55R3hlMuHYTJuFXOVPPeLDXkypY2t1Ec0hRBW4OufJN1nBHFl83DyGZ0uCboXi553SRjxQ6luXFQ/sU7DED/NNhQ+kVta3Kd3fR6eg1GCSxMVpOY7hja8Dvvb9Q0qU1uxFWiK8HHyCw2Ysro8GrdRjb7rTtfmZDt7tlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718111920; c=relaxed/simple;
	bh=//O8QtIkUmKxIBuNk5IVof7YvtkWoHd/YCdJUEecUUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UcAz/KqElvtWpiM1jvUosFmEKpn07w/OtXsUN5JK87wCTNN7wAXHqPRkcKCrNMeYtHRWsnxKfqMirQ4V8WZNHhSajn3dUJn0EPfmv50qJ22+jJQjlneqL8QehHN5/go4xHTtD79oX2qV2xk2JZW7O1ckrDXVt4KGJEzpLS+PXRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aYNQKFFc; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718111918; x=1749647918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=//O8QtIkUmKxIBuNk5IVof7YvtkWoHd/YCdJUEecUUE=;
  b=aYNQKFFc61/ZqD8tG8zPkKyW3TOA9H8k+A2eJotBHfklsJ+jq8eb8yGZ
   MToaJ/sd4lRudp+3igYAeAdSCaPvmu5CmbMzykQCT5NtVUt1Stz0TXL4O
   2+GTkuaEDSqRR1MiHiDXr/aNz16swI7Hi0FfzPbYUmebRefspLA6RhDdM
   Ca2lNPkqnvrSlM9+RDfSqJrkO5/MBzsBNfqTCxcYU22Uo0sWS7WoeNDIZ
   dXJxQY+g28C2KONVrhIvrypF5daujHpSaVoyHOTgT3o4K34NjN8OAP6xy
   OUbEP87BLo7VkemKFwoPB54fp67+KhmCxZ5BajEWerv5S4mrsjg1tuLJU
   g==;
X-CSE-ConnectionGUID: K0io0sKCSP29HLcz8FmZBg==
X-CSE-MsgGUID: HBP8WYTBSm6BEO+OSLYFiQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="40221754"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="40221754"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 06:18:38 -0700
X-CSE-ConnectionGUID: vfwcBQrYSvuAytjbhXuaFw==
X-CSE-MsgGUID: ys0y+A/sTz2N0gygGMg9FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="39896510"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.224.116]) ([10.124.224.116])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 06:18:35 -0700
Message-ID: <aefee0c0-6931-4677-932e-e61db73b63a2@linux.intel.com>
Date: Tue, 11 Jun 2024 21:18:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
To: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
 <ZiJ3Krs_HoqdfyWN@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZiJ3Krs_HoqdfyWN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/19/2024 9:52 PM, Sean Christopherson wrote:
> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TDX doesn't support system-management mode (SMM) and system-management
>> interrupt (SMI) in guest TDs.  Because guest state (vcpu state, memory
>> state) is protected, it must go through the TDX module APIs to change guest
>> state, injecting SMI and changing vcpu mode into SMM.  The TDX module
>> doesn't provide a way for VMM to inject SMI into guest TD and a way for VMM
>> to switch guest vcpu mode into SMM.
>>
>> We have two options in KVM when handling SMM or SMI in the guest TD or the
>> device model (e.g. QEMU): 1) silently ignore the request or 2) return a
>> meaningful error.
>>
>> For simplicity, we implemented the option 1).
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   arch/x86/kvm/smm.h         |  7 +++++-
>>   arch/x86/kvm/vmx/main.c    | 45 ++++++++++++++++++++++++++++++++++----
>>   arch/x86/kvm/vmx/tdx.c     | 29 ++++++++++++++++++++++++
>>   arch/x86/kvm/vmx/x86_ops.h | 12 ++++++++++
>>   4 files changed, 88 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>> index a1cf2ac5bd78..bc77902f5c18 100644
>> --- a/arch/x86/kvm/smm.h
>> +++ b/arch/x86/kvm/smm.h
>> @@ -142,7 +142,12 @@ union kvm_smram {
>>   
>>   static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
>>   {
>> -	kvm_make_request(KVM_REQ_SMI, vcpu);
>> +	/*
>> +	 * If SMM isn't supported (e.g. TDX), silently discard SMI request.
>> +	 * Assume that SMM supported = MSR_IA32_SMBASE supported.
>> +	 */
>> +	if (static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE))
>> +		kvm_make_request(KVM_REQ_SMI, vcpu);
>>   	return 0;
> No, just do what KVM already does for CONFIG_KVM_SMM=n, and return -ENOTTY.  The
> *entire* point of have a return code is to handle setups that don't support SMM.
>
> 	if (!static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE)))
> 		return -ENOTTY;
>
> And with that, I would drop the comment, it's pretty darn clear what "assumption"
> is being made.  In quotes because it's not an assumption, it's literally KVM's
> implementation.
>
> And then the changelog can say "do what KVM does for CONFIG_KVM_SMM=n" without
> having to explain why we decided to do something completely arbitrary for TDX.
>
>>   }
>>   
>> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>> index ed46e7e57c18..4f3b872cd401 100644
>> --- a/arch/x86/kvm/vmx/main.c
>> +++ b/arch/x86/kvm/vmx/main.c
>> @@ -283,6 +283,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
>>   	vmx_msr_filter_changed(vcpu);
>>   }
>>   
>> +#ifdef CONFIG_KVM_SMM
>> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>> +{
>> +	if (is_td_vcpu(vcpu))
>> +		return tdx_smi_allowed(vcpu, for_injection);
> Adding stubs for something that TDX will never support is silly.  Bug the VM and
> return an error.
>
> 	if (KVM_BUG_ON(is_td_vcpu(vcpu)))
> 		return -EIO;

is_td_vcpu() is defined in tdx.h.
Do you mind using open code to check whether the VM is TD in vmx.c?
"vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM"



>
> And I wouldn't even bother with vt_* wrappers, just put that right in vmx_*().
> Same thing for everything below.
>


