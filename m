Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8872A32C5
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgKBSTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgKBST1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:19:27 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096D2C0617A6
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 10:19:27 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id dg9so15274923edb.12
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 10:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WiRUc29zxqGsO+d9X8MH7HOz5SXqo6HQakNFN6TG8oI=;
        b=hn3DSEKB/RMDVIl8+uf/cXIPRq4hEnoahMtBDSqMYwZ0yyCmlA1wr7KtKFj+kR7qmG
         LPKy+PtIfaItp4eIhNoIYgsEJUlT7mzBAcbZtb+5c4m0QBqJRtz8oSrtjxPOo7XWsTSc
         2iuELeBrCeMyN6mj2Jj2ucEo0YcivEK6yk290=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WiRUc29zxqGsO+d9X8MH7HOz5SXqo6HQakNFN6TG8oI=;
        b=N3s3sDKgXpU5eTzpFT4aJ8iBh2DpDBenONVmWRJ4DahsMH9Sig3jH0HeDZZzdvDp2I
         z/ZFsXbQkDDs7jA40MsRaCFGQr0hYXz0BrBXWEX81Z8m32ju6SfJ9mN9QsJllxtULmUH
         IBQyFz7wj8rGibtTi5lQ7kHvSeEg5tS0HKEwh0Qks2Wjq2c2SRvAv0D8+hBEX//MqRbu
         vh7OEt4ax1afwRonRBp0zAvuAytcRpTYsoAJQvpM4AcQ6Kb7OW1FJXGGLBTdOlLga22g
         b4zYQ1Z6Vcl/5DOr0+5e6Tzyp4XcxJqJYUz+4I2oLUftBkd1C+//GSbQrcQ9r8uJL95c
         MNkg==
X-Gm-Message-State: AOAM530EejzoVJRfaL/YAwr8PJF/HEGspRlTajcpG+Vfq7R/il8Me2TO
        HJjr5tJxYNXnJwXkMSFTHnYNgwK29fOMiA==
