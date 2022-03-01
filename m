Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F554C924E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiCAR56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbiCAR5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:57:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F77E41F8A
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646157432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQhak+Su6M+EQTYweyumH4z+HcNE5OP/0buHUmVRu8g=;
        b=WCjfPl6dNzN3K2n8WgjDRs+0hpyROwXyASsaz7q1TRiTgCwysUxQvVF1dSyKUKdRh7JJh9
        uOl9uzX/Bh2QAW9O4g1h/omg2qTHRAcBViIkqUDMsvIeuvIG0wDphFVZfVFBhe2EjUB37b
        Xm98P7YpBFagIvI9sT6BQHF+b3PLr2s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-19sd1VcFO1uM2zelzIMy5w-1; Tue, 01 Mar 2022 12:57:11 -0500
X-MC-Unique: 19sd1VcFO1uM2zelzIMy5w-1
Received: by mail-wm1-f70.google.com with SMTP id az11-20020a05600c600b00b00381b45e12b7so1251540wmb.6
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NQhak+Su6M+EQTYweyumH4z+HcNE5OP/0buHUmVRu8g=;
        b=xsWidm/tvPPzCFZBShHd/iWYt2Fu+jXSbrSOqJdnxXuWt6RpgUrdPeSJooinNTtDiV
         Svd0FLyU+kt77sUdaRYUOUe8QIg+sWFlGs6GzPpV6nGjRjsfJNXBasWVvvIj4OrTt57w
         2YOTAbW3HtmOdS4k2cjGvH1Kl+WCju+kALISIL5EQkT0KowWZV/aig81MufojbjVRNft
         +TERyrNJFxLGtONsNUlIoa8ZLo7RK5u/Liumv6pjD5s7rmBxYjvr19vyjA0Ez5q9YnN0
         MKk2++nihNyFEA1GCyOKMMbF8/LgQDYtBje+fdTFRAQIN5yGejFAiJl2lUW2CGxAxvu2
         4MWg==
X-Gm-Message-State: AOAM530doQAbC0+hcEkD0OFp90gXaFaIIQsZdS7zRsOTMcmhAlyiWqn1
        p/CEggiR7Pxjrgw7POEHGyBel4uAB4G9SUmvV3YmTfqBZhymYtKUZwPMIX2bCxdXRqgM2RW1crN
        pHQkNcxEUMG5y
X-Received: by 2002:a7b:c242:0:b0:381:41c9:e745 with SMTP id b2-20020a7bc242000000b0038141c9e745mr14909325wmj.144.1646157429969;
        Tue, 01 Mar 2022 09:57:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy29uZw+EXKiJuWjJAFOrEE/wyRDCs7nO2Yul5BTjPBn/O5HD5MmiilEjca9dpK26AOibZ0Mg==
X-Received: by 2002:a7b:c242:0:b0:381:41c9:e745 with SMTP id b2-20020a7bc242000000b0038141c9e745mr14909308wmj.144.1646157429694;
        Tue, 01 Mar 2022 09:57:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id j7-20020a05600c1c0700b0037c2c6d2a91sm3927627wms.2.2022.03.01.09.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:57:09 -0800 (PST)
Message-ID: <13c4ac55-5b08-bdd9-5cfd-71e68c672825@redhat.com>
Date:   Tue, 1 Mar 2022 18:57:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] x86: kvm Require const tsc for RT
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <Yh5eJSG19S2sjZfy@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh5eJSG19S2sjZfy@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 18:55, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sun, 6 Nov 2011 12:26:18 +0100
> 
> Non constant TSC is a nightmare on bare metal already, but with
> virtualization it becomes a complete disaster because the workarounds
> are horrible latency wise. That's also a preliminary for running RT in
> a guest on top of a RT host.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   arch/x86/kvm/x86.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 82a9dcd8c67fe..54d2090d04e7a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8826,6 +8826,12 @@ int kvm_arch_init(void *opaque)
>   		goto out;
>   	}
>   
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +		pr_err("RT requires X86_FEATURE_CONSTANT_TSC\n");
> +		r = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>   	r = -ENOMEM;
>   
>   	x86_emulator_cache = kvm_alloc_emulator_cache();

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

