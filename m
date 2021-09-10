Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AB0406521
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhIJBZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbhIJBY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:24:56 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8623C0613DF
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 18:23:40 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c8-20020a9d6c88000000b00517cd06302dso121667otr.13
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 18:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OAp385IrRyQM0bf2CTn8m6HsT3G2HXxxQxD9bmiIJg4=;
        b=lXeBnpzgLkHZ7Nnp7RalkiuqX/N3/tdJjiWv7a9ZE7Axa5+ZrA3mAYeZgLrWduclrI
         Guw2B2fqM+vDktr5tDzNIhkEg4yT6zPys7ac2Sdn00lr0llJYcAY+TDMt2uMWGU1zJJE
         3jwZpaUwHphGF5I/gOIPUVz1LIItmTrpAgR86qUhOAjXIGY0QiGzbRgl6s93N8QLrLnD
         2wM59yaEtvkBh5kjslfdytuqhnlhrxu79FLJj0zQfLHYyZffKlfq1TNp3pP8K/JUB3k5
         3THEZ1kQZ/DPJMWlHjkuRpJq59MFouREYyxoEhXvq6izqXs4YmEcVTTxCyyfkReM6pHT
         1TsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OAp385IrRyQM0bf2CTn8m6HsT3G2HXxxQxD9bmiIJg4=;
        b=tTpfIEiJdB7aOG8HwtD9KFKfosu3i8AJFACWJK2KDbgapDn0T1vHsqs7r+fg771BxC
         OWK1a+N0yWz4/Nz4XSOdEq7R5wSDXa/+GFOv0yIcKX1vFhkVZZVdm2+8ZTsGhGEfKDAq
         fq6KI9E8zhv9EmkBS8EG88SJlIcpmROmXYunxtfn2SVqg02ycXnFHYetUF1fx0MQ5pie
         0/8aEzDd1OwhZAA7cwjOpO/VlxqhyOeDdC9jDPr91zpSDzAWEK223f4b2n63NGKA/S7L
         qf55U4mKKWQ2j81TuduRnFmw+xv6YEvPX71ISZjPVD5kOp1xJv0RBmDNjXq/PcB2sXbT
         QY3Q==
X-Gm-Message-State: AOAM532TCdtoX1jHhwiLkdz8UORyXKHcmx6y5zzcnczE20mVJr5yyn//
        8XmW6Ia++oe5SYYYiTCTvnnJf1CGRAv7q02pJ4nyxQ==
X-Google-Smtp-Source: ABdhPJwlQyQUySxRUao6VzWG+GD3ZmsaRhSPVis3onD/48fp6HP6gL6VypDF0fexa+FZ27z2U9sJ/GBqmg5vlkEXAfA=
X-Received: by 2002:a05:6830:349c:: with SMTP id c28mr2502271otu.35.1631237019961;
 Thu, 09 Sep 2021 18:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com> <20210818053908.1907051-4-mizhang@google.com>
 <YTJ5wjNShaHlDVAp@google.com> <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com>
 <YTf3udAv1TZzW+xA@google.com> <8421f104-34e8-cc68-1066-be95254af625@amd.com>
 <YTpOsUAqHjQ9DDLd@google.com> <CAL715W+u6mt5grwoT6DBhUtzN6xx=OjWPu6M0=p0sxLZ4JTvDg@mail.gmail.com>
 <48af420f-20e3-719a-cf5c-e651a176e7c2@amd.com> <CAL715WL6g3P6QKv1w-zSDvY3jjLVdbfxaqyr2XV_NicnuP2+EQ@mail.gmail.com>
In-Reply-To: <CAL715WL6g3P6QKv1w-zSDvY3jjLVdbfxaqyr2XV_NicnuP2+EQ@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 9 Sep 2021 18:23:29 -0700
Message-ID: <CAA03e5HK1Qkk0uyZRi_ncFewJ5yStXWGT7REQdYQ2Z1BYHcCew@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 6:18 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> > I believe once we are done with it, will have 5 functions that will need
> >  >=8 arguments. I don't know if its acceptable.
> >
> > > In addition, having to construct each sev_data_* structure in KVM code
> > > is also a pain and  consumes a lot of irrelevant lines as well.
> > >
> >
> > Maybe I am missing something, aren't those lines will be moved from KVM
> > to PSP driver?
> >
> > I am in full support for restructuring, but lets look at full set of PSP
> > APIs before making the final decision.
> >
> > thanks
> >
>
> Oh, sorry for the confusion. I think the current feedback I got is
> that my restructuring patchset was blocked due to the fact that it is
> a partial one. So, if this patchset got checked in, then the psp-sev.h
> will have two types of APIs: ones that use sev_data_* structure and
> ones that do not. So one of the worries is that this would make the
> situation even worse.
>
> So that's why I am thinking that maybe it is fine to just avoid using
> sev_data_* for all PSP functions exposed to KVM? I use the number of
> arguments as the justification. But that might not be a good one.
>
> In anycase, I will not rush into any code change before we reach a consensus.

Isn't the first patch in this patch set a straight-forward bug fix
:-)? Assuming others agree, I'd suggest to re-send that one out as a
single patch on its own, so we can get it merged while the rest of
this patch set works its way through the process.
