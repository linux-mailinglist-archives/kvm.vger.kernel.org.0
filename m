Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768107A2721
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbjIOTXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbjIOTXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:23:06 -0400
Received: from out-229.mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6611FDE
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:22:56 -0700 (PDT)
Date:   Fri, 15 Sep 2023 19:22:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694805774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f6A1k8x4/KZw+o1a8WwOEfU/+PCk8Ghi0Fb9Ywzdmuc=;
        b=u8sqfMd5XvQFcuyvVmb00KMHIveZCJpd1PJ/o6SPWEWjThqR1m6L9Od8mQk4TgzRyIBrkm
        b+TXHCJkNTPKVPlMZ7+o5IfMeQ0xESl0/ZLnxKUehTAf2NOWtXhyGSReXf56VKj+X+uRkx
        P/b6Y7DyjadqHA0r48vCRcethFP4WRc=
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
Subject: Re: [PATCH v5 01/12] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
Message-ID: <ZQSvB4ZZ25eIHt/G@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-2-rananta@google.com>
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

On Thu, Aug 17, 2023 at 12:30:18AM +0000, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Introduce a new helper function to set the guest's PMU
> (kvm->arch.arm_pmu), and use it when the guest's PMU needs
> to be set. This helper will make it easier for the following
> patches to modify the relevant code.
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 52 +++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 5606509724787..0ffd1efa90c07 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -865,6 +865,32 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	return true;
>  }
>  
> +static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> +{
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	if (!arm_pmu) {
> +		/*
> +		 * No PMU set, get the default one.
> +		 *
> +		 * The observant among you will notice that the supported_cpus
> +		 * mask does not get updated for the default PMU even though it
> +		 * is quite possible the selected instance supports only a
> +		 * subset of cores in the system. This is intentional, and
> +		 * upholds the preexisting behavior on heterogeneous systems
> +		 * where vCPUs can be scheduled on any core but the guest
> +		 * counters could stop working.
> +		 */
> +		arm_pmu = kvm_pmu_probe_armpmu();
> +		if (!arm_pmu)
> +			return -ENODEV;
> +	}
> +
> +	kvm->arch.arm_pmu = arm_pmu;
> +
> +	return 0;
> +}
> +

I'm not too big of a fan of adding the 'default' path to this helper.
I'd prefer it if kvm_arm_set_vm_pmu() does all the necessary
initialization for a valid pmu instance. You then avoid introducing
unexpected error handling where it didn't exist before.

  static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  {
  	lockdep_assert_held(&kvm->arch.config_lock);

	kvm->arch.arm_pmu = arm_pmu;
  }

  /*
   * Blurb about default PMUs I'm too lazy to copy/paste
   */
  static int kvm_arm_set_default_pmu(struct kvm *kvm)
  {
  	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();

	if (!arm_pmu)
		return -ENODEV;

	kvm_arm_set_pmu(kvm, arm_pmu);
	return 0;
  }

-- 
Thanks,
Oliver
