Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259495B902C
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 23:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiINVqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 17:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiINVqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 17:46:30 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E8580E84
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 14:46:29 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1278a61bd57so44686247fac.7
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=EzEx6lfTQnhv0AgnCCoqoCsDj6wiEILd1WznFoZclbg=;
        b=dMLNpwdsischAJInPbWwXevVFs7LQULXimj5XE3XZbfLwfP84vUbduSF7YkeVz9KAS
         UByPQNRGz/5RnuTSrVuceU1Sb3x4K1PR4fXyKEzKu92n/YrhQ1htEd5EZpybPUSSlrs5
         CxJRng3OKwnSgv2DXV4EAyKvNcXE9W2nSAi2ZRV2hkUe/l9YNypkyNaPgzo7U14hLHta
         PYn7j+VFojFxUHhsCS6400PatuZljhwXH7P7D00KH5PwVA6dncTuBZgWSMtYZWD3Kgov
         c+ghdEQobT3qz7kyJOCiuEGsrxzvDNh4msdIYxHKyHEei2pvyRbjuyWa6SNcsePgoYJF
         7FqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EzEx6lfTQnhv0AgnCCoqoCsDj6wiEILd1WznFoZclbg=;
        b=iTT5V/6WV+S+qsfKq7cS1grVKRLadw95A09cY7gAeqOMAe1Q7NVeTee6ArVA4C9O4+
         vu8/w0HtqX4yIEQd64QDwEvlTi17/3fB2/Bd3NG9Jm/YvmkvZMnK0yyeEXi0d1mLvuSd
         3nS/iQKPiwjidb8no/dP/DEaiM0dXBnO9poeu70q7YCYovYLRahPvcatZHLbAmgRqNXT
         wkeZrryX84t2omllYiuax+vSWH7RyR2rJAWV3FwuI0C/ymdfB1n9E05njXBQ8L84OVVe
         730+A4c9HDjnuki9QMPFpJ7pnc2FOhqamE4BPzWJ8T83G4FTA8y5pkvFZxRpRC4ky8Yf
         WEGg==
X-Gm-Message-State: ACgBeo1wHNLL12XEF/M1L1KWFI+Ojy7F5IYfFb/DhwoqV8UIN6HFuvCB
        ddtpD243quxNTSEEcu2J8IQOqRFILcr6dCf/pUedGw==
X-Google-Smtp-Source: AA6agR5rZhIXArGNHvQZC2+tQzNwvpKg5dXZXlSW/9Nb8/5qJK4v6N2Q9RKjhngvv22DvXgLUpRLGamt/wBAm47vh5Q=
X-Received: by 2002:a05:6808:151f:b0:350:1b5e:2380 with SMTP id
 u31-20020a056808151f00b003501b5e2380mr1698266oiw.112.1663191988444; Wed, 14
 Sep 2022 14:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220525173933.1611076-1-venkateshs@chromium.org>
In-Reply-To: <20220525173933.1611076-1-venkateshs@chromium.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 14:46:17 -0700
Message-ID: <CALMp9eSTg+FQAk+LX9qspOLZ9bt0ou=1U-fymcK9FVmSwBautg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Inject #GP on invalid write to APIC_SELF_IPI register
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm@vger.kernel.org, seanjc@google.com, marcorr@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 10:40 AM Venkatesh Srinivas
<venkateshs@chromium.org> wrote:
>
> From: Marc Orr <marcorr@google.com>
>
> From: Venkatesh Srinivas <venkateshs@chromium.org>
>
> The upper bytes of the x2APIC APIC_SELF_IPI register are reserved.
> Inject a #GP into the guest if any of these reserved bits are set.
>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> ---
>  arch/x86/kvm/lapic.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 21ab69db689b..6f8522e8c492 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2169,10 +2169,16 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>                 break;
>
>         case APIC_SELF_IPI:
> -               if (apic_x2apic_mode(apic))
> -                       kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
> -               else
> +               /*
> +                * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
> +                * the vector, everything else is reserved.
> +                */
> +               if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK)) {
>                         ret = 1;
> +                       break;
> +               }
> +               kvm_lapic_reg_write(apic, APIC_ICR,
> +                                   APIC_DEST_SELF | (val & APIC_VECTOR_MASK));

Masking off the high bytes of 'val' is redundant here.

>                 break;
>         default:
>                 ret = 1;
> --
> 2.36.1.124.g0e6072fb45-goog
>
