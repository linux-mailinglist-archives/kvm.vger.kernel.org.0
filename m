Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0B67440FD
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 19:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjF3RQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 13:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjF3RQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 13:16:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F384A183
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688145343;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZdTDhbZr4eQQTRSk7eayCEYmdszTgdjX7jCu+h7WTEM=;
        b=Wy1vyJP4+954epO8l+8YvUi29W7UGfg8pj28sXGnm8090VwUO2k/6Rhg2LwQ8f7/JN8Qvk
        RC0f+/GDvu+ZajI/LEeDMezxrWRBlP3U4kfsCiYPBQ0XuQ1qCoU75937qreoWROOKAMHUR
        oyvarsP/jaw7EQ013c3HrT0VNz4z8wY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-fizKD8Q4OdK_Nnct5d7eDw-1; Fri, 30 Jun 2023 13:15:41 -0400
X-MC-Unique: fizKD8Q4OdK_Nnct5d7eDw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30e6153f0eeso1091851f8f.0
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688145340; x=1690737340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZdTDhbZr4eQQTRSk7eayCEYmdszTgdjX7jCu+h7WTEM=;
        b=lpk0BseiwJRqEDljJbB+BqkBEn040dRciDHtxsGqJS6eX0n4MTRx/d3RrPAcjGZLo/
         dE/ye6rCCFLEI6h840j218T1d7EqeJDirIXHW0c2jganzs0qE6DdSW7bunoce1i4k2PS
         SQuZvVS+kw3g9cDg3Uri+y0biEiQu+rBB+rlzgDYyVjSxuUN6B4qjkgAGDcT2Hbbalur
         VdSzFUNZGW0X0b0iMVY9cCxJlrQrB9/46ktclPRKw+6UxCqPZ+A2mtSfb9+c/XKjByDY
         dT0eg8hZvuVNN5V6EFNe3+ebG5HXmUyke++WzPZr3skXwIuAVwEsCdvaeM2IAf8A2V5x
         HOoQ==
X-Gm-Message-State: ABy/qLYZOcst846HhHQd429CeuuMQMWHiLHRR3sRkmpVc+dgOPKTbKtf
        Rg13MChdJCTStFa6tF9bufJlr1Js4kmJfKPbhls7nz8ncLYwqK5Gfz2ttCnQAa9CorczkpS9Tcg
        3wRYITMct4Zfk
X-Received: by 2002:a5d:63ca:0:b0:314:2594:7b9f with SMTP id c10-20020a5d63ca000000b0031425947b9fmr1537716wrw.11.1688145340110;
        Fri, 30 Jun 2023 10:15:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGYQtNnqxzBlUMaJpB4SLIl9agMNRhMzLKZKgZfHAAAO79NYFKr3eANPETkJIKzZ3Y9SRHyrA==
X-Received: by 2002:a5d:63ca:0:b0:314:2594:7b9f with SMTP id c10-20020a5d63ca000000b0031425947b9fmr1537691wrw.11.1688145339672;
        Fri, 30 Jun 2023 10:15:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h11-20020a1ccc0b000000b003fa8158135esm20167744wmb.11.2023.06.30.10.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 10:15:38 -0700 (PDT)
Message-ID: <829d87f7-2103-ef6f-5d3b-18aa8f8cb850@redhat.com>
Date:   Fri, 30 Jun 2023 19:15:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-6-eric.auger@redhat.com>
 <ZJ7_UrrBdgn6FB7-@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZJ7_UrrBdgn6FB7-@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 6/30/23 18:14, Alexandru Elisei wrote:
> Hi,
>
> On Mon, Jun 19, 2023 at 10:04:00PM +0200, Eric Auger wrote:
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
>> INFO: pmu: pmu-mem-access-reliability: 32-bit overflows:
>> overflow=1 min=21 max=41 COUNT=20 MARGIN=15
>> FAIL: pmu: pmu-mem-access-reliability: 32-bit overflows:
>> mem_access count is reliable
> Looks good:
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> Also ran the test on my rockpro64, with qemu and kvmtool. With kvmtool,
> when running on the little cores, min=max=250, but when running on the big
> cores, there was some deviation from that, I would say about 5 events,
> varying from run to run. I assume this is because the little cores are in
> order, and the big cores are out of order. Maybe the reason why you are
> seeing such a big difference between min and max on the ThunderX 2, the
> core might be speculating more aggressively.

