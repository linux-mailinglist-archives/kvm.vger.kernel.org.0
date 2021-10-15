Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6540942ECB1
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 10:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhJOIpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 04:45:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:15959 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhJOIpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 04:45:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="214813451"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="214813451"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 01:43:44 -0700
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="442457306"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 01:43:42 -0700
Message-ID: <11416416-8fc8-f4db-71d6-5205f3b7515e@intel.com>
Date:   Fri, 15 Oct 2021 16:43:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: VMX: Remove redundant handling of bus lock vmexit
Content-Language: en-US
To:     Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, seanjc@google.com
References: <1634270265-99421-1-git-send-email-hao.xiang@linux.alibaba.com>
 <5eb45c93-38aa-cea8-a5c8-cf786c193342@intel.com>
 <8cda9b23-9985-5b59-5d9b-eee4f798fb38@linux.alibaba.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <8cda9b23-9985-5b59-5d9b-eee4f798fb38@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/2021 3:28 PM, Hao Xiang wrote:
> 
> 
> On 2021/10/15 14:46, Xiaoyao Li wrote:
>> On 10/15/2021 11:57 AM, Hao Xiang wrote:
>>> Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
>>> VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
>>> could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.
>>>
>>> We can remove redundant handling of bus lock vmexit. Force Setting
>>> exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
>>> KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().
>>>
>>> Suggested-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
>>> ---
>>> v1 -> v2: a little modifications of comments
>>>
>>>   arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
>>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 116b089..22be02e 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -5562,9 +5562,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>>>   static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>>>   {
>>> -    vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
>>> -    vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
>>> -    return 0;
>>> +    /*
>>> +     * Hardware may or may not set the BUS_LOCK_DETECTED flag on 
>>> BUS_LOCK
>>> +     * VM-Exits, force setting the flag 
>>
>>>          so that the logic in vmx_handle_exit()
>>> +     * doesn't have to handle the flag and the basic exit reason.
>>
>> The code itself looks good.
>>
>> But the comment is partly incorrect. Now we rely only on the 
>> bus_lock_detected flag so vmx_handle_exit() must check the flag.
>> Thank you for you advice. Is the following comment ok?
> /*
>   * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
>   * VM-Exits. Forcely set the flag here, then check the flag in
>   * vmx_handle_exit() and handle the bus lock vmexit if the flag is
>   * set.
>   */

(I'm not sure if forcely is a valid word)

how about

/*
  * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
  * VM Exit. Unconditionally set the flag here and leave the handling to
  * vmx_handle_exit().
  */

>>> +     */
>>> +    to_vmx(vcpu)->exit_reason.bus_lock_detected = true;
>>> +    return 1;
>>>   }
>>>   /*
>>> @@ -6051,9 +6055,8 @@ static int vmx_handle_exit(struct kvm_vcpu 
>>> *vcpu, fastpath_t exit_fastpath)
>>>       int ret = __vmx_handle_exit(vcpu, exit_fastpath);
>>>       /*
>>> -     * Even when current exit reason is handled by KVM internally, we
>>> -     * still need to exit to user space when bus lock detected to 
>>> inform
>>> -     * that there is a bus lock in guest.
>>> +     * Exit to user space when bus lock detected to inform that 
>>> there is
>>> +     * a bus lock in guest.
>>>        */
>>>       if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
>>>           if (ret > 0)
>>>

