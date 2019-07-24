Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06E5740F0
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfGXVjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 17:39:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46830 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbfGXVjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 17:39:07 -0400
Received: by mail-qk1-f193.google.com with SMTP id r4so34845417qkm.13
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 14:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=28a4qMc4GebGixyPVlXegsBCWlKTvaQ82BrqmXv24hI=;
        b=L/It2dkg0Rhl8fNw2F0ITtYc5v4YxDfu7YJNjsukkhHi/8+8DJTUBMjMzDQJuJD9eq
         gVfmJ2BifPJMM2DInBzWpmXqwxmMpqSMFtRhLr3D5SnSMvFeBxG+yo51vYmt9JUc8oXI
         acKOgN9ToM1I7ONB19KKgenDb8ZxjGW2TptfEE5oibaa8Dno+Zs34cIYcIga323PijgL
         2uxIEql5ZUkqqNu6AyWS5wQW2b1KC/qpt1xnL7Xy5x01WgRhQfJ+kf/DKLbactPxvBL4
         vKq8Z9xK3CHux6yQw4xOzmuGk7nFHkzotYudfMeB3AsMLH4J4lA8SrEJA//gIgWp7czy
         e9YA==
X-Gm-Message-State: APjAAAVVP1rJNQIIPu3z1RLXO+eaCS7oJlTmtm1KOs53lUh0Rk8Ev2IM
        0OK/VVoOFIgfkrMnUG8vN9jbLw==
X-Google-Smtp-Source: APXvYqx5Vviay06G4wTpmKw6r6Rmn4S1f6AcbU39ZWHwDn0ZM/RIONGYIejuWx0pfdZo4Js4cYM76A==
X-Received: by 2002:a37:6944:: with SMTP id e65mr51570295qkc.119.1564004345710;
        Wed, 24 Jul 2019 14:39:05 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id g2sm21591961qti.68.2019.07.24.14.39.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 14:39:04 -0700 (PDT)
Date:   Wed, 24 Jul 2019 17:38:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v2 QEMU] virtio-balloon: Provide a interface for "bubble
 hinting"
Message-ID: <20190724173403-mutt-send-email-mst@kernel.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724171050.7888.62199.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724171050.7888.62199.stgit@localhost.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 10:12:10AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Add support for what I am referring to as "bubble hinting". Basically the
> idea is to function very similar to how the balloon works in that we
> basically end up madvising the page as not being used. However we don't
> really need to bother with any deflate type logic since the page will be
> faulted back into the guest when it is read or written to.
> 
> This is meant to be a simplification of the existing balloon interface
> to use for providing hints to what memory needs to be freed. I am assuming
> this is safe to do as the deflate logic does not actually appear to do very
> much other than tracking what subpages have been released and which ones
> haven't.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

BTW I wonder about migration here.  When we migrate we lose all hints
right?  Well destination could be smarter, detect that page is full of
0s and just map a zero page. Then we don't need a hint as such - but I
don't think it's done like that ATM.


I also wonder about interaction with deflate.  ATM deflate will add
pages to the free list, then balloon will come right back and report
them as free.


> ---
>  hw/virtio/virtio-balloon.c                      |   40 +++++++++++++++++++++++
>  include/hw/virtio/virtio-balloon.h              |    2 +
>  include/standard-headers/linux/virtio_balloon.h |    1 +
>  3 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> index 2112874055fb..70c0004c0f88 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -328,6 +328,39 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
>      balloon_stats_change_timer(s, 0);
>  }
>  
> +static void virtio_bubble_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    VirtQueueElement *elem;
> +
> +    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
> +    	unsigned int i;
> +
> +        for (i = 0; i < elem->in_num; i++) {
> +            void *addr = elem->in_sg[i].iov_base;
> +            size_t size = elem->in_sg[i].iov_len;
> +            ram_addr_t ram_offset;
> +            size_t rb_page_size;
> +            RAMBlock *rb;
> +
> +            if (qemu_balloon_is_inhibited())
> +                continue;
> +
> +            rb = qemu_ram_block_from_host(addr, false, &ram_offset);
> +            rb_page_size = qemu_ram_pagesize(rb);
> +
> +            /* For now we will simply ignore unaligned memory regions */
> +            if ((ram_offset | size) & (rb_page_size - 1))
> +                continue;
> +
> +            ram_block_discard_range(rb, ram_offset, size);
> +        }
> +
> +        virtqueue_push(vq, elem, 0);
> +        virtio_notify(vdev, vq);
> +        g_free(elem);
> +    }
> +}
> +
>  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>  {
>      VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
> @@ -782,6 +815,11 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
>      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
>  
>      if (virtio_has_feature(s->host_features,
> +                           VIRTIO_BALLOON_F_HINTING)) {
> +        s->hvq = virtio_add_queue(vdev, 128, virtio_bubble_handle_output);
> +    }
> +
> +    if (virtio_has_feature(s->host_features,
>                             VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
>          s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
>                                             virtio_balloon_handle_free_page_vq);
> @@ -897,6 +935,8 @@ static Property virtio_balloon_properties[] = {
>                      VIRTIO_BALLOON_F_DEFLATE_ON_OOM, false),
>      DEFINE_PROP_BIT("free-page-hint", VirtIOBalloon, host_features,
>                      VIRTIO_BALLOON_F_FREE_PAGE_HINT, false),
> +    DEFINE_PROP_BIT("guest-page-hinting", VirtIOBalloon, host_features,
> +                    VIRTIO_BALLOON_F_HINTING, true),
>      DEFINE_PROP_LINK("iothread", VirtIOBalloon, iothread, TYPE_IOTHREAD,
>                       IOThread *),
>      DEFINE_PROP_END_OF_LIST(),
> diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
> index 1afafb12f6bc..a58b24fdf29d 100644
> --- a/include/hw/virtio/virtio-balloon.h
> +++ b/include/hw/virtio/virtio-balloon.h
> @@ -44,7 +44,7 @@ enum virtio_balloon_free_page_report_status {
>  
>  typedef struct VirtIOBalloon {
>      VirtIODevice parent_obj;
> -    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
> +    VirtQueue *ivq, *dvq, *svq, *free_page_vq, *hvq;
>      uint32_t free_page_report_status;
>      uint32_t num_pages;
>      uint32_t actual;
> diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
> index 9375ca2a70de..f9e3e8256261 100644
> --- a/include/standard-headers/linux/virtio_balloon.h
> +++ b/include/standard-headers/linux/virtio_balloon.h
> @@ -36,6 +36,7 @@
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
> +#define VIRTIO_BALLOON_F_HINTING	5 /* Page hinting virtqueue */
>  
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
