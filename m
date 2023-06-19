Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146BA735E05
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjFST6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjFST6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 15:58:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B38E118
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 12:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687204680;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BLzAUVDf7QH/L0j/AvjHhDk6Se5RIMDruboAZ8kG79c=;
        b=OcvPwHiuF9s2EVwv4Zfq/3K8t/jYqxvrTcVwhxh1fH40tm1f3lFABJD8JZBPyncgwFf400
        WbrYQUYppAvHRHtwUjgd3kcoJM+V/sZrUFP1npdPWkTXHXeZ3CjaDH7oR/y+fE/tV71xT4
        A5UP3xZstjE0660VD+E+YHN0PDTEQLo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-6C0ScaWGOVCSMKdHO1y9Vg-1; Mon, 19 Jun 2023 15:57:58 -0400
X-MC-Unique: 6C0ScaWGOVCSMKdHO1y9Vg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-763a7abf1c5so55840785a.2
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 12:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687204678; x=1689796678;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLzAUVDf7QH/L0j/AvjHhDk6Se5RIMDruboAZ8kG79c=;
        b=JMozbBWaw53OXmzra3xSCnZsFQYpE2W/nPERMHVgX4gMiY0017JBvkC3f9kuBX+2LD
         ucDeQPEeXBEAFu0fQFjHCD2bBsB7HY3JgJ51klhaZQhs6Z+8tPWXGEvfMqxCD+QmnoJM
         f9r2KK5ij2nYbL+dMQ5On+zQwkh6ZU67/uqVju+XgNuZALaIFvDDbRLJJ17hEfLrCA+F
         ExXv+v3wyC4mc5XMhkAuDoKwwfiU0xmNZFl3BwArH8NdCtFG/X8IxBpeWBQuICgq2poi
         etaM1vB4G61R5zOQX1cS/8iwjz+VnV46Dq65ysah7QP9GhSd62sr4Zpy53msvmD+7O96
         k/3w==
X-Gm-Message-State: AC+VfDxTkrY7bWsuGUEd7usiHoErxsH/k4hfjqmp+p1cKOK3Hb32cWOb
        eq0uTvqz8rfM72nu1OoxrIJPgI5GOCymOwaVWEKIdoKTySNfgKWoGD8Jv59WhGmWvhq1O8fUt0X
        X2aHDG8e0f0M/
X-Received: by 2002:a05:620a:4104:b0:75b:23a0:e7a1 with SMTP id j4-20020a05620a410400b0075b23a0e7a1mr13382717qko.2.1687204678217;
        Mon, 19 Jun 2023 12:57:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5icZzD7gXE5USnFIzgI7gJWnT9xTLWjfZLGHVrmj1t+1AdjxWockVfBiCVTz9birW0aCZT9w==
X-Received: by 2002:a05:620a:4104:b0:75b:23a0:e7a1 with SMTP id j4-20020a05620a410400b0075b23a0e7a1mr13382701qko.2.1687204677912;
        Mon, 19 Jun 2023 12:57:57 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j2-20020a05620a146200b0076223cde82bsm264595qkl.85.2023.06.19.12.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 12:57:57 -0700 (PDT)
Message-ID: <cc93bd8c-37d2-8755-daf3-8fa8e85a9b74@redhat.com>
Date:   Mon, 19 Jun 2023 21:57:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/6] arm: pmu: Fix chain counter
 enable/disable sequences
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230531201438.3881600-5-eric.auger@redhat.com>
 <ZIw-cJJha3OSYSMW@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZIw-cJJha3OSYSMW@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,
