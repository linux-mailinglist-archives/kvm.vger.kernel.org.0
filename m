Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F8D2A0818
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 15:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgJ3OiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 10:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgJ3OiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 10:38:04 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C0BC0613D5
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 07:38:03 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id f7so6869149oib.4
        for <kvm@vger.kernel.org>; Fri, 30 Oct 2020 07:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SFdgvNNkKFB8SPaNCIOCQJISIgDBDMbDzScVAH9EDMM=;
        b=koZdGXG+Ed4ZrGS9gYktSh+x1QwMrt0hVdgtd4bIPF04LbzITd0kgGqgPUBl5FakP+
         0IPlU3GsFBiis2BGBWZ8Etau8IP6JGUudreHosPpOTayfP42rljDrS9OOvm9gkIsYPvS
         XRK9qJaWRojvBDDnG6hf9KUPyRba0rCKMXbVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SFdgvNNkKFB8SPaNCIOCQJISIgDBDMbDzScVAH9EDMM=;
        b=Q9UMgB+PIER+pOQa/dvhAK6rgD48NM459beB3bhmFZphGp6bN+uL8g2spbk9VjLYfd
         BR0eVUWm/sTcQmB0kqj7vYSovRaygvsnDRChVBQ+gAnmdVNYmsp5Up0P+m5YFm6qQUVU
         00w+RnddFH5hFqGgNv8o9oHbRfpM0sCKnXoDLysKtb0dmac2E/SVH64mlT0SEMkHSvfQ
         3DTVfkI8/53C4+Czucg9CfQLEOIBX41KohwmA5YhJT7GKuTy4wChPGI6O7zgHG+GQLo+
         Vq5+I1HlfRytws1J34sjMrX6xiGNgvIZpvpMhxS0BPhBb5va8FbqJXRTcn3tAqs05Li3
         zgcQ==
X-Gm-Message-State: AOAM531pSHqwOTsJNaEm9/m/20DTt7X40COE7AeabqzPkcHLLaRpm693
        Etm8s8n7kN6GYY0R00dBn6aJaASfVkm8yaoPoq5a/Q==
X-Google-Smtp-Source: ABdhPJzRmIwZAJG+16lc3hpTwK/eoorAnaJg+RPUJ77L79AwZKhT5ZuLVu9x7ItY0hWudsBOQUnGYhpPZBYn26IA3Eg=
X-Received: by 2002:aca:b141:: with SMTP id a62mr1673007oif.101.1604068683122;
 Fri, 30 Oct 2020 07:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch> <20201030100815.2269-6-daniel.vetter@ffwll.ch>
 <CAAFQd5ANOAzVf+tC1iYKXeY0ALahtYrG7xtKHXHmvv1xh7si3g@mail.gmail.com>
In-Reply-To: <CAAFQd5ANOAzVf+tC1iYKXeY0ALahtYrG7xtKHXHmvv1xh7si3g@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 30 Oct 2020 15:37:52 +0100
Message-ID: <CAKMK7uFFNNXtWh5CyDVGnXo+GYdhc-CgZN1pZSmYAhnyrDhXaQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        kvm <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux MM <linux-mm@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 3:11 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Fri, Oct 30, 2020 at 11:08 AM Daniel Vetter <daniel.vetter@ffwll.ch> w=
rote:
> >
> > This is used by media/videbuf2 for persistent dma mappings, not just
> > for a single dma operation and then freed again, so needs
> > FOLL_LONGTERM.
> >
> > Unfortunately current pup_locked doesn't support FOLL_LONGTERM due to
> > locking issues. Rework the code to pull the pup path out from the
> > mmap_sem critical section as suggested by Jason.
> >
> > By relying entirely on the vma checks in pin_user_pages and follow_pfn
> > (for vm_flags and vma_is_fsdax) we can also streamline the code a lot.
> >
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Pawel Osciak <pawel@osciak.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Tomasz Figa <tfiga@chromium.org>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > --
> > v2: Streamline the code and further simplify the loop checks (Jason)
> >
> > v5: Review from Tomasz:
> > - fix page counting for the follow_pfn case by resetting ret
> > - drop gup_flags paramater, now unused
> > ---
> >  .../media/common/videobuf2/videobuf2-memops.c |  3 +-
> >  include/linux/mm.h                            |  2 +-
> >  mm/frame_vector.c                             | 53 ++++++-------------
> >  3 files changed, 19 insertions(+), 39 deletions(-)
> >
>
> Thanks, looks good to me now.
>
> Acked-by: Tomasz Figa <tfiga@chromium.org>
>
> From reading the code, this is quite unlikely to introduce any
> behavior changes, but just to be safe, did you have a chance to test
> this with some V4L2 driver?

Nah, unfortunately not.
-Daniel

