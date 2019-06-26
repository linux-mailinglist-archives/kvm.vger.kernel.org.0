Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF45610A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 05:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfFZD4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 23:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfFZD4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 23:56:48 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C703D21738
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 03:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561521407;
        bh=m/TvZtPmYzBwsHH7PDZA6nQYn+T03CeNEhiZVVnWsKY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hqIVIEiOJwZdhDQAjpk4J8je2WINB7pB8kOy5+53nJpdRQoCFFAzS9UoK/oUJuVmj
         d8/Hz60QbKRbQkFSxbFVYOQ5K4Bo0X3gnpSoCcNnR0066qL5c+udfr/f1We43mMJ3F
         yCJMBQr1TP68VNycX8kFHUH1SXoG3VTxGF8xv3YU=
Received: by mail-wr1-f41.google.com with SMTP id n4so942129wrs.3
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 20:56:46 -0700 (PDT)
X-Gm-Message-State: APjAAAWIEkFDUQJofZrcZ1YcRhtFGekJEnClp88SPNkI+Btk6G3GYbAx
        oWDz6MUewT0TnUx1Hpg8NFKFchg1SbIpU478SFlMNw==
X-Google-Smtp-Source: APXvYqzBKxXRyJ7+G7lM4wmtqaiyQkbPGzCk4bXMoyeBgLmv7h+moXJc4QyB84kKQyi9VQBMgXJ4YdzUaq1onQW2rF8=
X-Received: by 2002:adf:f606:: with SMTP id t6mr1202807wrp.265.1561521405326;
 Tue, 25 Jun 2019 20:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190613064813.8102-1-namit@vmware.com> <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com> <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
 <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com> <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com>
In-Reply-To: <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 25 Jun 2019 20:56:34 -0700
X-Gmail-Original-Message-ID: <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com>
Message-ID: <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
To:     Nadav Amit <namit@vmware.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 8:41 PM Nadav Amit <namit@vmware.com> wrote:
>
> > On Jun 25, 2019, at 8:35 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Tue, Jun 25, 2019 at 7:39 PM Nadav Amit <namit@vmware.com> wrote:
> >>> On Jun 25, 2019, at 2:40 PM, Dave Hansen <dave.hansen@intel.com> wrot=
e:
> >>>
> >>> On 6/12/19 11:48 PM, Nadav Amit wrote:
> >>>> Support the new interface of flush_tlb_multi, which also flushes the
> >>>> local CPU's TLB, instead of flush_tlb_others that does not. This
> >>>> interface is more performant since it parallelize remote and local T=
LB
> >>>> flushes.
> >>>>
> >>>> The actual implementation of flush_tlb_multi() is almost identical t=
o
> >>>> that of flush_tlb_others().
> >>>
> >>> This confused me a bit.  I thought we didn't support paravirtualized
> >>> flush_tlb_multi() from reading earlier in the series.
> >>>
> >>> But, it seems like that might be Xen-only and doesn't apply to KVM an=
d
> >>> paravirtualized KVM has no problem supporting flush_tlb_multi().  Is
> >>> that right?  It might be good to include some of that background in t=
he
> >>> changelog to set the context.
> >>
> >> I=E2=80=99ll try to improve the change-logs a bit. There is no inheren=
t reason for
> >> PV TLB-flushers not to implement their own flush_tlb_multi(). It is le=
ft
> >> for future work, and here are some reasons:
> >>
> >> 1. Hyper-V/Xen TLB-flushing code is not very simple
> >> 2. I don=E2=80=99t have a proper setup
> >> 3. I am lazy
> >
> > In the long run, I think that we're going to want a way for one CPU to
> > do a remote flush and then, with appropriate locking, update the
> > tlb_gen fields for the remote CPU.  Getting this right may be a bit
> > nontrivial.
>
> What do you mean by =E2=80=9Cdo a remote flush=E2=80=9D?
>

I mean a PV-assisted flush on a CPU other than the CPU that started
it.  If you look at flush_tlb_func_common(), it's doing some work that
is rather fancier than just flushing the TLB.  By replacing it with
just a pure flush on Xen or Hyper-V, we're losing the potential CR3
switch and this bit:

        /* Both paths above update our state to mm_tlb_gen. */
        this_cpu_write(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, mm_tlb_ge=
n);

Skipping the former can hurt idle performance, although we should
consider just disabling all the lazy optimizations on systems with PV
flush.  (And I've asked Intel to help us out here in future hardware.
I have no idea what the result of asking will be.)  Skipping the
cpu_tlbstate write means that we will do unnecessary flushes in the
future, and that's not doing us any favors.

In principle, we should be able to do something like:

flush_tlb_multi(...);
for(each CPU that got flushed) {
  spin_lock(something appropriate?);
  per_cpu_write(cpu, cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, f->new_tlb_=
gen);
  spin_unlock(...);
}

with the caveat that it's more complicated than this if the flush is a
partial flush, and that we'll want to check that the ctx_id still
matches, etc.

Does this make sense?
