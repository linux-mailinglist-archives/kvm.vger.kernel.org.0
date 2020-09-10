Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8759F263E7B
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgIJHWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:22:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730176AbgIJHW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599722520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9J12yIqoh3oJuHlnCwJnAPqIQmtqWYHOoKuX1BnkTs=;
        b=ZU9/C79qdwyGOrPPz6fi5s1b2kceldbT6qwkeVI72jzHpgTTwngopfIO37qQY4xXUzdwGe
        HrLGTMD0p/t2cSgcpffA5V4bsDEeIIayjh/Wj9IajTZJmH3j/ipIobEVfTGAwd5YyWFWW7
        x6SmyewRIauuAriXnmK73dbINXJ3798=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-Yga5ZlGoMKmri57BCV_Wyw-1; Thu, 10 Sep 2020 03:21:55 -0400
X-MC-Unique: Yga5ZlGoMKmri57BCV_Wyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 325B5801FDE;
        Thu, 10 Sep 2020 07:21:54 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67D1127BB8;
        Thu, 10 Sep 2020 07:21:51 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
To:     Alexander Graf <graf@amazon.com>, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200908205730.23898-1-graf@amazon.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <79606f01-7638-ed6f-27c8-1183c723cd60@redhat.com>
Date:   Thu, 10 Sep 2020 09:21:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200908205730.23898-1-graf@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 9/8/20 10:57 PM, Alexander Graf wrote:
> We currently pass through the number of PMU counters that we have available
> in hardware to guests. So if my host supports 10 concurrently active PMU
> counters, my guest will be able to spawn 10 counters as well.
> 
> This is undesireable if we also want to use the PMU on the host for
> monitoring. In that case, we want to split the PMU between guest and
> host.
but don't we have a trap and emulate approach as opposed to current SPE
implementation?
> 
> To help that case, let's add a PMU attr that allows us to limit the number
> of PMU counters that we expose. With this patch in place, user space can
> keep some counters free for host use.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> 
> ---
> 
> Because this patch touches the same code paths as the vPMU filtering one
> and the vPMU filtering generalized a few conditions in the attr path,
> I've based it on top. Please let me know if you want it independent instead.
> 
> v1 -> v2:
> 
>   - Add documentation
>   - Add read support
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 25 +++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  7 ++++---
>  arch/arm64/kvm/pmu-emul.c               | 32 ++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c               |  5 +++++
>  include/kvm/arm_pmu.h                   |  1 +
>  5 files changed, 67 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 203b91e93151..1a1c8d8c8b1d 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -102,6 +102,31 @@ isn't strictly speaking an event. Filtering the cycle counter is possible
>  using event 0x11 (CPU_CYCLES).
>  
>  
> +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_NUM_EVENTS
> +---------------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for the limit of concurrent
> +             events is a pointer to an int
> +
> +:Returns:
> +
> +	 =======  ======================================================
> +	 -ENODEV: PMUv3 not supported
> +	 -EBUSY:  PMUv3 already initialized
> +	 -EINVAL: Too large number of events
s/events/event counters

I see that in perf code indeed num_events is used for that but I think
for the end-user the event counter terminology is better as it fits the
ARM spec.
> +	 =======  ======================================================
> +
> +Reconfigure the limit of concurrent PMU events that the guest can monitor.
here also
> +This number is directly exposed as part of the PMCR_EL0 register.
Maybe quote the "N" field
> +
> +On vcpu creation, this attribute is set to the hardware limit of the current
> +platform. If you need to determine the hardware limit, you can read this
> +attribute before setting it.
> +
> +Restrictions: The default value for this property is the number of hardware
> +supported events. Only values that are smaller than the hardware limit can
event counters
> +be set.
> +
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 7b1511d6ce44..db025c0b5a40 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -342,9 +342,10 @@ struct kvm_vcpu_events {
>  
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
> -#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> -#define   KVM_ARM_VCPU_PMU_V3_INIT	1
> -#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
> +#define   KVM_ARM_VCPU_PMU_V3_IRQ		0
> +#define   KVM_ARM_VCPU_PMU_V3_INIT		1
> +#define   KVM_ARM_VCPU_PMU_V3_FILTER		2
> +#define   KVM_ARM_VCPU_PMU_V3_NUM_EVENTS	3
>  #define KVM_ARM_VCPU_TIMER_CTRL		1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0458860bade2..c7915b95fec0 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -253,6 +253,8 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>  		pmu->pmc[i].idx = i;
> +
> +	pmu->num_events = perf_num_counters() - 1;
>  }
>  
>  /**
> @@ -978,6 +980,25 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  
>  		return 0;
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
> +		u64 mask = ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT;
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		u32 num_events;
> +
> +		if (get_user(num_events, uaddr))
> +			return -EFAULT;
> +
> +		if (num_events >= perf_num_counters())
> +			return -EINVAL;
> +
> +		vcpu->arch.pmu.num_events = num_events;
> +
> +		num_events <<= ARMV8_PMU_PMCR_N_SHIFT;
> +		__vcpu_sys_reg(vcpu, SYS_PMCR_EL0) &= ~mask;
> +		__vcpu_sys_reg(vcpu, SYS_PMCR_EL0) |= num_events;
> +
> +		return 0;
> +	}
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>  		return kvm_arm_pmu_v3_init(vcpu);
>  	}
> @@ -1004,6 +1025,16 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		irq = vcpu->arch.pmu.irq_num;
>  		return put_user(irq, uaddr);
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		u32 num_events;
> +
> +		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> +			return -ENODEV;
> +
> +		num_events = vcpu->arch.pmu.num_events;
> +		return put_user(num_events, uaddr);
> +	}
>  	}
>  
>  	return -ENXIO;
> @@ -1015,6 +1046,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	case KVM_ARM_VCPU_PMU_V3_IRQ:
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>  	case KVM_ARM_VCPU_PMU_V3_FILTER:
> +	case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS:
>  		if (kvm_arm_support_pmu_v3() &&
>  		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>  			return 0;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 20ab2a7d37ca..d51e39600bbd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -672,6 +672,11 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
>  	if (!system_supports_32bit_el0())
>  		val |= ARMV8_PMU_PMCR_LC;
> +
> +	/* Override number of event selectors */
> +	val &= ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +	val |= (u32)vcpu->arch.pmu.num_events << ARMV8_PMU_PMCR_N_SHIFT;
> +
>  	__vcpu_sys_reg(vcpu, r->reg) = val;
>  }
>  
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 98cbfe885a53..ea3fc96a37d9 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -27,6 +27,7 @@ struct kvm_pmu {
>  	bool ready;
>  	bool created;
>  	bool irq_level;
> +	u8 num_events;
>  };
>  
>  #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
> 

Thanks

Eric

