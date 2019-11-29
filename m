Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3995210DAD5
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfK2VNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:13:46 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46415 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbfK2VNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:13:46 -0500
Received: by mail-il1-f195.google.com with SMTP id t17so1097488ilm.13;
        Fri, 29 Nov 2019 13:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJ8RbTIGZZQ7VJu2rp/1bZ+IuxZXobj9TbZNQdZKBHE=;
        b=qdN0zHl22aRYUrvLOlxp/PivnUhWnY0g+1CZq+skgMhO8eIAosj3SB3I1BuroUtr/U
         9l5e6F9taugoWU9W47NrjUC6j34mKcQJeSn6Ge3FbryDN4iRQG8ABNNQoq+P/hFpow8I
         qmQ4H2WRF+WsXI/XrZ/VLk8gUNLE0xbP3kgzqRjI+UxFSLGdmAQDoGA+JHCsufmZ3iPA
         cQ1YuVYmX09K46n3hCRypvPj7Q14mqb4jX2BhrekYNSKvgsuHJhB/0Yzl8CSE2jKUigA
         D96/y2k/t/Qr2yv7N/bv0vYOEpZ0eGJxA1MoDGOXlyQgxZl9f+AUspBhYHE8B0jeXvOB
         hO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJ8RbTIGZZQ7VJu2rp/1bZ+IuxZXobj9TbZNQdZKBHE=;
        b=UGp3Se3eZJdVLmmhZPTM8vDg+7D4TFStvozj7VbPPGW6LcPSFd/dStj03rjB3rQoz8
         PfdeNjbVkZC7Q/ByiG4g6ULEW43WSLuCuYlx/yI+ns8H8DJt594BKQgLZZC8TSMZnljD
         B/3kVwGMA1rsq8oaWLUW8NLrKChs/FuILrIvz9G69pygoGGY4HVIbUkmS8npYdwbcph0
         txsq0QLITEjPxuIP+1OcqHt3zrMwFXX3/t0o/cqSh8i3dCL+v+cflTZRnj+0uCU4kjKT
         RkyaYOwviS88UxHOXfVNY2pmdSBbnoO4mUcJG7pEtcIWGNdSDDW/3Py7amsLayp7AFLZ
         mlTA==
X-Gm-Message-State: APjAAAVmW7h2VMprQTPIUjOJlYhGfdbwQIffCOL63vMGvqeDITPbkN3m
        aPCBPro38Y2PGW3I9ReERcMX8C4qkzGGBximzso=
X-Google-Smtp-Source: APXvYqz8PHQebGFS+bDvYJwLP/1NZwgIQoF6ZaBfKex11pycHa/29B2aacde4OzWDehPoaR2l/+QaRQ1jCDHqFg3AuI=
X-Received: by 2002:a92:d744:: with SMTP id e4mr16846561ilq.64.1575062023927;
 Fri, 29 Nov 2019 13:13:43 -0800 (PST)
MIME-Version: 1.0
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain> <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
In-Reply-To: <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 29 Nov 2019 13:13:32 -0800
Message-ID: <CAKgT0Uf8iebEXSovdWfXq1FvyGpqrF-X0VDrq-h8xavQkvA_9w@mail.gmail.com>
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

On Thu, Nov 28, 2019 at 7:26 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 19.11.19 22:46, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Add support for the page reporting feature provided by virtio-balloon.
> > Reporting differs from the regular balloon functionality in that is is
> > much less durable than a standard memory balloon. Instead of creating a
> > list of pages that cannot be accessed the pages are only inaccessible
> > while they are being indicated to the virtio interface. Once the
> > interface has acknowledged them they are placed back into their respective
> > free lists and are once again accessible by the guest system.
>
> Maybe add something like "In contrast to ordinary balloon
> inflation/deflation, the guest can reuse all reported pages immediately
> after reporting has finished, without having to notify the hypervisor
> about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."

Okay. I'll make a note of it for next version.

> [...]
>
> >  /*
> >   * Balloon device works in 4K page units.  So each page is pointed to by
> > @@ -37,6 +38,9 @@
> >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> >       (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> >
> > +/*  limit on the number of pages that can be on the reporting vq */
> > +#define VIRTIO_BALLOON_VRING_HINTS_MAX       16
>
> Maybe rename that from HINTS to REPORTS

I'll fix it for the next version.

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
>
> Sounds like the device is unused :D
>
> "Device info for reporting unused pages" ?
>
> I am in general wondering, should we rename "unused" to "free". I.e.,
> "free page reporting" instead of "unused page reporting"? Or what was
> the motivation behind using "unused" ?

I honestly don't remember why I chose "unused" at this point. I can
switch over to "free" if that is what is preferred.

Looking over the code a bit more I suspect the reason for avoiding it
is because free page hinting also mentioned reporting in a few spots.

