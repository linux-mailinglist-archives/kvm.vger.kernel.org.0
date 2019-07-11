Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50592661D5
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 00:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfGKWgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 18:36:21 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33004 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfGKWgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 18:36:20 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so16262141iog.0;
        Thu, 11 Jul 2019 15:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XGbYxpgADiFUW/V0IvgQ/ffdWslTKgPikSuk1woxxJY=;
        b=giKONUdZk+h//k+ASGHs65mEmPS7nCToBHnCpwURuqzREmqTaXCnM93NHmce9j0Nmj
         GB638zx+YKQE2POzEefS2gTqX3IkzXwYsV2rGbaML/Nl7XVh4wLFF7n2ce4kd3mYnapu
         Rs34zLwvuP9qNrMrkBBnWnLTeu0KOqvjE2cT4cateqqw5GlysBvykZRZn7rnb7jJtY7g
         nTu0TThFUF/CmBB7ajDnfsJ1uAqvxc+d1wV6UHP3vGMU4GLeZx9hL7UmtmrqZX49bLV7
         w7dq0B5NVvepIfJAg2dFPDf1CaKcfzbBL7wqmVbh5gtIyh2j69ZDgz9ZknE0kj0ekEhh
         dGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XGbYxpgADiFUW/V0IvgQ/ffdWslTKgPikSuk1woxxJY=;
        b=QF8zVrVLnXb77LJIV3HuDaVL0w2V04ANfV0NthwIbSJmE88aQZocpPo79leJ8/iHFH
         cwoyEk1VL1Kt+8XABn3H4pVshmKklmIn/RK4HKeiyrDqTRgfE1zIjtE879FWkOv8D7Gt
         4AgpJ8NTezzgz10+RhG5B+q78cdooMZBYGsPtGXTp4NOuhncV0XXmS4H3fYw9ewbnjyJ
         UQVF1QhRdmeX9qOSlOlgWE6wAn8tPiycfiXe8sUd+e7gMtp7BMhIFn31x8RzwNupLEYa
         xOnry0XPzQ7N+Ljfi8ga7DY5/55wTN/My7cZM0Mkk7bASJEJ9uBN7Y9lXn0jflYz+vfP
         n1Tw==
X-Gm-Message-State: APjAAAW/Mz38QMnbdB8niMIqygddlLStK1/UvylDQ1rrs0FF18yVRSxf
        Qf13V+OvdTEh2MCumNsHsjKmb/uDyg8boTjelvM=
X-Google-Smtp-Source: APXvYqwJrt4afd3bDAw5Uc8yK5/zGmoGIAKhlF0WEgpjra0ERTYFrLXiOfFyk1FMetvyKKxAKiC4/bDBQmHRH1NaD9o=
X-Received: by 2002:a6b:6409:: with SMTP id t9mr55131iog.270.1562884579704;
 Thu, 11 Jul 2019 15:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190710195158.19640-1-nitesh@redhat.com> <20190710195303.19690-1-nitesh@redhat.com>
 <20190711141036-mutt-send-email-mst@kernel.org> <00f4d486-e4e8-c796-5b4f-c0e8b6b74dc2@redhat.com>
