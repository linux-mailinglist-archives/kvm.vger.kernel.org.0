Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3739626EEC
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 11:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbiKMKVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 05:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiKMKVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 05:21:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F20911807
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 02:21:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2ADF60B46
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 10:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5F7C433C1;
        Sun, 13 Nov 2022 10:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668334865;
        bh=bAJllN46EPAoI4gsSpHJ8M3EPpj3jJg9OxPG1MEqQGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f/2fqifuG1M7A6Z1OoNTm5evuC9kytJ96vnnCcLxjISUV6M2tb8Q3ZHZq/krY1zFF
         XtLIOQvUqtszAZNN7M9LKtvS8CUK6rA0xfahPNnR28FVoEF8ueWSvaRGtTjQDpueoV
         HZGZ39sWZWiJJ+WOlbg+W9xZGHhfVrMcCo77eAfHn9BB6Bm9+Ki18QppuaHEOnRHmb
         0+RrUPSoyh/cZE+q3P6fo8HvOBUEVt5rjQnQhHU/uln1tGhYsBydlswsLY84WXPHtK
         +FJmq+apzfdcgphjmNNKZoDYXAh52892zNWfandT7T5pOVGe6J6jKwMlplFWd0Jobw
         dh4QEhWOb1Y9g==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouA6o-005mZw-T8;
        Sun, 13 Nov 2022 10:21:02 +0000
MIME-Version: 1.0
Date:   Sun, 13 Nov 2022 10:21:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
In-Reply-To: <CAAeT=FyR_4d1HzDjNEdVhsdgzRuBGuEwGuoMYY0xvi+YAbMqSg@mail.gmail.com>
References: <20221107085435.2581641-1-maz@kernel.org>
 <20221107085435.2581641-12-maz@kernel.org>
 <CAAeT=FyR_4d1HzDjNEdVhsdgzRuBGuEwGuoMYY0xvi+YAbMqSg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <136ee516118c97b8f3e4792b8ec9752a@kernel.org>
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

On 2022-11-08 05:38, Reiji Watanabe wrote:
> Hi Marc,
> 
> On Mon, Nov 7, 2022 at 1:16 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
>> the PMUver field can be altered and be at most the one that was
>> initially computed for the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 40 
>> ++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 39 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 7a4cd644b9c0..47c882401f3c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1247,6 +1247,43 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu 
>> *vcpu,
>>         return 0;
>>  }
>> 
>> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>> +                              const struct sys_reg_desc *rd,
>> +                              u64 val)
>> +{
>> +       u8 pmuver, host_pmuver;
>> +       bool valid_pmu;
>> +
>> +       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
>> +
>> +       /*
>> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
>> +        * as it doesn't promise more than what the HW gives us. We
>> +        * allow an IMPDEF PMU though, only if no PMU is supported
>> +        * (KVM backward compatibility handling).
>> +        */
>> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), 
>> val);
>> +       if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > 
>> host_pmuver) ||
>> +           (pmuver != 0 && pmuver < ID_AA64DFR0_EL1_PMUVer_IMP))
> 
> Nit: Since this second condition cannot be true (right?), perhaps it 
> might
> be rather confusing?  I wasn't able to understand what it meant until
> I see the equivalent check in set_id_dfr0_el1() (Maybe just me 
> though:).

Ah, that's just me being tainted with the AArch32 version which
doesn't start at 1 for PMUv3. I'll drop it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
