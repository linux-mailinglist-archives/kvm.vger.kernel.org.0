Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56C67919C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 18:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbfG2Q6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 12:58:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46446 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387717AbfG2Q6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 12:58:17 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so8227930iol.13;
        Mon, 29 Jul 2019 09:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMJX6exOwqjooLEn9qtJXN6JS2y5xnQ/2H7xPTrhJ28=;
        b=qmwBJoRInh23civEWJdNICjdMLoR9BUo4NN/Jr86tkcVeVrkU8KIGkSHwi5irmcRPP
         //4n9GJj5Y4+FnXDmYBTTPKxGApkHqgo65J6IGPXJlcCq78kIwGwAwelULdRAmOMY0wj
         2jocJCfs/d9EId682irXl8YPuCk5umHMvx2eMUnRwkfBu/fBd6mQy3KuQt0NxpkLbO9W
         YOVEhLnvLQfQO0RnpPtADN/mblkeyeUlPNcWyZOlmbzLjSafTngOlIL+SV4V+pIbh3EV
         3SwJBZ+dMeUWV+Bvl+whJ+X+UegiEFARHumJQ/VGnj75FFt4AgYcDgpK34RtNtgdtb9r
         fSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMJX6exOwqjooLEn9qtJXN6JS2y5xnQ/2H7xPTrhJ28=;
        b=BQkvtzn5MbhmFKj05FUQd/wf1YqO1YSliof2eTwfmQUN+5sxyVsKy81UvIybS4rYKy
         i5m0R7Wfsjl8BmyhLgabUgduherQRMtRkaENR+RRY/IvBkfdZDPmxOB8xWhcSStFa4p2
         wkG7vMEunYhY9C7h7KvrLlz2p0y/hi9ZS85pXa3XlQX66xhSLjnbsiHB78TXw0/B3gnt
         74VcK6M90VbHVds/H/dtRB+yJV+QsoOaNNU8CzRCJvopmfhQBhaqJof7j4BGvW8YMkvw
         mNIyweMAXTtktLMwoWrDksQqGVWz9ntG8OmponcSqdhrlyNib0NO1bSMUeeeQZD46zCq
         S+SA==
X-Gm-Message-State: APjAAAXzwtTnsHRtDg+Rvlffnl9uq7cMZT+9zsk3mp5wnXxWb5U0XJ3o
        i7Jh501gWSGEEpCe3YGVSsUCF2ba6mdWWA3QIUo=
X-Google-Smtp-Source: APXvYqztFG7YMJz0zsHEI3iKX0c4uGDWIt8CrgE8B+fv9wr+8aZKn7VtfZzuBhrEkz5ALTKWzWmFtnQpnC24Mw8lh00=
X-Received: by 2002:a5d:9dc7:: with SMTP id 7mr48452689ioo.237.1564419495894;
 Mon, 29 Jul 2019 09:58:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724171050.7888.62199.stgit@localhost.localdomain> <20190724150224-mutt-send-email-mst@kernel.org>
 <6218af96d7d55935f2cf607d47680edc9b90816e.camel@linux.intel.com>
 <ee5387b1-89af-daf4-8492-8139216c6dcf@redhat.com> <20190724164023-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190724164023-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 29 Jul 2019 09:58:04 -0700
