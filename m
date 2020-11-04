Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF382A6DC6
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 20:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgKDTXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 14:23:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726849AbgKDTX3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 14:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604517807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f4HgXERN1GLLWEsHB/LV0NauWLri2PzKQHC4zn0SuuE=;
        b=IPUPHveJ70NAoITKaq0BFPV0xEnzkxojK9Mo/Op2jxizA0K1TgTQczNLHZLyGWm8JrW4ZV
        tkOHiJc1Hac0fgcPKsjG7kT6pS2T3MMU/gIN6BvJtsild0ruYGYK/eqxOMhxtUo2+YT5uw
        CBCAVG06qXP+uQCmuqqZTH8a4dq2HgY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-JiG4tA8XOS2Sp-tE1rJnkA-1; Wed, 04 Nov 2020 14:23:25 -0500
X-MC-Unique: JiG4tA8XOS2Sp-tE1rJnkA-1
Received: by mail-qv1-f72.google.com with SMTP id eh4so13399475qvb.12
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 11:23:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f4HgXERN1GLLWEsHB/LV0NauWLri2PzKQHC4zn0SuuE=;
        b=joO6IJltt27uoYYbKSuLt5SMs2gWjkyX8jBvxs2vFCAOTeaxdj5J+e9i2dzZjhf3oo
         H/nop4gEspVBM+iYheGcDqtCKfFTMKSzOYaPa+5uTIT4oMHdH55Fkd9LCRil0rDIOWPJ
         cyEt9ky8yciC7bUInHaFPdCccrzwQ3x2AMFiOhgobNiHj8k96mCU/if7MKXZqhKHuWYF
         cq/zw6KOKCo6HjNCHO3bz9iZughCeiHYRaQNZYg133vextB6G0uONwVJyMFQyvMoyvtC
         BKpZ9LHisz2j+DIK1W84DzqjJMdtnyBxWrcsLSuoQgM3JKtld4Ec50wFTJDpcqsFikJz
         cVEg==
X-Gm-Message-State: AOAM530WQ02/yPxZe2Yn8RoV5C5fADpEP0q73Wm6szVzwqWLJpTrnrps
        gxyLG10ckMDC/qWMlD3UeT3e/3iK8S1ps5TQ2o1AbBfTQa4ztAlH0guHKnjngrp5sMcK2cdjAKl
        A1SAzMPcgkMP1
X-Received: by 2002:a37:4a4d:: with SMTP id x74mr27070701qka.55.1604517804947;
        Wed, 04 Nov 2020 11:23:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHb78N5GzI+vqBEO20LYazmsB4qBwMKOBG38rc8NCxxKgk67Hrj5AhXONTfcBksEDRQGvKVg==
X-Received: by 2002:a37:4a4d:: with SMTP id x74mr27070680qka.55.1604517804630;
        Wed, 04 Nov 2020 11:23:24 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id y3sm859322qto.2.2020.11.04.11.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 11:23:23 -0800 (PST)
Date:   Wed, 4 Nov 2020 14:23:22 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Laszlo Ersek <lersek@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] memory: pause all vCPUs for the duration of memory
 transactions
Message-ID: <20201104192322.GA96645@xz-x1>
References: <20201026084916.3103221-1-vkuznets@redhat.com>
 <20201102195729.GA20600@xz-x1>
 <87v9emy4g2.fsf@vitty.brq.redhat.com>
 <20201103163718.GH20600@xz-x1>
 <f7cd01b0-086c-307e-f995-d4c3c4729bd6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f7cd01b0-086c-307e-f995-d4c3c4729bd6@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 07:09:02PM +0100, Laszlo Ersek wrote:
