Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30616ABF8
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 17:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbfGPPhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 11:37:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44811 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387924AbfGPPhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 11:37:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so19964008qtg.11;
        Tue, 16 Jul 2019 08:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C93X661VNMOR9DFx3hY8rNDYh7Sxy5r20/CPUz7fPoI=;
        b=OhZ27q5680bO3unAKy/oIbRQ/kHunOzN6T3oKB4ku54b6OG12FYS6p/cAWrB12xeTw
         Dq9rLUvss3pISdY4FOhlS3R69lfLwwFp0qFxo+/hgye4iji9hsVqP7qav+NhvvlfvVmC
         k0eVvUMY2h5C/ErIkxEBtkrB5wzGn94RCjDNIXqGeuIaK4xcDGXQ0SuNW9huiZQOpeM9
         NlMovhx4HIrrk/jTZLvkNF+a07kGkvuia+AIzzQ3470a3e5PhIoplJX3vUKNPVY4gvTB
         RuN/DgAGzx5EOH0d58n7ZdEmV6WtnVPz4BI+sYEoZGCzFEcwtrv2+b/n7uh6cqhTfVxg
         WZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C93X661VNMOR9DFx3hY8rNDYh7Sxy5r20/CPUz7fPoI=;
        b=kXC02tJEbBmND3X/2ELztROkoPQlENacdaNJQAF0ochw0uBuFeBBVzFNSzd/wTDLmZ
         mGNlTkFgc80EnF8ITHh6RWCNwwP/nMSNlNNCEAr8m8LO1Y2RG7bOPmHG4K/8aN9PoTpp
         iPMGWJJGoESWMpDnRNElfwfbsiU2VPRT4Ttt7sVn+q6Cvdyqtfdzy7720I+FQ4NWvAjZ
         TG+e2J+2Rjt8KrtcyJfo7Wp2EKRklolW1WayouUlipNxAPKR9yFFcbq6Z2PW3KWdqURa
         qVZk0NS/oPfiLfUKyrOSm5Dzxy7fPQUoQPpNUCAw98gV6auYFhr3kHP5mCm6kDVEXzPF
         Vwqw==
X-Gm-Message-State: APjAAAXRUK5HmPzzEsYTIVHSYJ1QJoNzyXPogqG5izBOHrLrxpfvFlJ0
        23N1aRGTssmXXoXheBWZGqxkqxmy7eDMIzrfPBQ=
X-Google-Smtp-Source: APXvYqy5077FqnRt9dZKnpu3FoJaG6aAk6xbfNR4grwb2kuiH/6uuo0NehX4b2tBaddVUBwvXctFAZweZPx0M0mSfVE=
X-Received: by 2002:ac8:32c8:: with SMTP id a8mr22704040qtb.47.1563291437641;
 Tue, 16 Jul 2019 08:37:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain> <20190716055017-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190716055017-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 16 Jul 2019 08:37:06 -0700
