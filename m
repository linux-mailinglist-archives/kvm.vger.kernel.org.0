Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA88496925
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 02:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiAVBTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 20:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 20:19:18 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957F5C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 17:19:17 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f3so2053118lja.12
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 17:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5K1U8ELVOQ1EzrWucxbSORKiw0frFUAvJIJCzdIfJzw=;
        b=DHsEY9GalGazdVpe+3G6Flz0eJrHMKAI+o5vvleZm4PoTKjtcmhKUH4GnIPeiZ73s6
         d9dNXS4JYCpy776VWD/KS7oyu6kqDAY6P4KrVF8zp74XG4b/fkcJy3XeQ9564KIPwaH7
         EQ++d9PebRtDPA0j/DIsIiKqGVQYlP2BqMtxSFawmnBgvqRWpiiSEgDk+6Lwq9bdwulO
         yOy/aRfdfcytNAE3hY5/4Do7YoJSkD1WdPN+viBnxqc7q9iaxJQwTIea5xIK+SrcRW9Z
         tgtDU1csxDpKzkAn+6lX/3TgTX/9qHQ6ImA+Ueh1k+PbtgbfgIg9WDFvahzR0sjcNARR
         Ggew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5K1U8ELVOQ1EzrWucxbSORKiw0frFUAvJIJCzdIfJzw=;
        b=fLE+764DFCOUR5MpZV9QS2cvltxBPYasNGmiEj5MpCaWOFto5PhD6/51VhnJ9izc67
         X6v+CdBeiUFH94M8XUY/snR9zfgvlfmkywqSAhno+Nu75IH0c7pEtJXG+djiNAsSWbBq
         ZGT01ouu77MbZOPa3v2N3LIwE1D41zQWTa6s5avjpiTGkzZD+Roh7TJYF41lU2sXgzZT
         AdZpIYU1BwwOQzO9j4AbMHVlYbhOG2AQvITk5ss69J0BDLqleijj36mK2F9vMALut6km
         ED5yQXrH8GkAufIATZeDz/WAyIuaPaOgb1Kx3C7NRWQ65aqjWsbLkBkJen4Dtn8YwmZB
         dk3g==
X-Gm-Message-State: AOAM532Wvs+FYAnWJkJAU35n2uP2gL6OITf4QhB1kanAktaXMqvkBNLR
        kGDYRaXthAjs9FGYW/DXJjNrVbLiBoCXXeWuOAG7P9/fW6xoFQ==
X-Google-Smtp-Source: ABdhPJxLJ+cBDfmjMQj1+WmVma+FKPaT2RpiPIm6sPGYcGFp2xK+7PGrBpexHLmhhMoVUZ7VrhXAiOjdcgCKdLmmiI8=
X-Received: by 2002:a05:651c:547:: with SMTP id q7mr4619623ljp.464.1642814355185;
 Fri, 21 Jan 2022 17:19:15 -0800 (PST)
MIME-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com> <20220121231852.1439917-2-seanjc@google.com>
In-Reply-To: <20220121231852.1439917-2-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 21 Jan 2022 17:18:47 -0800
Message-ID: <CALzav=dFUwKcq0cEJ38OxcSH7WjH2PCmJh_2msFUQjTNzXexNg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/8] x86: Always use legacy xAPIC to get
 APIC ID during TSS setup
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022 at 3:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Force use of xAPIC to retrieve the APIC ID during TSS setup to fix an
> issue where an AP can switch apic_ops to point at x2apic_ops before
> setup_tss() completes, leading to a #GP and triple fault due to trying
> to read an x2APIC MSR without x2APIC being enabled.
>
> A future patch will make apic_ops a per-cpu pointer, but that's not of
> any help for 32-bit, which uses the APIC ID to determine the GS selector,
> i.e. 32-bit KUT has a chicken-and-egg problem.  All setup_tss() callers
> ensure the local APIC is in xAPIC mode, so just force use of xAPIC in
> this case.
>
> Fixes: 7e33895 ("x86: Move 32-bit GDT and TSS to desc.c")
> Fixes: dbd3800 ("x86: Move 64-bit GDT and TSS to desc.c")

FYI there was recently a report [1] to the KVM mailing list that Fixes
tags should use at least 12 characters for hashes. So I guess this
should be:

Fixes: 7e33895d3232 ("x86: Move 32-bit GDT and TSS to desc.c")
Fixes: dbd380049042 ("x86: Move 64-bit GDT and TSS to desc.c")

[1] https://lore.kernel.org/kvm/20220121081432.5b671602@canb.auug.org.au/



> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/apic.c  | 5 +++++
>  lib/x86/apic.h  | 2 ++
>  lib/x86/setup.c | 4 ++--
>  3 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index da8f3013..b404d580 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -48,6 +48,11 @@ static uint32_t xapic_id(void)
>      return xapic_read(APIC_ID) >> 24;
>  }
>
> +uint32_t pre_boot_apic_id(void)
> +{
> +       return xapic_id();
> +}
> +
>  static const struct apic_ops xapic_ops = {
>      .reg_read = xapic_read,
>      .reg_write = xapic_write,
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index c4821716..7844324b 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -53,6 +53,8 @@ bool apic_read_bit(unsigned reg, int n);
>  void apic_write(unsigned reg, uint32_t val);
>  void apic_icr_write(uint32_t val, uint32_t dest);
>  uint32_t apic_id(void);
> +uint32_t pre_boot_apic_id(void);
> +
>
>  int enable_x2apic(void);
>  void disable_apic(void);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index bbd34682..64217add 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -109,7 +109,7 @@ unsigned long setup_tss(u8 *stacktop)
>         u32 id;
>         tss64_t *tss_entry;
>
> -       id = apic_id();
> +       id = pre_boot_apic_id();
>
>         /* Runtime address of current TSS */
>         tss_entry = &tss[id];
> @@ -129,7 +129,7 @@ unsigned long setup_tss(u8 *stacktop)
>         u32 id;
>         tss32_t *tss_entry;
>
> -       id = apic_id();
> +       id = pre_boot_apic_id();
>
>         /* Runtime address of current TSS */
>         tss_entry = &tss[id];
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>
