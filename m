Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050E228A1B7
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgJJWOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 18:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728751AbgJJVlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 17:41:49 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D2CC0613D6
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 14:41:42 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id n61so12293724ota.10
        for <kvm@vger.kernel.org>; Sat, 10 Oct 2020 14:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iNxwDH5u5TrRQqiTxTiC507fsoXAo+Ear9Qr1cSCDXM=;
        b=cODuj2bzo2AO+NtsSDmK+GM+IH6Wb2aQIdPJNZwsWPVwppiG83SSt1UXXIp6hTsgX4
         TEoJk6lOuTqWZaWdYBoSJlxxzz9Lz3t/mbTiz7Ayr4xGvQyHkg9c04lcUmYMfoSQJIZQ
         sxhzwWcw4CIeNF13coxREsRH2lgZbzvzGnLIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iNxwDH5u5TrRQqiTxTiC507fsoXAo+Ear9Qr1cSCDXM=;
        b=NtDn1HBP62ytdEV59h/u1QajTqj7D4dCNVyz9HFPRVLXtxS/XEaxpUJWfI7vDtMJyD
         f3LfSHnIH86tAxPrXE/8iHQj876lNFJcupu2uO1dgpK9kkKiFNl/3RcsNxS34f+/by7l
         hK/ozeLzGMoTYQhyC7+AOvr9ZeLqKbC47l1HLd4UiI5o5/WJ7X5gOFERrQ3TQsfbbB51
         /A0jV0v2zawv7JNVLATezkS0aaiqwsyQTUbluDqMxxgqNKwmo133FpPxw9r+njF7zgLx
         4KDoq9EjDFJrmn71ZOuOQH5e09y6ejQ4ziXwAj2G6NQiMt8/bi04IhCFVpV5DSxcFNUV
         iUzg==
X-Gm-Message-State: AOAM5304U7ZTVVoGXBqGKZ63EancNuBugnEorpwlVKY80Wi6ODaBqihv
        tj4EP4RMIevCS0NjFXTEk26OZBqwk+glkJF8ALcnEw==
X-Google-Smtp-Source: ABdhPJysptysEsT0jSmsHNKPWkJOs+Pv1LX5DB7//lfpdyBsRnuaRszTMCaD3Je1nsfqA1Sk2kecuUszSEGAlMPDXc0=
X-Received: by 2002:a05:6830:1c3c:: with SMTP id f28mr14253407ote.188.1602366101323;
 Sat, 10 Oct 2020 14:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-4-daniel.vetter@ffwll.ch> <CAFCwf1194Ce98y8tWxKzXT1rsdHDkzEcnERiaU=3-=t7hygmXg@mail.gmail.com>
 <CAKMK7uG_kBpmuQDRgKdyh8SycFDhE7kuB2MEOsx+D5wRmerWKA@mail.gmail.com>
In-Reply-To: <CAKMK7uG_kBpmuQDRgKdyh8SycFDhE7kuB2MEOsx+D5wRmerWKA@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat, 10 Oct 2020 23:41:30 +0200
Message-ID: <CAKMK7uFUtkd7j1WZZoSmeO3mKG2zZ9SpwEO08EFJKromU0LV4Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/17] misc/habana: Stop using frame_vector helpers
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Omer Shpigelman <oshpigelman@habana.ai>,
        Ofir Bitton <obitton@habana.ai>,
        Tomer Tayar <ttayar@habana.ai>,
        Moti Haimovski <mhaimovski@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Piskorski <ppiskorski@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10, 2020 at 11:32 PM Daniel Vetter <daniel.vetter@ffwll.ch> wro=
