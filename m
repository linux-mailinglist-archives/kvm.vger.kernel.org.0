Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27E228686C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgJGTi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgJGTi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 15:38:56 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CD4C0613D4
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 12:38:55 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id t15so3377487otk.0
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 12:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LsElbMcFzN96yl2Sl/ziA41uXCCImdpCgv4KLFFd2jg=;
        b=JEKQ8k7fkmwZeYrlUlz3G8hZps3ExQiyKA2OwomgnwTekQBi+F0d7wOTziCheDkGKC
         Sop2Gdre551T94df2v7y1eMTnQHiWe0yUTDZjm+ZgzFXM8oxuELLqSnmw/X2wHY81Oiq
         NO4qJN6wk378wM9u+QS2uUvJPNszvveexmpPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LsElbMcFzN96yl2Sl/ziA41uXCCImdpCgv4KLFFd2jg=;
        b=A6lNlLtZsd/wRqbDXvd3/2/iaSjEhJPyIOIGAkPns3eNIvjANQGeO8o8zH/L/sHVuD
         4k+TgTe1qeGSV7xnl5F0z/S9F2Mk08cYZEaLhBMRXNd8+V5Agbf/AEkQJxEZyUARUpi/
         NfJyFzBBUseZG9zaWC8/cFZNh4M+DaEeRK7eTO3VEoekSqJr7JpJ6sdxF1F7oLcLbSdd
         HqFEtQkDeh/c0jvgjJm8HsQS9mEp2oyGSwRIYHPswqajBLgb6GQbjmHzzoRkCXRrf8nA
         w8HcC2fpLtEEfSCUJD+cDa6vPFjF+Yk6s0avQsYQ4AGZfVqTCK5hkJTJfT31JZujpnh8
         jD9Q==
X-Gm-Message-State: AOAM532Za3G7YMjgwxkX8DwruKyM42vuv8b63CmBaHgqUWHx2fMOhaHI
        ukksyzmJ6/xu5ByDuI1oY3jdAtFptDm3hsR8tFxKlg==
X-Google-Smtp-Source: ABdhPJzDeUcXRqAYmdWYWg9wJA+fWIrvGfY9TAWXYdC/GYct5kjchJ6t7F5Fbz0UZkTJcUSkSz7+OQDzNSm6p86bNJU=
X-Received: by 2002:a05:6830:1c3c:: with SMTP id f28mr3008000ote.188.1602099533763;
 Wed, 07 Oct 2020 12:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-12-daniel.vetter@ffwll.ch> <20201007173647.GW5177@ziepe.ca>
 <CAKMK7uE9sbK_tGhJbsnHgD9rOnx-dr=2xmpMw7RvvvpPLnjVVA@mail.gmail.com> <20201007190023.GA5177@ziepe.ca>
In-Reply-To: <20201007190023.GA5177@ziepe.ca>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 7 Oct 2020 21:38:42 +0200
Message-ID: <CAKMK7uHNV7di+J10_JyLY6ctdsAGNnGhF7qrFzRCWFnXsQSEwQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] mm: add unsafe_follow_pfn
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 7, 2020 at 9:00 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Oct 07, 2020 at 08:10:34PM +0200, Daniel Vetter wrote:
> > On Wed, Oct 7, 2020 at 7:36 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Wed, Oct 07, 2020 at 06:44:24PM +0200, Daniel Vetter wrote:
> > > > Way back it was a reasonable assumptions that iomem mappings never
> > > > change the pfn range they point at. But this has changed:
> > > >
> > > > - gpu drivers dynamically manage their memory nowadays, invalidatin=
g
> > > > ptes with unmap_mapping_range when buffers get moved
> > > >
> > > > - contiguous dma allocations have moved from dedicated carvetouts t=
o
> > > > cma regions. This means if we miss the unmap the pfn might contain
> > > > pagecache or anon memory (well anything allocated with GFP_MOVEABLE=
)
> > > >
> > > > - even /dev/mem now invalidates mappings when the kernel requests t=
hat
> > > > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> > > > ("/dev/mem: Revoke mappings when a driver claims the region")
> > > >
> > > > Accessing pfns obtained from ptes without holding all the locks is
> > > > therefore no longer a good idea.
> > > >
> > > > Unfortunately there's some users where this is not fixable (like v4=
l
> > > > userptr of iomem mappings) or involves a pile of work (vfio type1
> > > > iommu). For now annotate these as unsafe and splat appropriately.
> > > >
> > > > This patch adds an unsafe_follow_pfn, which later patches will then
> > > > roll out to all appropriate places.
> > > >
> > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Cc: Kees Cook <keescook@chromium.org>
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > > Cc: Jan Kara <jack@suse.cz>
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Cc: linux-mm@kvack.org
> > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > Cc: linux-samsung-soc@vger.kernel.org
> > > > Cc: linux-media@vger.kernel.org
> > > > Cc: kvm@vger.kernel.org
> > > >  include/linux/mm.h |  2 ++
> > > >  mm/memory.c        | 32 +++++++++++++++++++++++++++++++-
> > > >  mm/nommu.c         | 17 +++++++++++++++++
> > > >  security/Kconfig   | 13 +++++++++++++
> > > >  4 files changed, 63 insertions(+), 1 deletion(-)
> > >
> > > Makes sense to me.
> > >
> > > I wonder if we could change the original follow_pfn to require the
> > > ptep and then lockdep_assert_held() it against the page table lock?
> >
> > The safe variant with the pagetable lock is follow_pte_pmd. The only
> > way to make follow_pfn safe is if you have an mmu notifier and
> > corresponding retry logic. That is not covered by lockdep (it would
> > splat if we annotate the retry side), so I'm not sure how you'd check
> > for that?
>
> Right OK.
>
> > Checking for ptep lock doesn't work here, since the one leftover safe
> > user of this (kvm) doesn't need that at all, because it has the mmu
> > notifier.
>
> Ah, so a better name and/or function kdoc for follow_pfn is probably a
> good iead in this patch as well.

I did change that already to mention that you need an mmu notifier,
and that follow_pte_pmd respectively unsafe_follow_pfn are the
alternatives. Do you want more or something else here?

Note that I left the kerneldoc for the nommu.c case unchanged, since
without an mmu all bets are off anyway.

> > So I think we're as good as it gets, since I really have no idea how
> > to make sure follow_pfn callers do have an mmu notifier registered.
>
> Yah, can't be done. Most mmu notifier users should be using
> hmm_range_fault anyhow, kvm is really very special here.

We could pass an mmu notifier to follow_pfn and check that it has a
registration for vma->vm_mm, but that feels like overkill when kvm is
the only legit user for this.

> > I've followed the few other CONFIG_STRICT_FOO I've seen, which are all
> > explicit enables and default to "do not break uapi, damn the
> > (security) bugs". Which is I think how this should be done. It is in
> > the security section though, so hopefully competent distros will
> > enable this all.
>
> I thought the strict ones were more general and less clear security
> worries, not bugs like this.
>
> This is "allow a user triggerable use after free bug to exist in the
> kernel"

Since at most you get at GFP_MOVEABLE stuff I'm not sure you can use
this to pull the kernel over the table. Maybe best way is if you get a
gpu pagetable somehow into your pfn and then use that to access
abitrary stuff, but there's still an iommu. I think leveraging this is
going to be very tricky, and pretty much has to be device or driver
specific somehow.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
