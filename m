Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EED7414666
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 12:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhIVKeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 06:34:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:41410 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234760AbhIVKd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 06:33:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="309117992"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="309117992"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 03:32:26 -0700
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="550197430"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.182]) ([10.255.29.182])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 03:32:24 -0700
Subject: Re: [PATCH] KVM: VMX: Check if bus lock vmexit was preempted
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chenyi.qiang@intel.com,
        shannon.zhao@linux.alibaba.com,
        Sean Christopherson <seanjc@google.com>
References: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
 <87b411c3-da75-e074-91a4-a73891f9f5f8@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <57597778-836c-7bac-7f1d-bcdae0cd6ac4@intel.com>
Date:   Wed, 22 Sep 2021 18:32:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87b411c3-da75-e074-91a4-a73891f9f5f8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/2021 6:02 PM, Paolo Bonzini wrote:
> On 18/09/21 13:30, Hao Xiang wrote:
>> exit_reason.bus_lock_detected is not only set when bus lock VM exit
>> was preempted, in fact, this bit is always set if bus locks are
>> detected no matter what the exit_reason.basic is.
>>
>> So the bus_lock_vmexit handling in vmx_handle_exit should be duplicated
>> when exit_reason.basic is EXIT_REASON_BUS_LOCK(74). We can avoid it by
>> checking if bus lock vmexit was preempted in vmx_handle_exit.
> 
> I don't understand, does this mean that bus_lock_detected=1 if 
> basic=EXIT_REASON_BUS_LOCK?  If so, can we instead replace the contents 
> of handle_bus_lock_vmexit with
> 
>      /* Do nothing and let vmx_handle_exit exit to userspace.  */
>      WARN_ON(!to_vmx(vcpu)->exit_reason.bus_lock_detected);
>      return 0;
> 
> ?
> 
> That would be doable only if this is architectural behavior and not a 
> processor erratum, of course.

EXIT_REASON.bus_lock_detected may or may not be set when exit reason == 
EXIT_REASON_BUS_LOCK. Intel will update ISE or SDM to state it.

Maybe we can do below in handle_bus_lock_vmexit handler:

	if (!to_vmx(vcpu)->exit_reason.bus_lock_detected)
		to_vmx(vcpu)->exit_reason.bus_lock_detected = 1;

But is manually changing the hardware reported value for software 
purpose a good thing?


> Thanks,
> 
> Paolo
> 
>> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0c2c0d5..5ddf1df 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6054,7 +6054,8 @@ static int vmx_handle_exit(struct kvm_vcpu 
>> *vcpu, fastpath_t exit_fastpath)
>>        * still need to exit to user space when bus lock detected to 
>> inform
>>        * that there is a bus lock in guest.
>>        */
>> -    if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
>> +    if (to_vmx(vcpu)->exit_reason.bus_lock_detected &&
>> +            to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_BUS_LOCK) {
>>           if (ret > 0)
>>               vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
>>
> 

