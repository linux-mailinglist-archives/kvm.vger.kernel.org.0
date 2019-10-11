Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6F0D429F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 16:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfJKOTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 10:19:37 -0400
Received: from foss.arm.com ([217.140.110.172]:33810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbfJKOTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 10:19:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65DEE142F;
        Fri, 11 Oct 2019 07:19:36 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D16173F68E;
        Fri, 11 Oct 2019 07:19:35 -0700 (PDT)
Date:   Fri, 11 Oct 2019 15:19:34 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 3/4] KVM: arm64: pmu: Set the CHAINED attribute before
 creating the in-kernel event
Message-ID: <20191011141933.GQ42880@e119886-lin.cambridge.arm.com>
References: <20191011123954.31378-1-maz@kernel.org>
 <20191011123954.31378-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011123954.31378-4-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 01:39:53PM +0100, Marc Zyngier wrote:
> The current convention for KVM to request a chained event from the
> host PMU is to set bit[0] in attr.config1 (PERF_ATTR_CFG1_KVM_PMU_CHAINED).
> 
> But as it turns out, this bit gets set *after* we create the kernel
> event that backs our virtual counter, meaning that we never get
> a 64bit counter.
> 
> Moving the setting to an earlier point solves the problem.
> 
> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

> ---
>  virt/kvm/arm/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index c30c3a74fc7f..f291d4ac3519 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -569,12 +569,12 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  		 * high counter.
>  		 */
>  		attr.sample_period = (-counter) & GENMASK(63, 0);
> +		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
> +			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> +
>  		event = perf_event_create_kernel_counter(&attr, -1, current,
>  							 kvm_pmu_perf_overflow,
>  							 pmc + 1);
> -
> -		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
> -			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
>  	} else {
>  		/* The initial sample period (overflow count) of an event. */
>  		if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> -- 
> 2.20.1
> 
