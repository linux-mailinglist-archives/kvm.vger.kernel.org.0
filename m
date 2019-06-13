Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E69F44702
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfFMQ4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbfFMBaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 21:30:17 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A66C02177E
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560389416;
        bh=245hSvEJ1fyVQ/NUoZsypuMJ69r/WWckga7/iHsIA6Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2ZR5cg5qXeIW8QeSueU+v+XoVtJwJqgh/zbPK+Vh23DiNB76z6igVBk5QmFjC4Q/b
         GYn8i0J6URP72JalBhebTaSz6TzlBV+Qnr5O7B+twJgiUQVPaKaKwsqofehUrHIiSR
         AYRWMsmaxcXIZJR9IifMDN2N37eieMRhYyWPJmug=
Received: by mail-wr1-f54.google.com with SMTP id f9so18821043wre.12
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 18:30:16 -0700 (PDT)
X-Gm-Message-State: APjAAAUXpFCZKPqQZzOe+b8XEqhimFshzeAq4qW+u5r0Ue2K+EklN5Rh
        CFqjJOhD4TDZ+mZ2yoRj4TXuTdgoDWTDLucP1rkihA==
X-Google-Smtp-Source: APXvYqy3xOlRMyGf+QmnX5kkUuMj4E/JOwcOVlo4m18xwdccaTtfWmajwtmET8pdpGl6blYVFY3m4ysGcKL2J5xWm7w=
X-Received: by 2002:adf:ef48:: with SMTP id c8mr35692572wrp.352.1560389415200;
 Wed, 12 Jun 2019 18:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
In-Reply-To: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 12 Jun 2019 18:30:03 -0700
X-Gmail-Original-Message-ID: <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
Message-ID: <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
To:     Dave Hansen <dave.hansen@intel.com>, Nadav Amit <namit@vmware.com>
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 1:27 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
>
>
> > On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote=
:
> >
> >> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> >> This patch series proposes to introduce a region for what we call
> >> process-local memory into the kernel's virtual address space.
> >
> > It might be fun to cc some x86 folks on this series.  They might have
> > some relevant opinions. ;)
> >
> > A few high-level questions:
> >
> > Why go to all this trouble to hide guest state like registers if all th=
e
> > guest data itself is still mapped?
> >
> > Where's the context-switching code?  Did I just miss it?
> >
> > We've discussed having per-cpu page tables where a given PGD is only in
> > use from one CPU at a time.  I *think* this scheme still works in such =
a
> > case, it just adds one more PGD entry that would have to context-switch=
ed.
>
> Fair warning: Linus is on record as absolutely hating this idea. He might=
 change his mind, but it=E2=80=99s an uphill battle.

I looked at the patch, and it (sensibly) has nothing to do with
per-cpu PGDs.  So it's in great shape!

Seriously, though, here are some very high-level review comments:

Please don't call it "process local", since "process" is meaningless.
Call it "mm local" or something like that.

We already have a per-mm kernel mapping: the LDT.  So please nix all
the code that adds a new VA region, etc, except to the extent that
some of it consists of valid cleanups in and of itself.  Instead,
please refactor the LDT code (arch/x86/kernel/ldt.c, mainly) to make
it use a more general "mm local" address range, and then reuse the
same infrastructure for other fancy things.  The code that makes it
KASLR-able should be in its very own patch that applies *after* the
code that makes it all work so that, when the KASLR part causes a
crash, we can bisect it.

+ /*
+ * Faults in process-local memory may be caused by process-local
+ * addresses leaking into other contexts.
+ * tbd: warn and handle gracefully.
+ */
+ if (unlikely(fault_in_process_local(address))) {
+ pr_err("page fault in PROCLOCAL at %lx", address);
+ force_sig_fault(SIGSEGV, SEGV_MAPERR, (void __user *)address, current);
+ }
+

Huh?  Either it's an OOPS or you shouldn't print any special
debugging.  As it is, you're just blatantly leaking the address of the
mm-local range to malicious user programs.

Also, you should IMO consider using this mechanism for kmap_atomic().
Hi, Nadav!
