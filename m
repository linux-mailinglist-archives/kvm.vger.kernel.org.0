Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA61255A432
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 00:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiFXWJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 18:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiFXWJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 18:09:02 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75D687D4C
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 15:09:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x4so3689960pfq.2
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 15:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UR5UMHoQyNnXrMCZx3m5q2W2Qhty2vRnz81Aifl0U3g=;
        b=U8frpXdG6c1F7FwpUm3J660PhyyD6uyWGg3ryvWawfG/ai8VwMofwrHirbzfZRDYeS
         3XlU4BCL36+mIII2o/sfFLgh4C1gOtt7NCYqHYjP24aXnfPadJYSkGD8vrlNuD8t+eQ+
         CCVYakyXoXa5v0diR0F+GhRPxKqCQWWi5PoE10i/sDISo9C/ighwZd6wBmVA5aZZ3u/g
         1Jmx1lZZlHQ2jjS65XnAYcAs+IbZWqbgZa6rTfa0SjyvTmMNR6sLcFrS9TRS1v4ARLsY
         MvDFwL0WB+cYNBPTd9ou8KCsIMfNpx3S1BH4vc88TK8cfku3dMsfMWlUvW0QvD4jqyNO
         2jsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UR5UMHoQyNnXrMCZx3m5q2W2Qhty2vRnz81Aifl0U3g=;
        b=dp8ia0lwAKPb5phlubDDY49zUkiSXCVm/WIlHMAPwvZVY4xPQ4onvkxM1ULLy56FJn
         DXvS7FZpU9CqEklqm2hYN2NR67zKkNpmcEsRJRY2jfrAJ5Ca0ievUngihZiEVyXog2lb
         y5afdjkGfripiPaKS8yT7hfSwYeFyIukmW/YrrWhfVpL3Fks1t8UYF9AliCLTlCLPJ3O
         OO2r6yAuAckZxSm/FGcpN9mMoD5EKjdu7+tB/YyjwkFE/XCKg+9JrSxjABoKOmqmto2P
         mDDOS1yULkVgB+dKw5psY/sDlEArLbsehHbOJ5q3H2ZqoND2QVDKatXCbYILZpkQCG5h
         sKxA==
X-Gm-Message-State: AJIora+46B8vgm7AiaMbGN/UyDVlZDeEliYwnj4y51LOmaXqzcJozDT3
        lU/Uj+k1Hbs9xwAmu0ISDmV2Gg==
X-Google-Smtp-Source: AGRyM1uXRUGJYMYPupaGh8CqU5GTU3gsAwUJRXJg1n9RHQh2lXx8SlFB7skaaw70ucHjXfPFXDhKpw==
X-Received: by 2002:a62:528c:0:b0:525:3bfc:a5f7 with SMTP id g134-20020a62528c000000b005253bfca5f7mr1289594pfb.66.1656108541306;
        Fri, 24 Jun 2022 15:09:01 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h28-20020a63121c000000b004088f213f68sm2101794pgl.56.2022.06.24.15.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 15:09:00 -0700 (PDT)
Date:   Fri, 24 Jun 2022 22:08:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] x86: Skip perf related tests when platform cannot
 support
Message-ID: <YrY1+UHZMDno74we@google.com>
References: <20220624090828.62191-1-weijiang.yang@intel.com>
 <20220624090828.62191-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624090828.62191-3-weijiang.yang@intel.com>
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

On Fri, Jun 24, 2022, Yang Weijiang wrote:
> Add helpers to check whether MSR_CORE_PERF_GLOBAL_CTRL and rdpmc
> are supported in KVM. When pmu is disabled with enable_pmu=0,
> reading MSR_CORE_PERF_GLOBAL_CTRL or executing rdpmc leads to #GP,
> so skip related tests in this case to avoid test failure.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  lib/x86/processor.h | 10 ++++++++++
>  x86/vmx_tests.c     | 18 ++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 9a0dad6..70b9193 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -690,4 +690,14 @@ static inline bool cpuid_osxsave(void)
>  	return cpuid(1).c & (1 << (X86_FEATURE_OSXSAVE % 32));
>  }
>  
> +static inline u8 pmu_version(void)
> +{
> +	return cpuid(10).a & 0xff;
> +}
> +
> +static inline bool has_perf_global_ctrl(void)

Slight preference for this_cpu_has_perf_global_ctrl() or cpu_has_perf_global_ctrl().

> +{
> +	return pmu_version() > 1;
> +}
> +
>  #endif
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4d581e7..3cf0776 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -944,6 +944,14 @@ static void insn_intercept_main(void)
>  			continue;
>  		}
>  
> +		if (insn_table[cur_insn].flag == CPU_RDPMC) {
> +			if (!!pmu_version()) {
> +				printf("\tFeature required for %s is not supported.\n",
> +				       insn_table[cur_insn].name);
> +				continue;
> +			}
> +		}

There's no need to copy+paste a bunch of code plus a one-off check, just add
another helper that plays nice with supported_fn().

static inline bool this_cpu_has_pmu(void)
{
	return !!pmu_version();
}

> +
>  		if (insn_table[cur_insn].disabled) {
>  			printf("\tFeature required for %s is not supported.\n",
>  			       insn_table[cur_insn].name);
> @@ -7490,6 +7498,11 @@ static void test_perf_global_ctrl(u32 nr, const char *name, u32 ctrl_nr,
>  
>  static void test_load_host_perf_global_ctrl(void)
>  {
> +	if (!has_perf_global_ctrl()) {
> +		report_skip("test_load_host_perf_global_ctrl");

If you're going to print just the function name, then

		report_skip(__func__);

will suffice.  I'd still prefer a more helpful message, especially since there's
another "skip" in this function.

> +		return;
> +	}
> +
>  	if (!(ctrl_exit_rev.clr & EXI_LOAD_PERF)) {
>  		printf("\"load IA32_PERF_GLOBAL_CTRL\" exit control not supported\n");
>  		return;

Speaking of said skip, can you clean up the existing code to use report_skip()?

> @@ -7502,6 +7515,11 @@ static void test_load_host_perf_global_ctrl(void)
>  
>  static void test_load_guest_perf_global_ctrl(void)
>  {
> +	if (!has_perf_global_ctrl()) {
> +		report_skip("test_load_guest_perf_global_ctrl");
> +		return;
> +	}
> +
>  	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
>  		printf("\"load IA32_PERF_GLOBAL_CTRL\" entry control not supported\n");
>  		return;
> -- 
> 2.27.0
> 
