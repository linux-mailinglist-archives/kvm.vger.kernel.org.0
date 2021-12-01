Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C5F4645A9
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 05:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346506AbhLAEHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 23:07:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241642AbhLAEHX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 23:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638331442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C+rfPhUKb3JyehGWWWgyzhHiBp5TcCj24f+B/X8FsXk=;
        b=ZWhCxwX4UkEw3PcDN+x60SQsW+48EqPBB4HxZU26Dk1tKbX2dAROiqToGgjMCV6TsqTkIG
        DPDzi2T1/bj18A3s+ti35i0WLqifeFRALnpljwkk3lZopzHoBe7shQawHri53WOdYO/b+i
        yIrKFaBW4Q8F7HvO2pAf055h50l1Gq4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-L1qFOnGyN3GTxDp8gWlwUg-1; Tue, 30 Nov 2021 23:04:00 -0500
X-MC-Unique: L1qFOnGyN3GTxDp8gWlwUg-1
Received: by mail-wm1-f72.google.com with SMTP id l4-20020a05600c1d0400b00332f47a0fa3so136784wms.8
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 20:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C+rfPhUKb3JyehGWWWgyzhHiBp5TcCj24f+B/X8FsXk=;
        b=GY0fJ22y/L+tGkGVZrI+aQdpIMZXUigbeGdHAaC3VuO2a35W1yCkE/ObWxZv8vCsvW
         NYcL2OeKpmaQNMkDnM/izrlnOJCJ5HL1QJNP77Iv6VOxd4gniLNDL8tIKdR00D4lTp86
         wdfCm5bdmnyiC8cm6d/DIXmcZg0qONtSVck8vGvr8DTzrua8N1KeqYjJ9ABOlP+zAB8J
         ZERPSinfJiRVeqzq+BZnInksrN4I/xIo67yqTZDQa5/uRSWvmyVUYTF1xjjyP6DQl5Lg
         NZdXhoxaCqxMlOAq54br5eIN82OiBw/8NgcrbpZMTRu1idCqT6aiKMU6eD+Mq9FNd3Gj
         YHzg==
X-Gm-Message-State: AOAM5303cj3J6xNvwM/Qw2jYj0DLD8B3CDvW4DU2hztraqJlFhwKwucu
        1Z4NxbKJnTF6I5tj5fI1vAHOk+yVwQa3/G2zLzNLemLnbynzwm5hiy0gOx50y5ZperTiaH3ZlRn
        RwM2ioAxXVhV5
X-Received: by 2002:a5d:53cb:: with SMTP id a11mr3853151wrw.357.1638331439462;
        Tue, 30 Nov 2021 20:03:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhumLryi9V9KrKlSpyLzRu5HDZkBC1FMg+YMqnBodV7FIVAFuPTlFzagdHDwr9aiFW0LIXrw==
X-Received: by 2002:a5d:53cb:: with SMTP id a11mr3853119wrw.357.1638331439201;
        Tue, 30 Nov 2021 20:03:59 -0800 (PST)
Received: from xz-m1.local ([64.64.123.10])
        by smtp.gmail.com with ESMTPSA id t16sm11411905wrn.49.2021.11.30.20.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:03:58 -0800 (PST)
Date:   Wed, 1 Dec 2021 12:03:49 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
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
Subject: Re: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during
 CLEAR_DIRTY_LOG
Message-ID: <Yab0JRVmwyr1GL3Y@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-14-dmatlack@google.com>
 <YaDQSKnZ3bN501Ml@xz-m1.local>
 <CALzav=fVd4mLMyf6RBS=yDuN+hMM0hoa7+YHdYucRcJDjD4EfA@mail.gmail.com>
 <CALzav=ex+5y7-5a-8Vum2-eOKuKYe=RU9NvrS82H=sTwj2mqaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=ex+5y7-5a-8Vum2-eOKuKYe=RU9NvrS82H=sTwj2mqaw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 04:17:01PM -0800, David Matlack wrote:
> On Tue, Nov 30, 2021 at 4:16 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Fri, Nov 26, 2021 at 4:17 AM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > On Fri, Nov 19, 2021 at 11:57:57PM +0000, David Matlack wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 6768ef9c0891..4e78ef2dd352 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> > > >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> > > >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> > > >
> > > > +             /*
> > > > +              * Try to proactively split any large pages down to 4KB so that
> > > > +              * vCPUs don't have to take write-protection faults.
> > > > +              */
> > > > +             kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
> > > > +
> > > >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> > > >
> > > >               /* Cross two large pages? */
> > >
> > > Is it intended to try split every time even if we could have split it already?
> > > As I remember Paolo mentioned that we can skip split if it's not the 1st
> > > CLEAR_LOG on the same range, and IIUC that makes sense.
> > >
> > > But indeed I don't see a trivial way to know whether this is the first clear of
> > > this range.  Maybe we can maintain "how many huge pages are there under current
> > > kvm_mmu_page node" somehow?  Then if root sp has the counter==0, then we can
> > > skip it.  Just a wild idea..
> > >
> > > Or maybe it's intended to try split unconditionally for some reason?  If so
> > > it'll be great to mention that either in the commit message or in comments.
> >
> > Thanks for calling this out. Could the same be said about the existing
> > code that unconditionally tries to write-protect 2M+ pages?

They're different because wr-protect can be restored (to be not-wr-protected)
when vcpu threads write to the pages, so they need to be always done.

For huge page split - when it happened during dirty tracking it'll not be
recovered anymore, so it's a one-time thing.

> > I aimed to keep parity with the write-protection calls (always try to split
> > before write-protecting) but I agree there might be opportunities available
> > to skip altogether.

So IMHO it's not about parity but it could be about how easy can it be
implemented, and whether it'll be worth it to add that complexity.

Besides the above accounting idea per-sp, we can have other ways to do this
too, e.g., keeping a bitmap showing which range has been split: that bitmap
will be 2M in granule for x86 because that'll be enough.  We init-all-ones for
the bitmap when start logging for a memslot.

But again maybe it turns out we don't really want that complexity.

IMHO a good start could be the perf numbers (which I asked in the cover letter)
comparing the overhead of 2nd+ iterations of CLEAR_LOG with/without eager page
split.

> >
> > By the way, looking at this code again I think I see some potential bugs:
> >  - I don't think I ever free split_caches in the initially-all-set case.

I saw that it's freed in kvm_mmu_try_split_large_pages(), no?

> >  - What happens if splitting fails the CLEAR_LOG but succeeds the
> > CLEAR_LOG?
> 
> Gah, meant to say "first CLEAR_LOG" and "second CLEAR_LOG" here.
> 
> > We would end up propagating the write-protection on the 2M
> > page down to the 4K page. This might cause issues if using PML.

Hmm looks correct.. I'm wondering what will happen with that.

Firstly this should be rare as the 1st split should in 99% cases succeed.

Then if split failed at the 1st attempt, we wr-protected sptes even during pml
during the split.  When written, we'll go the fast page fault and record the
writes too, I think, as we'll apply dirty bit to the new spte so I think it'll
just skip pml.  Looks like we'll be using a mixture of pml+wp but all dirty
will still be captured as exptected?..

There could be leftover wp when stopping dirty logging, but that seems not
directly harmful too.  It'll make things a bit messed up, at least.

-- 
Peter Xu

