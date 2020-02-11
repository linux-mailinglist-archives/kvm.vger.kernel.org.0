Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620B7159C09
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBKWTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBKWTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:19:05 -0500
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53002173E
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581459545;
        bh=BtTTbf66d4ZndImglbcpTn7JSHa69QCkwdohC6uLX1M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pNbwbbi6Ci2U0CegsqKkSd0uMThWVqEvNPAYsf2DpZ1yT7m/16h5w6LqKBIT55mpA
         THrH5gPXzGb2YyfOdKfRYRkZLwBp2YMoxW1WQvz59IVtCxpT0/OjlzQSRJE30Dp6uP
         Ax4QtsSW0xKQ05QmUFM/gxvOnDNW6Zv1C9MiE140=
Received: by mail-wm1-f48.google.com with SMTP id p9so5745172wmc.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:19:04 -0800 (PST)
X-Gm-Message-State: APjAAAXPHxFxhLChH4MVak2TQuhjsRBhxDeKcHB4xJWlx9jAvwnriY3Z
        pCkpEtJLwT/hoZOlQlJhmpgdC9Pie/Imqb6nP6k2uQ==
X-Google-Smtp-Source: APXvYqxgH/L+PTOkvq4VwpcjEPNRJ4Rn+9UAJW/4iUfZMfvCSX5HF6lMTrDQecp2ABQPGJPH/KdOIIfJxqSFOOyTAqE=
X-Received: by 2002:a1c:3906:: with SMTP id g6mr8465912wma.49.1581459543059;
 Tue, 11 Feb 2020 14:19:03 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-9-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-9-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:18:52 -0800
X-Gmail-Original-Message-ID: <CALCETrWznWHQNfd80G95G_CB-yCw8Botqee8bsLz3OcC4-SS=w@mail.gmail.com>
Message-ID: <CALCETrWznWHQNfd80G95G_CB-yCw8Botqee8bsLz3OcC4-SS=w@mail.gmail.com>
Subject: Re: [PATCH 08/62] x86/boot/compressed/64: Add IDT Infrastructure
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
> Add code needed to setup an IDT in the early pre-decompression
> boot-code. The IDT is loaded first in startup_64, which is after
> EfiExitBootServices() has been called, and later reloaded when the
> kernel image has been relocated to the end of the decompression area.
>
> This allows to setup different IDT handlers before and after the
> relocation.
>

> diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
> new file mode 100644
> index 000000000000..46ecea671b90
> --- /dev/null
> +++ b/arch/x86/boot/compressed/idt_64.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <asm/trap_defs.h>
> +#include <asm/segment.h>
> +#include "misc.h"
> +
> +static void set_idt_entry(int vector, void (*handler)(void))
> +{
> +       unsigned long address = (unsigned long)handler;
> +       gate_desc entry;
> +
> +       memset(&entry, 0, sizeof(entry));
> +
> +       entry.offset_low    = (u16)(address & 0xffff);
> +       entry.segment       = __KERNEL_CS;
> +       entry.bits.type     = GATE_TRAP;

^^^

I realize we're not running a real kernel here, but GATE_TRAP is
madness.  Please use GATE_INTERRUPT.

> +       entry.bits.p        = 1;
> +       entry.offset_middle = (u16)((address >> 16) & 0xffff);
> +       entry.offset_high   = (u32)(address >> 32);
> +
> +       memcpy(&boot_idt[vector], &entry, sizeof(entry));
> +}
> +
> +/* Have this here so we don't need to include <asm/desc.h> */
> +static void load_boot_idt(const struct desc_ptr *dtr)
> +{
> +       asm volatile("lidt %0"::"m" (*dtr));
> +}
> +
> +/* Setup IDT before kernel jumping to  .Lrelocated */
> +void load_stage1_idt(void)
> +{
> +       boot_idt_desc.address = (unsigned long)boot_idt;
> +
> +       load_boot_idt(&boot_idt_desc);
> +}
> +
> +/* Setup IDT after kernel jumping to  .Lrelocated */
> +void load_stage2_idt(void)
> +{
> +       boot_idt_desc.address = (unsigned long)boot_idt;
> +
> +       load_boot_idt(&boot_idt_desc);
> +}
> diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
> new file mode 100644
> index 000000000000..0b2b6cf747d2
> --- /dev/null
> +++ b/arch/x86/boot/compressed/idt_handlers_64.S
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Early IDT handler entry points
> + *
> + * Copyright (C) 2019 SUSE
> + *
> + * Author: Joerg Roedel <jroedel@suse.de>
> + */
> +
> +#include <asm/segment.h>
> +
> +.macro EXCEPTION_HANDLER name function error_code=0
> +SYM_FUNC_START(\name)
> +
> +       /* Build pt_regs */
> +       .if \error_code == 0
> +       pushq   $0
> +       .endif

cld

> +
> +       pushq   %rdi
> +       pushq   %rsi
> +       pushq   %rdx
> +       pushq   %rcx
> +       pushq   %rax
> +       pushq   %r8
> +       pushq   %r9
> +       pushq   %r10
> +       pushq   %r11
> +       pushq   %rbx
> +       pushq   %rbp
> +       pushq   %r12
> +       pushq   %r13
> +       pushq   %r14
> +       pushq   %r15
> +
> +       /* Call handler with pt_regs */
> +       movq    %rsp, %rdi
> +       call    \function
> +
> +       /* Restore regs */
> +       popq    %r15
> +       popq    %r14
> +       popq    %r13
> +       popq    %r12
> +       popq    %rbp
> +       popq    %rbx
> +       popq    %r11
> +       popq    %r10
> +       popq    %r9
> +       popq    %r8
> +       popq    %rax
> +       popq    %rcx
> +       popq    %rdx
> +       popq    %rsi
> +       popq    %rdi

if error_code?

> +
> +       /* Remove error code and return */
> +       addq    $8, %rsp
> +
> +       /*
> +        * Make sure we return to __KERNEL_CS - the CS selector on
> +        * the IRET frame might still be from an old BIOS GDT
> +        */
> +       movq    $__KERNEL_CS, 8(%rsp)
> +

If this actually happens, you have a major bug.  Please sanitize all
the segment registers after installing the GDT rather than hacking
around it here.
