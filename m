Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09F36ADCB
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbfGPRlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 13:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbfGPRlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 13:41:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A26E300CB07;
        Tue, 16 Jul 2019 17:41:33 +0000 (UTC)
Received: from redhat.com (ovpn-122-108.rdu2.redhat.com [10.10.122.108])
        by smtp.corp.redhat.com (Postfix) with SMTP id 116BA600C4;
        Tue, 16 Jul 2019 17:41:20 +0000 (UTC)
Date:   Tue, 16 Jul 2019 13:41:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
Subject: Re: [PATCH v1 6/6] virtio-balloon: Add support for aerating memory
 via hinting
Message-ID: <20190716125845-mutt-send-email-mst@kernel.org>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
 <20190619223338.1231.52537.stgit@localhost.localdomain>
 <20190716055017-mutt-send-email-mst@kernel.org>
 <CAKgT0Uc-2k9o7pjtf-GFAgr83c7RM-RTJ8-OrEzFv92uz+MTDw@mail.gmail.com>
 <20190716115535-mutt-send-email-mst@kernel.org>
 <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ud47-cWu9VnAAD_Q2Fjia5gaWCz_L9HUF6PBhbugv6tCQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 16 Jul 2019 17:41:34 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 09:54:37AM -0700, Alexander Duyck wrote:
