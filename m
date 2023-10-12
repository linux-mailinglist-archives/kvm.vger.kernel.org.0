Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AE87C69E7
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 11:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbjJLJnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 05:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbjJLJnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 05:43:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2730B7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 02:43:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14DDC13D5;
        Thu, 12 Oct 2023 02:44:14 -0700 (PDT)
Received: from [10.57.69.218] (unknown [10.57.69.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F27153F762;
        Thu, 12 Oct 2023 02:43:31 -0700 (PDT)
Message-ID: <2e724a19-1a58-ac6d-1697-c4a2b7a6962a@arm.com>
Date:   Thu, 12 Oct 2023 10:43:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-3-oliver.upton@linux.dev>
From:   James Clark <james.clark@arm.com>
In-Reply-To: <20231011081649.3226792-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/10/2023 09:16, Oliver Upton wrote:
> Prevent the guest from setting the NSH bit, which enables event counting
> while the PE is in EL2. kvm_pmu_create_perf_event() never wired up the
> bit, nor does it make any sense in the context of a guest without NV.
> 
> While at it, build the event type mask using explicit field definitions
> instead of relying on ARMV8_PMU_EVTYPE_MASK. KVM probably should've been
> doing this in the first place, as it avoids changes to the
> aforementioned mask affecting sysreg emulation.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0666212c0c15..087764435390 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -663,8 +663,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return;
>  
> -	mask  =  ARMV8_PMU_EVTYPE_MASK;

ARMV8_PMU_EVTYPE_MASK is still used in access_pmu_evtyper() and
reset_pmevtyper(), although it's not really an issue if you can't set
the bits in the first place. But it probably makes sense to use the same
mask everywhere.

> -	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
> +	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
>  	mask |= kvm_pmu_event_mask(vcpu->kvm);
>  
>  	reg = counter_index_to_evtreg(pmc->idx);
