Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789D154E997
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378048AbiFPSk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378046AbiFPSk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:40:28 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433A54BD3
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:40:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c196so2232970pfb.1
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qOtsGgRe/HH6fZCGA1Vqnp/Pu2SpXJ203pmsMApP9BQ=;
        b=ghV/+SwhOrmWSAqfHY6oib0Bgukkl21RuufbSrEMtukRTyKO6vNTe3H6zfHENiXv7F
         I0H7Hd2s8l69WZ2midlhigmck6rArP0HJBqV4UGpNKarYuop9SoRh0nfOqkOtaKPGlA/
         zj0fRsthrrh6p/lSTvsFyoOgblRLJry6PSKZkg3h6CEwCaD/zbIPH7rjfneJamf/J4Dx
         XpfIuGQTP4vftc7+ZF3REFz7wNPDErkY9RKwuY6nd3YRjn3qEAalVz0sioDhaJl7zAsJ
         dhpxaeIPL7hN6x3ogpfBqBfCFv99CP7mJItiIe12fGDc2XG/poQYWU8kMSPC+nxcq7Jr
         LjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qOtsGgRe/HH6fZCGA1Vqnp/Pu2SpXJ203pmsMApP9BQ=;
        b=4kmTEhY1nGNQ1alGj/m4CqSjd7A2zp+Gxn5zoEGrhrWopzq6QGOBaawbdCzOJ7GmPJ
         rck+ecNX/bPov6mEIJXsN4BarO6ku5pYVOyIabcRZFYNm5NQSVhhntM/ReKXFUH3potR
         0x1sgHuQKFB4+ZKbxxr11EQJZ/gmXZhnIfbX3BGb4xqT3ZH+nZa7KkfyVf9+PH8ai8xx
         6IlKvZ4kv+rF/m4w5CUTcDiEQ0jXc4P8VGWvWcRfCa19wuniAlqJbo8rZngMc4wcfLdY
         +ffmPCPcwVKmT7yqoT8/SU6StAF/MGVGBWvWg6ptC+x4052iPC6GpuqDHtkzeDrQ3a+5
         WrjA==
X-Gm-Message-State: AJIora/9GFH4cGYpsLgC97iIu8b8gmYKmTsYr15FdFPNTfQY/Jb/J3SJ
        Zs8epM2QfgufRy+84bnnFm8Rcg==
X-Google-Smtp-Source: AGRyM1uBPJnjS+zaEQvs0WWO2BBd1tCDhgkg2x0s/MDJqsQU2VYIAT9vHByVJYS2WACJKoZyiciIPQ==
X-Received: by 2002:a63:8bc7:0:b0:3fc:b8ab:c612 with SMTP id j190-20020a638bc7000000b003fcb8abc612mr5508336pge.535.1655404826017;
        Thu, 16 Jun 2022 11:40:26 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w1-20020a63a741000000b00404fd2138afsm2181375pgo.40.2022.06.16.11.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:40:25 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:40:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, like.xu.linux@gmail.com, jmattson@google.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/3] x86: Skip perf related tests when
 pmu is disabled
Message-ID: <Yqt5Fa/8l56XhfRC@google.com>
References: <20220615084641.6977-1-weijiang.yang@intel.com>
 <20220615084641.6977-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615084641.6977-4-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022, Yang Weijiang wrote:
> When pmu is disabled in KVM, reading MSR_CORE_PERF_GLOBAL_CTRL
> or executing rdpmc leads to #GP, so skip related tests in this case.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  x86/vmx_tests.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4d581e7..dd6fc13 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -944,6 +944,16 @@ static void insn_intercept_main(void)
>  			continue;
>  		}
>  
> +		if (insn_table[cur_insn].flag == CPU_RDPMC) {
> +			struct cpuid id = cpuid(10);
> +
> +			if (!(id.a & 0xff)) {

Please add helpers to query (a) the PMU version and (b) whether or not PERF_GLOBAL_CTRL
is supported.

> +				printf("\tFeature required for %s is not supported.\n",
> +				       insn_table[cur_insn].name);
> +				continue;
> +			}
> +		}
> +
>  		if (insn_table[cur_insn].disabled) {
>  			printf("\tFeature required for %s is not supported.\n",
>  			       insn_table[cur_insn].name);
> @@ -7490,6 +7500,13 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
>  
>  static void test_load_host_perf_global_ctrl(void)
>  {
> +	struct cpuid id = cpuid(10);
> +
> +	if (!(id.a & 0xff)) {
> +		report_skip("test_load_host_perf_global_ctrl");
> +		return;
> +	}
> +
>  	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
>  		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
>  		return;
> @@ -7502,6 +7519,13 @@ static void test_load_host_perf_global_ctrl(void)
>  
>  static void test_load_guest_perf_global_ctrl(void)
>  {
> +	struct cpuid id = cpuid(10);
> +
> +	if (!(id.a & 0xff)) {
> +		report_skip("test_load_guest_perf_global_ctrl");
> +		return;
> +	}
> +
>  	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
>  		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
>  		return;
> -- 
> 2.31.1
> 
