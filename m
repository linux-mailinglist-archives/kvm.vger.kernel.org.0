Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0111310F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 18:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfLDRs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 12:48:56 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38999 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfLDRs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 12:48:56 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so527428ioh.6;
        Wed, 04 Dec 2019 09:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=efwyYDVEiM7aGDZKhgrFkRs+3EAMj4oWKFlAtJhblEI=;
        b=ItoU88XZuzrZO3bd6W+JkwY8rfR0JDmQyDRLJ68ui3CPx+xeIPZ7iS55ewh7T7Oe+2
         7paueF4MTjXbVG8rSQtr61c0KgwiHevS8vAvtIbZq1Gs8YPuROZzzgoqnZ+xiVMWPB5L
         mk3O4jaqPLlg1kGHabfG/udlMaV1dYiLtiDq01MJV+s0vPQmAx0ieKo/IhQRjFGe6aBU
         PuUxn9VPLfDhcAhOn3qBVQqdXkSA6DBzGovCkdhuaxKAF5i/bhCvNDMfP69Jt9ilRw79
         zdGS62OnO0oyfEmBtH3OFeLUbS6Z8UlzhFPMWqYSNtwps714Lp6/TB/yBKsWXWI+YnIk
         SoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=efwyYDVEiM7aGDZKhgrFkRs+3EAMj4oWKFlAtJhblEI=;
        b=aHWdSAahgTQybN9/OWltGNlvpqnsapUvDsRIIOMTwYHqi8jJYRvO1nyYbjnpkRChBD
         ii6ulIDsYIqXMZLmQDoZEEPRB49wa5gY/Xk1X11XCTv1oRMzwVBRusQ3BbOrQGnndnDR
         i0eflmBSiSZlZgK6XLn1aQo3Lrxt0s2DWI8Pup7VJBpOIhN79wxi0NdLruZrSRoE4aqE
         a7FndgBDIB7dbKADZ9Lc4CWSDYvdmJSyqpmqvzR12hZSV1W4UQaOwXIsP+PROC+HNT+M
         72JDoVazCH7YbYJqAIl83piUWOwpipGA10zc23E+/AFwbuiWhG7P8okdId4JFSXu2MoM
         QLeg==
X-Gm-Message-State: APjAAAU73BVHvQCjwt19bgBAAvW+Ery6i6Y//Qwb6votWzztnin0kU/w
        zWpbkP3qnZTqoVubWxSRtG/Z8yYmIrpSjvZjUH0=
X-Google-Smtp-Source: APXvYqx+HiNOZY/r+DvcC0thyFzKBj6fe/NmVDty9GuUTcYoZ/bJj6+o/WNB1el+D0yRPX6IZnoj/cUJ8jKynfWRSR8=
X-Received: by 2002:a02:7f54:: with SMTP id r81mr4203735jac.121.1575481734573;
 Wed, 04 Dec 2019 09:48:54 -0800 (PST)
MIME-Version: 1.0
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain> <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
 <20191128115436-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191128115436-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 4 Dec 2019 09:48:43 -0800
