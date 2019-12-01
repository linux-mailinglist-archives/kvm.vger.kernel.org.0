Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689F010E30E
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2019 19:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLASZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Dec 2019 13:25:23 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37704 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfLASZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Dec 2019 13:25:22 -0500
Received: by mail-il1-f194.google.com with SMTP id t9so11582363iln.4;
        Sun, 01 Dec 2019 10:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S37k3A5OZNWm+ZDtfzp7gJIg2KrVYiwA7UdzCuB7Mf0=;
        b=icjDNAz/2tC1LZs9ngH+2rLCG/3klSZvUC70TOMEqtUP3Ko19tqkb0EFX9VDxw5J0O
         rDYjlOpbuPAfD46gpnOGYYUnCLkYSXGlYuqzofULGjCO9J/0+Ni82Ai24YKGfVplfAIL
         LNK1/3J+vQ9SbKjJ5/8dR6z0MkEKm9ZdIbnEt1boVisM3XvbuCZqMwQFdfotDMxHABtB
         V+4uhJaEHPiwBI3DtVonbchiHB+7nQlJw0a8micDHW1gExS/aAa1UeLUQmnO2fl05bXY
         YzdJ6HSujVjwdrwADzfTnpTe5QAjAXgrdJKVDbKnbTmAG3cGQtALTd7I078vWLtNPx+E
         S9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S37k3A5OZNWm+ZDtfzp7gJIg2KrVYiwA7UdzCuB7Mf0=;
        b=RS3O01Kg6lmmGWRQr0QA8D+fJzerMxLSR2mIhqS9nYJp8n4BNNt4GsErQGWXgrsQpz
         e/f8NSdrjxHLG0RA73dna+/9Hbx9ZbHOPuBTIBnchx6XiT6hP2Pgk+YaOtYGwo2VtTav
         9KETYPWQTNQGzHxZY4UHpbDgTmC1FOfmF87wFjSWQg8/ghy79d9nknfoK4jBUFsEklSO
         UPAwpXffUZm9dxb7scNo8N3jBiniVOYiAtIi7Mo03P+5L6JMKzv68LuSFT4pwB3e7SnL
         CXk2NzZ6YjohObvMPhRL/jWlgNk8TpHH4HR9wE7EELxAZkw1I1QduVwd3NQd3t7gTdAT
         7t+Q==
X-Gm-Message-State: APjAAAVIuGmabQAwz/Lxmh9NaDcs9gEu7ckxHqkK5I3GBi5ACiWkw2Es
        eOtCB0BfN0EEbNOR/tNziLMbkoA2Mlx3bLyea/U=
X-Google-Smtp-Source: APXvYqwASm5GQzrjtAhYGQ2BVcpjqma3GupvyAm4TuXkI2zcSQyrydk/FeB+Y5c4U8XpXAAvM1Y/KqaNJN8EnyjTgNk=
X-Received: by 2002:a92:d744:: with SMTP id e4mr24337951ilq.64.1575224720915;
 Sun, 01 Dec 2019 10:25:20 -0800 (PST)
MIME-Version: 1.0
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain> <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
 <CAKgT0Uf8iebEXSovdWfXq1FvyGpqrF-X0VDrq-h8xavQkvA_9w@mail.gmail.com> <20191201041731-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191201041731-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 1 Dec 2019 10:25:09 -0800
Message-ID: <CAKgT0UeCZJqEjyngQxtdFcaEP1Ei_X6ydNyE_4Jfr6cs=zKkiw@mail.gmail.com>
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

On Sun, Dec 1, 2019 at 3:46 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Nov 29, 2019 at 01:13:32PM -0800, Alexander Duyck wrote:
> > On Thu, Nov 28, 2019 at 7:26 AM David Hildenbrand <david@redhat.com> wrote:
> > >
> > > On 19.11.19 22:46, Alexander Duyck wrote:
> > > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > >
> > > > Add support for the page reporting feature provided by virtio-balloon.
> > > > Reporting differs from the regular balloon functionality in that is is
> > > > much less durable than a standard memory balloon. Instead of creating a
> > > > list of pages that cannot be accessed the pages are only inaccessible
> > > > while they are being indicated to the virtio interface. Once the
> > > > interface has acknowledged them they are placed back into their respective
> > > > free lists and are once again accessible by the guest system.
> > >
> > > Maybe add something like "In contrast to ordinary balloon
> > > inflation/deflation, the guest can reuse all reported pages immediately
> > > after reporting has finished, without having to notify the hypervisor
> > > about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."
> >
> > Okay. I'll make a note of it for next version.
>
>
> VIRTIO_BALLOON_F_MUST_TELL_HOST is IMHO misdocumented.
> It states:
>         VIRTIO_BALLOON_F_MUST_TELL_HOST (0) Host has to be told before pages from the balloon are
>         used.
> but really balloon always told host. The difference is in timing,
> historically balloon gave up pages before sending the
> message and before waiting for the buffer to be used by host.
>
> I think this feature can be the same if we want.

