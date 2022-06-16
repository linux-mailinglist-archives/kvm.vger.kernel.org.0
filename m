Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F6254E973
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiFPSfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiFPSfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:35:01 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B148C517FC
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:35:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f65so1990086pgc.7
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2DDMpYpJIW2G43lM7VbrvSxw342R0ygln5vOT5hucU8=;
        b=ownebIQxonM5KkMhFH5JVGkaQme8MLm7ZX9ST78hEoYEe28ZGs3vdCPcHrqkelSlS+
         4ONsFY1pObJisnUI/UE7dFPVJmmZOQqjpFQv7hTCJld83h7UmpqzNrDrvFaYma/1YFTH
         VAftM64D62Ob+eBJe49LqaJJ+T3YPPf6vmJQZLH2COzZHsCJBOatYGO7yhBNq5JtYUEp
         Euqla277KaMufi5RgPvC0cxFFfOT7lguI4xXB69uxERh3HQIH3Gq7kqvuImBmBk8r4L8
         drD8Rg/XkJTg1R5vOewzCS4A1nlZUwF8tNUynkpC1L+iEkZu7GVbZJ1+xHuBULLXyYK9
         P2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2DDMpYpJIW2G43lM7VbrvSxw342R0ygln5vOT5hucU8=;
        b=VAkjtwTnws0wGm1zjXId4duz1Pab7eF+V05IMdB+k5FArXguCsQJFVN4PSTHyFcYKT
         sOzMOa4PRFelwpwO+m4z+afP9qKGzpe6evRU9HIjoKz+h8d9UaCJTrCpGRyiotFO+0qY
         vYR3kYzzKChgv4+FSehkifZolIGpm6vGsTS4FDk349KDbI/7v2R4MYhPE70FgxFZ9PEr
         CMLlpGb2UPwKMBGPDOYQ/TMxatcV7KvXIfb+UucyHJ+yVfzo1Y7DPp6g8crZtR/EElG7
         PCDPQ70H5GkpAIfUIt8whDPue8F4Q74vUeEbkmUJuvktW9u92Sr5fasRD4uxemOKWq1G
         Jd/g==
X-Gm-Message-State: AJIora+l4AeBMyJDxENbh+Z0VbUc39LFoj16+z+LfLBlqv+VFE/IDCZz
        APRQVVMxdIhkHNbgt7BB9exG9UKzBiIDvA==
X-Google-Smtp-Source: AGRyM1tGcFUTWV6HEKvRwId+6xa3/GnNX6fAt0Y85hLxhIGXMWuI5xRARf8gSN5Iy1izmWeuyaY5rw==
X-Received: by 2002:a65:6044:0:b0:3fc:674:8f5a with SMTP id a4-20020a656044000000b003fc06748f5amr5608538pgp.436.1655404499824;
        Thu, 16 Jun 2022 11:34:59 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c11-20020a62f84b000000b0051844a64d3dsm2082312pfm.25.2022.06.16.11.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:34:59 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:34:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, like.xu.linux@gmail.com, jmattson@google.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/3] x86: Skip running test when pmu is
 disabled
Message-ID: <Yqt3zzTV2UrsFX3v@google.com>
References: <20220615084641.6977-1-weijiang.yang@intel.com>
 <20220615084641.6977-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615084641.6977-3-weijiang.yang@intel.com>
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
> Read MSR_IA32_PERF_CAPABILITIES triggers #GP when pmu is disabled
> by enable_pmu=0 in KVM. Let's check whether pmu is available before
> issue msr reading to avoid the #GP. Also check PDCM bit before read
> the MSR.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  x86/pmu_lbr.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
> index 688634d..62614a0 100644
> --- a/x86/pmu_lbr.c
> +++ b/x86/pmu_lbr.c
> @@ -5,6 +5,7 @@
>  #define N 1000000
>  #define MAX_NUM_LBR_ENTRY	  32
>  #define DEBUGCTLMSR_LBR	  (1UL <<  0)
> +#define PDCM_ENABLED	  (1UL << 15)
>  #define PMU_CAP_LBR_FMT	  0x3f
>  
>  #define MSR_LBR_NHM_FROM	0x00000680
> @@ -74,13 +75,22 @@ int main(int ac, char **av)
>  		return 0;
>  	}
>  
> -	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>  	eax.full = id.a;
>  
>  	if (!eax.split.version_id) {
>  		printf("No pmu is detected!\n");
>  		return report_summary();
>  	}
> +
> +	id = cpuid(1);
> +
> +	if (!(id.c & PDCM_ENABLED)) {

Don't open code cpuid(), add and use X86_FEATURE_PDCM:

  #define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))

	if (!this_cpu_has(X86_FEATURE_PDCM))
		...



> +		printf("No PDCM is detected!\n");

If your going to bother printing a message, please make it useful.  Every time I
read PMU code I have to reread the kernel's cpufeatures.h to remember what PDCM
stands for.

		printf("Perf/Debug Capabilities MSR isn't supported\n");

> +		return report_summary();
> +	}
> +
> +	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> +
>  	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
>  		printf("No LBR is detected!\n");

Similar complaint,

		printf("Architectural LBRs are not supported.\n");

>  		return report_summary();
> -- 
> 2.31.1
> 