On 6/16/23 12:50, Alexandru Elisei wrote:
> Hi,
>
> On Wed, May 31, 2023 at 10:14:36PM +0200, Eric Auger wrote:
>> In some ARM ARM ddi0487 revisions it is said that
>> disabling/enabling a pair of counters that are paired
>> by a CHAIN event should follow a given sequence:
>>
>> Enable the high counter first, isb, enable low counter
>> Disable the low counter first, isb, disable the high counter
>>
>> This was the case in Fc. However this is not written anymore
>> in subsequent revions such as Ia.
>>
>> Anyway, just in case, and because it also makes the code a
>> little bit simpler, introduce 2 helpers to enable/disable chain
>> counters that execute those sequences and replace the existing
>> PMCNTENCLR/ENSET calls (at least this cannot do any harm).
>>
>> Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
>> and replace them by PMCNTENCLR writes since writing 0 in
>> PMCNTENSET_EL0 has no effect.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v1 -> v2:
>> - fix the enable_chain_counter()/disable_chain_counter()
>>   sequence, ie. swap n + 1 / n as reported by Alexandru.
>> - fix an other comment using the 'low' terminology
>> ---
>>  arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
>>  1 file changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 74dd4c10..74c9f6f9 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -731,6 +731,22 @@ static void test_chained_sw_incr(bool unused)
>>  		    read_regn_el0(pmevcntr, 0), \
>>  		    read_sysreg(pmovsclr_el0))
>>  
>> +static void enable_chain_counter(int even)
>> +{
>> +	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the high counter first */
>> +	isb();
>> +	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the low counter */
>> +	isb();
>> +}
>> +
>> +static void disable_chain_counter(int even)
>> +{
>> +	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the low counter first*/
>> +	isb();
>> +	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the high counter */
>> +	isb();
>> +}
>> +
>>  static void test_chain_promotion(bool unused)
> Here's what test_chain_promotion() does for the first subtest:
>
> static void test_chain_promotion(bool unused)
> {
>         uint32_t events[] = {MEM_ACCESS, CHAIN};
>         void *addr = malloc(PAGE_SIZE);
>
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>                 return;
>
>         /* Only enable CHAIN counter */
>         report_prefix_push("subtest1");
>         pmu_reset();
>         write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>         write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>         write_sysreg_s(0x2, PMCNTENSET_EL0);
>         isb();
>
>         mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>
> And here's what test_chained_counters() does:
>
> static void test_chained_counters(bool unused)
> {
>         uint32_t events[] = {CPU_CYCLES, CHAIN};
>         uint64_t all_set = pmevcntr_mask();
>
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>                 return;
>
>         pmu_reset();
>
>         write_regn_el0(pmevtyper, 0, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>         write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>         /* enable counters #0 and #1 */
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>         write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>
>         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>
> Why the extra ISB in test_chain_promotion()? Or, if you want to look at it
> the other way around, is the ISB missing from test_chained_counters()?

agreed. as mentionned below, enable_chain_counter() can also be
used here and this issues an isb().
>
>>  {
>>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>> @@ -769,16 +785,17 @@ static void test_chain_promotion(bool unused)
>>  	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
>>  	report_prefix_push("subtest3");
>>  	pmu_reset();
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>> -	isb();
>> +	enable_chain_counter(0);
>>  	PRINT_REGS("init");
> Here's how subtest3 ends up looking:
>
>         report_prefix_push("subtest3");
>         pmu_reset();
>         write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>         enable_chain_counter(0);
>         PRINT_REGS("init");
>
>         mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>
> And here's something similar from test_chained_counters():
>
>         pmu_reset();
>         write_sysreg_s(0x3, PMCNTENSET_EL0);
>
>         write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>         write_regn_el0(pmevcntr, 1, 0x1);
>         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>
>
> Why does test_chain_promotion() use enable_chain_counter() and
> test_chained_counters() doesn't?
>
> Could probably find more examples of this in test_chain_promotion().

agreed. I used enable_chain_counter() in test_chain_promotion()
and test_chained_sw_incr() whenever possible. In other case, both
counters are not set in 'chained' mode.
>
> As an aside, it's extremely difficult to figure out how the counters are
> programmed for a subtest. In the example above, you need to go back 2
> subtests, to the start of test_chain_promotion(), to figure that out. And
> that only gets worse the subtest number increases. test_chain_promotion()
> would really benefit from being split into separate functions, each with
> each own clear initial state. But that's for another patch, not for this
> series.

Yes I do agree with you. This subset splitting was not the best idea
ever. That can be reworked separately indeed.

Thank you for your time!

Eric
>
> Thanks,
> Alex
>
>>  
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* disable the CHAIN event */
>> -	write_sysreg_s(0x2, PMCNTENCLR_EL0);
>> +	disable_chain_counter(0);
>> +	write_sysreg_s(0x1, PMCNTENSET_EL0); /* Enable the low counter */
>> +	isb();
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2nd loop");
>>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>> @@ -799,9 +816,11 @@ static void test_chain_promotion(bool unused)
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>> -	/* enable the CHAIN event */
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>> +	/* Disable the low counter first and enable the chain counter */
>> +	write_sysreg_s(0x1, PMCNTENCLR_EL0);
>>  	isb();
>> +	enable_chain_counter(0);
>> +
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  
>>  	PRINT_REGS("After 2nd loop");
>> @@ -825,10 +844,10 @@ static void test_chain_promotion(bool unused)
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* 0 becomes CHAINED */
>> -	write_sysreg_s(0x0, PMCNTENSET_EL0);
>> +	write_sysreg_s(0x3, PMCNTENCLR_EL0);
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 1, 0x0);
>> +	enable_chain_counter(0);
>>  
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2nd loop");
>> @@ -844,13 +863,13 @@ static void test_chain_promotion(bool unused)
>>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>> -	write_sysreg_s(0x3, PMCNTENSET_EL0);
>> +	enable_chain_counter(0);
>>  	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>> -	write_sysreg_s(0x0, PMCNTENSET_EL0);
>> +	disable_chain_counter(0);
>>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  
>> -- 
>> 2.38.1
>>

