Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D9F4158EA
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 09:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhIWHQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 03:16:59 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:42957 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239075AbhIWHQ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 03:16:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=hao.xiang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UpIwbV9_1632381325;
Received: from 30.43.105.150(mailfrom:hao.xiang@linux.alibaba.com fp:SMTPD_---0UpIwbV9_1632381325)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Sep 2021 15:15:25 +0800
Message-ID: <a6a770c9-227a-08b2-2829-09cd45141889@linux.alibaba.com>
Date:   Thu, 23 Sep 2021 15:15:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] KVM: VMX: Check if bus lock vmexit was preempted
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenyi.qiang@intel.com,
        shannon.zhao@linux.alibaba.com
References: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
 <87b411c3-da75-e074-91a4-a73891f9f5f8@redhat.com>
 <57597778-836c-7bac-7f1d-bcdae0cd6ac4@intel.com>
 <YUtEraihPxsytaJc@google.com>
From:   Hao Xiang <hao.xiang@linux.alibaba.com>
In-Reply-To: <YUtEraihPxsytaJc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/9/22 22:58, Sean Christopherson wrote:
> On Wed, Sep 22, 2021, Xiaoyao Li wrote:
>> On 9/22/2021 6:02 PM, Paolo Bonzini wrote:
>>> On 18/09/21 13:30, Hao Xiang wrote:
>>>> exit_reason.bus_lock_detected is not only set when bus lock VM exit
>>>> was preempted, in fact, this bit is always set if bus locks are
>>>> detected no matter what the exit_reason.basic is.
>>>>
>>>> So the bus_lock_vmexit handling in vmx_handle_exit should be duplicated
>>>> when exit_reason.basic is EXIT_REASON_BUS_LOCK(74). We can avoid it by
>>>> checking if bus lock vmexit was preempted in vmx_handle_exit.
>>> I don't understand, does this mean that bus_lock_detected=1 if
>>> basic=EXIT_REASON_BUS_LOCK?  If so, can we instead replace the contents
>>> of handle_bus_lock_vmexit with
>>>
>>>       /* Do nothing and let vmx_handle_exit exit to userspace.  */
>>>       WARN_ON(!to_vmx(vcpu)->exit_reason.bus_lock_detected);
>>>       return 0;
>>>
>>> ?
>>>
>>> That would be doable only if this is architectural behavior and not a
>>> processor erratum, of course.
>> EXIT_REASON.bus_lock_detected may or may not be set when exit reason ==
>> EXIT_REASON_BUS_LOCK. Intel will update ISE or SDM to state it.
>>
>> Maybe we can do below in handle_bus_lock_vmexit handler:
>>
>> 	if (!to_vmx(vcpu)->exit_reason.bus_lock_detected)
>> 		to_vmx(vcpu)->exit_reason.bus_lock_detected = 1;
>>
>> But is manually changing the hardware reported value for software purpose a
>> good thing?
> In this case, I'd say yes.  Hardware having non-deterministic behavior is the not
> good thing, KVM would simply be correctly the not-technically-an-erratum erratum.
>
> Set it unconditionally and then handle everything in common path.  This has the
> added advantage of having only one site that deals with KVM_RUN_X86_BUS_LOCK.
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 33f92febe3ce..aa9372452e49 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5561,9 +5561,9 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>
>   static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>   {
> -       vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> -       vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> -       return 0;
> +       /* The dedicated flag may or may not be set by hardware.  /facepalm. */
> +       vcpu->exit_reason.bus_lock_detected = true;
> +       return 1;
>   }
>
>   /*
> @@ -6050,9 +6050,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>          int ret = __vmx_handle_exit(vcpu, exit_fastpath);
>
>          /*
> -        * Even when current exit reason is handled by KVM internally, we
> -        * still need to exit to user space when bus lock detected to inform
> -        * that there is a bus lock in guest.
> +        * Exit to user space when bus lock detected to inform that there is a
> +        * bus lock in guest.
>           */
>          if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
>                  if (ret > 0)
I agree with your modifications. And I will  re-submit the patch. Thanks.
