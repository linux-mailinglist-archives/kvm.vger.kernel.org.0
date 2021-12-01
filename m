Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20EA4658F5
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 23:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbhLAWSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 17:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbhLAWSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 17:18:18 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A3DC061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 14:14:56 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id l7so51026640lja.2
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 14:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7UDskhK3Oqq30ngC8iXYIuuaaFtVwMvQOmqpFrFvuA=;
        b=Q7Fb03JoPcZ2Km/5jcYGA6p16pkN1MXOBfH7kotJRCyBpaFEuUNh/HR3j7oxely2fy
         GS4aeIV2mkf+faXZ3NCvlSxflZlAO91WCuoNcV1hX/XoO9zLXLT4HOlZLeRpbZqkHQh8
         qXKTvJG86vZ+F8nMphSvGMpHhlKoovIoG+97y1sqsj+9x5lEzwNk58u39aso+QRFY1Ih
         5s+03+N2la7vqxsFO/fZpq0aAVZ+PeaQ5zzPLO8b3xkcnBoVOB6ILsor945Gkf4w4XmB
         XVQ2+ibrxRLtj0gTTus9gURUdTaF8sw/oQZYY1njeseMSwDNqkmKJ1cv81T6krmnKFJ2
         GqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7UDskhK3Oqq30ngC8iXYIuuaaFtVwMvQOmqpFrFvuA=;
        b=MShkIcmPEjZsBhsRHUVBrQzx14oUPSUiKLmMLvijGGXEQbgWZ8SEzs+d5QxrK/X5/0
         Kyx5SBaQWDA/NYR79Fm4UXsBN8bm77hGBK2BBNrAXesydme9QuA+DVxMyHUuy+r7LrWn
         xJHJ9td8uQOFMdE91q/OZ3jJW0t3ZsrK2ghNi1CcffEbHPThncwCLs17HB1v/nf2fu5p
         pxyScpJ0+RaiYKJK2lr16Bo2kLuoWMYdu2ADqC9socD8Q3LGV8YWAskOAPm3XC99OQ8b
         Er9AgAnOUf6veMLpYWCeKvjKeGkwiDhU3QF9CdE89REwMWMpy9Cvo68rtVANu4RgUW5T
         j+3Q==
X-Gm-Message-State: AOAM531gEAS0iK8ZNi77g64xRrdnm2cFVBaGArQ06fgp937A0NxpfUE4
        t43F2ilLaDovBwq0PEGOCmtHTMxozV7CIieZO/qBE1XDfjM=
X-Google-Smtp-Source: ABdhPJzhezu3yg46epYLKkyD6Pk6aPhu3WSepg+UF8xpc2awShbm4U5858JSOBWSLenOnEeH+Qy9MvcgnS6P0VWz0jU=
X-Received: by 2002:a2e:8156:: with SMTP id t22mr8241859ljg.223.1638396894377;
 Wed, 01 Dec 2021 14:14:54 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-14-dmatlack@google.com>
 <YaDQSKnZ3bN501Ml@xz-m1.local> <CALzav=fVd4mLMyf6RBS=yDuN+hMM0hoa7+YHdYucRcJDjD4EfA@mail.gmail.com>
 <CALzav=ex+5y7-5a-8Vum2-eOKuKYe=RU9NvrS82H=sTwj2mqaw@mail.gmail.com> <Yab0JRVmwyr1GL3Y@xz-m1.local>
