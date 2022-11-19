Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ED8630EB4
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 13:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiKSMcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 07:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiKSMcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 07:32:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2D28A17D
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 04:32:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 723DF60B68
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 12:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC42C433B5;
        Sat, 19 Nov 2022 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668861126;
        bh=XJmwZtMhV/ZMzzKSVFYIBb4CYRzhYt+pogZhoRf+CdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sBVM1OLel3CdbtCGiInVEen3SpaU/m8nAEdgqjgqqU8pYycHk43HIIxu9SZ/KeZzt
         /tgx+tfOdql8OvFiJSP3HL7jvMEuQa8yCIDZgegevi7KkKIBaJMyluWfkhOf90InA4
         bcHdxqdCHnCzRuA0FrHl5XxYXP3oyEKogVczHCmjPDmGFcXOsd39w8H4wqoSJi+WrP
         VsTJXH+TMVss7/mKF22pEKS7muygfkc7ub2KaE9PgQ/mpuZoSPDtfy0DrEKcrMsOlt
         V0SrfmFPRWFYRiMDiZk9yU5nJt0x+SfVGYb4rFAIjQnM5vsEQpV1sXNmyqCZvFRC38
         jqL556J9YRFVw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1owN0u-007EHn-FT;
        Sat, 19 Nov 2022 12:32:04 +0000
MIME-Version: 1.0
Date:   Sat, 19 Nov 2022 12:32:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 09/16] KVM: arm64: PMU: Do not let AArch32 change the
 counters' top 32 bits
In-Reply-To: <CAAeT=FzvGPs04N8=y2pjBxv_HTgQHwRN8hEsyheu0bi+WJzRQQ@mail.gmail.com>
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-10-maz@kernel.org>
 <CAAeT=FzvGPs04N8=y2pjBxv_HTgQHwRN8hEsyheu0bi+WJzRQQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <b21eb3cfe4fc07c5c9672e2140b3fffe@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-11-18 07:45, Reiji Watanabe wrote:
> Hi Marc,
> 
> On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> Even when using PMUv3p5 (which implies 64bit counters), there is
>> no way for AArch32 to write to the top 32 bits of the counters.
>> The only way to influence these bits (other than by counting
>> events) is by writing PMCR.P==1.
>> 
>> Make sure we obey the architecture and preserve the top 32 bits
>> on a counter update.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 35 +++++++++++++++++++++++++++--------
>>  1 file changed, 27 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index ea0c8411641f..419e5e0a13d0 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -119,13 +119,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu 
>> *vcpu, u64 select_idx)
>>         return counter;
>>  }
>> 
>> -/**
>> - * kvm_pmu_set_counter_value - set PMU counter value
>> - * @vcpu: The vcpu pointer
>> - * @select_idx: The counter index
>> - * @val: The counter value
>> - */
>> -void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, 
>> u64 val)
>> +static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 
>> select_idx, u64 val,
>> +                               bool force)
>>  {
>>         u64 reg;
>> 
>> @@ -135,12 +130,36 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu 
>> *vcpu, u64 select_idx, u64 val)
>>         kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
>> 
>>         reg = counter_index_to_reg(select_idx);
>> +
>> +       if (vcpu_mode_is_32bit(vcpu) && select_idx != 
>> ARMV8_PMU_CYCLE_IDX &&
>> +           !force) {
>> +               /*
>> +                * Even with PMUv3p5, AArch32 cannot write to the top
>> +                * 32bit of the counters. The only possible course of
>> +                * action is to use PMCR.P, which will reset them to
>> +                * 0 (the only use of the 'force' parameter).
>> +                */
>> +               val  = lower_32_bits(val);
>> +               val |= upper_32_bits(__vcpu_sys_reg(vcpu, reg));
> 
> Shouldn't the result of upper_32_bits() be shifted 32bits left
> before ORing (to maintain the upper 32bits of the current value) ?

Indeed, and it only shows that AArch32 has had no testing
whatsoever :-(.

I'll fix it up locally.

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
