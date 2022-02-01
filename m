Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209014A6534
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 20:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiBATxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 14:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiBATxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 14:53:42 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCF9C061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 11:53:42 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id bx31so13990271ljb.0
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 11:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BLa4FR1JDKGzHbMj+swTkk7iSUe7LbD5o7vJbsNybm0=;
        b=Y8oINUyuGlfKSDFVZrsXaijVo9SnLzPGVFzmquhYvNHyRAMyK7D9s10kUek0cwYrnZ
         n81auy4xwjhpnqlbeJyTfytijFL/jzg2wxwRE9HYGOohWIG4JzYZa7YZ6Mghs7D23P6c
         9r8IbL/sAkoo4fx0laDEE6rZA883YUTGEoLhX5Izj2Mju3xWdSUpfSPiTz8vAD8lIrF4
         cCIqeKEgZTUyw1MJp3TpEu1BssB3Bd4u7qvWCr1xSbCYyWAtNMceiJvgK+wtt4yZjR3r
         V0343uNAoFxFMdU/UMtMcCbgXXlHZFGgU8L+6g7khbp/pHOCrXovaHiApnhjUuXVTOdu
         EVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLa4FR1JDKGzHbMj+swTkk7iSUe7LbD5o7vJbsNybm0=;
        b=cgqH7hGeWP6NGoAjOeiO0HxZutVdaH5ICUnYyAUbPLEaTlC/3LbOv/mBv7L9d+uAWU
         7gaSKCB3/jUynvr+ain0eTf+kYYeztaYY6Qm0HH4V9POVNbkWYgXxFX/LhRLH/u3nJFl
         vN8PFehXlRY4od3GusF43XFA/CNDKUSaWWv6FgCpstQG7lEEoN6ttXkmGfahXRX8BA5t
         LbH1ELNdfmY+BpubYvnCZJeVnEOOf1VINIj7+nKlQ6YDjaVwXgnp4BRReEIOMhM7poRz
         ktI9CGOPWNhlsc4hY+nJu108GhVqX7k4ejSVuCT8QURbVveqxgw96w0e+hAVTXS+sZKx
         FzIA==
X-Gm-Message-State: AOAM531AvAxc7OXyztIkgrJHD9DlZyuZ9lijrPVoez9FjV8gMxHAugpV
        PTnQaTdJlsReX7GfBuy1preJfvJ75UVBIo2EtvGZXg==
X-Google-Smtp-Source: ABdhPJxS2tGwyzowqzneu6o5CJZtfmeuyDYEh1VZjNkBcphAs9augEPBSSqnjPUJKmZC/SuI0rk/coZkTseAyV62ltk=
X-Received: by 2002:a05:651c:1253:: with SMTP id h19mr9151673ljh.338.1643745220420;
 Tue, 01 Feb 2022 11:53:40 -0800 (PST)
MIME-Version: 1.0
References: <20220201010838.1494405-4-seanjc@google.com> <202202011400.EaZmWZ48-lkp@intel.com>
 <YfmNr8OjOWvsQBKx@google.com>
In-Reply-To: <YfmNr8OjOWvsQBKx@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 1 Feb 2022 11:53:28 -0800
Message-ID: <CAKwvOdkieUPcXgu4_GNmD_wpH5z2mzuDL+FTxRAQ4EqeF-WbvA@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: x86: Use __try_cmpxchg_user() to update guest
 PTE A/D bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 11:44 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Feb 01, 2022, kernel test robot wrote:
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from arch/x86/kvm/mmu/mmu.c:4246:
> > >> arch/x86/kvm/mmu/paging_tmpl.h:244:9: error: invalid output size for constraint '+a'
> >                    ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
> >                          ^
> >    arch/x86/include/asm/uaccess.h:629:11: note: expanded from macro '__try_cmpxchg_user'
> >            __ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);   \
> >                     ^
> >    arch/x86/include/asm/uaccess.h:606:18: note: expanded from macro 'unsafe_try_cmpxchg_user'
> >            case 1: __ret = __try_cmpxchg_user_asm("b", "q",                \
> >                            ^
> >    arch/x86/include/asm/uaccess.h:467:22: note: expanded from macro '__try_cmpxchg_user_asm'
> >                           [old] "+a" (__old)                               \
>
> #$*&(#$ clang.
>
> clang isn't smart enough to avoid compiling the impossible conditions it will
> throw away in the end, i.e. it compiles all cases given:
>
>   switch (8) {
>   case 1:
>   case 2:
>   case 4:
>   case 8:
>   }

This is because Clang generally handles diagnostics, while LLVM
handles optimizations, in a pipeline, in that order. In order to know
not to emit a diagnostic, optimizations need to be run.  Do you prefer
that diagnostics only get emitted for code not optimized out? In this
case, yes, but in others folks could reasonably desire the others.
Sorry, but this is a BIG architectural difference between compilers.

(FWIW; I've personally implemented warnings in clang that don't work
that way.  The tradeoff is excessive memory usage and work during
compile time to basically pessimistically emit the equivalent of debug
info, and do all the work that entails keeping it up to date as you
transform the code, even if it may never trigger a warning.  Changing
all diagnostics to work that way would be tantamount to rewriting most
of the frontend and would be slower and use more memory at runtime).

>
> I can fudge around that by casting the pointer, which I don't think can go sideways
> if the pointer value is a signed type?
>
> @@ -604,15 +602,15 @@ extern void __try_cmpxchg_user_wrong_size(void);
>         bool __ret;                                                     \
>         switch (sizeof(*(_ptr))) {                                      \
>         case 1: __ret = __try_cmpxchg_user_asm("b", "q",                \
> -                                              (_ptr), (_oldp),         \
> +                                              (u8 *)(_ptr), (_oldp),   \
>                                                (_nval), _label);        \
>                 break;                                                  \
>         case 2: __ret = __try_cmpxchg_user_asm("w", "r",                \
> -                                              (_ptr), (_oldp),         \
> +                                              (u16 *)(_ptr), (_oldp),  \
>                                                (_nval), _label);        \
>                 break;                                                  \
>         case 4: __ret = __try_cmpxchg_user_asm("l", "r",                \
> -                                              (_ptr), (_oldp),         \
> +                                              (u32 *)(_ptr), (_oldp),  \
>                                                (_nval), _label);        \
>                 break;                                                  \
>         case 8: __ret = __try_cmpxchg64_user_asm((_ptr), (_oldp),       \
>
>
> clang also lacks the intelligence to realize that it can/should use a single
> register for encoding the memory operand and consumes both ESI and EDI, leaving
> no register for the __err "+r" param in __try_cmpxchg64_user_asm().  That can be
> avoided by open coding CC_SET and using a single output register for both the
> result and the -EFAULT error path.



-- 
Thanks,
~Nick Desaulniers