In-Reply-To: <Yab0JRVmwyr1GL3Y@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 14:14:27 -0800
Message-ID: <CALzav=etCjq=9BukQ4vF49wOsE+pdGRGLHqy5jfzFaeHaZBoUg@mail.gmail.com>
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 8:04 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Nov 30, 2021 at 04:17:01PM -0800, David Matlack wrote:
> > On Tue, Nov 30, 2021 at 4:16 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On Fri, Nov 26, 2021 at 4:17 AM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > On Fri, Nov 19, 2021 at 11:57:57PM +0000, David Matlack wrote:
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index 6768ef9c0891..4e78ef2dd352 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> > > > >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> > > > >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> > > > >
> > > > > +             /*
> > > > > +              * Try to proactively split any large pages down to 4KB so that
> > > > > +              * vCPUs don't have to take write-protection faults.
> > > > > +              */
> > > > > +             kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
> > > > > +
> > > > >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> > > > >
> > > > >               /* Cross two large pages? */
> > > >
> > > > Is it intended to try split every time even if we could have split it already?
> > > > As I remember Paolo mentioned that we can skip split if it's not the 1st
> > > > CLEAR_LOG on the same range, and IIUC that makes sense.
> > > >
> > > > But indeed I don't see a trivial way to know whether this is the first clear of
> > > > this range.  Maybe we can maintain "how many huge pages are there under current
> > > > kvm_mmu_page node" somehow?  Then if root sp has the counter==0, then we can
> > > > skip it.  Just a wild idea..
> > > >
> > > > Or maybe it's intended to try split unconditionally for some reason?  If so
> > > > it'll be great to mention that either in the commit message or in comments.
> > >
> > > Thanks for calling this out. Could the same be said about the existing
> > > code that unconditionally tries to write-protect 2M+ pages?
>
> They're different because wr-protect can be restored (to be not-wr-protected)
> when vcpu threads write to the pages, so they need to be always done.

That's true for 4K pages, but not for write-protecting 2M+ pages
(which is what we're discussing here). Once KVM write-protects a 2M+
page, it should never need to write-protect it again, but we always
try to here. Same goes with splitting.

>
> For huge page split - when it happened during dirty tracking it'll not be
> recovered anymore, so it's a one-time thing.
>
> > > I aimed to keep parity with the write-protection calls (always try to split
> > > before write-protecting) but I agree there might be opportunities available
> > > to skip altogether.
>
> So IMHO it's not about parity but it could be about how easy can it be
> implemented, and whether it'll be worth it to add that complexity.

Agreed.

>
> Besides the above accounting idea per-sp, we can have other ways to do this
> too, e.g., keeping a bitmap showing which range has been split: that bitmap
> will be 2M in granule for x86 because that'll be enough.  We init-all-ones for
> the bitmap when start logging for a memslot.
>
> But again maybe it turns out we don't really want that complexity.
>
> IMHO a good start could be the perf numbers (which I asked in the cover letter)
> comparing the overhead of 2nd+ iterations of CLEAR_LOG with/without eager page
> split.

Ack. I'll be sure to include these in v1!

>
> > >
> > > By the way, looking at this code again I think I see some potential bugs:
> > >  - I don't think I ever free split_caches in the initially-all-set case.
>
> I saw that it's freed in kvm_mmu_try_split_large_pages(), no?

Ah yes you are right. I misremembered how I implemented it and thought
we kept the split_caches around across calls to CLEAR_LOG. (We
probably should TBH. The current implementation is quite wasteful.)

>
> > >  - What happens if splitting fails the CLEAR_LOG but succeeds the
> > > CLEAR_LOG?
> >
> > Gah, meant to say "first CLEAR_LOG" and "second CLEAR_LOG" here.
> >
> > > We would end up propagating the write-protection on the 2M
> > > page down to the 4K page. This might cause issues if using PML.
>
> Hmm looks correct.. I'm wondering what will happen with that.
>
> Firstly this should be rare as the 1st split should in 99% cases succeed.
>
> Then if split failed at the 1st attempt, we wr-protected sptes even during pml
> during the split.  When written, we'll go the fast page fault and record the
> writes too, I think, as we'll apply dirty bit to the new spte so I think it'll
> just skip pml.  Looks like we'll be using a mixture of pml+wp but all dirty
> will still be captured as exptected?..

That's what I was hoping for. I'll double check for v1.

>
> There could be leftover wp when stopping dirty logging, but that seems not
> directly harmful too.  It'll make things a bit messed up, at least.
>
> --
> Peter Xu
>
