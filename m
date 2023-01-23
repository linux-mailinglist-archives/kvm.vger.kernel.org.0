Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA931678760
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjAWURk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjAWURk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD47C30297
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674505015;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3+junlULVMF75LbBg2MY53y+N+veB8zNDWGNo4VFkw=;
        b=er9cP6v72VQ7BIJqMSiTx0n1W84gWVmoCyRIXNdDh5JwDGLEUL7HadntYWVBVjbTdGJNvo
        eck+r02/5UDacFo1VwhO8fSQD3JEGNccGGJcXUhH43I7nXNHJDd7zsbNItCv4JS5VM0VfN
        LWo5xHmwR4cifPrLqTeoc3IFDNJHdJs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-UTUCLVUOOvOlz99htcZjmA-1; Mon, 23 Jan 2023 15:16:54 -0500
X-MC-Unique: UTUCLVUOOvOlz99htcZjmA-1
Received: by mail-qt1-f197.google.com with SMTP id j15-20020ac8440f000000b003b6951707e9so4142733qtn.18
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:16:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3+junlULVMF75LbBg2MY53y+N+veB8zNDWGNo4VFkw=;
        b=MvznDPF/ywZX9i1FLKajg5Fp1Xs2N1CYOKiB/2dS1edy9YiynwLibLzzoepUi59GsR
         ZpoMaglFOAct3F4OsKPBI12vK+RooE4JDnBqpQ0+ho0wqHDxmTuCr15gowlgVByL/lge
         3hicXj1eh757o7cRu2kcrO5MtrGIuS8/RBagYQwStVbA7ECaC+sBZrkgAM792a7RKUIN
         lU0Huqby7XncwWR1nJer42gdCpW2lIVN6hCwCXMwne+Xo3daolQVfDlZCwoVThrjENRR
         abhMvsAmcseDoLjMJSxc6vsgcw8lvfJG6sGo1TBwNQKKXx3QSM89ytfvw7EZr9Ihafog
         sqCg==
X-Gm-Message-State: AFqh2krQmd9tPNFKLjGzdlbRlIy5pZiEuxNaQw41mbO2TUWKyLtdFTki
        OlWwMclg5I1AjW0dipBZw0FFgVJvj2QYjUipiLN4JpQY8hQrI+rqKGl9jNXsdBE/z/WxNEca2+1
        NPCJaDkoQw3lR
X-Received: by 2002:a05:622a:4209:b0:3b5:4aae:cb0b with SMTP id cp9-20020a05622a420900b003b54aaecb0bmr35735722qtb.22.1674505014033;
        Mon, 23 Jan 2023 12:16:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtZemXz++AKrwgeusa+BGaOwsCkHjVNtIxK/mnyMB/tGaIQ2uX5/GraXmIFnA5tIAnit1XFqQ==
X-Received: by 2002:a05:622a:4209:b0:3b5:4aae:cb0b with SMTP id cp9-20020a05622a420900b003b54aaecb0bmr35735700qtb.22.1674505013726;
        Mon, 23 Jan 2023 12:16:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h3-20020ac87143000000b003a6a19ee4f0sm9192819qtp.33.2023.01.23.12.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:16:53 -0800 (PST)
Message-ID: <13f3ef62-a399-eb04-2389-f25881d3eb1a@redhat.com>
Date:   Mon, 23 Jan 2023 21:16:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-2-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230109211754.67144-2-ricarkol@google.com>
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

On 1/9/23 22:17, Ricardo Koller wrote:
> PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> for overflowing at 32 or 64-bits. The consequence is that tests that check
> the counter values after overflowing should not assume that values will be
> wrapped around 32-bits: they overflow into the other half of the 64-bit
> counters on PMUv3p5.
>
> Fix tests by correctly checking overflowing-counters against the expected
> 64-bit value.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arm/pmu.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index cd47b14..7f0794d 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -54,10 +54,10 @@
>  #define EXT_COMMON_EVENTS_LOW	0x4000
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
> -#define ALL_SET			0xFFFFFFFF
> -#define ALL_CLEAR		0x0
> -#define PRE_OVERFLOW		0xFFFFFFF0
> -#define PRE_OVERFLOW2		0xFFFFFFDC
> +#define ALL_SET			0x00000000FFFFFFFFULL
> +#define ALL_CLEAR		0x0000000000000000ULL
> +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>  
>  #define PMU_PPI			23
>  
> @@ -419,6 +419,22 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
>  	return true;
>  }
>  
> +static uint64_t pmevcntr_mask(void)
> +{
> +	/*
> +	 * Bits [63:0] are always incremented for 64-bit counters,
> +	 * even if the PMU is configured to generate an overflow at
> +	 * bits [31:0]
> +	 *
> +	 * For more details see the AArch64.IncrementEventCounter()
> +	 * pseudo-code in the ARM ARM DDI 0487I.a, section J1.1.1.
> +	 */
> +	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
> +		return ~0;
> +
> +	return (uint32_t)~0;
> +}
> +
>  static void test_basic_event_count(void)
>  {
>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> @@ -538,6 +554,7 @@ static void test_mem_access(void)
>  static void test_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> +	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -572,9 +589,8 @@ static void test_sw_incr(void)
>  		write_sysreg(0x3, pmswinc_el0);
>  
>  	isb();
> -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> -	report(read_regn_el0(pmevcntr, 1)  == 100,
> -		"counter #0 after + 100 SW_INCR");
> +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
>  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
> @@ -625,6 +641,8 @@ static void test_chained_counters(void)
>  static void test_chained_sw_incr(void)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
> +	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> @@ -666,9 +684,9 @@ static void test_chained_sw_incr(void)
>  
>  	isb();
>  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> -		(read_regn_el0(pmevcntr, 1) == 0) &&
> -		(read_regn_el0(pmevcntr, 0) == 84),
> -		"expected overflows and values after 100 SW_INCR/CHAIN");
> +	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
> +	       (read_regn_el0(pmevcntr, 1) == cntr1),
> +	       "expected overflows and values after 100 SW_INCR/CHAIN");
>  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }

