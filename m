Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA977577ECC
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 11:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiGRJjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 05:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiGRJiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 05:38:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AA32CD2
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 02:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658137132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vesu0j3GgIPn4qpg1moBWzyKr7iHeM8IBkd+1mNy3is=;
        b=NFxAc7/8/7l+reQtlkhbrp1TmbI29tMWybgwZrElv1h3LifIeELZ9oYg9mu8mWa2aMsDRq
        EMh0P2+J23FODp36NOM5Fihvx6GlsZjkY6JmhUssqgsC5ABAITDyI1F6QWgW8nFnQImk+/
        7XLHg1W2LzGoGS5ADmy+U7tH5fckM6I=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-SYKYS1x6PaCMwV_PuCNHpA-1; Mon, 18 Jul 2022 05:38:51 -0400
X-MC-Unique: SYKYS1x6PaCMwV_PuCNHpA-1
Received: by mail-qv1-f72.google.com with SMTP id lp7-20020a056214590700b004733d9feaf6so5161785qvb.0
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 02:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vesu0j3GgIPn4qpg1moBWzyKr7iHeM8IBkd+1mNy3is=;
        b=bi9DBglNa3K3TJaTsG5egHYZs0K+t4gG1TsqujNci1qTNLO+71z/bPbfCUUojOjPHp
         ZvIVaF0njb2z3lnUO/7IDo65rjH0FxomC5tsGPjiB9KCPQVqCi+aTpRHGOwh2cda6iu6
         SrQKyWQ7VSQzZgXUQNadsKRXFSVAulUsZn+CEsO3mk+VZ9fqFygrpEmba7Q10GAs3zve
         BgDQynV0EAYcdd38m4Snncf2jG4IiDnzKdQ6heCQGL7Hd8+g7j6oKl34TApiDeqlEZsp
         TezSJH+pNbfnP0iHdG6D5CVTzIvv7cqfTwtusuksYCYJCv5fAnf6jvjxseNgoQ9w+U2c
         ggpw==
X-Gm-Message-State: AJIora8ezid0E/utN7cjix9XRp1g+H96OvsZt8xwDM1cmaZ/5+ImCADX
        MEaIoGodbH5eLAMrpDtDv0jrXq7PwzecLjbKSKcfoit5lDRxlH0124KUD9ebCEAO3nBxfc9qhMM
        sJWM2i2Jj9G2c
X-Received: by 2002:a05:622a:1ba5:b0:317:c65b:3ad1 with SMTP id bp37-20020a05622a1ba500b00317c65b3ad1mr20254889qtb.117.1658137130670;
        Mon, 18 Jul 2022 02:38:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1szlag+Xp7/MglHwkYYNaZi7HYohrB3NdOzDA5n47yDL9epjySsY+PhWR7bJWfXCb38wM3Yhw==
X-Received: by 2002:a05:622a:1ba5:b0:317:c65b:3ad1 with SMTP id bp37-20020a05622a1ba500b00317c65b3ad1mr20254883qtb.117.1658137130479;
        Mon, 18 Jul 2022 02:38:50 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id q13-20020a05620a2a4d00b006b5763bffebsm10485498qkp.34.2022.07.18.02.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 02:38:49 -0700 (PDT)
Message-ID: <71585b6bfd584bf01b09d898c5702a8ab54b5308.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Fix x2APIC MSRs interception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jon.grimm@amd.com
Date:   Mon, 18 Jul 2022 12:38:47 +0300
In-Reply-To: <20220718083833.222117-1-suravee.suthikulpanit@amd.com>
References: <20220718083833.222117-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-18 at 03:38 -0500, Suravee Suthikulpanit wrote:
> The index for svm_direct_access_msrs was incorrectly initialized with
> the APIC MMIO register macros. Fix by introducing a macro for calculating
> x2APIC MSRs.
> 
> Fixes: 5c127c85472c ("KVM: SVM: Adding support for configuring x2APIC MSRs interception")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 52 ++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ba81a7e58f75..aef63aae922d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -74,6 +74,8 @@ static uint64_t osvw_len = 4, osvw_status;
>  
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
> +#define X2APIC_MSR(x)  (APIC_BASE_MSR + (x >> 4))
> +
>  static const struct svm_direct_access_msrs {
>         u32 index;   /* Index of the MSR */
>         bool always; /* True if intercept is initially cleared */
> @@ -100,31 +102,31 @@ static const struct svm_direct_access_msrs {
>         { .index = MSR_IA32_CR_PAT,                     .always = false },
>         { .index = MSR_AMD64_SEV_ES_GHCB,               .always = true  },
>         { .index = MSR_TSC_AUX,                         .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_ID),           .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_TASKPRI),      .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_ARBPRI),       .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_PROCPRI),      .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_EOI),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_RRR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LDR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_DFR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_SPIV),         .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_ISR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_TMR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_IRR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_ESR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_ICR),          .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_ICR2),         .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVTT),         .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVTTHMR),      .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVTPC),        .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVT0),         .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVT1),         .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_LVTERR),       .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_TMICT),        .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_TMCCT),        .always = false },
> -       { .index = (APIC_BASE_MSR + APIC_TDCR),         .always = false },
> +       { .index = X2APIC_MSR(APIC_ID),                 .always = false },
> +       { .index = X2APIC_MSR(APIC_LVR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_TASKPRI),            .always = false },
> +       { .index = X2APIC_MSR(APIC_ARBPRI),             .always = false },
> +       { .index = X2APIC_MSR(APIC_PROCPRI),            .always = false },
> +       { .index = X2APIC_MSR(APIC_EOI),                .always = false },
> +       { .index = X2APIC_MSR(APIC_RRR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_LDR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_DFR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_SPIV),               .always = false },
> +       { .index = X2APIC_MSR(APIC_ISR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_TMR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_IRR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_ESR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_ICR),                .always = false },
> +       { .index = X2APIC_MSR(APIC_ICR2),               .always = false },
> +       { .index = X2APIC_MSR(APIC_LVTT),               .always = false },
> +       { .index = X2APIC_MSR(APIC_LVTTHMR),            .always = false },
> +       { .index = X2APIC_MSR(APIC_LVTPC),              .always = false },
> +       { .index = X2APIC_MSR(APIC_LVT0),               .always = false },
> +       { .index = X2APIC_MSR(APIC_LVT1),               .always = false },
> +       { .index = X2APIC_MSR(APIC_LVTERR),             .always = false },
> +       { .index = X2APIC_MSR(APIC_TMICT),              .always = false },
> +       { .index = X2APIC_MSR(APIC_TMCCT),              .always = false },
> +       { .index = X2APIC_MSR(APIC_TDCR),               .always = false },
>         { .index = MSR_INVALID,                         .always = false },

Ouch.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

>  };
>  


