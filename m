Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6DD699F98
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 23:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBPWJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 17:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBPWJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 17:09:56 -0500
Received: from out-167.mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C43038EAB
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:09:53 -0800 (PST)
Date:   Thu, 16 Feb 2023 22:09:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676585391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gusSgHuRHriX2I9klAI50JRbZs+tVNNAeSSjo6yWKTI=;
        b=LNM6OwO6sNPPCQV4z+PFFWnANCMMXAgF3YFDR+IAudGiHrUmkpWhg4clYh9IVHLII1hlsV
        oYlhWsEGE+xYZ+doFjaFE3FIh6S5FVBebSSINyxzt9e3My7TTbM2qV0ti9Sj3ZJuwQODcj
        zTxXwGQtIwyK5Ir47AzVUYCgA4BRAMc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: Re: [PATCH 08/16] KVM: arm64: timers: Allow userspace to set the
 counter offsets
Message-ID: <Y+6pqz3pCwu7izZL@linux.dev>
References: <20230216142123.2638675-1-maz@kernel.org>
 <20230216142123.2638675-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216142123.2638675-9-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Feb 16, 2023 at 02:21:15PM +0000, Marc Zyngier wrote:
> And this is the moment you have all been waiting for: setting the
> counter offsets from userspace.
> 
> We expose a brand new capability that reports the ability to set
> the offsets for both the virtual and physical sides, independently.
> 
> In keeping with the architecture, the offsets are expressed as
> a delta that is substracted from the physical counter value.
> 
> Once this new API is used, there is no going back, and the counters
> cannot be written to to set the offsets implicitly (the writes
> are instead ignored).

Is there any particular reason to use an explicit ioctl as opposed to
the KVM_{GET,SET}_DEVICE_ATTR ioctls? Dunno where you stand on it, but I
quite like that interface for simple state management. We also avoid
eating up more UAPI bits in the global namespace.

You could also split up the two offsets as individual attributes, but I
really couldn't care less. Its userspace's problem after all!

And on that note, any VMM patches to match this implementation? kvmtool
would suffice, just want something that runs a real VM and pokes these
ioctls.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  4 +++
>  arch/arm64/include/uapi/asm/kvm.h | 15 ++++++++++
>  arch/arm64/kvm/arch_timer.c       | 46 +++++++++++++++++++++++++++----
>  arch/arm64/kvm/arm.c              |  8 ++++++
>  include/uapi/linux/kvm.h          |  3 ++
>  5 files changed, 71 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3adac0c5e175..8514a37cf8d5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -221,6 +221,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_EL1_32BIT				4
>  	/* PSCI SYSTEM_SUSPEND enabled for the guest */
>  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
> +	/* VM counter offsets */
> +#define KVM_ARCH_FLAG_COUNTER_OFFSETS			6

nit: I'm not too bothered by the test_bit(...) mouthful when its used
sparingly but it may be nice to have a helper if it is repeated enough
times.

