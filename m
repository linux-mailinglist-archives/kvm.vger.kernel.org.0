Return-Path: <kvm+bounces-11637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BC9878E38
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7785B2176A
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 05:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E382D2E3F9;
	Tue, 12 Mar 2024 05:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="alu+yz/x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F12720304;
	Tue, 12 Mar 2024 05:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710222252; cv=none; b=RpJyXoQls47gTklAp9W+FDb+213SSHWFEW6Lcsgau5b4awqM6Hf0sGuav7IV+rQ2svEiJIbf3ghweAbpDfP6yKkljieSmfUnsoTpV5EJJdvuFCYbCfhOLWe4KhdsVhlgjswIYq8wcVxpEH6v3sud898JA0Oc6ChPQoBUSS1/CME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710222252; c=relaxed/simple;
	bh=YUA5xCks3DL01daXHdbAKUuXLaWBHujC/db7Mi41JeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZLzNMq3myQmTdR2JiPl/67O/F0tM5KF10qMyO2Dic2L/noSvCtvxFqnbm5XLsk9ozVKFl+ep4Amwspko6dGiUAoHLWQY78+0Mseoh7QT6Tcq3q5ICF7/Yd2KuRhafzFAUbSoY6g+1GpezRX2OaGgk1MBYASqiQvMKS78eh9T88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=alu+yz/x; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710222251; x=1741758251;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YUA5xCks3DL01daXHdbAKUuXLaWBHujC/db7Mi41JeM=;
  b=alu+yz/x7b/HBgt+nH+JoDNpiXHA+61J/8+WZC4bXcHPDEBloksE7cid
   04q2BfUTTBeNf8Y2gm7N1/io+j/8lWUf0r2UYApar2tOKuaXHKlJ8h8z5
   S4atthKaOqTg1ZvTedQzz/8pj2KccsL4JOvyk/8UjxqUeC2OGZp6itiR2
   nVOCfHiDi3ieASr00yRk250fkmlQH24LO3C2lLRqfmbhasmxjJJzTS+oS
   q/s2zwAf/sFSdAL+Q5KHW6NhUB1ZAtgNFQojnKGMC6NoJb8yHquB0xgd+
   XnWzox3Iqcn4DvmYds9M0cQB6cLG9Z5IIx+zIAb3zMMKKhn3EcFKsNMhy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5042637"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="5042637"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 22:44:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="48866108"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 22:44:07 -0700
Message-ID: <f1e2d2f7-f5cb-488b-8f9d-647d2f4e7480@linux.intel.com>
Date: Tue, 12 Mar 2024 13:44:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] KVM: x86/mmu: WARN if upper 32 bits of legacy #PF
 error code are non-zero
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-7-seanjc@google.com>
 <3779953f-4d07-41d7-b450-bbc2afffaa43@intel.com>
 <ZeEOTxUTSkYnP9Y0@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZeEOTxUTSkYnP9Y0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/1/2024 7:07 AM, Sean Christopherson wrote:
> On Fri, Mar 01, 2024, Kai Huang wrote:
>>
>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>> WARN if bits 63:32 are non-zero when handling an intercepted legacy #PF,
>> I found "legacy #PF" is a little bit confusing but I couldn't figure out a
>> better name either :-)

Me too.

>>
>>> as the error code for #PF is limited to 32 bits (and in practice, 16 bits
>>> on Intel CPUS).  This behavior is architectural, is part of KVM's ABI
>>> (see kvm_vcpu_events.error_code), and is explicitly documented as being
>>> preserved for intecerpted #PF in both the APM:

"intecerpted" -> "intercepted"

>>>
>>>     The error code saved in EXITINFO1 is the same as would be pushed onto
>>>     the stack by a non-intercepted #PF exception in protected mode.
>>>
>>> and even more explicitly in the SDM as VMCS.VM_EXIT_INTR_ERROR_CODE is a
>>> 32-bit field.
>>>
>>> Simply drop the upper bits of hardware provides garbage, as spurious
>> "of" -> "if" ?
>>
>>> information should do no harm (though in all likelihood hardware is buggy
>>> and the kernel is doomed).
>>>
>>> Handling all upper 32 bits in the #PF path will allow moving the sanity
>>> check on synthetic checks from kvm_mmu_page_fault() to npf_interception(),
>>> which in turn will allow deriving PFERR_PRIVATE_ACCESS from AMD's
>>> PFERR_GUEST_ENC_MASK without running afoul of the sanity check.
>>>
>>> Note, this also why Intel uses bit 15 for SGX (highest bit on Intel CPUs)
>> "this" -> "this is" ?
>>
>>> and AMD uses bit 31 for RMP (highest bit on AMD CPUs); using the highest
>>> bit minimizes the probability of a collision with the "other" vendor,
>>> without needing to plumb more bits through microcode.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 7807bdcd87e8..5d892bd59c97 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4553,6 +4553,13 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>>>    	if (WARN_ON_ONCE(fault_address >> 32))
>>>    		return -EFAULT;
>>>    #endif
>>> +	/*
>>> +	 * Legacy #PF exception only have a 32-bit error code.  Simply drop the
>> "have" -> "has" ?
> This one I'll fix by making "exception" plural.
>
> Thanks much for the reviews!
>
>>> +	 * upper bits as KVM doesn't use them for #PF (because they are never
>>> +	 * set), and to ensure there are no collisions with KVM-defined bits.
>>> +	 */
>>> +	if (WARN_ON_ONCE(error_code >> 32))
>>> +		error_code = lower_32_bits(error_code);
>>>    	vcpu->arch.l1tf_flush_l1d = true;
>>>    	if (!flags) {
>> Reviewed-by: Kai Huang <kai.huang@intel.com>


