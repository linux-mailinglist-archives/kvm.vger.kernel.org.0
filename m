Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478A7A6AF1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfICONq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 10:13:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36334 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfICONq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 10:13:46 -0400
Received: by mail-io1-f66.google.com with SMTP id b136so12102412iof.3;
        Tue, 03 Sep 2019 07:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y/VL+PK0aa7I0TUMW6S0h1e2db0cJYFyho+B7GBvI98=;
        b=GwzYwTSiPE7hY1aHgKJnz9pezIkSHDijyqXQyYTSugckr8scV4I8dkc1ZOxY4cS6/n
         MnBX1ZWOkEFM30Z8JnKT0FudX3lStl5DS9bS6cHeWjQVF6LRovZRLBJmaeZPrdgCuwrt
         rA+nbe7NeADRj5v9jNLrPg9OZ1Or3SBd3eTw7z5m2H/c8Y2WgczrrT65Fy+pTn6bmxSA
         6RILUSshYtPnGBxTiVBjMtEMS0Ikr7qSHJyWm6yO6+nIUdhuVktMh31qPYknUuFbfTaw
         mshIz4m/pNnss5HQL/7tLfTVKdv8qlNhtjXrd7adlxr4RBppFEYLb+v43mTMGOk3LXHG
         Vpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y/VL+PK0aa7I0TUMW6S0h1e2db0cJYFyho+B7GBvI98=;
        b=cFybV+VOYsGm5Qj6LBf2+bDtNnZYb5g6ZIBtCWbwCsS8BOtYCqfO7o/jDOT91njwvc
         d+5+gn90S9sRUsSn2s20K09a+w/Fv1TSprBYWL92DegrDJYe+c9PTHsdzlnkNZAxDnha
         xOpFKWDB1moAVpeZVfo4oaunZEPoLIb9hTofSyEMiRaEF2jnlp+cNEz0dpBjhXDeNQJD
         2YIZy6huoC7gZuMA7Dhtmrz3XO2N/hk3f2GFz7TFBpPnrP3IBx2ReUIOue8vIlkP7Jzz
         h7ySYQCWSzTTqBPHIwOsQcYhZ8ov8LbQIyPJyptnzBNo3+Yow9GA4lvqMDb2jJ68eEZ5
         knlw==
X-Gm-Message-State: APjAAAXtN4X6nJDfmMzdr+4pA6I3Y8J95Rh8DLRpN/5lM42dE9lOI8l+
        wOVE634t4rIvFZqOxCG7Obkr0nIw79MrVjUlV7M=
X-Google-Smtp-Source: APXvYqwn0spCMIfJkxs1b43ts9V9mY6LvVn3Y5MjwOEMgObF3Hu8yinoT5tXr1xnME1F645J0W7swYVHJ563jc5M0GM=
X-Received: by 2002:a6b:fc02:: with SMTP id r2mr19977135ioh.15.1567520024575;
 Tue, 03 Sep 2019 07:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
 <20190812213356.22097.20751.stgit@localhost.localdomain> <20190903032759-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190903032759-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 3 Sep 2019 07:13:32 -0700
