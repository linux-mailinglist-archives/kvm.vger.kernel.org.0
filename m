Return-Path: <kvm+bounces-11986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F060F87EA9F
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A04AB282D5C
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 14:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14DB4B5C1;
	Mon, 18 Mar 2024 14:14:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC47482C7;
	Mon, 18 Mar 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710771287; cv=none; b=KPWu19Y1ucQ9ZifzkStsOIJz8055MCQUhOiZtyThFkdr+bTt8gwRQHMEe63ULNwnhU2Qsia8fkX2lNBmotO/jRYGo9AOkfp1jKKbP5baZUO3a/a92FJo44RFCyY5EiWKpcDURgYzOJfUphNKy2BWT8KSviJgrVahP4ezJ7n/4FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710771287; c=relaxed/simple;
	bh=UO+5wsSGymUVPt4vVeQZ8EDKQ64Wom2tgJ8iYeh7rSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CdUeT/xUvj0MwIuPWuCZeD1HPN5Br9lrscsg6twnLwnGQQVDgFWyjPJjpufap4tYazCRzszXCyIGzYZrgDbwBEEH7ySyauVMv8jhW+U/Xs7SWfA22qJamISqBkYHPr0tJh4svSI+i5M8xuHB3EEA2M9MEcBxtqLytLmkvnsAdWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C94DBDA7;
	Mon, 18 Mar 2024 07:15:17 -0700 (PDT)
Received: from [10.57.12.69] (unknown [10.57.12.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F1013F67D;
	Mon, 18 Mar 2024 07:14:39 -0700 (PDT)
Message-ID: <fff76a4f-28c3-4e46-945f-54554441a93c@arm.com>
Date: Mon, 18 Mar 2024 14:14:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 12/28] KVM: arm64: Support timers in realm RECs
Content-Language: en-GB
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-13-steven.price@arm.com>
 <9ae4b453-4d5b-4537-b004-4db60183019a@os.amperecomputing.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <9ae4b453-4d5b-4537-b004-4db60183019a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2024 11:28, Ganapatrao Kulkarni wrote:
> 
> 
> On 27-01-2023 04:59 pm, Steven Price wrote:
>> The RMM keeps track of the timer while the realm REC is running, but on
>> exit to the normal world KVM is responsible for handling the timers.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/kvm/arch_timer.c  | 53 ++++++++++++++++++++++++++++++++----
>>   include/kvm/arm_arch_timer.h |  2 ++
>>   2 files changed, 49 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index bb24a76b4224..d4af9ee58550 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -130,6 +130,11 @@ static void timer_set_offset(struct
>> arch_timer_context *ctxt, u64 offset)
>>   {
>>       struct kvm_vcpu *vcpu = ctxt->vcpu;
>>   +    if (kvm_is_realm(vcpu->kvm)) {
>> +        WARN_ON(offset);
>> +        return;
>> +    }
>> +
>>       switch(arch_timer_ctx_index(ctxt)) {
>>       case TIMER_VTIMER:
>>           __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
>> @@ -411,6 +416,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu
>> *vcpu, bool new_level,
>>       }
>>   }
>>   +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
>> +{
>> +    struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
>> +    int i;
>> +
>> +    for (i = 0; i < NR_KVM_TIMERS; i++) {
> 
> Do we required to check for all timers, is realm/rmm uses hyp timers?

Good point, the realm guest can't use the hyp timers, so this should be
NR_KVM_EL0_TIMERS. The hyp timers are used by the host to interrupt the
guest execution. I think this code was written before NV support added
the extra timers.

>> +        struct arch_timer_context *timer = &arch_timer->timers[i];
>> +        bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
>> +        bool level = kvm_timer_irq_can_fire(timer) && status;
>> +
>> +        if (level != timer->irq.level)
>> +            kvm_timer_update_irq(vcpu, level, timer);
>> +    }
>> +}
>> +
>>   /* Only called for a fully emulated timer */
>>   static void timer_emulate(struct arch_timer_context *ctx)
>>   {
>> @@ -621,6 +641,11 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>>       if (unlikely(!timer->enabled))
>>           return;
>>   +    kvm_timer_unblocking(vcpu);
>> +
>> +    if (vcpu_is_rec(vcpu))
>> +        return;
>> +
> 
> For realm, timer->enabled is not set, load returns before this check.

True, this can be simplified. Thanks.

Steve

>>       get_timer_map(vcpu, &map);
>>         if (static_branch_likely(&has_gic_active_state)) {
>> @@ -633,8 +658,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>>         set_cntvoff(timer_get_offset(map.direct_vtimer));
>>   -    kvm_timer_unblocking(vcpu);
>> -
>>       timer_restore_state(map.direct_vtimer);
>>       if (map.direct_ptimer)
>>           timer_restore_state(map.direct_ptimer);
>> @@ -668,6 +691,9 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>>       if (unlikely(!timer->enabled))
>>           return;
>>   +    if (vcpu_is_rec(vcpu))
>> +        goto out;
>> +
>>       get_timer_map(vcpu, &map);
>>         timer_save_state(map.direct_vtimer);
>> @@ -686,9 +712,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>>       if (map.emul_ptimer)
>>           soft_timer_cancel(&map.emul_ptimer->hrtimer);
>>   -    if (kvm_vcpu_is_blocking(vcpu))
>> -        kvm_timer_blocking(vcpu);
>> -
>>       /*
>>        * The kernel may decide to run userspace after calling
>> vcpu_put, so
>>        * we reset cntvoff to 0 to ensure a consistent read between user
>> @@ -697,6 +720,11 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>>        * virtual offset of zero, so no need to zero CNTVOFF_EL2 register.
>>        */
>>       set_cntvoff(0);
>> +
>> +out:
>> +    if (kvm_vcpu_is_blocking(vcpu))
>> +        kvm_timer_blocking(vcpu);
>> +
>>   }
>>     /*
>> @@ -785,12 +813,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>       struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>>       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>>       struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> +    u64 cntvoff;
>>         vtimer->vcpu = vcpu;
>>       ptimer->vcpu = vcpu;
>>   +    if (kvm_is_realm(vcpu->kvm))
>> +        cntvoff = 0;
>> +    else
>> +        cntvoff = kvm_phys_timer_read();
>> +
>>       /* Synchronize cntvoff across all vtimers of a VM. */
>> -    update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
>> +    update_vtimer_cntvoff(vcpu, cntvoff);
>>       timer_set_offset(ptimer, 0);
>>         hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC,
>> HRTIMER_MODE_ABS_HARD);
>> @@ -1265,6 +1299,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>           return -EINVAL;
>>       }
>>   +    /*
>> +     * We don't use mapped IRQs for Realms because the RMI doesn't allow
>> +     * us setting the LR.HW bit in the VGIC.
>> +     */
>> +    if (vcpu_is_rec(vcpu))
>> +        return 0;
>> +
>>       get_timer_map(vcpu, &map);
>>         ret = kvm_vgic_map_phys_irq(vcpu,
>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>> index cd6d8f260eab..158280e15a33 100644
>> --- a/include/kvm/arm_arch_timer.h
>> +++ b/include/kvm/arm_arch_timer.h
>> @@ -76,6 +76,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu,
>> struct kvm_device_attr *attr);
>>   int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct
>> kvm_device_attr *attr);
>>   int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct
>> kvm_device_attr *attr);
>>   +void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
>> +
>>   u64 kvm_phys_timer_read(void);
>>     void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
> 
> Thanks,
> Ganapat


