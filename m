Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70495BE1D6
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiITJYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiITJXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95819647F5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663665811;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GSf87BSSgNT/V3eE50g8WgBHpFjYwLE65SvSOgqQPh4=;
        b=YCJJn0PlLnmZl95E29IHtmuaKeEsVXn508QZ5ANWAi8r59KTkmBzmAf+c/AngbUjjGxSBI
        2Wn0pHb0k267x7GiuIBfBarEf2bYy4dIJsJyMAIBBdgbR8QQ2mhbpLWGWH3F4kamTmYpUQ
        2Fb5WXsPl8isXhDvxOTh4fKiW9oei2Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-63-RSj_XJ0VO_WOUUvgmoa6kw-1; Tue, 20 Sep 2022 05:23:29 -0400
X-MC-Unique: RSj_XJ0VO_WOUUvgmoa6kw-1
Received: by mail-ej1-f72.google.com with SMTP id go7-20020a1709070d8700b007793ffa7c44so1061318ejc.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=GSf87BSSgNT/V3eE50g8WgBHpFjYwLE65SvSOgqQPh4=;
        b=y2PPap/1FeCzw78o8p1HBHz/ibgk9GI8UG/IWXFEE22o9EPA1dcFRuiYpWc53dBJbh
         bwjETB0Cy5wAIFtdVkf3ieeVCsqlhuMkXdMl5LrUlPhc2+jcfYZOydOmZewB8+HvX4hg
         kKA6fTHj9+oMCEWzgK7gq272ADoPk6Ux7XWsC7wwLqGTl3B0xkL8Rl2FEJK81OVbiq4k
         AqQQjNc9ZWlEgm02Hm2ZIGuCCn3EFkqitv/CiOQAk8o18aToA1nPX+loLeByJTst7kED
         G7hETGrAn3EIW1kThsyVCo9PIcS2uD/Zw4pilRRLMYLYNbjQcbSEhRm5eCw4M6FYFDta
         Lh8w==
X-Gm-Message-State: ACrzQf1YJbssWlhlfagDD5tCTeneh2AI6WUezd2w1UL6a+qHsdlFfsDN
        IvY1in/4GxNsoCAIkIO5/5BAETelDOUFpxRTk5Vjj3Domtgq7L5Ls5tFoZy6W6hfKIzirilc6jz
        1zOYUWbX4p7kQ
X-Received: by 2002:a05:6402:510c:b0:451:f363:24ee with SMTP id m12-20020a056402510c00b00451f36324eemr19402265edd.156.1663665807778;
        Tue, 20 Sep 2022 02:23:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7THS77/1aqAMyw96VtLINHAQS+Y0X3Fmcn7BxfNJgup6o0hnv6228D6cJl3NPO0wZnB0KUCw==
X-Received: by 2002:a05:6402:510c:b0:451:f363:24ee with SMTP id m12-20020a056402510c00b00451f36324eemr19402256edd.156.1663665807600;
        Tue, 20 Sep 2022 02:23:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d28-20020a056402401c00b0044e7862ab3fsm952192eda.7.2022.09.20.02.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 02:23:26 -0700 (PDT)
Message-ID: <82f23813-a8ca-d350-891f-100d23c9601e@redhat.com>
Date:   Tue, 20 Sep 2022 11:23:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 07/12] arm: pmu: Basic event counter
 Tests
Content-Language: en-US
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andrew.murray@arm.com,
        andre.przywara@arm.com
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-8-eric.auger@redhat.com>
 <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 9/19/22 16:30, Zenghui Yu wrote:
> Hi Eric,
>
> A few comments when looking through the PMU test code (2 years after
> the series was merged).

Thank you for reviewing even after this time! Do you want to address the
issues yourself and send a patch series or do you prefer I proceed?

Thanks

