Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0DD7AFD84
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 10:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjI0ICu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 04:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjI0ICt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 04:02:49 -0400
Received: from out-206.mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1492BF
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 01:02:47 -0700 (PDT)
Date:   Wed, 27 Sep 2023 08:02:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695801765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P1b5Vu+07ETgZbRINBDyHraEk19f7O0PJbIxNMiL+uw=;
        b=MvKjYHrYCAKE6MJeHVIPDbLVB7UDJsGnTRk6BcBQ/nKGRmhszabL6whjC3rmPsLpupHTxQ
        Iu2mElUNoePLQxX85XCn2Sd46cCd7Ip7oaD/P/Z+rqQh4eAXeBV7xIb9+fPXiOhBOvfRqk
        dy5Pn0ozwmok3Xl0WTydQ4tiIOMIKQ8=
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
Subject: Re: [PATCH v6 02/11] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
Message-ID: <ZRPhoExoiU3_Jvxy@linux.dev>
References: <20230926234008.2348607-1-rananta@google.com>
 <20230926234008.2348607-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926234008.2348607-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Tue, Sep 26, 2023 at 11:39:59PM +0000, Raghavendra Rao Ananta wrote:
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

I would argue there still is a functional change here, as PMU
initialization failure now shows up on a completely different ioctl for
userspace.

> @@ -216,6 +217,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	vcpu->arch.reset_state.reset = false;
>  	spin_unlock(&vcpu->arch.mp_state_lock);
>  
> +	if (kvm_vcpu_has_pmu(vcpu)) {
> +		if (!kvm_arm_support_pmu_v3())
> +			return -EINVAL;
> +
> +		/*
> +		 * When the vCPU has a PMU, but no PMU is set for the guest
> +		 * yet, set the default one.
> +		 */
> +		if (unlikely(!kvm->arch.arm_pmu) && kvm_arm_set_default_pmu(kvm))
> +			return -EINVAL;
> +	}
> +

Ah, this probably will not mix well with my recent change to get rid of
the return value altogether from kvm_reset_vcpu() [*]. I see two ways to
handle this:

 - Add a separate helper responsible for one-time setup of the vCPU
   called from KVM_ARM_VCPU_INIT which may fail.

 - Add a check for !kvm->arch.arm_pmu to kvm_arm_pmu_v3_init().

No strong preference, though.

[*]: https://lore.kernel.org/r/20230920195036.1169791-8-oliver.upton@linux.dev

-- 
Thanks,
Oliver
