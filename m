Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A88F718AEC
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjEaUQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjEaUQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:16:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF30D126
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685564137;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A3DrwwfvwCXd6+7gks1RJn9Y9vf3cnR8jzSCC2zUk04=;
        b=TlppMDDHFUxGf+Wx4KrZehsFfeKQWLcRQgfTIWJ3CZy51ioeOKwmLvALnWLCiezbfnT7df
        ntzKlAyzKZhkHGBKfECilfdSjjN1TusxbynVK12+jnJHdFNHDpwpMvcTqMhjC2nrJWzV3h
        6L6cyTDZbDz6w0s4ZOCrgtIZMzHGEVQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-TaTDYHOUM0y4xbpiHL5r4g-1; Wed, 31 May 2023 16:15:36 -0400
X-MC-Unique: TaTDYHOUM0y4xbpiHL5r4g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30ae8776c12so78902f8f.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685564135; x=1688156135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A3DrwwfvwCXd6+7gks1RJn9Y9vf3cnR8jzSCC2zUk04=;
        b=IzKJzUvjGpmRH90sUdFVaq0G5N76VlI6JzVopAj9DoYiK1k6Olg3dx1gK4fBoP9d4R
         hPIYdb+qJb3X2iJU7+yelzfv8ZCEkykj3bHWUBrbr4jLL3xgkQKUWjXA6dZNb8+HfzUU
         DK2s6N6hJHTj55980ZLTns3oiMKUl1tTi2lg6+WiOVPsQ+ZEaziKjl4nRG9zE+6BRsZP
         MC6cRD5EKWxQrHPpTJr4ct9/6fBe7+bwWZJ+J2B8wjLMhvOOSGw7s8KLm/KpUHobFbCG
         PNtOkOGcsd95JM9YDR6Rq3eSmY/DOD0cIPzwv8pjFE1sV4nvfJg2Mbb5CFlNbHdqFeGn
         OBTA==
X-Gm-Message-State: AC+VfDxzjtHr6wb18MMeUXLXiaZdTooZ4tEI4DVBR6FB0GPPavP9Gwua
        39MYsIayw+fhbTKIr3O3tFjv5VSAsN9Zde26L5GWu1cWHX7xN9x1EkaDdLouXLCJ2XG3H7H4RUK
        owxowRBhjHxVM
X-Received: by 2002:adf:fed2:0:b0:307:5091:5b96 with SMTP id q18-20020adffed2000000b0030750915b96mr135384wrs.22.1685564135354;
        Wed, 31 May 2023 13:15:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4b5YKPcNuXa8YMkmOTtBLDOKPdZ617ApUGgpe+j7fR4ig/P881wKIeLdBZA8V5eFdvCWxz0A==
X-Received: by 2002:adf:fed2:0:b0:307:5091:5b96 with SMTP id q18-20020adffed2000000b0030750915b96mr135369wrs.22.1685564135051;
        Wed, 31 May 2023 13:15:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t4-20020a5d5344000000b00307acec258esm7874875wrv.3.2023.05.31.13.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 13:15:34 -0700 (PDT)
Message-ID: <b2fb0ef4-a311-1faa-6fca-20c38ab07431@redhat.com>
Date:   Wed, 31 May 2023 22:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 5/6] arm: pmu: Add
 pmu-memaccess-reliability test
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-6-eric.auger@redhat.com>
 <ZEJv2EINBwNRjBa6@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZEJv2EINBwNRjBa6@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 4/21/23 13:13, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Mar 15, 2023 at 12:07:24PM +0100, Eric Auger wrote:
