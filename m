Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27347BA72B
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjJEQ4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjJEQz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C275FCC
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 09:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696524305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZYBR2QbKq3NqPwbI1Wys9ihDkXFlFcq5Xf8xnR7rTY=;
        b=RP7oiuM2MEEvR/p8ljoe27dGJaWUkAwcNR22W4D5mZwTEVV2YAUAaEcz0LEloZqc+92HEq
        U9Oh/1+dWOp6fv3zG3bekn2wjvrT2J3sFpid3cpRAqOSSWvNmksefQUB5kdeTk/hn2MuiJ
        cSYgxX0/HGcIZkkmyhxSLX7CfEEIZyM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-GThh0uQdMIiZ_nTV5czxvA-1; Thu, 05 Oct 2023 12:45:04 -0400
X-MC-Unique: GThh0uQdMIiZ_nTV5czxvA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4054743df06so8788265e9.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 09:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696524303; x=1697129103;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZYBR2QbKq3NqPwbI1Wys9ihDkXFlFcq5Xf8xnR7rTY=;
        b=Il0nWCfT08d5kOtq1hTsDOQ33kYSHL8sUGmx5uoB8bX+JRKeTd5T2Q+MHyLV2VivNr
         JFY/OCuKaZ9arWB35VL31/9sVR5po3elrFghAU3UTYglQ/yB4tDHar/7aPnQI9M6KNPd
         jNFCInghaIwY01luqpyR+qM0ESt+Y3RVFNGieQuYJxmf8JxBdtKYgDGPaWrwuopXVQKo
         ctKi3vZ5Fs+sDszcUdlH9Nbvay2heUB1aYp62xymQFTMFZ6jjKQK+6NzCB1bCjDfsO2R
         zx1kkZszX1SUIBxx6JGQ2dMnIQH4rcNUDXXtT4eqqmIPqT/3pKPSPj1grrKjtAMLbXoH
         brXQ==
X-Gm-Message-State: AOJu0YzBJLs5QjT9PBxLublTurwVR/bD+7yF1qdsekVyVyZaFPV3WbWV
        rhceIWojNSxcWOKSTSvdXvExwrpVcQzJMYGCyYGSRWPiiqnnqcDjBNqje1GpW9BilG3aiuVGUex
        4nKfdsla/u+h7
X-Received: by 2002:a7b:c84d:0:b0:401:b504:b6a0 with SMTP id c13-20020a7bc84d000000b00401b504b6a0mr4797715wml.3.1696524303353;
        Thu, 05 Oct 2023 09:45:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSAY1JlfgaWsXPc1rDsrIpGA57eSh7hEMXp5NeMXQy4aTq9QP5VCNrJdBs1/K0EyU5ILMNkQ==
X-Received: by 2002:a7b:c84d:0:b0:401:b504:b6a0 with SMTP id c13-20020a7bc84d000000b00401b504b6a0mr4797690wml.3.1696524302947;
        Thu, 05 Oct 2023 09:45:02 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id d16-20020adff850000000b003232d122dbfsm2157582wrq.66.2023.10.05.09.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 09:45:02 -0700 (PDT)
Message-ID: <d9bf0049963df4d1e3e03290c28acb95d833f782.camel@redhat.com>
Subject: Re: [PATCH v2] x86: KVM: Add feature flag for
 CPUID.80000021H:EAX[bit 1]
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 05 Oct 2023 19:45:00 +0300
In-Reply-To: <20231005031237.1652871-1-jmattson@google.com>
References: <20231005031237.1652871-1-jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У ср, 2023-10-04 у 20:12 -0700, Jim Mattson пише:
> Define an X86_FEATURE_* flag for CPUID.80000021H:EAX.[bit 1], and
> advertise the feature to userspace via KVM_GET_SUPPORTED_CPUID.
> 
> Per AMD's "Processor Programming Reference (PPR) for AMD Family 19h
> Model 61h, Revision B1 Processors (56713-B1-PUB)," this CPUID bit
> indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
> MSR_KERNEL_GS_BASE is non-serializing. This is a change in previously
> architected behavior.
> 
> Effectively, this CPUID bit is a "defeature" bit, or a reverse
> polarity feature bit. When this CPUID bit is clear, the feature
> (serialization on WRMSR to any of these three MSRs) is available. When
> this CPUID bit is set, the feature is not available.
> 
> KVM_GET_SUPPORTED_CPUID must pass this bit through from the underlying
> hardware, if it is set. Leaving the bit clear claims that WRMSR to
> these three MSRs will be serializing in a guest running under
> KVM. That isn't true. Though KVM could emulate the feature by
> intercepting writes to the specified MSRs, it does not do so
> today. The guest is allowed direct read/write access to these MSRs
> without interception, so the innate hardware behavior is preserved
> under KVM.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
> 
> v1 -> v2: Added justification for this change to the commit message,
>           tweaked the macro name and comment in cpufeatures.h for
> 	  improved clarity.
> 
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 58cb9495e40f..4af140cf5719 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -443,6 +443,7 @@
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
> +#define X86_FEATURE_WRMSR_XX_BASE_NS	(20*32+ 1) /* "" WRMSR to {FS,GS,KERNEL_GS}_BASE is non-serializing */
>  #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
>  #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" Null Selector Clears Base */
>  #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" Automatic IBRS */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0544e30b4946..93241b33e36f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -761,7 +761,8 @@ void kvm_set_cpu_caps(void)
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>  		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
> -		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
> +		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
> +		F(WRMSR_XX_BASE_NS)
>  	);
>  
>  	if (cpu_feature_enabled(X86_FEATURE_SRSO_NO))


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

