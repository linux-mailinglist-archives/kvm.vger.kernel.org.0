Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC97F7C441C
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 00:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbjJJWaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 18:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjJJWau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 18:30:50 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [IPv6:2001:41d0:203:375::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2B8E0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 15:30:38 -0700 (PDT)
Date:   Tue, 10 Oct 2023 22:30:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696977037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/lM90Up6SI7d/uT4OcCpfnqLaN2bM1VE++77i6UZHLg=;
        b=oaZYsJNm62P+DG0gECk9TGwg1Rvb25tEqRmt+8I4Vt24ltE+ubl4Ksj2iTkpsKf0Lz9SAc
        GDjT4LfvV3vkJtIiVgkNYEBt9JlLmDEyPy8AlD4DelofZNOVn6GW9JSW1Vo7qSjP23anU4
        Q6vUTqEojDviyiXttF+ECliCoHG4gJo=
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
Subject: Re: [PATCH v7 06/12] KVM: arm64: PMU: Add a helper to read the
 number of counters
Message-ID: <ZSXQh2P_l5xcj7zS@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009230858.3444834-7-rananta@google.com>
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

On Mon, Oct 09, 2023 at 11:08:52PM +0000, Raghavendra Rao Ananta wrote:
> Add a helper, kvm_arm_get_num_counters(), to read the number
> of counters from the arm_pmu associated to the VM. Make the
> function global as upcoming patches will be interested to
> know the value while setting the PMCR.N of the guest from
> userspace.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 17 +++++++++++++++++
>  include/kvm/arm_pmu.h     |  6 ++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a161d6266a5c..84aa8efd9163 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -873,6 +873,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	return true;
>  }
>  
> +/**
> + * kvm_arm_get_num_counters - Get the number of general-purpose PMU counters.
> + * @kvm: The kvm pointer
> + */
> +int kvm_arm_get_num_counters(struct kvm *kvm)

nit: the naming suggests this returns the configured number of PMCs, not
the limit.

Maybe kvm_arm_pmu_get_max_counters()?

> +{
> +	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	/*
> +	 * The arm_pmu->num_events considers the cycle counter as well.
> +	 * Ignore that and return only the general-purpose counters.
> +	 */
> +	return arm_pmu->num_events - 1;
> +}
> +
>  static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>  {
>  	lockdep_assert_held(&kvm->arch.config_lock);
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index cd980d78b86b..672f3e9d7eea 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -102,6 +102,7 @@ void kvm_vcpu_pmu_resync_el0(void);
>  
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
>  int kvm_arm_set_default_pmu(struct kvm *kvm);
> +int kvm_arm_get_num_counters(struct kvm *kvm);
>  
>  u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
>  #else
> @@ -181,6 +182,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
>  	return -ENODEV;
>  }
>  
> +static inline int kvm_arm_get_num_counters(struct kvm *kvm)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
>  {
>  	return 0;
> -- 
> 2.42.0.609.gbb76f46606-goog
> 

-- 
Thanks,
Oliver
