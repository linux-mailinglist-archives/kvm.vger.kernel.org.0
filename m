Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC066ED5ED
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 22:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjDXUK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 16:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjDXUKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 16:10:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF34640E0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682366982;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ujYVgz+txm1lGBh6SyDK3CxW+aQKwQ3pZ931TZpn/KY=;
        b=XV+tJw+X40fd01dMTI+im8WtA6+5cnYfJGHLQ0MtEYKg+HBnaluVMSiQ6c+9BBzSHAN1yX
        T4P/sKXqznvUMp0Ue2gw+mlSJ2nA4PmaMFK3K6L7IwJ1T3eeOLOjTpx99CfQDg6jg9TfMW
        uxphUxdTIKj7P8ch+nQuKmozD1JwGyg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-yWhlRnhXMxS5Cyfsoi6ODQ-1; Mon, 24 Apr 2023 16:09:40 -0400
X-MC-Unique: yWhlRnhXMxS5Cyfsoi6ODQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-2f625d521abso2632237f8f.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682366979; x=1684958979;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujYVgz+txm1lGBh6SyDK3CxW+aQKwQ3pZ931TZpn/KY=;
        b=JfuQn1PWwnyflV4HteGBjP6ItNI4cSaKeyLAaLz4gLa4iDkwX8+EymgPwbbB3Y55VI
         QNOZZ8OjE71wmgIkunNVaAEhClsE6WJUA+GjNUiZPDdHHmzjKxhkNADyTercZiv+isMw
         AAVMtvDa/SLmIZPJ966iaxmcipfjErp676aVUUXtsfHTJHlO5MAYkC2/upZKsy5DHzjs
         sBD6DldyN63t3ua5vb2vNxYpH+ixoRhWw+1BvikbPV5gKsCSIwWMPWYY/lSdMbdN7MoP
         7ePVakLteAJ9U4d6I61Bb3++xNkbO6QggLewW7pWbfwAL0OhXoDd4E5fQD+j9h6jVO64
         SkVw==
X-Gm-Message-State: AAQBX9flS8PrrElr1JZGLqXcVmRCwJBbNCnLY1Oq26Cn5/czZRX4PRaV
        foUpPD2p6SZj/Z7+s2+jYe3bssU+HS9XsGxMCwEvKp0IZ0XHEjyx+hNTMzYsUuYSjPjsGmVnQOs
        qqx2iL3m3pyA9
X-Received: by 2002:a5d:58f5:0:b0:2f9:896a:7554 with SMTP id f21-20020a5d58f5000000b002f9896a7554mr10072784wrd.13.1682366979445;
        Mon, 24 Apr 2023 13:09:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvVUmxH8EgEECxq3QfhKsGRstKP2b4ZNGJRtfyXUfJpWyQS+VMo6s53nDoo6D1UjtREQ67KA==
X-Received: by 2002:a5d:58f5:0:b0:2f9:896a:7554 with SMTP id f21-20020a5d58f5000000b002f9896a7554mr10072769wrd.13.1682366979062;
        Mon, 24 Apr 2023 13:09:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r4-20020adfdc84000000b002f598008d50sm11431897wrj.34.2023.04.24.13.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 13:09:38 -0700 (PDT)
Message-ID: <e518045c-6138-f9b7-7503-3b3b47c7ee80@redhat.com>
Date:   Mon, 24 Apr 2023 22:09:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/6] arm: pmu: pmu-chain-promotion:
 Introduce defines for count and margin values
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-3-eric.auger@redhat.com>
 <ZEJdpmTSyf6sp3Yv@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZEJdpmTSyf6sp3Yv@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,
