Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCE56ACB5
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 22:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbiGGU2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 16:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiGGU2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 16:28:42 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABC718359
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 13:28:41 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id z14so20596776pgh.0
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 13:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Fy4M13ABfv1V8/8o50N3gQ90WdvJsmrjB+fv04z/Ig=;
        b=l7EgGgsIREQoPkWSFRztr1xMig4xUWRhzDbOEiltMXC+EJHRQxmmDrbkqZWaecLcQs
         iWdAKtp7JPgI9N0pNLJO1Vjwv+60Ps9QgpPfeTO+Ag/Q7fbe5+8SGdGokex3wzGTQrUY
         vErlLQpwYp+Z32IrKYBTeeNawCLrTseYTIY3fK9DURqZBgutqzAw1jn6IUhCOOj0NKTK
         hrtaICylG2/bn2LTeZedi9jzFWK/qhhd4UX6umc5EydYOMjXCGbUigbNAEg5G2PKD9uM
         cHGzzQetW/wD0U/YW/kQMDBMh5XPiyf/kaLJe6S37KvTuUBP7ZpFrcBNpJ3Ip0K+cVnO
         ceew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Fy4M13ABfv1V8/8o50N3gQ90WdvJsmrjB+fv04z/Ig=;
        b=ae/tkH1XdNB8DWqJmVzPLJ5HR3jRs9SGnXAqFy+3WRt5760/r/2XTMwNg6oM71F1xI
         n4WeUq6n18gEs8prnUm3E/3I8xwP54hvhc4xMAMFRwc1JtgZFWC6H/2YpcWNaFv2vzrA
         mC7I2aviaoTgDwFMOt76cgp7pHGXXSO4lhc4I8tWDHRnBuPU18x165fU3MR/zxC0HWQn
         RnmBUsfekiZZs2+fASY2p5PqfHsdPk1DYuQuzHnu9JjtUyt5JBxG0HNlo/TxPUqMwoDV
         9VgCbVpciRbsbnna8o4jl7/9B6+HAL+KPKI0go22E2Sjl2hFb5hx3X+EovT0qqetYVRX
         MaKg==
X-Gm-Message-State: AJIora8NwdiHjOyJQEMwZyhGCV5ZyXqe1qzvRjFdveczkU5Xfs7KxW6c
        DjG+iq7h6TYJcDuYEkGZLmVvSO5pvkCjow==
X-Google-Smtp-Source: AGRyM1tgXGmoegoDnHaE+yIUsc2g9NVjCuWQ02eHtzEqoZmDftjHGxlRgDB6ZaV+17fN/wjPdnQBwA==
X-Received: by 2002:a05:6a00:1412:b0:528:47a6:8569 with SMTP id l18-20020a056a00141200b0052847a68569mr31835828pfu.39.1657225720490;
        Thu, 07 Jul 2022 13:28:40 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id g6-20020a1709026b4600b0016788487357sm28207402plt.132.2022.07.07.13.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 13:28:40 -0700 (PDT)
Date:   Thu, 7 Jul 2022 20:28:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 2/2] x86: Check platform vPMU
 capabilities before run lbr tests
Message-ID: <YsdB9Is3oHgSFg8S@google.com>
References: <20220628093203.73160-1-weijiang.yang@intel.com>
 <20220628093203.73160-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628093203.73160-2-weijiang.yang@intel.com>
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

On Tue, Jun 28, 2022, Yang Weijiang wrote:
> Use new helper to check whether pmu is available and Perfmon/Debug
> capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
> avoid test failure. The issue can be captured when enable_pmu=0.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> 
> v4:
> - Put the X86_FEATURE_PDCM to the right place. [Sean]
> ---

<version info goes here>

>  lib/x86/processor.h |  1 +
>  x86/pmu_lbr.c       | 32 +++++++++++++-------------------
>  2 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 7b6ee92..7a35c7f 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -146,6 +146,7 @@ static inline bool is_intel(void)
>   */
>  #define	X86_FEATURE_MWAIT		(CPUID(0x1, 0, ECX, 3))
>  #define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
> +#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
>  #define	X86_FEATURE_PCID		(CPUID(0x1, 0, ECX, 17))
>  #define	X86_FEATURE_MOVBE		(CPUID(0x1, 0, ECX, 22))
>  #define	X86_FEATURE_TSC_DEADLINE_TIMER	(CPUID(0x1, 0, ECX, 24))
> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
> index 688634d..497df1e 100644
> --- a/x86/pmu_lbr.c
> +++ b/x86/pmu_lbr.c
> @@ -15,6 +15,7 @@
>  #define MSR_LBR_SELECT		0x000001c8
>  
>  volatile int count;
> +u32 lbr_from, lbr_to;
>  
>  static noinline int compute_flag(int i)
>  {
> @@ -38,18 +39,6 @@ static noinline int lbr_test(void)
>  	return 0;
>  }
>  
> -union cpuid10_eax {
> -	struct {
> -		unsigned int version_id:8;
> -		unsigned int num_counters:8;
> -		unsigned int bit_width:8;
> -		unsigned int mask_length:8;
> -	} split;
> -	unsigned int full;
> -} eax;
> -
> -u32 lbr_from, lbr_to;
> -
>  static void init_lbr(void *index)
>  {
>  	wrmsr(lbr_from + *(int *) index, 0);
> @@ -63,7 +52,7 @@ static bool test_init_lbr_from_exception(u64 index)
>  
>  int main(int ac, char **av)
>  {
> -	struct cpuid id = cpuid(10);
> +	u8 version = pmu_version();
>  	u64 perf_cap;
>  	int max, i;
>  
> @@ -74,19 +63,24 @@ int main(int ac, char **av)
>  		return 0;
>  	}
>  
> -	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> -	eax.full = id.a;
> -
> -	if (!eax.split.version_id) {
> +	if (!version) {

If the previous patch exposes cpu_has_pmu(), then this open coded check goes away
in favor of the more obvious:

	if (!cpu_has_pmu()) {

>  		printf("No pmu is detected!\n");
>  		return report_summary();
>  	}
> +
> +	if (!this_cpu_has(X86_FEATURE_PDCM)) {
> +		printf("Perfmon/Debug Capabilities MSR isn't supported\n");
> +		return report_summary();
> +	}
> +
> +	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> +
>  	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
> -		printf("No LBR is detected!\n");
> +		printf("(Architectural) LBR is not supported.\n");
>  		return report_summary();
>  	}
>  
> -	printf("PMU version:		 %d\n", eax.split.version_id);
> +	printf("PMU version:		 %d\n", version);

And with the open coded check gone, this can be:
	
	printf("PMU version:		 %d\n", pmu_version());

>  	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
>  
>  	/* Look for LBR from and to MSRs */
> -- 
> 2.27.0
> 
