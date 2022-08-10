Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58258EF88
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiHJPmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiHJPmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:42:10 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB9C3B940
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:42:06 -0700 (PDT)
Date:   Wed, 10 Aug 2022 10:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660146124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K2PbOUqOvValZYHdNM1MGvDbH+NW5HMrQfpzoZhK7ZE=;
        b=htruQVkH3tRwn67M8lxwDxWJcmqoYYJ7n3o1BU4Nzi+bk/Qkn/2fU9FSTvgictSsmVFw37
        cJkohOBnSioV23R1DBb/ZPvkiWp3m9lapoivUmelydT1ZddoDT46WXqNbC/Hyiie9gHtun
        OW/GmCzkrE0nN2Wx0j9w7JuP90sAbGw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: Re: [PATCH 5/9] KVM: arm64: PMU: Simplify setting a counter to a
 specific value
Message-ID: <YvPRxHgriLXc5AGp@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-6-maz@kernel.org>
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

On Fri, Aug 05, 2022 at 02:58:09PM +0100, Marc Zyngier wrote:
> kvm_pmu_set_counter_value() is pretty odd, as it tries to update
> the counter value while taking into account the value that is
> currently held by the running perf counter.
> 
> This is not only complicated, this is quite wrong. Nowhere in
> the architecture is it said that the counter would be offset
> by something that is pending. The counter should be updated
> with the value set by SW, and start counting from there if
> required.
> 
> Remove the odd computation and just assign the provided value
> after having released the perf event (which is then restarted).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks much better.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/pmu-emul.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 9be485d23416..ddd79b64b38a 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -21,6 +21,7 @@ static LIST_HEAD(arm_pmus);
>  static DEFINE_MUTEX(arm_pmus_lock);
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> +static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
>  
>  static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  {
> @@ -129,8 +130,10 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return;
>  
> +	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
> +

<bikeshed>

Not your code, but since we're here: it seems as though there is some
inconsistency in parameterization as some functions take an index and
others take a kvm_pmc pointer. For example,
kvm_pmu_{create,release}_perf_event() are inconsistent.

It might be nice to pick a scheme and apply consistently throughout.

</bikeshed>

--
Thanks,
Oliver

>  	reg = counter_index_to_reg(select_idx);
> -	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> +	__vcpu_sys_reg(vcpu, reg) = val;
>  
>  	/* Recreate the perf event to reflect the updated sample_period */
>  	kvm_pmu_create_perf_event(vcpu, select_idx);
> -- 
> 2.34.1
> 
>
