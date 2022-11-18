Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8CF62F9E9
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 17:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241815AbiKRQId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 11:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKRQIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 11:08:31 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AED12085
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:08:30 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b11so4894812pjp.2
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=18v7itz8tcB+kulyiAhq7l9hrIOQNQ0hxN4rmyqP/Gk=;
        b=JyC6nE+T/Eqsnqr6iO3fk2MGx3PhxnyAJ8yPFlpQNleqYdGDrLGtkm2WiQ98CKRfyp
         CQM1ONo8/jAYTK0ab2Txj5wcwyJyRQWy1DhLJv8olXqny46AqhKzvtVFGMcyw8PxkZXa
         lD+uoEKhhvPOOBUlErzJwYK6AFifqlsYDd9N4jZwcnRDZ0PN8/CwoL281hM0fGrJgafp
         1w7VVMsh7LbxAYkdRdkxu1Ze+yr+hR5saN/IeYFnsInZR43FQrRMqv7qkIF35cqbdQ35
         A02vu3zgIBzDdOEk64IJAbwQUBidIS/MTiZ857aD4sCN/O6nVcT1znn9k7PECTInOVJi
         ZVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=18v7itz8tcB+kulyiAhq7l9hrIOQNQ0hxN4rmyqP/Gk=;
        b=YaAxWdDXLEnCwbRYznq7FEcoXhH1eX/I8NYqIIkUOHv5hbIq6Z1OAyNQaAVJydQxtW
         GcdVih6577YedKphja6iJy/ckd2Xig79VkXpv+PKMcphRKL5PmhOaoYkaKjkdb6buZ9V
         uZqPowxYQKQeXjwAIgm3YGBhleUR+ULiD31wiCbPTrhOdzOh+7jaBxI0vK/dzTD2v/wC
         0dDdO5CIWH8gZYF8xOCxs9ohJWzuetHUFzpXm0hGlN38oviO4JLshrtvTcG5TzPWFOwp
         NbF1kpaWHs+1TEgrkruMZ8yTbJRPhHotF61Jb5LFvTJaEvC4/aKlYclFpFnwfcDDdeG9
         sIBQ==
X-Gm-Message-State: ANoB5plud7eO+iypwwHW9KjU0VSbxso8QiaZvZ35+5glmtMQxYW8d3jJ
        sJr74uRCz0l71BqwaqN6fsCRGZMHDuvrcg==
X-Google-Smtp-Source: AA0mqf6K5YJzlJyO+jeKg3SttZRxjLIf9dk/RpMi6fNcla3M+fffcQ1zcQBnZ61z9SCHc+dHaeaTaQ==
X-Received: by 2002:a17:90a:ad4c:b0:212:c6f4:fa5 with SMTP id w12-20020a17090aad4c00b00212c6f40fa5mr8673553pjv.49.1668787710014;
        Fri, 18 Nov 2022 08:08:30 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l7-20020a170902f68700b00177fb862a87sm3983255plg.20.2022.11.18.08.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 08:08:29 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:08:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] x86: KVM: Advertise AVX-IFMA CPUID to user space
Message-ID: <Y3et+VpYh+L7N8SL@google.com>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-4-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118141509.489359-4-jiaxi.chen@linux.intel.com>
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

On Fri, Nov 18, 2022, Jiaxi Chen wrote:
> AVX-IFMA is a new instruction in the latest Intel platform Sierra
> Forest. This instruction packed multiplies unsigned 52-bit integers and
> adds the low/high 52-bit products to Qword Accumulators.
> 
> The bit definition:
> CPUID.(EAX=7,ECX=1):EAX[bit 23]
> 
> This CPUID is exposed to user space. Besides, there is no other VMX
> control for this instruction.
> 
> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index df4a7f7505a9..159f8b9898bf 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -310,6 +310,7 @@
>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
>  #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
>  #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
> +#define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
>  
>  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
>  #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2a334d4cd04e..5726afb2d14c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -657,8 +657,8 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>  
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> -		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
> -	);
> +		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
> +		F(AVX_IFMA));

Please keep the terminating paranthesis+semicolon on a separate line.  KVM isn't
100% consistent (as usual), but I would rather "fix" the cases that don't put
the terminators on their own line. 
