Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B367A500
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 22:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbjAXVdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 16:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAXVdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 16:33:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC0548A05
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 13:33:01 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso15361034pjf.1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 13:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8MIgb1FC4LRlLs+V9SCUKWjUyCpMInu0ZH7wUPNGpSs=;
        b=E6psx8YV4vAdnKkIV2m9Germ7GqmWEnc/9AQtceX/5eUz7Ni5cLT8Qkasf4DyoTkPK
         NtydHCmOO8uBc5OaQuKOXDvyB6FS7izFrMRL5uUtPtNf92BH5fETbbTziouNUVTfxyEK
         bshnS081IcP4kevvdQAw7a2kdNa3fDxHA7TAooZyPspTqLykH+pGcEobdFD/Ui6vWEWg
         9z2y+Aym6kGKGfl2Zys9b+2JBon3OA9oIO/F4nVNPEgIILjpO1QkbwPh1vQNM96Mm01V
         qzdLLYslq3l9dlLKxzBoWvrdOvbvsceB9li+nZu7OO8wuQho+Ty3/fu/CZJkD1EuVf5k
         855g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MIgb1FC4LRlLs+V9SCUKWjUyCpMInu0ZH7wUPNGpSs=;
        b=DE7119zDcTlrRXwAfaAWf+SX2FU7rcHLsUDAMxOluFGbbcAPw6jxRWitPOGmN4/n3i
         F1nqdgi9NX1pFD8uLELfJYOQxvtgvJfb93mj8mWSNvXNPTgOdeZnd/b7gTUL2FUUJGTr
         MMz1VQpW1NP7Oj07aHH+12NMAg0pDaohxDTc9c4Qcu2YuZJl77nqPa55sK/fTRm985Qr
         nNf2yLVeWBoHWrNs+pZWj++8xr38jyWCUUc4xRb2yALdU3Hcqudir54JCMQyWolhkrJj
         VYspUTbr7jaaDeaZgUslWsO8haVgTQYLUYbkXrSdTAz1R0amk2AcEsT8tgEKLvY/MkXe
         dJ1w==
X-Gm-Message-State: AO0yUKVC+zbNDDoTw9JG0fiiDYtNI2p0OH6CH/o16dxRs+BRozSpKYGe
        FQpkSk3F5z0UXn6FC5+7yarqYg==
X-Google-Smtp-Source: AK7set8LwrT8q6wW7rJIZWqL1MaFgvrOp6tyO1Mlya56e2G9m/iyC8pIqiUrW4bbqzd8lVk2aoSXqA==
X-Received: by 2002:a17:902:e00c:b0:192:8a1e:9bc7 with SMTP id o12-20020a170902e00c00b001928a1e9bc7mr344558plo.0.1674595980333;
        Tue, 24 Jan 2023 13:33:00 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b00196251ca124sm236809plb.75.2023.01.24.13.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 13:32:59 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:32:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 4/8] x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to
 its native leaf
Message-ID: <Y9BOh9xB/G5Ifj8N@google.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-5-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124163319.2277355-5-kim.phillips@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023, Kim Phillips wrote:
> The LFENCE always serializing feature bit was defined as scattered
> LFENCE_RDTSC and its native leaf bit position open-coded for KVM.
> Add it to its newly added CPUID leaf 0x80000021 EAX proper.
> With LFENCE_RDTSC is in its proper place, the kernel's set_cpu_cap()
> will effectively sythesize the feature for KVM going forward.
> 
> Drop the bit description comments now it's more self-describing.
> 
> Also, in amd_init(), don't bother setting DE_CFG[1] any more.
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 3 ++-
>  arch/x86/kernel/cpu/amd.c          | 2 +-
>  arch/x86/kvm/cpuid.c               | 5 +----
>  3 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 4637fd7a84d6..e975822951b2 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -97,7 +97,7 @@
>  #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
>  #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
>  #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* AMD Last Branch Record Extension Version 2 */
> -#define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
> +/* FREE, was #define X86_FEATURE_LFENCE_RDTSC		( 3*32+18) "" LFENCE synchronizes RDTSC */
>  #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
>  #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
>  #define X86_FEATURE_ALWAYS		( 3*32+21) /* "" Always-present feature */
> @@ -432,6 +432,7 @@
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
> +#define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
>  
>  /*
>   * BUG word(s)
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index f769d6d08b43..208c2ce8598a 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -956,7 +956,7 @@ static void init_amd(struct cpuinfo_x86 *c)
>  
>  	init_amd_cacheinfo(c);
>  
> -	if (cpu_has(c, X86_FEATURE_XMM2)) {
> +	if (!cpu_has(c, X86_FEATURE_LFENCE_RDTSC) && cpu_has(c, X86_FEATURE_XMM2)) {
>  		/*
>  		 * Use LFENCE for execution serialization.  On families which
>  		 * don't have that MSR, LFENCE is already serializing.
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9764499acce2..448b5de98b8f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -742,12 +742,9 @@ void kvm_set_cpu_caps(void)
>  		F(SME_COHERENT));
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> -		F(NO_NESTED_DATA_BP) |
> -		BIT(2) /* LFENCE Always serializing */ | 0 /* SmmPgCfgLock */ |
> +		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>  		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
>  	);
> -	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
> -		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;

Gah, I was wrong.  I lost track of the fact that kvm_cpu_cap_mask() does an
actual CPUID, i.e. the oddball code is necessary to manual synthesize the flag.

Boris, can you fold this in?

---
 arch/x86/kvm/cpuid.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fb32e084a40f..12455dc5afe5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -745,6 +745,19 @@ void kvm_set_cpu_caps(void)
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
 	);
+
+	/*
+	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
+	 * KVM's supported CPUID if the feature is reported as supported by the
+	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
+	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
+	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
+	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
+	 * the mask with the raw host CPUID, and reporting support in AMD's
+	 * leaf can make it easier for userspace to detect the feature.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
 	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;

base-commit: f607476ee37397a72a2abb687bc170ce0bbec780
-- 

I.e. end up with this as of this patch:

	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
	);

	/*
	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
	 * KVM's supported CPUID if the feature is reported as supported by the
	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
	 * the mask with the raw host CPUID, and reporting support in AMD's
	 * leaf can make it easier for userspace to detect the feature.
	 */
	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;

