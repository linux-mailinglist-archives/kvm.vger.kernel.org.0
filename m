Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECD267481C
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjATAkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 19:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjATAkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 19:40:19 -0500
X-Greylist: delayed 576 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 16:40:18 PST
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F0475A20
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 16:40:18 -0800 (PST)
Date:   Fri, 20 Jan 2023 00:30:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674174638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W/vUFgjfb6X+FqyAmeIxFK5cLI9LeCRTehmKQ0lRZDc=;
        b=rcAoQPvkwz2Bai8lDy5e6ktQyY9+tnTRAuLq2LSzW+VKfjxSb+mgolQn55wCUSAFEE9oAo
        N0WykfebaJAeAZA7FuYy+42T08yRwlGqIlzO8slGvoh/PMypxbO0nSmeI/acwrpcMIsRr7
        VnscjFqlsjPLCQhIB6dNFr+FYqnGlLU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v2 3/8] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value
 on vCPU reset
Message-ID: <Y8ngqRHhiXHjc0vA@google.com>
References: <20230117013542.371944-1-reijiw@google.com>
 <20230117013542.371944-4-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117013542.371944-4-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 05:35:37PM -0800, Reiji Watanabe wrote:
> The number of PMU event counters is indicated in PMCR_EL0.N.
> For a vCPU with PMUv3 configured, its value will be the same as
> the host value by default. Userspace can set PMCR_EL0.N for the
> vCPU to a lower value than the host value using KVM_SET_ONE_REG.
> However, it is practically unsupported, as reset_pmcr() resets
> PMCR_EL0.N to the host value on vCPU reset.
> 
> Change reset_pmcr() to preserve the vCPU's PMCR_EL0.N value on
> vCPU reset so that userspace can limit the number of the PMU
> event counter on the vCPU.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 6 ++++++
>  arch/arm64/kvm/sys_regs.c | 4 +++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 24908400e190..937a272b00a5 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -213,6 +213,12 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>  		pmu->pmc[i].idx = i;
> +
> +	/*
> +	 * Initialize PMCR_EL0 for the vCPU with the host value so that
> +	 * the value is available at the very first vCPU reset.
> +	 */
> +	__vcpu_sys_reg(vcpu, PMCR_EL0) = read_sysreg(pmcr_el0);

I think we need to derive a sanitised value for PMCR_EL0.N, as I believe
nothing in the architecture prevents implementers from gluing together
cores with varying numbers of PMCs. We probably haven't noticed it yet
since it would appear all Arm designs have had 6 PMCs.

>  }
>  
>  /**
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4959658b502c..67c1bd39b478 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -637,8 +637,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	if (!kvm_arm_support_pmu_v3())
>  		return;
>  
> +	/* PMCR_EL0 for the vCPU is set to the host value at vCPU creation. */
> +

nit: I think we can do without the floating comment here.

--
Thanks,
Oliver
