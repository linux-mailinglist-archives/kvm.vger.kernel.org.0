Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91DB286F4C
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 09:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgJHHX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 03:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgJHHX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 03:23:27 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C9C061755
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 00:23:26 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id y127so1252309ooa.5
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 00:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ui8WkZ8ZsqWNVKFISnxizxdl1xBQtE0ojtcqIbBf85o=;
        b=OLHQfD6clKQWUqpmaAK9RMlR/tsEUgzWlL24nlPViG1Rk9p8LHmyCmM7/5WLHXKEvu
         lI/irRP+aq5gBsvKA49uJgztAy930tPikm27PGApe4JTRXsGR0g3qvfoDhdKCEoe0v+J
         hUX2iSsNsi3+8JirFm0OBhWG4fOImFFw/17nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ui8WkZ8ZsqWNVKFISnxizxdl1xBQtE0ojtcqIbBf85o=;
        b=sH7AWhUSs2rzv+oiGM5rCDeDWpHpuGSGQ2oxBnI+KQbIu1p4M7uVG+eKDqtatlMjR/
         P3Hworhp9/QieIjnz/CCX3xqJffaSm8X3QaVy4s87xbBCgyRppFqvNAP1ELLVF2DWMHN
         ojPSX2t0IwwGN9GrkpRJ3rlhMPJ7vXYeNQ957f2FTeaJi2g4A+WPoFUR3wpB6WExZwEY
         QOprVeMh+QMudb+WcUyZQaSKU4/f6x1QaADurqgVyYwqrk1VzI38rKu93wh5hc3rIS8k
         BY4ZAPaehZuSCoQ32ZKiheaXzPrT3gGLkcoSDkk5MHnHlwKagSG5V96iLa/DgELm44ke
         jY+Q==
X-Gm-Message-State: AOAM533wKjvsjopV3bE3F/t7gphc5evbX+gFe0bW5JXjtMHaxue1DeB2
        10IRF+6TbsMr6JiKEC4RYsuHfTfenS7YyTZBxGljtw==
X-Google-Smtp-Source: ABdhPJy3F0IZWGCXcT7DTnuCU2t5bEV1GI8WhdMxAAqDMxgLl6e5j0szfklCmFBV9PnPK7/VfntIN7R+bRVO1DC8GEg=
X-Received: by 2002:a4a:c011:: with SMTP id v17mr4481557oop.89.1602141806038;
 Thu, 08 Oct 2020 00:23:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-8-daniel.vetter@ffwll.ch> <852a74ec-339b-4c7f-9e29-b9736111849a@nvidia.com>
In-Reply-To: <852a74ec-339b-4c7f-9e29-b9736111849a@nvidia.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 8 Oct 2020 09:23:14 +0200
Message-ID: <CAKMK7uEa1+f+34qeLo9F3-SvYpOKtGmQ+8sDtbEBmFeXkCx9mw@mail.gmail.com>
Subject: Re: [PATCH 07/13] mm: close race in generic_access_phys
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Rik van Riel <riel@redhat.com>,
        Benjamin Herrensmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@linux.ie>,
        Hugh Dickins <hugh@veritas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 8, 2020 at 2:44 AM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 10/7/20 9:44 AM, Daniel Vetter wrote:
> > Way back it was a reasonable assumptions that iomem mappings never
> > change the pfn range they point at. But this has changed:
> >
> > - gpu drivers dynamically manage their memory nowadays, invalidating
> >    ptes with unmap_mapping_range when buffers get moved
> >
> > - contiguous dma allocations have moved from dedicated carvetouts to
>
> s/carvetouts/carveouts/
>
> >    cma regions. This means if we miss the unmap the pfn might contain
> >    pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> >
> > - even /dev/mem now invalidates mappings when the kernel requests that
> >    iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> >    ("/dev/mem: Revoke mappings when a driver claims the region")
>
> Thanks for putting these references into the log, it's very helpful.
> ...
> > diff --git a/mm/memory.c b/mm/memory.c
> > index fcfc4ca36eba..8d467e23b44e 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4873,28 +4873,68 @@ int follow_phys(struct vm_area_struct *vma,
> >       return ret;
> >   }
> >
> > +/**
> > + * generic_access_phys - generic implementation for iomem mmap access
> > + * @vma: the vma to access
> > + * @addr: userspace addres, not relative offset within @vma
> > + * @buf: buffer to read/write
> > + * @len: length of transfer
> > + * @write: set to FOLL_WRITE when writing, otherwise reading
> > + *
> > + * This is a generic implementation for &vm_operations_struct.access for an
> > + * iomem mapping. This callback is used by access_process_vm() when the @vma is
> > + * not page based.
> > + */
> >   int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
> >                       void *buf, int len, int write)
> >   {
> >       resource_size_t phys_addr;
> >       unsigned long prot = 0;
> >       void __iomem *maddr;
> > +     pte_t *ptep, pte;
> > +     spinlock_t *ptl;
> >       int offset = addr & (PAGE_SIZE-1);
> > +     int ret = -EINVAL;
> > +
> > +     if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > +             return -EINVAL;
> > +
> > +retry:
> > +     if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
> > +             return -EINVAL;
> > +     pte = *ptep;
> > +     pte_unmap_unlock(ptep, ptl);
> >
> > -     if (follow_phys(vma, addr, write, &prot, &phys_addr))
> > +     prot = pgprot_val(pte_pgprot(pte));
> > +     phys_addr = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
> > +
> > +     if ((write & FOLL_WRITE) && !pte_write(pte))
> >               return -EINVAL;
> >
> >       maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
> >       if (!maddr)
> >               return -ENOMEM;
> >
> > +     if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
> > +             goto out_unmap;
> > +
> > +     if (pte_same(pte, *ptep)) {
>
>
> The ioremap area is something I'm sorta new to, so a newbie question:
> is it possible for the same pte to already be there, ever? If so, we
> be stuck in an infinite loop here.  I'm sure that's not the case, but
> it's not yet obvious to me why it's impossible. Resource reservations
> maybe?

It's just buggy, it should be !pte_same. And I need to figure out how
to test this I guess.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
