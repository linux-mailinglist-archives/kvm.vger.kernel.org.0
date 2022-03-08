Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8464D1C88
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241510AbiCHP7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348427AbiCHP6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:58:10 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B64350B3C
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:56:19 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id x26-20020a4a9b9a000000b003211029e80fso6064485ooj.5
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SwFPke7Gr1UGcWPkqgL/0NX1ZL3Kwja1sgGpM0B0lXc=;
        b=EkU8DIry0Y0EHH6yDRow4ZGgo5UDBvi+YZ6ReTK+1pLp9nxDQwwCj177g9p7lCzUKR
         9cqybkcLoAZndGq+/c4oLRD9SsJN0TOCaXghMU9xrLPT9MMTPNAmMLF5GTBhPiq3jUTe
         wcEWhWGKxEZOApY+Fv/07Wao04D/dvjzZ//o3kmABVpJ/XBf6gaQ5vcqjP4ohlQibLSE
         khINEaeCoq6krS9KzAXDeKV7gIlegV93GgQAXKRutjsd+zNbYh909NXV0UYxFFNxO1lv
         mOjnT9wVKkLiRrrL5soPMvjn5SWqvVuCOzHeKlVU93xSrmthdozEWV9QDQ3QGzpZw58T
         Qbuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SwFPke7Gr1UGcWPkqgL/0NX1ZL3Kwja1sgGpM0B0lXc=;
        b=Q6ppZminF7AfIz9B/B5QH/u5QoJuljjySEbs4qY9bAxnCEK8OblupE+b/FyVdAnjSE
         IoSW71GnYMA+V9gVb7wYtL5VWcj4kZmz/FRY9m8mdLW9FZpH1NUsNUqI2RiV4BVjx7FL
         WI/L6AAwZu0bj8fKzziQfmlIpQJGPBax3ISsj3E4LPyfBXmu9bTnrTIHdLh8XySVzzRm
         3c8p+wPLoSEHKW8Zys9VL2zaU85dOdNMsFyGIiQStpjv4Gsl8c/6yvcgjrzOBRJIqKg4
         h2TfeDqaXS/6nG3u8evfm9j7YAzghC0vzUx5twntSdiGjzHoslqMlvaSh+eKidOTZLUr
         7/dQ==
X-Gm-Message-State: AOAM5300eJKn7R14np7cuLYO6sHebwQ/Tp0Go0HTEgOtATWABLkAGcvC
        najEdRyi4GWW8zDB/R4/Fd52IlhVj3TiGZME+YT5OQ==
X-Google-Smtp-Source: ABdhPJz86mC/0S+lKsEKY+b7OuwttIY21p1PRTJ/ienpi9sYvBliWzE24lYxYlDe4FFvfyuz0OF4Qr3n0xtQQXDhCto=
X-Received: by 2002:a05:6870:1041:b0:d3:521b:f78a with SMTP id
 1-20020a056870104100b000d3521bf78amr2788929oaj.13.1646754978753; Tue, 08 Mar
 2022 07:56:18 -0800 (PST)
MIME-Version: 1.0
References: <20220308012452.3468611-1-jmattson@google.com> <01af48ad-fee3-603a-7b14-5a0ae52bb7f9@gmail.com>
In-Reply-To: <01af48ad-fee3-603a-7b14-5a0ae52bb7f9@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 8 Mar 2022 07:56:07 -0800
Message-ID: <CALMp9eSKGaGdoDwEs_kiokEGBih5+PxUB5kvKuwKeMcvVhypmQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Use different raw event masks for AMD and Intel
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
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

On Tue, Mar 8, 2022 at 2:29 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 8/3/2022 9:24 am, Jim Mattson wrote:
> > The third nybble of AMD's event select overlaps with Intel's IN_TX and
> > IN_TXCP bits. Therefore, we can't use AMD64_RAW_EVENT_MASK on Intel
> > platforms that support TSX.
>
> We already have pmu->reserved_bits as the first wall to check "can't use".

That is only a safeguard for Intel platforms that *don't* support TSX.

> >
> > Declare a raw_event_mask in the kvm_pmu structure, initialize it in
> > the vendor-specific pmu_refresh() functions, and use that mask for
> > PERF_TYPE_RAW configurations in reprogram_gp_counter().
> >
> > Fixes: 710c47651431 ("KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW")
>
> Is it really a fix ?

When I submitted the commit referenced above, it was not my intention
to introduce semantic changes on Intel platforms. I hadn't realized at
the time that IN_TX and IN_TXCP overlapped with bits 11:8 of AMD's
event select.

But, you are right. Previously, the code would mask off IN_TX and
IN_TXCP, just to or them back in again later. So, the aforementioned
commit did not change the semantics of the existing code; it just
rendered the statements to or the bits back in redundant.
