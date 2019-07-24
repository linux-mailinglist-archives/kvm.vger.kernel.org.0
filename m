Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F5174042
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 22:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfGXUmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 16:42:39 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34398 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfGXUmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 16:42:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so46968717qtq.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 13:42:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0oDsp6PabiGgGzFV5AXKWcbAmWPliOqgciTu5AmtKko=;
        b=tDaiKmaTNNPBGlsrpJQ/s5SVEh+h+3rN6tiAhNKPgydCuSnXThnn3Qo/9uQDhKeiLO
         8NMw/BD1xOpg0IbI1FK/2ar60TsolcJco21X3qSJKp8ga1PIZCRxq3VswkDb62WlIQkG
         k5al7a5q5vpQrlugsX3lzUVP6P2hpSdbtxuvdApEaT3uNAVFUfpUi97/qmIiSZDYRWRr
         iPGj0KlctfaOA4FB8jdEVdbNtGaSSvB7iePAlBSdAhHBxqq97GS5Xph0CId84tq+aKzl
         LwoCy/6pAaoLzzqwlyK0GfgQmhr/7niKsP5lMyDWkQ4owoeI3HQlXHNJiOzjx1BCIxxA
         NdeA==
X-Gm-Message-State: APjAAAWizQ3ydxpcOXUg1BK+dbhdR8KsFZjtAGA5virLrTZsjnMqXJ3i
        Ua9/3+gOc/WrXY5573tswOT2pg==
X-Google-Smtp-Source: APXvYqy1xyF8m0D0XrDjgh1Az86AClKVYNEKuVVVwKydA8wHTr4Opr/E4uUxsrcRi8Vs/vksPRXBLQ==
X-Received: by 2002:ac8:5315:: with SMTP id t21mr59263152qtn.229.1564000957709;
        Wed, 24 Jul 2019 13:42:37 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id r14sm22913246qke.47.2019.07.24.13.42.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 13:42:36 -0700 (PDT)
Date:   Wed, 24 Jul 2019 16:42:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
Message-ID: <20190724164023-mutt-send-email-mst@kernel.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724171050.7888.62199.stgit@localhost.localdomain>
 <20190724150224-mutt-send-email-mst@kernel.org>
 <6218af96d7d55935f2cf607d47680edc9b90816e.camel@linux.intel.com>
 <ee5387b1-89af-daf4-8492-8139216c6dcf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee5387b1-89af-daf4-8492-8139216c6dcf@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 04:29:27PM -0400, Nitesh Narayan Lal wrote:
> 
> On 7/24/19 4:18 PM, Alexander Duyck wrote:
> > On Wed, 2019-07-24 at 15:02 -0400, Michael S. Tsirkin wrote:
> >> On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> >>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >>>
> >>> Add support for what I am referring to as "bubble hinting". Basically the
> >>> idea is to function very similar to how the balloon works in that we
> >>> basically end up madvising the page as not being used. However we don't
> >>> really need to bother with any deflate type logic since the page will be
> >>> faulted back into the guest when it is read or written to.
> >>>
> >>> This is meant to be a simplification of the existing balloon interface
> >>> to use for providing hints to what memory needs to be freed. I am assuming
> >>> this is safe to do as the deflate logic does not actually appear to do very
> >>> much other than tracking what subpages have been released and which ones
> >>> haven't.
> >>>
> >>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >>> ---
> >>>  hw/virtio/virtio-balloon.c                      |   40 +++++++++++++++++++++++
> >>>  include/hw/virtio/virtio-balloon.h              |    2 +
> >>>  include/standard-headers/linux/virtio_balloon.h |    1 +
> >>>  3 files changed, 42 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> >>> index 2112874055fb..70c0004c0f88 100644
> >>> --- a/hw/virtio/virtio-balloon.c
> >>> +++ b/hw/virtio/virtio-balloon.c
> >>> @@ -328,6 +328,39 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
> >>>      balloon_stats_change_timer(s, 0);
> >>>  }
> >>>  
> >>> +static void virtio_bubble_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> >>> +{
> >>> +    VirtQueueElement *elem;
> >>> +
> >>> +    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
> >>> +    	unsigned int i;
> >>> +
> >>> +        for (i = 0; i < elem->in_num; i++) {
> >>> +            void *addr = elem->in_sg[i].iov_base;
> >>> +            size_t size = elem->in_sg[i].iov_len;
> >>> +            ram_addr_t ram_offset;
> >>> +            size_t rb_page_size;
> >>> +            RAMBlock *rb;
> >>> +
> >>> +            if (qemu_balloon_is_inhibited())
> >>> +                continue;
> >>> +
> >>> +            rb = qemu_ram_block_from_host(addr, false, &ram_offset);
> >>> +            rb_page_size = qemu_ram_pagesize(rb);
> >>> +
> >>> +            /* For now we will simply ignore unaligned memory regions */
> >>> +            if ((ram_offset | size) & (rb_page_size - 1))
> >>> +                continue;
> >>> +
> >>> +            ram_block_discard_range(rb, ram_offset, size);
> >> I suspect this needs to do like the migration type of
> >> hinting and get disabled if page poisoning is in effect.
> >> Right?
> > Shouldn't something like that end up getting handled via
> > qemu_balloon_is_inhibited, or did I miss something there? I assumed cases
> > like that would end up setting qemu_balloon_is_inhibited to true, if that
> > isn't the case then I could add some additional conditions. I would do it
> > in about the same spot as the qemu_balloon_is_inhibited check.
> I don't think qemu_balloon_is_inhibited() will take care of the page poisoning
> situations.
> If I am not wrong we may have to look to extend VIRTIO_BALLOON_F_PAGE_POISON
> support as per Michael's suggestion.


BTW upstream qemu seems to ignore VIRTIO_BALLOON_F_PAGE_POISON ATM.
Which is probably a bug.
Wei, could you take a look pls?

> >
> >
> -- 
> Thanks
> Nitesh
