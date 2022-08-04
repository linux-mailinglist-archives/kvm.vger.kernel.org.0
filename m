Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2727758A067
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 20:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbiHDSWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 14:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbiHDSWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 14:22:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AB6C6C118
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 11:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659637322;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v75w6GLObgAtRIZl7LRPPpod4VI56HpyexDqTUTHWM0=;
        b=CX4/8zGCFripggy7NsHVsRSbwSjoULoC9mvmis5Bg5BadMXiRiu9cVTGx51vAlH1QODzTD
        8tiNyhzZHTSzF6ULwEM1Kk0K2hRy+6/N8S/C4TDXvxrJiwrWeu8rcLP63t1MVvlR6j361M
        +Ce2DA0wesqUsw/lMF5XloNy611nz6I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-KOGGk2AkO_-SPrdAuoUZ3A-1; Thu, 04 Aug 2022 14:22:01 -0400
X-MC-Unique: KOGGk2AkO_-SPrdAuoUZ3A-1
Received: by mail-wm1-f70.google.com with SMTP id bh18-20020a05600c3d1200b003a32044cc9fso179795wmb.6
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 11:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=v75w6GLObgAtRIZl7LRPPpod4VI56HpyexDqTUTHWM0=;
        b=2vdPr7cULkmZdT2Tn7xyz/5hFv/uGdTIhYvEpkwy14sqB7EdKQHMoJooefYFVmAHHD
         nnrP3EdUdMm5IkfKy/ik4KYjUIqGG09DCwtLLVMZ1oqxZnMVucgcdqSRNngZcC+zl0WH
         hhbm1z8r9G3j+BFQP3B/PxEqPauXtuKdzOhhMNluln2rVkyDJ98sGkWB6M+itqS44DOe
         1w7jUs16D4QoweRsh9OHS6ae6GiDVqh6qVwYwu7vJ1uxDlvgy7IOd0IYVeW5zxFnZ4f4
         TqNtDjRlgde+vn9QdxhygJcXd+E2vrOZFbi59fsCcCGcEN55bZE6ltPwVnbFtSsMe3z1
         0P6w==
X-Gm-Message-State: ACgBeo1dWrmxKhtoDfSmLrHsfDHOCzHh4YiHe28Hb3OSVZo7D3SB3HG7
        4g4+dL3O8Yf9rE81swjsQBQn4yxx7znqEjZ4FX/M4s24ltXkqXVDlulsfQ1RL2b+Nxoifj6bBuo
        oY0+Mx6kEpWSq
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id be13-20020a05600c1e8d00b003a5074dc61cmr2313603wmb.70.1659637319691;
        Thu, 04 Aug 2022 11:21:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5qa6u4rvLgdrkeGZQ58TN8wqu+0q3xLX/YnoDM93GtPS6AXXdj3d2Nxn1Y47VQUM/Q9USHMw==
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id be13-20020a05600c1e8d00b003a5074dc61cmr2313594wmb.70.1659637319521;
        Thu, 04 Aug 2022 11:21:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bi19-20020a05600c3d9300b003a342933727sm7203839wmb.3.2022.08.04.11.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 11:21:58 -0700 (PDT)
Message-ID: <33adcdb9-9f29-a253-6491-314dcd08e0c8@redhat.com>
Date:   Thu, 4 Aug 2022 20:21:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] arm: pmu: Reset the pmu registers
 before starting some tests
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-3-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220803182328.2438598-3-ricarkol@google.com>
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
> Some registers like the PMOVS reset to an architecturally UNKNOWN value.
> Most tests expect them to be reset (mostly zeroed) using pmu_reset().
> Add a pmu_reset() on all the tests that need one.
>
> As a bonus, fix a couple of comments related to the register state
> before a sub-test.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/pmu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 76156f78..7c5bc259 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
>  	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>  	isb();
>  
> -	/* interrupts are disabled */
> +	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>  
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
> @@ -841,7 +841,7 @@ static void test_overflow_interrupt(void)
>  	isb();
>  	report(expect_interrupts(0), "no overflow interrupt after counting");
>  
> -	/* enable interrupts */
> +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
>  
>  	pmu_reset_stats();
>  
> @@ -889,6 +889,7 @@ static bool check_cycles_increase(void)
>  	bool success = true;
>  
>  	/* init before event access, this test only cares about cycle count */
> +	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
>  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>  
> @@ -943,6 +944,7 @@ static bool check_cpi(int cpi)
>  	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
>  
>  	/* init before event access, this test only cares about cycle count */
> +	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
>  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>  

