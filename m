Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE3F1C07D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 04:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfENCHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 22:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfENCHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 22:07:50 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F935216B7
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 02:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557799669;
        bh=194cYzJSEWelAQdAamSQ+HGCjU5m9KnJ95hz0wnBDOw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AWYLnYQXqecynVt8YdrwsS+Xfe7b6aCvx26D2JOr6eOFfLp34kg8+aoO6xKlIGs+n
         if+Vo2q8fZoCeysFzcDiUsbbBG2udM5TCiMj02dJ8dNOct9/ZqVispF3WQeOuagvIo
         NudBGjsk7KLG9PNcK2KUdJ8z3KuRVee+3Ctp2/cA=
Received: by mail-wm1-f52.google.com with SMTP id c66so1209360wme.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 19:07:49 -0700 (PDT)
X-Gm-Message-State: APjAAAUzshkBAXF+SbQ6JOgAoRj+5MkDADijEgl1nLy5baRSyP0tt+3i
        23wqVqZFpu4pwU9D3sYZI86yjhPJXuYwzBj6J0qyyg==
X-Google-Smtp-Source: APXvYqzLSJXQVwKfkewbLcE7v0r0bhXbJZ1wHCUTLEQOaL5ypCYuhmil6I3fNQ+XQ6Dh66OKap38pkC6fcXCiEHQ6uk=
X-Received: by 2002:a7b:c844:: with SMTP id c4mr6663648wml.108.1557799667844;
 Mon, 13 May 2019 19:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrVhRt0vPgcun19VBqAU_sWUkRg1RDVYk4osY6vK0SKzgg@mail.gmail.com> <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
In-Reply-To: <C2A30CC6-1459-4182-B71A-D8FF121A19F2@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 19:07:36 -0700
X-Gmail-Original-Message-ID: <CALCETrXK8+tUxNA=iVDse31nFRZyiQYvcrQxV1JaidhnL4GC0w@mail.gmail.com>
Message-ID: <CALCETrXK8+tUxNA=iVDse31nFRZyiQYvcrQxV1JaidhnL4GC0w@mail.gmail.com>
Subject: Re: [RFC KVM 00/27] KVM Address Space Isolation
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 2:09 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 13 May 2019, at 21:17, Andy Lutomirski <luto@kernel.org> wrote:
> >
> >> I expect that the KVM address space can eventually be expanded to incl=
ude
> >> the ioctl syscall entries. By doing so, and also adding the KVM page t=
able
> >> to the process userland page table (which should be safe to do because=
 the
> >> KVM address space doesn't have any secret), we could potentially handl=
e the
> >> KVM ioctl without having to switch to the kernel pagetable (thus effec=
tively
> >> eliminating KPTI for KVM). Then the only overhead would be if a VM-Exi=
t has
> >> to be handled using the full kernel address space.
> >>
> >
> > In the hopefully common case where a VM exits and then gets re-entered
> > without needing to load full page tables, what code actually runs?
> > I'm trying to understand when the optimization of not switching is
> > actually useful.
> >
> > Allowing ioctl() without switching to kernel tables sounds...
> > extremely complicated.  It also makes the dubious assumption that user
> > memory contains no secrets.
>
> Let me attempt to clarify what we were thinking when creating this patch =
series:
>
> 1) It is never safe to execute one hyperthread inside guest while it=E2=
=80=99s sibling hyperthread runs in a virtual address space which contains =
secrets of host or other guests.
> This is because we assume that using some speculative gadget (such as hal=
f-Spectrev2 gadget), it will be possible to populate *some* CPU core resour=
ce which could then be *somehow* leaked by the hyperthread running inside g=
uest. In case of L1TF, this would be data populated to the L1D cache.
>
> 2) Because of (1), every time a hyperthread runs inside host kernel, we m=
ust make sure it=E2=80=99s sibling is not running inside guest. i.e. We mus=
t kick the sibling hyperthread outside of guest using IPI.
>
> 3) From (2), we should have theoretically deduced that for every #VMExit,=
 there is a need to kick the sibling hyperthread also outside of guest unti=
l the #VMExit is completed. Such a patch series was implemented at some poi=
nt but it had (obviously) significant performance hit.
>
>
4) The main goal of this patch series is to preserve (2), but to avoid
the overhead specified in (3).
>
> The way this patch series achieves (4) is by observing that during the ru=
n of a VM, most #VMExits can be handled rather quickly and locally inside K=
VM and doesn=E2=80=99t need to reference any data that is not relevant to t=
his VM or KVM code. Therefore, if we will run these #VMExits in an isolated=
 virtual address space (i.e. KVM isolated address space), there is no need =
to kick the sibling hyperthread from guest while these #VMExits handlers ru=
n.

Thanks!  This clarifies a lot of things.

> The hope is that the very vast majority of #VMExit handlers will be able =
to completely run without requiring to switch to full address space. Theref=
ore, avoiding the performance hit of (2).
> However, for the very few #VMExits that does require to run in full kerne=
l address space, we must first kick the sibling hyperthread outside of gues=
t and only then switch to full kernel address space and only once all hyper=
threads return to KVM address space, then allow then to enter into guest.

What exactly does "kick" mean in this context?  It sounds like you're
going to need to be able to kick sibling VMs from extremely atomic
contexts like NMI and MCE.
