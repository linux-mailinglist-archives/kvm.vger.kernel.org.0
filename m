Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A4758A065
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 20:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiHDSV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 14:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiHDSV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 14:21:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFB0D29CA3
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659637313;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RL0li+3DlwGsUGlAbLZI7XCE66BlkCgU5p7dciU473A=;
        b=avOLJqbln/W961gTdMjfprf3g/1eEOFnSuJoi0Y5ZLtpVwH/rjc/nqB2+zZR+ClMydm/83
        tbjfzQKzH4/YlyclNpNBKEwlnHv5V+qax06W7sASjwuAhuyWfJrWOo/Fff3r67l2Gjdtoi
        qxqRtjFkw3VcpSeS9KkFQcv9utgATG0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-lNt0be85OCGccdsXoul9VQ-1; Thu, 04 Aug 2022 14:21:52 -0400
X-MC-Unique: lNt0be85OCGccdsXoul9VQ-1
Received: by mail-wm1-f69.google.com with SMTP id r188-20020a1c44c5000000b003a4ef3d710aso2192413wma.2
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 11:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=RL0li+3DlwGsUGlAbLZI7XCE66BlkCgU5p7dciU473A=;
        b=Bmf3KwE61n8vLiFM7AuPjd0jqtYkGaKfgDd00tCFvTFHvj6Nn9mtcPtFvtS9qK2udx
         8ug/+ByIRTmwlrABcY351JqtwZkDe3NH33L0qD/WOMnGlL6HmMOllBvoMd63GfMtImgi
         JxSVMUp88xqw3cVRjWQFCGbhSUSDUAJMFTjc/nN+P//QlnGqmC8XWQhs9f/U1Pbb/OzA
         Vg7uu+FusvxO3oYG3W+jKpXkfn12lGuIeDkGh5vAwSAEyrjQInUkQuP9jAe98y8zAlvx
         8vUd4q55CHLU9QDy4+iz3YmxFxyEDaLDA0AX+Bqh8B7Bag11K/IPdY6ICyGZTQVbqRVo
         TcCg==
X-Gm-Message-State: ACgBeo1PhK3D66QhbpZ++qLcytWl4voMzP51xPtJIV3Cmsxpt5pzWcxX
        Mfb09v8BV9yGiV6xraTKOxmWRBnXGF++lhcUIyAFDWu1TrInpl3M7T3TZfTVrQGSIOzOSSUI8zP
        rdiblC0XrrsRQ
X-Received: by 2002:a5d:4b03:0:b0:220:6b87:8f0f with SMTP id v3-20020a5d4b03000000b002206b878f0fmr2220949wrq.534.1659637311468;
        Thu, 04 Aug 2022 11:21:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5vN/LX5v7lg0478SI5XNYQ30Tia4nMGFDOj5EMJDxI4B5uBBJFv5O9GMu8ObPq/xCct/miNg==
X-Received: by 2002:a5d:4b03:0:b0:220:6b87:8f0f with SMTP id v3-20020a5d4b03000000b002206b878f0fmr2220936wrq.534.1659637311195;
        Thu, 04 Aug 2022 11:21:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l19-20020a05600c1d1300b003a326b84340sm6873196wms.44.2022.08.04.11.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 11:21:50 -0700 (PDT)
Message-ID: <289609de-ca61-2257-caf0-daedaf6c9bc3@redhat.com>
Date:   Thu, 4 Aug 2022 20:21:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] arm: pmu: Check for overflow in the
 low counter in chained counters tests
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-4-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220803182328.2438598-4-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 8/3/22 20:23, Ricardo Koller wrote:
> A chained event overflowing on the low counter can set the overflow flag
> in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> overflow.
>
> The pmu chain tests fail on bare metal when checking the overflow flag
> of the low counter _not_ being set on overflow.  Fix by checking for
> overflow. Note that this test fails in KVM without the respective fix.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 7c5bc259..258780f4 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -583,7 +583,7 @@ static void test_chained_counters(void)
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  
>  	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
> -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
> +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
>  
>  	/* test 64b overflow */
>  
> @@ -595,7 +595,7 @@ static void test_chained_counters(void)
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
> +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>  	write_regn_el0(pmevcntr, 1, ALL_SET);
> @@ -603,7 +603,7 @@ static void test_chained_counters(void)
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> -	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
> +	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
>  static void test_chained_sw_incr(void)
> @@ -629,8 +629,9 @@ static void test_chained_sw_incr(void)
>  		write_sysreg(0x1, pmswinc_el0);
>  
>  	isb();
> -	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
> -		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> +	report((read_sysreg(pmovsclr_el0) == 0x1) &&
> +		(read_regn_el0(pmevcntr, 1) == 1),
> +		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
>  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  
> @@ -648,10 +649,10 @@ static void test_chained_sw_incr(void)
>  		write_sysreg(0x1, pmswinc_el0);
>  
>  	isb();
> -	report((read_sysreg(pmovsclr_el0) == 0x2) &&
> +	report((read_sysreg(pmovsclr_el0) == 0x3) &&
>  		(read_regn_el0(pmevcntr, 1) == 0) &&
>  		(read_regn_el0(pmevcntr, 0) == 84),
> -		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
> +		"overflow on even and odd counters,  and expected values after 100 SW_INCR/CHAIN");
>  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
> @@ -731,8 +732,9 @@ static void test_chain_promotion(void)
>  	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>  		    read_regn_el0(pmevcntr, 0));
>  
> -	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> -		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
> +	report((read_regn_el0(pmevcntr, 1) == 1) &&
> +		(read_sysreg(pmovsclr_el0) == 0x1),
> +		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
>  
>  	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
>  		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> @@ -759,8 +761,9 @@ static void test_chain_promotion(void)
>  	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>  		    read_regn_el0(pmevcntr, 0));
>  
> -	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> -		"32b->64b: CHAIN counter incremented and no overflow");
> +	report((read_regn_el0(pmevcntr, 1) == 1) &&
> +		(read_sysreg(pmovsclr_el0) == 0x1),
> +		"32b->64b: CHAIN counter incremented and overflow");
>  
>  	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
>  		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> @@ -867,8 +870,8 @@ static void test_overflow_interrupt(void)
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>  	isb();
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> -	report(expect_interrupts(0),
> -		"no overflow interrupt expected on 32b boundary");
> +	report(expect_interrupts(0x1),
> +		"expect overflow interrupt on 32b boundary");
>  
>  	/* overflow on odd counter */
>  	pmu_reset_stats();
> @@ -876,8 +879,8 @@ static void test_overflow_interrupt(void)
>  	write_regn_el0(pmevcntr, 1, ALL_SET);
>  	isb();
>  	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> -	report(expect_interrupts(0x2),
> -		"expect overflow interrupt on odd counter");
> +	report(expect_interrupts(0x3),
> +		"expect overflow interrupt on even and odd counter");
>  }
>  #endif
>  
Besides Drew's comment and assuming Marc's fix in sync,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

I definitively missed that spec detail when originally writing the test,
thank you for fixing.

Eric



