Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E3B1A6476
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 11:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgDMJHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 05:07:46 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:52908 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728150AbgDMJHp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 05:07:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0TvMk-zp_1586768848;
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TvMk-zp_1586768848)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Apr 2020 17:07:29 +0800
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <17097df45c7fe76ee3c09ac180b844d2@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <a06c5435-8790-a970-519b-92ea4ee70f7d@linux.alibaba.com>
Date:   Mon, 13 Apr 2020 17:07:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <17097df45c7fe76ee3c09ac180b844d2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/13 16:56, Marc Zyngier wrote:
> Tianjia,
> 
> On 2020-04-13 04:45, Tianjia Zhang wrote:
>> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
>> where vcpu->run is the kvm_run parameter, so it has been replaced.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>  arch/x86/kvm/x86.c | 8 ++++----
>>  virt/kvm/arm/arm.c | 2 +-
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3bf2ecafd027..70e3f4abbd4d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
>> *vcpu, struct kvm_run *kvm_run)
>>          r = -EAGAIN;
>>          if (signal_pending(current)) {
>>              r = -EINTR;
>> -            vcpu->run->exit_reason = KVM_EXIT_INTR;
>> +            kvm_run->exit_reason = KVM_EXIT_INTR;
>>              ++vcpu->stat.signal_exits;
>>          }
>>          goto out;
>>      }
>>
>> -    if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>> +    if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>>          r = -EINVAL;
>>          goto out;
>>      }
>>
>> -    if (vcpu->run->kvm_dirty_regs) {
>> +    if (kvm_run->kvm_dirty_regs) {
>>          r = sync_regs(vcpu);
>>          if (r != 0)
>>              goto out;
>> @@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
>> *vcpu, struct kvm_run *kvm_run)
>>
>>  out:
>>      kvm_put_guest_fpu(vcpu);
>> -    if (vcpu->run->kvm_valid_regs)
>> +    if (kvm_run->kvm_valid_regs)
>>          store_regs(vcpu);
>>      post_kvm_run_save(vcpu);
>>      kvm_sigset_deactivate(vcpu);
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 48d0ec44ad77..ab9d7966a4c8 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
>> struct kvm_run *run)
>>          return ret;
>>
>>      if (run->exit_reason == KVM_EXIT_MMIO) {
>> -        ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>> +        ret = kvm_handle_mmio_return(vcpu, run);
>>          if (ret)
>>              return ret;
>>      }
> 
> Do you have any number supporting the idea that you are optimizing anything
> here? Performance, code size, register pressure or any other relevant 
> metric?
> 
> Thanks,
> 
>          M.

This is only a simplified implementation of the function, the impact on 
performance and register pressure can be ignored.

Thanks,
Tianjia
