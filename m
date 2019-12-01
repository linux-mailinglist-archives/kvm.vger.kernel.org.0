Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B97610E1C1
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2019 12:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfLALqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Dec 2019 06:46:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34945 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726186AbfLALqn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 1 Dec 2019 06:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575200801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8vZSTFTClz+gFYFT8rY2rqTrpX2zFmVovSigmWOJuME=;
        b=ZNiGtZDoy/VThjByNEdEI7s0RMiF+mfoAPUHQ6czxAj64UHY4SrQQoPeWKEOKfxThlsfJs
        UZrZm6qWkuwuDnQD9h3L6b/cD6YQQWM8O3t8UbzVobVmtw+rFR6qCybgku+a0rElu80jTp
        +4H6CQmgmLhcdjFU2mZW4NLzTcL66kQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-w483Cw8bNEyWv6jp1mTPug-1; Sun, 01 Dec 2019 06:46:38 -0500
Received: by mail-qk1-f198.google.com with SMTP id a6so7488357qkl.7
        for <kvm@vger.kernel.org>; Sun, 01 Dec 2019 03:46:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GZ2K4EhFx9VSHnQ9Db4nl7lYmDIyd3raQqWfh0qOyio=;
        b=VGtm788YNFWJYesQQtR5AqC0Btxl1R29qmz2g5RdH5QML+QEm7zF2/qPXltkn9EBYt
         2uokHRs6grshXVz6U+GK7HGzn0Ac4C9Ms3TWRqFvHNmoL4W7CZQaXCZoHz30q40ffetr
         vA2TnyZtINl0rLJq14aFqjjW5sbbgemujJyT/OyU6Ie+YOMGjlHQ5Tb1sS3lG+KT6rJT
         C+uxXvBPwwB7mwggeah4d7AHdTJGCzsOAClCdnWb0fWrn4/MSkXpqhaI2ZG+f8KyJzws
         qLH8zHK7z5qgIhHqpUl3vY+Xp2KMSErV4PLIx2qHSre5lWvYR/gJMm1q1r3B9UZ3n8Lo
         w2nw==
X-Gm-Message-State: APjAAAWQJhp5RA8DoLoV7rPb5nlYIXnySGrv5SIoFs9E4uQU552EpFK/
        83CffFRpLYc3S8zO1WdWDYfz+9vYMmmsc9s+w7kYaYaY44z5vkS/4LNDY4aUMcZc/zoPUfipRyo
        LAIx/VFZj3zTw
X-Received: by 2002:a37:a08d:: with SMTP id j135mr12380006qke.455.1575200797465;
        Sun, 01 Dec 2019 03:46:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPDBK8mIuf+qYJn0qUoYQhep/CKiZhygPm3sID1S27ff8V+Dyzk82ZcylZj+dvRZgbwXJX3Q==
X-Received: by 2002:a37:a08d:: with SMTP id j135mr12379977qke.455.1575200796970;
        Sun, 01 Dec 2019 03:46:36 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id d26sm2479811qka.28.2019.12.01.03.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 03:46:35 -0800 (PST)
Date:   Sun, 1 Dec 2019 06:46:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
Message-ID: <20191201041731-mutt-send-email-mst@kernel.org>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain>
 <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
 <CAKgT0Uf8iebEXSovdWfXq1FvyGpqrF-X0VDrq-h8xavQkvA_9w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf8iebEXSovdWfXq1FvyGpqrF-X0VDrq-h8xavQkvA_9w@mail.gmail.com>
X-MC-Unique: w483Cw8bNEyWv6jp1mTPug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 29, 2019 at 01:13:32PM -0800, Alexander Duyck wrote:
> On Thu, Nov 28, 2019 at 7:26 AM David Hildenbrand <david@redhat.com> wrot=
e:
> >
> > On 19.11.19 22:46, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >
> > > Add support for the page reporting feature provided by virtio-balloon=
.
> > > Reporting differs from the regular balloon functionality in that is i=
s
> > > much less durable than a standard memory balloon. Instead of creating=
 a
