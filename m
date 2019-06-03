Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5733B7B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 00:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCWij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 18:38:39 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35642 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCWij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 18:38:39 -0400
Received: by mail-it1-f196.google.com with SMTP id n189so10844315itd.0;
        Mon, 03 Jun 2019 15:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F/ixDeQhQV0jkM+ZLEc/zUFxrkTvZoI9aB593YmsPiA=;
        b=s9+aMnx6B3R0hLSkCU1J6r+p1AiMsWy/lS4s0oth8CJJfttuYrqWdaFXKQUggrJ0B/
         sF3/n1/6QUBSqlLcDes5E5PYyl+oeAsV0DGtwnGzLigTlDdztk1cCIxyrNvQKt9Vo9Zd
         G7egM7/Mm1B3cChhYLxz7qmiYxEd9ygcusCLtAstLWvOZeX6GzpJLVoa/yyT6fWJ8rEE
         v4siPNXfVWM79HhrQPBHunnd5GQRrfmWoSQW/tgpbaUz8Bg/S1j4BLFmh01yJEhczXam
         rtpTOEqIlv8e//gYzQcDQqVG2RBXwnCMbSnSDZ65KAWWS+gZE+UBhQqJQOS+rRCiSn5b
         YRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F/ixDeQhQV0jkM+ZLEc/zUFxrkTvZoI9aB593YmsPiA=;
        b=NfXSGYats/EAuZLCRlNlRaAMgQwaRkjnV407sVTRce85s9auzlkcqajedi+OvUvwMD
         W0jGRvfXprQNDVw+1+TnGIekK7707j8lfo6UYh7nWvIg6rbuYopzDAFPdrv4lx4IFYzC
         Y+93pNqXI6Xs4AeKk9q527eypqZNWk4fN6ADE1RidcWDHwcKQGUkCkiouy/YdGigct9x
         GgheOljadAeZyCgn7Nk61eEpswQh/KycSQsP2JQ4bSwmruh2MrhlSWoyFSwZZtLsHAdc
         0zxJVr1g1R2xWFvoH3vhqILibM3x3QsnwnhxHhxLB7z097y3MvOlJDzlo1iNTDOQTdlR
         V6jw==
X-Gm-Message-State: APjAAAVlwf77b0eJi732uCL+LV9SzrlwQXI1QcPIddyqkzz+CzzSN8g8
        79xPGqYfA7S2wy0IQMM9vfeTfcfIXEcwEIQoj9M=
X-Google-Smtp-Source: APXvYqxE3pqRl68z5nHb341KBeHZIiVFd5DLcpA0OiQW5aDXbSqBg02oNx5KzeRRPXKtMYy6PK+00mxJhVAMM2gxC80=
X-Received: by 2002:a02:5502:: with SMTP id e2mr18612138jab.87.1559601517930;
 Mon, 03 Jun 2019 15:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170306.49099-3-nitesh@redhat.com>