> On 11/03/20 17:37, Peter Xu wrote:
> > On Tue, Nov 03, 2020 at 02:07:09PM +0100, Vitaly Kuznetsov wrote:
> >> In case it is a normal access from the guest, yes, but AFAIR here
> >> guest's CR3 is pointing to non existent memory and when KVM detects that
> >> it injects #PF by itself without a loop through userspace.
> > 
> > I see, thanks Vitaly.  I think this kind of answered my previous confusion on
> > why we can't just bounce all these to QEMU since I thought QEMU should try to
> > take the bql if it's mmio access - probably because there're quite a lot of
> > references to guest memslots in kernel that cannot be naturally treated as
> > guest MMIO access (especially for nested, maybe?) so that maybe it's very hard
> > to cover all of them.  Paolo has mentioned quite a few times that he'd prefer a
> > kernel solution for this; I feel like I understand better on the reason now..
> > 
> > Have any of us tried to collect the requirements on this new kernel interface
> > (if to be proposed)?  I'm kind of thinking how it would look like to solve all
> > the pains we have right now.
> > 
> > Firstly, I think we'd likely want to have the capability to handle "holes" in
> > memslots, either to punch a hole, which iiuc is the problem behind this patch.
> > Or the reversed operation, which is to fill up a whole that we've just punched.
> > The other major one could be virtio-mem who would like to extend or shrink an
> > existing memslot.  However IIUC that's also doable with the "hole" idea in that
> > we can create the memslot with the maximum supported size, then "punch a hole"
> > at the end of the memslot just like it shrinked.  When extend, we shrink the
> > hole instead rather than the memslot.
> > 
> > Then there's the other case where we want to keep the dirty bitmap when
> > punching a hole on existing ram.  If with the "hole" idea in the kernel, it
> > seems easy too - when we punch the hole, we drop dirty bitmaps only for the
> > range covered by the hole.  Then we won't lose the rest bitmaps that where the
> > RAM still makes sense, since the memslot will use the same bitmap before/after
> > punching a hole.
> > 
> > So now an simple idea comes to my mind (I think we can have even more better,
> > or more complicated ideas, e.g., to make kvm memslot a tree? But I'll start
> > with the simple): maybe we just need to teach each kvm memslot to take "holes"
> > within itself.  By default, there's no holes with KVM_SET_USER_MEMORY_REGION
> > configured kvm memslots, then we can configure holes for each memslot using a
> > new flag (assuming, KVM_MEM_SET_HOLE) of the same ioctl (after LOG_DIRTY_PAGES
> > and READ_ONLY).  Initially we may add a restriction on how many holes we need,
> > so the holes can also be an array.
> > 
> > Thoughts?
> 
> My only one (and completely unwashed / uneducated) thought is that this
> resembles the fact (?) that VMAs are represented as rbtrees. So maybe
> don't turn a single KVM memslot into a tree, but represent the full set
> of KVM memslots as an rbtree?
> 
> My understanding is that "interval tree" is one of the most efficient
> data structures for tracking a set of (discontiguous) memory regions,
> and that an rbtree can be generalized into an interval tree. I'm super
> rusty on the theory (after having contributed a genuine rbtree impl to
> edk2 in 2014, sic transit gloria mundi :/), but I think that's what the
> VMA stuff in the kernel does, effectively.
> 
> Perhaps it could apply to KVM memslots too.
> 
> Sorry if I'm making no sense, of course. (I'm going out on a limb with
> posting this email, but whatever...)

Appreciate your input, Laszlo.

I agree that in most cases tree is more efficient.  Though, I feel like
there're two issues, while the structure itself is the less important one.

Firstly, about the "tree or array" question: I'm not sure whether it's urgently
needed for kvm.  Here imho slot lookup should be the major critical operation
for kvm memslots, while crrent array impl of kvm memslot has already achieved
something similar of a tree (O(logn)) by keeping the array ordered (can refer
to search_memslots()).  That's why I think it's still ok.

The other issue is about the "atomic update" of memslots that we're trying to
look for a solution that can address all the issues we've seen.  IMHO it's a
different problem to solve.  For example, even if we start to use tree
structure, we'll still face the same issue when we want to punch a hole in an
existing memslot - we'll still need to remove the tree node before adding the
new one.  AFAICT, same failure could happen on CR3.

So IMHO the more important question is how to make these operations atomic.

To make things clearer, I'll also try to expand a bit more on the "hole" idea
proposed above.

Firstly, I believe there's also other solutions for these problems.

Assuming we would like to remove slot X (range 0-4G), and add back slots X1
(range 0-1G) and X2 (range 2G-4G), with range 1G-2G as new MMIO region.

One example is, we can introduce another new ioctl to contain a few operations
of KVM_SET_USER_MEMORY_REGION, then we can put three items in:

  - Remove memslot X
  - Add memslot X1
  - Add memslot X2

So that the container update will be atomic.  I think it works too at least for
the issue that this patch wants to address.  However I think it's not ideal.
The thing is, the memslot ID could change before/after the new ioctl even if
it's backing mostly the same thing.  Meanwhile, we'll need to destroy a memslot
that is destined to be added back with just some range information changed.
E.g., if we have dirty bitmap, we need to drop it and reallocate again.  That's
a waste, imho.

So I'm thinking, how about we teach kvm similar things as what QEMU has already
know with those memory regions?  That means kvm would start to know "ok this
memslot is always that one, it never changed, however we want to mask some of
it and bounce to QEMU for whatever reason".  The simplest way to implement this
is to introduce a "hole" idea to kvm.  And as I mentioned, I believe an array
would work too similar to memslots, but that's another story.

One thing intersting about the "hole" idea is that, we don't need containers to
keep a bunch of KVM_SET_USER_MEMORY_REGION ioctls any more!  Because our
operation is naturally atomic when represented as "holes": when we add a new
MMIO region within a RAM range, we simply add a new hole element to the
existing holes of this kvm memslot (note! adding the hole does _not_ change
slot ID and everything of the slot itself; e.g. dirty bitmaps do not need to be
re-allocate when we operate on the holes).  As a summary, in the new world: A
memslot should present something more close to ramblock in QEMU.  It means
"this range will be used by the guest", but it does not mean that guest can
access all of it.  When the access reaches a hole, we bounce to QEMU as if the
memslot is missing.

(Since this is really more kvm-specific, cc kvm list too)

Thanks,

-- 
Peter Xu

