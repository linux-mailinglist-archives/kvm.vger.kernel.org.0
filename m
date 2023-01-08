Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C736166186E
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 20:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjAHTH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 14:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAHTHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 14:07:54 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF4F5AD
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 11:07:53 -0800 (PST)
Date:   Sun, 8 Jan 2023 11:07:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673204872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DxI08leHr6/s+8mRt8PBAlVT0EMyAXuFiPf3TpofM6Y=;
        b=g5BDn7LEK36CBMlKtsc56HiGFLfsDxUthtILQ+5VhrTsJkKl8KHnkn8NiRNBAsklEUiAfL
        naF6uplwSzpDqcARXUBHUiIIjHVTglyhv6syvNnMgCODSjByrANdr+0WMCKFQaKAPRH/Jq
        ngyd+2Qn5M3e3bV4uHNupK4Cx0RvXmQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/7] KVM: arm64: PMU: Have reset_pmu_reg() to clear a
 register
Message-ID: <Y7sUggVq+D6R82qK@thinky-boi>
References: <20221230035928.3423990-1-reijiw@google.com>
 <20221230035928.3423990-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230035928.3423990-2-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022 at 07:59:22PM -0800, Reiji Watanabe wrote:
> On vCPU reset, PMCNTEN{SET,CLR}_EL1 and PMOVS{SET,CLR}_EL1 for
> a vCPU are reset by reset_pmu_reg(). This function clears RAZ bits
> of those registers corresponding to unimplemented event counters
> on the vCPU, and sets bits corresponding to implemented event counters
> to a predefined pseudo UNKNOWN value (some bits are set to 1).
> 
> The function identifies (un)implemented event counters on the
> vCPU based on the PMCR_EL1.N value on the host. Using the host
> value for this would be problematic when KVM supports letting
> userspace set PMCR_EL1.N to a value different from the host value
> (some of the RAZ bits of those registers could end up being set to 1).
> 
> Fix reset_pmu_reg() to clear the registers so that it can ensure
> that all the RAZ bits are cleared even when the PMCR_EL1.N value
> for the vCPU is different from the host value.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c6cbfe6b854b..ec4bdaf71a15 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>  
>  static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
> -	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> -
>  	/* No PMU available, any PMU reg may UNDEF... */
>  	if (!kvm_arm_support_pmu_v3())
>  		return;
>  
> -	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> -	n &= ARMV8_PMU_PMCR_N_MASK;
> -	if (n)
> -		mask |= GENMASK(n - 1, 0);
> -
> -	reset_unknown(vcpu, r);
> -	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> +	__vcpu_sys_reg(vcpu, r->reg) = 0;

I've personally found KVM's UNKNOWN reset value to be tremendously
useful in debugging guest behavior, as seeing that value is quite a
'smoking gun' IMO.

Rather than zeroing the entire register, is it possible to instead
derive the mask based on what userspace wrote to PMCR_EL1.N instead of
what's in hardware?

--
Thanks,
Oliver
