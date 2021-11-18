Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEF4552D6
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 03:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbhKRCov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 21:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbhKRCou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 21:44:50 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FE5C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:41:50 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id bi37so18271511lfb.5
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nndpagO1UyvqFY51uT0SPwhA/Ocf8bbxYZeWozDfAQw=;
        b=njl3OrNBdLugqPKfveYKQPegzT6hUA5L25psf9cepK6MuWznfy7u+z8RBwDWbS066z
         JsRbzRq7ek0rKeppXgLmNDR43LkVcjlwa/StjoTeQQf8Bo/n3yme6tmH+an1w7UGHquk
         zzBenlPhVSqyuBFmaAK0ByOs6IaHHS3PPN3uAyHeZgZuFV86QTXi4/N+pv7UZym8XOq9
         3FsSWRUFOBxikfIR1XEcD4lJ2oUgEuwvFvuK6D4Bzmvx8kgGI1MXrPZrhlLjGjFvISIW
         oLRL/1OALMwlcDvkDPth7/oO39wldqwqEbNQ/FaBkIRJ3ZamoOb2f/iJ3chzuH4+iMmZ
         p3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nndpagO1UyvqFY51uT0SPwhA/Ocf8bbxYZeWozDfAQw=;
        b=Yj5ZTeE+G2k8gcWhOkkX+ZoMg5J0yuzTrY1ioUmaTRE8cSo5+yus2ECimm0Qrhp7GP
         f90BQjtxaMQvrIzmIiBzpTgKBTIPdsSgMuMYxyThd4c22N/aqlZHGFD39/81hP3IzSQn
         1HIeKL8ArPPOmU9MCOBz5E4A537vqJ65vf1Inc4l53Ao0YkwZlsWAm55YQ1MS0AEdFcw
         jcVkOYRsTTnu3WeF4nPKj+YwzJOjpUNDGSr1P5E+7g9i5vXQFbgOPzX6G0Y4owdrUT6w
         jGQiG5EHUCKBzR3ASKgqoJcRYe/gveur8l9A5NOUOg5e+lEDhK6XjUyI4mVfi9goi7ku
         ndZw==
X-Gm-Message-State: AOAM5332/4cpND/MwkdUsPdNoUhWvPIvZITk02+s+Pb6fRndVMjMDE3R
        Hrjh4KBAKm+JJWJf1dilEsG3VwLrMkyHnG3C2Tf2Rw==
X-Google-Smtp-Source: ABdhPJwnJWqJU4XSj9H8oMGLQUzKW7ORfxxaNG4VdjOMGthPFnl9W8jF2SmY4TrsMEpknx8MCdlmC5tS3Qp/TI9Bi3o=
X-Received: by 2002:a2e:7807:: with SMTP id t7mr12706588ljc.426.1637203308047;
 Wed, 17 Nov 2021 18:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20211118021326.4134850-1-sterritt@google.com>
In-Reply-To: <20211118021326.4134850-1-sterritt@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 17 Nov 2021 19:41:36 -0700
Message-ID: <CAMkAt6qBTStDyr6_0ca7f2r1UU=P5qFjhO-WWtfnHnH5TsRaSw@mail.gmail.com>
Subject: Re: [PATCH] Fix SEV-ES INS/OUTS instructions for word, dword, and qword.
To:     Michael Sterritt <sterritt@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-coco@lists.linux.dev, marcorr@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 7:13 PM Michael Sterritt <sterritt@google.com> wrote:
>
> Properly type the operands being passed to __put_user()/__get_user().
> Otherwise, these routines truncate data for dependent instructions
> (e.g., INSW) and only read/write one byte.
>
> Tested: Tested by sending a string with `REP OUTSW` to a port and then
> reading it back in with `REP INSW` on the same port. Previous behavior
> was to only send and receive the first char of the size. For example,
> word operations for "abcd" would only read/write "ac". With change, the
> full string is now written and read back.

