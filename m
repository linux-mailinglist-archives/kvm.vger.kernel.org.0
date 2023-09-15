Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC607A2740
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237009AbjIOTdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbjIOTdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:33:33 -0400
Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EB61FC9
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:33:28 -0700 (PDT)
Date:   Fri, 15 Sep 2023 19:33:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694806406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ggp2BB16iuPy0E9mpIKP4GvDgaoK0t3AKedagkTatk=;
        b=ZzbIXviTy6bhzqZZX5Ps8kN8VwMXijVJBl8SakQ+eOQu2eaUOTkrr24QCItPxAwDZ4fuyw
        1hh5gZkmOd82Epwsq1elQzCHy8ZZ5gh9ICdXBB3IkqiWRAl/WGWSHhGVvs9I1YlmAb9C3v
        AQ/T2RAVP3V6v1p0eYFhGlBhKJs1Mpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
Message-ID: <ZQSxgWWZ3YdNgeiC@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023 at 12:30:19AM +0000, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> The following patches will use the number of counters information
> from the arm_pmu and use this to set the PMCR.N for the guest
> during vCPU reset. However, since the guest is not associated
> with any arm_pmu until userspace configures the vPMU device
> attributes, and a reset can happen before this event, call
> kvm_arm_support_pmu_v3() just before doing the reset.
> 
> No functional change intended.

But there absolutely is a functional change here, and user visible at
that. KVM_ARM_VCPU_INIT ioctls can now fail with -ENODEV, which is not
part of the documented errors for the interface.

> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c |  9 +--------
>  arch/arm64/kvm/reset.c    | 18 +++++++++++++-----
>  include/kvm/arm_pmu.h     |  6 ++++++
>  3 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0ffd1efa90c07..b87822024828a 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -865,7 +865,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	return true;
>  }
>  
> -static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> +int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>  {
>  	lockdep_assert_held(&kvm->arch.config_lock);
>  
> @@ -937,13 +937,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	if (vcpu->arch.pmu.created)
>  		return -EBUSY;
>  
> -	if (!kvm->arch.arm_pmu) {
> -		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
> -
> -		if (ret)
> -			return ret;
> -	}
> -
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PMU_V3_IRQ: {
>  		int __user *uaddr = (int __user *)(long)attr->addr;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index bc8556b6f4590..4c20f1ccd0789 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -206,6 +206,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>   */
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm *kvm = vcpu->kvm;
>  	struct vcpu_reset_state reset_state;
>  	int ret;
>  	bool loaded;
> @@ -216,6 +217,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	vcpu->arch.reset_state.reset = false;
>  	spin_unlock(&vcpu->arch.mp_state_lock);
>  
> +	/*
> +	 * When the vCPU has a PMU, but no PMU is set for the guest
> +	 * yet, set the default one.
> +	 */
> +	if (kvm_vcpu_has_pmu(vcpu) && unlikely(!kvm->arch.arm_pmu)) {
> +		ret = -EINVAL;
> +		if (kvm_arm_support_pmu_v3())
> +			ret = kvm_arm_set_vm_pmu(kvm, NULL);
> +		if (ret)
> +			return ret;
> +	}
> +

On top of my prior suggestion w.r.t. the default PMU helper, I'd rather
see this block look like:

	if (kvm_vcpu_has_pmu(vcpu)) {
		if (!kvm_arm_support_pmu_v3())
			return -EINVAL;
		/*
		 * When the vCPU has a PMU but no PMU is set for the
		 * guest yet, set the default one.
		 */
		if (unlikely(!kvm->arch.arm_pmu) && kvm_set_default_pmu(kvm))
			return -EINVAL;
	}

This would eliminate the possibility of returning ENODEV to userspace
where we shouldn't.

-- 
Thanks,
Oliver
