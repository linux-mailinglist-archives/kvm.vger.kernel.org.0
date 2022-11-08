Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67D6620CB3
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 10:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiKHJyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 04:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiKHJyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 04:54:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33D33BC
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 01:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667901198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzoGd4Gb3r/vu7Rkz4I2OXS3PO0nLcghMAIB6UW5rKQ=;
        b=iaQ2QKmSYThrbKHx/Jwa9sCHXIcejSN76z7g7NdWfpkCvXZTkWpwAfF6Z4bD55CvLK/nYU
        Gw/SeG5hCvCfiKi38VkNz9krX2OtO2ueJw8UcMUR4tOLroBOqBlGtrwSoQURbQ+lTyOhiC
        w45z5PFztGqzF2u74NstGK++Bur56ag=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-357-lzQU3jaTNVm267xf0rj94w-1; Tue, 08 Nov 2022 04:53:16 -0500
X-MC-Unique: lzQU3jaTNVm267xf0rj94w-1
Received: by mail-wr1-f69.google.com with SMTP id n13-20020adf8b0d000000b0023658a75751so3824423wra.23
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 01:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uzoGd4Gb3r/vu7Rkz4I2OXS3PO0nLcghMAIB6UW5rKQ=;
        b=1oWa90UvcniIg42cjPK5gKGZOFlTA3XSzRjMPkcrqR5GdnjFKsmuxK9BjgamOCGjme
         cpeMWbKLnJhXNadsOqfNzPZn/GO9oG20AerO3aehas0Ec1wY7LGG5+1dpxpSAyzeb+FC
         VjpjQD1K3DRw6MEe15gtR88Sfr3RvvruthmB/CAi/Fq5yV2xjwp91KMLPs/v2TrY+kak
         MwcOsrF+uNErpMXUh1T8Po2895dKBcSJFXrZDakENsxE22opjRaJE4q+fE7Q1R+HdXmE
         FrSoL+j8gWAcBzSRDU2xrDrLQxAA3wxjQP+O0ZV/2UroLYtVQpm/lNY/yvYsueWqUDjT
         j8oA==
X-Gm-Message-State: ACrzQf1i1EtPOwz2jiXRGRWDyungc3uDleB3/Xu+9WgErwe08zVazxlz
        hemmOoN91D3rQHjCGT0M0+ylWOkjm8KyxO61tPfL7dx8u/sbePRIGCfLDuOuqmqGiQZG7RpESmy
        8cqSohn+mSWMg
X-Received: by 2002:adf:f1c9:0:b0:236:49ee:8598 with SMTP id z9-20020adff1c9000000b0023649ee8598mr33921492wro.481.1667901195390;
        Tue, 08 Nov 2022 01:53:15 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6Ec9loeKZWPo0yMMthDKLz6II1hGxtRHuPK4ad2qBoZ7H0jm0uUtFY27W6viz5QAVEqGkTWA==
X-Received: by 2002:adf:f1c9:0:b0:236:49ee:8598 with SMTP id z9-20020adff1c9000000b0023649ee8598mr33921483wro.481.1667901195176;
        Tue, 08 Nov 2022 01:53:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id t12-20020a5d6a4c000000b00228692033dcsm9831584wrw.91.2022.11.08.01.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 01:53:14 -0800 (PST)
Message-ID: <adcb7098-5bae-7dc3-f48f-5c84fd3f4f7d@redhat.com>
Date:   Tue, 8 Nov 2022 10:53:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [kvm-unit-tests PATCH v5 26/27] x86/pmu: Update testcases to
 cover AMD PMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
References: <20221102225110.3023543-1-seanjc@google.com>
 <20221102225110.3023543-27-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102225110.3023543-27-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/22 23:51, Sean Christopherson wrote:
> +		pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
> +		pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
> +		if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
> +			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
> +		else
> +			pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +

If X86_FEATURE_PERFCTR_CORE is not set, pmu.msr_gp_*_base should point 
to MSR_K7_PERFCTR0/MSR_K7_EVNTSEL0:

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index af68f3a..8d5f69f 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -47,10 +47,13 @@ void pmu_init(void)
  		pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
  		if (this_cpu_has(X86_FEATURE_AMD_PMU_V2))
  			pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
-		else if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
-			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
-		else
+		else if (this_cpu_has(X86_FEATURE_PERFCTR_CORE))
  			pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
+		else {
+			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
+			pmu.msr_gp_counter_base = MSR_K7_PERFCTR0;
+			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
+		}

  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
  		pmu.gp_counter_mask_length = pmu.nr_gp_counters;

Paolo

