Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6BDD99B1
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 21:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436678AbfJPTID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 15:08:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42523 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbfJPTID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 15:08:03 -0400
Received: by mail-io1-f65.google.com with SMTP id n197so55167134iod.9
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 12:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1NjK6LrD99Gaxm5bLlaUAmgTHhn8gjMU8QSyUXujDFg=;
        b=okkPmOWHiQpWGGnN2H1oD8oWpj5KihtTNxFrm5qU4a+FBryh1TZSRMkyCmr/x6TRFV
         tEnz1aP0/g4MmAcXc8rX9YkcaCtI+FpYeB3jOFe4+MTnsogjEv6B7pPIJTmLZ91KsQw6
         Dw6ju/X6hDFqy1GcGREmUTyn9m7R27tpIb0KPVMMLrNQ8wC0DV8eYNLBIK9Mnt4cjJlW
         m6x5Vttx046iYm04NQaQbtnR7PD1MP3apnEQI/pDDlrde6OkuwePRaIUgnd8bhbIhRYJ
         hzDov58F4McP+wmDBRGsic/p+JELgF4jwGQX8aH8NQ7/r0vnufIl6OEanlwb7gUOseWN
         NzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1NjK6LrD99Gaxm5bLlaUAmgTHhn8gjMU8QSyUXujDFg=;
        b=C0KSYAv7cMALQ85bmkwBPwRzdRig9upvDRl5lGIQqo+020G6ie0SK6EmRd6sKic0ih
         1x/WHj+104ch/HmjAtbUm9cezF2IkEreJfAfGZhszCmnb7QJGMrVvyuP8ZYdGfYR9UkA
         iJlhz/hw9lDFP33T8GihriD4l2C0HhI/jYrnpFYNHnMCuLv6/xKVCoovmNApPy2uMTvE
         XBixFgx/14gTRMeJ0DSov0/HzQmA+OJSh7KsKKybZMnBZkmzUh/T7EdkYlZbVwr7c1gy
         OaVSApdX91/+VDCf4xXMBRs8omXtCLovSlBskAwu8C4b0We+s28uUWzR86lJUbHVfGtM
         2adw==
X-Gm-Message-State: APjAAAVuFnASRvqjsLkntzVGzFseu6pTe22axCaObBcHnG9A8R20rHI2
        aP7rxB8j2K+0WEVtZ2eAvQXhPowOGT9nsIQZH0wMGg==
X-Google-Smtp-Source: APXvYqyh0quZafqyQwJ+8lkAmHtDFinGaU3LZvZEEazu2+uaEx2gfRYbkcSIGAglxsEb6pFQ8EGMYwAdr45OAjj+3gY=
X-Received: by 2002:a5d:8146:: with SMTP id f6mr29656177ioo.108.1571252881952;
 Wed, 16 Oct 2019 12:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com> <20191012235859.238387-2-morbo@google.com>
In-Reply-To: <20191012235859.238387-2-morbo@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Oct 2019 12:07:50 -0700
Message-ID: <CALMp9eSAG_1cFGG65hpbOpcSLi8MJRwmdXnkeaMAqfLee6faQQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: realmode: explicitly copy
 structure to avoid memcpy
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 12, 2019 at 4:59 PM Bill Wendling <morbo@google.com> wrote:
>
> Clang prefers to use a "mempcy" (or equivalent) to copy the "regs"
> structure. This doesn't work in 16-bit mode, as it will end up copying
> over half the number of bytes. GCC performs a field-by-field copy of the
> structure, so force clang to do the same thing.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/realmode.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/x86/realmode.c b/x86/realmode.c
> index 303d093..cf45fd6 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -117,6 +117,19 @@ struct regs {
>         u32 eip, eflags;
>  };
>
> +#define COPY_REG(name, dst, src) (dst).name = (src).name
> +#define COPY_REGS(dst, src)                            \
> +       COPY_REG(eax, dst, src);                        \
> +       COPY_REG(ebx, dst, src);                        \
> +       COPY_REG(ecx, dst, src);                        \
> +       COPY_REG(edx, dst, src);                        \
> +       COPY_REG(esi, dst, src);                        \
> +       COPY_REG(edi, dst, src);                        \
> +       COPY_REG(esp, dst, src);                        \
> +       COPY_REG(ebp, dst, src);                        \
> +       COPY_REG(eip, dst, src);                        \
> +       COPY_REG(eflags, dst, src)
> +

This seems very fragile, too. Can we introduce our own
address-space-size-independent "memcpy" and use that?

I'm thinking something like:

static void bytecopy(void *dst, void *src, u32 count)
{
        asm volatile("rep movsb"
             : "+D" (dst), "+S" (src), "+c" (count) : : "cc");
}

>  struct table_descr {
>         u16 limit;
>         void *base;
> @@ -148,11 +161,11 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
>         extern u8 test_insn[], test_insn_end[];
>
>         for (i = 0; i < insn->len; ++i)
> -           test_insn[i] = ((u8 *)(unsigned long)insn->ptr)[i];
> +               test_insn[i] = ((u8 *)(unsigned long)insn->ptr)[i];
>         for (; i < test_insn_end - test_insn; ++i)
>                 test_insn[i] = 0x90; // nop
>
> -       save = inregs;
> +       COPY_REGS(save, inregs);
>         asm volatile(
>                 "lgdtl %[gdt_descr] \n\t"
>                 "mov %%cr0, %[tmp] \n\t"
> @@ -196,7 +209,7 @@ static void exec_in_big_real_mode(struct insn_desc *insn)
>                 : [gdt_descr]"m"(gdt_descr), [bigseg]"r"((short)16)
>                 : "cc", "memory"
>                 );
> -       outregs = save;
> +       COPY_REGS(outregs, save);
>  }
>
>  #define R_AX 1
> --
> 2.23.0.700.g56cf767bdb-goog
>
