Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1143CAE26
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 22:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGOUzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 16:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhGOUzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 16:55:33 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72FCC06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 13:52:39 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t3so10031953edc.7
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 13:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+jMjj9qv4VxWA396ta3IcoAYh5PnskFQSMxJ3fw0f4=;
        b=TUWNYihnlIls0fFeL6dexTbqE4JqQAuzkRSbc2DUH8pqugJDTZ7XWQaBQ8z/d6hVcl
         bT5YkRF3RSp7/Z3QN9cVi9iPsyJsfBIkTPhBGgSwBfJ8R/28lECzapf8lPJ8/KOmWkjW
         Wg3lKDN0jzxbfzpN8SYDyh6Bk2N3P9MROrCFpWsl7WWZfBLhvdqtl2ZIVPvjYPUlsGxQ
         E0KPjm93ZCw7CtW7AeuG9Z4drtKcFsakb6/P26obWfbyP2jMCmOgo9uPOFu00a6/6vbP
         2/uaWh1Q2dU+l+p/+8LBn2vyK+NIEEHFFjWqi4qCKxb6tbVp/OtP2XIHTg71MauHhoXF
         7etQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+jMjj9qv4VxWA396ta3IcoAYh5PnskFQSMxJ3fw0f4=;
        b=mVuRJolwMjFetqUHVMCvfj/rxx0/FU8hz6F6PxBsbtdlxUZek7JO4eiAPbzPm6mlK0
         pXGd0lCzsUOqi6QcbYX2R7ldJz9jMJfyEtOy8ulVbYNHgpR10ePb9kCO5qFifolCoQ/H
         9MXH2NPLnrAcGNjb5e3v/sTDyinW/WPafExdzVXkQHBu6j82aJE31CaNb9Fut43ZgsAl
         ookTFoLfSiPuBvctbR760n97Gtfp6k0vGk4x2vjMnfKRZ+ZFPY9gjQFfNuTy6mpE++pB
         llIDf/R6uo8jCailau7LzZRXdsLtwn2euh0dRl6uYvrV9J4jmIcWlyXFgMBLW0PFJX7M
         MMIg==
X-Gm-Message-State: AOAM531RzkqTUrdX2/gg8ysrFvVlzwlOrTe6hoRvxyZDFNyMt5VTxqPg
        uk+he+Xz/Hmd+tvg86+TfdXR2oBai+Uof6zsOowB3g==
X-Google-Smtp-Source: ABdhPJz2mtagHGX9lBAGtkbV3Y0KFvZcpSxy4NdJHVRU3VXpQYGXw5/iqaS8N4T2qcNvFLRZd8kUuC6QII8/JY0yQuw=
X-Received: by 2002:aa7:d809:: with SMTP id v9mr9808210edq.146.1626382358395;
 Thu, 15 Jul 2021 13:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210713160957.3269017-1-ehabkost@redhat.com> <20210713160957.3269017-5-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-5-ehabkost@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 15 Jul 2021 21:51:58 +0100
Message-ID: <CAFEAcA-nif_Z0guHx4q4NUg=FEyhUz8kkAvfZ58916yp6TXT7Q@mail.gmail.com>
Subject: Re: [PULL 04/11] i386: expand Hyper-V features during CPU feature
 expansion time
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jul 2021 at 17:19, Eduardo Habkost <ehabkost@redhat.com> wrote:
>
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> To make Hyper-V features appear in e.g. QMP query-cpu-model-expansion we
> need to expand and set the corresponding CPUID leaves early. Modify
> x86_cpu_get_supported_feature_word() to call newly intoduced Hyper-V
> specific kvm_hv_get_supported_cpuid() instead of
> kvm_arch_get_supported_cpuid(). We can't use kvm_arch_get_supported_cpuid()
> as Hyper-V specific CPUID leaves intersect with KVM's.
>
> Note, early expansion will only happen when KVM supports system wide
> KVM_GET_SUPPORTED_HV_CPUID ioctl (KVM_CAP_SYS_HYPERV_CPUID).
>
> Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210608120817.1325125-6-vkuznets@redhat.com>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>

Hi; Coverity reports an issue in this code (CID 1458243):

> -static bool hyperv_expand_features(CPUState *cs, Error **errp)
> +bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> +    CPUState *cs = CPU(cpu);
>
>      if (!hyperv_enabled(cpu))
>          return true;
>
> +    /*
> +     * When kvm_hyperv_expand_features is called at CPU feature expansion
> +     * time per-CPU kvm_state is not available yet so we can only proceed
> +     * when KVM_CAP_SYS_HYPERV_CPUID is supported.
> +     */
> +    if (!cs->kvm_state &&
> +        !kvm_check_extension(kvm_state, KVM_CAP_SYS_HYPERV_CPUID))
> +        return true;

Here we check whether cs->kvm_state is NULL, but even if it is
NULL we can still continue execution further through the function.

Later in the function we call hv_cpuid_get_host(), which in turn
can call get_supported_hv_cpuid_legacy(), which can dereference
cs->kvm_state without checking it.

So either the check on cs->kvm_state above is unnecessary, or we
need to handle it being NULL in some way other than falling through.

Side note: this change isn't in line with our coding style, which
requires braces around the body of the if().

thanks
-- PMM
