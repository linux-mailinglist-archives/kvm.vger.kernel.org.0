Return-Path: <kvm+bounces-51979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E937AAFEDC4
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 17:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A8FC189D056
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D622E8DF9;
	Wed,  9 Jul 2025 15:29:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BC9156F4A;
	Wed,  9 Jul 2025 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752074988; cv=none; b=YGdMUPiHyU2Wivq3zgCKZxiqcrqGzAVaDiXKXALldTVCiKrvnXzRaTAe21jbVLreW4chQHHHPOzMpyLprwWQdvo3SKlwdPLmmcvsI+9rF8lycxxdN5YaXsuak+XTtydLKyONLHuClBeMdRIJICedMTbAWGJmxlTXk3DLMujlSBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752074988; c=relaxed/simple;
	bh=hxwENio9vqhZJqqfY5hcdmYC9aTUCi3OKuArnu64jOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AY5FeSU84LazKzskLD4FmoiLcDPOtbGh/d0oziIUfuKe1W3Ur1SvSvBaNRxpCElzQKm7A2lk2WPrHJoqUxrKbOMm0sw5LjNQ9MN1it14Ea6mMEHEqrqJZJPijRG4yQnI/AD3PHiR4Eq2vm3Q2nYKooFNRN3m9PoKHXyW0VpcE40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CE521424;
	Wed,  9 Jul 2025 08:29:34 -0700 (PDT)
