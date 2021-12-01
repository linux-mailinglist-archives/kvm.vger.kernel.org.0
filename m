Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7406B4659EB
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 00:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353823AbhLAXsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 18:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353809AbhLAXsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 18:48:03 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB99C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 15:44:42 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i9so27243142ilu.1
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 15:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqzOTW5eXkzj6FlzjiKmsbJBVIVlloyfRwo0n+Y/YXE=;
        b=BoKJEErBDIvVP8aBQN2xUKYa0brpU2aexQCIcqnjBmbGRn3jpb3Z6AgKGW6SOJCo9m
         5d/iv9A5VKfnXH0bCeET+JwuxvNRvaU62SyAHToIDfUyuIkCv5XmSeLqUK6Vn1plROzH
         jV5xp7NZSPhUxPYvW/AZKCshmUZzibvVOEe/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqzOTW5eXkzj6FlzjiKmsbJBVIVlloyfRwo0n+Y/YXE=;
        b=To5nM+1sQYE3v0YK58GaF/sAu50zvxqDnwBWmefAWeo7Z6t3KFuyYAS+ntqi7NlLzT
         gcHGzALnOYe9mkwTMq+/M26tKuMIVwOZzXf2An5RGzn040jI+w3NI11XSp3Xr4qTnnut
         vTEBP7lpNN9XQ9144iWOZ35jRthm4Xz54VCboxKVFMNManSgfAo5RaH4U2Xgd5UEG23r
         4Uxtslgba94eVQyDc47FCwacqNQ4HxLL0gRDqTVyWBNkNknlZVF76UjgqZEDu3fUucFJ
         mPdvn58XBpl9q5B/5jL3uGs3xVykurYW6yTl5rFdTGnOhKdqXd+a6OcW/tIdfjspDEXj
         kQRw==
X-Gm-Message-State: AOAM533K5UvpGXHKDk60MeIeRO63zJSQDrPM7HtA3TIo4hArGU8V1m2M
        FvDqQ85EKBw3yxQcoGiev7dVg+EITwwHKj9A5sPtgg==
X-Google-Smtp-Source: ABdhPJyGqLReI15PHfkWHviFDsrsXsSg1pBdEqQRI8HiR3VGmwSTv7pzJwkFG8nI+fHhUgcjwtZMHhIWZ3TCU/RA85k=
X-Received: by 2002:a05:6e02:160e:: with SMTP id t14mr12628184ilu.16.1638402281353;
 Wed, 01 Dec 2021 15:44:41 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com>
In-Reply-To: <YaaIRv0n2E8F5YpX@google.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 1 Dec 2021 23:44:30 +0000
Message-ID: <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 8:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 30, 2021, Ignat Korchagin wrote:
> > I have managed to reliably reproduce the issue on a QEMU VM (on a host
> > with nested virtualisation enabled). Here are the steps:
> >
> > 1. Install gvisor as per
> > https://gvisor.dev/docs/user_guide/install/#install-latest
> > 2. Run
> > $ for i in $(seq 1 100); do sudo runsc --platform=kvm --network=none
> > do echo ok; done
> >
> > I've tried to recompile the kernel with the above patch, but
> > unfortunately it does fix the issue. I'm happy to try other
> > patches/fixes queued for 5.16-rc4
>
> My best guest would be https://lore.kernel.org/all/20211120045046.3940942-5-seanjc@google.com/,
> that bug results in KVM installing SPTEs into an invalid root.  I think that could
> lead to a use-after-free and/or double-free, which is usually what leads to the
> "Bad page state" errors.

Unfortunately, that patch (alone) does not fix it in my repro environment.

Ignat

>
> In the meantime, I'll try to repro.
>
> > > > arch/x86/kvm/../../../virt/kvm/kvm_main.c:171
>
> ...
>
> > > > After this the machine starts spitting some traces starting with:
> > > >
> > > > [177247.871683][T2343516] BUG: Bad page state in process <comm>  pfn:fe680a