> > +     struct virtqueue *reporting_vq;
> > +     struct page_reporting_dev_info pr_dev_info;
> >  };
> >
> >  static struct virtio_device_id id_table[] = {
> > @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >
> >  }
> >
> > +void virtballoon_unused_page_report(struct page_reporting_dev_info *pr_dev_info,
> > +                                 unsigned int nents)
> > +{
> > +     struct virtio_balloon *vb =
> > +             container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> > +     struct virtqueue *vq = vb->reporting_vq;
> > +     unsigned int unused, err;
> > +
> > +     /* We should always be able to add these buffers to an empty queue. */
>
> This comment somewhat contradicts the error handling (and comment)
> below. Maybe just drop it?
>
> > +     err = virtqueue_add_inbuf(vq, pr_dev_info->sg, nents, vb,
> > +                               GFP_NOWAIT | __GFP_NOWARN);
> > +
> > +     /*
> > +      * In the extremely unlikely case that something has changed and we
> > +      * are able to trigger an error we will simply display a warning
> > +      * and exit without actually processing the pages.
> > +      */
> > +     if (WARN_ON(err))
> > +             return;
>
> Maybe WARN_ON_ONCE? (to not flood the log on recurring errors)

Actually I might need to tweak things here a bit. It occurs to me that
this can fail for more than just there not being space in the ring. I
forgot that DMA mapping needs to also occur so in the case of a DMA
mapping failure we would also see an error.

I probably will switch it to a WARN_ON_ONCE. I may also need to add a
return value to the function so that we can indicate that an entire
batch has failed and that we need to abort.

> > +
> > +     virtqueue_kick(vq);
> > +
> > +     /* When host has read buffer, this completes via balloon_ack */
> > +     wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
>
> Is it safe to rely on the same ack-ing mechanism as the inflate/deflate
> queue? What if both mechanisms are used concurrently and race/both wait
> for the hypervisor?
>
> Maybe we need a separate vb->acked + callback function.

So if I understand correctly what is actually happening is that the
wait event is simply a trigger that will wake us up, and at that point
we check to see if the buffer we submitted is done. If not we go back
to sleep. As such all we are really waiting on is the notification
that the buffers we submitted have been processed. So it is using the
same function but on a different virtual queue.

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
>
> I'd register these in the same order they are defined (IOW, move this
> further down)

done.

> >       vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> >       vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > @@ -932,12 +976,30 @@ static int virtballoon_probe(struct virtio_device *vdev)
> >               if (err)
> >                       goto out_del_balloon_wq;
> >       }
> > +
> > +     vb->pr_dev_info.report = virtballoon_unused_page_report;
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +             unsigned int capacity;
> > +
> > +             capacity = min_t(unsigned int,
> > +                              virtqueue_get_vring_size(vb->reporting_vq),
> > +                              VIRTIO_BALLOON_VRING_HINTS_MAX);
> > +             vb->pr_dev_info.capacity = capacity;
> > +
> > +             err = page_reporting_register(&vb->pr_dev_info);
> > +             if (err)
> > +                     goto out_unregister_shrinker;
> > +     }
>
> It can happen here that we start reporting before marking the device
> ready. Can that be problematic?
>
> Maybe we have to ignore any reports in virtballoon_unused_page_report()
> until ready...

I don't think there is an issue with us putting buffers on the ring
before it is ready. I think it will just cause our function to sleep.

I'm guessing that is the case since init_vqs will add a buffer to the
stats vq and that happens even earlier in virtballoon_probe.

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
>
> A sync is done implicitly, right? So after this call, we won't get any
> new callbacks/are stuck in a callback.

From what I can tell a read/write semaphore is used in
unregister_shrinker when we delete it from the list so it shouldn't be
an issue.

> >  out_del_balloon_wq:
> >       if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> >               destroy_workqueue(vb->balloon_wq);
> > @@ -966,6 +1028,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
> >  {
> >       struct virtio_balloon *vb = vdev->priv;
> >
> > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > +             page_reporting_unregister(&vb->pr_dev_info);
>
> Dito, same question regarding syncs.

Yes, although for that one I was using pointer deletion, a barrier,
and a cancel_work_sync since I didn't support a list.

> >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> >               virtio_balloon_unregister_shrinker(vb);
> >       spin_lock_irq(&vb->stop_update_lock);
> > @@ -1038,6 +1102,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
> >       VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> >       VIRTIO_BALLOON_F_FREE_PAGE_HINT,
> >       VIRTIO_BALLOON_F_PAGE_POISON,
> > +     VIRTIO_BALLOON_F_REPORTING,
> >  };
> >
> >  static struct virtio_driver virtio_balloon_driver = {
> > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> > index a1966cd7b677..19974392d324 100644
> > --- a/include/uapi/linux/virtio_balloon.h
> > +++ b/include/uapi/linux/virtio_balloon.h
> > @@ -36,6 +36,7 @@
> >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM      2 /* Deflate balloon on OOM */
> >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT      3 /* VQ to report free pages */
> >  #define VIRTIO_BALLOON_F_PAGE_POISON 4 /* Guest is using page poisoning */
> > +#define VIRTIO_BALLOON_F_REPORTING   5 /* Page reporting virtqueue */
> >
> >  /* Size of a PFN in the balloon interface. */
> >  #define VIRTIO_BALLOON_PFN_SHIFT 12
> >
> >
>
> Small and powerful patch :)

Agreed. Although we will have to see if we can keep it that way.
Ideally I want to leave this with the ability so specify what size
scatterlist we receive. However if we have to flip it around then it
will force us to add logic for chopping up the scatterlist for
processing in chunks.

Thanks for the review.

- Alex
