Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407D368DEDD
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBGR0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjBGR0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:26:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6AA14EAE
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675790753;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wr4924T1aLcmvD2PfH582f9c/NgM4LTWRkg4XTQezRc=;
        b=JbbTyhjckoFvLelM6rjJwknYOadtTXn0dFDjmUXj7sM9OPVbH+j7695IIMfPItXkmTItNX
        Bxo/co0ZQeFa1rF62a2T3+kF+XTMUGNy1B49AjqadNRCsgEpVnmFYVWpUVn7clqsKgpGwM
        U718xoEmL8KnkrERQyAVE5BhFSDlWNk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-GOqf7jL0O6eUUsGQdaF6cQ-1; Tue, 07 Feb 2023 12:25:44 -0500
X-MC-Unique: GOqf7jL0O6eUUsGQdaF6cQ-1
Received: by mail-qv1-f71.google.com with SMTP id ly4-20020a0562145c0400b0054d2629a759so8060712qvb.16
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:25:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wr4924T1aLcmvD2PfH582f9c/NgM4LTWRkg4XTQezRc=;
        b=sDclaTV0im4rceVkaYJYIy5OrcWijOzfAoKA89+YH1J4TZaMcdhPtENuwY81MpTz6X
         AsD5f6vXcNp8cHMscmVGwZmy13BDc8YF7xl297zuJsMlez9L0Ntg4YM8l5jAI8fds9eN
         blTFMYyhRaR/dWBEH4xyLtT0BVgcE+Ns3SSOSgFnfe2WWtSLbvMoTox2gL8Rgq73PBKS
         2tCglYHj4dCQYq0zh9FhkKwjOzoXHnp0uhdjYmpU0cUaRbZVxl1qFXKxWJYoTt4gPSjy
         i1pMhDkTuXWRzXvDLqdMoOuc41dEwHYUCQAAV/p8OSRC8IGEtgvuxtN7gm8GKt8NONGx
         QC7g==
X-Gm-Message-State: AO0yUKVrrYV3k3rV1tKJ441cUVYsTiXQX2AL6NTbwuOFY4jZpJYATfxh
        Ig1BWiT2tNal64YHAShLPOKF+qNDnOVih00zrE/vNrXX1jHbTQnkic5ym2ewTtJsJgqtU75fBuX
        ed2NGJ2/7xOKFLc0BGQ==
X-Received: by 2002:ad4:5966:0:b0:56a:d94d:6deb with SMTP id eq6-20020ad45966000000b0056ad94d6debmr5481794qvb.25.1675790743305;
        Tue, 07 Feb 2023 09:25:43 -0800 (PST)
X-Google-Smtp-Source: AK7set/oNUeLb7iYyAiE+0YjHlHKRi9Qky2mq4EAl0GmlqGhLkQr6HJbmAUtCSqyiwtOGLuTZEx/Og==
X-Received: by 2002:ad4:5966:0:b0:56a:d94d:6deb with SMTP id eq6-20020ad45966000000b0056ad94d6debmr5481762qvb.25.1675790742910;
        Tue, 07 Feb 2023 09:25:42 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r30-20020a05620a03de00b0071c2a68d6f2sm9796218qkm.20.2023.02.07.09.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 09:25:42 -0800 (PST)