Message-ID: <CAKgT0Uc7g2iOSwwVMZtKg2e2S6SehNoZnOLPiRUfb0PxotUkbw@mail.gmail.com>
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 9:00 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Nov 28, 2019 at 04:25:54PM +0100, David Hildenbrand wrote:
> > On 19.11.19 22:46, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >
> > > Add support for the page reporting feature provided by virtio-balloon.
> > > Reporting differs from the regular balloon functionality in that is is
> > > much less durable than a standard memory balloon. Instead of creating a
> > > list of pages that cannot be accessed the pages are only inaccessible
> > > while they are being indicated to the virtio interface. Once the
> > > interface has acknowledged them they are placed back into their respective
> > > free lists and are once again accessible by the guest system.
> >
> > Maybe add something like "In contrast to ordinary balloon
> > inflation/deflation, the guest can reuse all reported pages immediately
> > after reporting has finished, without having to notify the hypervisor
> > about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."
>
> Maybe we can make apply. The effect of reporting a page is effectively
> putting it in a balloon then immediately taking it out. Maybe without
> VIRTIO_BALLOON_F_MUST_TELL_HOST the pages can be reused before host
> marked buffers used?
>
> We didn't teach existing page hinting to behave like this, but maybe we
> should, and maybe it's not too late, not a long time passed
> since it was merged, and the whole shrinker based thing
> seems to have been broken ...
>
>
> BTW generally UAPI patches will have to be sent to virtio-dev
> mailing list before they are merged.
>
> > [...]
> >
> > >  /*
> > >   * Balloon device works in 4K page units.  So each page is pointed to by
> > > @@ -37,6 +38,9 @@
> > >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> > >     (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> > >
> > > +/*  limit on the number of pages that can be on the reporting vq */
> > > +#define VIRTIO_BALLOON_VRING_HINTS_MAX     16
> >
> > Maybe rename that from HINTS to REPORTS
> >
> > > +
> > >  #ifdef CONFIG_BALLOON_COMPACTION
> > >  static struct vfsmount *balloon_mnt;
> > >  #endif
> > > @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
> > >     VIRTIO_BALLOON_VQ_DEFLATE,
> > >     VIRTIO_BALLOON_VQ_STATS,
> > >     VIRTIO_BALLOON_VQ_FREE_PAGE,
> > > +   VIRTIO_BALLOON_VQ_REPORTING,
> > >     VIRTIO_BALLOON_VQ_MAX
> > >  };
> > >
> > > @@ -113,6 +118,10 @@ struct virtio_balloon {
> > >
> > >     /* To register a shrinker to shrink memory upon memory pressure */
> > >     struct shrinker shrinker;
> > > +
> > > +   /* Unused page reporting device */
> >
> > Sounds like the device is unused :D
> >
> > "Device info for reporting unused pages" ?
> >
> > I am in general wondering, should we rename "unused" to "free". I.e.,
> > "free page reporting" instead of "unused page reporting"? Or what was
> > the motivation behind using "unused" ?
> >
> > > +   struct virtqueue *reporting_vq;
> > > +   struct page_reporting_dev_info pr_dev_info;
> > >  };
> > >
> > >  static struct virtio_device_id id_table[] = {
> > > @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> > >
> > >  }
> > >
> > > +void virtballoon_unused_page_report(struct page_reporting_dev_info *pr_dev_info,
> > > +                               unsigned int nents)
> > > +{
> > > +   struct virtio_balloon *vb =
> > > +           container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> > > +   struct virtqueue *vq = vb->reporting_vq;
> > > +   unsigned int unused, err;
> > > +
> > > +   /* We should always be able to add these buffers to an empty queue. */
> >
> > This comment somewhat contradicts the error handling (and comment)
> > below. Maybe just drop it?
> >
> > > +   err = virtqueue_add_inbuf(vq, pr_dev_info->sg, nents, vb,
> > > +                             GFP_NOWAIT | __GFP_NOWARN);
> > > +
> > > +   /*
> > > +    * In the extremely unlikely case that something has changed and we
> > > +    * are able to trigger an error we will simply display a warning
> > > +    * and exit without actually processing the pages.
> > > +    */
> > > +   if (WARN_ON(err))
> > > +           return;
> >
> > Maybe WARN_ON_ONCE? (to not flood the log on recurring errors)
> >
> > > +
> > > +   virtqueue_kick(vq);
> > > +
> > > +   /* When host has read buffer, this completes via balloon_ack */
> > > +   wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> >
> > Is it safe to rely on the same ack-ing mechanism as the inflate/deflate
> > queue? What if both mechanisms are used concurrently and race/both wait
> > for the hypervisor?
> >
> > Maybe we need a separate vb->acked + callback function.
> >
> > > +}
> > > +
> > >  static void set_page_pfns(struct virtio_balloon *vb,
> > >                       __virtio32 pfns[], struct page *page)
> > >  {
> > > @@ -476,6 +511,7 @@ static int init_vqs(struct virtio_balloon *vb)
> > >     names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
> > >     names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> > >     names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > > +   names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
> > >
> > >     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > >             names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> > > @@ -487,11 +523,19 @@ static int init_vqs(struct virtio_balloon *vb)
> > >             callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> > >     }
> > >
> > > +   if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > > +           names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
> > > +           callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
> > > +   }
> > > +
> > >     err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
> > >                                      vqs, callbacks, names, NULL, NULL);
> > >     if (err)
> > >             return err;
> > >
> > > +   if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > > +           vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
> > > +
> >
> > I'd register these in the same order they are defined (IOW, move this
> > further down)
> >
> > >     vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> > >     vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> > >     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > > @@ -932,12 +976,30 @@ static int virtballoon_probe(struct virtio_device *vdev)
> > >             if (err)
> > >                     goto out_del_balloon_wq;
> > >     }
> > > +
> > > +   vb->pr_dev_info.report = virtballoon_unused_page_report;
> > > +   if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > > +           unsigned int capacity;
> > > +
> > > +           capacity = min_t(unsigned int,
> > > +                            virtqueue_get_vring_size(vb->reporting_vq),
> > > +                            VIRTIO_BALLOON_VRING_HINTS_MAX);
> > > +           vb->pr_dev_info.capacity = capacity;
> > > +
> > > +           err = page_reporting_register(&vb->pr_dev_info);
> > > +           if (err)
> > > +                   goto out_unregister_shrinker;
> > > +   }
> >
> > It can happen here that we start reporting before marking the device
> > ready. Can that be problematic?
> >
> > Maybe we have to ignore any reports in virtballoon_unused_page_report()
> > until ready...
> >
> > > +
> > >     virtio_device_ready(vdev);
> > >
> > >     if (towards_target(vb))
> > >             virtballoon_changed(vdev);
> > >     return 0;
> > >
> > > +out_unregister_shrinker:
> > > +   if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> > > +           virtio_balloon_unregister_shrinker(vb);
> >
> > A sync is done implicitly, right? So after this call, we won't get any
> > new callbacks/are stuck in a callback.
> >
> > >  out_del_balloon_wq:
> > >     if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> > >             destroy_workqueue(vb->balloon_wq);
> > > @@ -966,6 +1028,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
> > >  {
> > >     struct virtio_balloon *vb = vdev->priv;
> > >
> > > +   if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > > +           page_reporting_unregister(&vb->pr_dev_info);
> >
> > Dito, same question regarding syncs.
> >
> > >     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> > >             virtio_balloon_unregister_shrinker(vb);
> > >     spin_lock_irq(&vb->stop_update_lock);
> > > @@ -1038,6 +1102,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
> > >     VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> > >     VIRTIO_BALLOON_F_FREE_PAGE_HINT,
> > >     VIRTIO_BALLOON_F_PAGE_POISON,
> > > +   VIRTIO_BALLOON_F_REPORTING,
> > >  };
> > >
> > >  static struct virtio_driver virtio_balloon_driver = {
> > > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> > > index a1966cd7b677..19974392d324 100644
> > > --- a/include/uapi/linux/virtio_balloon.h
> > > +++ b/include/uapi/linux/virtio_balloon.h
> > > @@ -36,6 +36,7 @@
> > >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM    2 /* Deflate balloon on OOM */
> > >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT    3 /* VQ to report free pages */
> > >  #define VIRTIO_BALLOON_F_PAGE_POISON       4 /* Guest is using page poisoning */
> > > +#define VIRTIO_BALLOON_F_REPORTING 5 /* Page reporting virtqueue */
> > >
> > >  /* Size of a PFN in the balloon interface. */
> > >  #define VIRTIO_BALLOON_PFN_SHIFT 12
> > >
> > >
> >
> > Small and powerful patch :)
> >
> > --
> > Thanks,
> >
> > David / dhildenb
>
>