> On Tue, Jul 16, 2019 at 9:08 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jul 16, 2019 at 08:37:06AM -0700, Alexander Duyck wrote:
> > > On Tue, Jul 16, 2019 at 2:55 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Jun 19, 2019 at 03:33:38PM -0700, Alexander Duyck wrote:
> > > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > >
> > > > > Add support for aerating memory using the hinting feature provided by
> > > > > virtio-balloon. Hinting differs from the regular balloon functionality in
> > > > > that is is much less durable than a standard memory balloon. Instead of
> > > > > creating a list of pages that cannot be accessed the pages are only
> > > > > inaccessible while they are being indicated to the virtio interface. Once
> > > > > the interface has acknowledged them they are placed back into their
> > > > > respective free lists and are once again accessible by the guest system.
> > > > >
> > > > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > > > ---
> > > > >  drivers/virtio/Kconfig              |    1
> > > > >  drivers/virtio/virtio_balloon.c     |  110 ++++++++++++++++++++++++++++++++++-
> > > > >  include/uapi/linux/virtio_balloon.h |    1
> > > > >  3 files changed, 108 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > > > index 023fc3bc01c6..9cdaccf92c3a 100644
> > > > > --- a/drivers/virtio/Kconfig
> > > > > +++ b/drivers/virtio/Kconfig
> > > > > @@ -47,6 +47,7 @@ config VIRTIO_BALLOON
> > > > >       tristate "Virtio balloon driver"
> > > > >       depends on VIRTIO
> > > > >       select MEMORY_BALLOON
> > > > > +     select AERATION
> > > > >       ---help---
> > > > >        This driver supports increasing and decreasing the amount
> > > > >        of memory within a KVM guest.
> > > > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > > > index 44339fc87cc7..91f1e8c9017d 100644
> > > > > --- a/drivers/virtio/virtio_balloon.c
> > > > > +++ b/drivers/virtio/virtio_balloon.c
> > > > > @@ -18,6 +18,7 @@
> > > > >  #include <linux/mm.h>
> > > > >  #include <linux/mount.h>
> > > > >  #include <linux/magic.h>
> > > > > +#include <linux/memory_aeration.h>
> > > > >
> > > > >  /*
> > > > >   * Balloon device works in 4K page units.  So each page is pointed to by
> > > > > @@ -26,6 +27,7 @@
> > > > >   */
> > > > >  #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
> > > > >  #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
> > > > > +#define VIRTIO_BALLOON_ARRAY_HINTS_MAX       32
> > > > >  #define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
> > > > >
> > > > >  #define VIRTIO_BALLOON_FREE_PAGE_ALLOC_FLAG (__GFP_NORETRY | __GFP_NOWARN | \
> > > > > @@ -45,6 +47,7 @@ enum virtio_balloon_vq {
> > > > >       VIRTIO_BALLOON_VQ_DEFLATE,
> > > > >       VIRTIO_BALLOON_VQ_STATS,
> > > > >       VIRTIO_BALLOON_VQ_FREE_PAGE,
> > > > > +     VIRTIO_BALLOON_VQ_HINTING,
> > > > >       VIRTIO_BALLOON_VQ_MAX
> > > > >  };
> > > > >
> > > > > @@ -54,7 +57,8 @@ enum virtio_balloon_config_read {
> > > > >
> > > > >  struct virtio_balloon {
> > > > >       struct virtio_device *vdev;
> > > > > -     struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
> > > > > +     struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
> > > > > +                                                             *hinting_vq;
> > > > >
> > > > >       /* Balloon's own wq for cpu-intensive work items */
> > > > >       struct workqueue_struct *balloon_wq;
> > > > > @@ -103,9 +107,21 @@ struct virtio_balloon {
> > > > >       /* Synchronize access/update to this struct virtio_balloon elements */
> > > > >       struct mutex balloon_lock;
> > > > >
> > > > > -     /* The array of pfns we tell the Host about. */
> > > > > -     unsigned int num_pfns;
> > > > > -     __virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
> > > > > +
> > > > > +     union {
> > > > > +             /* The array of pfns we tell the Host about. */
> > > > > +             struct {
> > > > > +                     unsigned int num_pfns;
> > > > > +                     __virtio32 pfns[VIRTIO_BALLOON_ARRAY_PFNS_MAX];
> > > > > +             };
> > > > > +             /* The array of physical addresses we are hinting on */
> > > > > +             struct {
> > > > > +                     unsigned int num_hints;
> > > > > +                     __virtio64 hints[VIRTIO_BALLOON_ARRAY_HINTS_MAX];
> > > > > +             };
> > > > > +     };
> > > > > +
> > > > > +     struct aerator_dev_info a_dev_info;
> > > > >
> > > > >       /* Memory statistics */
> > > > >       struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
> > > > > @@ -151,6 +167,68 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> > > > >
> > > > >  }
> > > > >
> > > > > +static u64 page_to_hints_pa_order(struct page *page)
> > > > > +{
> > > > > +     unsigned char order;
> > > > > +     dma_addr_t pa;
> > > > > +
> > > > > +     BUILD_BUG_ON((64 - VIRTIO_BALLOON_PFN_SHIFT) >=
> > > > > +                  (1 << VIRTIO_BALLOON_PFN_SHIFT));
> > > > > +
> > > > > +     /*
> > > > > +      * Record physical page address combined with page order.
> > > > > +      * Order will never exceed 64 - VIRTIO_BALLON_PFN_SHIFT
> > > > > +      * since the size has to fit into a 64b value. So as long
> > > > > +      * as VIRTIO_BALLOON_SHIFT is greater than this combining
> > > > > +      * the two values should be safe.
> > > > > +      */
> > > > > +     pa = page_to_phys(page);
> > > > > +     order = page_private(page) +
> > > > > +             PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT;
> > > > > +
> > > > > +     return (u64)(pa | order);
> > > > > +}
> > > > > +
> > > > > +void virtballoon_aerator_react(struct aerator_dev_info *a_dev_info)
> > > > > +{
> > > > > +     struct virtio_balloon *vb = container_of(a_dev_info,
> > > > > +                                             struct virtio_balloon,
> > > > > +                                             a_dev_info);
> > > > > +     struct virtqueue *vq = vb->hinting_vq;
> > > > > +     struct scatterlist sg;
> > > > > +     unsigned int unused;
> > > > > +     struct page *page;
> > > > > +
> > > > > +     mutex_lock(&vb->balloon_lock);
> > > > > +
> > > > > +     vb->num_hints = 0;
> > > > > +
> > > > > +     list_for_each_entry(page, &a_dev_info->batch, lru) {
> > > > > +             vb->hints[vb->num_hints++] =
> > > > > +                             cpu_to_virtio64(vb->vdev,
> > > > > +                                             page_to_hints_pa_order(page));
> > > > > +     }
> > > > > +
> > > > > +     /* We shouldn't have been called if there is nothing to process */
> > > > > +     if (WARN_ON(vb->num_hints == 0))
> > > > > +             goto out;
> > > > > +
> > > > > +     sg_init_one(&sg, vb->hints,
> > > > > +                 sizeof(vb->hints[0]) * vb->num_hints);
> > > > > +
> > > > > +     /*
> > > > > +      * We should always be able to add one buffer to an
> > > > > +      * empty queue.
> > > > > +      */
> > > > > +     virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
> > > > > +     virtqueue_kick(vq);
> > > > > +
> > > > > +     /* When host has read buffer, this completes via balloon_ack */
> > > > > +     wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> > > > > +out:
> > > > > +     mutex_unlock(&vb->balloon_lock);
> > > > > +}
> > > > > +
> > > > >  static void set_page_pfns(struct virtio_balloon *vb,
> > > > >                         __virtio32 pfns[], struct page *page)
> > > > >  {
> > > > > @@ -475,6 +553,7 @@ static int init_vqs(struct virtio_balloon *vb)
> > > > >       names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
> > > > >       names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> > > > >       names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > > > > +     names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
> > > > >
> > > > >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > > > >               names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> > > > > @@ -486,11 +565,19 @@ static int init_vqs(struct virtio_balloon *vb)
> > > > >               callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > > > >       }
> > > > >
> > > > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
> > > > > +             names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
> > > > > +             callbacks[VIRTIO_BALLOON_VQ_HINTING] = balloon_ack;
> > > > > +     }
> > > > > +
> > > > >       err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
> > > > >                                        vqs, callbacks, names, NULL, NULL);
> > > > >       if (err)
> > > > >               return err;
> > > > >
> > > > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
> > > > > +             vb->hinting_vq = vqs[VIRTIO_BALLOON_VQ_HINTING];
> > > > > +
> > > > >       vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> > > > >       vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> > > > >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > > > > @@ -929,12 +1016,24 @@ static int virtballoon_probe(struct virtio_device *vdev)
> > > > >               if (err)
> > > > >                       goto out_del_balloon_wq;
> > > > >       }
> > > > > +
> > > > > +     vb->a_dev_info.react = virtballoon_aerator_react;
> > > > > +     vb->a_dev_info.capacity = VIRTIO_BALLOON_ARRAY_HINTS_MAX;
> > > > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
> > > > > +             err = aerator_startup(&vb->a_dev_info);
> > > > > +             if (err)
> > > > > +                     goto out_unregister_shrinker;
> > > > > +     }
> > > > > +
> > > > >       virtio_device_ready(vdev);
> > > > >
> > > > >       if (towards_target(vb))
> > > > >               virtballoon_changed(vdev);
> > > > >       return 0;
> > > > >
> > > > > +out_unregister_shrinker:
> > > > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> > > > > +             virtio_balloon_unregister_shrinker(vb);
> > > > >  out_del_balloon_wq:
> > > > >       if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> > > > >               destroy_workqueue(vb->balloon_wq);
> > > > > @@ -963,6 +1062,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
> > > > >  {
> > > > >       struct virtio_balloon *vb = vdev->priv;
> > > > >
> > > > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
> > > > > +             aerator_shutdown();
> > > > >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> > > > >               virtio_balloon_unregister_shrinker(vb);
> > > > >       spin_lock_irq(&vb->stop_update_lock);
> > > > > @@ -1032,6 +1133,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
> > > > >       VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> > > > >       VIRTIO_BALLOON_F_FREE_PAGE_HINT,
> > > > >       VIRTIO_BALLOON_F_PAGE_POISON,
> > > > > +     VIRTIO_BALLOON_F_HINTING,
> > > > >  };
> > > > >
> > > > >  static struct virtio_driver virtio_balloon_driver = {
> > > > > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> > > > > index a1966cd7b677..2b0f62814e22 100644
> > > > > --- a/include/uapi/linux/virtio_balloon.h
> > > > > +++ b/include/uapi/linux/virtio_balloon.h
> > > > > @@ -36,6 +36,7 @@
> > > > >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM      2 /* Deflate balloon on OOM */
> > > > >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT      3 /* VQ to report free pages */
> > > > >  #define VIRTIO_BALLOON_F_PAGE_POISON 4 /* Guest is using page poisoning */
> > > > > +#define VIRTIO_BALLOON_F_HINTING     5 /* Page hinting virtqueue */
> > > > >
> > > > >  /* Size of a PFN in the balloon interface. */
> > > > >  #define VIRTIO_BALLOON_PFN_SHIFT 12
> > > >
> > > >
> > > >
> > > > The approach here is very close to what on-demand hinting that is
> > > > already upstream does.
> > > >
> > > > This should have resulted in a most of the code being shared
> > > > but this does not seem to happen here.
> > > >
> > > > Can we unify the code in some way?
> > > > It can still use a separate feature flag, but there are things
> > > > I like very much about current hinting code, such as
> > > > using s/g instead of passing PFNs in a buffer.
> > > >
> > > > If this doesn't work could you elaborate on why?
> > >
> > > As far as sending a scatter gather that shouldn't be too much of an
> > > issue, however I need to double check that I will still be able to
> > > keep the completions as a single block.
> > >
> > > One significant spot where the "VIRTIO_BALLOON_F_FREE_PAGE_HINT" code
> > > and my code differs. My code is processing a fixed discreet block of
> > > pages at a time, whereas the FREE_PAGE_HINT code is slurping up all
> > > available high-order memory and stuffing it into a giant balloon and
> > > has more of a streaming setup as it doesn't return things until either
> > > forced to by the shrinker or once it has processed all available
> > > memory.
> >
> > This is what I am saying. Having watched that patchset being developed,
> > I think that's simply because processing blocks required mm core
> > changes, which Wei was not up to pushing through.
> >
> >
> > If we did
> >
> >         while (1) {
> >                 alloc_pages
> >                 add_buf
> >                 get_buf
> >                 free_pages
> >         }
> >
> > We'd end up passing the same page to balloon again and again.
> >
> > So we end up reserving lots of memory with alloc_pages instead.
> >
> > What I am saying is that now that you are developing
> > infrastructure to iterate over free pages,
> > FREE_PAGE_HINT should be able to use it too.
> > Whether that's possible might be a good indication of
> > whether the new mm APIs make sense.
> 
> The problem is the infrastructure as implemented isn't designed to do
> that. I am pretty certain this interface will have issues with being
> given small blocks to process at a time.
> 
> Basically the design for the FREE_PAGE_HINT feature doesn't really
> have the concept of doing things a bit at a time. It is either
> filling, stopped, or done. From what I can tell it requires a
> configuration change for the virtio balloon interface to toggle
> between those states.

Maybe I misunderstand what you are saying.

Filling state can definitely report things
a bit at a time. It does not assume that
all of guest free memory can fit in a VQ.



> > > The basic idea with the bubble hinting was to essentially create mini
> > > balloons. As such I had based the code off of the balloon inflation
> > > code. The only spot where it really differs is that I needed the
> > > ability to pass higher order pages so I tweaked thinks and passed
> > > "hints" instead of "pfns".
> >
> > And that is fine. But there isn't really such a big difference with
> > FREE_PAGE_HINT except FREE_PAGE_HINT triggers upon host request and not
> > in response to guest load.
> 
> I disagree, I believe there is a significant difference.

Yes there is, I just don't think it's in the iteration.
The iteration seems to be useful to hinting.

> The
> FREE_PAGE_HINT code was implemented to be more of a streaming
> interface.

It's implemented like this but it does not follow from
the interface. The implementation is a combination of
attempts to minimize # of exits and minimize mm core changes.

> This is one of the things Linus kept complaining about in
> his comments. This code attempts to pull in ALL of the higher order
> pages, not just a smaller block of them.

It wants to report all higher order pages eventually, yes.
But it's absolutely fine to report a chunk and then wait
for host to process the chunk before reporting more.

However, interfaces we came up with for this would call
into virtio with a bunch of locks taken.
The solution was to take pages off the free list completely.
That in turn means we can't return them until
we have processed all free memory.


> Honestly the difference is
> mostly in the hypervisor interface than what is needed for the kernel
> interface, however the design of the hypervisor interface would make
> doing things more incrementally much more difficult.

OK that's interesting. The hypervisor interface is not
documented in the spec yet. Let me take a stub at a writeup now. So:



- hypervisor requests reporting by modifying command ID
  field in config space, and interrupting guest

- in response, guest sends the command ID value on a special
  free page hinting VQ,
  followed by any number of buffers. Each buffer is assumed
  to be the address and length of memory that was
  unused *at some point after the time when command ID was sent*.

  Note that hypervisor takes pains to handle the case
  where memory is actually no longer free by the time
  it gets the memory.
  This allows guest driver to take more liberties
  and free pages without waiting for guest to
  use the buffers.

  This is also one of the reason we call this a free page hint -
  the guarantee that page is free is a weak one,
  in that sense it's more of a hint than a promise.
  That helps guarantee we don't create OOM out of blue.

- guest eventually sends a special buffer signalling to
  host that it's done sending free pages.
  It then stops reporting until command id changes.

- host can restart the process at any time by
  updating command ID. That will make guest stop
  and start from the beginning.

- host can also stop the process by specifying a special
  command ID value.


=========


Now let's compare to what you have here:

- At any time after boot, guest walks over free memory and sends
  addresses as buffers to the host

- Memory reported is then guaranteed to be unused
  until host has used the buffers


Is above a fair summary?

So yes there's a difference but the specific bit of chunking is same
imho.

> With that said I will take a look into at least using the scatter
> gather interface directly rather than sending the list. I think I can
> probably do that much. However it will actually reduce code reuse as I
> have to check and verify the pages have been processed before I can
> free them back to the host.
> 
> - Alex
