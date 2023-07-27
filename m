Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3393B7657D0
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjG0PiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjG0PiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:38:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAF5B4
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 08:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7184461EC0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 15:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD795C433C8;
        Thu, 27 Jul 2023 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690472285;
        bh=NGPspxjeq4ZzyVX1fBJdjOsk2s7D3ufnSXsoLhLWATY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rogHGh7vCHyykONUoEyClEzGS6tu2FXPRp+1axA2NXuDEY9E2P/sF711dIGIgw5dX
         sjybT+WzoL2oox+NsecttelaxDXHdZm5SS0ty8xSY62egClb/bh9RwxSDeQwPjh4Eq
         ivjMqistjku78rthFJvBG700nMPMCguSghTEJETg87Jez7U30oHuKv5+kfoSESPM5c
         CwurYi7PBxC/Vee0OaJMPbKoLqUy1KV3j1mHEa4mmEpf0C5vx7RLd3jC1PG+pKicLA
         UpUL5wukMG1lP6TpgWnHARdDPBNeIgQogcg8erxevXJ0r0lS6+rEGVuwPIoCHH0UoO
         gTLJ8EZegJB/Q==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qP33z-00HOju-84;
        Thu, 27 Jul 2023 16:38:03 +0100
MIME-Version: 1.0
Date:   Thu, 27 Jul 2023 16:38:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     eric.auger@redhat.com
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 19/27] KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
In-Reply-To: <9739cab9-c058-ec5f-ac15-7d708aef4e85@redhat.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-20-maz@kernel.org>
 <9739cab9-c058-ec5f-ac15-7d708aef4e85@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <b2b31e80923bbc0143d774b850abc043@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-07-25 18:37, Eric Auger wrote:
> Hi Marc,
> 
> On 7/12/23 16:58, Marc Zyngier wrote:
>> Describe the CNTHCTL_EL2 register, and associate it with all the 
>> sysregs
>> it allows to trap.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/emulate-nested.c | 37 
>> ++++++++++++++++++++++++++++++++-
>>  1 file changed, 36 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/kvm/emulate-nested.c 
>> b/arch/arm64/kvm/emulate-nested.c
>> index 25e4842ac334..c07c0f3361d7 100644
>> --- a/arch/arm64/kvm/emulate-nested.c
>> +++ b/arch/arm64/kvm/emulate-nested.c
>> @@ -98,9 +98,11 @@ enum coarse_grain_trap_id {
>> 
>>  	/*
>>  	 * Anything after this point requires a callback evaluating a
>> -	 * complex trap condition. Hopefully we'll never need this...
>> +	 * complex trap condition. Ugly stuff.
>>  	 */
>>  	__COMPLEX_CONDITIONS__,
>> +	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
>> +	CGT_CNTHCTL_EL1PTEN,
>>  };
>> 
>>  static const struct trap_bits coarse_trap_bits[] = {
>> @@ -358,9 +360,37 @@ static const enum coarse_grain_trap_id 
>> *coarse_control_combo[] = {
>> 
>>  typedef enum trap_behaviour (*complex_condition_check)(struct 
>> kvm_vcpu *);
>> 
>> +static u64 get_sanitized_cnthctl(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
>> +
>> +	if (!vcpu_el2_e2h_is_set(vcpu))
>> +		val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
>> +
>> +	return val;
> don't you want to return only bits 10 & 11 to match the other 
> condition?
> 
> I would add a comment saying that When FEAT_VHE is implemented and
> HCR_EL2.E2H == 1:
> 
> sanitized_cnthctl[11:10] = [EL1PTEN, EL1PCTEN]
> otherwise
> sanitized_cnthctl[11:10] = [EL1PCEN, EL1PCTEN]
> 
>> +}
>> +
>> +static enum trap_behaviour check_cnthctl_el1pcten(struct kvm_vcpu 
>> *vcpu)
>> +{
>> +	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCTEN << 10))
>> +		return BEHAVE_HANDLE_LOCALLY;
>> +
>> +	return BEHAVE_FORWARD_ANY;
>> +}
>> +
>> +static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu 
>> *vcpu)
> or pcen. This is a bit confusing to see EL1PCEN below. But this is due
> to above sanitized CNTHCTL. Worth a comment to me.

I'm adding the following:

/*
  * Warning, maximum confusion ahead.
  *
  * When E2H=0, CNTHCTL_EL2[1:0] are defined as EL1PCEN:EL1PCTEN
  * When E2H=1, CNTHCTL_EL2[11:10] are defined as EL1PTEN:EL1PCTEN
  *
  * Note the single letter difference? Yet, the bits have the same
  * function despite a different layout and a different name.
  *
  * We don't try to reconcile this mess. We just use the E2H=0 bits
  * to generate something that is in the E2H=1 format, and live with
  * it. You're welcome.
  */

Hopefully this will make things clearer. Not completely sure though.

>> +{
>> +	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCEN << 10))
>> +		return BEHAVE_HANDLE_LOCALLY;
>> +
>> +	return BEHAVE_FORWARD_ANY;
>> +}
>> +
>>  #define CCC(id, fn)	[id - __COMPLEX_CONDITIONS__] = fn
>> 
>>  static const complex_condition_check ccc[] = {
>> +	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
>> +	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
>>  };
>> 
>>  /*
>> @@ -855,6 +885,11 @@ static const struct encoding_to_trap_config 
>> encoding_to_cgt[] __initdata = {
>>  	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
>>  	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
>>  	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
>> +	SR_TRAP(SYS_CNTP_TVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
>> +	SR_TRAP(SYS_CNTP_CVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
>> +	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
>> +	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
>> +	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
>>  };
>> 
>>  static DEFINE_XARRAY(sr_forward_xa);
> Otherwise looks good to me
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks!

         M.
-- 
Jazz is not dead. It just smells funny...