>> Add a new basic test that runs MEM_ACCESS loop over
>> 100 iterations and make sure the number of measured
>> MEM_ACCESS never overflows the margin. Some other
>> pmu tests rely on this pattern and if the MEM_ACCESS
>> measurement is not reliable, it is better to report
>> it beforehand and not confuse the user any further.
>>
>> Without the subsequent patch, this typically fails on
>> ThunderXv2 with the following logs:
>>
>> INFO: pmu: pmu-memaccess-reliability: 32-bit overflows:
>> overflow=1 min=21 max=41 COUNT=20 MARGIN=15
>> FAIL: pmu: pmu-memaccess-reliability: 32-bit overflows:
>> memaccess is reliable
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/pmu.c         | 52 +++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg |  6 ++++++
>>  2 files changed, 58 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index af679667..c3d2a428 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -56,6 +56,7 @@
>>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>>  
>>  #define ALL_SET_32		0x00000000FFFFFFFFULL
>> +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
>>  #define ALL_CLEAR		0x0000000000000000ULL
>>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>> @@ -67,6 +68,10 @@
>>   * for some observed variability we take into account a given @MARGIN
>>   */
>>  #define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
>> +#define PRE_OVERFLOW2_64		(ALL_SET_64 - COUNT - MARGIN)
>> +
>> +#define PRE_OVERFLOW2(__overflow_at_64bits)				\
>> +	(__overflow_at_64bits ? PRE_OVERFLOW2_64 : PRE_OVERFLOW2_32)
>>  
>>  #define PRE_OVERFLOW(__overflow_at_64bits)				\
>>  	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
>> @@ -746,6 +751,50 @@ static void disable_chain_counter(int even)
>>  	isb();
>>  }
>>  
>> +static void test_memaccess_reliability(bool overflow_at_64bits)
>> +{
>> +	uint32_t events[] = {MEM_ACCESS};
>> +	void *addr = malloc(PAGE_SIZE);
>> +	uint64_t count, max = 0, min = pmevcntr_mask();
>> +	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
>> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>> +	bool overflow = false;
>> +
>> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>> +	    !check_overflow_prerequisites(overflow_at_64bits))
>> +		return;
>> +
>> +	pmu_reset();
>> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>> +	for (int i = 0; i < 100; i++) {
>> +		pmu_reset();
>> +		write_regn_el0(pmevcntr, 0, pre_overflow2);
>> +		write_sysreg_s(0x1, PMCNTENSET_EL0);
>> +		isb();
>> +		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> +		count = read_regn_el0(pmevcntr, 0);
>> +		if (count < pre_overflow2) {
>> +			count += COUNT + MARGIN;
>> +			if (count > max)
>> +				max = count;
>> +			if (count < min)
>> +				min = count;
>> +			overflow = true;
>> +			report_info("iter=%d count=%ld min=%ld max=%ld overflow!!!",
>> +				    i, count, min, max);
>> +			continue;
>> +		}
>> +		count -= pre_overflow2;
>> +		if (count > max)
>> +			max = count;
>> +		if (count < min)
>> +			min = count;
> I'm having difficulties following the above maze of conditions. That's not going
> to be easy to maintain.
>
> If I understand the commit message correctly, the point of this test is to check
> that PRE_OVERFLOW2 + COUNT doesn't overflow, but PRE_OVERFLOW2 + 2 * COUNT does.
> How about this simpler approach instead:
>
> 	for (int i = 0; i < 100; i++) {
> 		pmu_reset();
> 		write_regn_el0(pmevcntr, 0, pre_overflow2);
> 		write_sysreg_s(0x1, PMCNTENSET_EL0);
> 		isb();
>
> 		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> 		count = read_regn_el0(pmevcntr, 0);
> 		/* Counter overflowed when it shouldn't. */
> 		if (count < pre_overflow2) {
> 			report_fail("reliable memaccess loop");
> 			return;
> 		}
>
> 		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> 		count = read_regn_el0(pmevcntr, 0);
> 		/* Counter didn't overflow when it should. */
> 		if (count >= pre_overflow2) {
> 			report_fail("reliable memaccess loop");
> 			return;
> 		}
> 	}
>
> 	report_success("reliable memaccess loop");
The test only checks that loop with PRE_OVERFLOW2 init value does not
overflow (in which case the mem access count is considered as 'reliable'
for subsequent tests using the same kind of loop). Besides doing that
check, the test also records the min/max mem access count values over
100 iterations to have an idea about how much the counting is [un]reliable.
I rearranged the logic and added comments. Hopefully this will be easier
to read.

Thank you for the review!

Eric
>
> Thanks,
> Alex
>
>>  static void test_chain_promotion(bool unused)
>>  {
>>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>> @@ -1203,6 +1252,9 @@ int main(int argc, char *argv[])
>>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>>  		run_event_test(argv[1], test_basic_event_count, false);
>>  		run_event_test(argv[1], test_basic_event_count, true);
>> +	} else if (strcmp(argv[1], "pmu-memaccess-reliability") == 0) {
>> +		run_event_test(argv[1], test_memaccess_reliability, false);
>> +		run_event_test(argv[1], test_memaccess_reliability, true);
>>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>>  		run_event_test(argv[1], test_mem_access, false);
>>  		run_event_test(argv[1], test_mem_access, true);
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 5e67b558..301261aa 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -90,6 +90,12 @@ groups = pmu
>>  arch = arm64
>>  extra_params = -append 'pmu-mem-access'
>>  
>> +[pmu-memaccess-reliability]
>> +file = pmu.flat
>> +groups = pmu
>> +arch = arm64
>> +extra_params = -append 'pmu-memaccess-reliability'
>> +
>>  [pmu-sw-incr]
>>  file = pmu.flat
>>  groups = pmu
>> -- 
>> 2.38.1
>>

