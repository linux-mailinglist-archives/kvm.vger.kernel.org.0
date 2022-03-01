Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C34C95EC
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 21:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbiCAUSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 15:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbiCAUSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 15:18:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55E1C2E6B9
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 12:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9aSLGBmnPIAJJgrzBhmaCFv1mrgnWp3DUsr0iZuWKl4=;
        b=B/4sbUVsH4nLOkUnMuDaAiSqSWRuh0Gyf9mfWvkYv0i8Jx2pUAPnn7y6bx5JjdcnpLrktv
        Bj47o7nMXk2v2h1vyNlyfR477v6iPhnxheSEYY3sYoOxCEWgBwfiUHE97qPOxBHNJXkoIW
        B/fQO441J6h0uzRJpuyM1W5/GYd6eQo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-7TgDv8oaPyCAvKfyVcsyuA-1; Tue, 01 Mar 2022 15:17:40 -0500
X-MC-Unique: 7TgDv8oaPyCAvKfyVcsyuA-1
Received: by mail-wm1-f72.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso493882wmz.0
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 12:17:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9aSLGBmnPIAJJgrzBhmaCFv1mrgnWp3DUsr0iZuWKl4=;
        b=C3bi3cus3VPkYrw2gtL2cSHQvE17/nqcZf29H6yRZjl41/GxGimf/tfz8ocEM87lGo
         jpv9YvbJtOw17kMW8jg6ObZTnufd6Q4m2f2oNuHSiaOFGHuEiYuX40ovdb9mLzA2avYb
         k6inqfd/CZRppuwfDG73AhfbR52d+DDpupqXWifEAqBg0S0a/jWMnekrrZcLwv1uy3fj
         fYRwj2x781vZ9e3N9FLVjy2npzAGEhmi7Yy5qAi7OZuxlL5JHeAagWVqN3VPj9V3sPUu
         DaR+EBZGklCGU7diK8Xd+5FjvkOAjafmBVVuN6j77+wSMwxk8KqexPAAlmMg7s4NKm8r
         WP6g==
X-Gm-Message-State: AOAM532dlhDpVzQFpqvImc2tpF0JyNf6DeS2phaI1h7osajt3uUxdMtL
        LlIF0KtjO0YBLsCn8E+o/SHfvq2lMyeEutkhDgfzndoOOcJoZu7NsCrfELHofz0FvSE85GSTF/i
        DAxvI55OOnlpe
X-Received: by 2002:a05:600c:3ba9:b0:381:1044:6fd3 with SMTP id n41-20020a05600c3ba900b0038110446fd3mr17960233wms.77.1646165859147;
        Tue, 01 Mar 2022 12:17:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykw7EAKZADuVfNKFsUk1bMuZG85x9BmwnFWCP10oKa09IqiJQdQ6r86+8jOank6umrt77LJA==
X-Received: by 2002:a05:600c:3ba9:b0:381:1044:6fd3 with SMTP id n41-20020a05600c3ba900b0038110446fd3mr17960217wms.77.1646165858931;
        Tue, 01 Mar 2022 12:17:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b13-20020a05600c4e0d00b003816cb4892csm6799037wmq.0.2022.03.01.12.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:17:38 -0800 (PST)
Message-ID: <4665d674-db6d-13b0-a35e-d33f2f152668@redhat.com>
Date:   Tue, 1 Mar 2022 21:17:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.16 12/28] x86/kvm: Don't use pv
 tlb/ipi/sched_yield if on 1 vCPU
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-12-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201344.18191-12-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 21:13, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit ec756e40e271866f951d77c5e923d8deb6002b15 ]
> 
> Inspired by commit 3553ae5690a (x86/kvm: Don't use pvqspinlock code if
> only 1 vCPU), on a VM with only 1 vCPU, there is no need to enable
> pv tlb/ipi/sched_yield and we can save the memory for __pv_cpu_mask.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kernel/kvm.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbdad7729c..ff3db164e52cb 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -462,19 +462,22 @@ static bool pv_tlb_flush_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>   		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
> +		(num_possible_cpus() != 1));
>   }
>   
>   static bool pv_ipi_supported(void)
>   {
> -	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
> +	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
> +	       (num_possible_cpus() != 1));
>   }
>   
>   static bool pv_sched_yield_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
>   		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
> +	    (num_possible_cpus() != 1));
>   }
>   
>   #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)

NACK

Not really necessary.

Paolo

