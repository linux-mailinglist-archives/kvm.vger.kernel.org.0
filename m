Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E2C174927
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 21:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgB2URu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Feb 2020 15:17:50 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33657 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgB2URt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Feb 2020 15:17:49 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so7431207ioh.0
        for <kvm@vger.kernel.org>; Sat, 29 Feb 2020 12:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wmpPmvsEIyrnQOguFJJRRPmk+nI9F2PZon3IZMblz1w=;
        b=wLO3hacNd3AO+uNA1CnNg95qpWPAeIVIN8j5Qi8kcMlj0w/64vVB58E2UUwauDE13S
         JWxSJf2cO+VtN1eX5PUa75e2ImrKlI9yfywbApSzce7XacU7yCTNVimHDh+2c/j4Isr8
         bcaQsNDcIluValQQMdy8PtzZqMzrCKRIT7c2B8YfrBK5SrWi4dFUgKjLc9t0jrjuxxzU
         y6GdV19Fg9H1Vuq71UeKMoFiX8RhHj/Ge+CF9GCNJVanHzRV7JvXYTyfrmHopclIEf+t
         16gm3SPcyONEDIECix611Gguwbr9/B6LX+HvcU/Wa0ZwVnu8uj1G1R+TdzZ16t8fSi+I
         ZWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wmpPmvsEIyrnQOguFJJRRPmk+nI9F2PZon3IZMblz1w=;
        b=tmyTYILsyHUtBWkOeQqOrkGdeJDIEEVfi+rHhFTE6IC3qWGyEYcwURNDH//TSQHevG
         gPtJ4Z+C5c9ZckAEU8CSbWljO6eriIcuWg7xPpGekfgYpZLve0/XTvt/Rgb7yr9cbdCr
         1oJBANh2vN6kK8ec+SrjIVW3dVN14aiPYUVyxOMoQ8KXBedFJ6g82un169ajy3v+TM1K
         hY8kGeOM9DWjKVKPPt9alLaV6NyDjKddyijBUavGItc8s9Hax1jCOSse4dMJv4IFFTjP
         /CxKbKcJGfktlTAA3w0KQobLj9FaAuoJR8aq3wJ4yUXQy4RthPcVlrPNIH0eBHY8tTma
         2ghg==
X-Gm-Message-State: APjAAAVg/e3/3L5LeSgHa2vAssKdX2epB7xhq8rvItO6jnD7FGa4DCyv
        EMaztXCCv0SiQwbDUsABEWozlfQLBuzwZgD70YOOTQ==
X-Google-Smtp-Source: APXvYqx3dpUf2n7ik6bI7eu9iMF2etEOearvMVPaaE0Ih/aI/ITxpHjzDEm78SmGWjK9fgGtSnoWNixiYwPJYeSJKwc=
X-Received: by 2002:a02:cc58:: with SMTP id i24mr8110735jaq.24.1583007468804;
 Sat, 29 Feb 2020 12:17:48 -0800 (PST)
MIME-Version: 1.0
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com> <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
 <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
 <CALMp9eRETy1RLWHWKtFHqpcpFHbQKtPgJHDD_N+LPzaUPx-Jvg@mail.gmail.com> <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
In-Reply-To: <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 29 Feb 2020 12:17:37 -0800
Message-ID: <CALMp9eR9zcXO64n7hDTzZHPkfV8qtuMHAbc=nLX8S8x7Crum+A@mail.gmail.com>
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since UMIP emulation is broken, I'm not sure why anyone would use it.
(Sorry, Paolo.)

On Sat, Feb 29, 2020 at 11:21 AM Jan Kiszka <jan.kiszka@web.de> wrote:
>
> On 29.02.20 20:00, Jim Mattson wrote:
> > On Sat, Feb 29, 2020 at 10:33 AM Oliver Upton <oupton@google.com> wrote:
> >>
> >> Hi Jan,
> >>
> >> On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote:
> >>> Is this expected to cause regressions on less common workloads?
> >>> Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Linux
> >>> gets a triple fault on load_current_idt() in start_secondary(). Only
> >>> bisected so far, didn't debug further.
> >>
> >> I'm guessing that Jailhouse doesn't use 'descriptor table exiting', so
> >> when KVM gets the corresponding exit from L2 the emulation burden is
> >> on L0. We now refuse the emulation, which kicks a #UD back to L2. I
> >> can get a patch out quickly to address this case (like the PIO exiting
> >> one that came in this series) but the eventual solution is to map
> >> emulator intercept checks into VM-exits + call into the
> >> nested_vmx_exit_reflected() plumbing.
> >
> > If Jailhouse doesn't use descriptor table exiting, why is L0
> > intercepting descriptor table instructions? Is this just so that L0
> > can partially emulate UMIP on hardware that doesn't support it?
> >
>
> That seems to be the case: My host lacks umip, L1 has it. So, KVM is
> intercepting descriptor table load instructions to emulate umip.
> Jailhouse never activates that interception.
>
> Jan
