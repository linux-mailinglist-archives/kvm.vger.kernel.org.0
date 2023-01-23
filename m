Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67A2678768
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjAWUSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjAWUSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:18:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325A734C09
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674505045;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8MNo2YjKk7J/BKzDu+azlSz0YXSq+1eoYCVeVbfO5OU=;
        b=N1IpEqn0FwNT/Pvw2M/QKQzexAzeRQYlcjFD3iaIFXcG+EBv+eh9SRH0bRx0fssmMpn9hd
        +q++gCYwWIktw3bFzcRBnjcYo0HDEvxfhy4YhSkUfnV3/SwPhvKSYPZgusrJinpj9fqgI4
        sLhJTGA16zU6WthvNCeaNryhZLRfQVg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-d1vzeiOvNgqxiKwnlm_CWw-1; Mon, 23 Jan 2023 15:17:23 -0500
X-MC-Unique: d1vzeiOvNgqxiKwnlm_CWw-1
Received: by mail-qk1-f197.google.com with SMTP id bp33-20020a05620a45a100b007090e2e1b0cso7995712qkb.16
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8MNo2YjKk7J/BKzDu+azlSz0YXSq+1eoYCVeVbfO5OU=;
        b=Z7M9bQznevdtQqqa1CcLZLgbmE96xx1jttaBKWYtYZrmSLrtr9vcLeZwrZcN+XBMNs
         xb/ghvIgKoC7gu5iVcjmq6+sgJ/hwpDcaEqM0HJW395izP0lpQwSzRQSQnpqfa2+84Cu
         3gf+Ejw2n3lnfoxBATIFpVucOKLCMkkWujhB002BcJYH2R+xYYeeG9fr3KxQsfZ9ul1u
         VpoTa3Y1RIa4yW6T6fqZcXJlGQTy7yiRWLD0wgckOJ0Oj3VPCSt8S9cyaI9p3RYv+xuF
         G3eqz5PMBP5BPFNSfpmoNlma2ud6jO2kSjdlj0756Vbq1AE5iVMrJD88knw/71bUzIM7
         auIA==
X-Gm-Message-State: AFqh2kpzmhFXpaKQhSN9px9hgbmXwe6IDNy8RvRVUbN0jZLxsSKJxpro
        JSFGn+9zDGhVoZxWU3vOvLK0k5uDUOamt+oCrOMRX21+IwSfMgbpoXUaTXrcHh1LNT69HarU4HS
        0325JbdtEJV8+
X-Received: by 2002:ac8:47cd:0:b0:3b6:8b6d:e53f with SMTP id d13-20020ac847cd000000b003b68b6de53fmr27207947qtr.29.1674505043408;
        Mon, 23 Jan 2023 12:17:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvLfxS6tOikVjJgIpmQw7wjx8hVJogYZZtO+s+FRPCpuA+Xinit9530UozNaOaoOBCHfXBdvg==
X-Received: by 2002:ac8:47cd:0:b0:3b6:8b6d:e53f with SMTP id d13-20020ac847cd000000b003b68b6de53fmr27207920qtr.29.1674505043077;
        Mon, 23 Jan 2023 12:17:23 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j129-20020a378787000000b00706a1551428sm141299qkd.6.2023.01.23.12.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:17:22 -0800 (PST)
Message-ID: <31614401-8669-1f74-aa01-bed3ad3d2cf0@redhat.com>
Date:   Mon, 23 Jan 2023 21:17:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 4/4] arm: pmu: Print counter values as
 hexadecimals
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
        reijiw@google.com
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-5-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230109211754.67144-5-ricarkol@google.com>
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



On 1/9/23 22:17, Ricardo Koller wrote:
> The arm/pmu test prints the value of counters as %ld.  Most tests start
> with counters around 0 or UINT_MAX, so having something like -16 instead of
> 0xffff_fff0 is not very useful.
>
> Report counter values as hexadecimals.
>
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arm/pmu.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 72d0f50..77b0a70 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -552,8 +552,8 @@ static void test_mem_access(bool overflow_at_64bits)
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> -	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
> -	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
> +	report_info("counter #0 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
> +	report_info("counter #1 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
>  	/* We may measure more than 20 mem access depending on the core */
>  	report((read_regn_el0(pmevcntr, 0) == read_regn_el0(pmevcntr, 1)) &&
>  	       (read_regn_el0(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0),
> @@ -568,7 +568,7 @@ static void test_mem_access(bool overflow_at_64bits)
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report(read_sysreg(pmovsclr_el0) == 0x3,
>  	       "Ran 20 mem accesses with expected overflows on both counters");
> -	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> +	report_info("cnt#0=0x%lx cnt#1=0x%lx overflow=0x%lx",
>  			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
>  			read_sysreg(pmovsclr_el0));
>  }
> @@ -599,7 +599,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  		write_sysreg(0x1, pmswinc_el0);
>  
>  	isb();
> -	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> +	report_info("SW_INCR counter #0 has value 0x%lx", read_regn_el0(pmevcntr, 0));
>  	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>  		"PWSYNC does not increment if PMCR.E is unset");
>  
> @@ -616,7 +616,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  	isb();
>  	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
>  	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> -	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> +	report_info("counter values after 100 SW_INCR #0=0x%lx #1=0x%lx",
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  	report(read_sysreg(pmovsclr_el0) == 0x1,
>  		"overflow on counter #0 after 100 SW_INCR");
> @@ -692,7 +692,7 @@ static void test_chained_sw_incr(bool unused)
>  	report((read_sysreg(pmovsclr_el0) == 0x1) &&
>  		(read_regn_el0(pmevcntr, 1) == 1),
>  		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> -	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> +	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  
>  	/* 64b SW_INCR and overflow on CHAIN counter*/
> @@ -713,7 +713,7 @@ static void test_chained_sw_incr(bool unused)
>  	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
>  	       (read_regn_el0(pmevcntr, 1) == cntr1),
>  	       "expected overflows and values after 100 SW_INCR/CHAIN");
> -	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> +	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
>  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
>  
> @@ -745,11 +745,11 @@ static void test_chain_promotion(bool unused)
>  	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
>  	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
>  		"odd counter did not increment on overflow if disabled");
> -	report_info("MEM_ACCESS counter #0 has value %ld",
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
>  		    read_regn_el0(pmevcntr, 0));
> -	report_info("CHAIN counter #1 has value %ld",
> +	report_info("CHAIN counter #1 has value 0x%lx",
>  		    read_regn_el0(pmevcntr, 1));
> -	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
> +	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
>  
>  	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
>  	pmu_reset();

