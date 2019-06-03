Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981C033813
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 20:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfFCSgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 14:36:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38091 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfFCSek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 14:34:40 -0400
Received: by mail-io1-f67.google.com with SMTP id x24so15173591ion.5;
        Mon, 03 Jun 2019 11:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8waf4j1Ofjdd+vlrV9/6mtAHmqs3O62eZd9KkYxJJY=;
        b=YMnEQjNS3kmaXxOa8LiYKPd+7AM5Mgz3m69k4rrH4XAlfpI8War57wDsoJHIZQrQ7j
         mPzhfvakRkN+vMgeeDdu5nSfcx+dzxaMIOJeffJCNqWLOiD9cNvCVmzryD/fWExbv8jB
         eOhLwDZYrTConaALsLkAHfrdrPoXCeiAJvg09o00qLeyGBsTjl9WPlTRn8fmMCtSvZip
         dE2eu694Q5Hcm/PXqeVwJrQF1T9cP5+BhBjRi++k89liTADUISSL9oQrIrbclyIwH7/z
         EI+0qiZwpZQha1+7lX7FYJ/2q6iwSP4h2OD7C2frlyDhBxdT89ZBsfUVnGET7KqEgQX4
         GT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8waf4j1Ofjdd+vlrV9/6mtAHmqs3O62eZd9KkYxJJY=;
        b=B6SH5tq98RpzQIKQQnRv0WsHIOReDM0vqtt+pDSQPXsFiC85CWAHITlbty5jBUceDN
         kFPf+KwRyNZWVZDEnVvD25YJvSoBHIZ9PXlvmXCeeborlinf8HcvX4V1tNaFHRCLcVdt
         3itQz0nW7xbyKbTWchXWtaoQkniDHanBxLE5wnWIEuZCITmYuhYsY2kmAkX51IadpnrP
         vMMOEuylgyZ7oQ3AfbVvGPp1XYoFiHJkbI62x/yjKz7vDZQbvzybLmikR6miSXhcSkMH
         qIqN+P0VcgvbwPLcy0cDUJsh4Un6V2X9kvh8leHXF17Uwus6rE/HEd5gif6EA3sFuyQR
         YWLQ==
X-Gm-Message-State: APjAAAWdlbyDJuZ9Pt3iGiIv1nSVEEEhTtqRQ6QbthHPTUUt276N7oLr
        MricAomCsGLRbNf0/d9fLkO8UyEeNXGNEoqdbeKxLUm9Ij8=
X-Google-Smtp-Source: APXvYqyCvPNC5WlDF8YEDiR6LjDGjgig4oSEwJnIdAgZECfPvaIaDDBZ+WucgcUSAeCXa3h3Np3EDMrFy9wCJ4uVpJs=
X-Received: by 2002:a6b:b790:: with SMTP id h138mr16268768iof.64.1559586878627;
 Mon, 03 Jun 2019 11:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170432.1195-1-nitesh@redhat.com>
In-Reply-To: <20190603170432.1195-1-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 3 Jun 2019 11:34:27 -0700
Message-ID: <CAKgT0Udqm2qNQ1+mPkx7vx=c2a7Hjq92fKM30041e1kU47bcHA@mail.gmail.com>
Subject: Re: [QEMU PATCH] KVM: Support for page hinting
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
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> Enables QEMU to call madvise on the pages which are reported
> by the guest kernel.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

What commit-id is this meant to apply on top of? I can't apply this to
the latest development version of QEMU.

> ---
>  hw/virtio/trace-events                        |  1 +
>  hw/virtio/virtio-balloon.c                    | 85 +++++++++++++++++++
>  include/hw/virtio/virtio-balloon.h            |  2 +-
>  include/qemu/osdep.h                          |  7 ++
>  .../standard-headers/linux/virtio_balloon.h   |  1 +
>  5 files changed, 95 insertions(+), 1 deletion(-)
>
> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> index 07bcbe9e85..015565785c 100644
> --- a/hw/virtio/trace-events
> +++ b/hw/virtio/trace-events
> @@ -46,3 +46,4 @@ virtio_balloon_handle_output(const char *name, uint64_t gpa) "section name: %s g
>  virtio_balloon_get_config(uint32_t num_pages, uint32_t actual) "num_pages: %d actual: %d"
>  virtio_balloon_set_config(uint32_t actual, uint32_t oldactual) "actual: %d oldactual: %d"
>  virtio_balloon_to_target(uint64_t target, uint32_t num_pages) "balloon target: 0x%"PRIx64" num_pages: %d"
> +virtio_balloon_hinting_request(unsigned long pfn, unsigned int num_pages) "Guest page hinting request: %lu size: %d"
> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> index a12677d4d5..cbb630279c 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -33,6 +33,13 @@
>
>  #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
>
> +struct guest_pages {
> +       uint64_t phys_addr;
> +       uint32_t len;
> +};
> +

Any reason for matching up 64b addr w/ 32b size? The way I see it you
would be be better off going with either 64b for both or 32b for both.
I opted for the 32b approach in my case since there was already code
in place for doing the PFN shift anyway in the standard virtio_balloon
code path.