>
> Best regards,
> Tomasz
>
> > diff --git a/drivers/media/common/videobuf2/videobuf2-memops.c b/driver=
s/media/common/videobuf2/videobuf2-memops.c
> > index 6e9e05153f4e..9dd6c27162f4 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-memops.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-memops.c
> > @@ -40,7 +40,6 @@ struct frame_vector *vb2_create_framevec(unsigned lon=
g start,
> >         unsigned long first, last;
> >         unsigned long nr;
> >         struct frame_vector *vec;
> > -       unsigned int flags =3D FOLL_FORCE | FOLL_WRITE;
> >
> >         first =3D start >> PAGE_SHIFT;
> >         last =3D (start + length - 1) >> PAGE_SHIFT;
> > @@ -48,7 +47,7 @@ struct frame_vector *vb2_create_framevec(unsigned lon=
g start,
> >         vec =3D frame_vector_create(nr);
> >         if (!vec)
> >                 return ERR_PTR(-ENOMEM);
> > -       ret =3D get_vaddr_frames(start & PAGE_MASK, nr, flags, vec);
> > +       ret =3D get_vaddr_frames(start & PAGE_MASK, nr, vec);
> >         if (ret < 0)
> >                 goto out_destroy;
> >         /* We accept only complete set of PFNs */
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ef360fe70aaf..d6b8e30dce2e 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1765,7 +1765,7 @@ struct frame_vector {
> >  struct frame_vector *frame_vector_create(unsigned int nr_frames);
> >  void frame_vector_destroy(struct frame_vector *vec);
> >  int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
> > -                    unsigned int gup_flags, struct frame_vector *vec);
> > +                    struct frame_vector *vec);
> >  void put_vaddr_frames(struct frame_vector *vec);
> >  int frame_vector_to_pages(struct frame_vector *vec);
> >  void frame_vector_to_pfns(struct frame_vector *vec);
> > diff --git a/mm/frame_vector.c b/mm/frame_vector.c
> > index 10f82d5643b6..f8c34b895c76 100644
> > --- a/mm/frame_vector.c
> > +++ b/mm/frame_vector.c
> > @@ -32,13 +32,12 @@
> >   * This function takes care of grabbing mmap_lock as necessary.
> >   */
> >  int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
> > -                    unsigned int gup_flags, struct frame_vector *vec)
> > +                    struct frame_vector *vec)
> >  {
> >         struct mm_struct *mm =3D current->mm;
> >         struct vm_area_struct *vma;
> >         int ret =3D 0;
> >         int err;
> > -       int locked;
> >
> >         if (nr_frames =3D=3D 0)
> >                 return 0;
> > @@ -48,40 +47,26 @@ int get_vaddr_frames(unsigned long start, unsigned =
int nr_frames,
> >
> >         start =3D untagged_addr(start);
> >
> > -       mmap_read_lock(mm);
> > -       locked =3D 1;
> > -       vma =3D find_vma_intersection(mm, start, start + 1);
> > -       if (!vma) {
> > -               ret =3D -EFAULT;
> > -               goto out;
> > -       }
> > -
> > -       /*
> > -        * While get_vaddr_frames() could be used for transient (kernel
> > -        * controlled lifetime) pinning of memory pages all current
> > -        * users establish long term (userspace controlled lifetime)
> > -        * page pinning. Treat get_vaddr_frames() like
> > -        * get_user_pages_longterm() and disallow it for filesystem-dax
> > -        * mappings.
> > -        */
> > -       if (vma_is_fsdax(vma)) {
> > -               ret =3D -EOPNOTSUPP;
> > -               goto out;
> > -       }
> > -
> > -       if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> > +       ret =3D pin_user_pages_fast(start, nr_frames,
> > +                                 FOLL_FORCE | FOLL_WRITE | FOLL_LONGTE=
RM,
> > +                                 (struct page **)(vec->ptrs));
> > +       if (ret > 0) {
> >                 vec->got_ref =3D true;
> >                 vec->is_pfns =3D false;
> > -               ret =3D pin_user_pages_locked(start, nr_frames,
> > -                       gup_flags, (struct page **)(vec->ptrs), &locked=
);
> > -               goto out;
> > +               goto out_unlocked;
> >         }
> >
> > +       mmap_read_lock(mm);
> >         vec->got_ref =3D false;
> >         vec->is_pfns =3D true;
> > +       ret =3D 0;
> >         do {
> >                 unsigned long *nums =3D frame_vector_pfns(vec);
> >
> > +               vma =3D find_vma_intersection(mm, start, start + 1);
> > +               if (!vma)
> > +                       break;
> > +
> >                 while (ret < nr_frames && start + PAGE_SIZE <=3D vma->v=
m_end) {
> >                         err =3D follow_pfn(vma, start, &nums[ret]);
> >                         if (err) {
> > @@ -92,17 +77,13 @@ int get_vaddr_frames(unsigned long start, unsigned =
int nr_frames,
> >                         start +=3D PAGE_SIZE;
> >                         ret++;
> >                 }
> > -               /*
> > -                * We stop if we have enough pages or if VMA doesn't co=
mpletely
> > -                * cover the tail page.
> > -                */
> > -               if (ret >=3D nr_frames || start < vma->vm_end)
> > +               /* Bail out if VMA doesn't completely cover the tail pa=
ge. */
> > +               if (start < vma->vm_end)
> >                         break;
> > -               vma =3D find_vma_intersection(mm, start, start + 1);
> > -       } while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
> > +       } while (ret < nr_frames);
> >  out:
> > -       if (locked)
> > -               mmap_read_unlock(mm);
> > +       mmap_read_unlock(mm);
> > +out_unlocked:
> >         if (!ret)
> >                 ret =3D -EFAULT;
> >         if (ret > 0)
> > --
> > 2.28.0
> >
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
