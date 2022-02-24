Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8FA4C2E5E
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbiBXOZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiBXOZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:25:26 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C794BBA3;
        Thu, 24 Feb 2022 06:24:56 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a23so4721823eju.3;
        Thu, 24 Feb 2022 06:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dR0hEfdT1fYHddbPSGn/rG/f7TOIytNrZIqHUNukwRc=;
        b=FJqNZ5nnu5w/NkJ57G7P+ejks0pA078sL4JTjfHGt49QNQf/8fdkxtKGGpj2PDtIun
         ODESJT1fLMDWBlDOBM9YhAm/sZLPr192yiZpJxtAm7p9xMsNmKlpAsTDiVRShlcmPfzt
         kbzb7JDlmuW9qKdie1uGzNNmQjCuyUgv9d1aTGV3CKPMYVNGP+/N5xLKn6M09b1wrWre
         qA5ud0g92HcJYXYp42dcSXsyCiLMeYOf0Cpymk4A5yNzMirbKPMQsjcy/uOEm6Bqh/yp
         zs40WnhMl2rtBNnpDgEpemgrtiwAazGZD1T6w/t83ZEVuEryQ637uUOpsRdHgPLXaSb4
         P3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dR0hEfdT1fYHddbPSGn/rG/f7TOIytNrZIqHUNukwRc=;
        b=DxefQirr+rHjiZSQ+Bq9KqXgIuPE078Azpc76gUmf0jPF8PgMNwoyXlrmb2DYwztko
         rtVvnnR5UPfhgXovasHDsThWeii96p8jUkle01Qr9s8pX95GSnnhydoDv1H2/1XXuXOW
         fJVCfAvElQs8t21GZ+bIRuYCik6fIpjFrn66CVV9BJ3pBDifCrNzt7m5+DhuMxkFCcFt
         GgxY+erYVIz2kBvSrxd6WpwkbANWTxAsd8L6XNwEVDGHmFHlNRb9aV6xdANIeG45RIU1
         c88ELGmDaNMTPV7XIsF6ENZATFbisMLP/KNCe4gdLRXSb64HmSgdT6DdVeOxZhNsdvgq
         OwdA==
X-Gm-Message-State: AOAM532+hQoFeYPRhMWaysLi5KgpJ5BFu89LgnKGtMonDyy9ML0gQCnf
        ShKIjbaZhfgLKP9zaU9qkIzAtu17xIM=
X-Google-Smtp-Source: ABdhPJwR+/BtqQ5ctUDOqptKnn9dTi2XDRNG2sSL/zzzeMnfz99z5RsM8Cp7lLYGFff+LNRtl0a/eQ==
X-Received: by 2002:a17:907:9196:b0:69f:2625:3f2e with SMTP id bp22-20020a170907919600b0069f26253f2emr2415849ejb.575.1645712695163;
        Thu, 24 Feb 2022 06:24:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j6sm1408169eje.158.2022.02.24.06.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:24:54 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b68771ca-2f5d-f803-6c47-f426f5ce07ee@redhat.com>
Date:   Thu, 24 Feb 2022 15:24:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] KVM:VMX:Remove scratch 'cpu' variable that shadows an
 identical scratch var
Content-Language: en-US
To:     Peng Hao <flyingpenghao@gmail.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220222103954.70062-1-flyingpeng@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222103954.70062-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 11:39, Peng Hao wrote:
>   From: Peng Hao <flyingpeng@tencent.com>
> 
>   Remove a redundant 'cpu' declaration from inside an if-statement that
>   that shadows an identical declaration at function scope.  Both variables
>   are used as scratch variables in for_each_*_cpu() loops, thus there's no
>   harm in sharing a variable.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ba66c171d951..6101c2980a9c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7931,7 +7931,6 @@ static int __init vmx_init(void)
>   	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
>   	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
>   	    KVM_EVMCS_VERSION) {
> -		int cpu;
>   
>   		/* Check that we have assist pages on all online CPUs */
>   		for_each_online_cpu(cpu) {

Queued, thanks.

Paolo