> +void page_hinting_request(uint64_t addr, uint32_t len);
> +
>  static void balloon_page(void *addr, int deflate)
>  {
>      if (!qemu_balloon_is_inhibited()) {
> @@ -207,6 +214,80 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
>      balloon_stats_change_timer(s, 0);
>  }
>
> +static void *gpa2hva(MemoryRegion **p_mr, hwaddr addr, Error **errp)
> +{
> +    MemoryRegionSection mrs = memory_region_find(get_system_memory(),
> +                                                 addr, 1);
> +
> +    if (!mrs.mr) {
> +        error_setg(errp, "No memory is mapped at address 0x%" HWADDR_PRIx, addr);
> +        return NULL;
> +    }
> +
> +    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.mr)) {
> +        error_setg(errp, "Memory at address 0x%" HWADDR_PRIx "is not RAM", addr);
> +        memory_region_unref(mrs.mr);
> +        return NULL;
> +    }
> +
> +    *p_mr = mrs.mr;
> +    return qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_region);
> +}
> +
> +void page_hinting_request(uint64_t addr, uint32_t len)
> +{
> +    Error *local_err = NULL;
> +    MemoryRegion *mr = NULL;
> +    int ret = 0;
> +    struct guest_pages *guest_obj;
> +    int i = 0;
> +    void *hvaddr_to_free;
> +    uint64_t gpaddr_to_free;
> +    void * temp_addr = gpa2hva(&mr, addr, &local_err);
> +
> +    if (local_err) {
> +        error_report_err(local_err);
> +        return;
> +    }
> +    guest_obj = temp_addr;
> +    while (i < len) {
> +       gpaddr_to_free = guest_obj[i].phys_addr;
> +       trace_virtio_balloon_hinting_request(gpaddr_to_free,guest_obj[i].len);
> +       hvaddr_to_free = gpa2hva(&mr, gpaddr_to_free, &local_err);
> +       if (local_err) {
> +               error_report_err(local_err);
> +               return;
> +       }
> +       ret = qemu_madvise((void *)hvaddr_to_free, guest_obj[i].len, QEMU_MADV_FREE);
> +       if (ret == -1)
> +           printf("\n%d:%s Error: Madvise failed with error:%d\n", __LINE__, __func__, ret);
> +       i++;
> +    }
> +}
> +

Have we made any determination yet on the MADV_FREE vs MADV_DONT_NEED?
My preference would be to have this code just reuse the existing
balloon code as I did in my patch set. Then we can avoid the need to
have multiple types in use. We could just have the balloon use the
same as the hint.

> +static void virtio_balloon_page_hinting(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    VirtQueueElement *elem = NULL;
> +    uint64_t temp_addr;
> +    uint32_t temp_len;
> +    size_t size, t_size = 0;
> +
> +    elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
> +    if (!elem) {
> +       printf("\npop error\n");
> +       return;
> +    }
> +    size = iov_to_buf(elem->out_sg, elem->out_num, 0, &temp_addr, sizeof(temp_addr));
> +    t_size += size;
> +    size = iov_to_buf(elem->out_sg, elem->out_num, 8, &temp_len, sizeof(temp_len));
> +    t_size += size;
> +    if (!qemu_balloon_is_inhibited())
> +           page_hinting_request(temp_addr, temp_len);
> +    virtqueue_push(vq, elem, t_size);
> +    virtio_notify(vdev, vq);
> +    g_free(elem);
> +}
> +

If you are doing a u64 addr, and a u32 len, does that mean you are
having to use a packed array between the guest and the host? This
would be another good reason to have both settle on either u64 or u32.

>  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
>  {
>      VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
> @@ -376,6 +457,7 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
>      VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
>      f |= dev->host_features;
>      virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
> +    virtio_add_feature(&f, VIRTIO_BALLOON_F_HINTING);
>      return f;
>  }
>
> @@ -445,6 +527,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
>      s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
> +    s->hvq = virtio_add_queue(vdev, 128, virtio_balloon_page_hinting);
>
>      reset_stats(s);
>  }
> @@ -488,6 +571,8 @@ static void virtio_balloon_instance_init(Object *obj)
>
>      object_property_add(obj, "guest-stats", "guest statistics",
>                          balloon_stats_get_all, NULL, NULL, s, NULL);
> +    object_property_add(obj, "guest-page-hinting", "guest page hinting",
> +                        NULL, NULL, NULL, s, NULL);
>
>      object_property_add(obj, "guest-stats-polling-interval", "int",
>                          balloon_stats_get_poll_interval,
> diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
> index e0df3528c8..774498a6ca 100644
> --- a/include/hw/virtio/virtio-balloon.h
> +++ b/include/hw/virtio/virtio-balloon.h
> @@ -32,7 +32,7 @@ typedef struct virtio_balloon_stat_modern {
>
>  typedef struct VirtIOBalloon {
>      VirtIODevice parent_obj;
> -    VirtQueue *ivq, *dvq, *svq;
> +    VirtQueue *ivq, *dvq, *svq, *hvq;
>      uint32_t num_pages;
>      uint32_t actual;
>      uint64_t stats[VIRTIO_BALLOON_S_NR];
> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
> index 840af09cb0..4d632933a9 100644
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
>
>  #elif defined(CONFIG_POSIX_MADVISE)
>
> @@ -373,6 +378,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
>
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
> index 4dbb7dc6c0..f50c0d95ea 100644
> --- a/include/standard-headers/linux/virtio_balloon.h
> +++ b/include/standard-headers/linux/virtio_balloon.h
> @@ -34,6 +34,7 @@
>  #define VIRTIO_BALLOON_F_MUST_TELL_HOST        0 /* Tell before reclaiming pages */
>  #define VIRTIO_BALLOON_F_STATS_VQ      1 /* Memory Stats virtqueue */
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM        2 /* Deflate balloon on OOM */
> +#define VIRTIO_BALLOON_F_HINTING       5 /* Page hinting virtqueue */

So this is obviously built against an old version of QEMU, the latest
values for this include:
#define VIRTIO_BALLOON_F_FREE_PAGE_HINT 3 /* VQ to report free pages */
#define VIRTIO_BALLOON_F_PAGE_POISON    4 /* Guest is using page poisoning */

I wonder if we shouldn't look for a term other than "HINT" since there
is already the code around providing hints to migration.
