Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182353B6700
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhF1QxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhF1QxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 12:53:13 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C4AC061574
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:50:46 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 128-20020a4a11860000b029024b19a4d98eso4915160ooc.5
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tRjdQ6kxj6CNAq7OiHwpdGF2PE729uBSvfgW6hH05aE=;
        b=fP0PtW2R1DxV5zPKcgU5BQZIkDtHQuWPQ4O9TEHOgo1qCTlUkbQPG81x8LnfmKisf+
         pgrjLCa9V1JKru8ixyiYXKTy5ORg4DDDOqsJFt16uFyG9dYua+ztt43MyGGh6MuqNUPA
         J/cBwrf/AAu5NrwBYg9EjKes/wuV8z7f3ZI5UvBtR8ungndIzqA6prtJeBCro8X+V4BL
         26jaFUhEtmaVACjeiWr82sDz8qiQEqDzqE7IqEdkkRfl0yCmT3L0LUmSG39soD6LGewx
         NvZNat27Nc8bfLImOWVWn7zOtK0pNJKBImMmCvT1kJmiRo5oQSsoNHb0xbMC/gUvTNd7
         qF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tRjdQ6kxj6CNAq7OiHwpdGF2PE729uBSvfgW6hH05aE=;
        b=Z0a36jlhcEZZC8rkFrsU8WXyv1EGRc5hBZDJvwwWAf08FU4mfabzJDbNoZa9HouefN
         78lZGARV1kDiv5zPHpU1Aha9DNpt7Xnaoy2Dyank3MxLDnil9lvux2waBPQlIbOtrVbB
         Zyd4Xo0Djb/hLLTGrRPscWfuA5JhYGz/sRPQYbHQekAO2RfPRP3NCIEbED7Ovda07yrt
         Nm8h+HERCKR5B3CxnkHDwufUAxMS9WXbpLn1pPfJp0gy2vngwNryVKflX9KVxsRIMazw
         GxTiWcoSY267ftmfzOxklLH3TosZvj+VvHyxntlQzfybDv1z/31zSt+5NzOSAhh6SXXg
         wO6A==
X-Gm-Message-State: AOAM530W1p2nkfGa/z9TJGh8ligl3qVzmHkkTPzDTRRxPQ4q+lDudDa1
        xjqJpwmPwOA0TiD6zeCPcwNBCwZV8akLe+xqCxqKlw==
X-Google-Smtp-Source: ABdhPJxNz6gPOHcBHF6AiXV22K07UXEXLtuqPhXVxdVHu6pVB/Wvj9XB57sAw4bgjMvbcTRbZiiRATWI3cXxZEee6K4=
X-Received: by 2002:a4a:c3c5:: with SMTP id e5mr308359ooq.82.1624899045860;
 Mon, 28 Jun 2021 09:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210628124814.1001507-1-stsp2@yandex.ru> <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <9a7962d1-7eee-620b-5b30-ffcc123c324c@yandex.ru>
In-Reply-To: <9a7962d1-7eee-620b-5b30-ffcc123c324c@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 28 Jun 2021 09:50:34 -0700
Message-ID: <CALMp9eQyhPO_Dpg8J0ZQ7jEnobAT5ydngB+x9OnFRyBU030E6w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 8:09 AM stsp <stsp2@yandex.ru> wrote:
>
> 28.06.2021 17:29, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > I used to know that area very very well, and I basically combed
> > the whole thing back and forth,
> > and I have patch series to decouple injected and
> > pending exceptions.
>
> Yes, and also I dislike the fact
> that you can't easily distinguish
> the exception injected from
> user-space, with the PF coming
> from the guest itself. They occupy
> the same pending/injected fields.
> Some refactoring will definitely
> not hurt.
>
>
> > I'll refresh my memory on this and then I'll review your patch.
> >
> > My gut feeling is that you discovered too that injections of
> > exceptions from userspace is kind of broken and only works
> > because Qemu doesn't really inject much
>
> Actually I discovered that injecting
> _interrupts_ is kinda broken (on Core2),
> because they clash with guest's PF.
> Maybe if I would be using KVM-supplied
> injection APIs, I would avoid the problem.
> But I just use KVM_SET_REGS to inject
> the interrupt, which perhaps qemu doesn't
> do.
>

I don't know how you can inject an interrupt with KVM_SET_REGS, but I
suspect that you're doing something wrong. :-)

 If I wanted to inject an interrupt from userspace, I would use
KVM_SET_LAPIC (assuming that the local APIC is active) to set the
appropriate bit in IRRV. Before you can deliver an interrupt, you have
to check the local APIC anyway, to see whether or not your interrupt
would be blocked by PPR.
