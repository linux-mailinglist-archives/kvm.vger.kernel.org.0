Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109A368DD44
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjBGPqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjBGPqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:46:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFC03A5A9
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675784759;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJfeQWowoNTHHyi6pKV2kY7wFhtNY5CB+H2FkVG4GJs=;
        b=YF/OmtJ/bTgA5mBSrZf037HzT+sK5FkHkyrdL/SBpd0LD9enqQ9EJ4eNtOz3BQjpn/Xhzm
        H3e9UMO5xpFwVUhZwxCq4Ta6r6TMkRxhixqhbJTbWAqwYplb0e179EgiHfYLabZ048v+df
        d9lVfS0w3Nm70P7B2zQ1KARQfkSIgAM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-464-f9qyTn1aNOuA6IVa-7v0JQ-1; Tue, 07 Feb 2023 10:45:56 -0500
X-MC-Unique: f9qyTn1aNOuA6IVa-7v0JQ-1
Received: by mail-qk1-f197.google.com with SMTP id u10-20020a05620a0c4a00b00705e77d6207so9907431qki.5
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 07:45:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GJfeQWowoNTHHyi6pKV2kY7wFhtNY5CB+H2FkVG4GJs=;
        b=FBtz/JiLSDmpFlJPxJC2gSfpwzsNZoP9lVwK/qoizXKScDMTN3IVW/lDYSnxATS4h/
         ZSTMnCmU1pHIGRSteh3emkqVLdDnEHtZIjMOJLc7oZlGZYgf22xurA5lQyd3J7MbDidk
         LgybuQMQt8yUIsrzpE82/oVPD7hJIoygMCSanDYb4j4W28Mqmy3sSRR86vDvKmkCcNqa
         EG2Ra32O4IzPzjVirqoGuBbU0Ov2nCDHYD1Tb34OuH+Gxd5fB89vjP/1Mp+ElLGtmIOJ
         ZXBRq+TNjE8VoAbjE384E24vc1kPIxiuHgC13v5Ld0qdNz6/22nv53ZBqoQlc+6xWrnj
         4R7g==
X-Gm-Message-State: AO0yUKUq3H3aUboHwcfbd3sZxqVcyc4R/xS8kn6/xLYOTdQsAAyJDX1I
        8JZ1rwkRG7QmIqxv0BeQ99CVaidW+fq8CG55o42o3VBJNvrnweDygQklbtC6IDzakaEtECHSi+d
        /RC/Z/b4AWJkv
X-Received: by 2002:ac8:4e96:0:b0:3b6:38cf:1277 with SMTP id 22-20020ac84e96000000b003b638cf1277mr4879012qtp.64.1675784755809;
        Tue, 07 Feb 2023 07:45:55 -0800 (PST)
X-Google-Smtp-Source: AK7set9Ge3K7xXBwU+Sq3Q7a4Kd9jW1ZNPN0e0DKM364KWX7jmUBQJOerh3LAwBAlYzl5qnTVULI0Q==
X-Received: by 2002:ac8:4e96:0:b0:3b6:38cf:1277 with SMTP id 22-20020ac84e96000000b003b638cf1277mr4878978qtp.64.1675784755463;
        Tue, 07 Feb 2023 07:45:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id fv22-20020a05622a4a1600b003b646123691sm9700008qtb.31.2023.02.07.07.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:45:54 -0800 (PST)
Message-ID: <e119c970-8c3f-5d24-08a0-9dfb44fe4679@redhat.com>
Date:   Tue, 7 Feb 2023 16:45:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 2/6] arm: pmu: Prepare for testing
 64-bit overflows
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-3-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230126165351.2561582-3-ricarkol@google.com>
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

Hi Ricardo,

