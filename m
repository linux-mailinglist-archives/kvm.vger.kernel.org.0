Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A94F58E79C
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiHJHIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiHJHIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:08:15 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60F874CFA
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:08:13 -0700 (PDT)
Date:   Wed, 10 Aug 2022 02:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660115292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16kqUglr1ishQgrJKlQFjUeIG4svmPIXYRWssIj916w=;
        b=kmhhSxS7uIccs/nrYdSWL3WpY7iLLfb086IQ2OPHv80z6GP87fiwDAqu5MhMZPTcJEhJFn
        IKWWEQTe2cyuaZo3J7bEjF7I+lJDWX/zwfntne4Qxoox02rZ2x4/mnYnYTdq7PegQzGnGB
        ylFovYXelsIAn9sU0BqHBUbbCHl/j4M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: Re: [PATCH 7/9] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be
 set from userspace
Message-ID: <YvNZVgMmFxrY4Nka@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 05, 2022 at 02:58:11PM +0100, Marc Zyngier wrote:
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.

As DFR0_EL1 is exposed to userspace, isn't a ->set_user() hook required
for it as well?

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 55451f49017c..c0595f31dab8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1236,6 +1236,38 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd,
> +			       u64 val)
> +{
> +	u8 pmuver, host_pmuver;
> +
> +	host_pmuver = kvm_arm_pmu_get_host_pmuver();
> +
> +	/*
> +	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +	 * as it doesn't promise more than what the HW gives us. We
> +	 * don't allow an IMPDEF PMU though.
> +	 */
> +	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), val);
> +	if (pmuver == ID_AA64DFR0_PMUVER_IMP_DEF || pmuver > host_pmuver)
> +		return -EINVAL;
> +
> +	/* We already have a PMU, don't try to disable it... */
> +	if (kvm_vcpu_has_pmu(vcpu) && pmuver == 0)
> +		return -EINVAL;
> +
> +	/* We can only differ with PMUver, and anything else is an error */
> +	val ^= read_id_reg(vcpu, rd, false);
> +	val &= ~(0xFUL << ID_AA64DFR0_PMUVER_SHIFT);

nit: ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)

--
Thanks,
Oliver