Eric
> On 2020/4/3 15:13, Eric Auger wrote:
>> Adds the following tests:
>> - event-counter-config: test event counter configuration
>> - basic-event-count:
>>   - programs counters #0 and #1 to count 2 required events
>>   (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
>>   to a value close enough to the 32b
>>   overflow limit so that we check the overflow bit is set
>>   after the execution of the asm loop.
>> - mem-access: counts MEM_ACCESS event on counters #0 and #1
>>   with and without 32-bit overflow.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>
> [...]
>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index 8c49e50..45dccf7 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -38,6 +43,7 @@
>>  #define SW_INCR            0x0
>>  #define INST_RETIRED        0x8
>>  #define CPU_CYCLES        0x11
>> +#define MEM_ACCESS        0x13
>>  #define INST_PREC        0x1B
>
> The spec spells event 0x001B as INST_SPEC.
>
>>  #define STALL_FRONTEND        0x23
>>  #define STALL_BACKEND        0x24
>
> [...]
>
>> @@ -175,6 +188,11 @@ static inline void precise_instrs_loop(int loop,
>> uint32_t pmcr)
>>  }
>>  
>>  #define PMCEID1_EL0 sys_reg(3, 3, 9, 12, 7)
>> +#define PMCNTENSET_EL0 sys_reg(3, 3, 9, 12, 1)
>> +#define PMCNTENCLR_EL0 sys_reg(3, 3, 9, 12, 2)
>> +
>> +#define PMEVTYPER_EXCLUDE_EL1 BIT(31)
>
> Unused macro.
>
>> +#define PMEVTYPER_EXCLUDE_EL0 BIT(30)
>>  
>>  static bool is_event_supported(uint32_t n, bool warn)
>>  {
>> @@ -228,6 +246,224 @@ static void test_event_introspection(void)
>>      report(required_events, "Check required events are implemented");
>>  }
>>  
>> +/*
>> + * Extra instructions inserted by the compiler would be difficult to
>> compensate
>> + * for, so hand assemble everything between, and including, the PMCR
>> accesses
>> + * to start and stop counting. isb instructions are inserted to make
>> sure
>> + * pmccntr read after this function returns the exact instructions
>> executed
>> + * in the controlled block. Loads @loop times the data at @address
>> into x9.
>> + */
>> +static void mem_access_loop(void *addr, int loop, uint32_t pmcr)
>> +{
>> +asm volatile(
>> +    "       msr     pmcr_el0, %[pmcr]\n"
>> +    "       isb\n"
>> +    "       mov     x10, %[loop]\n"
>> +    "1:     sub     x10, x10, #1\n"
>> +    "       ldr    x9, [%[addr]]\n"
>> +    "       cmp     x10, #0x0\n"
>> +    "       b.gt    1b\n"
>> +    "       msr     pmcr_el0, xzr\n"
>> +    "       isb\n"
>> +    :
>> +    : [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
>> +    : "x9", "x10", "cc");
>> +}
>> +
>> +static void pmu_reset(void)
>> +{
>> +    /* reset all counters, counting disabled at PMCR level*/
>> +    set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
>> +    /* Disable all counters */
>> +    write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
>> +    /* clear overflow reg */
>> +    write_sysreg(ALL_SET, pmovsclr_el0);
>> +    /* disable overflow interrupts on all counters */
>> +    write_sysreg(ALL_SET, pmintenclr_el1);
>> +    isb();
>> +}
>> +
>> +static void test_event_counter_config(void)
>> +{
>> +    int i;
>> +
>> +    if (!pmu.nb_implemented_counters) {
>> +        report_skip("No event counter, skip ...");
>> +        return;
>> +    }
>> +
>> +    pmu_reset();
>> +
>> +    /*
>> +     * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
>
> s/PMESELR/PMSELR/ ?
>
>> +     * select counter 0
>> +     */
>> +    write_sysreg(1, PMSELR_EL0);
>> +    /* program this counter to count unsupported event */
>> +    write_sysreg(0xEA, PMXEVTYPER_EL0);
>> +    write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
>> +    report((read_regn_el0(pmevtyper, 1) & 0xFFF) == 0xEA,
>> +        "PMESELR/PMXEVTYPER/PMEVTYPERn");
>
> Ditto
>
>> +    report((read_regn_el0(pmevcntr, 1) == 0xdeadbeef),
>> +        "PMESELR/PMXEVCNTR/PMEVCNTRn");
>
> Ditto
>
>> +
>> +    /* try to configure an unsupported event within the range [0x0,
>> 0x3F] */
>> +    for (i = 0; i <= 0x3F; i++) {
>> +        if (!is_event_supported(i, false))
>> +            break;
>> +    }
>> +    if (i > 0x3F) {
>> +        report_skip("pmevtyper: all events within [0x0, 0x3F] are
>> supported");
>> +        return;
>> +    }
>> +
>> +    /* select counter 0 */
>> +    write_sysreg(0, PMSELR_EL0);
>> +    /* program this counter to count unsupported event */
>
> We get the unsupported event number *i* but don't program it into
> PMXEVTYPER_EL0 (or PMEVTYPER0_EL0). Is it intentional?
>
>> +    write_sysreg(i, PMXEVCNTR_EL0);
>> +    /* read the counter value */
>> +    read_sysreg(PMXEVCNTR_EL0);
>> +    report(read_sysreg(PMXEVCNTR_EL0) == i,
>> +        "read of a counter programmed with unsupported event");
>> +
>> +}
>
> [...]
>
>> +
>> +static void test_mem_access(void)
>> +{
>> +    void *addr = malloc(PAGE_SIZE);
>
> *addr* isn't freed at the end of test_mem_access(). The same in
> test_chain_promotion() and test_overflow_interrupt().
>
> Zenghui
>

