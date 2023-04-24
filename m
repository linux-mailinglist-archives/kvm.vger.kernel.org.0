Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE26ED5EC
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 22:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjDXUKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 16:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjDXUKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 16:10:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F8A7A8D
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682366961;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaqSE7XG48tGeZTh9A4GycMEA8tOnfnEqPR8Mi0e3+Y=;
        b=OJmkvuZNXSyXChi01I9xKgyWmUGH4UMoNJ+B9e8EZsfnOXUdQDsv5VBA4VYv4FHvTHePAy
        8TT8nHn7MFbTx2kcomZzaPrkrYkl1hwOAbvS98a6e9xPhS7yLidhfAxek/GVs9zfy4zctC
        dtqvTaYsncFzE0uA8M1AuKKPHaVPPB8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-nLYtlS3nNY6hySKPWsDSwQ-1; Mon, 24 Apr 2023 16:09:17 -0400
X-MC-Unique: nLYtlS3nNY6hySKPWsDSwQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f2981b8364so2599451f8f.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682366957; x=1684958957;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jaqSE7XG48tGeZTh9A4GycMEA8tOnfnEqPR8Mi0e3+Y=;
        b=hDmbQi7ljrseO3qd5i5RhORNl9TWlIws5rGdk7JI+h8jA/P6a3P31r5sXxQ1x53Gyy
         Kwp0i75cHnUQVwA1e3jcA+TcRWTpu3UNr6aQAXBQQr/BhZda6QN6pppWZs4qNo64eo92
         LZWJ3M5c31E097DfT7C/qG/rlEgTyzy6fuFAQy+j7ApRiLFwZcHpV7wTh5A1aOoKQzz9
         H+m7wivEjXNvsCXekeDY90WcdoiU+dZDn+LAfsLl2KgauNbRAhq4Z9dAlzU4lSSdUcuf
         NyjUSqjLp9X+uf9JraVyKbPJfj95wfRNclFPXnX2XAmLzi5eHlIGCI4tdxwh4NAeGab+
         Muyg==
X-Gm-Message-State: AAQBX9cUO5sJGMr6GZUdnQl/4lpz/34ROo3I6NKMWalnRM0p+LkgtWGP
        dWI7jlea1DcS15tWXgcxpEWWKe1FFRzJGO+cCCQTbFMQP64NEN6KEgYV+bkvF3EsWmsgNiClGcY
        xRU9ZKeiF0gw+
X-Received: by 2002:a5d:6e02:0:b0:2fd:98a8:e800 with SMTP id h2-20020a5d6e02000000b002fd98a8e800mr10456628wrz.7.1682366956787;
        Mon, 24 Apr 2023 13:09:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350b8PHP69xqyyY1DFRDqw5J7nCTjWgiwzlJv176XIAN5iUfI2BvRjPGgCTBQAnXiP6y1j6cByA==
X-Received: by 2002:a5d:6e02:0:b0:2fd:98a8:e800 with SMTP id h2-20020a5d6e02000000b002fd98a8e800mr10456615wrz.7.1682366956468;
        Mon, 24 Apr 2023 13:09:16 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id iz14-20020a05600c554e00b003f175954e71sm16410424wmb.32.2023.04.24.13.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 13:09:15 -0700 (PDT)
Message-ID: <745cd61a-4dbd-4e1b-630c-2f21eec7b005@redhat.com>
Date:   Mon, 24 Apr 2023 22:09:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/6] arm: pmu: pmu-chain-promotion: Improve
 debug messages
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-2-eric.auger@redhat.com>
 <ZEJWhPtA2xaaqV54@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZEJWhPtA2xaaqV54@monolith.localdoman>
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

On 4/21/23 11:25, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Mar 15, 2023 at 12:07:20PM +0100, Eric Auger wrote:
>> The pmu-chain-promotion test is composed of several subtests.
>> In case of failures, the current logs are really dificult to
>> analyze since they look very similar and sometimes duplicated
>> for each subtest. Add prefixes for each subtest and introduce
>> a macro that prints the registers we are mostly interested in,
>> namerly the 2 first counters and the overflow counter.
> One possible typo below.
renamed 2d into 2nd as suggested.
>
> Ran pmu-chain-promotion with and without this patch applied, the
> improvement is very noticeable, it makes it very easy to match the debug
> message with the subtest being run:
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