>  	unsigned long flags;
>  
> @@ -1010,6 +1012,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
> +int kvm_vm_ioctl_set_counter_offsets(struct kvm *kvm,
> +				     struct kvm_arm_counter_offsets *offsets);
>  
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f8129c624b07..2d7557a160bd 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -198,6 +198,21 @@ struct kvm_arm_copy_mte_tags {
>  	__u64 reserved[2];
>  };
>  
> +/*
> + * Counter/Timer offset structure. Describe the virtual/physical offsets.
> + * To be used with KVM_ARM_SET_CNT_OFFSETS.
> + */
> +struct kvm_arm_counter_offsets {
> +	__u64 virtual_offset;
> +	__u64 physical_offset;
> +
> +#define KVM_COUNTER_SET_VOFFSET_FLAG	(1UL << 0)
> +#define KVM_COUNTER_SET_POFFSET_FLAG	(1UL << 1)
> +
> +	__u64 flags;
> +	__u64 reserved;
> +};
> +
>  #define KVM_ARM_TAGS_TO_GUEST		0
>  #define KVM_ARM_TAGS_FROM_GUEST		1
>  
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 444ea6dca218..b04544b702f9 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -852,9 +852,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	ptimer->vcpu = vcpu;
>  	ptimer->offset.vm_offset = &vcpu->kvm->arch.offsets.poffset;
>  
> -	/* Synchronize cntvoff across all vtimers of a VM. */
> -	timer_set_offset(vtimer, kvm_phys_timer_read());
> -	timer_set_offset(ptimer, 0);
> +	/* Synchronize offsets across timers of a VM if not already provided */
> +	if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS, &vcpu->kvm->arch.flags)) {
> +		timer_set_offset(vtimer, kvm_phys_timer_read());
> +		timer_set_offset(ptimer, 0);
> +	}
>  
>  	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
>  	timer->bg_timer.function = kvm_bg_timer_expire;
> @@ -898,8 +900,11 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
>  		break;
>  	case KVM_REG_ARM_TIMER_CNT:
> -		timer = vcpu_vtimer(vcpu);
> -		timer_set_offset(timer, kvm_phys_timer_read() - value);
> +		if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS,
> +			      &vcpu->kvm->arch.flags)) {
> +			timer = vcpu_vtimer(vcpu);
> +			timer_set_offset(timer, kvm_phys_timer_read() - value);
> +		}

If we've already got userspace to buy in to the new UAPI, should we
return an error instead of silently failing? Might be good to catch
misbehavior in the act, even if it is benign as this patch is written.

>  		break;
>  	case KVM_REG_ARM_TIMER_CVAL:
>  		timer = vcpu_vtimer(vcpu);
> @@ -909,6 +914,13 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  		timer = vcpu_ptimer(vcpu);
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
>  		break;
> +	case KVM_REG_ARM_PTIMER_CNT:
> +		if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS,
> +			      &vcpu->kvm->arch.flags)) {
> +			timer = vcpu_ptimer(vcpu);
> +			timer_set_offset(timer, kvm_phys_timer_read() - value);
> +		}
> +		break;
>  	case KVM_REG_ARM_PTIMER_CVAL:
>  		timer = vcpu_ptimer(vcpu);
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
> @@ -1446,3 +1458,27 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  
>  	return -ENXIO;
>  }
> +
> +int kvm_vm_ioctl_set_counter_offsets(struct kvm *kvm,
> +				     struct kvm_arm_counter_offsets *offsets)
> +{
> +	if (offsets->reserved ||
> +	    (offsets->flags & ~(KVM_COUNTER_SET_VOFFSET_FLAG |
> +				KVM_COUNTER_SET_POFFSET_FLAG)))
> +		return -EINVAL;
> +
> +	if (!lock_all_vcpus(kvm))
> +		return -EBUSY;

Is there any reason why we can't just order this ioctl before vCPU
creation altogether, or is there a need to do this at runtime? We're
about to tolerate multiple writers to the offset value, and I think the
only thing we need to guarantee is that the below flag is set before
vCPU ioctls have a chance to run.

Actually, the one benefit of enforcing a strict ordering is that you can
hide the old register indices completely from KVM_GET_REG_LIST to
provide further discouragement to userspace.

Otherwise, if you choose to keep it this way then the requirement to
have no vCPU ioctls in flight needs to be explicitly documented as that
is a bit of a tricky interface.

> +	set_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS, &kvm->arch.flags);
> +
> +	if (offsets->flags & KVM_COUNTER_SET_VOFFSET_FLAG)
> +		kvm->arch.offsets.voffset = offsets->virtual_offset;
> +
> +	if (offsets->flags & KVM_COUNTER_SET_POFFSET_FLAG)
> +		kvm->arch.offsets.poffset = offsets->physical_offset;
> +
> +	unlock_all_vcpus(kvm);
> +
> +	return 0;
> +}

-- 
Thanks,
Oliver
