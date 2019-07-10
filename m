Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CBD64D66
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfGJURn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:17:43 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40621 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJURn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:17:43 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so7531326iom.7;
        Wed, 10 Jul 2019 13:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7d8N94prlC005qJxNuBMxAhqvvB2PcIZbyAYedxINpc=;
        b=A660zAOx1NcqwGPXU0S81OSe0LH1JfXzi0EstPzpOIEFFgR+eLRGX2GV+P/H7nWi0r
         BnNduUauMeGtsKhXs4EFZi4pfr67EVEdgZfymWsFVzsijwY9RpH4iJ8Im0HjnMB/Zs/Z
         zkBtWj7lhrNVWhWchQvut8RpbLs/IgWFTTBnjKEKUXfzsENkVwfvRIjSg88h37pkdUgw
         VdSZtx2WbkCsyL1sd1yIDiFWCvmB0mSZv3xkWHTS/re9UPK+eAtjEEn1fajIsykmwBhg
         s4YRhZgcssrG0TT7/2uKtOMukEmSbT0mBVfDsYFLX6Dp9oMQkEJy8xZTsn0akGFSK7pj
         mlew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7d8N94prlC005qJxNuBMxAhqvvB2PcIZbyAYedxINpc=;
        b=Xvb+2Hcok9xDPT8TueVKQWhBBU7JUeVx3ksbVCSQlc0VGa4Vzr+Q0F+d2KZHV8UpZY
         4nM+IaULplDEGNrtvq0Kw4xPhuGtbWrrOsXjn3lsVWbdCSnyCZ7lKK1R4S4LBt/Ufv2s
         izKN7mi19NkpwTLLRMDEjXCMwvWAYDKeL7dXSBcERAM1ukK18ElfRWclcVMk1D2DhJVY
         BvL/BydlQDnDOwnDzT/90Th2UyGl+x1cGP+Duci9KGKC67k0+gn4AikE3tytF+Jbhxlq
         FY2LkqalNzJAZZ42B16OZFy1qW7AqxXEt16WhJ6TJInm9oZbCdZWTJmq2M3+KzN8HBb+
         hOzQ==
X-Gm-Message-State: APjAAAXstcAdq0rU92BE0HmKflpHkROiRr/tKx1vJno8xNpS8s7ahWgQ
        9S8+RdoJ/9w2EVtsk1Qvhzj5fwZG7Hwjj6K0Gt0=
X-Google-Smtp-Source: APXvYqwmmTBevzVupkiRrsSdz1DE9dPgAh7hKhQXppie+SyarCAW+GHeXzLwnVpziw7G9r3c6OAF/BUW1Q0OD7AyqNI=
X-Received: by 2002:a6b:901:: with SMTP id t1mr8862556ioi.42.1562789862231;
 Wed, 10 Jul 2019 13:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190710195158.19640-1-nitesh@redhat.com> <20190710195303.19690-1-nitesh@redhat.com>
In-Reply-To: <20190710195303.19690-1-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Jul 2019 13:17:30 -0700
Message-ID: <CAKgT0UchTgZPzhSRSnEb5PLpUqdR58Tv-5wxTf57v7ORB0jzaA@mail.gmail.com>
Subject: Re: [QEMU Patch] virtio-baloon: Support for page hinting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 12:53 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> Enables QEMU to perform madvise free on the memory range reported
> by the vm.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  hw/virtio/trace-events                        |  1 +
>  hw/virtio/virtio-balloon.c                    | 59 +++++++++++++++++++
>  include/hw/virtio/virtio-balloon.h            |  2 +-
>  include/qemu/osdep.h                          |  7 +++
>  .../standard-headers/linux/virtio_balloon.h   |  1 +
>  5 files changed, 69 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> index e28ba48da6..f703a22d36 100644
> --- a/hw/virtio/trace-events
> +++ b/hw/virtio/trace-events
> @@ -46,6 +46,7 @@ virtio_balloon_handle_output(const char *name, uint64_t gpa) "section name: %s g
>  virtio_balloon_get_config(uint32_t num_pages, uint32_t actual) "num_pages: %d actual: %d"
>  virtio_balloon_set_config(uint32_t actual, uint32_t oldactual) "actual: %d oldactual: %d"
>  virtio_balloon_to_target(uint64_t target, uint32_t num_pages) "balloon target: 0x%"PRIx64" num_pages: %d"
> +virtio_balloon_hinting_request(unsigned long pfn, unsigned int num_pages) "Guest page hinting request PFN:%lu size: %d"
>
>  # virtio-mmio.c
>  virtio_mmio_read(uint64_t offset) "virtio_mmio_read offset 0x%" PRIx64
> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> index 2112874055..5d186707b5 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -34,6 +34,9 @@
>
>  #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
>
> +#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES  16
> +void free_mem_range(uint64_t addr, uint64_t len);
> +

The definition you have here is unused. I think you can drop it. Also
why do you need this forward declaration? Couldn't you just leave
free_mem_range below as a static and still have this compile?

