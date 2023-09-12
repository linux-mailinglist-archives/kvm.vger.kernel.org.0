Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F979D330
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbjILOGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 10:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbjILOGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 10:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD4F310D1
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 07:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694527525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Se7hqQXQMKrYV5KqZThGeZ3NRXLMJ2EyFNldKIrj/Kc=;
        b=czMnKQ7eYl01dWzwcP2iSEJ1LW3ZfU/lu1R6kYkjuleCabDR36YCjWSwSe15B6u5ZTzL4z
        3MFdGmICSKzWXqhmdS5Q+tUWLAqAxndWmKwGmjmd93Sv3zyp3vSxXUFjU12qWZJ7JVTGWM
        T+7y8qaO4z0sd7QDfjrgGDtq7AKyl/4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-BJFGdIfUMrueTzOk8xafdw-1; Tue, 12 Sep 2023 10:05:23 -0400
X-MC-Unique: BJFGdIfUMrueTzOk8xafdw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-31f79595669so1702902f8f.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 07:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694527522; x=1695132322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Se7hqQXQMKrYV5KqZThGeZ3NRXLMJ2EyFNldKIrj/Kc=;
        b=jn5b1xnDedTyutgsMyeBn80nKHXxJNti0z8xaLL8SDLzrrB5C7BZYmW3gwob1FORDd
         rmoFpkY4OD5OCDAsS+JDCCMUFZMJyfnebc3CBIYwTgXn2+PJMJFArSZzaMFXbWArt0Hy
         OtSdFbokzzJTmOIeBLksLqEXv6LAZ1XVYYZPTNqMvmPiGeds+MvRKq4XKh+gLK3hF9vw
         RTSM3WbGHNvZOIL/6Gz9fP2EbOEPlYCWEntf3HV0NcerWx7x+HesVgtJ6s7P8sYlqj7y
         PoHeZZojNW3rxUBLuGvuq6ebVi1Jkncwo6wcpXMvUWRFCAp3ZLeNkpy8RD0Xig+RzYQJ
         RFcw==
X-Gm-Message-State: AOJu0YyCmdceTq+Ihr469ia37OmC5L31wYO7MaV/Q3ddfjJB7XtnJ9En
        DMcAjnngXoolbYKI/GgibkvBmQ6EkOwSZ56TVBKaSvyx5DojqIf/RqdlfY6rRQYndy6WmyBwBIl
        G3jyX5LYNTXFi
X-Received: by 2002:a5d:60cf:0:b0:319:6ed2:a5c4 with SMTP id x15-20020a5d60cf000000b003196ed2a5c4mr1981262wrt.26.1694527521947;
        Tue, 12 Sep 2023 07:05:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwvhGWr+8e/BfJGS8trosITGG6jjfK+GccPrMCMaQFMHkG9Oz3yizJcHxtDxGBOSe4tBw8yg==
X-Received: by 2002:a5d:60cf:0:b0:319:6ed2:a5c4 with SMTP id x15-20020a5d60cf000000b003196ed2a5c4mr1981205wrt.26.1694527520907;
        Tue, 12 Sep 2023 07:05:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v17-20020a5d6791000000b00318147fd2d3sm12934675wru.41.2023.09.12.07.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 07:05:20 -0700 (PDT)
Message-ID: <c33130ec-661a-a1ed-c285-eeaa52365358@redhat.com>
Date:   Tue, 12 Sep 2023 16:05:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v4 2/3] target/i386: Restrict system-specific features
 from user emulation
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
References: <20230911211317.28773-1-philmd@linaro.org>
 <20230911211317.28773-3-philmd@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230911211317.28773-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/23 23:13, Philippe Mathieu-Daudé wrote:
>   /*
>    * Only for builtin_x86_defs models initialized with x86_register_cpudef_types.
>    */
> @@ -6163,6 +6195,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               }
>               *edx = env->features[FEAT_7_0_EDX]; /* Feature flags */
>   
> +#ifndef CONFIG_USER_ONLY
>               /*
>                * SGX cannot be emulated in software.  If hardware does not
>                * support enabling SGX and/or SGX flexible launch control,
> @@ -6181,6 +6214,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                       CPUID_7_0_ECX_SGX_LC))) {
>                   *ecx &= ~CPUID_7_0_ECX_SGX_LC;
>               }
> +#endif

This can use a variant of x86_cpu_get_supported_cpuid that returns a 
single register; or it can be rewritten to use x86_cpu_get_supported_cpuid.

In general, a lot of checks for accel_uses_host_cpuid() are unnecessary, 
and the code can be modified to not depend on either KVM or HVF.

>           } else if (count == 1) {
>               *eax = env->features[FEAT_7_1_EAX];
>               *edx = env->features[FEAT_7_1_EDX];
> @@ -6876,6 +6910,8 @@ static void mce_init(X86CPU *cpu)
>       }
>   }
>   
> +#ifndef CONFIG_USER_ONLY
> +
>   static void x86_cpu_adjust_level(X86CPU *cpu, uint32_t *min, uint32_t value)
>   {
>       if (*min < value) {
> @@ -6948,6 +6984,8 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
>       env->features[FEAT_XSAVE_XSS_HI] = mask >> 32;
>   }
>   
> +#endif /* !CONFIG_USER_ONLY */

These functions should all be used in user-mode emulation as well.

>   /***** Steps involved on loading and filtering CPUID data
>    *
>    * When initializing and realizing a CPU object, the steps
> @@ -7040,6 +7078,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>           }
>       }
>   
> +#ifndef CONFIG_USER_ONLY
>       if (!kvm_enabled() || !cpu->expose_kvm) {
>           env->features[FEAT_KVM] = 0;
>       }

This is "!kvm_enabled()" so it should be kept for user-mode emulation.

> @@ -7111,6 +7150,8 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>           return;
>       }
>   
> +#endif /* !CONFIG_USER_ONLY */
>       /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly set */
>       if (env->cpuid_level_func7 == UINT32_MAX) {
>           env->cpuid_level_func7 = env->cpuid_min_level_func7;
> @@ -7152,6 +7193,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>           mark_unavailable_features(cpu, w, unavailable_features, prefix);
>       }
>   
> +#ifndef CONFIG_USER_ONLY
>       if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
>           kvm_enabled()) {
>           KVMState *s = CPU(cpu)->kvm_state;
> @@ -7179,6 +7221,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>               mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, prefix);
>           }
>       }
> +#endif

This need not be limited to KVM, it can likewise use 
x86_cpu_get_supported_cpuid.

Paolo

>   }
>   
>   static void x86_cpu_hyperv_realize(X86CPU *cpu)

