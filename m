Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1E0630ECD
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 13:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiKSMyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 07:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKSMyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 07:54:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645A18C4B8
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 04:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A72B80171
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 12:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD73C433D6;
        Sat, 19 Nov 2022 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668862444;
        bh=vioAvYwfiaLZn2wwZZq6HjQqCvgo19zaYRMDjhkRB4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LGoMvRluIE3TsL7CDUqe2tLxyTeVvN3GQABrBDYTnvZuErTa3wLMUUl68KOrer/Rn
         371Kg+wQf9fJ7ngdBDRRg2pMLLdd6fUKDTsLmtowCxh2l6IxlKkLZ8GDSShAELXhqV
         iYvkpo9sQCJJmy8I8hrLBkzaMKW+hsLlUftPYjda7krJXVNyHZqtuWkRsfgggbc4qn
         UNHyk3gJrcU36H2XFwk2LvLwznlSBH3VObVUzJz9vltv3oGEdeK10PGnsW+7gzy0uc
         mLxzA0Q2FnP5AQ0EHSh99UAcnemd9FlZQOryYtjBWMkEX2zoEtT4qeDp9i6thZs5tL
         oJvTPVIps2E2A==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1owNMA-007EQZ-H7;
        Sat, 19 Nov 2022 12:54:02 +0000
MIME-Version: 1.0
Date:   Sat, 19 Nov 2022 12:54:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 12/16] KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be
 set from userspace
In-Reply-To: <CAAeT=Fwq8wcBvoWE+5RJt4og4uD5KgQ0kzhDZorGPjHmTguwzw@mail.gmail.com>
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-13-maz@kernel.org>
 <CAAeT=Fwq8wcBvoWE+5RJt4og4uD5KgQ0kzhDZorGPjHmTguwzw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6b70f8fac8b2fd316b618c3c2e67e07b@kernel.org>
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

On 2022-11-19 05:52, Reiji Watanabe wrote:
> Hi Marc,
> 
> On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> Allow userspace to write ID_DFR0_EL1, on the condition that only
>> the PerfMon field can be altered and be something that is compatible
>> with what was computed for the AArch64 view of the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 57 
>> ++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 56 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 3cbcda665d23..dc201a0557c0 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1070,6 +1070,19 @@ static u8 vcpu_pmuver(const struct kvm_vcpu 
>> *vcpu)
>>         return vcpu->kvm->arch.dfr0_pmuver.unimp;
>>  }
>> 
>> +static u8 perfmon_to_pmuver(u8 perfmon)
>> +{
>> +       switch (perfmon) {
>> +       case ID_DFR0_PERFMON_8_0:
>> +               return ID_AA64DFR0_EL1_PMUVer_IMP;
>> +       case ID_DFR0_PERFMON_IMP_DEF:
>> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> 
> Nit: Since IMP_DEF is 0xf for both PMUVER and PERFMON,
> I think the 'default' can handle IMP_DEF (I have the same
> comment for pmuver_to_perfmon in the patch-10).

It sure can, but IMP_DEF is special enough in its treatment
(we explicitly check this value in set_id_dfr0_el1()) that
it actually helps the reader to keep the explicit conversion
here.

> 
>> +       default:
>> +               /* Anything ARMv8.1+ has the same value. For now. */
> 
> Nit: Shouldn't the comment also mention NI (and IMP_DEF) ?
> (I have the same comment for pmuver_to_perfmon in the patch-10)

I can expand the comment to include NI.

> Otherwise:
> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
