Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FC06CFB7C
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 08:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjC3G1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 02:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3G07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 02:26:59 -0400
Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [IPv6:2001:41d0:203:375::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445B52720
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 23:26:58 -0700 (PDT)
Date:   Thu, 30 Mar 2023 06:26:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680157615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ZgdS+jUR77XvVW3n9V6I+tOmSVWjH7Tk5zLOJ1pRgs=;
        b=F4TZAeqZOKKQ97cdEt/KMQGRxuNgzSeL4b3yDGZy7vSisg6Xg4nM+4GBe+ahw3bOR1pu2t
        LaJYfau3ifJTik6iAwhLoDSBgXFs7QVgTe4SDV1yQpjCHOB68NW2FDTELlln/cdyTyPpDo
        Ff3NBwUECR0GGo1bicOGApVCIyeEMEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v3 07/18] KVM: arm64: timers: Allow userspace to set the
 global counter offset
Message-ID: <ZCUrqIwNNdcAUSv3@linux.dev>
References: <20230324144704.4193635-1-maz@kernel.org>
 <20230324144704.4193635-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324144704.4193635-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Mar 24, 2023 at 02:46:53PM +0000, Marc Zyngier wrote:
> And this is the moment you have all been waiting for: setting the
> counter offset from userspace.
> 
> We expose a brand new capability that reports the ability to set
> the offset for both the virtual and physical sides.
> 
> In keeping with the architecture, the offset is expressed as
> a delta that is substracted from the physical counter value.
> 
> Once this new API is used, there is no going back, and the counters
> cannot be written to to set the offsets implicitly (the writes
> are instead ignored).
> 
> Reviewed-by: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 +++
>  arch/arm64/include/uapi/asm/kvm.h |  9 ++++++
>  arch/arm64/kvm/arch_timer.c       | 46 +++++++++++++++++++++++++++----
>  arch/arm64/kvm/arm.c              |  8 ++++++
>  include/uapi/linux/kvm.h          |  3 ++
>  5 files changed, 65 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 002a10cbade2..116233a390e9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -221,6 +221,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_EL1_32BIT				4
>  	/* PSCI SYSTEM_SUSPEND enabled for the guest */
>  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
> +	/* VM counter offset */
> +#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
>  
>  	unsigned long flags;
>  
> @@ -1010,6 +1012,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
> +int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> +				    struct kvm_arm_counter_offset *offset);
>  
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f8129c624b07..12fb0d8a760a 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -198,6 +198,15 @@ struct kvm_arm_copy_mte_tags {
>  	__u64 reserved[2];
>  };
>  
> +/*
> + * Counter/Timer offset structure. Describe the virtual/physical offset.
> + * To be used with KVM_ARM_SET_COUNTER_OFFSET.
> + */
> +struct kvm_arm_counter_offset {
> +	__u64 counter_offset;
> +	__u64 reserved;
> +};
> +
>  #define KVM_ARM_TAGS_TO_GUEST		0
>  #define KVM_ARM_TAGS_FROM_GUEST		1
>  
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index bb64a71ae193..25625e1d6d89 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -851,9 +851,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	ptimer->vcpu = vcpu;
>  	ptimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.poffset;
>  
> -	/* Synchronize cntvoff across all vtimers of a VM. */
> -	timer_set_offset(vtimer, kvm_phys_timer_read());
> -	timer_set_offset(ptimer, 0);
> +	/* Synchronize offsets across timers of a VM if not already provided */
> +	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
> +		timer_set_offset(vtimer, kvm_phys_timer_read());
> +		timer_set_offset(ptimer, 0);
> +	}
>  
>  	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
>  	timer->bg_timer.function = kvm_bg_timer_expire;
> @@ -897,8 +899,11 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
>  		break;
>  	case KVM_REG_ARM_TIMER_CNT:
> -		timer = vcpu_vtimer(vcpu);
> -		timer_set_offset(timer, kvm_phys_timer_read() - value);
> +		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
> +			      &vcpu->kvm->arch.flags)) {
> +			timer = vcpu_vtimer(vcpu);
> +			timer_set_offset(timer, kvm_phys_timer_read() - value);
> +		}
>  		break;
>  	case KVM_REG_ARM_TIMER_CVAL:
>  		timer = vcpu_vtimer(vcpu);
> @@ -908,6 +913,13 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  		timer = vcpu_ptimer(vcpu);
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
>  		break;
> +	case KVM_REG_ARM_PTIMER_CNT:
> +		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
> +			      &vcpu->kvm->arch.flags)) {
> +			timer = vcpu_ptimer(vcpu);
> +			timer_set_offset(timer, kvm_phys_timer_read() - value);
> +		}
> +		break;
>  	case KVM_REG_ARM_PTIMER_CVAL:
>  		timer = vcpu_ptimer(vcpu);
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
> @@ -1443,3 +1455,27 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  
>  	return -ENXIO;
>  }
> +
> +int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> +				    struct kvm_arm_counter_offset *offset)
> +{
> +	if (offset->reserved)
> +		return -EINVAL;
> +
> +	if (!lock_all_vcpus(kvm))
> +		return -EBUSY;

Similar to what you had mentioned over on the lock (un)inversion series,
doesn't this risk racing with vCPU creation w/o holding the kvm->lock?

Alternatively you could require this ioctl to be issued before any vCPUs
are created to avoid the need to lock them all here. But, if you see
value in poking this at runtime then fine by me.

-- 
Thanks,
Oliver