> > > list of pages that cannot be accessed the pages are only inaccessible
> > > while they are being indicated to the virtio interface. Once the
> > > interface has acknowledged them they are placed back into their respe=
ctive
> > > free lists and are once again accessible by the guest system.
> >
> > Maybe add something like "In contrast to ordinary balloon
> > inflation/deflation, the guest can reuse all reported pages immediately
> > after reporting has finished, without having to notify the hypervisor
> > about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."
>=20
> Okay. I'll make a note of it for next version.


VIRTIO_BALLOON_F_MUST_TELL_HOST is IMHO misdocumented.
It states:
=09VIRTIO_BALLOON_F_MUST_TELL_HOST (0) Host has to be told before pages fro=
m the balloon are
=09used.
but really balloon always told host. The difference is in timing,
historically balloon gave up pages before sending the
message and before waiting for the buffer to be used by host.

I think this feature can be the same if we want.


> > [...]
> >
> > >  /*
> > >   * Balloon device works in 4K page units.  So each page is pointed t=
o by
> > > @@ -37,6 +38,9 @@
> > >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> > >       (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> > >
> > > +/*  limit on the number of pages that can be on the reporting vq */
> > > +#define VIRTIO_BALLOON_VRING_HINTS_MAX       16
> >
> > Maybe rename that from HINTS to REPORTS
>=20
> I'll fix it for the next version.
>=20
> > > +
> > >  #ifdef CONFIG_BALLOON_COMPACTION
> > >  static struct vfsmount *balloon_mnt;
> > >  #endif
> > > @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
> > >       VIRTIO_BALLOON_VQ_DEFLATE,
> > >       VIRTIO_BALLOON_VQ_STATS,
> > >       VIRTIO_BALLOON_VQ_FREE_PAGE,
> > > +     VIRTIO_BALLOON_VQ_REPORTING,
> > >       VIRTIO_BALLOON_VQ_MAX
> > >  };
> > >
> > > @@ -113,6 +118,10 @@ struct virtio_balloon {
> > >
> > >       /* To register a shrinker to shrink memory upon memory pressure=
 */
> > >       struct shrinker shrinker;
> > > +
> > > +     /* Unused page reporting device */
> >
> > Sounds like the device is unused :D
> >
> > "Device info for reporting unused pages" ?
> >
> > I am in general wondering, should we rename "unused" to "free". I.e.,
> > "free page reporting" instead of "unused page reporting"? Or what was
> > the motivation behind using "unused" ?
>=20
> I honestly don't remember why I chose "unused" at this point. I can
> switch over to "free" if that is what is preferred.
>=20
> Looking over the code a bit more I suspect the reason for avoiding it
> is because free page hinting also mentioned reporting in a few spots.
>=20
> > > +     struct virtqueue *reporting_vq;
> > > +     struct page_reporting_dev_info pr_dev_info;
> > >  };
> > >
> > >  static struct virtio_device_id id_table[] =3D {
> > > @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb,=
 struct virtqueue *vq)