>  struct PartiallyBalloonedPage {
>      RAMBlock *rb;
>      ram_addr_t base;
> @@ -328,6 +331,58 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
>      balloon_stats_change_timer(s, 0);
>  }
>
> +void free_mem_range(uint64_t addr, uint64_t len)
> +{
> +    int ret = 0;
> +    void *hvaddr_to_free;
> +    MemoryRegionSection mrs = memory_region_find(get_system_memory(),
> +                                                 addr, 1);
> +    if (!mrs.mr) {
> +       warn_report("%s:No memory is mapped at address 0x%lu", __func__, addr);
> +        return;
> +    }
> +
> +    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.mr)) {
> +       warn_report("%s:Memory at address 0x%s is not RAM:0x%lu", __func__,
> +                   HWADDR_PRIx, addr);
> +        memory_region_unref(mrs.mr);
> +        return;
> +    }
> +
> +    hvaddr_to_free = qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_region);
> +    trace_virtio_balloon_hinting_request(addr, len);
> +    ret = qemu_madvise(hvaddr_to_free,len, QEMU_MADV_FREE);
> +    if (ret == -1) {
> +       warn_report("%s: Madvise failed with error:%d", __func__, ret);
> +    }
> +}
> +
> +static void virtio_balloon_handle_page_hinting(VirtIODevice *vdev,
> +                                              VirtQueue *vq)
> +{
> +    VirtQueueElement *elem;
> +    size_t offset = 0;
> +    uint64_t gpa, len;
> +    elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
> +    if (!elem) {
> +        return;
> +    }
> +    /* For pending hints which are < max_pages(16), 'gpa != 0' ensures that we
> +     * only read the buffer which holds a valid PFN value.
> +     * TODO: Find a better way to do this.
> +     */

I'm not sure this comment makes much sense to me. Shouldn't the
iov_to_buf be limiting you anyway? Why do you need the additional gpa
check?

> +    while (iov_to_buf(elem->out_sg, elem->out_num, offset, &gpa, 8) == 8 && gpa != 0) {
> +       offset += 8;
> +       offset += iov_to_buf(elem->out_sg, elem->out_num, offset, &len, 8);

Why pull this out as two separate buffers? Why not just define a
structure that consists of the two uint64_t values and then pull the
entire thing as one buffer? I'm pretty sure the solution as you have
it now opens you up to an error since you could have a malicious guest
only give you a part of the structure and you really should be
verifying you get the entire structure.

> +       if (!qemu_balloon_is_inhibited()) {
> +           free_mem_range(gpa, len);
> +       }
> +    }
> +    virtqueue_push(vq, elem, offset);
> +    virtio_notify(vdev, vq);
> +    g_free(elem);
> +}
> +
>  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>  {
>      VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
> @@ -694,6 +749,7 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
>      VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
>      f |= dev->host_features;
>      virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
> +    virtio_add_feature(&f, VIRTIO_BALLOON_F_HINTING);
>
>      return f;
>  }
> @@ -780,6 +836,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
>      s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
> +    s->hvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_page_hinting);
>
>      if (virtio_has_feature(s->host_features,
>                             VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> @@ -875,6 +932,8 @@ static void virtio_balloon_instance_init(Object *obj)
>
>      object_property_add(obj, "guest-stats", "guest statistics",
>                          balloon_stats_get_all, NULL, NULL, s, NULL);
> +    object_property_add(obj, "guest-page-hinting", "guest page hinting",
> +                        NULL, NULL, NULL, s, NULL);
>
>      object_property_add(obj, "guest-stats-polling-interval", "int",
>                          balloon_stats_get_poll_interval,
> diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
> index 1afafb12f6..a58b24fdf2 100644
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
> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> index af2b91f0b8..bb9207e7f4 100644
> --- a/include/qemu/osdep.h
> +++ b/include/qemu/osdep.h
> @@ -360,6 +360,11 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #else
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
>  #endif
> +#ifdef MADV_FREE
> +#define QEMU_MADV_FREE MADV_FREE
> +#else
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
> +#endif

As I mentioned before it might make more sense to use MADV_DONTNEED
instead of just disabling this functionality if the host kernel
doesn't have MADV_FREE support. That way you would still have the
functionality on kernels prior to 4.5 if they need it.

>  #elif defined(CONFIG_POSIX_MADVISE)
>
> @@ -373,6 +378,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID

Same here. It might make more sense to use the POSIX_MADV_DONTNEED
instead of just making it invalid.

>  #else /* no-op */
>
> @@ -386,6 +392,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
>
>  #endif
>
> diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
> index 9375ca2a70..f9e3e82562 100644
> --- a/include/standard-headers/linux/virtio_balloon.h
> +++ b/include/standard-headers/linux/virtio_balloon.h
> @@ -36,6 +36,7 @@
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM        2 /* Deflate balloon on OOM */
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT        3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON   4 /* Guest is using page poisoning */
> +#define VIRTIO_BALLOON_F_HINTING       5 /* Page hinting virtqueue */
>
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
> --
> 2.21.0
>