thank you for your time. At least this new test outputting the min/max
will give interesting indications of what can be expected from the mem
access count precision on a given HW.
>
> Anyway:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

Eric
>
> Thanks,
> Alex
>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v2 -> v3:
>> - rename variables as suggested by Alexandru, rework the
>>   traces accordingly. Use all_set.
>>
>> v1 -> v2:
>> - use mem-access instead of memaccess as suggested by Mark
>> - simplify the logic and add comments in the test loop
>> ---
>>  arm/pmu.c         | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg |  6 +++++
>>  2 files changed, 65 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 0995a249..491d2958 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -56,6 +56,11 @@
>>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>>  
>>  #define ALL_SET_32		0x00000000FFFFFFFFULL
>> +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
>> +
>> +#define ALL_SET(__overflow_at_64bits)				\
>> +	(__overflow_at_64bits ? ALL_SET_64 : ALL_SET_32)
>> +
>>  #define ALL_CLEAR		0x0000000000000000ULL
>>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>> @@ -67,6 +72,10 @@
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
>> @@ -744,6 +753,53 @@ static void test_chained_sw_incr(bool unused)
>>  		    read_regn_el0(pmevcntr, 0), \
>>  		    read_sysreg(pmovsclr_el0))
>>  
>> +/*
>> + * This test checks that a mem access loop featuring COUNT accesses
>> + * does not overflow with an init value of PRE_OVERFLOW2. It also
>> + * records the min/max access count to see how much the counting
>> + * is (un)reliable
>> + */
>> +static void test_mem_access_reliability(bool overflow_at_64bits)
>> +{
>> +	uint32_t events[] = {MEM_ACCESS};
>> +	void *addr = malloc(PAGE_SIZE);
>> +	uint64_t cntr_val, num_events, max = 0, min = pmevcntr_mask();
>> +	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
>> +	uint64_t all_set = ALL_SET(overflow_at_64bits);
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
>> +		cntr_val = read_regn_el0(pmevcntr, 0);
>> +		if (cntr_val >= pre_overflow2) {
>> +			num_events = cntr_val - pre_overflow2;
>> +		} else {
>> +			/* unexpected counter overflow */
>> +			num_events = cntr_val + all_set - pre_overflow2;
>> +			overflow = true;
>> +			report_info("iter=%d num_events=%ld min=%ld max=%ld overflow!!!",
>> +				    i, num_events, min, max);
>> +		}
>> +		/* record extreme value */
>> +		max = MAX(num_events, max);
>> +		min = MIN(num_events, min);
>> +	}
>> +	report_info("overflow=%d min=%ld max=%ld expected=%d acceptable margin=%d",
>> +		    overflow, min, max, COUNT, MARGIN);
>> +	report(!overflow, "mem_access count is reliable");
>> +}
>> +
>>  static void test_chain_promotion(bool unused)
>>  {
>>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>> @@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
>>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>>  		run_event_test(argv[1], test_basic_event_count, false);
>>  		run_event_test(argv[1], test_basic_event_count, true);
>> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
>> +		run_event_test(argv[1], test_mem_access_reliability, false);
>> +		run_event_test(argv[1], test_mem_access_reliability, true);
>>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>>  		run_event_test(argv[1], test_mem_access, false);
>>  		run_event_test(argv[1], test_mem_access, true);
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 5e67b558..fe601cbb 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -90,6 +90,12 @@ groups = pmu
>>  arch = arm64
>>  extra_params = -append 'pmu-mem-access'
>>  
>> +[pmu-mem-access-reliability]
>> +file = pmu.flat
>> +groups = pmu
>> +arch = arm64
>> +extra_params = -append 'pmu-mem-access-reliability'
>> +
>>  [pmu-sw-incr]
>>  file = pmu.flat
>>  groups = pmu
>> -- 
>> 2.38.1
>>

