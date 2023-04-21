Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E159A6EA914
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjDULY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDULY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC18E4ED7
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 04:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62EC464FD6
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 11:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CB8C433D2;
        Fri, 21 Apr 2023 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682076293;
        bh=GmfDHx1HJOprAgc/KFGBtZ/DijDDaT1Bq7BDqD/+p2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FjxXDPvsC8Lv9yt82lnDeVT5ufVZ6NlSNr9cAoLZu8Z1ZRUw5Y16kkVOahB9kHyTJ
         gY4zLXP0DbgowTsxDNn+hOF7xI6W8PSc50G2WplLem4PuNp5/vH0be/EpDrIG9NBA3
         0W72al2sHLbqS69rZZElNzGDpvGjsA+KJ2ODtoYktwSWEI19dpYItmQfSc8CE9bWJ8
         kv5qXoLRc2qIr1G8SpKFunt8e3/uX8O47KO6z0jrv3aO7FXItFvFYMyatyLhVR8uhe
         mmvvIdcchHuSe8QN5bMOfRL7O0ChmXfS+hoi4iLIGjZWcS9ykqg0rVp7VfMp4O1sqA
         Hqe4cEdyk07wQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pposl-00A9fI-Du;
        Fri, 21 Apr 2023 12:24:51 +0100
MIME-Version: 1.0
Date:   Fri, 21 Apr 2023 12:24:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, will@kernel.org, oliver.upton@linux.dev,
        ricarkol@google.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 4/6] arm: pmu: Fix chain counter
 enable/disable sequences
In-Reply-To: <ZEJq_XNHi8Mx3CBy@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-5-eric.auger@redhat.com>
 <ZEJq_XNHi8Mx3CBy@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <651289b765b20d6e2dc32f71c5d7b5b5@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, eric.auger@redhat.com, eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev, will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
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

On 2023-04-21 11:52, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Mar 15, 2023 at 12:07:23PM +0100, Eric Auger wrote:
>> In some ARM ARM ddi0487 revisions it is said that
>> disabling/enabling a pair of counters that are paired
>> by a CHAIN event should follow a given sequence:
>> 
>> Disable the low counter first, isb, disable the high counter
>> Enable the high counter first, isb, enable low counter
>> 
>> This was the case in Fc. However this is not written anymore
>> in Ia revision.
>> 
>> Introduce 2 helpers to execute those sequences and replace
>> the existing PMCNTENCLR/ENSET calls.
>> 
>> Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
>> and replace them by PMCNTENCLR writes since writing 0 in
>> PMCNTENSET_EL0 has no effect.
>> 
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
>>  1 file changed, 28 insertions(+), 9 deletions(-)
>> 
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index dde399e2..af679667 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -730,6 +730,22 @@ static void test_chained_sw_incr(bool unused)
>>  		    read_regn_el0(pmevcntr, 0), \
>>  		    read_sysreg(pmovsclr_el0))
>> 
>> +static void enable_chain_counter(int even)
>> +{
>> +	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the high 
>> counter first */
>> +	isb();
>> +	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the low 
>> counter */
>> +	isb();
>> +}
> 
> In ARM DDI 0487F.b, at the bottom of page D7-2727:
> 
> "When enabling a pair of counters that are paired by a CHAIN event,
> software must:
> 
> 1. Enable the high counter, by setting PMCNTENCLR_EL0[n+1] to 0 and, if
> necessary, setting PMCR_EL0.E to 1.
> 2. Execute an ISB instruction, or perform another Context 
> synchronization
> event.
> 3. Enable the low counter by setting PMCNTENCLR_EL0[n] to 0."

This particular text seems to have been removed from the H.a and I.a
revisions of the ARM ARM, and I cannot spot any equivalent requirement.

         M.
-- 
Jazz is not dead. It just smells funny...
