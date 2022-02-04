Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD454AA0F4
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbiBDUNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBDUNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:13:00 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C68CC061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:12:59 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so5870832ooq.10
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6Pr3l6NlNEA0LJkIla64dB8533CtDiB3/ZIs3YUWao=;
        b=SPtKZ5JE1JWSfKzj1A8yZKK18/QQ3mCVjBf5098nz140uEW17iMNsInDmypcW6nPxJ
         0lKWiQTxZtwYl0KM0NIM5BRkCkeEtYDOQwGJ9+l6BcDYMsxZLTVi+a/Z4fXat1GleUMC
         mBIEEuZkDI6P3lZCgiW/ItGBF4jm8mexp0XacnSDq1swkLQktPsR/Mv0rm6rK9y4eGrO
         RgXVd9b7LxG6gXmfbufEcYZ4ZX+VngAS4J/VSXxr3WCuUAAfN695asiELP+asEjrc4Pa
         Jq7Q/mdczIZ7TQ/ATbw6UxwLvUNKhdpX2ioycY96uUJ0EoE+YebJgfA53mTZRzvWVFmI
         V/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6Pr3l6NlNEA0LJkIla64dB8533CtDiB3/ZIs3YUWao=;
        b=Wbnfm3wpAJxch8PAiReubluXMFLtuQ3ktCYsTAO2WKtPupWEZaeU4EbiZRlJBYJhdd
         Ws0SZkvJyZNz5f5ZyCjQ0SuqD9LAiXcJU6NM3PmSQF0fAXcw6Aqs/0K+MHWaXHNbg4xn
         jKI0rTQnOKW7fTPJr8kt/x7j4kV5EiWcA7hZZnh9YLrEXARaCAU/DFWqRxCBjr9CLQHf
         1Uy8/eipEHfjyOPLYwL3NCnG3lhqUNqoXTd3pWP8dFIv8fspoJ+NfTfBA3AmVOq9yc62
         XbRz/lchsLS/sQb5ZQptc2oBYYthsXQDfnEhr0Zmukjpp98YCHIr8ELmtqi4LEkSmf6Q
         ADxg==
X-Gm-Message-State: AOAM532my5251Qmii/KPNwcd9Z8w/hoxMLUYBWGoyu4TuaQNDKtjfHKo
        92GZkJiJfUbKp0kqR29CrKmLPjPtHY8Txd0kIRPz4w==
X-Google-Smtp-Source: ABdhPJy17XdI+nE9kjUApSnj8hhpGla/6VJB7LDcEhVq6MLZlm7sgtFNBPGJjUZbIEEwbMKbJ5YbS+r0xFu1w+7Hzsw=
X-Received: by 2002:a05:6870:1150:: with SMTP id 16mr187535oag.304.1644005578582;
 Fri, 04 Feb 2022 12:12:58 -0800 (PST)
MIME-Version: 1.0
References: <20220120125122.4633-1-varad.gautam@suse.com> <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
 <Yf0GO8EydyQSdZvu@suse.de> <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
 <Yf1fHNHakPsaF8Uu@suse.de>
In-Reply-To: <Yf1fHNHakPsaF8Uu@suse.de>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 4 Feb 2022 12:12:47 -0800
Message-ID: <CAA03e5GtiLE5L32ZZrmqzwjFYxkWOjaVd2XaK074k516FQ2Fcw@mail.gmail.com>
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 4, 2022 at 9:15 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> Hi Marc,
>
> On Fri, Feb 04, 2022 at 07:57:39AM -0800, Marc Orr wrote:
> > Regarding code review and testing, I can help with the following:
> > - Compare the patches being pulled into kvm-unit-tests to what's in
> > the Linux kernel and add my Reviewed-by tags if I don't see any
> > meaningful discrepancies.
> > - Test the entire series on Google's setup, which doesn't use QEMU and
> > add my Tested-by tag accordingly. My previous Tested-by tags were on
> > individual patches. I have not yet tested the entire series.
> >
> > Please let me know if this is useful. If not, I wouldn't spend the time :-).
>
> I think it is definitly useful to run this in Googles environment too
> to get it tested and possible bugs ruled out. That can only help the
> upstream integration of these patches :)

SGTM. Thank you for the feedback.

> Varad discussed an idea with me today where the core VC handling code
> could be put into a library and used by the kernel and unit-tests and
> possibly others as well. The has the benefit that the kvm-unit-tests
> would also test the kernels VC handler paths. But it is probably
> something for the future.

Yes, I like this idea a lot. This is basically what our internal test
framework does. So if we can eventually convert this code to be a #VC
as a library, that can be used from kvm-unit-tests, Linux kernel,
UEFI, etc., that would be great.
