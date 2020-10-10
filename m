Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3224228A1A4
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbgJJVzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387560AbgJJU1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Oct 2020 16:27:49 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95344C0613D0;
        Sat, 10 Oct 2020 13:27:18 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id c13so14162509oiy.6;
        Sat, 10 Oct 2020 13:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oGo8IGgCZpTOoR3ZKZaP8e3qvIeXNb3yMrzl+Uani14=;
        b=QdqGF5qe16vB4wlkB20OoDG5GsZXhkiu+V7PIg7gevT+li9s2YZrjhJjrGKFlhR8f2
         S2dMeFOHFe2Vy3+ViSPQkUcTH6WgZSgyFemNPe3jkRa1BRJLmCIpjdAjfS+Z+fMYuuFc
         J/zHg1WUv6YS6qXHyCbAbu2sfcz6kuW6fXvudSVSb/G2m0zjetF8vQarbaEqA1w5uj5C
         1ytU+yCJQIoUFZyqLvf50g0rJYU5X+PHHN8XIpBwZ7Wgshsn/e8A5zDxqiYS9ZaCOgq0
         +eTVZzOuHYBHFBmUTwz8gE0YQaPT+/D15xczuawlfzpKen+UVAP0g0nAO1GFs3+KLRMi
         43mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oGo8IGgCZpTOoR3ZKZaP8e3qvIeXNb3yMrzl+Uani14=;
        b=jfRtHi8KOqCmT0Yp6rQ0+SoB/5Y6165/0CrxTAvRWxcE1GtYIF1ZGrRYi2MJIQTUof
         dk6NusOkPAoYlotRnhPcxrp87AypG1VBydbU2IxKinqFvnXZkzGOBZF/A4DUsCOV/zC5
         zgy0xaV3I82Y5Q3QdfBBP3RGupdsVCcCln7rpOXxCF3k+l8VrCtQXVgcHplUNpBD5aT5
         X6fJavIqBzCvkKq0LaHn3d56xO1Cf9bZ6tfi3tEa5IiFkwPooBWNATSo/IG5IkPow099
         PJkdoKyNtz9IOuFFeOEpcKyVTUtEuqDyLCUZ3bx+AL9S3SS5+qEyHNwLZz9OH2Bsriu6
         LSlA==
X-Gm-Message-State: AOAM530xTZ+4bvGW/ZlKTsz9c8crwmNzuwa3fwfO/R4kCyHD3/KipaMd
        KHcNOCJj3N+nZaV/N3KafAAwQyJHd+PqYfhjJdo=
X-Google-Smtp-Source: ABdhPJwowo80GWbqkm6ZkqR7gSgknWZHhpMAZMgkL8s88FI9XTRLJCjdHnJ8k2W5KFXN71VQforAtfzOFMwHNRWQMIg=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr6204755oie.130.1602361637761;
 Sat, 10 Oct 2020 13:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch> <20201009075934.3509076-4-daniel.vetter@ffwll.ch>
In-Reply-To: <20201009075934.3509076-4-daniel.vetter@ffwll.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sat, 10 Oct 2020 23:26:52 +0300
Message-ID: <CAFCwf1194Ce98y8tWxKzXT1rsdHDkzEcnERiaU=3-=t7hygmXg@mail.gmail.com>
Subject: Re: [PATCH v2 03/17] misc/habana: Stop using frame_vector helpers
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-s390@vger.kernel.org,
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

On Fri, Oct 9, 2020 at 10:59 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> All we need are a pages array, pin_user_pages_fast can give us that
> directly. Plus this avoids the entire raw pfn side of get_vaddr_frames.
>
Thanks for the patch Daniel.

> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Oded Gabbay <oded.gabbay@gmail.com>
> Cc: Omer Shpigelman <oshpigelman@habana.ai>
> Cc: Ofir Bitton <obitton@habana.ai>
> Cc: Tomer Tayar <ttayar@habana.ai>
> Cc: Moti Haimovski <mhaimovski@habana.ai>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Pawel Piskorski <ppiskorski@habana.ai>
> --
> v2: Use unpin_user_pages_dirty_lock (John)
> ---
>  drivers/misc/habanalabs/Kconfig             |  1 -
>  drivers/misc/habanalabs/common/habanalabs.h |  3 +-
>  drivers/misc/habanalabs/common/memory.c     | 49 ++++++++-------------
>  3 files changed, 20 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/misc/habanalabs/Kconfig b/drivers/misc/habanalabs/Kc=
onfig
> index 8eb5d38c618e..2f04187f7167 100644
> --- a/drivers/misc/habanalabs/Kconfig
> +++ b/drivers/misc/habanalabs/Kconfig
> @@ -6,7 +6,6 @@
>  config HABANA_AI
>         tristate "HabanaAI accelerators (habanalabs)"
>         depends on PCI && HAS_IOMEM
> -       select FRAME_VECTOR
>         select DMA_SHARED_BUFFER
>         select GENERIC_ALLOCATOR
>         select HWMON
> diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/h=
abanalabs/common/habanalabs.h
> index edbd627b29d2..c1b3ad613b15 100644
> --- a/drivers/misc/habanalabs/common/habanalabs.h
> +++ b/drivers/misc/habanalabs/common/habanalabs.h
> @@ -881,7 +881,8 @@ struct hl_ctx_mgr {
>  struct hl_userptr {
>         enum vm_type_t          vm_type; /* must be first */
>         struct list_head        job_node;
> -       struct frame_vector     *vec;
> +       struct page             **pages;
> +       unsigned int            npages;
Can you please update the kerneldoc comment section of this structure
according to your changes ?

>         struct sg_table         *sgt;
>         enum dma_data_direction dir;
>         struct list_head        debugfs_list;
> diff --git a/drivers/misc/habanalabs/common/memory.c b/drivers/misc/haban=
alabs/common/memory.c
> index 5ff4688683fd..327b64479f97 100644
> --- a/drivers/misc/habanalabs/common/memory.c
> +++ b/drivers/misc/habanalabs/common/memory.c
> @@ -1281,45 +1281,41 @@ static int get_user_memory(struct hl_device *hdev=
, u64 addr, u64 size,
>                 return -EFAULT;
>         }
>
> -       userptr->vec =3D frame_vector_create(npages);
> -       if (!userptr->vec) {
> +       userptr->pages =3D kvmalloc_array(npages, sizeof(*userptr->pages)=
,
> +                                       GFP_KERNEL);
> +       if (!userptr->pages) {
>                 dev_err(hdev->dev, "Failed to create frame vector\n");
>                 return -ENOMEM;
>         }
>
> -       rc =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
> -                               userptr->vec);
> +       rc =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRITE=
,
> +                                userptr->pages);
>
>         if (rc !=3D npages) {
>                 dev_err(hdev->dev,
>                         "Failed to map host memory, user ptr probably wro=
ng\n");
>                 if (rc < 0)
> -                       goto destroy_framevec;
> +                       goto destroy_pages;
> +               npages =3D rc;
>                 rc =3D -EFAULT;
> -               goto put_framevec;
> -       }
> -
> -       if (frame_vector_to_pages(userptr->vec) < 0) {
> -               dev_err(hdev->dev,
> -                       "Failed to translate frame vector to pages\n");
> -               rc =3D -EFAULT;
> -               goto put_framevec;
> +               goto put_pages;
>         }
> +       userptr->npages =3D npages;
>
>         rc =3D sg_alloc_table_from_pages(userptr->sgt,
> -                                       frame_vector_pages(userptr->vec),
> -                                       npages, offset, size, GFP_ATOMIC)=
;
> +                                      userptr->pages,
> +                                      npages, offset, size, GFP_ATOMIC);
I think that because the call to kvmalloc_array() is done with
GFP_KERNEL, there is no point in using GFP_ATOMIC here.
And actually, this path only needs to avoid yielding when using a
special debug mode.
So I suggest putting here GFP_KERNEL.

In the meanwhile, I'll run this patch (coupled with the next patch) in
our C/I to make sure there are no regressions.
Thanks,
Oded

>         if (rc < 0) {
>                 dev_err(hdev->dev, "failed to create SG table from pages\=
n");
> -               goto put_framevec;
> +               goto put_pages;
>         }
>
>         return 0;
>
> -put_framevec:
> -       put_vaddr_frames(userptr->vec);
> -destroy_framevec:
> -       frame_vector_destroy(userptr->vec);
> +put_pages:
> +       unpin_user_pages(userptr->pages, npages);
> +destroy_pages:
> +       kvfree(userptr->pages);
>         return rc;
>  }
>
> @@ -1405,8 +1401,6 @@ int hl_pin_host_memory(struct hl_device *hdev, u64 =
addr, u64 size,
>   */
>  void hl_unpin_host_memory(struct hl_device *hdev, struct hl_userptr *use=
rptr)
>  {
> -       struct page **pages;
> -
>         hl_debugfs_remove_userptr(hdev, userptr);
>
>         if (userptr->dma_mapped)
> @@ -1414,15 +1408,8 @@ void hl_unpin_host_memory(struct hl_device *hdev, =
struct hl_userptr *userptr)
>                                                         userptr->sgt->nen=
ts,
>                                                         userptr->dir);
>
> -       pages =3D frame_vector_pages(userptr->vec);
> -       if (!IS_ERR(pages)) {
> -               int i;
> -
> -               for (i =3D 0; i < frame_vector_count(userptr->vec); i++)
> -                       set_page_dirty_lock(pages[i]);
> -       }
> -       put_vaddr_frames(userptr->vec);
> -       frame_vector_destroy(userptr->vec);
> +       unpin_user_pages_dirty_lock(userptr->pages, userptr->npages, true=
);
> +       kvfree(userptr->pages);
>
>         list_del(&userptr->job_node);
>
> --
> 2.28.0
>
