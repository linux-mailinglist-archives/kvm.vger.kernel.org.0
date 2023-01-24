Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DACD67A3B4
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 21:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjAXUQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 15:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAXUQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 15:16:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE19E474E6
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674591344;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++j7LuFjzHAN55kQ6RxWyYZQdEf82chbUrKlQzI8uC4=;
        b=X/amjXYvfnm5FJekLFSpYAT0G00mD9d7P3raQbXWnd92xF49yuQfd+3XQsO+LWj806u2QD
        IhGOtQq58bgyslC59Cl9UMt9WpojnXm7RgcYHh5XHDfdD+DNCGcjxLlUI1iZC9grHqUdn+
        vzuqLQMGyHkgKhHQd7Z7r9CJgihxUnY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-138-YfCJ7ZKYNxCvVJgySkb4Uw-1; Tue, 24 Jan 2023 15:15:41 -0500
X-MC-Unique: YfCJ7ZKYNxCvVJgySkb4Uw-1
Received: by mail-qv1-f71.google.com with SMTP id jy13-20020a0562142b4d00b00535302dd1b8so8119770qvb.18
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:15:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=++j7LuFjzHAN55kQ6RxWyYZQdEf82chbUrKlQzI8uC4=;
        b=tJGoK9neqEqqU9bdDACDzrYA5HFca2l1ZPOkuECSlRr2Pz1Yf3S0biyBdL1fAAoN7i
         6YOh+v804qIrkYl+LdZXlyligqhvxtJC0EoNfkwK3FM1pvPbe4KL8LgN6RDwLr11iv79
         XNMq/iINFbL7clf0/myM59EbdNlKt5dVjyXaFEVJ37CqTO+tc3xXHeQ2+LCai80ldgbW
         KrggVhwP8S0AN/AUGb4H+fbNoBosvSEQQkrX0e1WAy3xuWtYoP+5yRf0WAX2Ez3xzHE3
         forouez7jtekqeqGqXTD2bELNCcxAD/SaAWifpcUKQXG9N2/bfXWe16vimaZ3JWRQuKT
         O+qw==
X-Gm-Message-State: AFqh2kr1YSOEAwDaG1arR/4KAyJfRr9HhAF8Rz9K9p2tk3p1CmBNVJHJ
        7NooRI0UMzdY2MfmicK5OqsCaSsh4PHNoqp6rn3criGsqhy41WZLOC4jPQxuygmCwUd1CNG4LGg
        6yFxG1KGnuwCI
X-Received: by 2002:ac8:5488:0:b0:3b6:9a0d:85b with SMTP id h8-20020ac85488000000b003b69a0d085bmr23818175qtq.40.1674591340531;
        Tue, 24 Jan 2023 12:15:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtAxTWWj5v30UeIltgql5Rxj1cLWENOjZR8BrxDJnum8Z11KXRj9/tOvvOpzQZ6m3yyeJFg5A==
X-Received: by 2002:ac8:5488:0:b0:3b6:9a0d:85b with SMTP id h8-20020ac85488000000b003b69a0d085bmr23818139qtq.40.1674591340148;
        Tue, 24 Jan 2023 12:15:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d5-20020ac85345000000b0039a610a04b1sm1848391qto.37.2023.01.24.12.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 12:15:39 -0800 (PST)
Message-ID: <14d813ba-492a-bf23-0dfd-ab4a9c708822@redhat.com>
Date:   Tue, 24 Jan 2023 21:15:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, reijiw@google.com
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <8bfc9b2b-0bad-a6dc-3c23-f67ad3d56741@redhat.com>
 <Y8/4kxSdOP2QrJVm@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Y8/4kxSdOP2QrJVm@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/24/23 16:26, Ricardo Koller wrote:
> On Mon, Jan 23, 2023 at 09:33:50PM +0100, Eric Auger wrote:
>> Hi Ricardo,
>>
>> On 1/9/23 22:17, Ricardo Koller wrote:
>>> Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
>>> and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
>>> supported on PMUv3p5.
>>>
>>> Note that chained tests do not implement "overflow_at_64bits == true".
>>> That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
>>> details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
>>> 0487H.a, J1.1.1 "aarch64/debug").
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  arm/pmu.c | 116 +++++++++++++++++++++++++++++++++++-------------------
>>>  1 file changed, 75 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>> index 0d06b59..72d0f50 100644
>>> --- a/arm/pmu.c
>>> +++ b/arm/pmu.c
>>> @@ -28,6 +28,7 @@
>>>  #define PMU_PMCR_X         (1 << 4)
>>>  #define PMU_PMCR_DP        (1 << 5)
>>>  #define PMU_PMCR_LC        (1 << 6)
>>> +#define PMU_PMCR_LP        (1 << 7)
>>>  #define PMU_PMCR_N_SHIFT   11
>>>  #define PMU_PMCR_N_MASK    0x1f
>>>  #define PMU_PMCR_ID_SHIFT  16
>>> @@ -56,9 +57,13 @@
>>>  
>>>  #define ALL_SET			0x00000000FFFFFFFFULL
>>>  #define ALL_CLEAR		0x0000000000000000ULL
>>> -#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
>>> +#define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>>> +#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>>>  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>>>  
>>> +#define PRE_OVERFLOW(__overflow_at_64bits)				\
>>> +	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
>>> +
>>>  #define PMU_PPI			23
>>>  
>>>  struct pmu {
>>> @@ -449,8 +454,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
>>>  static void test_basic_event_count(bool overflow_at_64bits)
>>>  {
>>>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
>>> -	uint32_t counter_mask;
>>> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
>>> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>>>  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
>>> +	uint32_t counter_mask;
>>>  
>>>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>>>  	    !check_overflow_prerequisites(overflow_at_64bits))
>>> @@ -472,13 +479,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
>>>  	 * clear cycle and all event counters and allow counter enablement
>>>  	 * through PMCNTENSET. LC is RES1.
>>>  	 */
>>> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
>>> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
>>>  	isb();
>>> -	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
>>> +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
>>>  
>>>  	/* Preset counter #0 to pre overflow value to trigger an overflow */
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>> +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>>>  		"counter #0 preset to pre-overflow value");
>>>  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
>>>  
>>> @@ -531,6 +538,8 @@ static void test_mem_access(bool overflow_at_64bits)
>>>  {
>>>  	void *addr = malloc(PAGE_SIZE);
>>>  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
>>> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
>>> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>>>  
>>>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>>>  	    !check_overflow_prerequisites(overflow_at_64bits))
>>> @@ -542,7 +551,7 @@ static void test_mem_access(bool overflow_at_64bits)
>>>  	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>>  	isb();
>>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>>> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>  	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
>>>  	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
>>>  	/* We may measure more than 20 mem access depending on the core */
>>> @@ -552,11 +561,11 @@ static void test_mem_access(bool overflow_at_64bits)
>>>  
>>>  	pmu_reset();
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>>  	isb();
>>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>>> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>  	report(read_sysreg(pmovsclr_el0) == 0x3,
>>>  	       "Ran 20 mem accesses with expected overflows on both counters");
>>>  	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
>>> @@ -566,8 +575,10 @@ static void test_mem_access(bool overflow_at_64bits)
>>>  
>>>  static void test_sw_incr(bool overflow_at_64bits)
>>>  {
>>> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
>>> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>>>  	uint32_t events[] = {SW_INCR, SW_INCR};
>>> -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>>> +	uint64_t cntr0 = (pre_overflow + 100) & pmevcntr_mask();
>>>  	int i;
>>>  
>>>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>>> @@ -581,7 +592,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>>>  	/* enable counters #0 and #1 */
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>  	isb();
>>>  
>>>  	for (i = 0; i < 100; i++)
>>> @@ -589,14 +600,14 @@ static void test_sw_incr(bool overflow_at_64bits)
>>>  
>>>  	isb();
>>>  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
>>> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
>>> +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>>>  		"PWSYNC does not increment if PMCR.E is unset");
>>>  
>>>  	pmu_reset();
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>>> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>  	isb();
>>>  
>>>  	for (i = 0; i < 100; i++)
>>> @@ -614,6 +625,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>>>  static void test_chained_counters(bool unused)
>>>  {
>>>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
>>> +	uint64_t all_set = pmevcntr_mask();
>> ALL_SET_32 may be enough, as suggested by Reiji;
> I think we still want to conditionally use ALL_SET_64 for the
> pre-overflow value of the odd counter in the case of PMUv3p5.
> More below.
Ah OK I initially understood there were no chain events at all with
PMUv3p5at. However they do exit if LP=0. Sorry for the noise.
>
>>>  
>>>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>>>  		return;
>>> @@ -624,7 +636,7 @@ static void test_chained_counters(bool unused)
>>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>>  	/* enable counters #0 and #1 */
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>>  
>>>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>>>  
>>> @@ -636,26 +648,26 @@ static void test_chained_counters(bool unused)
>>>  	pmu_reset();
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>>  	write_regn_el0(pmevcntr, 1, 0x1);
>>>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>>>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>>>  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
>>>  	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> As we want to test the overflow of the chained counter, we need
> ALL_SET_64 for its preoverflow value.
>
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> -	write_regn_el0(pmevcntr, 1, ALL_SET);
>>> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>> +	write_regn_el0(pmevcntr, 1, all_set);
>> and here
>>>  
>>>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>>>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>>> -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
>>> +	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
>>>  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>>>  }
>>>  
>>>  static void test_chained_sw_incr(bool unused)
>>>  {
>>>  	uint32_t events[] = {SW_INCR, CHAIN};
>>> -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>>> +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
>>>  	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
>>>  	int i;
>> the chained counter changes may be put in a separate patch to help the
>> reviewer focus on the new 64b overflow tests.
> Got it, will try that for the next version.
>
>>>  
>>> @@ -669,7 +681,7 @@ static void test_chained_sw_incr(bool unused)
>>>  	/* enable counters #0 and #1 */
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>>>  	isb();
>>>  
>>> @@ -687,7 +699,7 @@ static void test_chained_sw_incr(bool unused)
>>>  	pmu_reset();
>>>  
>>>  	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>>  	write_regn_el0(pmevcntr, 1, ALL_SET);
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>>> @@ -726,7 +738,7 @@ static void test_chain_promotion(bool unused)
>>>  
>>>  	/* Only enable even counter */
>>>  	pmu_reset();
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>>>  	isb();
>>>  
>>> @@ -856,6 +868,9 @@ static bool expect_interrupts(uint32_t bitmap)
>>>  
>>>  static void test_overflow_interrupt(bool overflow_at_64bits)
>>>  {
>>> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
>>> +	uint64_t all_set = pmevcntr_mask();
>>> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>>>  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
>>>  	void *addr = malloc(PAGE_SIZE);
>>>  	int i;
>>> @@ -874,16 +889,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>>  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
>>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>>>  	isb();
>>>  
>>>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>>>  
>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
>>> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> I noticed that undocumented change. Is it done on purpose?
> Yes, it's intentional. It conditionally sets PMCR.LP for the next
> subtest when overflow_at_64bits==true. That's also why the pre-overflow
> value is close to ALL_SET_64 (and not ALL_SET_32).
I rather meant s/200/20

Thanks

Eric
>
>>>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>>>  
>>> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>>> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>  	isb();
>>>  
>>>  	for (i = 0; i < 100; i++)
>>> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>  
>>>  	pmu_reset_stats();
>>>  
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>>>  	write_sysreg(ALL_SET, pmintenset_el1);
>>>  	isb();
>>>  
>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
>>> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>  	for (i = 0; i < 100; i++)
>>>  		write_sysreg(0x3, pmswinc_el0);
>>>  
>>> @@ -912,25 +927,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>  	report(expect_interrupts(0x3),
>>>  		"overflow interrupts expected on #0 and #1");
>>>  
>>> -	/* promote to 64-b */
>>> +	/*
>>> +	 * promote to 64-b:
>>> +	 *
>>> +	 * This only applies to the !overflow_at_64bits case, as
>>> +	 * overflow_at_64bits doesn't implement CHAIN events. The
>>> +	 * overflow_at_64bits case just checks that chained counters are
>>> +	 * not incremented when PMCR.LP == 1.
>>> +	 */
>>>  
>>>  	pmu_reset_stats();
>>>  
>>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>  	isb();
>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
>>> -	report(expect_interrupts(0x1),
>>> -		"expect overflow interrupt on 32b boundary");
>>> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>> +	report(expect_interrupts(0x1), "expect overflow interrupt");
>>>  
>>>  	/* overflow on odd counter */
>>>  	pmu_reset_stats();
>>> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>> -	write_regn_el0(pmevcntr, 1, ALL_SET);
>>> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>>> +	write_regn_el0(pmevcntr, 1, all_set);
>>>  	isb();
>>> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
>>> -	report(expect_interrupts(0x3),
>>> -		"expect overflow interrupt on even and odd counter");
>>> +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>> +	if (overflow_at_64bits) {
>>> +		report(expect_interrupts(0x1),
>>> +		       "expect overflow interrupt on even counter");
>>> +		report(read_regn_el0(pmevcntr, 1) == all_set,
>>> +		       "Odd counter did not change");
>>> +	} else {
>>> +		report(expect_interrupts(0x3),
>>> +		       "expect overflow interrupt on even and odd counter");
>>> +		report(read_regn_el0(pmevcntr, 1) != all_set,
>>> +		       "Odd counter wrapped");
>>> +	}
>>>  }
>>>  #endif
>>>  
>>> @@ -1131,10 +1161,13 @@ int main(int argc, char *argv[])
>>>  		report_prefix_pop();
>>>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>>>  		run_test(argv[1], test_basic_event_count, false);
>>> +		run_test(argv[1], test_basic_event_count, true);
>>>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>>>  		run_test(argv[1], test_mem_access, false);
>>> +		run_test(argv[1], test_mem_access, true);
>>>  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
>>>  		run_test(argv[1], test_sw_incr, false);
>>> +		run_test(argv[1], test_sw_incr, true);
>>>  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
>>>  		run_test(argv[1], test_chained_counters, false);
>>>  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
>>> @@ -1143,6 +1176,7 @@ int main(int argc, char *argv[])
>>>  		run_test(argv[1], test_chain_promotion, false);
>>>  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
>>>  		run_test(argv[1], test_overflow_interrupt, false);
>>> +		run_test(argv[1], test_overflow_interrupt, true);
>>>  	} else {
>>>  		report_abort("Unknown sub-test '%s'", argv[1]);
>>>  	}
>> Thanks
>>
>> Eric
>>