Message-ID: <7c5b1215-41f7-0475-ad31-8387cd8c3769@redhat.com>
Date:   Tue, 7 Feb 2023 18:25:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 4/6] arm: pmu: Add tests for 64-bit
 overflows
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-5-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230126165351.2561582-5-ricarkol@google.com>
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
> Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
> and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
> supported on PMUv3p5.
>
> Note that chained tests do not implement "overflow_at_64bits == true".
> That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
> details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
> 0487H.a, J1.1.1 "aarch64/debug").
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
Looks good to me

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arm/pmu.c | 100 ++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 67 insertions(+), 33 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 08e956d..082fb41 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -28,6 +28,7 @@
>  #define PMU_PMCR_X         (1 << 4)
>  #define PMU_PMCR_DP        (1 << 5)
>  #define PMU_PMCR_LC        (1 << 6)
> +#define PMU_PMCR_LP        (1 << 7)
>  #define PMU_PMCR_N_SHIFT   11
>  #define PMU_PMCR_N_MASK    0x1f
>  #define PMU_PMCR_ID_SHIFT  16
> @@ -57,8 +58,12 @@
>  #define ALL_SET_32			0x00000000FFFFFFFFULL
>  #define ALL_CLEAR		0x0000000000000000ULL
>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>  
> +#define PRE_OVERFLOW(__overflow_at_64bits)				\
> +	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> +
>  #define PMU_PPI			23
>  
>  struct pmu {
> @@ -448,8 +453,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
>  static void test_basic_event_count(bool overflow_at_64bits)
>  {
>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> -	uint32_t counter_mask;
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> +	uint32_t counter_mask;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>  	    !check_overflow_prerequisites(overflow_at_64bits))
> @@ -471,13 +478,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
>  	 * clear cycle and all event counters and allow counter enablement
>  	 * through PMCNTENSET. LC is RES1.
>  	 */
> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
>  	isb();
> -	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
>  
>  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>  		"counter #0 preset to pre-overflow value");
>  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
>  
> @@ -530,6 +537,8 @@ static void test_mem_access(bool overflow_at_64bits)
>  {
>  	void *addr = malloc(PAGE_SIZE);
>  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>  	    !check_overflow_prerequisites(overflow_at_64bits))
> @@ -541,7 +550,7 @@ static void test_mem_access(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
>  	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
>  	/* We may measure more than 20 mem access depending on the core */
> @@ -551,11 +560,11 @@ static void test_mem_access(bool overflow_at_64bits)
>  
>  	pmu_reset();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report(read_sysreg(pmovsclr_el0) == 0x3,
>  	       "Ran 20 mem accesses with expected overflows on both counters");
>  	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> @@ -565,8 +574,10 @@ static void test_mem_access(bool overflow_at_64bits)
>  
>  static void test_sw_incr(bool overflow_at_64bits)
>  {
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> -	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
> +	uint64_t cntr0 = (pre_overflow + 100) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> @@ -580,7 +591,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -588,14 +599,14 @@ static void test_sw_incr(bool overflow_at_64bits)
>  
>  	isb();
>  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
> +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>  		"PWSYNC does not increment if PMCR.E is unset");
>  
>  	pmu_reset();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -613,6 +624,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  static void test_chained_counters(bool unused)
>  {
>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> +	uint64_t all_set = pmevcntr_mask();
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>  		return;
> @@ -643,11 +655,11 @@ static void test_chained_counters(bool unused)
>  	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> -	write_regn_el0(pmevcntr, 1, ALL_SET_32);
> +	write_regn_el0(pmevcntr, 1, all_set);
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> +	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
>  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
> @@ -855,6 +867,9 @@ static bool expect_interrupts(uint32_t bitmap)
>  
>  static void test_overflow_interrupt(bool overflow_at_64bits)
>  {
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t all_set = pmevcntr_mask();
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
>  	void *addr = malloc(PAGE_SIZE);
>  	int i;
> @@ -873,16 +888,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>  	isb();
>  
>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>  
> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -897,12 +912,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  
>  	pmu_reset_stats();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>  	isb();
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x3, pmswinc_el0);
>  
> @@ -911,25 +926,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	report(expect_interrupts(0x3),
>  		"overflow interrupts expected on #0 and #1");
>  
> -	/* promote to 64-b */
> +	/*
> +	 * promote to 64-b:
> +	 *
> +	 * This only applies to the !overflow_at_64bits case, as
> +	 * overflow_at_64bits doesn't implement CHAIN events. The
> +	 * overflow_at_64bits case just checks that chained counters are
> +	 * not incremented when PMCR.LP == 1.
> +	 */
>  
>  	pmu_reset_stats();
>  
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	isb();
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> -	report(expect_interrupts(0x1),
> -		"expect overflow interrupt on 32b boundary");
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	report(expect_interrupts(0x1), "expect overflow interrupt");
>  
>  	/* overflow on odd counter */
>  	pmu_reset_stats();
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> -	write_regn_el0(pmevcntr, 1, ALL_SET_32);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, all_set);
>  	isb();
> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> -	report(expect_interrupts(0x3),
> -		"expect overflow interrupt on even and odd counter");
> +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	if (overflow_at_64bits) {
> +		report(expect_interrupts(0x1),
> +		       "expect overflow interrupt on even counter");
> +		report(read_regn_el0(pmevcntr, 1) == all_set,
> +		       "Odd counter did not change");
> +	} else {
> +		report(expect_interrupts(0x3),
> +		       "expect overflow interrupt on even and odd counter");
> +		report(read_regn_el0(pmevcntr, 1) != all_set,
> +		       "Odd counter wrapped");
> +	}
>  }
>  #endif
>  
> @@ -1138,10 +1168,13 @@ int main(int argc, char *argv[])
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>  		run_event_test(argv[1], test_basic_event_count, false);
> +		run_event_test(argv[1], test_basic_event_count, true);
>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>  		run_event_test(argv[1], test_mem_access, false);
> +		run_event_test(argv[1], test_mem_access, true);
>  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
>  		run_event_test(argv[1], test_sw_incr, false);
> +		run_event_test(argv[1], test_sw_incr, true);
>  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
>  		run_event_test(argv[1], test_chained_counters, false);
>  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> @@ -1150,6 +1183,7 @@ int main(int argc, char *argv[])
>  		run_event_test(argv[1], test_chain_promotion, false);
>  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
>  		run_event_test(argv[1], test_overflow_interrupt, false);
> +		run_event_test(argv[1], test_overflow_interrupt, true);
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}

