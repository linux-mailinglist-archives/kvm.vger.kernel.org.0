Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B712671934A
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 08:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjFAGeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 02:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjFAGe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 02:34:28 -0400
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F044126
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 23:34:25 -0700 (PDT)
Date:   Thu, 1 Jun 2023 06:34:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685601263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TNu8g5bcDjZLGCC9IYSQGhuaint+Q0+//GNY41I3lck=;
        b=jiKBhEg36dfZ0tMGeUWlUzrZH3jH1dCulsgQVikqwMbAPVcbUJrnMLPIdy7rdPOece0T3F
        jiw2kbJoC1cUPbMje7zmXnRGi9b4GEpbVPOnHZ7JS1tQ5cqoJvxT4sUWL3Us6HyP3C7UNL
        h031D4V6S7UQkRknAgT4rG+YicgMvOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 06/17] arm64: Allow EL1 physical timer access when
 running VHE
Message-ID: <ZHg76wizp5RSXTLG@linux.dev>
References: <20230526143348.4072074-1-maz@kernel.org>
 <20230526143348.4072074-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143348.4072074-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Fri, May 26, 2023 at 03:33:37PM +0100, Marc Zyngier wrote:
> To initialise the timer access from EL2 when HCR_EL2.E2H is set,
> we must make use the CNTHCTL_EL2 formap used is appropriate.
> 
> This amounts to shifting the timer/counter enable bits by 10
> to the left.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/el2_setup.h | 5 +++++
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 9 +++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 037724b19c5c..225bf1f2514d 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -34,6 +34,11 @@
>   */
>  .macro __init_el2_timers
>  	mov	x0, #3				// Enable EL1 physical timers
> +	mrs	x1, hcr_el2
> +	and	x1, x1, #HCR_E2H
> +	cbz	x1, .LnVHE_\@
> +	lsl	x0, x0, #10
> +.LnVHE_\@:
>  	msr	cnthctl_el2, x0
>  	msr	cntvoff_el2, xzr		// Clear virtual offset
>  .endm
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index a6d67c2bb5ae..f9ee10e29497 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -95,6 +95,15 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
>  	ldr	x1, [x0, #NVHE_INIT_HCR_EL2]
>  	msr	hcr_el2, x1
>  
> +	mov	x2, #HCR_E2H
> +	and	x2, x1, x2
> +	cbz	x2, 1f
> +
> +	mrs	x1, cnthctl_el2
> +	and	x1, x1, #~(BIT(0) | BIT(1))
> +	orr	x1, x1, #(BIT(10) | BIT(11))
> +	msr	cnthctl_el2, x1
> +1:

Can this be done with an alternative block keyed on ARM64_KVM_HVHE?
I get that __init_el2_timers needs to run before the cpu caps have been
evaluated, but I don't think the same applies for ___kvm_hyp_init

-- 
Thanks,
Oliver
