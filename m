Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5527159C22
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgBKW0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgBKW0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:26:03 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A6120848
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581459963;
        bh=jwOvEweDP3a6frfUBwUsTRLm3KUOaJHDLObO3bfMngQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zZYakXND4nSyArsUYniGdrmaKSyq1gknzDCuf0po+GIXwSJFpic9i7FaMFT5+FR+2
         OgpeNiEc6wN+3KbrRoQWDiWm0QjF4KCTdbL02gOc9XOuU4E8hi2JKG7ZHCh98mPmnM
         bw7k9TPplzbMJREMCV+2FkmwzoEhDOOarizM7dEo=
Received: by mail-wr1-f43.google.com with SMTP id y11so14562652wrt.6
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:26:02 -0800 (PST)
X-Gm-Message-State: APjAAAUaWTKoBVQl8QqlLr5gHtegoVL8c2oW5LOJmliUJXVNIW30TdPU
        QGFZyUCgZZke+OlP+sNTHSuRx6AW6yQT9YvWo/ycgg==
X-Google-Smtp-Source: APXvYqzhlwE9e/rHSQa1i4zUzoVmEyewXxrV5b2agTpUtz0bDQeneWSxaZrnHZkjhP0nWHhNPn8gEdVFwZOXFNRhQHY=
X-Received: by 2002:a5d:494b:: with SMTP id r11mr10831273wrs.184.1581459961446;
 Tue, 11 Feb 2020 14:26:01 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-19-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-19-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:25:49 -0800
X-Gmail-Original-Message-ID: <CALCETrVWoG7ugfE_FJgNKyyWYCmZh1162kfceJ2bs+O7Qyf-8A@mail.gmail.com>
Message-ID: <CALCETrVWoG7ugfE_FJgNKyyWYCmZh1162kfceJ2bs+O7Qyf-8A@mail.gmail.com>
Subject: Re: [PATCH 18/62] x86/boot/compressed/64: Setup GHCB Based VC
 Exception handler
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

On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> Install an exception handler for #VC exception that uses a GHCB. Also
> add the infrastructure for handling different exit-codes by decoding
> the instruction that caused the exception and error handling.
>

> diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
> index 8d13121a8cf2..02fb6f57128b 100644
> --- a/arch/x86/boot/compressed/sev-es.c
> +++ b/arch/x86/boot/compressed/sev-es.c
> @@ -8,12 +8,16 @@
>  #include <linux/kernel.h>
>
>  #include <asm/sev-es.h>
> +#include <asm/trap_defs.h>
>  #include <asm/msr-index.h>
>  #include <asm/ptrace.h>
>  #include <asm/svm.h>
>
>  #include "misc.h"
>
> +struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
> +struct ghcb *boot_ghcb;
> +
>  static inline u64 read_ghcb_msr(void)
>  {
>         unsigned long low, high;
> @@ -35,8 +39,95 @@ static inline void write_ghcb_msr(u64 val)
>                         "a"(low), "d" (high) : "memory");
>  }
>
> +static enum es_result es_fetch_insn_byte(struct es_em_ctxt *ctxt,
> +                                        unsigned int offset,
> +                                        char *buffer)
> +{
> +       char *rip = (char *)ctxt->regs->ip;
> +
> +       buffer[offset] = rip[offset];
> +
> +       return ES_OK;
> +}
> +
> +static enum es_result es_write_mem(struct es_em_ctxt *ctxt,
> +                                  void *dst, char *buf, size_t size)
> +{
> +       memcpy(dst, buf, size);
> +
> +       return ES_OK;
> +}
> +
> +static enum es_result es_read_mem(struct es_em_ctxt *ctxt,
> +                                 void *src, char *buf, size_t size)
> +{
> +       memcpy(buf, src, size);
> +
> +       return ES_OK;
> +}


What are all these abstractions for?