On 1/26/23 17:53, Ricardo Koller wrote:
> PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
> instead of 32. Prepare by doing these 3 things:
>
> 1. Add a "bool overflow_at_64bits" argument to all tests checking
>    overflows.
Actually test_chained_sw_incr() and test_chained_counters() also test
overflows but they feature CHAIN events. I guess that's why you don't
need the LP flag. Just tweek the commit msg if you need to respin.
> 2. Extend satisfy_prerequisites() to check if the machine supports
>    "overflow_at_64bits".
> 3. Refactor the test invocations to use the new "run_test()" which adds a
>    report prefix indicating whether the test uses 64 or 32-bit overflows.
>
> A subsequent commit will actually add the 64-bit overflow tests.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arm/pmu.c | 99 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 60 insertions(+), 39 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 7f0794d..06cbd73 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -164,13 +164,13 @@ static void pmu_reset(void)
>  /* event counter tests only implemented for aarch64 */
>  static void test_event_introspection(void) {}
>  static void test_event_counter_config(void) {}
> -static void test_basic_event_count(void) {}
> -static void test_mem_access(void) {}
> -static void test_sw_incr(void) {}
> -static void test_chained_counters(void) {}
> -static void test_chained_sw_incr(void) {}
> -static void test_chain_promotion(void) {}
> -static void test_overflow_interrupt(void) {}
> +static void test_basic_event_count(bool overflow_at_64bits) {}
> +static void test_mem_access(bool overflow_at_64bits) {}
> +static void test_sw_incr(bool overflow_at_64bits) {}
> +static void test_chained_counters(bool unused) {}
> +static void test_chained_sw_incr(bool unused) {}
> +static void test_chain_promotion(bool unused) {}
> +static void test_overflow_interrupt(bool overflow_at_64bits) {}
>  
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
> @@ -435,13 +435,24 @@ static uint64_t pmevcntr_mask(void)
>  	return (uint32_t)~0;
>  }
>  
> -static void test_basic_event_count(void)
> +static bool check_overflow_prerequisites(bool overflow_at_64bits)
> +{
> +	if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
> +		report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void test_basic_event_count(bool overflow_at_64bits)
>  {
>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
>  	uint32_t counter_mask;
>  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
> @@ -515,12 +526,13 @@ static void test_basic_event_count(void)
>  		"check overflow happened on #0 only");
>  }
>  
> -static void test_mem_access(void)
> +static void test_mem_access(bool overflow_at_64bits)
>  {
>  	void *addr = malloc(PAGE_SIZE);
>  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	pmu_reset();
> @@ -551,13 +563,14 @@ static void test_mem_access(void)
>  			read_sysreg(pmovsclr_el0));
>  }
>  
> -static void test_sw_incr(void)
> +static void test_sw_incr(bool overflow_at_64bits)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
>  	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>  	int i;
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	pmu_reset();
> @@ -597,7 +610,7 @@ static void test_sw_incr(void)
>  		"overflow on counter #0 after 100 SW_INCR");
>  }
>  
> -static void test_chained_counters(void)
> +static void test_chained_counters(bool unused)
>  {
>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
>  
> @@ -638,7 +651,7 @@ static void test_chained_counters(void)
>  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
> -static void test_chained_sw_incr(void)
> +static void test_chained_sw_incr(bool unused)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
>  	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> @@ -691,7 +704,7 @@ static void test_chained_sw_incr(void)
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
>  
> -static void test_chain_promotion(void)
> +static void test_chain_promotion(bool unused)
>  {
>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
>  	void *addr = malloc(PAGE_SIZE);
> @@ -840,13 +853,14 @@ static bool expect_interrupts(uint32_t bitmap)
>  	return true;
>  }
>  
> -static void test_overflow_interrupt(void)
> +static void test_overflow_interrupt(bool overflow_at_64bits)
>  {
>  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
>  	void *addr = malloc(PAGE_SIZE);
>  	int i;
>  
> -	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
>  		return;
>  
>  	gic_enable_defaults();
> @@ -1070,6 +1084,27 @@ static bool pmu_probe(void)
>  	return true;
>  }
>  
> +static void run_test(const char *name, const char *prefix,
> +		     void (*test)(bool), void *arg)
> +{
> +	report_prefix_push(name);
> +	report_prefix_push(prefix);
> +
> +	test(arg);
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
> +}
> +
> +static void run_event_test(char *name, void (*test)(bool),
> +			   bool overflow_at_64bits)
> +{
> +	const char *prefix = overflow_at_64bits ? "64-bit overflows"
> +						: "32-bit overflows";
> +
> +	run_test(name, prefix, test, (void *)overflow_at_64bits);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int cpi = 0;
> @@ -1102,33 +1137,19 @@ int main(int argc, char *argv[])
>  		test_event_counter_config();
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_basic_event_count();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_basic_event_count, false);
>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_mem_access();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_mem_access, false);
>  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_sw_incr();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_sw_incr, false);
>  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_chained_counters();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_chained_counters, false);
>  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_chained_sw_incr();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_chained_sw_incr, false);
>  	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_chain_promotion();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_chain_promotion, false);
>  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> -		report_prefix_push(argv[1]);
> -		test_overflow_interrupt();
> -		report_prefix_pop();
> +		run_event_test(argv[1], test_overflow_interrupt, false);
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}

