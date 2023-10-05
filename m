Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE827BA74C
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 19:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjJERHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 13:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjJERHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 13:07:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6013C3B
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 09:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696524733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfBa2PBztZPefecPJI7ke3UbcZNr/dJZxdjNyd6oBXc=;
        b=dr7dtT+XaZ1GUUCCB9ks+MMH4V+SSCfdswXfmbzA8abA0Pe2hgAFRZOwleEjc9EOO77Dv2
        mU7J22iDc/BoUIzAIakM+viR1kjHUKjqKeFr47AQ+BFUVMJmbaCfVLLKBvvZ264EfqXvj9
        vV2mkncMSgBH6WDk9v8PmGw0HQIlHGM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-vagx0KcVNK--1RjRrjOcNg-1; Thu, 05 Oct 2023 12:52:02 -0400
X-MC-Unique: vagx0KcVNK--1RjRrjOcNg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9b65d7079faso93895466b.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 09:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696524721; x=1697129521;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hfBa2PBztZPefecPJI7ke3UbcZNr/dJZxdjNyd6oBXc=;
        b=f+3TcUcjDaGV7hfVM4joK5yEAlLQnI6eSwl3vxArA6uJzWEI6gr7rSaSoM6G0bTQMZ
         bZr9RX8lrCTSIBXNrnFuApfNnez5D8L38GFZkCFo8MQcnf62Uquf46JtCGX2qTFdf2rY
         5Q1vq1Klvok+rvxGhhn38BGO8IBjOm7SfpbYK9jh4QmUYWZJ0M3mTovJX6VmRhHpDL7U
         vOOAoWiBAm8gkt/PDRvzr8UtF8fBjmNenIxZGqUiCVtpng621IV8W65VSvmXvwVAjocH
         o0GrpYRI6u+LwextzXnY4AI7M5J2a6dgepKFrNkyucaYQIFQtV9DEOeDwccUlYQLO377
         +aRg==
X-Gm-Message-State: AOJu0YzEfxisFDW0kh91F5oheqxSgO38k9bsFdkeMeEUNaOkQ0rAgzjV
        xd6J3ypsTQmibPJkoddXMMnPJfUTiMh2iOxBIJ1AB3OWrd1o6DId4YYPrzMlfb/HTKoqjQ4KVsk
        EK4s5y/vzAk1f
X-Received: by 2002:a17:907:271a:b0:9b9:ed52:8213 with SMTP id w26-20020a170907271a00b009b9ed528213mr2108075ejk.54.1696524720982;
        Thu, 05 Oct 2023 09:52:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgssYgHWHZZXyp1cFbR2loPbqq9hiLlw7Dc8A83s5u0YNtnV3XNQusYBiNSkut41GTr1E/UQ==
X-Received: by 2002:a17:907:271a:b0:9b9:ed52:8213 with SMTP id w26-20020a170907271a00b009b9ed528213mr2108053ejk.54.1696524720646;
        Thu, 05 Oct 2023 09:52:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j18-20020a170906411200b0099ccee57ac2sm1465845ejk.194.2023.10.05.09.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 09:51:59 -0700 (PDT)
Message-ID: <4318facf-df2d-7658-39d2-d2dce1ec77d9@redhat.com>
Date:   Thu, 5 Oct 2023 18:51:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20231004002038.907778-1-jmattson@google.com>
 <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
 <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
 <CALMp9eT2qHSig-ptP461GbLSfg86aCRjoxzK9Q7dc6yXSpPn7A@mail.gmail.com>
 <ef665e55-7604-e167-7c49-739c284c248c@intel.com>
 <CALMp9eQL4m6PVVhntG9-RbY6w60pxka2tpCvTi01dQXPJ7QEJA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's
 FsGsKernelGsBaseNonSerializing
In-Reply-To: <CALMp9eQL4m6PVVhntG9-RbY6w60pxka2tpCvTi01dQXPJ7QEJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/23 18:41, Jim Mattson wrote:
>> I hope I'm not throwing stones from a glass house here...
>>
>> But I'm struggling to think of cases where Intel has read-only
>> "defeature bits" like this one.  There are certainly things like
>> MSR_IA32_MISC_ENABLE_FAST_STRING that can be toggled, but read-only
>> indicators of a departure from established architecture seems ...
>> suboptimal.
>>
>> It's arguable that TDX changed a bunch of architecture like causing
>> exceptions on CPUID and MSRs that never caused exceptions before and
>> _that_  constitutes a defeature.  But that's the least of the problems
>> for a TDX VM. 😄
>>
>> (Seriously, I'm not trying to shame Intel's x86 fellow travelers here,
>>   just trying to make sure I'm not missing something).
> Intel's defeature bits that I know of are:
> 
> CPUID.(EAX=7,ECX=0):EBX[bit 13] (Haswell) - "Deprecates FPU CS and FPU
> DS values if 1."
> CPUID.(EAX=7,ECX=0):EBX[bit 6] (Skylake) - "FDP_EXCPTN_ONLY. x87 FPU
> Data Pointer updated only on x87 exceptions if 1."

And for AMD, to get the full landscape:

- CPUID(EAX=8000_0021h).EAX[0], "Processor ignores nested data breakpoints"

- CPUID(EAX=8000_0021h).EAX[9], "SMM_CTL MSR is not present" (the MSR 
used to be always present if SVM is available)

AMD had a few processors without X86_BUG_NULL_SEG that do not expose 
X86_FEATURE_NULL_SEL_CLR_BASE, but that's conservative so not a big deal.

Paolo

