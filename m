Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0503A1B52BA
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgDWCyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:54:45 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:57904 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgDWCyo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 22:54:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0TwO5QT5_1587610476;
Received: from 30.27.118.66(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TwO5QT5_1587610476)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 10:54:37 +0800
Subject: Re: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
 <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
 <20200422154543.2efba3dd.cohuck@redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <e115bcf6-edf3-7465-f592-4e93e5ad984c@linux.alibaba.com>
Date:   Thu, 23 Apr 2020 10:54:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422154543.2efba3dd.cohuck@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/22 21:45, Cornelia Huck wrote:
> On Wed, 22 Apr 2020 20:58:04 +0800
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> 
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. Earlier than historical reasons, many kvm-related function
> 
> s/Earlier than/For/ ?
> 

Yes, it should be replaced like this.

>> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
>> This patch does a unified cleanup of these remaining redundant parameters.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 37 ++++++++++++++++++++++---------------
>>   1 file changed, 22 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index e335a7e5ead7..d7bb2e7a07ff 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>   	return rc;
>>   }
>>   
>> -static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>>   {
>> +	struct kvm_run *kvm_run = vcpu->run;
>>   	struct runtime_instr_cb *riccb;
>>   	struct gs_cb *gscb;
>>   
>> @@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>   		}
>>   		if (vcpu->arch.gs_enabled) {
>>   			current->thread.gs_cb = (struct gs_cb *)
>> -						&vcpu->run->s.regs.gscb;
>> +						&kvm_run->s.regs.gscb;
> 
> Not sure if these changes (vcpu->run-> => kvm_run->) are really worth
> it. (It seems they amount to at least as much as the changes advertised
> in the patch description.)
> 
> Other opinions?
> 

Why not replace `vcpu->run->` to `kvm_run->` ? If not, there will be 
both styles of code, which is confusing. I will be confused and think 
that this is something different.

Thanks,
Tianjia

>>   			restore_gs_cb(current->thread.gs_cb);
>>   		}
>>   		preempt_enable();
