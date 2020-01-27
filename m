Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342E9149F9B
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 09:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgA0IOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 03:14:40 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43023 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0IOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 03:14:39 -0500
Received: by mail-ed1-f67.google.com with SMTP id dc19so9839409edb.10;
        Mon, 27 Jan 2020 00:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YYnwroKpA2nRDD4ithAnL2HDhzyOBBW3fti4xbSutyQ=;
        b=hgPg4IKG/a+3y0tJvqk6Y7XLQyO4PyaJ47evlWNP8KhIlTRM8z8GTRDIOs33u6awvS
         7XCSMATd7lHNCAmUGu2r4VhBC7/SlXlz1ugpYby18bsCb5Z8l0ClXVDoBy36xF4uFCjX
         pAgkq72eI2s2XDrDcEBxsXLp+vJU9myka6cOEI5dhhARdZJk/yaYtq0r1Aej1PtWJ/Jh
         2I8ie5D3ehfvQU7ADAocfEzo2RAKHjxA2/g2hQtjvXhiMUPxazCNf6qBSrh6R2qOQzQ2
         lgf2uiKbmzAqi8SrTZLOl1+pCIR1ZGetJbZQLCq9cXrbi0MfzZdDVkstRkpjC1Uhc006
         GJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YYnwroKpA2nRDD4ithAnL2HDhzyOBBW3fti4xbSutyQ=;
        b=Gk3xcQJpsW7LFu/46E+1K6pmtey75bojP8Bb2zKLdZw2q6o78nZgCAVCqIAXe6b7o7
         c5vQkDeze9mb+IrkqKDbx/Z2ncNgl2i/UYnsqX6RVFC6SgLJAXV7uyyGKw/9pJXIUfiz
         NeWSy/Zj1XIHaS/fi9E2VEK6ceFEA3oQn54hBRRMaVIot3+e77aJtuRn4Z9rV5zoO+N+
         RAZ111waEsz0Rq/dwC1YNTsv/WA9wNd+ggzMi9f9CsRrKSYhTVT3fOGX3k+zqkzB8sHP
         D2d2BYl/z7TCu8zm5HPusDh+FCyNOlsZ3NW93RYm4IPa45ycabpUq0CnFN1slKTFaU4U
         5MFw==
X-Gm-Message-State: APjAAAU6Y1EavU5/RI0ji9VhEFXTBrNVslNz+GaeFwXVCVMubcIRTndm
        wOUFK0yuQiOpa17ZI0z8Z9gIBIi3ZklSAYfnrMs=
X-Google-Smtp-Source: APXvYqxJ8d4By48//ETwe5RFDeKOX0dy082FbxHG/OjE+rw9M2sZgLdEJC+Qh9m4O1O3dm/oXYrjW9xhPYRbBd/5l1Q=
X-Received: by 2002:a17:906:eb91:: with SMTP id mh17mr11719153ejb.54.1580112877830;
 Mon, 27 Jan 2020 00:14:37 -0800 (PST)
MIME-Version: 1.0
References: <20200127071602.11460-1-nick.desaulniers@gmail.com> <20200127080935.GH14914@hirez.programming.kicks-ass.net>
In-Reply-To: <20200127080935.GH14914@hirez.programming.kicks-ass.net>
From:   Nick Desaulniers <nick.desaulniers@gmail.com>
Date:   Mon, 27 Jan 2020 00:14:27 -0800
Message-ID: <CAH7mPvi9uH6210Np2GmzaMDY7k7MNRaBZdwhPakLu8ZEfoq0pQ@mail.gmail.com>
Subject: Re: [PATCH] dynamically allocate struct cpumask
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bp@alien8.de,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 12:09 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sun, Jan 26, 2020 at 11:16:02PM -0800, Nick Desaulniers wrote:
> > This helps avoid avoid a potentially large stack allocation.
> >
> > When building with:
> > $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> > The following warning is observed:
> > arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> > function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> > static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> > vector)
> >             ^
> > Debugging with:
> > https://github.com/ClangBuiltLinux/frame-larger-than
> > via:
> > $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
> >   kvm_send_ipi_mask_allbutself
> > points to the stack allocated `struct cpumask newmask` in
> > `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> > potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> > the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> > 8192, making a single instance of a `struct cpumask` 1024 B.
> >
> > Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
> > ---
> >  arch/x86/kernel/kvm.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 32ef1ee733b7..d41c0a0d62a2 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -494,13 +494,15 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
> >  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
> >  {
> >       unsigned int this_cpu = smp_processor_id();
> > -     struct cpumask new_mask;
>
> Right, on stack cpumask is definitely dodgy.
>
> > +     struct cpumask *new_mask;
> >       const struct cpumask *local_mask;
> >
> > -     cpumask_copy(&new_mask, mask);
> > -     cpumask_clear_cpu(this_cpu, &new_mask);
> > -     local_mask = &new_mask;
> > +     new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);

Probably should check for allocation failure, d'oh!

> > +     cpumask_copy(new_mask, mask);
> > +     cpumask_clear_cpu(this_cpu, new_mask);
> > +     local_mask = new_mask;
> >       __send_ipi_mask(local_mask, vector);
> > +     kfree(new_mask);
> >  }
>
> One alternative approach is adding the inverse of cpu_bit_bitmap. I'm
> not entirely sure how often we need the all-but-self mask, but ISTR
> there were other places too.