Message-ID: <CAKgT0UfFU3oT5kKZk999XfrM6oducTizcUL5xpDWmMG=oP04ow@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] virtio-balloon: Add support for providing unused
 page reports to host
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 3, 2019 at 12:32 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Aug 12, 2019 at 02:33:56PM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Add support for the page reporting feature provided by virtio-balloon.
> > Reporting differs from the regular balloon functionality in that is is
> > much less durable than a standard memory balloon. Instead of creating a
> > list of pages that cannot be accessed the pages are only inaccessible
> > while they are being indicated to the virtio interface. Once the
> > interface has acknowledged them they are placed back into their respective
> > free lists and are once again accessible by the guest system.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  drivers/virtio/Kconfig              |    1 +
> >  drivers/virtio/virtio_balloon.c     |   65 +++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_balloon.h |    1 +
> >  3 files changed, 67 insertions(+)
> >
> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > index 078615cf2afc..4b2dd8259ff5 100644
> > --- a/drivers/virtio/Kconfig
> > +++ b/drivers/virtio/Kconfig
> > @@ -58,6 +58,7 @@ config VIRTIO_BALLOON
> >       tristate "Virtio balloon driver"
> >       depends on VIRTIO
> >       select MEMORY_BALLOON
> > +     select PAGE_REPORTING
> >       ---help---
> >        This driver supports increasing and decreasing the amount
> >        of memory within a KVM guest.
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 2c19457ab573..52f9eeda1877 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/magic.h>
> >  #include <linux/pseudo_fs.h>
> > +#include <linux/page_reporting.h>
> >
> >  /*
> >   * Balloon device works in 4K page units.  So each page is pointed to by
> > @@ -37,6 +38,9 @@
> >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> >       (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> >
> > +/*  limit on the number of pages that can be on the reporting vq */
> > +#define VIRTIO_BALLOON_VRING_HINTS_MAX       16
> > +
> >  #ifdef CONFIG_BALLOON_COMPACTION
> >  static struct vfsmount *balloon_mnt;
> >  #endif
> > @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
> >       VIRTIO_BALLOON_VQ_DEFLATE,
> >       VIRTIO_BALLOON_VQ_STATS,
> >       VIRTIO_BALLOON_VQ_FREE_PAGE,
> > +     VIRTIO_BALLOON_VQ_REPORTING,
> >       VIRTIO_BALLOON_VQ_MAX
> >  };
> >
> > @@ -113,6 +118,10 @@ struct virtio_balloon {
> >
> >       /* To register a shrinker to shrink memory upon memory pressure */
> >       struct shrinker shrinker;
> > +
> > +     /* Unused page reporting device */
> > +     struct virtqueue *reporting_vq;
> > +     struct page_reporting_dev_info ph_dev_info;
> >  };
> >
> >  static struct virtio_device_id id_table[] = {
> > @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >
> >  }
> >
> > +void virtballoon_unused_page_report(struct page_reporting_dev_info *ph_dev_info,
> > +                                 unsigned int nents)
> > +{
> > +     struct virtio_balloon *vb =
> > +             container_of(ph_dev_info, struct virtio_balloon, ph_dev_info);
> > +     struct virtqueue *vq = vb->reporting_vq;
> > +     unsigned int unused, err;
> > +
> > +     /* We should always be able to add these buffers to an empty queue. */
> > +     err = virtqueue_add_inbuf(vq, ph_dev_info->sg, nents, vb,
> > +                               GFP_NOWAIT | __GFP_NOWARN);
> > +
> > +     /*
> > +      * In the extremely unlikely case that something has changed and we
> > +      * are able to trigger an error we will simply display a warning
> > +      * and exit without actually processing the pages.
> > +      */
> > +     if (WARN_ON(err))
> > +             return;
> > +
> > +     virtqueue_kick(vq);
> > +
> > +     /* When host has read buffer, this completes via balloon_ack */
> > +     wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> > +}
> > +
> >  static void set_page_pfns(struct virtio_balloon *vb,
> >                         __virtio32 pfns[], struct page *page)
> >  {
> > @@ -476,6 +511,7 @@ static int init_vqs(struct virtio_balloon *vb)
> >       names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
> >       names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> >       names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > +     names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> >               names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> > @@ -487,11 +523,19 @@ static int init_vqs(struct virtio_balloon *vb)
> >               callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> >       }
> >
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +             names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
> > +             callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
> > +     }
> > +
> >       err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
> >                                        vqs, callbacks, names, NULL, NULL);
> >       if (err)
> >               return err;
> >
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > +             vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
> > +
> >       vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> >       vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > @@ -931,12 +975,30 @@ static int virtballoon_probe(struct virtio_device *vdev)
> >               if (err)
> >                       goto out_del_balloon_wq;
> >       }
> > +
> > +     vb->ph_dev_info.report = virtballoon_unused_page_report;
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +             unsigned int capacity;
> > +
> > +             capacity = min_t(unsigned int,
> > +                              virtqueue_get_vring_size(vb->reporting_vq) - 1,
> > +                              VIRTIO_BALLOON_VRING_HINTS_MAX);
>
> Hmm why - 1 exactly?
> This might end up being 0 in the unusual configuration of vq size 1.
> Also, VIRTIO_BALLOON_VRING_HINTS_MAX is a power of 2 but
> virtqueue_get_vring_size(vb->reporting_vq) - 1 won't
> be if we are using split rings - donnu if that matters.

Is a vq size of 1 valid? Does that mean you can use that 1 descriptor?

Odds are I probably misunderstood the ring config in the other hinting
implementation. Looking it over now I guess it was adding one
additional entry for a command header and that was why it was
reserving one additional slot. I can update the code to drop the "- 1"
if the ring is capable of being fully utilized.

Thanks.

- Alex
