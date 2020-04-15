Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227A01A90DA
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 04:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392928AbgDOCTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 22:19:18 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:54149 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732702AbgDOCTO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 22:19:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0TvZsw-x_1586917144;
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TvZsw-x_1586917144)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Apr 2020 10:19:05 +0800
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <875ze2ywhy.fsf@vitty.brq.redhat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
Date:   Wed, 15 Apr 2020 10:19:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <875ze2ywhy.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/14 22:26, Vitaly Kuznetsov wrote:
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
> 
>> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
>> where vcpu->run is the kvm_run parameter, so it has been replaced.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 ++++----
>>   virt/kvm/arm/arm.c | 2 +-
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3bf2ecafd027..70e3f4abbd4d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>   		r = -EAGAIN;
>>   		if (signal_pending(current)) {
>>   			r = -EINTR;
>> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
>> +			kvm_run->exit_reason = KVM_EXIT_INTR;
> 
> I have a more generic question: why do we need to pass 'kvm_run' to
> kvm_arch_vcpu_ioctl_run() if it can be extracted from 'struct kvm_vcpu'?
> The only call site looks like
> 
> virt/kvm/kvm_main.c:            r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
> 

In the earlier version, kvm_run is used to pass parameters with user 
mode and is not included in the vcpu structure, so it has been retained 
until now.

Thanks,
Tianjia

>>   			++vcpu->stat.signal_exits;
>>   		}
>>   		goto out;
>>   	}
>>   
>> -	if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>>   		r = -EINVAL;
>>   		goto out;
>>   	}
>>   
>> -	if (vcpu->run->kvm_dirty_regs) {
>> +	if (kvm_run->kvm_dirty_regs) {
>>   		r = sync_regs(vcpu);
>>   		if (r != 0)
>>   			goto out;
>> @@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>   
>>   out:
>>   	kvm_put_guest_fpu(vcpu);
>> -	if (vcpu->run->kvm_valid_regs)
>> +	if (kvm_run->kvm_valid_regs)
>>   		store_regs(vcpu);
>>   	post_kvm_run_save(vcpu);
>>   	kvm_sigset_deactivate(vcpu);
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 48d0ec44ad77..ab9d7966a4c8 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   		return ret;
>>   
>>   	if (run->exit_reason == KVM_EXIT_MMIO) {
>> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>> +		ret = kvm_handle_mmio_return(vcpu, run);
>>   		if (ret)
>>   			return ret;
>>   	}
> 
