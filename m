Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC45749DF
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiGNJ7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiGNJ7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:59:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19469D47
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657792771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXjYUn/LR7t2A7uSGt42ou7GfATznOMUig3WAXqM26I=;
        b=P4I2aWxX3qqWJGLLuqySm0FylrEEQP3XrhAJIlSv29GXWBX06J2F83Vk/Aqg3Pw2V4b2f8
        viYCsmGPbL6gFbwZKZBFGH4kXXDr+uFP0Xl1xAgtsP0Ct+iJnlw8RQW3Rq8bf3VmU+gvXO
        shNvswVSR0K38iDj35ieUpY5n2cHfL8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-rImiKIE0OnW0hgVEXEzSuQ-1; Thu, 14 Jul 2022 05:59:29 -0400
X-MC-Unique: rImiKIE0OnW0hgVEXEzSuQ-1
Received: by mail-wm1-f72.google.com with SMTP id v67-20020a1cac46000000b003a2be9fa09cso439297wme.3
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zXjYUn/LR7t2A7uSGt42ou7GfATznOMUig3WAXqM26I=;
        b=Fmqgmv8YiHxM5jwilzL+jqq0roIDZfB+he0Kxr5L/uRJv0Jfct+OwRukzuoEmkohxm
         daxtCFkEhzYb4bP4emEPonpkx/xq5E3Wbn0D4D1DJcCFv7IR6zxrOZDT/YTMA7wukb7N
         RioYt8UwmoQ9EDOm7tfUMoTAuYSiST+HRRRio7cdaxRnOR6pH2SiTRdPu9+Ub6+KK65g
         DRzUwEaZ28ygrogER8jhdCQecnXOTua+jlxf2A8ZRGlEfaiPw6xxnHH18yiV2Q54nh6M
         MYmG99rBGY6J0TaUHAiwQZw5K4GbrERZuUczUaMBRc3cGx5HM6FnQuaV5BKuT/18Bfp3
         MvHw==
X-Gm-Message-State: AJIora8Bib2VaBpV2Ev3Fqn6YtazcV+/MmM2g0E36gsUKki0Bl/m1vYf
        uBy61FQAh9tPZQvG4Xhfw1Cqe+fKrdUsN+xloR1RUd1OVaFbDCDejrhscBk7jOeBQ/Tu/tvMwHm
        y3iq3FxdoVyV/
X-Received: by 2002:a05:6000:184f:b0:21d:a1fb:4581 with SMTP id c15-20020a056000184f00b0021da1fb4581mr7681671wri.651.1657792768133;
        Thu, 14 Jul 2022 02:59:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v00Jsb6xlCiW+CE/1WE8v9/+VZRxbnmbKMKK2zx0OxH5+3894bMwSHl46djcMyHIlcOpK15Q==
X-Received: by 2002:a05:6000:184f:b0:21d:a1fb:4581 with SMTP id c15-20020a056000184f00b0021da1fb4581mr7681655wri.651.1657792767963;
        Thu, 14 Jul 2022 02:59:27 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id p6-20020a05600c358600b003a2e2ba94ecsm4693716wmq.40.2022.07.14.02.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:59:27 -0700 (PDT)
Message-ID: <849757ed499c4190762a28a1bbf819382abaf22c.camel@redhat.com>
Subject: Re: [PATCH v4 06/25] KVM: x86: hyper-v: Cache
 HYPERV_CPUID_NESTED_FEATURES CPUID leaf
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 12:59:25 +0300
In-Reply-To: <20220714091327.1085353-7-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
         <20220714091327.1085353-7-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 11:13 +0200, Vitaly Kuznetsov wrote:
> KVM has to check guest visible HYPERV_CPUID_NESTED_FEATURES.EBX CPUID
> leaf to know which Enlightened VMCS definition to use (original or 2022
> update). Cache the leaf along with other Hyper-V CPUID feature leaves
> to make the check quick.
> 
> While on it, wipe the whole 'hv_vcpu->cpuid_cache' with memset() instead
> of having to zero each particular member when the corresponding CPUID entry
> was not found.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/hyperv.c           | 17 ++++++++---------
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index de5a149d0971..077ec9cf3169 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -616,6 +616,8 @@ struct kvm_vcpu_hv {
>                 u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
>                 u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
>                 u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
> +               u32 nested_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
> +               u32 nested_ebx; /* HYPERV_CPUID_NESTED_FEATURES.EBX */
>         } cpuid_cache;
>  };
>  
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e08189211d9a..a8e4944ca110 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2005,31 +2005,30 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
>  
>         hv_vcpu = to_hv_vcpu(vcpu);
>  
> +       memset(&hv_vcpu->cpuid_cache, 0, sizeof(hv_vcpu->cpuid_cache));
> +
>         entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES, 0);
>         if (entry) {
>                 hv_vcpu->cpuid_cache.features_eax = entry->eax;
>                 hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
>                 hv_vcpu->cpuid_cache.features_edx = entry->edx;
> -       } else {
> -               hv_vcpu->cpuid_cache.features_eax = 0;
> -               hv_vcpu->cpuid_cache.features_ebx = 0;
> -               hv_vcpu->cpuid_cache.features_edx = 0;
>         }
>  
>         entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
>         if (entry) {
>                 hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
>                 hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
> -       } else {
> -               hv_vcpu->cpuid_cache.enlightenments_eax = 0;
> -               hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
>         }
>  
>         entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES, 0);
>         if (entry)
>                 hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
> -       else
> -               hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
> +
> +       entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES, 0);
> +       if (entry) {
> +               hv_vcpu->cpuid_cache.nested_eax = entry->eax;
> +               hv_vcpu->cpuid_cache.nested_ebx = entry->ebx;
> +       }
>  }
>  
>  int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)

Makes sense, looks good.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


