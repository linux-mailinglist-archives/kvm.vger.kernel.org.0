Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F19E73734
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfGXTDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 15:03:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46759 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfGXTDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 15:03:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so46529340qtn.13
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 12:03:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p/O/eoxQhBRc771PITXPNeSklEhzUdVEBJF9ZJTsHJ8=;
        b=Sblx5F7kqhI/P4p9njowXy+8EfzDT1zx/iBbDMxouZhZeuL0+BwicFjvWJgnQmyVO6
         161UX1JLpbV5W2Xw5NdNFnCV2E++IthmUuU1PbHxBL0f2PoIHVTQ0wY4ZmFlQjPE/a3E
         +XzBw5UXkIegqC8h3USNXXxWX6SqoHdGCvkckq+eXqQ6jgm1TkH1UmQvlbdAmcoGP8wB
         USJd0W0qZHlxhoIcbVMDmHHDGOHAb69zsx/Czck0Kv3TeCnpNzdfWzLkwAi2N4y/GN8C
         Ue9JETdJCUl6r3iYBfoVd0QdP1+Z8jplOMTPPyMFpEpItXfADKUJcObBCNVa4iMBHpeN
         P15A==
X-Gm-Message-State: APjAAAWXoA5AgAP9ODB4XaF7JZl7UhHZBTi9IILXlpWIlZvsiFYXJpyH
        GkHRTNXkIq9HxNEaJmv5KH/3ZA==
X-Google-Smtp-Source: APXvYqxLYZw8rlw3oqXg+jJiwN6HmesmFY8Q4kNnFppIrK1HvwN2j54BYbLPwLmiMExxvUpkuvzfMw==
X-Received: by 2002:ac8:1ba9:: with SMTP id z38mr59884346qtj.176.1563994984575;
        Wed, 24 Jul 2019 12:03:04 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id v1sm21056496qkj.19.2019.07.24.12.02.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 12:03:03 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:02:56 -0400
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
Message-ID: <20190724150224-mutt-send-email-mst@kernel.org>
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

I suspect this needs to do like the migration type of
hinting and get disabled if page poisoning is in effect.
Right?

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