In-Reply-To: <20190603170306.49099-3-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 3 Jun 2019 15:38:26 -0700
Message-ID: <CAKgT0UdtHAvRd++enU3ouxebwV1T4KZbS_JkmyDbJ5jGkA1XaQ@mail.gmail.com>
Subject: Re: [RFC][Patch v10 2/2] virtio-balloon: page_hinting: reporting to
 the host
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
> Enables the kernel to negotiate VIRTIO_BALLOON_F_HINTING feature with the
> host. If it is available and page_hinting_flag is set to true, page_hinting
> is enabled and its callbacks are configured along with the max_pages count
> which indicates the maximum number of pages that can be isolated and hinted
> at a time. Currently, only free pages of order >= (MAX_ORDER - 2) are
> reported. To prevent any false OOM max_pages count is set to 16.
>
> By default page_hinting feature is enabled and gets loaded as soon
> as the virtio-balloon driver is loaded. However, it could be disabled
> by writing the page_hinting_flag which is a virtio-balloon parameter.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/virtio/virtio_balloon.c     | 112 +++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_balloon.h |  14 ++++
>  2 files changed, 125 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index f19061b585a4..40f09ea31643 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -31,6 +31,7 @@
>  #include <linux/mm.h>
>  #include <linux/mount.h>
>  #include <linux/magic.h>
> +#include <linux/page_hinting.h>
>
>  /*
>   * Balloon device works in 4K page units.  So each page is pointed to by
> @@ -48,6 +49,7 @@
>  /* The size of a free page block in bytes */
>  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
>         (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> +#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES  16
>
>  #ifdef CONFIG_BALLOON_COMPACTION
>  static struct vfsmount *balloon_mnt;
> @@ -58,6 +60,7 @@ enum virtio_balloon_vq {
>         VIRTIO_BALLOON_VQ_DEFLATE,
>         VIRTIO_BALLOON_VQ_STATS,
>         VIRTIO_BALLOON_VQ_FREE_PAGE,
> +       VIRTIO_BALLOON_VQ_HINTING,
>         VIRTIO_BALLOON_VQ_MAX
>  };
>
> @@ -67,7 +70,8 @@ enum virtio_balloon_config_read {
>
>  struct virtio_balloon {
>         struct virtio_device *vdev;
> -       struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
> +       struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
> +                        *hinting_vq;
>
>         /* Balloon's own wq for cpu-intensive work items */
>         struct workqueue_struct *balloon_wq;
> @@ -125,6 +129,9 @@ struct virtio_balloon {
>
>         /* To register a shrinker to shrink memory upon memory pressure */
>         struct shrinker shrinker;
> +
> +       /* object pointing at the array of isolated pages ready for hinting */
> +       struct hinting_data *hinting_arr;

Just make this an array of size VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES.
It will save a bunch of complexity later.

>  };
>
>  static struct virtio_device_id id_table[] = {
> @@ -132,6 +139,85 @@ static struct virtio_device_id id_table[] = {
>         { 0 },
>  };
>
> +#ifdef CONFIG_PAGE_HINTING

Instead of having CONFIG_PAGE_HINTING enable this, maybe we should
have virtio-balloon enable CONFIG_PAGE_HINTING.

> +struct virtio_balloon *hvb;
> +bool page_hinting_flag = true;
> +module_param(page_hinting_flag, bool, 0444);
> +MODULE_PARM_DESC(page_hinting_flag, "Enable page hinting");
> +
> +static bool virtqueue_kick_sync(struct virtqueue *vq)
> +{
> +       u32 len;
> +
> +       if (likely(virtqueue_kick(vq))) {
> +               while (!virtqueue_get_buf(vq, &len) &&
> +                      !virtqueue_is_broken(vq))
> +                       cpu_relax();
> +               return true;

Is this a synchronous setup? It seems kind of wasteful to have a
thread busy waiting here like this. It might make more sense to just
make this work like the other balloon queues and have a wait event
with a wake up in the interrupt handler for the queue.

> +       }
> +       return false;
> +}
> +
> +static void page_hinting_report(int entries)
> +{
> +       struct scatterlist sg;
> +       struct virtqueue *vq = hvb->hinting_vq;
> +       int err = 0;
> +       struct hinting_data *hint_req;
> +       u64 gpaddr;
> +
> +       hint_req = kmalloc(sizeof(*hint_req), GFP_KERNEL);
> +       if (!hint_req)
> +               return;

Why do we need another allocation here? Couldn't you just allocate
hint_req on the stack and then use that? I think we might be doing too
much here. All this really needs to look like is something along the
lines of tell_host() minus the wait_event.

> +       gpaddr = virt_to_phys(hvb->hinting_arr);
> +       hint_req->phys_addr = cpu_to_virtio64(hvb->vdev, gpaddr);
> +       hint_req->size = cpu_to_virtio32(hvb->vdev, entries);
> +       sg_init_one(&sg, hint_req, sizeof(*hint_req));
> +       err = virtqueue_add_outbuf(vq, &sg, 1, hint_req, GFP_KERNEL);
> +       if (!err)
> +               virtqueue_kick_sync(hvb->hinting_vq);
> +
> +       kfree(hint_req);
> +}
> +
> +int page_hinting_prepare(void)
> +{
> +       hvb->hinting_arr = kmalloc_array(VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
> +                                        sizeof(*hvb->hinting_arr), GFP_KERNEL);
> +       if (!hvb->hinting_arr)
> +               return -ENOMEM;
> +       return 0;
> +}
> +

Why make the hinting_arr a dynamic allocation? You should probably
just make it a static array within the virtio_balloon structure. Then
you don't have the risk of an allocation failing and messing up the
hints.

> +void hint_pages(struct list_head *pages)
> +{
> +       struct page *page, *next;
> +       unsigned long pfn;
> +       int idx = 0, order;
> +
> +       list_for_each_entry_safe(page, next, pages, lru) {
> +               pfn = page_to_pfn(page);
> +               order = page_private(page);
> +               hvb->hinting_arr[idx].phys_addr = pfn << PAGE_SHIFT;
> +               hvb->hinting_arr[idx].size = (1 << order) * PAGE_SIZE;
> +               idx++;
> +       }
> +       page_hinting_report(idx);
> +}
> +

Getting back to my suggestion from earlier today. It might make sense
to not bother with the PAGE_SHIFT or PAGE_SIZE multiplication if you
just record everything in VIRTIO_BALLOON_PAGES intead of using the
actual address and size.

> +void page_hinting_cleanup(void)
> +{
> +       kfree(hvb->hinting_arr);
> +}
> +

Same comment here. Make this array a part of virtio_balloon and you
don't have to free it.

> +static const struct page_hinting_cb hcb = {
> +       .prepare = page_hinting_prepare,
> +       .hint_pages = hint_pages,
> +       .cleanup = page_hinting_cleanup,
> +       .max_pages = VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
> +};

With the above changes prepare and cleanup can be dropped.

> +#endif
> +
>  static u32 page_to_balloon_pfn(struct page *page)
>  {
>         unsigned long pfn = page_to_pfn(page);
> @@ -488,6 +574,7 @@ static int init_vqs(struct virtio_balloon *vb)
>         names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>         names[VIRTIO_BALLOON_VQ_STATS] = NULL;
>         names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> +       names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
>
>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>                 names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> @@ -499,11 +586,18 @@ static int init_vqs(struct virtio_balloon *vb)
>                 callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>         }
>
> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
> +               names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
> +               callbacks[VIRTIO_BALLOON_VQ_HINTING] = NULL;
> +       }
>         err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>                                          vqs, callbacks, names, NULL, NULL);
>         if (err)
>                 return err;
>
> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
> +               vb->hinting_vq = vqs[VIRTIO_BALLOON_VQ_HINTING];
> +
>         vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
>         vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> @@ -942,6 +1036,14 @@ static int virtballoon_probe(struct virtio_device *vdev)
>                 if (err)
>                         goto out_del_balloon_wq;
>         }
> +
> +#ifdef CONFIG_PAGE_HINTING
> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING) &&
> +           page_hinting_flag) {
> +               hvb = vb;
> +               page_hinting_enable(&hcb);
> +       }
> +#endif
>         virtio_device_ready(vdev);
>
>         if (towards_target(vb))
> @@ -989,6 +1091,12 @@ static void virtballoon_remove(struct virtio_device *vdev)
>                 destroy_workqueue(vb->balloon_wq);
>         }
>
> +#ifdef CONFIG_PAGE_HINTING
> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
> +               hvb = NULL;
> +               page_hinting_disable();
> +       }
> +#endif
>         remove_common(vb);
>  #ifdef CONFIG_BALLOON_COMPACTION
>         if (vb->vb_dev_info.inode)
> @@ -1043,8 +1151,10 @@ static unsigned int features[] = {
>         VIRTIO_BALLOON_F_MUST_TELL_HOST,
>         VIRTIO_BALLOON_F_STATS_VQ,
>         VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> +       VIRTIO_BALLOON_F_HINTING,
>         VIRTIO_BALLOON_F_FREE_PAGE_HINT,
>         VIRTIO_BALLOON_F_PAGE_POISON,
> +       VIRTIO_BALLOON_F_HINTING,
>  };
>
>  static struct virtio_driver virtio_balloon_driver = {
> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> index a1966cd7b677..25e4f817c660 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h
> @@ -29,6 +29,7 @@
>  #include <linux/virtio_types.h>
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
> +#include <linux/page_hinting.h>
>
>  /* The feature bitmap for virtio balloon */
>  #define VIRTIO_BALLOON_F_MUST_TELL_HOST        0 /* Tell before reclaiming pages */
> @@ -36,6 +37,7 @@
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM        2 /* Deflate balloon on OOM */
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT        3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON   4 /* Guest is using page poisoning */
> +#define VIRTIO_BALLOON_F_HINTING       5 /* Page hinting virtqueue */
>
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
> @@ -108,4 +110,16 @@ struct virtio_balloon_stat {
>         __virtio64 val;
>  } __attribute__((packed));
>
> +#ifdef CONFIG_PAGE_HINTING
> +/*
> + * struct hinting_data- holds the information associated with hinting.
> + * @phys_add:  physical address associated with a page or the array holding
> + *             the array of isolated pages.
> + * @size:      total size associated with the phys_addr.
> + */
> +struct hinting_data {
> +       __virtio64 phys_addr;
> +       __virtio32 size;
> +};

So in order to avoid errors this should either have
"__attribute__((packed))" added or it should be changed to a pair of
u32 or u64 values so that it will always be the same size regardless
of what platform it is built on.

> +#endif
>  #endif /* _LINUX_VIRTIO_BALLOON_H */
> --
> 2.21.0
>
