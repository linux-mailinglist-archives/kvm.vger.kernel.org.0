Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D614C3EF791
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 03:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhHRBgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 21:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbhHRBgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 21:36:48 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E2FC061764;
        Tue, 17 Aug 2021 18:36:14 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id x5so554913ill.3;
        Tue, 17 Aug 2021 18:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mTlSpJCOzYSWnHbCprL/LUgcu5gZ9W6lRJHq3m6wgZk=;
        b=iW5IOfKJ/qGWdHJ2LaVQt4BPBwNdma2W7XPIbEedF5x9QtSmWqXi0t47R7gspHSAE9
         YMfgUbj1wDyH2kIO/W3JZVL6coNuCmVvmzoTAgGWemMjql3So83TMdBOVa/ueZ+4ZzBM
         FwO8dty9fGehQjQY1x0AEyMctRUHFIz3gNx0Pu95jf62/M0CGdemV+i+Ik8YBd89Iytt
         txf/q7UXb00R2G+mbHAAifqw4FnvV7ffP3AdQBjtv+Hud9Ahm9L5Fn/0AyJFOE8OeHba
         innVQtnFRhnjNKmK+ARDpeUo2BAqS+syMCUENoHb4mYtvrVQEjlfD5QN/6IDLxrtSb/l
         QJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mTlSpJCOzYSWnHbCprL/LUgcu5gZ9W6lRJHq3m6wgZk=;
        b=EBXpqFOq3ZJzNx9ktuIcBlKEpTmw17VgBxBszrtWvO8erj3B9SV/PBF3ugBlmrOcuk
         u/r8/N8/Ashbp7xiCsCl4IUBqQ6TgfvQQwi6LdpZcSvZU5jVAkT8N4yD8pIZL1Jxzo7Q
         O0S99Q2l2idJswJ3Gs4LRtf4VDBkEP2uY7fAX+e9MKMmZBkZdOdlOBbWrECJGQgAxmrb
         Cdw57dtuRETR1KpG6tJZipB2dERhKUY8wXobXkyHo0Ejw00QhZUAHJMu3jXKtAtoODQQ
         l51uGeJL6oy6kC43WZFTvT7cY8vCEA0NfQQiulCtqjJmqTsnW/PPzUL6dVq7FiVxETIm
         /K6g==
X-Gm-Message-State: AOAM530ipW7qS4ELYyCfnvFGQ8A8Zl/j+P4j0agFkR7Llt0eo5+RlZIo
        xGQ1LBu731GxvTl32eheqxufCvg89XkM9KK+YVQH7UzK
X-Google-Smtp-Source: ABdhPJyxUkahOsLKnX8Ep/9lBH+xqyhCNmyJPUcgJpmnQvOulOk8TGU+hJcupEH8yrzbehczHT9tghdgUkVkYpsU/30=
X-Received: by 2002:a05:6e02:13f3:: with SMTP id w19mr4242402ilj.164.1629250573650;
 Tue, 17 Aug 2021 18:36:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210814035129.154242-1-jiangshanlai@gmail.com>
In-Reply-To: <20210814035129.154242-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 18 Aug 2021 09:36:02 +0800
Message-ID: <CAJhGHyBbWBwyVZvcT_ExghfDp_D+nw_s=izcgjBcLXnPjmWbdA@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Don't enable IRQ when IRQ enabled in kvm_wait
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping

On Sat, Aug 14, 2021 at 9:36 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> Commit f4e61f0c9add3 ("x86/kvm: Fix broken irq restoration in kvm_wait")
> replaced "local_irq_restore() when IRQ enabled" with "local_irq_enable()
> when IRQ enabled" to suppress a warnning.
>
> Although there is no similar debugging warnning for doing local_irq_enable()
> when IRQ enabled as doing local_irq_restore() in the same IRQ situation.  But
> doing local_irq_enable() when IRQ enabled is no less broken as doing
> local_irq_restore() and we'd better avoid it.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>
> The original debugging warnning was introduced in commit 997acaf6b4b5
> ("lockdep: report broken irq restoration").  I think a similar debugging
> check and warnning should also be added to "local_irq_enable() when IRQ
> enabled" and even maybe "local_irq_disable() when IRQ disabled" to detect
> something this:
>
>     | local_irq_save(flags);
>     | local_irq_disable();
>     | local_irq_restore(flags);
>     | local_irq_enable();
>
> Or even we can do the check in lockdep+TRACE_IRQFLAGS:
>
> In lockdep_hardirqs_on_prepare(), lockdep_hardirqs_enabled() was checked
> (and exit) before checking DEBUG_LOCKS_WARN_ON(!irqs_disabled()), so lockdep
> can't give any warning for these kind of situations.  If we did the check
> in lockdep, we would have found the problem before, and we don't need
> 997acaf6b4b5.
>
> Any thought? Mark? Peter?
>
>  arch/x86/kernel/kvm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a26643dc6bd6..b656456c3a94 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -884,10 +884,11 @@ static void kvm_wait(u8 *ptr, u8 val)
>         } else {
>                 local_irq_disable();
>
> +               /* safe_halt() will enable IRQ */
>                 if (READ_ONCE(*ptr) == val)
>                         safe_halt();
> -
> -               local_irq_enable();
> +               else
> +                       local_irq_enable();
>         }
>  }
>
> --
> 2.19.1.6.gb485710b
>