> > >
> > >  }
> > >
> > > +void virtballoon_unused_page_report(struct page_reporting_dev_info *=
pr_dev_info,
> > > +                                 unsigned int nents)
> > > +{
> > > +     struct virtio_balloon *vb =3D
> > > +             container_of(pr_dev_info, struct virtio_balloon, pr_dev=
_info);
> > > +     struct virtqueue *vq =3D vb->reporting_vq;
> > > +     unsigned int unused, err;
> > > +
> > > +     /* We should always be able to add these buffers to an empty qu=
eue. */
> >
> > This comment somewhat contradicts the error handling (and comment)
> > below. Maybe just drop it?
> >
> > > +     err =3D virtqueue_add_inbuf(vq, pr_dev_info->sg, nents, vb,
> > > +                               GFP_NOWAIT | __GFP_NOWARN);
> > > +
> > > +     /*
> > > +      * In the extremely unlikely case that something has changed an=
d we
> > > +      * are able to trigger an error we will simply display a warnin=
g
> > > +      * and exit without actually processing the pages.
> > > +      */
> > > +     if (WARN_ON(err))
> > > +             return;
> >
> > Maybe WARN_ON_ONCE? (to not flood the log on recurring errors)
>=20
> Actually I might need to tweak things here a bit. It occurs to me that
> this can fail for more than just there not being space in the ring. I
> forgot that DMA mapping needs to also occur so in the case of a DMA
> mapping failure we would also see an error.

Balloon assumes DMA mapping is bypassed right now:

static int virtballoon_validate(struct virtio_device *vdev)
{
        if (!page_poisoning_enabled())
                __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);

        __virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);

^^^^^^^^


        return 0;
}

I don't think it can work with things like a bounce buffer.

