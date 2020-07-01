Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99862210D44
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgGAOM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 10:12:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:17537 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730307AbgGAOM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 10:12:27 -0400
IronPort-SDR: Xzxg9+pywGS1QZFZdaKUQ60+pY3yuhAjqKcxpWYhpbDZKpSwgiTSPpWpT0oeoNnbH0S3uexuI8
 nnUkhHHZyxAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="144086420"
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="144086420"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 07:12:27 -0700
IronPort-SDR: 2gRFfydadHrNTFFz1trRa8xVauxhWiln8rNZlIWTanAV7EKsJzX5Lcu7siDqwep6s1HHNQ3Qew
 mLi4N+CbI+ew==
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="455118274"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.175.105]) ([10.249.175.105])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 07:12:24 -0700
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200628085341.5107-1-chenyi.qiang@intel.com>
 <20200628085341.5107-3-chenyi.qiang@intel.com>
 <878sg3bo8b.fsf@vitty.brq.redhat.com>
 <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
 <87366bbe1y.fsf@vitty.brq.redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <adad61e8-8252-0491-7feb-992a52c1b4f3@intel.com>
Date:   Wed, 1 Jul 2020 22:12:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87366bbe1y.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/2020 8:44 PM, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 7/1/2020 5:04 PM, Vitaly Kuznetsov wrote:
>>> Chenyi Qiang <chenyi.qiang@intel.com> writes:
>> [...]
>>>>    static const int kvm_vmx_max_exit_handlers =
>>>> @@ -6830,6 +6838,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>>    	if (unlikely(vmx->exit_reason.failed_vmentry))
>>>>    		return EXIT_FASTPATH_NONE;
>>>>    
>>>> +	/*
>>>> +	 * check the exit_reason to see if there is a bus lock
>>>> +	 * happened in guest.
>>>> +	 */
>>>> +	if (vmx->exit_reason.bus_lock_detected)
>>>> +		handle_bus_lock(vcpu);
>>>
>>> In case the ultimate goal is to have an exit to userspace on bus lock,
>>
>> I don't think we will need an exit to userspace on bus lock. See below.
>>
>>> the two ways to reach handle_bus_lock() are very different: in case
>>> we're handling EXIT_REASON_BUS_LOCK we can easily drop to userspace by
>>> returning 0 but what are we going to do in case of
>>> exit_reason.bus_lock_detected? The 'higher priority VM exit' may require
>>> exit to userspace too. So what's the plan? Maybe we can ignore the case
>>> when we're exiting to userspace for some other reason as this is slow
>>> already and force the exit otherwise?
>>
>>> And should we actually introduce
>>> the KVM_EXIT_BUS_LOCK and a capability to enable it here?
>>>
>>
>> Introducing KVM_EXIT_BUS_LOCK maybe help nothing. No matter
>> EXIT_REASON_BUS_LOCK or exit_reason.bus_lock_detected, the bus lock has
>> already happened. Exit to userspace cannot prevent bus lock, so what
>> userspace can do is recording and counting as what this patch does in
>> vcpu->stat.bus_locks.
> 
> Exiting to userspace would allow to implement custom 'throttling'
> policies to mitigate the 'noisy neighbour' problem. The simplest would
> be to just inject some sleep time.
> 

So you want an exit to userspace for every bus lock and leave it all to 
userspace. Yes, it's doable.

As you said, the exit_reason.bus_lock_detected case is the tricky one. 
We cannot do the similar to extend vcpu->run->exit_reason, this breaks 
ABI. Maybe we can extend the vcpu->run->flags to indicate bus lock 
detected for the other exit reason?
