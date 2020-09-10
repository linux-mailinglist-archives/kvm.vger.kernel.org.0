Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F169626433C
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgIJKG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbgIJKGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:06:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DDD2145D;
        Thu, 10 Sep 2020 10:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599732375;
        bh=C+snSaZA8ZBO3q0gc3u/ZtSs9A6Zfxe83fdVxOebxeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aexmjgeIlOuf7o8/3vsTxY6s5ghVA4dP4oPjSddZgeEo4OONVkQe/myhLxgJ1tzbV
         KiuaN+csufQjiaPm5fpwF/tiQ97EeEXINclU22ZfFZ1m8g/1rj6o7LS4O7jMXc6wZU
         B5u9feq//iW5SBASH+t+o9K8VaPQH/bDeJJKW000=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kGJT3-00Ae10-8R; Thu, 10 Sep 2020 11:06:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Sep 2020 11:06:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
In-Reply-To: <20200908205730.23898-1-graf@amazon.com>
References: <20200908205730.23898-1-graf@amazon.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <9a4279aa9bf0a40bece3930c11c2f7cb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: graf@amazon.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-08 21:57, Alexander Graf wrote:
> We currently pass through the number of PMU counters that we have 
> available
> in hardware to guests. So if my host supports 10 concurrently active 
> PMU
> counters, my guest will be able to spawn 10 counters as well.
> 
> This is undesireable if we also want to use the PMU on the host for
> monitoring. In that case, we want to split the PMU between guest and
> host.
> 
> To help that case, let's add a PMU attr that allows us to limit the 
> number
> of PMU counters that we expose. With this patch in place, user space 
> can
> keep some counters free for host use.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> 
> ---
> 
> Because this patch touches the same code paths as the vPMU filtering 
> one
> and the vPMU filtering generalized a few conditions in the attr path,
> I've based it on top. Please let me know if you want it independent 
> instead.
> 
> v1 -> v2:
> 
>   - Add documentation
>   - Add read support
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 25 +++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  7 ++++---
>  arch/arm64/kvm/pmu-emul.c               | 32 
> ++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c               |  5 +++++
>  include/kvm/arm_pmu.h                   |  1 +
>  5 files changed, 67 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst
> b/Documentation/virt/kvm/devices/vcpu.rst
> index 203b91e93151..1a1c8d8c8b1d 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -102,6 +102,31 @@ isn't strictly speaking an event. Filtering the
> cycle counter is possible
>  using event 0x11 (CPU_CYCLES).
> 
> 
> +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_NUM_EVENTS
> +---------------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for the limit of 
> concurrent
> +             events is a pointer to an int
> +
> +:Returns:
> +
> +	 =======  ======================================================
> +	 -ENODEV: PMUv3 not supported
> +	 -EBUSY:  PMUv3 already initialized
> +	 -EINVAL: Too large number of events
> +	 =======  ======================================================
> +
> +Reconfigure the limit of concurrent PMU events that the guest can 
> monitor.
> +This number is directly exposed as part of the PMCR_EL0 register.
> +
> +On vcpu creation, this attribute is set to the hardware limit of the 
> current
> +platform. If you need to determine the hardware limit, you can read 
> this
> +attribute before setting it.
> +
> +Restrictions: The default value for this property is the number of 
> hardware
> +supported events. Only values that are smaller than the hardware limit 
> can
> +be set.
> +
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h
> b/arch/arm64/include/uapi/asm/kvm.h
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
> @@ -978,6 +980,25 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu
> *vcpu, struct kvm_device_attr *attr)
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
> @@ -1004,6 +1025,16 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu
> *vcpu, struct kvm_device_attr *attr)
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
> @@ -1015,6 +1046,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu
> *vcpu, struct kvm_device_attr *attr)
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
> @@ -672,6 +672,11 @@ static void reset_pmcr(struct kvm_vcpu *vcpu,
> const struct sys_reg_desc *r)
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

I see several problems with this approach:

- userspace doesn't really have a good way to retrieve the number of
   counters.

- Limiting the number of counters for the guest doesn't mean anything
   when it comes to the actual use of the HW counters, given that we
   don't allocate them ourselves (it's all perf doing the actual work).

- If you want to "pin" counters for the host, why don't you just do
   that before starting the guest?

I think you need to look at the bigger picture: how to limit the use
of physical counter usage for a given userspace task. This needs
to happen in perf itself, and not in KVM.

         M.
-- 
Jazz is not dead. It just smells funny...