X-Google-Smtp-Source: ABdhPJxrtY1hgm2uwnsZhJhk2Fxp1krn8GK3ctZKjtqq/v+QRQt4ZNBgLQvcWQuD1sEJDOnUDaK5Wg==
X-Received: by 2002:a05:6402:4d:: with SMTP id f13mr17943128edu.306.1604341165143;
        Mon, 02 Nov 2020 10:19:25 -0800 (PST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id b24sm9957672edt.68.2020.11.02.10.19.23
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 10:19:23 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id y12so15729016wrp.6
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 10:19:23 -0800 (PST)
X-Received: by 2002:adf:f511:: with SMTP id q17mr21106249wro.192.1604341162894;
 Mon, 02 Nov 2020 10:19:22 -0800 (PST)
MIME-Version: 1.0
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch> <20201030100815.2269-6-daniel.vetter@ffwll.ch>
 <CAAFQd5ANOAzVf+tC1iYKXeY0ALahtYrG7xtKHXHmvv1xh7si3g@mail.gmail.com> <CAKMK7uFFNNXtWh5CyDVGnXo+GYdhc-CgZN1pZSmYAhnyrDhXaQ@mail.gmail.com>
In-Reply-To: <CAKMK7uFFNNXtWh5CyDVGnXo+GYdhc-CgZN1pZSmYAhnyrDhXaQ@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 2 Nov 2020 19:19:10 +0100
X-Gmail-Original-Message-ID: <CAAFQd5B7yuk3G1u8m6i-TmUeoW-D_xPiUj56SvN8dgG7xtTZrw@mail.gmail.com>
Message-ID: <CAAFQd5B7yuk3G1u8m6i-TmUeoW-D_xPiUj56SvN8dgG7xtTZrw@mail.gmail.com>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
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

On Fri, Oct 30, 2020 at 3:38 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> On Fri, Oct 30, 2020 at 3:11 PM Tomasz Figa <tfiga@chromium.org> wrote:
> >
> > On Fri, Oct 30, 2020 at 11:08 AM Daniel Vetter <daniel.vetter@ffwll.ch>=
 wrote:
> > >
> > > This is used by media/videbuf2 for persistent dma mappings, not just
> > > for a single dma operation and then freed again, so needs
> > > FOLL_LONGTERM.
> > >
> > > Unfortunately current pup_locked doesn't support FOLL_LONGTERM due to
> > > locking issues. Rework the code to pull the pup path out from the
> > > mmap_sem critical section as suggested by Jason.
> > >
> > > By relying entirely on the vma checks in pin_user_pages and follow_pf=
n
> > > (for vm_flags and vma_is_fsdax) we can also streamline the code a lot=
.
> > >
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Pawel Osciak <pawel@osciak.com>
> > > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Tomasz Figa <tfiga@chromium.org>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-samsung-soc@vger.kernel.org
> > > Cc: linux-media@vger.kernel.org
> > > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > --
> > > v2: Streamline the code and further simplify the loop checks (Jason)
> > >
> > > v5: Review from Tomasz:
> > > - fix page counting for the follow_pfn case by resetting ret
> > > - drop gup_flags paramater, now unused
> > > ---
> > >  .../media/common/videobuf2/videobuf2-memops.c |  3 +-
> > >  include/linux/mm.h                            |  2 +-
> > >  mm/frame_vector.c                             | 53 ++++++-----------=
--
> > >  3 files changed, 19 insertions(+), 39 deletions(-)
> > >
> >
> > Thanks, looks good to me now.
> >
> > Acked-by: Tomasz Figa <tfiga@chromium.org>
> >
> > From reading the code, this is quite unlikely to introduce any
> > behavior changes, but just to be safe, did you have a chance to test
> > this with some V4L2 driver?
>
> Nah, unfortunately not.

I believe we don't have any setup that could exercise the IO/PFNMAP
user pointers, but it should be possible to exercise the basic userptr
path by enabling the virtual (fake) video driver, vivid or
CONFIG_VIDEO_VIVID, in your kernel and then using yavta [1] with
--userptr and --capture=3D<number of frames> (and possibly some more
options) to grab a couple of frames from the test pattern generator.

Does it sound like something that you could give a try? Feel free to
ping me on IRC (tfiga on #v4l or #dri-devel) if you need any help.

[1] https://git.ideasonboard.org/yavta.git

Best regards,
Tomasz

> -Daniel
>
> >
> > Best regards,
> > Tomasz
> >
> > > diff --git a/drivers/media/common/videobuf2/videobuf2-memops.c b/driv=
ers/media/common/videobuf2/videobuf2-memops.c
> > > index 6e9e05153f4e..9dd6c27162f4 100644
> > > --- a/drivers/media/common/videobuf2/videobuf2-memops.c
> > > +++ b/drivers/media/common/videobuf2/videobuf2-memops.c
> > > @@ -40,7 +40,6 @@ struct frame_vector *vb2_create_framevec(unsigned l=
ong start,
> > >         unsigned long first, last;
> > >         unsigned long nr;
> > >         struct frame_vector *vec;
> > > -       unsigned int flags =3D FOLL_FORCE | FOLL_WRITE;
> > >
> > >         first =3D start >> PAGE_SHIFT;
> > >         last =3D (start + length - 1) >> PAGE_SHIFT;
> > > @@ -48,7 +47,7 @@ struct frame_vector *vb2_create_framevec(unsigned l=
ong start,
> > >         vec =3D frame_vector_create(nr);
> > >         if (!vec)
> > >                 return ERR_PTR(-ENOMEM);
> > > -       ret =3D get_vaddr_frames(start & PAGE_MASK, nr, flags, vec);
> > > +       ret =3D get_vaddr_frames(start & PAGE_MASK, nr, vec);
> > >         if (ret < 0)
> > >                 goto out_destroy;
> > >         /* We accept only complete set of PFNs */
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index ef360fe70aaf..d6b8e30dce2e 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -1765,7 +1765,7 @@ struct frame_vector {
> > >  struct frame_vector *frame_vector_create(unsigned int nr_frames);
> > >  void frame_vector_destroy(struct frame_vector *vec);
> > >  int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
> > > -                    unsigned int gup_flags, struct frame_vector *vec=
);
> > > +                    struct frame_vector *vec);
> > >  void put_vaddr_frames(struct frame_vector *vec);
> > >  int frame_vector_to_pages(struct frame_vector *vec);
> > >  void frame_vector_to_pfns(struct frame_vector *vec);
> > > diff --git a/mm/frame_vector.c b/mm/frame_vector.c
> > > index 10f82d5643b6..f8c34b895c76 100644
> > > --- a/mm/frame_vector.c
> > > +++ b/mm/frame_vector.c
> > > @@ -32,13 +32,12 @@
> > >   * This function takes care of grabbing mmap_lock as necessary.
> > >   */
> > >  int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
> > > -                    unsigned int gup_flags, struct frame_vector *vec=
)
> > > +                    struct frame_vector *vec)
> > >  {
> > >         struct mm_struct *mm =3D current->mm;
> > >         struct vm_area_struct *vma;
> > >         int ret =3D 0;
> > >         int err;
> > > -       int locked;
> > >
> > >         if (nr_frames =3D=3D 0)
> > >                 return 0;
> > > @@ -48,40 +47,26 @@ int get_vaddr_frames(unsigned long start, unsigne=
d int nr_frames,
> > >
> > >         start =3D untagged_addr(start);
> > >
> > > -       mmap_read_lock(mm);
> > > -       locked =3D 1;
> > > -       vma =3D find_vma_intersection(mm, start, start + 1);
> > > -       if (!vma) {
> > > -               ret =3D -EFAULT;
> > > -               goto out;
> > > -       }
> > > -
> > > -       /*
> > > -        * While get_vaddr_frames() could be used for transient (kern=
el
> > > -        * controlled lifetime) pinning of memory pages all current
> > > -        * users establish long term (userspace controlled lifetime)
> > > -        * page pinning. Treat get_vaddr_frames() like
> > > -        * get_user_pages_longterm() and disallow it for filesystem-d=
ax
> > > -        * mappings.
> > > -        */
> > > -       if (vma_is_fsdax(vma)) {
> > > -               ret =3D -EOPNOTSUPP;
> > > -               goto out;
> > > -       }
> > > -
> > > -       if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> > > +       ret =3D pin_user_pages_fast(start, nr_frames,
> > > +                                 FOLL_FORCE | FOLL_WRITE | FOLL_LONG=
TERM,
> > > +                                 (struct page **)(vec->ptrs));
> > > +       if (ret > 0) {
> > >                 vec->got_ref =3D true;
> > >                 vec->is_pfns =3D false;
> > > -               ret =3D pin_user_pages_locked(start, nr_frames,
> > > -                       gup_flags, (struct page **)(vec->ptrs), &lock=
ed);
> > > -               goto out;
> > > +               goto out_unlocked;
> > >         }
> > >
> > > +       mmap_read_lock(mm);
> > >         vec->got_ref =3D false;
> > >         vec->is_pfns =3D true;
> > > +       ret =3D 0;
> > >         do {
> > >                 unsigned long *nums =3D frame_vector_pfns(vec);
> > >
> > > +               vma =3D find_vma_intersection(mm, start, start + 1);
> > > +               if (!vma)
> > > +                       break;
> > > +
> > >                 while (ret < nr_frames && start + PAGE_SIZE <=3D vma-=
>vm_end) {
> > >                         err =3D follow_pfn(vma, start, &nums[ret]);
> > >                         if (err) {
> > > @@ -92,17 +77,13 @@ int get_vaddr_frames(unsigned long start, unsigne=
d int nr_frames,
> > >                         start +=3D PAGE_SIZE;
> > >                         ret++;
> > >                 }
> > > -               /*
> > > -                * We stop if we have enough pages or if VMA doesn't =
completely
> > > -                * cover the tail page.
> > > -                */
> > > -               if (ret >=3D nr_frames || start < vma->vm_end)
> > > +               /* Bail out if VMA doesn't completely cover the tail =
page. */
> > > +               if (start < vma->vm_end)
> > >                         break;
> > > -               vma =3D find_vma_intersection(mm, start, start + 1);
> > > -       } while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
> > > +       } while (ret < nr_frames);
> > >  out:
> > > -       if (locked)
> > > -               mmap_read_unlock(mm);
> > > +       mmap_read_unlock(mm);
> > > +out_unlocked:
> > >         if (!ret)
> > >                 ret =3D -EFAULT;
> > >         if (ret > 0)
> > > --
> > > 2.28.0
> > >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