Message-ID: <CAKgT0Uc-2k9o7pjtf-GFAgr83c7RM-RTJ8-OrEzFv92uz+MTDw@mail.gmail.com>
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 2:55 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 19, 2019 at 03:33:38PM -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Add support for aerating memory using the hinting feature provided by
> > virtio-balloon. Hinting differs from the regular balloon functionality in
> > that is is much less durable than a standard memory balloon. Instead of
> > creating a list of pages that cannot be accessed the pages are only
> > inaccessible while they are being indicated to the virtio interface. Once
> > the interface has acknowledged them they are placed back into their
> > respective free lists and are once again accessible by the guest system.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  drivers/virtio/Kconfig              |    1
> >  drivers/virtio/virtio_balloon.c     |  110 ++++++++++++++++++++++++++++++++++-
> >  include/uapi/linux/virtio_balloon.h |    1
> >  3 files changed, 108 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > index 023fc3bc01c6..9cdaccf92c3a 100644
> > --- a/drivers/virtio/Kconfig
> > +++ b/drivers/virtio/Kconfig
> > @@ -47,6 +47,7 @@ config VIRTIO_BALLOON
> >       tristate "Virtio balloon driver"
> >       depends on VIRTIO
> >       select MEMORY_BALLOON
> > +     select AERATION
> >       ---help---
> >        This driver supports increasing and decreasing the amount
> >        of memory within a KVM guest.
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 44339fc87cc7..91f1e8c9017d 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/mount.h>
> >  #include <linux/magic.h>
> > +#include <linux/memory_aeration.h>
> >
> >  /*
> >   * Balloon device works in 4K page units.  So each page is pointed to by
> > @@ -26,6 +27,7 @@
> >   */
> >  #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
> >  #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
> > +#define VIRTIO_BALLOON_ARRAY_HINTS_MAX       32
> >  #define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
> >
> >  #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
> > @@ -45,6 +47,7 @@ enum virtio_balloon_vq {
> >       VIRTIO_BALLOON_VQ_DEFLATE,
> >       VIRTIO_BALLOON_VQ_STATS,
> >       VIRTIO_BALLOON_VQ_FREE_PAGE,
> > +     VIRTIO_BALLOON_VQ_HINTING,
> >       VIRTIO_BALLOON_VQ_MAX
> >  };
> >
> > @@ -54,7 +57,8 @@ enum virtio_balloon_config_read {
> >
> >  struct virtio_balloon {
> >       struct virtio_device *vdev;
> > -     struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
> > +     struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
> > +                                                             *hinting_vq;
> >
> >       /* Balloon's own wq for cpu-intensive work items */
> >       struct workqueue_struct *balloon_wq;
> > @@ -103,9 +107,21 @@ struct virtio_balloon {
> >       /* Synchronize access/update to this struct virtio_balloon elements */
> >       struct mutex balloon_lock;
> >
> > -     /* The array of pfns we tell the Host about. */
> > -     unsigned int num_pfns;
> > -     __virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
> > +
> > +     union {
> > +             /* The array of pfns we tell the Host about. */
> > +             struct {
> > +                     unsigned int num_pfns;
> > +                     __virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
> > +             };
> > +             /* The array of physical addresses we are hinting on */
> > +             struct {
> > +                     unsigned int num_hints;
> > +                     __virtio64 hints[VIRTIO_BALLOON_ARRAY_HINTS_MAX];
> > +             };
> > +     };
> > +
> > +     struct aerator_dev_info a_dev_info;
> >
> >       /* Memory statistics */
> >       struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
> > @@ -151,6 +167,68 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >
> >  }
> >
> > +static u64 page_to_hints_pa_order(struct page *page)
> > +{
> > +     unsigned char order;
> > +     dma_addr_t pa;
> > +
> > +     BUILD_BUG_ON((64 - VIRTIO_BALLOON_PFN_SHIFT) >=
> > +                  (1 << VIRTIO_BALLOON_PFN_SHIFT));
> > +
> > +     /*
> > +      * Record physical page address combined with page order.
> > +      * Order will never exceed 64 - VIRTIO_BALLON_PFN_SHIFT
> > +      * since the size has to fit into a 64b value. So as long
> > +      * as VIRTIO_BALLOON_SHIFT is greater than this combining
> > +      * the two values should be safe.
> > +      */
> > +     pa = page_to_phys(page);
> > +     order = page_private(page) +
> > +             PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT;
> > +
> > +     return (u64)(pa | order);
> > +}
> > +
> > +void virtballoon_aerator_react(struct aerator_dev_info *a_dev_info)
> > +{
> > +     struct virtio_balloon *vb = container_of(a_dev_info,
> > +                                             struct virtio_balloon,
> > +                                             a_dev_info);
> > +     struct virtqueue *vq = vb->hinting_vq;
> > +     struct scatterlist sg;
> > +     unsigned int unused;
> > +     struct page *page;
> > +
> > +     mutex_lock(&vb->balloon_lock);
> > +
> > +     vb->num_hints = 0;
> > +
> > +     list_for_each_entry(page, &a_dev_info->batch, lru) {
> > +             vb->hints[vb->num_hints++] =
> > +                             cpu_to_virtio64(vb->vdev,
> > +                                             page_to_hints_pa_order(page));
> > +     }
> > +
> > +     /* We shouldn't have been called if there is nothing to process */
> > +     if (WARN_ON(vb->num_hints == 0))
> > +             goto out;
> > +
> > +     sg_init_one(&sg, vb->hints,
> > +                 sizeof(vb->hints[0]) * vb->num_hints);
> > +
> > +     /*
> > +      * We should always be able to add one buffer to an
> > +      * empty queue.
> > +      */
> > +     virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
> > +     virtqueue_kick(vq);
> > +
> > +     /* When host has read buffer, this completes via balloon_ack */
> > +     wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> > +out:
> > +     mutex_unlock(&vb->balloon_lock);
> > +}
> > +
> >  static void set_page_pfns(struct virtio_balloon *vb,
> >                         __virtio32 pfns[], struct page *page)
> >  {
> > @@ -475,6 +553,7 @@ static int init_vqs(struct virtio_balloon *vb)
> >       names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
> >       names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> >       names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > +     names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
> >
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> >               names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> > @@ -486,11 +565,19 @@ static int init_vqs(struct virtio_balloon *vb)
> >               callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> >       }
> >
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
> > +             names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
> > +             callbacks[VIRTIO_BALLOON_VQ_HINTING] = balloon_ack;
> > +     }
> > +
> >       err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
> >                                        vqs, callbacks, names, NULL, NULL);
> >       if (err)
> >               return err;
> >
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
> > +             vb->hinting_vq = vqs[VIRTIO_BALLOON_VQ_HINTING];
> > +
> >       vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> >       vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > @@ -929,12 +1016,24 @@ static int virtballoon_probe(struct virtio_device *vdev)
> >               if (err)
> >                       goto out_del_balloon_wq;
> >       }
> > +
> > +     vb->a_dev_info.react = virtballoon_aerator_react;
> > +     vb->a_dev_info.capacity = VIRTIO_BALLOON_ARRAY_HINTS_MAX;
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
> > +             err = aerator_startup(&vb->a_dev_info);
> > +             if (err)
> > +                     goto out_unregister_shrinker;
> > +     }
> > +
> >       virtio_device_ready(vdev);
> >
> >       if (towards_target(vb))
> >               virtballoon_changed(vdev);
> >       return 0;
> >
> > +out_unregister_shrinker:
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> > +             virtio_balloon_unregister_shrinker(vb);
> >  out_del_balloon_wq:
> >       if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> >               destroy_workqueue(vb->balloon_wq);
> > @@ -963,6 +1062,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
> >  {
> >       struct virtio_balloon *vb = vdev->priv;
> >
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
> > +             aerator_shutdown();
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> >               virtio_balloon_unregister_shrinker(vb);
> >       spin_lock_irq(&vb->stop_update_lock);
> > @@ -1032,6 +1133,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
> >       VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> >       VIRTIO_BALLOON_F_FREE_PAGE_HINT,
> >       VIRTIO_BALLOON_F_PAGE_POISON,
> > +     VIRTIO_BALLOON_F_HINTING,
> >  };
> >
> >  static struct virtio_driver virtio_balloon_driver = {
> > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> > index a1966cd7b677..2b0f62814e22 100644
> > --- a/include/uapi/linux/virtio_balloon.h
> > +++ b/include/uapi/linux/virtio_balloon.h
> > @@ -36,6 +36,7 @@
> >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM      2 /* Deflate balloon on OOM */
> >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT      3 /* VQ to report free pages */
> >  #define VIRTIO_BALLOON_F_PAGE_POISON 4 /* Guest is using page poisoning */
> > +#define VIRTIO_BALLOON_F_HINTING     5 /* Page hinting virtqueue */
> >
> >  /* Size of a PFN in the balloon interface. */
> >  #define VIRTIO_BALLOON_PFN_SHIFT 12
>
>
>
> The approach here is very close to what on-demand hinting that is
> already upstream does.
>
> This should have resulted in a most of the code being shared
> but this does not seem to happen here.
>
> Can we unify the code in some way?
> It can still use a separate feature flag, but there are things
> I like very much about current hinting code, such as
> using s/g instead of passing PFNs in a buffer.
>
> If this doesn't work could you elaborate on why?

As far as sending a scatter gather that shouldn't be too much of an
issue, however I need to double check that I will still be able to
keep the completions as a single block.

One significant spot where the "VIRTIO_BALLOON_F_FREE_PAGE_HINT" code
and my code differs. My code is processing a fixed discreet block of
pages at a time, whereas the FREE_PAGE_HINT code is slurping up all
available high-order memory and stuffing it into a giant balloon and
has more of a streaming setup as it doesn't return things until either
forced to by the shrinker or once it has processed all available
memory.

The basic idea with the bubble hinting was to essentially create mini
balloons. As such I had based the code off of the balloon inflation
code. The only spot where it really differs is that I needed the
ability to pass higher order pages so I tweaked thinks and passed
"hints" instead of "pfns".