te:
>
> On Sat, Oct 10, 2020 at 10:27 PM Oded Gabbay <oded.gabbay@gmail.com> wrot=
e:
> >
> > On Fri, Oct 9, 2020 at 10:59 AM Daniel Vetter <daniel.vetter@ffwll.ch> =
wrote:
> > >
> > > All we need are a pages array, pin_user_pages_fast can give us that
> > > directly. Plus this avoids the entire raw pfn side of get_vaddr_frame=
s.
> > >
> > Thanks for the patch Daniel.
> >
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: John Hubbard <jhubbard@nvidia.com>
> > > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-samsung-soc@vger.kernel.org
> > > Cc: linux-media@vger.kernel.org
> > > Cc: Oded Gabbay <oded.gabbay@gmail.com>
> > > Cc: Omer Shpigelman <oshpigelman@habana.ai>
> > > Cc: Ofir Bitton <obitton@habana.ai>
> > > Cc: Tomer Tayar <ttayar@habana.ai>
> > > Cc: Moti Haimovski <mhaimovski@habana.ai>
> > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Pawel Piskorski <ppiskorski@habana.ai>
> > > --
> > > v2: Use unpin_user_pages_dirty_lock (John)
> > > ---
> > >  drivers/misc/habanalabs/Kconfig             |  1 -
> > >  drivers/misc/habanalabs/common/habanalabs.h |  3 +-
> > >  drivers/misc/habanalabs/common/memory.c     | 49 ++++++++-----------=
--
> > >  3 files changed, 20 insertions(+), 33 deletions(-)
> > >
> > > diff --git a/drivers/misc/habanalabs/Kconfig b/drivers/misc/habanalab=
s/Kconfig
> > > index 8eb5d38c618e..2f04187f7167 100644
> > > --- a/drivers/misc/habanalabs/Kconfig
> > > +++ b/drivers/misc/habanalabs/Kconfig
> > > @@ -6,7 +6,6 @@
> > >  config HABANA_AI
> > >         tristate "HabanaAI accelerators (habanalabs)"
> > >         depends on PCI && HAS_IOMEM
> > > -       select FRAME_VECTOR
> > >         select DMA_SHARED_BUFFER
> > >         select GENERIC_ALLOCATOR
> > >         select HWMON
> > > diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/mi=
sc/habanalabs/common/habanalabs.h
> > > index edbd627b29d2..c1b3ad613b15 100644
> > > --- a/drivers/misc/habanalabs/common/habanalabs.h
> > > +++ b/drivers/misc/habanalabs/common/habanalabs.h
> > > @@ -881,7 +881,8 @@ struct hl_ctx_mgr {
> > >  struct hl_userptr {
> > >         enum vm_type_t          vm_type; /* must be first */
> > >         struct list_head        job_node;
> > > -       struct frame_vector     *vec;
> > > +       struct page             **pages;
> > > +       unsigned int            npages;
> > Can you please update the kerneldoc comment section of this structure
> > according to your changes ?
>
> Apologies I missed the nice kerneldoc. I'll fix that in the next round.
>
>
> > >         struct sg_table         *sgt;
> > >         enum dma_data_direction dir;
> > >         struct list_head        debugfs_list;
> > > diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/h=
abanalabs/common/memory.c
> > > index 5ff4688683fd..327b64479f97 100644
> > > --- a/drivers/misc/habanalabs/common/memory.c
> > > +++ b/drivers/misc/habanalabs/common/memory.c
> > > @@ -1281,45 +1281,41 @@ static int get_user_memory(struct hl_device *=
hdev, u64 addr, u64 size,
> > >                 return -EFAULT;
> > >         }
> > >
> > > -       userptr->vec =3D frame_vector_create(npages);
> > > -       if (!userptr->vec) {
> > > +       userptr->pages =3D kvmalloc_array(npages, sizeof(*userptr->pa=
ges),
> > > +                                       GFP_KERNEL);
> > > +       if (!userptr->pages) {
> > >                 dev_err(hdev->dev, "Failed to create frame vector\n")=
;
> > >                 return -ENOMEM;
> > >         }
> > >
> > > -       rc =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRIT=
E,
> > > -                               userptr->vec);
> > > +       rc =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_W=
RITE,
> > > +                                userptr->pages);
> > >
> > >         if (rc !=3D npages) {
> > >                 dev_err(hdev->dev,
> > >                         "Failed to map host memory, user ptr probably=
 wrong\n");
> > >                 if (rc < 0)
> > > -                       goto destroy_framevec;
> > > +                       goto destroy_pages;
> > > +               npages =3D rc;
> > >                 rc =3D -EFAULT;
> > > -               goto put_framevec;
> > > -       }
> > > -
> > > -       if (frame_vector_to_pages(userptr->vec) < 0) {
> > > -               dev_err(hdev->dev,
> > > -                       "Failed to translate frame vector to pages\n"=
);
> > > -               rc =3D -EFAULT;
> > > -               goto put_framevec;
> > > +               goto put_pages;
> > >         }
> > > +       userptr->npages =3D npages;
> > >
> > >         rc =3D sg_alloc_table_from_pages(userptr->sgt,
> > > -                                       frame_vector_pages(userptr->v=
ec),
> > > -                                       npages, offset, size, GFP_ATO=
MIC);
> > > +                                      userptr->pages,
> > > +                                      npages, offset, size, GFP_ATOM=
IC);
> > I think that because the call to kvmalloc_array() is done with
> > GFP_KERNEL, there is no point in using GFP_ATOMIC here.
> > And actually, this path only needs to avoid yielding when using a
> > special debug mode.
> > So I suggest putting here GFP_KERNEL.
>
> Huh, I didn't even notice the GFP_ATOMIC here. This looks indeed
> strange and GFP_KERNEL should be perfectly fine in a function that
> also calls pin_user_pages (since that one can allocate and do worse
> stuff like userspace pagefaults).
>
> But since that GFP_ATOMIC is there already I'll do that in a separate pat=
ch.

Ok I read up on your usage of GFP_ATOMIC in habanalabs, and I'm not
going to touch this. But I'm pretty sure it's broken.

You seem to have some requirement of not allocating memory with
blocking (see hl_cb_alloc()), and that seems to be way you allocate
tons of structures with GFP_ATOMIC. There's 2 pretty tough problems
with that:
- GFP_ATOMIC can fail, even when the system hasn't run out of memory
yet. You _must_ have a fallback back to handle allocation failures for
these. Quick survey shows you a ton of GFP_ATOMIC callsites, and very
little fallback code - I've found none, but I didn't check the failure
handlers all going up the possible callchains.
- pin_user_pages can allocate memory, so you're breaking your own "no
sleeping in these paths" rules.

This isn't going to get fixed with a quick oneliner patch, depending
what's needed you're looking at a driver rearchitecture here :-/ Hence
I'm not going to touch this in the next patch, but leave it all as-is.

Cheers, Daniel

>
> > In the meanwhile, I'll run this patch (coupled with the next patch) in
> > our C/I to make sure there are no regressions.
>
> Excellent. I'll wait with v3 until that's done, just in case you hit a
> snag I need to fix.
>
> Cheers, Daniel
>
> > Thanks,
> > Oded
> >
> > >         if (rc < 0) {
> > >                 dev_err(hdev->dev, "failed to create SG table from pa=
ges\n");
> > > -               goto put_framevec;
> > > +               goto put_pages;
> > >         }
> > >
> > >         return 0;
> > >
> > > -put_framevec:
> > > -       put_vaddr_frames(userptr->vec);
> > > -destroy_framevec:
> > > -       frame_vector_destroy(userptr->vec);
> > > +put_pages:
> > > +       unpin_user_pages(userptr->pages, npages);
> > > +destroy_pages:
> > > +       kvfree(userptr->pages);
> > >         return rc;
> > >  }
> > >
> > > @@ -1405,8 +1401,6 @@ int hl_pin_host_memory(struct hl_device *hdev, =
u64 addr, u64 size,
> > >   */
> > >  void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr =
*userptr)
> > >  {
> > > -       struct page **pages;
> > > -
> > >         hl_debugfs_remove_userptr(hdev, userptr);
> > >
> > >         if (userptr->dma_mapped)
> > > @@ -1414,15 +1408,8 @@ void hl_unpin_host_memory(struct hl_device *hd=
ev, struct hl_userptr *userptr)
> > >                                                         userptr->sgt-=
>nents,
> > >                                                         userptr->dir)=
;
> > >
> > > -       pages =3D frame_vector_pages(userptr->vec);
> > > -       if (!IS_ERR(pages)) {
> > > -               int i;
> > > -
> > > -               for (i =3D 0; i < frame_vector_count(userptr->vec); i=
++)
> > > -                       set_page_dirty_lock(pages[i]);
> > > -       }
> > > -       put_vaddr_frames(userptr->vec);
> > > -       frame_vector_destroy(userptr->vec);
> > > +       unpin_user_pages_dirty_lock(userptr->pages, userptr->npages, =
true);
> > > +       kvfree(userptr->pages);
> > >
> > >         list_del(&userptr->job_node);
> > >
> > > --
> > > 2.28.0
> > >
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
