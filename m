Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82498A21B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 17:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfHLPTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 11:19:04 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43628 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfHLPTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 11:19:04 -0400
Received: by mail-ot1-f65.google.com with SMTP id e12so15846890otp.10;
        Mon, 12 Aug 2019 08:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g61UWX1fk8nOjgoG5gZ42LwxR/PoBHmYKeb7M1oSMlU=;
        b=Dj0y3Gbz+HzorEQLnZ8bag7EZHZpsiF+HrWRA2zvhJXLrllUnKYhmr8PlbAC2W6WqA
         boPOsG8b1w8cwUSyNQQTzh1VI/79rscI1R7EpIm0MraDHmGtLdif4TBa20FYcGqu9D7z
         ry1UpJluYg6Z84ewqK3CZ4glmBdwxmgBqbtPp9xc+jMv4QfueJzeI8Zr9clvPRZVIkVD
         V4nn6qDJmxkkGDu6DbwSWET0zF1i2ljW35L6A1snPP9BhnUI105N9lCYMK67XhpKeuIz
         8E/2eDsyERtkhIMu5MYjjoia5+KIBPP11YWegrDM2fsenbtb1d5sCJkGZDg2Vi5FYC14
         6O1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g61UWX1fk8nOjgoG5gZ42LwxR/PoBHmYKeb7M1oSMlU=;
        b=OEo6PLFKfxNNzR5f8Q9cPPHmKCaxz2EDjbXMAQWORPSxVGC3TF717t1GbTTjoMuyrw
         vjNaiCi/cU4LlMMR9MZ7lfx9pDhCa0q2LASls4Dx3WwRN0SVIsnEJAYX4uoPwiXDpg75
         7fron6N12v8t4EgJnKVqEa5cVwm0/S7bjmVR7jwR7oCkPA1RmkWaBM45N0PWRlOU9Zys
         In3AT0lOnACL5d75asvOPLNzPehq7N+8mA4gedDzSZxFJsdevGWTR37H62HmcMOr2UUq
         LerjbsQ2Qj9r+oMz9IfjiL9+PoB7JiZUJhSVz3Me0usDZQUAGvbFwN+fHR5NDu+iGbTd
         s72A==
X-Gm-Message-State: APjAAAUQVQh1Oj4BzH/z+3PqkygoMXUVn2fZko07pnljKICJRPkkJpp2
        oGGZPdHIhOwI4xFJNq6axfNCI3q/3iPx7tONQok=
X-Google-Smtp-Source: APXvYqy67a3lTSjf7Vx2s1uiVtCzZ0/KxkgABAzojCEpEbXpH78z314N2AUzoDA5i2GXWUhxi/1pMLbS2hj7YG4ncrk=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr33482356ioj.64.1565623142785;
 Mon, 12 Aug 2019 08:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190812131235.27244-1-nitesh@redhat.com> <20190812131357.27312-1-nitesh@redhat.com>
 <20190812131357.27312-2-nitesh@redhat.com>
In-Reply-To: <20190812131357.27312-2-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 12 Aug 2019 08:18:51 -0700
Message-ID: <CAKgT0Uc8kGwX8VwU2b51qVuh2z5eZQ6XhSnYMryTVa_pKHCvew@mail.gmail.com>
Subject: Re: [QEMU Patch 2/2] virtio-balloon: support for handling page reporting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>, cohuck@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 6:14 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> Page reporting is a feature which enables the virtual machine to report
> chunk of free pages to the hypervisor.
> This patch enables QEMU to process these reports from the VM and discard the
> unused memory range.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  hw/virtio/virtio-balloon.c         | 41 ++++++++++++++++++++++++++++++
>  include/hw/virtio/virtio-balloon.h |  2 +-
>  2 files changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> index 25de154307..1132e47ee0 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -320,6 +320,39 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
>      balloon_stats_change_timer(s, 0);
>  }
>
> +static void virtio_balloon_handle_reporting(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    VirtQueueElement *elem;
> +
> +    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
> +        unsigned int i;
> +
> +        for (i = 0; i < elem->in_num; i++) {
> +            void *gaddr = elem->in_sg[i].iov_base;
> +            size_t size = elem->in_sg[i].iov_len;
> +            ram_addr_t ram_offset;
> +            size_t rb_page_size;
> +           RAMBlock *rb;
> +
> +            if (qemu_balloon_is_inhibited())
> +                continue;
> +
> +            rb = qemu_ram_block_from_host(gaddr, false, &ram_offset);
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

No offense, but I am a bit annoyed. If you are going to copy my code
you should at least keep up with the fixes. You are missing all of the
stuff to handle the poison value. If you are going to just duplicate
my setup you might as well have just pulled the QEMU patches from the
last submission I did. Then this would have at least has the fix for
the page poisoning. Also it wouldn't hurt to mention that you are
basing it off of the patch set I submitted since it hasn't been
accepted yet.

>  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>  {
>      VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
> @@ -792,6 +825,12 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
>      s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
>
> +    if (virtio_has_feature(s->host_features,
> +                           VIRTIO_BALLOON_F_REPORTING)) {
> +        s->reporting_vq = virtio_add_queue(vdev, 16,
> +                                          virtio_balloon_handle_reporting);
> +    }
> +
>      if (virtio_has_feature(s->host_features,
>                             VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
>          s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
> @@ -912,6 +951,8 @@ static Property virtio_balloon_properties[] = {
>       * is disabled, resulting in QEMU 3.1 migration incompatibility.  This
>       * property retains this quirk for QEMU 4.1 machine types.
>       */
> +    DEFINE_PROP_BIT("free-page-reporting", VirtIOBalloon, host_features,
> +                    VIRTIO_BALLOON_F_REPORTING, true),
>      DEFINE_PROP_BOOL("qemu-4-0-config-size", VirtIOBalloon,
>                       qemu_4_0_config_size, false),
>      DEFINE_PROP_LINK("iothread", VirtIOBalloon, iothread, TYPE_IOTHREAD,
> diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
> index d1c968d237..15a05e6435 100644
> --- a/include/hw/virtio/virtio-balloon.h
> +++ b/include/hw/virtio/virtio-balloon.h
> @@ -42,7 +42,7 @@ enum virtio_balloon_free_page_report_status {
>
>  typedef struct VirtIOBalloon {
>      VirtIODevice parent_obj;
> -    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
> +    VirtQueue *ivq, *dvq, *svq, *free_page_vq, *reporting_vq;
>      uint32_t free_page_report_status;
>      uint32_t num_pages;
>      uint32_t actual;
> --
> 2.21.0
>q
