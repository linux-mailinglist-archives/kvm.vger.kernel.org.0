Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1343244153
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfFMQNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbfFMQNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:13:32 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C3C20866
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560442411;
        bh=RT5ARPzRqXVzJnJRWsb4aSjhGlmdp5Dxz378/CaIaL8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jWx9jUqtLSoaTp6fq+ZAAyQ249hwyTuIESHQFGBVCjKixn7/1ja8wEJimcZC/RHpn
         pCBiMesN1fFQLGNQ8iuL4wl4nlAaSxRT83DkPLRTkxS+bcrGL0KrOidd2suiElr21e
         M90biM2nPQBDCFYQ8S8h4xN5nWWeR+4zq6h/Nm8Y=
Received: by mail-wm1-f49.google.com with SMTP id h19so6959669wme.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 09:13:31 -0700 (PDT)
X-Gm-Message-State: APjAAAV1nQ7X7MZABT9Vnws0DiB/C/Vbyu2b/ZCplEEklVE9+H5+EfpM
        vW6/0f3Y+q2ORJI0xs6AQinIeuj2iDEeEyXwshUzXg==
X-Google-Smtp-Source: APXvYqxORucqKuGLKjes9H2wam29KDoQdYjsLf9dyQzWSteNOhlzCVgUt/QAWlV6lgXowPWhEDBN5CK0AZlXmczTjmM=
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr4464357wmj.79.1560442410236;
 Thu, 13 Jun 2019 09:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
 <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
In-Reply-To: <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 13 Jun 2019 09:13:19 -0700
X-Gmail-Original-Message-ID: <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
Message-ID: <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
To:     Alexander Graf <graf@amazon.com>, Nadav Amit <namit@vmware.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 12:53 AM Alexander Graf <graf@amazon.com> wrote:
>
>
> On 13.06.19 03:30, Andy Lutomirski wrote:
> > On Wed, Jun 12, 2019 at 1:27 PM Andy Lutomirski <luto@amacapital.net> w=
rote:
> >>
> >>
> >>> On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wro=
te:
> >>>
> >>>> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> >>>> This patch series proposes to introduce a region for what we call
> >>>> process-local memory into the kernel's virtual address space.
> >>> It might be fun to cc some x86 folks on this series.  They might have
> >>> some relevant opinions. ;)
> >>>
> >>> A few high-level questions:
> >>>
> >>> Why go to all this trouble to hide guest state like registers if all =
the
> >>> guest data itself is still mapped?
> >>>
> >>> Where's the context-switching code?  Did I just miss it?
> >>>
> >>> We've discussed having per-cpu page tables where a given PGD is only =
in
> >>> use from one CPU at a time.  I *think* this scheme still works in suc=
h a
> >>> case, it just adds one more PGD entry that would have to context-swit=
ched.
> >> Fair warning: Linus is on record as absolutely hating this idea. He mi=
ght change his mind, but it=E2=80=99s an uphill battle.
> > I looked at the patch, and it (sensibly) has nothing to do with
> > per-cpu PGDs.  So it's in great shape!
>
>
> Thanks a lot for the very timely review!
>
>
> >
> > Seriously, though, here are some very high-level review comments:
> >
> > Please don't call it "process local", since "process" is meaningless.
> > Call it "mm local" or something like that.
>
>
> Naming is hard, yes :). Is "mmlocal" obvious enough to most readers? I'm
> not fully convinced, but I don't find it better or worse than proclocal.
> So whatever flies with the majority works for me :).

My objection to "proc" is that we have many concepts of "process" in
the kernel: task, mm, signal handling context, etc.  These memory
ranges are specifically local to the mm.  Admittedly, it would be very
surprising to have memory that is local to a signal handling context,
but still.

>
>
> > We already have a per-mm kernel mapping: the LDT.  So please nix all
> > the code that adds a new VA region, etc, except to the extent that
> > some of it consists of valid cleanups in and of itself.  Instead,
> > please refactor the LDT code (arch/x86/kernel/ldt.c, mainly) to make
> > it use a more general "mm local" address range, and then reuse the
> > same infrastructure for other fancy things.  The code that makes it
>
>
> I don't fully understand how those two are related. Are you referring to
> the KPTI enabling code in there? That just maps the LDT at the same
> address in both kernel and user mappings, no?

The relevance here is that, when KPTI is on, the exact same address
refers to a different LDT in different mms, so it's genuinely an
mm-local mapping.  It works just like yours: a whole top-level paging
entry is reserved for it.  What I'm suggesting is that, when you're
all done, the LDT should be more or less just one more mm-local
mapping, with two caveats.  First, the LDT needs special KPTI
handling, but that's fine.  Second, the LDT address is visible to user
code on non-UMIP systems, so you'll have to decide if that's okay.  My
suggestion is to have the LDT be the very first address in the
mm-local range and then to randomize everything else in the mm-local
range.

>
> So you're suggesting we use the new mm local address as LDT address
> instead and have that mapped in both kernel and user space? This patch
> set today maps "mm local" data only in kernel space, not in user space,
> as it's meant for kernel data structures.

Yes, exactly.

>
> So I'm not really seeing the path to adapt any of the LDT logic to this.
> Could you please elaborate?
>
>
> > KASLR-able should be in its very own patch that applies *after* the
> > code that makes it all work so that, when the KASLR part causes a
> > crash, we can bisect it.
>
>
> That sounds very reasonable, yes.
>
>
> >
> > + /*
> > + * Faults in process-local memory may be caused by process-local
> > + * addresses leaking into other contexts.
> > + * tbd: warn and handle gracefully.
> > + */
> > + if (unlikely(fault_in_process_local(address))) {
> > + pr_err("page fault in PROCLOCAL at %lx", address);
> > + force_sig_fault(SIGSEGV, SEGV_MAPERR, (void __user *)address, current=
);
> > + }
> > +
> >
> > Huh?  Either it's an OOPS or you shouldn't print any special
> > debugging.  As it is, you're just blatantly leaking the address of the
> > mm-local range to malicious user programs.
>
>
> Yes, this is a left over bit from an idea that we discussed and rejected
> yesterday. The idea was to have a DEBUG config option that allows
> proclocal memory to leak into other processes, but print debug output so
> that it's easier to catch bugs. After discussion, I think we managed to
> convince everyone that an OOPS is the better tool to find bugs :).
>
> Any trace of this will disappear in the next version.
>
>
> >
> > Also, you should IMO consider using this mechanism for kmap_atomic().
>
>
> It might make sense to use it for kmap_atomic() for debug purposes, as
> it ensures that other users can no longer access the same mapping
> through the linear map. However, it does come at quite a big cost, as we
> need to shoot down the TLB of all other threads in the system. So I'm
> not sure it's of general value?

What I meant was that kmap_atomic() could use mm-local memory so that
it doesn't need to do a global shootdown.  But I guess it's not
actually used for real on 64-bit, so this is mostly moot.  Are you
planning to support mm-local on 32-bit?

--Andy
>
>
> Alex
>
>
> > Hi, Nadav!