Received: from [10.57.86.38] (unknown [10.57.86.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E72943F738;
	Wed,  9 Jul 2025 08:29:41 -0700 (PDT)
Message-ID: <8757342e-26e6-467c-a469-0ac1120bcdd9@arm.com>
Date: Wed, 9 Jul 2025 16:29:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/43] KVM: arm64: Support timers in realm RECs
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-15-steven.price@arm.com>
 <20250709144939.GA2753450@e124191.cambridge.arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20250709144939.GA2753450@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 09/07/2025 15:49, Joey Gouly wrote:
> Hi Steven,
> 
> On Wed, Jun 11, 2025 at 11:48:11AM +0100, Steven Price wrote:
>> The RMM keeps track of the timer while the realm REC is running, but on
>> exit to the normal world KVM is responsible for handling the timers.
>>
>> The RMM doesn't provide a mechanism to set the counter offset, so don't
>> expose KVM_CAP_COUNTER_OFFSET for a realm VM.
>>
>> A later patch adds the support for propagating the timer values from the
>> exit data structure and calling kvm_realm_timers_update().
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>  * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
>> ---
>>  arch/arm64/kvm/arch_timer.c  | 48 +++++++++++++++++++++++++++++++++---
>>  arch/arm64/kvm/arm.c         |  2 +-
>>  include/kvm/arm_arch_timer.h |  2 ++
>>  3 files changed, 47 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index fdbc8beec930..7f8705d6fdf5 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
>> @@ -148,6 +148,13 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>>  
>>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>>  {
>> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
>> +
>> +	if (kvm_is_realm(vcpu->kvm)) {
>> +		WARN_ON(offset);
>> +		return;
>> +	}
>> +
>>  	if (!ctxt->offset.vm_offset) {
>>  		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>>  		return;
>> @@ -462,6 +469,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>>  			    timer_ctx);
>>  }
>>  
>> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
>> +	int i;
>> +
>> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
>> +		struct arch_timer_context *timer = &arch_timer->timers[i];
>> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
>> +		bool level = kvm_timer_irq_can_fire(timer) && status;
>> +
>> +		if (level != timer->irq.level)
>> +			kvm_timer_update_irq(vcpu, level, timer);
>> +	}
>> +}
>> +
>>  /* Only called for a fully emulated timer */
>>  static void timer_emulate(struct arch_timer_context *ctx)
>>  {
>> @@ -870,6 +892,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>>  	if (unlikely(!timer->enabled))
>>  		return;
>>  
>> +	kvm_timer_unblocking(vcpu);
>> +
>>  	get_timer_map(vcpu, &map);
>>  
>>  	if (static_branch_likely(&has_gic_active_state)) {
>> @@ -883,8 +907,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>>  		kvm_timer_vcpu_load_nogic(vcpu);
>>  	}
>>  
>> -	kvm_timer_unblocking(vcpu);
>> -
> 
> The change here to move kvm_timer_unblocking() looks unnecessary, as the change
> to add an early return in kvm_timer_enable() causes timer->enable to never be
> set to 1.  Since it is never set, kvm_timer_vcpu_load() will return early
> before this call to kvm_timer_unblocking().

Good spot.

Looking through the code it makes sense keeping the timer disabled
because that also disables all the code for loading/unloading the timer
state which we don't want for realms (because the RMM deals with that).
So I think just reverting the above change to move
kvm_timer_unblocking() is the correct approach.

Thanks,
Steve

> Thanks,
> Joey
> 
>>  	timer_restore_state(map.direct_vtimer);
>>  	if (map.direct_ptimer)
>>  		timer_restore_state(map.direct_ptimer);
>> @@ -1065,7 +1087,9 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>>  
>>  	ctxt->vcpu = vcpu;
>>  
>> -	if (timerid == TIMER_VTIMER)
>> +	if (kvm_is_realm(vcpu->kvm))
>> +		ctxt->offset.vm_offset = NULL;
>> +	else if (timerid == TIMER_VTIMER)
>>  		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>>  	else
>>  		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
>> @@ -1087,13 +1111,19 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>  {
>>  	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>> +	u64 cntvoff;
>>  
>>  	for (int i = 0; i < NR_KVM_TIMERS; i++)
>>  		timer_context_init(vcpu, i);
>>  
>> +	if (kvm_is_realm(vcpu->kvm))
>> +		cntvoff = 0;
>> +	else
>> +		cntvoff = kvm_phys_timer_read();
>> +
>>  	/* Synchronize offsets across timers of a VM if not already provided */
>>  	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>> -		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>> +		timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
>>  		timer_set_offset(vcpu_ptimer(vcpu), 0);
>>  	}
>>  
>> @@ -1633,6 +1663,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>  		return -EINVAL;
>>  	}
>>  
>> +	/*
>> +	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
>> +	 * us setting the LR.HW bit in the VGIC.
>> +	 */
>> +	if (vcpu_is_rec(vcpu))
>> +		return 0;
>> +
>>  	get_timer_map(vcpu, &map);
>>  
>>  	ret = kvm_vgic_map_phys_irq(vcpu,
>> @@ -1764,6 +1801,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>>  	if (offset->reserved)
>>  		return -EINVAL;
>>  
>> +	if (kvm_is_realm(kvm))
>> +		return -EINVAL;
>> +
>>  	mutex_lock(&kvm->lock);
>>  
>>  	if (!kvm_trylock_all_vcpus(kvm)) {
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 0cdcc2ca4a88..6a5c9be4af2d 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -350,10 +350,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_PTP_KVM:
>>  	case KVM_CAP_ARM_SYSTEM_SUSPEND:
>>  	case KVM_CAP_IRQFD_RESAMPLE:
>> -	case KVM_CAP_COUNTER_OFFSET:
>>  	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
>>  		r = 1;
>>  		break;
>> +	case KVM_CAP_COUNTER_OFFSET:
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>  		r = !kvm_is_realm(kvm);
>>  		break;
>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>> index 681cf0c8b9df..f64e317c091b 100644
>> --- a/include/kvm/arm_arch_timer.h
>> +++ b/include/kvm/arm_arch_timer.h
>> @@ -113,6 +113,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>  int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>  
>> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
>> +
>>  u64 kvm_phys_timer_read(void);
>>  
>>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
>> -- 
>> 2.43.0
>>


