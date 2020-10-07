Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441262867ED
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgJGTA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbgJGTA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 15:00:26 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD2FC0613D5
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 12:00:25 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id q10so1793057qvs.1
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 12:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gwCbc+E55rt8fvg0Z5RrVkUNpQiUldF+rgqAtNMU+jY=;
        b=cMpNZVJG4K3eU3P6Jrd5CX0FOMJ/Il/vK4/7K8PoeJK7lgtOlsvjUxgy6GDWgBQ9D2
         Aw5daoxRX/jrMpwNlaXAoNbojcae9A3GOXghtCpRVV9HiqHG68GEdYZUDKJSzv88i+3p
         aFkcGAX3Swzr2MMkwPQxIHr1Vh0HtpCatuWCeA2XXODcHpk/xTpMM82sPz7LoWoj7YYW
         Luz6GqqQzWzkcXY5HEYy6sj4zsu7Bc3sA+CDzGGX0SAXYkf0OGAbHVxxlJGYn7JBpuJm
         7XOCU2H2Wb2aAXJ06fg5h12CT15LqHGmR1WX6xifpDWK1MH5EARIEabM4b4xkoRgWTA0
         GO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gwCbc+E55rt8fvg0Z5RrVkUNpQiUldF+rgqAtNMU+jY=;
        b=KJlvToZ6jT130vX0b5qS9Hz3CbW+QpeT56o0g5RLbFhlbZZoG9UZriOcIqWhLmP1Qz
         Wjb1/mE7m847kcsvtnpzJ8yIFMMEVOP0fJzH3iKmgLcVzrLb2Cza06B61PdUS2xXaHit
         4tJUWUDL6JNYgAIrhOvT3P2aeBtexE8w92SCPpdbDdK+Eb//5EZ0FOZO4hZiJEiHcpzL
         q8CAB6GLLKaL1kxAB18YTIlsX4sh+oQwM5+esHHtxLl2I3snoz6lSVB7dGvgwvfErzO5
         TZAD/xSlJIXkvHIyweJ68Elsmv6Ei7wpHlXbqh0Knepe5LWZVM3DO9hZwdOYHmZSIvpZ
         z27Q==
X-Gm-Message-State: AOAM531gXL6kYTtVqrb6OD4fCqwJ1HncpEeXrhteIoJh8yb/4LeDy6XZ
        x3R9nRknpxcIJq+K49tkQHjwQg==
X-Google-Smtp-Source: ABdhPJzTPvAeI7la8FWGJoa8jqCaN28XQwmJorKlewk43J8Zj2TVezuTxCVG7tggprHbo9uup+dLjQ==
X-Received: by 2002:a0c:9d03:: with SMTP id m3mr4454155qvf.54.1602097224984;
        Wed, 07 Oct 2020 12:00:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id v65sm2143675qkb.88.2020.10.07.12.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 12:00:24 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kQEfn-001EwU-Q3; Wed, 07 Oct 2020 16:00:23 -0300
Date:   Wed, 7 Oct 2020 16:00:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
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
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/13] mm: add unsafe_follow_pfn
Message-ID: <20201007190023.GA5177@ziepe.ca>
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-12-daniel.vetter@ffwll.ch>
 <20201007173647.GW5177@ziepe.ca>
 <CAKMK7uE9sbK_tGhJbsnHgD9rOnx-dr=2xmpMw7RvvvpPLnjVVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uE9sbK_tGhJbsnHgD9rOnx-dr=2xmpMw7RvvvpPLnjVVA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07, 2020 at 08:10:34PM +0200, Daniel Vetter wrote:
> On Wed, Oct 7, 2020 at 7:36 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Wed, Oct 07, 2020 at 06:44:24PM +0200, Daniel Vetter wrote:
> > > Way back it was a reasonable assumptions that iomem mappings never
> > > change the pfn range they point at. But this has changed:
> > >
> > > - gpu drivers dynamically manage their memory nowadays, invalidating
> > > ptes with unmap_mapping_range when buffers get moved
> > >
> > > - contiguous dma allocations have moved from dedicated carvetouts to
> > > cma regions. This means if we miss the unmap the pfn might contain
> > > pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> > >
> > > - even /dev/mem now invalidates mappings when the kernel requests that
> > > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> > > ("/dev/mem: Revoke mappings when a driver claims the region")
> > >
> > > Accessing pfns obtained from ptes without holding all the locks is
> > > therefore no longer a good idea.
> > >
> > > Unfortunately there's some users where this is not fixable (like v4l
> > > userptr of iomem mappings) or involves a pile of work (vfio type1
> > > iommu). For now annotate these as unsafe and splat appropriately.
> > >
> > > This patch adds an unsafe_follow_pfn, which later patches will then
> > > roll out to all appropriate places.
> > >
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > Cc: Jérôme Glisse <jglisse@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-samsung-soc@vger.kernel.org
> > > Cc: linux-media@vger.kernel.org
> > > Cc: kvm@vger.kernel.org
> > >  include/linux/mm.h |  2 ++
> > >  mm/memory.c        | 32 +++++++++++++++++++++++++++++++-
> > >  mm/nommu.c         | 17 +++++++++++++++++
> > >  security/Kconfig   | 13 +++++++++++++
> > >  4 files changed, 63 insertions(+), 1 deletion(-)
> >
> > Makes sense to me.
> >
> > I wonder if we could change the original follow_pfn to require the
> > ptep and then lockdep_assert_held() it against the page table lock?
> 
> The safe variant with the pagetable lock is follow_pte_pmd. The only
> way to make follow_pfn safe is if you have an mmu notifier and
> corresponding retry logic. That is not covered by lockdep (it would
> splat if we annotate the retry side), so I'm not sure how you'd check
> for that?

Right OK.

> Checking for ptep lock doesn't work here, since the one leftover safe
> user of this (kvm) doesn't need that at all, because it has the mmu
> notifier.

Ah, so a better name and/or function kdoc for follow_pfn is probably a
good iead in this patch as well.

> So I think we're as good as it gets, since I really have no idea how
> to make sure follow_pfn callers do have an mmu notifier registered.

Yah, can't be done. Most mmu notifier users should be using
hmm_range_fault anyhow, kvm is really very special here.
 
> I've followed the few other CONFIG_STRICT_FOO I've seen, which are all
> explicit enables and default to "do not break uapi, damn the
> (security) bugs". Which is I think how this should be done. It is in
> the security section though, so hopefully competent distros will
> enable this all.

I thought the strict ones were more general and less clear security
worries, not bugs like this.

This is "allow a user triggerable use after free bug to exist in the
kernel"

Jason