> I probably will switch it to a WARN_ON_ONCE. I may also need to add a
> return value to the function so that we can indicate that an entire
> batch has failed and that we need to abort.
>=20
> > > +
> > > +     virtqueue_kick(vq);
> > > +
> > > +     /* When host has read buffer, this completes via balloon_ack */
> > > +     wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> >
> > Is it safe to rely on the same ack-ing mechanism as the inflate/deflate
> > queue? What if both mechanisms are used concurrently and race/both wait
> > for the hypervisor?
> >
> > Maybe we need a separate vb->acked + callback function.
>=20
> So if I understand correctly what is actually happening is that the
> wait event is simply a trigger that will wake us up, and at that point
> we check to see if the buffer we submitted is done. If not we go back
> to sleep. As such all we are really waiting on is the notification
> that the buffers we submitted have been processed. So it is using the
> same function but on a different virtual queue.
>=20
> > > +}
> > > +
> > >  static void set_page_pfns(struct virtio_balloon *vb,
> > >                         __virtio32 pfns[], struct page *page)
> > >  {
> > > @@ -476,6 +511,7 @@ static int init_vqs(struct virtio_balloon *vb)
> > >       names[VIRTIO_BALLOON_VQ_DEFLATE] =3D "deflate";
> > >       names[VIRTIO_BALLOON_VQ_STATS] =3D NULL;
> > >       names[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> > > +     names[VIRTIO_BALLOON_VQ_REPORTING] =3D NULL;
> > >
> > >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > >               names[VIRTIO_BALLOON_VQ_STATS] =3D "stats";
> > > @@ -487,11 +523,19 @@ static int init_vqs(struct virtio_balloon *vb)
> > >               callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> > >       }
> > >
> > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > > +             names[VIRTIO_BALLOON_VQ_REPORTING] =3D "reporting_vq";
> > > +             callbacks[VIRTIO_BALLOON_VQ_REPORTING] =3D balloon_ack;
> > > +     }
> > > +
> > >       err =3D vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_=
MAX,
> > >                                        vqs, callbacks, names, NULL, N=
ULL);
> > >       if (err)
> > >               return err;
> > >
> > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > > +             vb->reporting_vq =3D vqs[VIRTIO_BALLOON_VQ_REPORTING];
> > > +
> >
> > I'd register these in the same order they are defined (IOW, move this
> > further down)
>=20
> done.
>=20
> > >       vb->inflate_vq =3D vqs[VIRTIO_BALLOON_VQ_INFLATE];
> > >       vb->deflate_vq =3D vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> > >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > > @@ -932,12 +976,30 @@ static int virtballoon_probe(struct virtio_devi=
ce *vdev)
> > >               if (err)
> > >                       goto out_del_balloon_wq;
> > >       }
> > > +
> > > +     vb->pr_dev_info.report =3D virtballoon_unused_page_report;
> > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > > +             unsigned int capacity;
> > > +
> > > +             capacity =3D min_t(unsigned int,
> > > +                              virtqueue_get_vring_size(vb->reporting=
_vq),
> > > +                              VIRTIO_BALLOON_VRING_HINTS_MAX);
> > > +             vb->pr_dev_info.capacity =3D capacity;
> > > +
> > > +             err =3D page_reporting_register(&vb->pr_dev_info);
> > > +             if (err)
> > > +                     goto out_unregister_shrinker;
> > > +     }
> >
> > It can happen here that we start reporting before marking the device
> > ready. Can that be problematic?
> >
> > Maybe we have to ignore any reports in virtballoon_unused_page_report()
> > until ready...
>=20
> I don't think there is an issue with us putting buffers on the ring
> before it is ready. I think it will just cause our function to sleep.
>=20
> I'm guessing that is the case since init_vqs will add a buffer to the
> stats vq and that happens even earlier in virtballoon_probe.
>=20
> > > +
> > >       virtio_device_ready(vdev);
> > >
> > >       if (towards_target(vb))
> > >               virtballoon_changed(vdev);
> > >       return 0;
> > >
> > > +out_unregister_shrinker:
> > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OO=
M))
> > > +             virtio_balloon_unregister_shrinker(vb);
> >
> > A sync is done implicitly, right? So after this call, we won't get any
> > new callbacks/are stuck in a callback.
>=20
> >From what I can tell a read/write semaphore is used in
> unregister_shrinker when we delete it from the list so it shouldn't be
> an issue.
>=20
> > >  out_del_balloon_wq:
> > >       if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> > >               destroy_workqueue(vb->balloon_wq);
> > > @@ -966,6 +1028,8 @@ static void virtballoon_remove(struct virtio_dev=
ice *vdev)
> > >  {
> > >       struct virtio_balloon *vb =3D vdev->priv;
> > >
> > > +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > > +             page_reporting_unregister(&vb->pr_dev_info);
> >
> > Dito, same question regarding syncs.
>=20
> Yes, although for that one I was using pointer deletion, a barrier,
> and a cancel_work_sync since I didn't support a list.
>=20
> > >       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OO=
M))
> > >               virtio_balloon_unregister_shrinker(vb);
> > >       spin_lock_irq(&vb->stop_update_lock);
> > > @@ -1038,6 +1102,7 @@ static int virtballoon_validate(struct virtio_d=
evice *vdev)
> > >       VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> > >       VIRTIO_BALLOON_F_FREE_PAGE_HINT,
> > >       VIRTIO_BALLOON_F_PAGE_POISON,
> > > +     VIRTIO_BALLOON_F_REPORTING,
> > >  };
> > >
> > >  static struct virtio_driver virtio_balloon_driver =3D {
> > > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux=
/virtio_balloon.h
> > > index a1966cd7b677..19974392d324 100644
> > > --- a/include/uapi/linux/virtio_balloon.h
> > > +++ b/include/uapi/linux/virtio_balloon.h
> > > @@ -36,6 +36,7 @@
> > >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM      2 /* Deflate balloon on=
 OOM */
> > >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT      3 /* VQ to report free =
pages */
> > >  #define VIRTIO_BALLOON_F_PAGE_POISON 4 /* Guest is using page poison=
ing */
> > > +#define VIRTIO_BALLOON_F_REPORTING   5 /* Page reporting virtqueue *=
/
> > >
> > >  /* Size of a PFN in the balloon interface. */
> > >  #define VIRTIO_BALLOON_PFN_SHIFT 12
> > >
> > >
> >
> > Small and powerful patch :)
>=20
> Agreed. Although we will have to see if we can keep it that way.
> Ideally I want to leave this with the ability so specify what size
> scatterlist we receive. However if we have to flip it around then it
> will force us to add logic for chopping up the scatterlist for
> processing in chunks.
>=20
> Thanks for the review.
>=20
> - Alex

