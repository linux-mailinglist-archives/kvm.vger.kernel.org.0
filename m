Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCB542EA1B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhJOHaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 03:30:21 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33196 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229656AbhJOHaU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 03:30:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Us6Ki-m_1634282892;
Received: from 30.43.96.45(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0Us6Ki-m_1634282892)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 15:28:13 +0800
Message-ID: <8cda9b23-9985-5b59-5d9b-eee4f798fb38@linux.alibaba.com>
Date:   Fri, 15 Oct 2021 15:28:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: VMX: Remove redundant handling of bus lock vmexit
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, seanjc@google.com
References: <1634270265-99421-1-git-send-email-hao.xiang@linux.alibaba.com>
 <5eb45c93-38aa-cea8-a5c8-cf786c193342@intel.com>
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
In-Reply-To: <5eb45c93-38aa-cea8-a5c8-cf786c193342@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/10/15 14:46, Xiaoyao Li wrote:
> On 10/15/2021 11:57 AM, Hao Xiang wrote:
>> Hardware may or may not set exit_reason.bus_lock_detected on BUS_LOCK
>> VM-Exits. Dealing with KVM_RUN_X86_BUS_LOCK in handle_bus_lock_vmexit
>> could be redundant when exit_reason.basic is EXIT_REASON_BUS_LOCK.
>>
>> We can remove redundant handling of bus lock vmexit. Force Setting
>> exit_reason.bus_lock_detected in handle_bus_lock_vmexit(), and deal with
>> KVM_RUN_X86_BUS_LOCK only in vmx_handle_exit().
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
>> ---
>> v1 -> v2: a little modifications of comments
>>
>>   arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 116b089..22be02e 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5562,9 +5562,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>>   static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>>   {
>> -    vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
>> -    vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
>> -    return 0;
>> +    /*
>> +     * Hardware may or may not set the BUS_LOCK_DETECTED flag on 
>> BUS_LOCK
>> +     * VM-Exits, force setting the flag 
> 
>>          so that the logic in vmx_handle_exit()
>> +     * doesn't have to handle the flag and the basic exit reason.
> 
> The code itself looks good.
> 
> But the comment is partly incorrect. Now we rely only on the 
> bus_lock_detected flag so vmx_handle_exit() must check the flag.
>Thank you for you advice. Is the following comment ok?
/*
  * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
  * VM-Exits. Forcely set the flag here, then check the flag in
  * vmx_handle_exit() and handle the bus lock vmexit if the flag is
  * set.
  */

>> +     */
>> +    to_vmx(vcpu)->exit_reason.bus_lock_detected = true;
>> +    return 1;
>>   }
>>   /*
>> @@ -6051,9 +6055,8 @@ static int vmx_handle_exit(struct kvm_vcpu 
>> *vcpu, fastpath_t exit_fastpath)
>>       int ret = __vmx_handle_exit(vcpu, exit_fastpath);
>>       /*
>> -     * Even when current exit reason is handled by KVM internally, we
>> -     * still need to exit to user space when bus lock detected to inform
>> -     * that there is a bus lock in guest.
>> +     * Exit to user space when bus lock detected to inform that there is
>> +     * a bus lock in guest.
>>        */
>>       if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
>>           if (ret > 0)
>>