Okay. I'll still probably try to document the behavior a bit better though.

> > > [...]
> > >
> > > >  /*
> > > >   * Balloon device works in 4K page units.  So each page is pointed to by
> > > > @@ -37,6 +38,9 @@
> > > >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> > > >       (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> > > >
> > > > +/*  limit on the number of pages that can be on the reporting vq */
> > > > +#define VIRTIO_BALLOON_VRING_HINTS_MAX       16
> > >
> > > Maybe rename that from HINTS to REPORTS
> >
> > I'll fix it for the next version.
> >
> > > > +
> > > >  #ifdef CONFIG_BALLOON_COMPACTION
> > > >  static struct vfsmount *balloon_mnt;
> > > >  #endif
> > > > @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
> > > >       VIRTIO_BALLOON_VQ_DEFLATE,
> > > >       VIRTIO_BALLOON_VQ_STATS,
> > > >       VIRTIO_BALLOON_VQ_FREE_PAGE,
> > > > +     VIRTIO_BALLOON_VQ_REPORTING,
> > > >       VIRTIO_BALLOON_VQ_MAX
> > > >  };
> > > >
> > > > @@ -113,6 +118,10 @@ struct virtio_balloon {
> > > >
> > > >       /* To register a shrinker to shrink memory upon memory pressure */
> > > >       struct shrinker shrinker;
> > > > +
> > > > +     /* Unused page reporting device */
> > >
> > > Sounds like the device is unused :D
> > >
> > > "Device info for reporting unused pages" ?
> > >
> > > I am in general wondering, should we rename "unused" to "free". I.e.,
> > > "free page reporting" instead of "unused page reporting"? Or what was
> > > the motivation behind using "unused" ?
> >
> > I honestly don't remember why I chose "unused" at this point. I can
> > switch over to "free" if that is what is preferred.
> >
> > Looking over the code a bit more I suspect the reason for avoiding it
> > is because free page hinting also mentioned reporting in a few spots.
> >
> > > > +     struct virtqueue *reporting_vq;
> > > > +     struct page_reporting_dev_info pr_dev_info;
> > > >  };
> > > >
> > > >  static struct virtio_device_id id_table[] = {
> > > > @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> > > >
> > > >  }
> > > >
> > > > +void virtballoon_unused_page_report(struct page_reporting_dev_info *pr_dev_info,
> > > > +                                 unsigned int nents)
> > > > +{
> > > > +     struct virtio_balloon *vb =
> > > > +             container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> > > > +     struct virtqueue *vq = vb->reporting_vq;
> > > > +     unsigned int unused, err;
> > > > +
> > > > +     /* We should always be able to add these buffers to an empty queue. */
> > >
> > > This comment somewhat contradicts the error handling (and comment)
> > > below. Maybe just drop it?
> > >
> > > > +     err = virtqueue_add_inbuf(vq, pr_dev_info->sg, nents, vb,
> > > > +                               GFP_NOWAIT | __GFP_NOWARN);
> > > > +
> > > > +     /*
> > > > +      * In the extremely unlikely case that something has changed and we
> > > > +      * are able to trigger an error we will simply display a warning
> > > > +      * and exit without actually processing the pages.
> > > > +      */
> > > > +     if (WARN_ON(err))
> > > > +             return;
> > >
> > > Maybe WARN_ON_ONCE? (to not flood the log on recurring errors)
> >
> > Actually I might need to tweak things here a bit. It occurs to me that
> > this can fail for more than just there not being space in the ring. I
> > forgot that DMA mapping needs to also occur so in the case of a DMA
> > mapping failure we would also see an error.
>
> Balloon assumes DMA mapping is bypassed right now:
>
> static int virtballoon_validate(struct virtio_device *vdev)
> {
>         if (!page_poisoning_enabled())
>                 __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
>
>         __virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
>
> ^^^^^^^^
>
>
>         return 0;
> }
>
> I don't think it can work with things like a bounce buffer.

Right. It wouldn't work with a bounce buffer. I was thinking more of
something like an IOMMU. So it sounds like the device is doing direct
map always anyway.

In any case I will add some logic so that if we encounter an error we
will just abort the reporting. That way if another user has some issue
like that it can be dealt with sooner and we can avoid flagging pages
as reported that are not.

- Alex
