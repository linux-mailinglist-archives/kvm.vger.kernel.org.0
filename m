Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906706D599C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjDDH3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjDDH2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:28:43 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2A32723
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:28:01 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso21190948wms.1
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 00:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680593236;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GTyv4EerpkHp6wzR4lt77hWmlvAQav0NhyjekFGVHt4=;
        b=U/irfhWrjJRztxCEp2SCNPBbOEDOo2rwXZNc8/eUMttlcvVg5gSzU6yENDa1KYFMDY
         5UzcvFXL7MiC1dDZuCAYsEEfY1MvOoBApf9SeGAQ9EY6sp0DkNTm2P7/X9EcCBzN/bPp
         EuBolWSLDP9MslRBa0hWJLDjl91+oO1FXTRIFrZQGrBpqbxmvpfnDbyr2WLnXT8Ag9E/
         98YF4pyVstZdbp6yAj15oKhAs32oeADYzl835wq0FzC5XqqflLldCUkiT1iigMSZTpJL
         gBoKUf1wDJDzWGKZdT71GnjVjnpB52EEgHB/MQd/oipB/3Gbf6fXcawTuq9YS37jTQEq
         dr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593236;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GTyv4EerpkHp6wzR4lt77hWmlvAQav0NhyjekFGVHt4=;
        b=N9Ar3Lj/FRO5DIJX9kToGUdGMZLdgf/MyRgXUpYEWjAkLVPbayMg3l1c8XW304xmbC
         27r0bwBHktOb84Iu8vWwZq/XhSqq3RLuOIqb4RI77WjpetmS8jK+kEH75Nr2vR0qHVxB
         8d1GY+3NT8LqbhFTZEmSdp7zTFcL5HBELLuiaKMZt3+eet4EdceoeioVgI1nE+tmPmfg
         jcgJawPObhRoqH2dMCvfrIuTNnZl21dtqOUsrT9zWAh7AMz8+/DUNxCnOi3Kgd10KPg4
         uW7g+/3tKdYYZ++5NrAg6lkWFIyJ6ulBP4B5uG1phsqqrfOlfLrnsfdrB1liTLh8hikB
         BtGw==
X-Gm-Message-State: AAQBX9calY4xOBAvVl87MqIr+h5IC/Nwmb3tfrRuo863BNsA9ImVpExj
        pbPPCuaz7w4LbDHrl9CGLKzBORCF0YadFb4Qqc8=
X-Google-Smtp-Source: AKy350b5EGFEkdcrPWOeYh/0HMdKcxLVgYqL0rUxdBb4Mvz7Ngqn7VS1pxDPxKm7/joQfxmi6dCL7A==
X-Received: by 2002:a05:600c:2154:b0:3f0:49b5:f0ce with SMTP id v20-20020a05600c215400b003f049b5f0cemr1381694wml.12.1680593236644;
        Tue, 04 Apr 2023 00:27:16 -0700 (PDT)
Received: from ?IPV6:2003:f6:af30:ed00:28b2:14b5:eef8:4b0b? (p200300f6af30ed0028b214b5eef84b0b.dip0.t-ipconnect.de. [2003:f6:af30:ed00:28b2:14b5:eef8:4b0b])
        by smtp.gmail.com with ESMTPSA id f11-20020a7bc8cb000000b003edff838723sm14209701wml.3.2023.04.04.00.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:27:16 -0700 (PDT)
Message-ID: <ddadeb78-52ff-4120-499e-e2bdac31a036@grsecurity.net>
Date:   Tue, 4 Apr 2023 09:27:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation
 support
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net> <ZCtpgGaRN+B91B3G@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCtpgGaRN+B91B3G@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.04.23 02:04, Sean Christopherson wrote:
> On Mon, Apr 03, 2023, Mathias Krause wrote:
>> Add support to enforce access tests to be handled by the emulator, if
>> supported by KVM. Exclude it from the ac_test_exec() test, though, to
>> not slow it down too much.
> 
> IMO, the slowdown is nowhere near bad enought to warrant exclusion.  On bare metal
> without KASAN and other debug gunk, the total runtime with EPT enabled is <6s.
> With EPT disabled, it's <8s.  In a VM, they times are <16s and <26s respectively.
> Those are perfectly reasonable, and forcing emulation actually makes the EPT case,
> interesting.  And the KASAN/debug builds are so horrendously slow that I think we
> should figure out a way to special case those kernels anyways.

You must have a more beefy machine than I do. Testing bare metal on a
NUC12 (i7-1260P) with kvm.ko loaded with force_emulation_prefix=1 and
not excluding AC_FEP_BIT from ac_test_bump() gives me a runtime of
little over 41s with EPT enabled and, funnily, only 9s with EPT
disabled, as that implicitly excludes the CR4.PKE tests, reducing the
number of tests to run by a factor of 10 (~38 million tests down do 3.8
million). The non-EPT run took 56s in a VM but the EPT one ran into the
90s timeout. After lifting that, it was 2m22s. :/

For comparison, the runtime of the access test on bare with this series
applied as-is is 10s with EPT enabled and 5s with EPT disabled. In a VM
I get 10s with EPT and 29s without.

> 
> If you don't object, I'll include FEP as a regular flag when applying.

My concerns are that the additional FEP access tests will push the
runtime over the 90s limit not only for my setup but for some CI setups
as well, as they are notoriously resource constraint (and I vaguely
remember a discussion about already hitting timeouts for the gitlab CI
pipeline?).

So yes, I do object. Please keep the AC_FEP_BIT excluded from the
ac_test_bump() tests. It'll cause trouble for CI setups, I'm certain.

> 
> One other fun thing the usage from vmx_pf_exception_test_guest(), which runs afoul
> of a KVM bug.  The VMX #PF test runs the access test as an L2 guest (from KVM's
> perspective), i.e. triggers emulation from L2.  KVM's emulator is goofy and checks
> nested intercepts for PAUSE even on vanilla NOPs.  SVM filters out non-PAUSE instructions
> on the backend, but VMX does not (VMX doesn't have any logic for PAUSE interception
> and just ends up injecting a #UD).

Hehe, nice :D

> 
> I'll post this as a KVM patch.
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9ae4044f076f..1e560457bf9a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7898,6 +7898,21 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>                 /* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
>                 break;
>  
> +       case x86_intercept_pause:
> +               /*
> +                * PAUSE is a single-byte NOP with a REPE prefix, i.e. collides
> +                * with vanilla NOPs in the emulator.  Apply the interception
> +                * check only to actual PAUSE instructions.  Don't check
> +                * PAUSE-loop-exiting, software can't expect a given PAUSE to
> +                * exit, i.e. KVM is within its rights to allow L2 to execute
> +                * the PAUSE.
> +                */
> +               if ((info->rep_prefix != REPE_PREFIX) ||
> +                   !nested_cpu_has2(vmcs12, CPU_BASED_PAUSE_EXITING))
> +                       return X86EMUL_CONTINUE;
> +
> +               break;
> +
>         /* TODO: check more intercepts... */
>         default:
>                 break;
> 

Thanks,
Mathias