Message-ID: <CAKgT0Ud6jPpsvJWFAMSnQXAXeNZb116kR7D2Xb7U-7BOtctK_Q@mail.gmail.com>
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble hinting"
To:     "Michael S. Tsirkin" <mst@redhat.com>, wei.w.wang@intel.com
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 1:42 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 24, 2019 at 04:29:27PM -0400, Nitesh Narayan Lal wrote:
> >
> > On 7/24/19 4:18 PM, Alexander Duyck wrote:
> > > On Wed, 2019-07-24 at 15:02 -0400, Michael S. Tsirkin wrote:
> > >> On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> > >>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >>>
> > >>> Add support for what I am referring to as "bubble hinting". Basically the
> > >>> idea is to function very similar to how the balloon works in that we
> > >>> basically end up madvising the page as not being used. However we don't
> > >>> really need to bother with any deflate type logic since the page will be
> > >>> faulted back into the guest when it is read or written to.
> > >>>
> > >>> This is meant to be a simplification of the existing balloon interface
> > >>> to use for providing hints to what memory needs to be freed. I am assuming
> > >>> this is safe to do as the deflate logic does not actually appear to do very
> > >>> much other than tracking what subpages have been released and which ones
> > >>> haven't.
> > >>>
> > >>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >>> ---
> > >>>  hw/virtio/virtio-balloon.c                      |   40 +++++++++++++++++++++++
> > >>>  include/hw/virtio/virtio-balloon.h              |    2 +
> > >>>  include/standard-headers/linux/virtio_balloon.h |    1 +
> > >>>  3 files changed, 42 insertions(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> > >>> index 2112874055fb..70c0004c0f88 100644
> > >>> --- a/hw/virtio/virtio-balloon.c
> > >>> +++ b/hw/virtio/virtio-balloon.c
> > >>> @@ -328,6 +328,39 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
> > >>>      balloon_stats_change_timer(s, 0);
> > >>>  }
> > >>>
> > >>> +static void virtio_bubble_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> > >>> +{
> > >>> +    VirtQueueElement *elem;
> > >>> +
> > >>> +    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
> > >>> +         unsigned int i;
> > >>> +
> > >>> +        for (i = 0; i < elem->in_num; i++) {
> > >>> +            void *addr = elem->in_sg[i].iov_base;
> > >>> +            size_t size = elem->in_sg[i].iov_len;
> > >>> +            ram_addr_t ram_offset;
> > >>> +            size_t rb_page_size;
> > >>> +            RAMBlock *rb;
> > >>> +
> > >>> +            if (qemu_balloon_is_inhibited())
> > >>> +                continue;
> > >>> +
> > >>> +            rb = qemu_ram_block_from_host(addr, false, &ram_offset);
> > >>> +            rb_page_size = qemu_ram_pagesize(rb);
> > >>> +
> > >>> +            /* For now we will simply ignore unaligned memory regions */
> > >>> +            if ((ram_offset | size) & (rb_page_size - 1))
> > >>> +                continue;
> > >>> +
> > >>> +            ram_block_discard_range(rb, ram_offset, size);
> > >> I suspect this needs to do like the migration type of
> > >> hinting and get disabled if page poisoning is in effect.
> > >> Right?
> > > Shouldn't something like that end up getting handled via
> > > qemu_balloon_is_inhibited, or did I miss something there? I assumed cases
> > > like that would end up setting qemu_balloon_is_inhibited to true, if that
> > > isn't the case then I could add some additional conditions. I would do it
> > > in about the same spot as the qemu_balloon_is_inhibited check.
> > I don't think qemu_balloon_is_inhibited() will take care of the page poisoning
> > situations.
> > If I am not wrong we may have to look to extend VIRTIO_BALLOON_F_PAGE_POISON
> > support as per Michael's suggestion.
>
>
> BTW upstream qemu seems to ignore VIRTIO_BALLOON_F_PAGE_POISON ATM.
> Which is probably a bug.
> Wei, could you take a look pls?

So I was looking at sorting out this for the unused page reporting
that I am working on and it occurred to me that I don't think we can
do the free page hinting if any sort of poison validation is present.
The problem is that free page hinting simply stops the page from being
migrated. As a result if there was stale data present it will just
leave it there instead of zeroing it or writing it to alternating 1s
and 0s.

Also it looks like the VIRTIO_BALLOON_F_PAGE_POISON feature is
assuming that 0 means that page poisoning is disabled, when in reality
it might just mean we are using the value zero to poison pages instead
of the 0xaa pattern. As such I think there are several cases where we
could incorrectly flag the pages with the hint and result in the
migrated guest reporting pages that contain non-poison values.

The zero assumption works for unused page reporting since we will be
zeroing out the page when it is faulted back into the guest, however
the same doesn't work for the free page hint since it is simply
skipping the migration of the recently dirtied page.
