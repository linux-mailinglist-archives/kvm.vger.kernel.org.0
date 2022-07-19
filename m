Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE52F57A6F8
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbiGSTLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiGSTLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:11:50 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D73F46DA7
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:11:49 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id r24so1721670plg.3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5euGlNmAtOuwJge1OAZFWWG5YnuElfsaMVS/8+pCung=;
        b=lYQH+CDAn8WlY9EcQ7lCQ2O1WMC+gU8t3Rx9MbHBA0vhwKJoliK4rvn1HphmSRntq4
         Kg1d6NVzXVy58nXoP565l0UjAFOCEczZKjyLc6sSZnlWmWHs5hBUg18JWSanwXMYKXIG
         mt5mMAdmpMlVdS4ZqudxBwVFs9vW9mmvuNJglFRnNEnYGuHCBdwFHeK9q2oCcXG0OEXp
         PAf7c9M1SPksx49vKuh5Av3Y48SonMbZ5bljU4PXsLiAzr9vUEUsfPfzKGPCaB6E2Fyu
         nTUPeMmSNOUOTzc1uMTVKT1o7FgRnUE44iY9J2TpZuPEF+7qM6XI3PfO6jeMH3LIE6BT
         Tmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5euGlNmAtOuwJge1OAZFWWG5YnuElfsaMVS/8+pCung=;
        b=lYQy4KHVIV7S0D6ba6Gpsu9eAaWqJ3LYRfcxamPi9nBIlKHWzyF0gjYKfw1eGS+Atz
         ClYRAnNNgV+wme4B29zrdgb3KPCXHdhNgLYng9cXy/yfQpauvgIP+8hqMV6qEVLo1FYl
         /N/ScHe5qz7dETkz6XiJewb5GCA3IDF4/8sCf9nTuNRwPwFOjUhWZi3Qm2M/D7jV87U1
         ht79O6mnpWdn7A2So+fb/0M0iWf6f38u4yEAiPv0wDP+NJEr52aYVExBPM1/iAroeA0C
         539tc0+A5JXJ/eKY4DQa+qcYuKEStqR3L0e9jmZYkefXTitgZWtE3fcsav7XJsb47cuc
         nxow==
X-Gm-Message-State: AJIora/JJ7Esqb8XGiD0rwW1Njm2/OTyvP8WulpTQPrj3EaUr3Ny6/Yf
        yKAxtOJNSIPUVFEs96bIpcLZsQ==
X-Google-Smtp-Source: AGRyM1ukVRoo46Z3XwAvvEFhfpu7v8Jc2npjQaPCc2VMImHDe3eUmh5Mh0gZd69IAhwax4PCXtNX1w==
X-Received: by 2002:a17:90a:ce07:b0:1f0:d4b1:30a1 with SMTP id f7-20020a17090ace0700b001f0d4b130a1mr904119pju.165.1658257909015;
        Tue, 19 Jul 2022 12:11:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u190-20020a6279c7000000b0052b433aa45asm9004344pfc.159.2022.07.19.12.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:11:48 -0700 (PDT)
Date:   Tue, 19 Jul 2022 19:11:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, jon.grimm@amd.com
Subject: Re: [PATCH] KVM: SVM: Fix x2APIC MSRs interception
Message-ID: <YtcB8EPnqdaasng3@google.com>
References: <20220718083833.222117-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718083833.222117-1-suravee.suthikulpanit@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022, Suravee Suthikulpanit wrote:
> The index for svm_direct_access_msrs was incorrectly initialized with
> the APIC MMIO register macros. Fix by introducing a macro for calculating
> x2APIC MSRs.
> 
> Fixes: 5c127c85472c ("KVM: SVM: Adding support for configuring x2APIC MSRs interception")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 52 ++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ba81a7e58f75..aef63aae922d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -74,6 +74,8 @@ static uint64_t osvw_len = 4, osvw_status;
>  
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
> +#define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))

Once this hits kvm/queue, I'll send a follow-up series to move X2APIC_MSR() to
arch/x86/include/asm/apicdef.h.  Non-KVM APIC support open code the calculation
in multiple places, and both VMX and SVM now have their own definitions.
