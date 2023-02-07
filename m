Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5822F68DD51
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjBGPty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjBGPtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:49:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D575FEF
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 07:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675784946;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZD2lt8E8kUcveEL/JwYuZpmIFmcz1MkWw0PV+9rbNqU=;
        b=Y4l0cq6LRUGRxbyHyetEm2e4i7PaomczzhaJ39sAVv/9M8Jps4IfZMY9Y5o/B21z5IiAoF
        giF2Dd+5DXIRr63SBqdgPg0z3Vi3NcVdFk7g9ptBHFSPrIqqT03K5EFSuuLiKcv8XfTUAr
        AghPhd2J2RMhG+olwYF/CTo6fwsRwSs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-Vf25YmfgOB-axj4BIYVlxw-1; Tue, 07 Feb 2023 10:49:05 -0500
X-MC-Unique: Vf25YmfgOB-axj4BIYVlxw-1
Received: by mail-qt1-f200.google.com with SMTP id t5-20020a05622a180500b003b9c03cd525so8879453qtc.20
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 07:49:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZD2lt8E8kUcveEL/JwYuZpmIFmcz1MkWw0PV+9rbNqU=;
        b=FEJ4JjTtlsrDfjPSYmz63AI5oDIyrlGTijA6paG9Eiv8lxPbvkQwuC7dT9Xde829FQ
         5rjK+HwgJ2Pfs8zoo/Mw7IbCWkerLZJXZalF/OZ8tf/pZi4tWlLiGBq/X1l5mfJ6YenQ
         yQT3OeUU47m1OPDaH72phUiFSdw5fw7TNCtohdZnXXdjmofN5gH/b9wxO8utx6mEGZ64
         LO6fNlfjT2gx1YMWp99opnCXeeLtZaxT5rwLhoTZtO/Sb3j2NwEL27i0surEOb9qNgnr
         AkRn6t5f7l2M9+hGO643FAwAvTyYGu7vGpecS14c/OUKi8N7j/szaNk+DoIxOC8aeeFY
         8PXQ==
X-Gm-Message-State: AO0yUKXwgrCxj7YO4xHvcJpUKQ86KSU9EZLUgAXdN089zl1yNEDzVFS+
        Sc7DFWDJTX6RyIl6XdZ0bbh/P6qeZ3PuVtKW5GnO9DOT0oANxsCf/65jOlpPY6mqHu3XZpkuuS4
        L5Ou0fxpkgmSfHYb8yQ==
X-Received: by 2002:a05:6214:ca8:b0:56b:ec14:e2ad with SMTP id s8-20020a0562140ca800b0056bec14e2admr6348118qvs.28.1675784944310;
        Tue, 07 Feb 2023 07:49:04 -0800 (PST)
X-Google-Smtp-Source: AK7set8lU/87XJIUEPgSXD/HoFqa57/4aQofLv8njL4GpD1IqnnGcTDM5dib/Lq7ggYfj25PPqSbjw==
X-Received: by 2002:a05:6214:ca8:b0:56b:ec14:e2ad with SMTP id s8-20020a0562140ca800b0056bec14e2admr6348067qvs.28.1675784943959;
        Tue, 07 Feb 2023 07:49:03 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 67-20020a370846000000b0073185aef96csm6362455qki.51.2023.02.07.07.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:49:03 -0800 (PST)
Message-ID: <ea888a30-9247-de34-9f8e-9cc1702fa021@redhat.com>
Date:   Tue, 7 Feb 2023 16:48:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 3/6] arm: pmu: Rename ALL_SET and
 PRE_OVERFLOW
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20230126165351.2561582-1-ricarkol@google.com>
 <20230126165351.2561582-4-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230126165351.2561582-4-ricarkol@google.com>
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

Hi Rocardo,

On 1/26/23 17:53, Ricardo Koller wrote:
> Given that the arm PMU tests now handle 64-bit counters and overflows,
> it's better to be precise about what the ALL_SET and PRE_OVERFLOW
> macros actually are. Given that they are both 32-bit counters,
> just add _32 to both of them.
nit: wouldn't have hurt to rename OVERFLOW2 too even if it is only used
in tests using chain events.