In-Reply-To: <00f4d486-e4e8-c796-5b4f-c0e8b6b74dc2@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Jul 2019 15:36:08 -0700
Message-ID: <CAKgT0UfZPCHsUu22cEKsCYE5jcWhCM-rKRU2TKA5VjvCZjsbdQ@mail.gmail.com>
Subject: Re: [QEMU Patch] virtio-baloon: Support for page hinting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 12:06 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 7/11/19 2:55 PM, Michael S. Tsirkin wrote:
> > On Wed, Jul 10, 2019 at 03:53:03PM -0400, Nitesh Narayan Lal wrote:
> >> Enables QEMU to perform madvise free on the memory range reported
> >> by the vm.
> >>
> >> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > Missing second "l" in the subject :)
> >
> >> ---
> >>  hw/virtio/trace-events                        |  1 +
> >>  hw/virtio/virtio-balloon.c                    | 59 +++++++++++++++++++
> >>  include/hw/virtio/virtio-balloon.h            |  2 +-
> >>  include/qemu/osdep.h                          |  7 +++
> >>  .../standard-headers/linux/virtio_balloon.h   |  1 +
> >>  5 files changed, 69 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> >> index e28ba48da6..f703a22d36 100644
> >> --- a/hw/virtio/trace-events
> >> +++ b/hw/virtio/trace-events
> >> @@ -46,6 +46,7 @@ virtio_balloon_handle_output(const char *name, uint64_t gpa) "section name: %s g
> >>  virtio_balloon_get_config(uint32_t num_pages, uint32_t actual) "num_pages: %d actual: %d"
> >>  virtio_balloon_set_config(uint32_t actual, uint32_t oldactual) "actual: %d oldactual: %d"
> >>  virtio_balloon_to_target(uint64_t target, uint32_t num_pages) "balloon target: 0x%"PRIx64" num_pages: %d"
> >> +virtio_balloon_hinting_request(unsigned long pfn, unsigned int num_pages) "Guest page hinting request PFN:%lu size: %d"
> >>
> >>  # virtio-mmio.c
> >>  virtio_mmio_read(uint64_t offset) "virtio_mmio_read offset 0x%" PRIx64
> >> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> >> index 2112874055..5d186707b5 100644
> >> --- a/hw/virtio/virtio-balloon.c
> >> +++ b/hw/virtio/virtio-balloon.c
> >> @@ -34,6 +34,9 @@
> >>
> >>  #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
> >>
> >> +#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES       16
> >> +void free_mem_range(uint64_t addr, uint64_t len);
> >> +
> >>  struct PartiallyBalloonedPage {
> >>      RAMBlock *rb;
> >>      ram_addr_t base;
> >> @@ -328,6 +331,58 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
> >>      balloon_stats_change_timer(s, 0);
> >>  }
> >>
> >> +void free_mem_range(uint64_t addr, uint64_t len)
> >> +{
> >> +    int ret = 0;
> >> +    void *hvaddr_to_free;
> >> +    MemoryRegionSection mrs = memory_region_find(get_system_memory(),
> >> +                                                 addr, 1);
> >> +    if (!mrs.mr) {
> >> +    warn_report("%s:No memory is mapped at address 0x%lu", __func__, addr);
> >> +        return;
> >> +    }
> >> +
> >> +    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.mr)) {
> >> +    warn_report("%s:Memory at address 0x%s is not RAM:0x%lu", __func__,
> >> +                HWADDR_PRIx, addr);
> >> +        memory_region_unref(mrs.mr);
> >> +        return;
> >> +    }
> >> +
> >> +    hvaddr_to_free = qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_region);
> >> +    trace_virtio_balloon_hinting_request(addr, len);
> >> +    ret = qemu_madvise(hvaddr_to_free,len, QEMU_MADV_FREE);
> >> +    if (ret == -1) {
> >> +    warn_report("%s: Madvise failed with error:%d", __func__, ret);
> >> +    }
> >> +}
> >> +
> >> +static void virtio_balloon_handle_page_hinting(VirtIODevice *vdev,
> >> +                                           VirtQueue *vq)
> >> +{
> >> +    VirtQueueElement *elem;
> >> +    size_t offset = 0;
> >> +    uint64_t gpa, len;
> >> +    elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
> >> +    if (!elem) {
> >> +        return;
> >> +    }
> >> +    /* For pending hints which are < max_pages(16), 'gpa != 0' ensures that we
> >> +     * only read the buffer which holds a valid PFN value.
> >> +     * TODO: Find a better way to do this.
> > Indeed. In fact, what is wrong with passing the gpa as
> > part of the element itself?
> There are two values which I need to read 'gpa' and 'len'. I will have
> to check how to pass them both as part of the element.
> But, I will look into it.

One advantage of doing it as a scatter-gather list being passed via
the element is that you only get one completion. If you are going to
do an element per page then you will need to somehow identify if the
entire ring has been processed or not before you free your local page
list.

> >> +     */
> >> +    while (iov_to_buf(elem->out_sg, elem->out_num, offset, &gpa, 8) == 8 && gpa != 0) {
> >> +    offset += 8;
> >> +    offset += iov_to_buf(elem->out_sg, elem->out_num, offset, &len, 8);
> >> +    if (!qemu_balloon_is_inhibited()) {
> >> +        free_mem_range(gpa, len);
> >> +    }
> >> +    }
> >> +    virtqueue_push(vq, elem, offset);
> >> +    virtio_notify(vdev, vq);
> >> +    g_free(elem);
> >> +}
> >> +
> >>  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> >>  {
> >>      VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
> >> @@ -694,6 +749,7 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
> >>      VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
> >>      f |= dev->host_features;
> >>      virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
> >> +    virtio_add_feature(&f, VIRTIO_BALLOON_F_HINTING);
> >>
> >>      return f;
> >>  }
> >> @@ -780,6 +836,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
> >>      s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
> >>      s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
> >>      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
> >> +    s->hvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_page_hinting);
> >>
> >>      if (virtio_has_feature(s->host_features,
> >>                             VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> >> @@ -875,6 +932,8 @@ static void virtio_balloon_instance_init(Object *obj)
> >>
> >>      object_property_add(obj, "guest-stats", "guest statistics",
> >>                          balloon_stats_get_all, NULL, NULL, s, NULL);
> >> +    object_property_add(obj, "guest-page-hinting", "guest page hinting",
> >> +                        NULL, NULL, NULL, s, NULL);
> >>
> >>      object_property_add(obj, "guest-stats-polling-interval", "int",
> >>                          balloon_stats_get_poll_interval,
> >> diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
> >> index 1afafb12f6..a58b24fdf2 100644
> >> --- a/include/hw/virtio/virtio-balloon.h
> >> +++ b/include/hw/virtio/virtio-balloon.h
> >> @@ -44,7 +44,7 @@ enum virtio_balloon_free_page_report_status {
> >>
> >>  typedef struct VirtIOBalloon {
> >>      VirtIODevice parent_obj;
> >> -    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
> >> +    VirtQueue *ivq, *dvq, *svq, *free_page_vq, *hvq;
> >>      uint32_t free_page_report_status;
> >>      uint32_t num_pages;
> >>      uint32_t actual;
> >> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> >> index af2b91f0b8..bb9207e7f4 100644
> >> --- a/include/qemu/osdep.h
> >> +++ b/include/qemu/osdep.h
> >> @@ -360,6 +360,11 @@ void qemu_anon_ram_free(void *ptr, size_t size);
> >>  #else
> >>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> >>  #endif
> >> +#ifdef MADV_FREE
> >> +#define QEMU_MADV_FREE MADV_FREE
> >> +#else
> >> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
> >> +#endif
> >>
> >>  #elif defined(CONFIG_POSIX_MADVISE)
> >>
> >> @@ -373,6 +378,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
> >>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
> >>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
> >>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> >> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
> >>
> >>  #else /* no-op */
> >>
> >> @@ -386,6 +392,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
> >>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
> >>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
> >>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> >> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
> >>
> >>  #endif
> >>
> >> diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
> >> index 9375ca2a70..f9e3e82562 100644
> >> --- a/include/standard-headers/linux/virtio_balloon.h
> >> +++ b/include/standard-headers/linux/virtio_balloon.h
> >> @@ -36,6 +36,7 @@
> >>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM     2 /* Deflate balloon on OOM */
> >>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT     3 /* VQ to report free pages */
> >>  #define VIRTIO_BALLOON_F_PAGE_POISON        4 /* Guest is using page poisoning */
> >> +#define VIRTIO_BALLOON_F_HINTING    5 /* Page hinting virtqueue */
> >>
> >>  /* Size of a PFN in the balloon interface. */
> >>  #define VIRTIO_BALLOON_PFN_SHIFT 12
> >> --
> >> 2.21.0
> --
> Thanks
> Nitesh
>