I think this should include:

Fixes: f980f9c31a923 (x86/sev-es: Compile early handler code into kernel image)

>
> Signed-off-by: Michael Sterritt <sterritt@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Gonda <pgonda@google.com>
> ---
>  arch/x86/kernel/sev.c | 57 +++++++++++++++++++++++++++++--------------
>  1 file changed, 39 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 74f0ec955384..a9fc2ac7a8bd 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -294,11 +294,6 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
>                                    char *dst, char *buf, size_t size)
>  {
>         unsigned long error_code = X86_PF_PROT | X86_PF_WRITE;
> -       char __user *target = (char __user *)dst;
> -       u64 d8;
> -       u32 d4;
> -       u16 d2;
> -       u8  d1;
>
>         /*
>          * This function uses __put_user() independent of whether kernel or user
> @@ -320,26 +315,42 @@ static enum es_result vc_write_mem(struct es_em_ctxt *ctxt,
>          * instructions here would cause infinite nesting.
>          */
>         switch (size) {
> -       case 1:
> +       case 1: {
> +               u8 d1;
> +               u8 __user *target = (u8 __user *)dst;
> +
>                 memcpy(&d1, buf, 1);
>                 if (__put_user(d1, target))
>                         goto fault;
>                 break;
> -       case 2:
> +       }
> +       case 2: {
> +               u16 d2;
> +               u16 __user *target = (u16 __user *)dst;
> +
>                 memcpy(&d2, buf, 2);
>                 if (__put_user(d2, target))
>                         goto fault;
>                 break;
> -       case 4:
> +       }
> +       case 4: {
> +               u32 d4;
> +               u32 __user *target = (u32 __user *)dst;
> +
>                 memcpy(&d4, buf, 4);
>                 if (__put_user(d4, target))
>                         goto fault;
>                 break;
> -       case 8:
> +       }
> +       case 8: {
> +               u64 d8;
> +               u64 __user *target = (u64 __user *)dst;
> +
>                 memcpy(&d8, buf, 8);
>                 if (__put_user(d8, target))
>                         goto fault;
>                 break;
> +       }
>         default:
>                 WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
>                 return ES_UNSUPPORTED;
> @@ -362,11 +373,6 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>                                   char *src, char *buf, size_t size)
>  {
>         unsigned long error_code = X86_PF_PROT;
> -       char __user *s = (char __user *)src;
> -       u64 d8;
> -       u32 d4;
> -       u16 d2;
> -       u8  d1;
>
>         /*
>          * This function uses __get_user() independent of whether kernel or user
> @@ -388,26 +394,41 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>          * instructions here would cause infinite nesting.
>          */
>         switch (size) {
> -       case 1:
> +       case 1: {
> +               u8 d1;
> +               u8 __user *s = (u8 __user *)src;
> +
>                 if (__get_user(d1, s))
>                         goto fault;
>                 memcpy(buf, &d1, 1);
>                 break;
> -       case 2:
> +       }
> +       case 2: {
> +               u16 d2;
> +               u16 __user *s = (u16 __user *)src;
> +
>                 if (__get_user(d2, s))
>                         goto fault;
>                 memcpy(buf, &d2, 2);
>                 break;
> -       case 4:
> +       }
> +       case 4: {
> +               u32 d4;
> +               u32 __user *s = (u32 __user *)src;
> +
>                 if (__get_user(d4, s))
>                         goto fault;
>                 memcpy(buf, &d4, 4);
>                 break;
> -       case 8:
> +       }
> +       case 8: {
> +               u64 d8;
> +               u64 __user *s = (u64 __user *)src;
>                 if (__get_user(d8, s))
>                         goto fault;
>                 memcpy(buf, &d8, 8);
>                 break;
> +       }
>         default:
>                 WARN_ONCE(1, "%s: Invalid size: %zu\n", __func__, size);
>                 return ES_UNSUPPORTED;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
