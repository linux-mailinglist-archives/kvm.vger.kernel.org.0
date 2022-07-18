Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB02C577F3C
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 12:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiGRKDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 06:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiGRKDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 06:03:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81C4B228
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 03:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658138627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGHXSsXP7PESTAktQNHipdyvyQYwVAgODx9p4N2tE2M=;
        b=EMVy4j9/mAFJjZ+fO7oAF7fq6htgaDTXfoGyZpb++SSD1R5ePn/we6TFMUWZuzLD4E9Ejn
        CZTS2TWpjlJrAujDMu2Xo1sxrksf9RcnaLnTpMn7BjPcJoYCM/3rGQ2IGaa/cEobBr6WTO
        hQsyI71cU7NGFPoAnOH+w0mqoU3g0wM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-yFLkLTxqO3WBz_yoS-U1Mg-1; Mon, 18 Jul 2022 06:03:46 -0400
X-MC-Unique: yFLkLTxqO3WBz_yoS-U1Mg-1
Received: by mail-qk1-f199.google.com with SMTP id ay35-20020a05620a17a300b006b5d9646d31so5132518qkb.6
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 03:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QGHXSsXP7PESTAktQNHipdyvyQYwVAgODx9p4N2tE2M=;
        b=MPu71fqShVESyBYaIxuNy14lX/uZy67c4hog/YDS9v3+pTyqMg/m1A/5+ktUg/8xR3
         CoUluWi6j2mfHdRmFsateQE44Nmg79yEZd6tgtJDvF9mMpbVZVd+lHKkvzhirbAZTX9a
         uREK98TiJQIfcx3pSIN2eTelxxmqT18mizuOtK0Kz6lB07gP3/sfXJUs/0/EWHSJrP8a
         cp0YNXBybb4Y5hkbjTn7zvkJNyFqS0RAE3MC6EJAuEBrYEAmgPPeukDv4fHok+iaENAN
         fu8hTEmlFGzedgP7spHpNdFRYjzZsQTZwpfyFmlLRf+J0VofKidgnnJFgzHceeSDmbDt
         xfKw==
X-Gm-Message-State: AJIora/7BZeKgeIYyFLD1fHhnvHLWAzIZ0klhTGnp9N9fhiILmLca0O3
        swK4oc8Ok+DNH/Ff7zJAK92upJOeQwCp6Rnq3GXXa8CMZhdqD+zJDE1N4sacKIryE0dAyi8KXbb
        qlf6F0xPUYT4U
X-Received: by 2002:a05:620a:4488:b0:6b5:7f1e:8c2f with SMTP id x8-20020a05620a448800b006b57f1e8c2fmr16659012qkp.194.1658138625400;
        Mon, 18 Jul 2022 03:03:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vo/gSt3GUFzqY05R/Cm0HFmrWCsYh4Swh2WaxFn8/+rL0N+Or2SE4fsyYlt/W9yYpUPoHaJA==
X-Received: by 2002:a05:620a:4488:b0:6b5:7f1e:8c2f with SMTP id x8-20020a05620a448800b006b57f1e8c2fmr16659000qkp.194.1658138625142;
        Mon, 18 Jul 2022 03:03:45 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id x9-20020a05620a448900b006b59f4f66d6sm11100430qkp.112.2022.07.18.03.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 03:03:44 -0700 (PDT)
Message-ID: <2c8fd8e1179fc63084ec451496df5b68caae2756.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: x86: Drop unnecessary goto+label in
 kvm_arch_init()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 18 Jul 2022 13:03:41 +0300
In-Reply-To: <20220715230016.3762909-3-seanjc@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
         <20220715230016.3762909-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 23:00 +0000, Sean Christopherson wrote:
> Return directly if kvm_arch_init() detects an error before doing any real
> work, jumping through a label obfuscates what's happening and carries the
> unnecessary risk of leaving 'r' uninitialized.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 12199c40f2bc..41aa3137665c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9146,21 +9146,18 @@ int kvm_arch_init(void *opaque)
>  
>         if (kvm_x86_ops.hardware_enable) {
>                 pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
> -               r = -EEXIST;
> -               goto out;
> +               return -EEXIST;
>         }
>  
>         if (!ops->cpu_has_kvm_support()) {
>                 pr_err_ratelimited("kvm: no hardware support for '%s'\n",
>                                    ops->runtime_ops->name);
> -               r = -EOPNOTSUPP;
> -               goto out;
> +               return -EOPNOTSUPP;
>         }
>         if (ops->disabled_by_bios()) {
>                 pr_err_ratelimited("kvm: support for '%s' disabled by bios\n",
>                                    ops->runtime_ops->name);
> -               r = -EOPNOTSUPP;
> -               goto out;
> +               return -EOPNOTSUPP;
>         }
>  
>         /*
> @@ -9170,14 +9167,12 @@ int kvm_arch_init(void *opaque)
>          */
>         if (!boot_cpu_has(X86_FEATURE_FPU) || !boot_cpu_has(X86_FEATURE_FXSR)) {
>                 printk(KERN_ERR "kvm: inadequate fpu\n");
> -               r = -EOPNOTSUPP;
> -               goto out;
> +               return -EOPNOTSUPP;
>         }
>  
>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>                 pr_err("RT requires X86_FEATURE_CONSTANT_TSC\n");
> -               r = -EOPNOTSUPP;
> -               goto out;
> +               return -EOPNOTSUPP;
>         }
>  
>         /*
> @@ -9190,21 +9185,19 @@ int kvm_arch_init(void *opaque)
>         if (rdmsrl_safe(MSR_IA32_CR_PAT, &host_pat) ||
>             (host_pat & GENMASK(2, 0)) != 6) {
>                 pr_err("kvm: host PAT[0] is not WB\n");
> -               r = -EIO;
> -               goto out;
> +               return -EIO;
>         }
>  
> -       r = -ENOMEM;
> -
>         x86_emulator_cache = kvm_alloc_emulator_cache();
>         if (!x86_emulator_cache) {
>                 pr_err("kvm: failed to allocate cache for x86 emulator\n");
> -               goto out;
> +               return -ENOMEM;
>         }
>  
>         user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
>         if (!user_return_msrs) {
>                 printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
> +               r = -ENOMEM;
>                 goto out_free_x86_emulator_cache;
>         }
>         kvm_nr_uret_msrs = 0;
> @@ -9235,7 +9228,6 @@ int kvm_arch_init(void *opaque)
>         free_percpu(user_return_msrs);
>  out_free_x86_emulator_cache:
>         kmem_cache_destroy(x86_emulator_cache);
> -out:
>         return r;
>  }
>  


I honestly don't see much value in this change, but I don't mind it either.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