Eric
>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/pmu.c | 63 ++++++++++++++++++++++++++++---------------------------
>>  1 file changed, 32 insertions(+), 31 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index f6e95012..dad7d4b4 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -715,6 +715,11 @@ static void test_chained_sw_incr(bool unused)
>>  	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
>>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>>  }
>> +#define PRINT_REGS(__s) \
>> +	report_info("%s #1=0x%lx #0=0x%lx overflow=0x%lx", __s, \
>> +		    read_regn_el0(pmevcntr, 1), \
>> +		    read_regn_el0(pmevcntr, 0), \
>> +		    read_sysreg(pmovsclr_el0))
>>  
>>  static void test_chain_promotion(bool unused)
>>  {
>> @@ -725,6 +730,7 @@ static void test_chain_promotion(bool unused)
>>  		return;
>>  
>>  	/* Only enable CHAIN counter */
>> +	report_prefix_push("subtest1");
>>  	pmu_reset();
>>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>> @@ -732,83 +738,81 @@ static void test_chain_promotion(bool unused)
>>  	isb();
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	PRINT_REGS("post");
>>  	report(!read_regn_el0(pmevcntr, 0),
>>  		"chain counter not counting if even counter is disabled");
>> +	report_prefix_pop();
>>  
>>  	/* Only enable even counter */
>> +	report_prefix_push("subtest2");
>>  	pmu_reset();
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>>  	isb();
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	PRINT_REGS("post");
>>  	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
>>  		"odd counter did not increment on overflow if disabled");
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> -	report_info("CHAIN counter #1 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 1));
>> -	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
>> +	report_prefix_pop();
>>  
>>  	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
>> +	report_prefix_push("subtest3");
>>  	pmu_reset();
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>>  	isb();
>> +	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> +	PRINT_REGS("After 1st loop");
>>  
>>  	/* disable the CHAIN event */
>>  	write_sysreg_s(0x2, PMCNTENCLR_EL0);
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> +	PRINT_REGS("After 2d loop");
> Hmm.. was that supposed to be "after 2**n**d loop" (matches the "after 1st
> loop" message)? A few more instances below.
>
> Thanks,
> Alex
>
>>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>>  		"should have triggered an overflow on #0");
>>  	report(!read_regn_el0(pmevcntr, 1),
>>  		"CHAIN counter #1 shouldn't have incremented");
>> +	report_prefix_pop();
>>  
>>  	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
>>  
>> +	report_prefix_push("subtest4");
>>  	pmu_reset();
>>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>>  	isb();
>> -	report_info("counter #0 = 0x%lx, counter #1 = 0x%lx overflow=0x%lx",
>> -		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
>> -		    read_sysreg(pmovsclr_el0));
>> +	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> +	PRINT_REGS("After 1st loop");
>>  
>>  	/* enable the CHAIN event */
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	isb();
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> +
>> +	PRINT_REGS("After 2d loop");
>>  
>>  	report((read_regn_el0(pmevcntr, 1) == 1) &&
>>  		(read_sysreg(pmovsclr_el0) == 0x1),
>>  		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
>> -
>> -	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
>> -		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
>> +	report_prefix_pop();
>>  
>>  	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
>> +	report_prefix_push("subtest5");
>>  	pmu_reset();
>>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>>  	isb();
>> +	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> +	PRINT_REGS("After 1st loop");
>>  
>>  	/* 0 becomes CHAINED */
>>  	write_sysreg_s(0x0, PMCNTENSET_EL0);
>> @@ -817,37 +821,34 @@ static void test_chain_promotion(bool unused)
>>  	write_regn_el0(pmevcntr, 1, 0x0);
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>> -		    read_regn_el0(pmevcntr, 0));
>> +	PRINT_REGS("After 2d loop");
>>  
>>  	report((read_regn_el0(pmevcntr, 1) == 1) &&
>>  		(read_sysreg(pmovsclr_el0) == 0x1),
>>  		"32b->64b: CHAIN counter incremented and overflow");
>> -
>> -	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
>> -		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
>> +	report_prefix_pop();
>>  
>>  	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
>> +	report_prefix_push("subtest6");
>>  	pmu_reset();
>>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>> +	PRINT_REGS("init");
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> -	report_info("counter #0=0x%lx, counter #1=0x%lx",
>> -			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>> +	PRINT_REGS("After 1st loop");
>>  
>>  	write_sysreg_s(0x0, PMCNTENSET_EL0);
>>  	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
>>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>>  
>>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>> +	PRINT_REGS("After 2d loop");
>>  	report(read_sysreg(pmovsclr_el0) == 1,
>>  		"overflow is expected on counter 0");
>> -	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
>> -			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
>> -			read_sysreg(pmovsclr_el0));
>> +	report_prefix_pop();
>>  }
>>  
>>  static bool expect_interrupts(uint32_t bitmap)
>> -- 
>> 2.38.1
>>

