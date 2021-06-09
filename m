Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F613A1CDD
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFISkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:40:43 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:37383 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFISkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:40:42 -0400
Received: by mail-oi1-f169.google.com with SMTP id h9so26098358oih.4
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sX7wBd0tcUErr5NyZUazI6LPTb09pVgnoeRW+BfmGYI=;
        b=avfG5tzdz08jyqTK+qZMxFF65pFDli0RYiCBjVHT5gLd9yQ9paVQ+TWNivCgZDkONC
         maeLuhgTx3Mpo6peg3zg/cEH61ALUle5/NC5MgWH7XSozZJbO+49CQy5hFueYisXjE+T
         3F9L8paheujWKuXZEqbJs8ZrF6tzeaK1SdYIqKJEBDtKdctIk2rNUqBpnIXVjD13HoYB
         KlW3jhY/UZDik4QzreV46KtbHkVwaqH//pLHld1tWgqvD1yyuo12FU++UjJ0cJeEXrHR
         n+kDkfJMZgddtDwgW+OskxtBaIS796xcMTs6ViOnQcIMj4OwY/Lu+uN8Iu6hw+kWVspN
         12BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sX7wBd0tcUErr5NyZUazI6LPTb09pVgnoeRW+BfmGYI=;
        b=Ul3fi7zJF8VfQew5ouZ90HObbES527jL/49glRuoPBcpu4/3f4YZ5mZT6V4OzWaRRf
         1dRMdGOnVm1L1BKWGRiKGqdAfO1bGqn6pjyOSsqNd/c0ShTZ1Poq3SayBQxVAFMaIrO/
         lRaGCg2fmFsOijWaAQclTLIDJshPrQ4WG7OhWie4DYnfyMMOWyzxMIJTi9MGQk7+ElLV
         ogunnJTyagB9s/l9ebY1FBC6YeoLGSrz/KsU4oYh/Tdnjps3y/oTbOgSRtj9xhXBRe6X
         N/bBUva0U38koBesCj9w1HCCXvBhKCXJlDsFUAyPGzI1QO5wMEXLlL0HpEm2IEORvT4Z
         mlCA==
X-Gm-Message-State: AOAM533CYprmGOe4i1fzsPaSzp1iGdw1tXJJ9jga12Nay46vntBqTo02
        yveAhLsoACQEJZumW0GQ10ViSCj+GjOoAFzt1th0TA==
X-Google-Smtp-Source: ABdhPJyjZ5o7VqyiyzCNG5zCUA9Gg2wQ7vCU2SdaS0qdpbLCh2daLzQYiO/prm7DuPWRVIzr27Hvp/qaSpkmZ88BaNw=
X-Received: by 2002:aca:1201:: with SMTP id 1mr7308734ois.6.1623263857802;
 Wed, 09 Jun 2021 11:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210609182945.36849-1-nadav.amit@gmail.com> <20210609182945.36849-5-nadav.amit@gmail.com>
In-Reply-To: <20210609182945.36849-5-nadav.amit@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Jun 2021 11:37:26 -0700
Message-ID: <CALMp9eReO7-L0hcMuMs8N6Aeb+JrfOcsNck95cc40f1Bj1Nvkg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 4/8] x86/hypercall: enable the test on
 non-KVM environment
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 9, 2021 at 11:32 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> From: Nadav Amit <nadav.amit@gmail.com>
>
> KVM knows to emulate both vmcall and vmmcall regardless of the
> actual architecture. Native hardware does not behave this way. Based on
> the availability of test-device, figure out that the test is run on
> non-KVM environment, and if so, run vmcall/vmmcall based on the actual
> architecture.
>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/processor.h |  8 ++++++++
>  x86/hypercall.c     | 31 +++++++++++++++++++++++--------
>  2 files changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index abc04b0..517ee70 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -118,6 +118,14 @@ static inline u8 cpuid_maxphyaddr(void)
>      return raw_cpuid(0x80000008, 0).a & 0xff;
>  }
>
> +static inline bool is_intel(void)
> +{
> +       struct cpuid c = cpuid(0);
> +       u32 name[4] = {c.b, c.d, c.c };
> +
> +       return strcmp((char *)name, "GenuineIntel") == 0;
> +}
> +
Don't VIA CPUs also require vmcall, since they implement VMX rather than SVM?