Besides:
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 78 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 39 insertions(+), 39 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 06cbd73..08e956d 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -54,9 +54,9 @@
>  #define EXT_COMMON_EVENTS_LOW	0x4000
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
> -#define ALL_SET			0x00000000FFFFFFFFULL
> +#define ALL_SET_32			0x00000000FFFFFFFFULL
>  #define ALL_CLEAR		0x0000000000000000ULL
> -#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>  
>  #define PMU_PPI			23
> @@ -153,11 +153,11 @@ static void pmu_reset(void)
>  	/* reset all counters, counting disabled at PMCR level*/
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
>  	/* Disable all counters */
> -	write_sysreg(ALL_SET, PMCNTENCLR);
> +	write_sysreg(ALL_SET_32, PMCNTENCLR);
>  	/* clear overflow reg */
> -	write_sysreg(ALL_SET, PMOVSR);
> +	write_sysreg(ALL_SET_32, PMOVSR);
>  	/* disable overflow interrupts on all counters */
> -	write_sysreg(ALL_SET, PMINTENCLR);
> +	write_sysreg(ALL_SET_32, PMINTENCLR);
>  	isb();
>  }
>  
> @@ -322,7 +322,7 @@ static void irq_handler(struct pt_regs *regs)
>  				pmu_stats.bitmap |= 1 << i;
>  			}
>  		}
> -		write_sysreg(ALL_SET, pmovsclr_el0);
> +		write_sysreg(ALL_SET_32, pmovsclr_el0);
>  		isb();
>  	} else {
>  		pmu_stats.unexpected = true;
> @@ -346,11 +346,11 @@ static void pmu_reset(void)
>  	/* reset all counters, counting disabled at PMCR level*/
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
>  	/* Disable all counters */
> -	write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
> +	write_sysreg_s(ALL_SET_32, PMCNTENCLR_EL0);
>  	/* clear overflow reg */
> -	write_sysreg(ALL_SET, pmovsclr_el0);
> +	write_sysreg(ALL_SET_32, pmovsclr_el0);
>  	/* disable overflow interrupts on all counters */
> -	write_sysreg(ALL_SET, pmintenclr_el1);
> +	write_sysreg(ALL_SET_32, pmintenclr_el1);
>  	pmu_reset_stats();
>  	isb();
>  }
> @@ -463,7 +463,7 @@ static void test_basic_event_count(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 1, INST_RETIRED | PMEVTYPER_EXCLUDE_EL0);
>  
>  	/* disable all counters */
> -	write_sysreg_s(ALL_SET, PMCNTENCLR_EL0);
> +	write_sysreg_s(ALL_SET_32, PMCNTENCLR_EL0);
>  	report(!read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0),
>  		"pmcntenclr: disable all counters");
>  
> @@ -476,8 +476,8 @@ static void test_basic_event_count(bool overflow_at_64bits)
>  	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
>  
>  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
>  		"counter #0 preset to pre-overflow value");
>  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
>  
> @@ -499,11 +499,11 @@ static void test_basic_event_count(bool overflow_at_64bits)
>  		"pmcntenset: just enabled #0 and #1");
>  
>  	/* clear overflow register */
> -	write_sysreg(ALL_SET, pmovsclr_el0);
> +	write_sysreg(ALL_SET_32, pmovsclr_el0);
>  	report(!read_sysreg(pmovsclr_el0), "check overflow reg is 0");
>  
>  	/* disable overflow interrupts on all counters*/
> -	write_sysreg(ALL_SET, pmintenclr_el1);
> +	write_sysreg(ALL_SET_32, pmintenclr_el1);
>  	report(!read_sysreg(pmintenclr_el1),
>  		"pmintenclr_el1=0, all interrupts disabled");
>  
> @@ -551,8 +551,8 @@ static void test_mem_access(bool overflow_at_64bits)
>  
>  	pmu_reset();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> @@ -566,7 +566,7 @@ static void test_mem_access(bool overflow_at_64bits)
>  static void test_sw_incr(bool overflow_at_64bits)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> @@ -580,7 +580,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -588,12 +588,12 @@ static void test_sw_incr(bool overflow_at_64bits)
>  
>  	isb();
>  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW_32,
>  		"PWSYNC does not increment if PMCR.E is unset");
>  
>  	pmu_reset();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>  	isb();
> @@ -623,7 +623,7 @@ static void test_chained_counters(bool unused)
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  
> @@ -635,15 +635,15 @@ static void test_chained_counters(bool unused)
>  	pmu_reset();
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_regn_el0(pmevcntr, 1, 0x1);
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
>  	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, ALL_SET);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, ALL_SET_32);
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> @@ -654,8 +654,8 @@ static void test_chained_counters(bool unused)
>  static void test_chained_sw_incr(bool unused)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
> -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> -	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
> +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
> +	uint64_t cntr1 = (ALL_SET_32 + 1) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -668,7 +668,7 @@ static void test_chained_sw_incr(bool unused)
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>  	isb();
>  
> @@ -686,8 +686,8 @@ static void test_chained_sw_incr(bool unused)
>  	pmu_reset();
>  
>  	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, ALL_SET);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, ALL_SET_32);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>  	isb();
> @@ -725,7 +725,7 @@ static void test_chain_promotion(bool unused)
>  
>  	/* Only enable even counter */
>  	pmu_reset();
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>  	isb();
>  
> @@ -873,8 +873,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
>  	isb();
>  
>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> @@ -893,13 +893,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	isb();
>  	report(expect_interrupts(0), "no overflow interrupt after counting");
>  
> -	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
> +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET_32) */
>  
>  	pmu_reset_stats();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> -	write_sysreg(ALL_SET, pmintenset_el1);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW_32);
> +	write_sysreg(ALL_SET_32, pmintenset_el1);
>  	isb();
>  
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> @@ -916,7 +916,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	pmu_reset_stats();
>  
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	isb();
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
>  	report(expect_interrupts(0x1),
> @@ -924,8 +924,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  
>  	/* overflow on odd counter */
>  	pmu_reset_stats();
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, ALL_SET);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, ALL_SET_32);
>  	isb();
>  	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
>  	report(expect_interrupts(0x3),

