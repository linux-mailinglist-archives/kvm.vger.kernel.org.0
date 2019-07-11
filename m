Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E7865355
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 10:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfGKItc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 04:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfGKItb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 04:49:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13A2D81F07;
        Thu, 11 Jul 2019 08:49:30 +0000 (UTC)
Received: from gondolin (ovpn-117-213.ams2.redhat.com [10.36.117.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 324321001B05;
        Thu, 11 Jul 2019 08:49:15 +0000 (UTC)
Date:   Thu, 11 Jul 2019 10:49:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com,
        john.starks@microsoft.com, dave.hansen@intel.com, mhocko@suse.com
Subject: Re: [QEMU Patch] virtio-baloon: Support for page hinting
Message-ID: <20190711104912.2cd79aeb.cohuck@redhat.com>
In-Reply-To: <20190710195303.19690-1-nitesh@redhat.com>
References: <20190710195158.19640-1-nitesh@redhat.com>
        <20190710195303.19690-1-nitesh@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 11 Jul 2019 08:49:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jul 2019 15:53:03 -0400
Nitesh Narayan Lal <nitesh@redhat.com> wrote:


$SUBJECT: s/baloon/balloon/

> Enables QEMU to perform madvise free on the memory range reported
> by the vm.

[No comments on the actual functionality; just some stuff I noticed.]

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

(...)

> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> index 2112874055..5d186707b5 100644
> --- a/hw/virtio/virtio-balloon.c
> +++ b/hw/virtio/virtio-balloon.c
> @@ -34,6 +34,9 @@
>  
>  #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
>  
> +#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES	16
> +void free_mem_range(uint64_t addr, uint64_t len);
> +
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
> +	warn_report("%s:No memory is mapped at address 0x%lu", __func__, addr);

Indentation seems to be off here (also in other places; please double
check.)

> +        return;
> +    }
> +
> +    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.mr)) {
> +	warn_report("%s:Memory at address 0x%s is not RAM:0x%lu", __func__,
> +		    HWADDR_PRIx, addr);
> +        memory_region_unref(mrs.mr);
> +        return;
> +    }
> +
> +    hvaddr_to_free = qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_region);
> +    trace_virtio_balloon_hinting_request(addr, len);
> +    ret = qemu_madvise(hvaddr_to_free,len, QEMU_MADV_FREE);
> +    if (ret == -1) {
> +	warn_report("%s: Madvise failed with error:%d", __func__, ret);
> +    }
> +}
> +
> +static void virtio_balloon_handle_page_hinting(VirtIODevice *vdev,
> +					       VirtQueue *vq)
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
> +    while (iov_to_buf(elem->out_sg, elem->out_num, offset, &gpa, 8) == 8 && gpa != 0) {
> +	offset += 8;
> +	offset += iov_to_buf(elem->out_sg, elem->out_num, offset, &len, 8);
> +	if (!qemu_balloon_is_inhibited()) {
> +	    free_mem_range(gpa, len);
> +	}
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

I don't think you can add this unconditionally if you want to keep this
migratable. This should be done via a property (as for deflate-on-oom
and free-page-hint) so it can be turned off in compat machines.

>  
>      return f;
>  }
> @@ -780,6 +836,7 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
>      s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
>      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
> +    s->hvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_page_hinting);

This should probably be conditional in the same way as the free page hint
queue (also see above).

>  
>      if (virtio_has_feature(s->host_features,
>                             VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> @@ -875,6 +932,8 @@ static void virtio_balloon_instance_init(Object *obj)
>  
>      object_property_add(obj, "guest-stats", "guest statistics",
>                          balloon_stats_get_all, NULL, NULL, s, NULL);
> +    object_property_add(obj, "guest-page-hinting", "guest page hinting",
> +                        NULL, NULL, NULL, s, NULL);

This object does not have any accessors; what purpose does it serve?

>  
>      object_property_add(obj, "guest-stats-polling-interval", "int",
>                          balloon_stats_get_poll_interval,

(...)

> diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
> index 9375ca2a70..f9e3e82562 100644
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

Please split off any update to these headers into a separate patch, so
that it can be replaced by a proper headers update when it is merged.
