Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1092218BB7A
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 16:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgCSPqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 11:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbgCSPqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 11:46:50 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B711721707
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584632810;
        bh=Cn1m0nZsjDiV+FYhoJLlELXGkyDw2CZ03wWFmubUPo8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Bqc/DvIBMhIobrqKeilGyFQQIGQMPqcwCCmTWlk+w71Tr24MgghLknOseCQr2FkPP
         pBg3C82P5fhtl5jsxpscyX3d4WPB7JCK7LxSpLZV3ERaPIqyv15Lp22fOEAUXOW1FA
         bO74bLqN3aP8k/9PYSX+u66n4JNxAqhw2T2P1Sww=
Received: by mail-wr1-f51.google.com with SMTP id h9so3632776wrc.8
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 08:46:49 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3jRfsyafvsQQFKRJrEvLuWzExvvZ2Kthflza07B7rlF8RA5eCy
        3cTPdeQgPEv+51jzNQ4Z2a+B+vbCB4jn6UccoE9G9Q==
X-Google-Smtp-Source: ADFU+vtRWY7b1vbCxAUKKJKmAYVxdIrYpSMuMiWvH4H8RWo6SRJpLSPLzDmmHbdXmaoFC1CnppEqPqcDFxLdoNnM7Rk=
X-Received: by 2002:adf:e883:: with SMTP id d3mr4992846wrm.75.1584632808043;
 Thu, 19 Mar 2020 08:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200319091407.1481-1-joro@8bytes.org> <20200319091407.1481-43-joro@8bytes.org>
In-Reply-To: <20200319091407.1481-43-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Mar 2020 08:46:36 -0700
X-Gmail-Original-Message-ID: <CALCETrXiWjALMTcG=92DmMn_H=yR88e0-3cj8CjTAjtjTvBR8w@mail.gmail.com>
Message-ID: <CALCETrXiWjALMTcG=92DmMn_H=yR88e0-3cj8CjTAjtjTvBR8w@mail.gmail.com>
Subject: Re: [PATCH 42/70] x86/sev-es: Support nested #VC exceptions
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 2:14 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> Handle #VC exceptions that happen while the GHCB is in use. This can
> happen when an NMI happens in the #VC exception handler and the NMI
> handler causes a #VC exception itself. Save the contents of the GHCB
> when nesting is detected and restore it when the GHCB is no longer
> used.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es.c | 63 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 59 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 97241d2f0f70..3b7bbc8d841e 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -32,9 +32,57 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>   */
>  struct ghcb __initdata *boot_ghcb;
>
> +struct ghcb_state {
> +       struct ghcb *ghcb;
> +};
> +
>  /* Runtime GHCB pointers */
>  static struct ghcb __percpu *ghcb_page;
>
> +/*
> + * Mark the per-cpu GHCB as in-use to detect nested #VC exceptions.
> + * There is no need for it to be atomic, because nothing is written to the GHCB
> + * between the read and the write of ghcb_active. So it is safe to use it when a
> + * nested #VC exception happens before the write.
> + */
> +static DEFINE_PER_CPU(bool, ghcb_active);
> +
> +static struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
> +{
> +       struct ghcb *ghcb = (struct ghcb *)this_cpu_ptr(ghcb_page);
> +       bool *active = this_cpu_ptr(&ghcb_active);
> +
> +       if (unlikely(*active)) {
> +               /* GHCB is already in use - save its contents */
> +
> +               state->ghcb = kzalloc(sizeof(struct ghcb), GFP_ATOMIC);
> +               if (!state->ghcb)
> +                       return NULL;

This can't possibly end well.  Maybe have a little percpu list of
GHCBs and make sure there are enough for any possible nesting?

Also, I admit confusion.  Isn't the GHCB required to be unencrypted?
How does that work with kzalloc()?
