Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EDF42995A
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 00:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhJKWOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 18:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbhJKWOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 18:14:14 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07956C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 15:12:14 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k2-20020a056830168200b0054e523d242aso13936105otr.6
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 15:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BfsWRyXcZk7G+Q/kIv7Szt5lWpWrjTVAwzYCkOvVQCU=;
        b=RBMonhbWbjB/OijxcZmqUKWO8OC5i8vs4gFK1WnlO+WsPwPZTWi7T2OQ4zHIGLwFy/
         YwPMBu4nQqX66EiA9eAzfrprNtIYQFO0BCRidl393RM5yZbUWEtoKyQjKRu03CY8Z4bi
         sS5cxYI8inEf8n5TqfJpsVqi8FzlWtu2eY81TKtlRfWPq3Oz1P0p5SGulp3tUFtlNoId
         l9hjODmO+RWzpD+oZATB88EzuRwOGNehfri2Loj/++X0SytjvbB6n+wEioU1tHY++7lb
         fkQe5wRFTnoaxWcLxjqZXQ4IcoD6HNP6ZVq/lzVsNqsAW3c+R4RG71hLLuKmd6KTkRXV
         Iiaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BfsWRyXcZk7G+Q/kIv7Szt5lWpWrjTVAwzYCkOvVQCU=;
        b=W6XSjpOiNpvxt4dv7vjw3IOmOEEeQQehOWqw4nUJlvXUYTn7l3xtKMPouEpiU00wwL
         45rreyqLZK0X2ZBUuirEq/e/YtcIY4zM9yL5RRVeRmNV/EakVV4FGfJEIuu5d+b0etnI
         5ECWdlobePSBiYqLXNPcs8QWTc0WpzTGGcIH2LNxdXdomfGK7HMs5uL13gz+BvMOgTXN
         T90GNK/KVJA/wdjzi+drJc+pZNzeGKGoHSi4HuzG38l01gJRvkwyv3Uw7nBYpnpEZq+p
         o5U9E5LntHuIC85v7JFdzS42PFdy1059/a1O8ZZO7QhBeA55dohMNOLeuqN0FvzM64yO
         Kc3Q==
X-Gm-Message-State: AOAM532iX14kh4FqV6HF2WHSTiULPsqcfpyXPFQvNyNMmuolpjIoPePl
        2Z7R3YHBQ0JeQMtmzjvVngHSRbuOBDJ5HrzOMN77A2BVl7s=
X-Google-Smtp-Source: ABdhPJxIibC0W5HdxRUGA+uqH9+Sv8l/3yl49/hjGVpBYEpckN00uYZ0gnwF/EgL7v0QYVsD2q535Cc+rV3Bi2fYWVU=
X-Received: by 2002:a9d:7114:: with SMTP id n20mr14140935otj.25.1633990333043;
 Mon, 11 Oct 2021 15:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20211011182853.978640-1-venkateshs@chromium.org> <YWSxIbjY6j5x4dyP@google.com>
In-Reply-To: <YWSxIbjY6j5x4dyP@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 11 Oct 2021 15:12:02 -0700
Message-ID: <CAA03e5F0VxoB4YVz=E4R4CrTkXPh2ncPRceETJQAZ2cwhe_i3g@mail.gmail.com>
Subject: Re: [PATCH] kvm: Inject #GP on invalid writes to x2APIC registers
To:     Sean Christopherson <seanjc@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >  arch/x86/kvm/lapic.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 76fb00921203..96e300acf70a 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2126,13 +2126,15 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >                       ret = 1;
> >               break;
> >
> > -     case APIC_SELF_IPI:
> > -             if (apic_x2apic_mode(apic)) {
> > +     case APIC_SELF_IPI: {
>
> Braces on the case statement are unnecessary (and confusing).

I guess the original patch defined an intermediate case-local var. I
agree, the case braces can be removed in this version.

Also, thanks for upstreaming this, Venkatesh! I read through Sean's
feedback, and it is all fine with me.
