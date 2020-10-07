Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA12286672
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgJGSBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgJGSBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 14:01:54 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B12AC061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 11:01:54 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id y127so843321ooa.5
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 11:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KjKZykFuT09vi8gvWSxWfIoih5+HtjIRxuS5MgzFTGo=;
        b=XlsYCfTVgW+6nmGAiv0O62GLPsC5r7eB+oidAEHNavDRGpWicEbtNZg9to7A5saHMp
         zaYRD/gT5inYX9JmqOP5ZzySgAIOp0+59TPao6y2kIbw9G7KU0mdvCuhCQrafShecj0J
         tHZf4mGHu3aegW49dmX0ZJptYBRUrRuO4MkvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KjKZykFuT09vi8gvWSxWfIoih5+HtjIRxuS5MgzFTGo=;
        b=q5jzApsJxlcLoSDrLC+h9Qgxms9NG+A4rJo2LuTmc0BDGh9oS/uxrM2LmZxb4xVjAL
         PPBVYmEKtw8qnCY6JJWIN2vDLTBQgB/tullR/DP9osv/0cLnhD15cRn8/5aDBlmQXFiW
         tHRTmKa0gBBIWSe8wAojhGodtIU/Rr0hlXXqeyV+rYz5/KcM+YtuxZoVdnOF87YQjn1X
         kTxBbPD8UG/AEVC2gXLPMHKVfc/7Ri3ui8Ux1r0DfZtUZ3Ha5HHf4qGx4dx3KlH6J4ec
         CDl9vOriogDwuKvBJVr8EezenYvHa8ygCVtlGMSkaW0rGvtB7gvTQ0O2rU3Np/VwiO9q
         xmiQ==
X-Gm-Message-State: AOAM530WtrpTg+cql3gtho8mv+ThbmS/Gw+6HqR5gQvnGlxpqYo2vR1I
        vyYb+NLdwtQ4JLqAZcC1fpZuYVBn3xMDcY3+49M9fkJwPnYk6A==
X-Google-Smtp-Source: ABdhPJwJzYY7PIFYfmYEAKc+uMwrEIxle3PFN75o5nMMKSdxenHBbi1fgd2mUNbWFOGRvdaIUhxGwTNij1DRYovGNtE=
X-Received: by 2002:a4a:c011:: with SMTP id v17mr2806667oop.89.1602093713265;
 Wed, 07 Oct 2020 11:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-8-daniel.vetter@ffwll.ch> <20201007172746.GU5177@ziepe.ca>
In-Reply-To: <20201007172746.GU5177@ziepe.ca>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 7 Oct 2020 20:01:42 +0200
Message-ID: <CAKMK7uH3P-6zs5MVceFD7872owqtcktqsTaQAOKNyaBg4_w=aA@mail.gmail.com>
Subject: Re: [PATCH 07/13] mm: close race in generic_access_phys
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Rik van Riel <riel@redhat.com>,
        Benjamin Herrensmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@linux.ie>,
        Hugh Dickins <hugh@veritas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 7, 2020 at 7:27 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Oct 07, 2020 at 06:44:20PM +0200, Daniel Vetter wrote:
> > Way back it was a reasonable assumptions that iomem mappings never
> > change the pfn range they point at. But this has changed:
> >
> > - gpu drivers dynamically manage their memory nowadays, invalidating
> >   ptes with unmap_mapping_range when buffers get moved
> >
> > - contiguous dma allocations have moved from dedicated carvetouts to
> >   cma regions. This means if we miss the unmap the pfn might contain
> >   pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> >
> > - even /dev/mem now invalidates mappings when the kernel requests that
> >   iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> >   ("/dev/mem: Revoke mappings when a driver claims the region")
> >
> > Accessing pfns obtained from ptes without holding all the locks is
> > therefore no longer a good idea. Fix this.
> >
> > Since ioremap might need to manipulate pagetables too we need to drop
> > the pt lock and have a retry loop if we raced.
> >
> > While at it, also add kerneldoc and improve the comment for the
> > vma_ops->access function. It's for accessing, not for moving the
> > memory from iomem to system memory, as the old comment seemed to
> > suggest.
> >
> > References: 28b2ee20c7cb ("access_process_vm device memory infrastructu=
re")
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Benjamin Herrensmidt <benh@kernel.crashing.org>
> > Cc: Dave Airlie <airlied@linux.ie>
> > Cc: Hugh Dickins <hugh@veritas.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  include/linux/mm.h |  3 ++-
> >  mm/memory.c        | 44 ++++++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 44 insertions(+), 3 deletions(-)
>
> This does seem to solve the race with revoke_devmem(), but it is really u=
gly.
>
> It would be much nicer to wrap a rwsem around this access and the unmap.
>
> Any place using it has a nice linear translation from vm_off to pfn,
> so I don't think there is a such a good reason to use follow_pte in
> the first place.
>
> ie why not the helper be this:
>
>  int generic_access_phys(unsigned long pfn, unsigned long pgprot,
>       void *buf, size_t len, bool write)
>
> Then something like dev/mem would compute pfn and obtain the lock:
>
> dev_access(struct vm_area_struct *vma, unsigned long addr, void *buf, int=
 len, int write)
> {
>      cpu_addr =3D vma->vm_pgoff*PAGE_SIZE + (addr - vma->vm_start));
>
>      /* FIXME: Has to be over each page of len */
>      if (!devmem_is_allowed_access(PHYS_PFN(cpu_addr/4096)))
>            return -EPERM;
>
>      down_read(&mem_sem);
>      generic_access_phys(cpu_addr/4096, pgprot_val(vma->vm_page_prot),
>                          buf, len, write);
>      up_read(&mem_sem);
> }
>
> The other cases looked simpler because they don't revoke, here the
> mmap_sem alone should be enough protection, they would just need to
> provide the linear translation to pfn.
>
> What do you think?

I think it'd fix the bug, until someone wires ->access up for
drivers/gpu, or the next subsystem. This is also just for ptrace, so
we really don't care when we stall the vm badly and other silly
things. So I figured the somewhat ugly, but full generic solution is
the better one, so that people who want to be able to ptrace
read/write their iomem mmaps can just sprinkle this wherever they feel
like.

But yeah if we go with most minimal fix, i.e. only trying to fix the
current users, then your thing should work and is simpler. But it
leaves the door open for future problems.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
