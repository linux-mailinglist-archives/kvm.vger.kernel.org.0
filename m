Return-Path: <kvm+bounces-40068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58290A4EC81
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAFD8E47B1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4521529238C;
	Tue,  4 Mar 2025 17:59:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE45202F89;
	Tue,  4 Mar 2025 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741111167; cv=none; b=JAFpjHhmF3MfQcVZvuk7leEmOG9q3XFOKyca2oLyRhUoWzbpvC4FcKvUmS78WObTOK4nbMLVH+CDWhb+giL+2CfMRurfqUw6r9JZVj3sQUYlF+BMXfKPUqS57EiSqKnrGY7RTmfVGYST9UarVrz/pWtpDLKTDaf6sR5nDfvsITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741111167; c=relaxed/simple;
	bh=oVD1GE3NzUYwD56omqTkMkV8FxpM5ALoGZ32XZaFoUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwMeBd5etYX8Xn+sotfvbI5KX3SNREnEfleBDGlpp+7xUHXR5x8wOCdnx3LSvsLL1lVNtZsDX13C7QneOQ8mo68hG4Y9AJpYP14s6JQfC++65Fgov0SsgfbFxDzK24f4jvfGjMjJud+3WjWT0+popcW5NJaHhTyh0vCDD1pdRj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23A042F;
	Tue,  4 Mar 2025 09:59:38 -0800 (PST)
Received: from [10.57.39.179] (unknown [10.57.39.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E329B3F5A1;
	Tue,  4 Mar 2025 09:59:20 -0800 (PST)
Message-ID: <d3181dde-1070-4101-a5f7-7e42d0ec2f99@arm.com>
Date: Tue, 4 Mar 2025 17:59:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/45] KVM: arm64: Support timers in realm RECs
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-16-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250213161426.102987-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/02/2025 16:13, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and calling kvm_realm_timers_update().
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arch_timer.c  | 45 ++++++++++++++++++++++++++++++++----
>   include/kvm/arm_arch_timer.h |  2 ++
>   2 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index d3d243366536..06b68bcd244f 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -148,6 +148,13 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>   
>   static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>   {
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	if (kvm_is_realm(vcpu->kvm)) {
> +		WARN_ON(offset);
> +		return;
> +	}
> +
>   	if (!ctxt->offset.vm_offset) {
>   		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>   		return;
> @@ -464,6 +471,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   	}
>   }
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
> +	int i;
> +
> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
> +		struct arch_timer_context *timer = &arch_timer->timers[i];
> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
> +		bool level = kvm_timer_irq_can_fire(timer) && status;
> +
> +		if (level != timer->irq.level)
> +			kvm_timer_update_irq(vcpu, level, timer);
> +	}
> +}
> +
>   /* Only called for a fully emulated timer */
>   static void timer_emulate(struct arch_timer_context *ctx)
>   {
> @@ -889,6 +911,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   	if (unlikely(!timer->enabled))
>   		return;
>   
> +	kvm_timer_unblocking(vcpu);
> +
>   	get_timer_map(vcpu, &map);
>   
>   	if (static_branch_likely(&has_gic_active_state)) {
> @@ -902,8 +926,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   		kvm_timer_vcpu_load_nogic(vcpu);
>   	}
>   
> -	kvm_timer_unblocking(vcpu);
> -
>   	timer_restore_state(map.direct_vtimer);
>   	if (map.direct_ptimer)
>   		timer_restore_state(map.direct_ptimer);
> @@ -1094,7 +1116,9 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>   
>   	ctxt->vcpu = vcpu;
>   
> -	if (timerid == TIMER_VTIMER)
> +	if (kvm_is_realm(vcpu->kvm))
> +		ctxt->offset.vm_offset = NULL;
> +	else if (timerid == TIMER_VTIMER)
>   		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;

I think we need to disable the KVM_CAP_COUNTER_OFFSET for Realms and
also deny KVM_ARM_SET_COUNTER_OFFSET vm_ioctl.

Suzuki



