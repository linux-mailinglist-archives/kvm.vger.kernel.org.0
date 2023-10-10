Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463C27C43CE
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 00:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjJJW0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 18:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjJJWZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 18:25:58 -0400
Received: from out-195.mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7F38F
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:25:56 -0700 (PDT)
Date:   Tue, 10 Oct 2023 22:25:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696976754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SPUkQY0+AWZGfvqgoiXnqvkeNR+nXAzCmXpNk7WkSXo=;
        b=M6bGJwHlM4DNvasAm3eeWnkSTFUPhb8DvM6ttqwv7ZfLe4GjXUd38gb6KJbAK8Joda0Fyr
        fHoCs/Qxd59GxA6CpXozmj3pM2vfKnh+XEywCTsFlbpvupoSfy5CUdJuPvP2H9tBSS8Ntv
        BqVlgm8ddPKCZiGR8NXiU5pGFIYonlc=
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
Subject: Re: [PATCH v7 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
Message-ID: <ZSXPbKH519uWXytf@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009230858.3444834-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Mon, Oct 09, 2023 at 11:08:48PM +0000, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> The following patches will use the number of counters information
> from the arm_pmu and use this to set the PMCR.N for the guest
> during vCPU reset. However, since the guest is not associated
> with any arm_pmu until userspace configures the vPMU device
> attributes, and a reset can happen before this event, assign a
> default PMU to the guest just before doing the reset.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/arm.c      | 20 ++++++++++++++++++++
>  arch/arm64/kvm/pmu-emul.c | 12 ++----------
>  include/kvm/arm_pmu.h     |  6 ++++++
>  3 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 78b0970eb8e6..708a53b70a7b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1313,6 +1313,23 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
>  			     KVM_VCPU_MAX_FEATURES);
>  }
>  
> +static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!kvm_arm_support_pmu_v3())
> +		return -EINVAL;

This check is pointless; the vCPU feature flags have been sanitised at
this point, and a requirement of having PMUv3 is that this predicate is
true.

> +	/*
> +	 * When the vCPU has a PMU, but no PMU is set for the guest
> +	 * yet, set the default one.
> +	 */
> +	if (unlikely(!kvm->arch.arm_pmu))
> +		return kvm_arm_set_default_pmu(kvm);
> +
> +	return 0;
> +}
> +

Apologies, I believe I was unclear last time around as to what I was
wanting here. Let's call this thing kvm_setup_vcpu() such that we can
add other one-time setup activities to it in the future.

Something like:

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 96641e442039..4896a44108e0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1265,19 +1265,17 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 			     KVM_VCPU_MAX_FEATURES);
 }
 
-static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
+static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	if (!kvm_arm_support_pmu_v3())
-		return -EINVAL;
-
 	/*
 	 * When the vCPU has a PMU, but no PMU is set for the guest
 	 * yet, set the default one.
 	 */
-	if (unlikely(!kvm->arch.arm_pmu))
-		return kvm_arm_set_default_pmu(kvm);
+	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
+	    kvm_arm_set_default_pmu(kvm))
+		return -EINVAL;
 
 	return 0;
 }
@@ -1297,7 +1295,8 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
-	if (kvm_vcpu_has_pmu(vcpu) && kvm_vcpu_set_pmu(vcpu))
+	ret = kvm_setup_vcpu(vcpu);
+	if (ret)
 		goto out_unlock;
 
 	/* Now we know what it is, we can reset it. */

-- 
Thanks,
Oliver
