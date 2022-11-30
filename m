Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CC663D753
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 14:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiK3N53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 08:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiK3N5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 08:57:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBDF490A8
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 05:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669816586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hvhyImnGPgOwYgAh4lRXR6RXaGv3YhLnuIS7/eXf+TI=;
        b=DRDjGrb+I5MAsGFmhiiVPLSuOMjqLFnbhVTqrcU6RwUsR++8DwuXxaY6RawtL8s8dPqNDN
        pf/lIq3mEqz21w8i47CEwFBbkArqajQjDfYZVTjJzY89zknv93oaKkEEMvLH9pdrPiyVfn
        z6EPDWQcIiqfH9PXZ3uzsO7m7yobx1Q=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-199-0yyk6PZbNRqxnwmuEpDU-g-1; Wed, 30 Nov 2022 08:56:25 -0500
X-MC-Unique: 0yyk6PZbNRqxnwmuEpDU-g-1
Received: by mail-pf1-f199.google.com with SMTP id y11-20020a056a00190b00b005749340b8a8so14024098pfi.11
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 05:56:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hvhyImnGPgOwYgAh4lRXR6RXaGv3YhLnuIS7/eXf+TI=;
        b=BU+2aHIawK4+iWZkeAOD7Xuj4hRJmV8URW4ZtcnyyBYlAl7P1/TnAJpLkft11dwXP+
         xvlx6NZ79nbatV1jdXMKoqRIrXESgwOTIkPOrSQ+cKYLVTFG4MIYreovZaf7xyVasBYG
         SwSrQwuBj5wnrTYOxiNYdjMB1d9QAnyADOvZncU9WExZEND8M8jtexrT6AcA7AChk4NR
         OaG3sEisQMjA9HX3JYe2MeZXzPwOKdX9TB3HEbpT/l46CFqeQxA4VV3FFT1GIkslbVk/
         fLbrsaPyhaknyh3nxGqcIeL+tePvFBZVbZV/EuYUKdlS+U2mcLk2JtRHYkcq8h9ydxeD
         24XA==
X-Gm-Message-State: ANoB5pnz4ncPiKtTIkIuXBe2KUS+AoANOHjjpvALgRNP1yk6P/kzXKj4
        P/ngyd2wYZqQqB5+MGDIWgzRWaodzQYkLvEnuoDt9gtAf+6wQpU/+dsNpvqJeGbgRhfNqcOFrGl
        KPsyFoKYUq9+EmnG95I72xPqqpP7f
X-Received: by 2002:a17:90b:3012:b0:219:63d9:516c with SMTP id hg18-20020a17090b301200b0021963d9516cmr3375678pjb.108.1669816584184;
        Wed, 30 Nov 2022 05:56:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7gTxtDlma6yfKgNxKNGKbn5MkQyJ58VEkajGKjGYTx8ZscS0WF/VSKnfAiYctGsSrV0WsLNZEHRPrqIeJ9K3Q=
X-Received: by 2002:a17:90b:3012:b0:219:63d9:516c with SMTP id
 hg18-20020a17090b301200b0021963d9516cmr3375659pjb.108.1669816583766; Wed, 30
 Nov 2022 05:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20221129203240.1815829-1-aaronlewis@google.com>
In-Reply-To: <20221129203240.1815829-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 30 Nov 2022 14:56:11 +0100
Message-ID: <CABgObfYgh--5mhBZw63hRE7ioQgNRS8ga0TDdPkRc-yahTmsfg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Fix test failures as a result of
 using clang-18
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, jsperbeck@google.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

On Tue, Nov 29, 2022 at 9:33 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When building 'debug' test on clang-18 the compiler more aggressively
> inlines helper functions.  This results in test failures because some
> of the helpers are not intended to be inlined.  Fix this by marking
> those functions with 'noinline'.
>
> Reported-by: John Sperbeck <jsperbeck@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/debug.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/x86/debug.c b/x86/debug.c
> index b66bf04..65784c5 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -128,7 +128,7 @@ static void report_singlestep_basic(unsigned long start, const char *usermode)
>                "%sSingle-step #DB basic test", usermode);
>  }
>
> -static unsigned long singlestep_basic(void)
> +static noinline unsigned long singlestep_basic(void)
>  {
>         unsigned long start;
>
> @@ -165,7 +165,7 @@ static void report_singlestep_emulated_instructions(unsigned long start,
>                "%sSingle-step #DB on emulated instructions", usermode);
>  }
>
> -static unsigned long singlestep_emulated_instructions(void)
> +static noinline unsigned long singlestep_emulated_instructions(void)
>  {
>         unsigned long start;
>
> @@ -204,7 +204,7 @@ static void report_singlestep_with_sti_blocking(unsigned long start,
>  }
>
>
> -static unsigned long singlestep_with_sti_blocking(void)
> +static noinline unsigned long singlestep_with_sti_blocking(void)
>  {
>         unsigned long start_rip;
>
> @@ -239,7 +239,7 @@ static void report_singlestep_with_movss_blocking(unsigned long start,
>                "%sSingle-step #DB w/ MOVSS blocking", usermode);
>  }
>
> -static unsigned long singlestep_with_movss_blocking(void)
> +static noinline unsigned long singlestep_with_movss_blocking(void)
>  {
>         unsigned long start_rip;
>
> @@ -277,7 +277,7 @@ static void report_singlestep_with_movss_blocking_and_icebp(unsigned long start,
>                "%sSingle-Step + ICEBP #DB w/ MOVSS blocking", usermode);
>  }
>
> -static unsigned long singlestep_with_movss_blocking_and_icebp(void)
> +static noinline unsigned long singlestep_with_movss_blocking_and_icebp(void)
>  {
>         unsigned long start;
>
> @@ -320,7 +320,7 @@ static void report_singlestep_with_movss_blocking_and_dr7_gd(unsigned long start
>                "Single-step #DB w/ MOVSS blocking and DR7.GD=1");
>  }
>
> -static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
> +static noinline unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
>  {
>         unsigned long start_rip;
>
> --
> 2.38.1.584.g0f3c55d4c2-goog
>

