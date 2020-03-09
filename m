Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A917E65D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 19:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgCISFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 14:05:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726269AbgCISFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 14:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583777137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kP7sVkwOS3ofanVWmMfztmyQ1DBwa2+YN9KmONlqah4=;
        b=RIQ+Ht3lC3Vf+2cRwuNnAGott19d0ZTIYELDziRV2BYU3G4jKCKqWs2rJ6Bv3wZsvNe4cW
        xpOhK5/ESM7HgTRcCk/MifUOReGz8JwxLVOL7uynjK0QHr2n+yaaugi4HgmyBt40sqAVr1
        MvRzSn1VJChd0G50V80F9mAV1prK1Dg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-knvtoQyNOd2zsv6aQW4REw-1; Mon, 09 Mar 2020 14:05:30 -0400
X-MC-Unique: knvtoQyNOd2zsv6aQW4REw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D783E477;
        Mon,  9 Mar 2020 18:05:28 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86EC55D9C5;
        Mon,  9 Mar 2020 18:05:26 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add PMU event filtering infrastructure
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-2-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <70e712fc-6789-2384-c21c-d932b5e1a32f@redhat.com>
Date:   Mon, 9 Mar 2020 19:05:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200309124837.19908-2-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/9/20 1:48 PM, Marc Zyngier wrote:
> It can be desirable to expose a PMU to a guest, and yet not want the
> guest to be able to count some of the implemented events (because this
> would give information on shared resources, for example.
> 
> For this, let's extend the PMUv3 device API, and offer a way to setup a
> bitmap of the allowed events (the default being no bitmap, and thus no
> filtering).
> 
> Userspace can thus allow/deny ranges of event. The default policy
> depends on the "polarity" of the first filter setup (default deny if the
> filter allows events, and default allow if the filter denies events).
> This allows to setup exactly what is allowed for a given guest.
> 
> Note that although the ioctl is per-vcpu, the map of allowed events is
> global to the VM (it can be setup from any vcpu until the vcpu PMU is
> initialized).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  6 +++
>  arch/arm64/include/uapi/asm/kvm.h | 16 ++++++
>  virt/kvm/arm/arm.c                |  2 +
>  virt/kvm/arm/pmu.c                | 84 +++++++++++++++++++++++++------
>  4 files changed, 92 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 57fd46acd058..8e63c618688d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -91,6 +91,12 @@ struct kvm_arch {
>  	 * supported.
>  	 */
>  	bool return_nisv_io_abort_to_user;
> +
> +	/*
> +	 * VM-wide PMU filter, implemented as a bitmap and big enough
> +	 * for up to 65536 events
> +	 */
> +	unsigned long *pmu_filter;
>  };
>  
>  #define KVM_NR_MEM_OBJS     40
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index ba85bb23f060..7b1511d6ce44 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -159,6 +159,21 @@ struct kvm_sync_regs {
>  struct kvm_arch_memory_slot {
>  };
>  
> +/*
> + * PMU filter structure. Describe a range of events with a particular
> + * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
> + */
> +struct kvm_pmu_event_filter {
> +	__u16	base_event;
> +	__u16	nevents;
> +
> +#define KVM_PMU_EVENT_ALLOW	0
> +#define KVM_PMU_EVENT_DENY	1
> +
> +	__u8	action;
> +	__u8	pad[3];
> +};
> +
>  /* for KVM_GET/SET_VCPU_EVENTS */
>  struct kvm_vcpu_events {
>  	struct {
> @@ -329,6 +344,7 @@ struct kvm_vcpu_events {
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
>  #define   KVM_ARM_VCPU_PMU_V3_INIT	1
> +#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index eda7b624eab8..8d849ac88a44 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -164,6 +164,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	free_percpu(kvm->arch.last_vcpu_ran);
>  	kvm->arch.last_vcpu_ran = NULL;
>  
> +	bitmap_free(kvm->arch.pmu_filter);
> +
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (kvm->vcpus[i]) {
>  			kvm_vcpu_destroy(kvm->vcpus[i]);
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index f0d0312c0a55..9f0fd0224d5b 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -579,10 +579,19 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  
>  	kvm_pmu_stop_counter(vcpu, pmc);
>  	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
> +	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> +		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
nit:
	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
	else
		eventsel = data & ARMV8_PMU_EVTYPE_EVENT;

>  
>  	/* Software increment event does't need to be backed by a perf event */
nit: while wer are at it fix the does't typo
> -	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
> -	    pmc->idx != ARMV8_PMU_CYCLE_IDX)
> +	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
> +		return;
> +
> +	/*
> +	 * If we have a filter in place and that the event isn't allowed, do
> +	 * not install a perf event either.
> +	 */
> +	if (vcpu->kvm->arch.pmu_filter &&
> +	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
>  		return;
>  
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
> @@ -594,8 +603,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>  	attr.exclude_hv = 1; /* Don't count EL2 events */
>  	attr.exclude_host = 1; /* Don't count host events */
> -	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
> -		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
> +	attr.config = eventsel;
So in that case the guest counter will not increment but the guest does
not know the counter is not implemented. Can't this lead to bad user
experience. Shouldn't this disablement be reflected in PMCEID0/1 regs?
>  
>  	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
>  
> @@ -735,15 +743,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>  
>  static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  {
> -	if (!kvm_arm_support_pmu_v3())
> -		return -ENODEV;
> -
> -	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> -		return -ENXIO;
> -
> -	if (vcpu->arch.pmu.created)
> -		return -EBUSY;
> -
>  	if (irqchip_in_kernel(vcpu->kvm)) {
>  		int ret;
>  
> @@ -794,8 +793,19 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	return true;
>  }
>  
> +#define NR_EVENTS	(ARMV8_PMU_EVTYPE_EVENT + 1)
> +
>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> +	if (!kvm_arm_support_pmu_v3())
> +		return -ENODEV;
> +
> +	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> +		return -ENODEV;
I see you changed -ENXIO into -ENODEV. wanted?
> +
> +	if (vcpu->arch.pmu.created)
> +		return -EBUSY;
> +
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PMU_V3_IRQ: {
>  		int __user *uaddr = (int __user *)(long)attr->addr;
> @@ -804,9 +814,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		if (!irqchip_in_kernel(vcpu->kvm))
>  			return -EINVAL;
>  
> -		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> -			return -ENODEV;
> -
>  		if (get_user(irq, uaddr))
>  			return -EFAULT;
>  
> @@ -824,6 +831,50 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		vcpu->arch.pmu.irq_num = irq;
>  		return 0;
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_FILTER: {
> +		struct kvm_pmu_event_filter __user *uaddr;
> +		struct kvm_pmu_event_filter filter;
> +
> +		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
> +
> +		if (copy_from_user(&filter, uaddr, sizeof(filter)))
> +			return -EFAULT;
> +
> +		if (((u32)filter.base_event + filter.nevents) > NR_EVENTS ||
isnt't it >= ?
> +		    (filter.action != KVM_PMU_EVENT_ALLOW &&
> +		     filter.action != KVM_PMU_EVENT_DENY))
> +			return -EINVAL;
-EINVAL is not documented in the API doc.
> +
> +		mutex_lock(&vcpu->kvm->lock);
> +
> +		if (!vcpu->kvm->arch.pmu_filter) {
> +			vcpu->kvm->arch.pmu_filter = bitmap_alloc(NR_EVENTS, GFP_KERNEL);
> +			if (!vcpu->kvm->arch.pmu_filter) {
> +				mutex_unlock(&vcpu->kvm->lock);
> +				return -ENOMEM;
> +			}
> +
> +			/*
> +			 * The default depends on the first applied filter.
> +			 * If it allows events, the default is to deny.
> +			 * Conversely, if the first filter denies a set of
> +			 * events, the default is to allow.
> +			 */
> +			if (filter.action == KVM_PMU_EVENT_ALLOW)
> +				bitmap_zero(vcpu->kvm->arch.pmu_filter, NR_EVENTS);
> +			else
> +				bitmap_fill(vcpu->kvm->arch.pmu_filter, NR_EVENTS);
> +		}
> +
> +		if (filter.action == KVM_PMU_EVENT_ALLOW)
> +			bitmap_set(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
> +		else
> +			bitmap_clear(vcpu->kvm->arch.pmu_filter, filter.base_event, filter.nevents);
> +
> +		mutex_unlock(&vcpu->kvm->lock);
> +
> +		return 0;
> +	}
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>  		return kvm_arm_pmu_v3_init(vcpu);
>  	}
> @@ -860,6 +911,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PMU_V3_IRQ:
not related to this patch but shouldn't we advertise this only with
in-kernel irqchip?
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
> +	case KVM_ARM_VCPU_PMU_V3_FILTER:
>  		if (kvm_arm_support_pmu_v3() &&
>  		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>  			return 0;
> 
Thanks

Eric

