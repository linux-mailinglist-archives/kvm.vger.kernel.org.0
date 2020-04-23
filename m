Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D71B52E2
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 05:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDWDBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 23:01:52 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42530 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgDWDBw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 23:01:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0TwNrvuB_1587610903;
Received: from 30.27.118.66(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TwNrvuB_1587610903)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 11:01:45 +0800
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        frankja@linux.ibm.com, david@redhat.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, maz@kernel.org,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
 <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
 <20200422154543.2efba3dd.cohuck@redhat.com>
 <dc5e0fa3-558b-d606-bda9-ed281cf9e9ae@de.ibm.com>
 <20200422180403.03f60b0c.cohuck@redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <5e1e126d-f1b0-196c-594b-4289d0afb9a8@linux.alibaba.com>
Date:   Thu, 23 Apr 2020 11:01:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422180403.03f60b0c.cohuck@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/23 0:04, Cornelia Huck wrote:
> On Wed, 22 Apr 2020 17:58:04 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 22.04.20 15:45, Cornelia Huck wrote:
>>> On Wed, 22 Apr 2020 20:58:04 +0800
>>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
>>>    
>>>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>>>> structure. Earlier than historical reasons, many kvm-related function
>>>
>>> s/Earlier than/For/ ?
>>>    
>>>> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
>>>> This patch does a unified cleanup of these remaining redundant parameters.
>>>>
>>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>>> ---
>>>>   arch/s390/kvm/kvm-s390.c | 37 ++++++++++++++++++++++---------------
>>>>   1 file changed, 22 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index e335a7e5ead7..d7bb2e7a07ff 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>>>   	return rc;
>>>>   }
>>>>   
>>>> -static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>>>>   {
>>>> +	struct kvm_run *kvm_run = vcpu->run;
>>>>   	struct runtime_instr_cb *riccb;
>>>>   	struct gs_cb *gscb;
>>>>   
>>>> @@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>>   		}
>>>>   		if (vcpu->arch.gs_enabled) {
>>>>   			current->thread.gs_cb = (struct gs_cb *)
>>>> -						&vcpu->run->s.regs.gscb;
>>>> +						&kvm_run->s.regs.gscb;
>>>
>>> Not sure if these changes (vcpu->run-> => kvm_run->) are really worth
>>> it. (It seems they amount to at least as much as the changes advertised
>>> in the patch description.)
>>>
>>> Other opinions?
>>
>> Agreed. It feels kind of random. Maybe just do the first line (move kvm_run from the
>> function parameter list into the variable declaration)? Not sure if this is better.
>>
> 
> There's more in this patch that I cut... but I think just moving
> kvm_run from the parameter list would be much less disruptive.
> 

I think there are two kinds of code(`vcpu->run->` and `kvm_run->`), but 
there will be more disruptive, not less.

Thanks,
Tianjia