On 4/21/23 11:55, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Mar 15, 2023 at 12:07:21PM +0100, Eric Auger wrote:
>> The pmu-chain-promotion test is composed of separate subtests.
>>
>> Some of them apply some settings on a first MEM_ACCESS loop
>> iterations, change the settings and run another MEM_ACCESS loop.
>>
>> The PRE_OVERFLOW2 MEM_ACCESS counter init value is defined so that
>> the first loop does not overflow and the second loop overflows.
>>
>> At the moment the MEM_ACCESS count number is hardcoded to 20 and
>> PRE_OVERFLOW2 is set to UINT32_MAX - 20 - 15 where 15 acts as a
>> margin.
>>
>> Introduce defines for the count number and the margin so that it
>> becomes easier to change them.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/pmu.c | 35 +++++++++++++++++++++--------------
>>  1 file changed, 21 insertions(+), 14 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index dad7d4b4..b88366a8 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -55,11 +55,18 @@
>>  #define EXT_COMMON_EVENTS_LOW	0x4000
>>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>>  
>> -#define ALL_SET_32			0x00000000FFFFFFFFULL
>> +#define ALL_SET_32		0x00000000FFFFFFFFULL
>>  #define ALL_CLEAR		0x0000000000000000ULL
>>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>> -#define PRE_OVERFLOW2_32	0x00000000FFFFFFDCULL
>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>> +#define COUNT 20
> test_mem_access (from the test "pmu-mem-access") also uses 20 for
> mem_access_loop, in case you want to change the define there too.
I hesitated to change this but in fact the mem-access test does not
suffer the same flaw and there is no risk we don't overflow when we set
to PRE_OVERFLOW init value as the measure is always larger than 20. so I
decided to keep the hardcoded value in that case.
>
> I realize I'm bikeshedding here, but it might also help if the define name
> held some clue to what is being counted (like ACCESS_COUNT, or something
> like that).
the event which is tested is MEM_ACCESS, that's whence the current name
stems from.
>
>> +#define MARGIN 15
>> +/*
>> + * PRE_OVERFLOW2 is set so that 1st COUNT iterations do not
>> + * produce 32b overflow and 2d COUNT iterations do. To accommodate
> 2**nd** COUNT iterations?
OK
>
>> + * for some observed variability we take into account a given @MARGIN
> Some inconsistency here, this variable is referred to with @MARGIN, but
> COUNT isn't (missing "@").
OK
>
>> + */
>> +#define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
> This is much better, I would have been hard pressed to figure out where the
> previous value of 0x00000000FFFFFFDCULL came from.
>
> The patch looks good to me (with or without the comments above):
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
thanks

Eric
>
> Thanks,
> Alex
>
>>  
>>  #define PRE_OVERFLOW(__overflow_at_64bits)				\
>>  	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
>> @@ -737,7 +744,7 @@ static void test_chain_promotion(bool unused)
>>  	write_sysreg_s(0x2, PMCNTENSET_EL0);
>>  	isb();
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("post");
>>  	report(!read_regn_el0(pmevcntr, 0),
>>  		"chain counter not counting if even counter is disabled");
>> @@ -750,13 +757,13 @@ static void test_chain_promotion(bool unused)
>>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>>  	isb();
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("post");
>>  	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
>>  		"odd counter did not increment on overflow if disabled");
>>  	report_prefix_pop();
>>  
>> -	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
>> +	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
>>  	report_prefix_push("subtest3");
>>  	pmu_reset();
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>> @@ -764,12 +771,12 @@ static void test_chain_promotion(bool unused)
>>  	isb();
>>  	PRINT_REGS("init");
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* disable the CHAIN event */
>>  	write_sysreg_s(0x2, PMCNTENCLR_EL0);
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2d loop");
>>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>>  		"should have triggered an overflow on #0");
>> @@ -777,7 +784,7 @@ static void test_chain_promotion(bool unused)
>>  		"CHAIN counter #1 shouldn't have incremented");
>>  	report_prefix_pop();
>>  
>> -	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
>> +	/* 1st COUNT with CHAIN disabled, next COUNT with CHAIN enabled */
>>  
>>  	report_prefix_push("subtest4");
>>  	pmu_reset();
>> @@ -786,13 +793,13 @@ static void test_chain_promotion(bool unused)
>>  	isb();
>>  	PRINT_REGS("init");
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* enable the CHAIN event */
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	isb();
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  
>>  	PRINT_REGS("After 2d loop");
>>  
>> @@ -811,7 +818,7 @@ static void test_chain_promotion(bool unused)
>>  	isb();
>>  	PRINT_REGS("init");
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	/* 0 becomes CHAINED */
>> @@ -820,7 +827,7 @@ static void test_chain_promotion(bool unused)
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 1, 0x0);
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2d loop");
>>  
>>  	report((read_regn_el0(pmevcntr, 1) == 1) &&
>> @@ -837,14 +844,14 @@ static void test_chain_promotion(bool unused)
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	PRINT_REGS("init");
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 1st loop");
>>  
>>  	write_sysreg_s(0x0, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  
>> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
>>  	PRINT_REGS("After 2d loop");
>>  	report(read_sysreg(pmovsclr_el0) == 1,
>>  		"overflow is expected on counter 0");
>> -- 
>> 2.38.1
>>
>>

