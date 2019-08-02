Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0D880210
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437061AbfHBU6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 16:58:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:5485 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfHBU6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 16:58:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 13:58:48 -0700
X-IronPort-AV: E=Sophos;i="5.64,339,1559545200"; 
   d="scan'208";a="184691853"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 13:58:48 -0700
Message-ID: <d59667e49e23a43ff55f73a9d2210c25fef783b0.camel@linux.intel.com>
Subject: Re: [PATCH v3 QEMU 2/2] virtio-balloon: Provide a interface for
 unused page reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Fri, 02 Aug 2019 13:58:48 -0700
In-Reply-To: <63bbf480-7d0c-dd5c-08bf-1951039fcd54@redhat.com>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
         <20190801224320.24744.16673.stgit@localhost.localdomain>
         <63bbf480-7d0c-dd5c-08bf-1951039fcd54@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-08-02 at 16:40 -0400, Nitesh Narayan Lal wrote:
> On 8/1/19 6:43 PM, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > 
> > Add support for what I am referring to as "unused page reporting".
> > Basically the idea is to function very similar to how the balloon works
> > in that we basically end up madvising the page as not being used. However
> > we don't really need to bother with any deflate type logic since the page
> > will be faulted back into the guest when it is read or written to.
> > 
> > This is meant to be a simplification of the existing balloon interface
> > to use for providing hints to what memory needs to be freed. I am assuming
> > this is safe to do as the deflate logic does not actually appear to do very
> > much other than tracking what subpages have been released and which ones
> > haven't.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  hw/virtio/virtio-balloon.c                      |   46 ++++++++++++++++++++++-
> >  include/hw/virtio/virtio-balloon.h              |    2 +
> >  include/standard-headers/linux/virtio_balloon.h |    1 +
> >  3 files changed, 46 insertions(+), 3 deletions(-)
> > 
> > diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
> > index 003b3ebcfdfb..7a30df63bc77 100644
> > --- a/hw/virtio/virtio-balloon.c
> > +++ b/hw/virtio/virtio-balloon.c
> > @@ -320,6 +320,40 @@ static void balloon_stats_set_poll_interval(Object *obj, Visitor *v,
> >      balloon_stats_change_timer(s, 0);
> >  }
> >  
> > +static void virtio_balloon_handle_report(VirtIODevice *vdev, VirtQueue *vq)
> > +{
> > +    VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
> > +    VirtQueueElement *elem;
> > +
> > +    while ((elem = virtqueue_pop(vq, sizeof(VirtQueueElement)))) {
> > +    	unsigned int i;
> > +
> > +        for (i = 0; i < elem->in_num; i++) {
> > +            void *addr = elem->in_sg[i].iov_base;
> > +            size_t size = elem->in_sg[i].iov_len;
> > +            ram_addr_t ram_offset;
> > +            size_t rb_page_size;
> > +            RAMBlock *rb;
> > +
> > +            if (qemu_balloon_is_inhibited() || dev->poison_val)
> > +                continue;
> > +
> > +            rb = qemu_ram_block_from_host(addr, false, &ram_offset);
> > +            rb_page_size = qemu_ram_pagesize(rb);
> > +
> > +            /* For now we will simply ignore unaligned memory regions */
> > +            if ((ram_offset | size) & (rb_page_size - 1))
> > +                continue;
> > +
> > +            ram_block_discard_range(rb, ram_offset, size);
> > +        }
> > +
> > +        virtqueue_push(vq, elem, 0);
> > +        virtio_notify(vdev, vq);
> > +        g_free(elem);
> > +    }
> > +}
> > +
> >  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> >  {
> >      VirtIOBalloon *s = VIRTIO_BALLOON(vdev);
> > @@ -627,7 +661,8 @@ static size_t virtio_balloon_config_size(VirtIOBalloon *s)
> >          return sizeof(struct virtio_balloon_config);
> >      }
> >      if (virtio_has_feature(features, VIRTIO_BALLOON_F_PAGE_POISON) ||
> > -        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> > +        virtio_has_feature(features, VIRTIO_BALLOON_F_FREE_PAGE_HINT) ||
> > +        virtio_has_feature(features, VIRTIO_BALLOON_F_REPORTING)) {
> >          return sizeof(struct virtio_balloon_config);
> >      }
> >      return offsetof(struct virtio_balloon_config, free_page_report_cmd_id);
> > @@ -715,7 +750,8 @@ static uint64_t virtio_balloon_get_features(VirtIODevice *vdev, uint64_t f,
> >      VirtIOBalloon *dev = VIRTIO_BALLOON(vdev);
> >      f |= dev->host_features;
> >      virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
> > -    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> > +    if (virtio_has_feature(f, VIRTIO_BALLOON_F_FREE_PAGE_HINT) ||
> > +        virtio_has_feature(f, VIRTIO_BALLOON_F_REPORTING)) {
> >          virtio_add_feature(&f, VIRTIO_BALLOON_F_PAGE_POISON);
> >      }
> >  
> > @@ -805,6 +841,10 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
> >      s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
> >      s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
> >  
> > +    if (virtio_has_feature(s->host_features, VIRTIO_BALLOON_F_REPORTING)) {
> > +        s->rvq = virtio_add_queue(vdev, 32, virtio_balloon_handle_report);
> > +    }
> > +
> This does makes sense. I haven't seen the kernel patch yet, but I am guessing
> you will use this max_vq size to define the capacity.

Right. It was one of the suggestions I had received for the last patch
set. So since I was already using it to limit the capacity I thought I
might as well shrink the size of the queue on the hypervisor and save
space. 

> >      if (virtio_has_feature(s->host_features,
> >                             VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
> >          s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
> > @@ -931,6 +971,8 @@ static Property virtio_balloon_properties[] = {
> >       */
> >      DEFINE_PROP_BOOL("qemu-4-0-config-size", VirtIOBalloon,
> >                       qemu_4_0_config_size, false),
> > +    DEFINE_PROP_BIT("unused-page-reporting", VirtIOBalloon, host_features,
> > +                    VIRTIO_BALLOON_F_REPORTING, true),
> >      DEFINE_PROP_LINK("iothread", VirtIOBalloon, iothread, TYPE_IOTHREAD,
> >                       IOThread *),
> >      DEFINE_PROP_END_OF_LIST(),
> > diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/virtio-balloon.h
> > index 7fe78e5c14d7..db5bf7127112 100644
> > --- a/include/hw/virtio/virtio-balloon.h
> > +++ b/include/hw/virtio/virtio-balloon.h
> > @@ -42,7 +42,7 @@ enum virtio_balloon_free_page_report_status {
> >  
> >  typedef struct VirtIOBalloon {
> >      VirtIODevice parent_obj;
> > -    VirtQueue *ivq, *dvq, *svq, *free_page_vq;
> > +    VirtQueue *ivq, *dvq, *svq, *free_page_vq, *rvq;
> >      uint32_t free_page_report_status;
> >      uint32_t num_pages;
> >      uint32_t actual;
> > diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
> > index 9375ca2a70de..1c5f6d6f2de6 100644
> > --- a/include/standard-headers/linux/virtio_balloon.h
> > +++ b/include/standard-headers/linux/virtio_balloon.h
> > @@ -36,6 +36,7 @@
> >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
> >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
> >  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
> > +#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
> 
> Do we really need this change? or is this something which is picked from the
> Linux kernel?
> If we do need it, then Cornelia suggested to split off any update to this header
> into a separate patch, so that it can be replaced by a proper headers update
> when it is merged.

I'll keep that in mind. I didn't think of this as an official submission
for QEMU as of yet. I have been mostly focused on the kernel side of
things for now.


