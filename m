Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C29A830AE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732753AbfHFLbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 07:31:22 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41431 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbfHFLbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 07:31:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so5186580qtj.8
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2019 04:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6MKE3WpJRvmKRFMaN2W9lDZcPJmjUwMQHP29v6g6oiE=;
        b=BIwvv1acuK7O0n7mP70KLfexTDrqSwYZ4DSKE03yXTFc94IjXMWEMHLGo0Z4RIURil
         iIWawGp+I3Y5/WxNLS9ePX3wBJZr2EBrICJb51VW354JPY69vYmyuP3hpQCJEJ+q9zGe
         kfWBCs2Y/FAmQUC20A9Y9m5RtH47Qd53CmJmxXwcYLhOG3YSvvvYUvLYhziAx0DxLALp
         niluqDfDAAl8qEiNi7sM+srpxD5/itFUOakwzQ1s0GcO4chX62IP3a/P8IESBdCCcbw9
         YyjOTU89KzGYU1A9Zst/nUQ+3ZtXF0F/ASCWGS9Q4OBuXUN1qU2B6Cr69mZEBNS0Py09
         H6Gg==
X-Gm-Message-State: APjAAAUiyNrbUpMTchiAW/y+0RjaFTiG15iVnRyQgpwCyQ34+ewoOiEv
        fraEvwma2/JYfd7yoGJMoM+JVA==
X-Google-Smtp-Source: APXvYqzvrf13MUE19LiIf1x3M2bj2D6eaCY1fg59zYnBrXL5jz1U6+gizBe5cXM8McsO2BykNMm8bA==
X-Received: by 2002:ac8:7a9a:: with SMTP id x26mr2526029qtr.251.1565091080543;
        Tue, 06 Aug 2019 04:31:20 -0700 (PDT)
Received: from redhat.com ([147.234.38.1])
        by smtp.gmail.com with ESMTPSA id d31sm44554913qta.39.2019.08.06.04.31.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 04:31:19 -0700 (PDT)
Date:   Tue, 6 Aug 2019 07:31:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        willy@infradead.org, lcapitulino@redhat.com, wei.w.wang@intel.com,
        aarcange@redhat.com, pbonzini@redhat.com, dan.j.williams@intel.com
Subject: Re: [PATCH v3 6/6] virtio-balloon: Add support for providing unused
 page reports to host
Message-ID: <20190806073047-mutt-send-email-mst@kernel.org>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
 <20190801223829.22190.36831.stgit@localhost.localdomain>
 <1cff09a4-d302-639c-ab08-9d82e5fc1383@redhat.com>
 <ed48ecdb833808bf6b08bc54fa98503cbad493f3.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed48ecdb833808bf6b08bc54fa98503cbad493f3.camel@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 05, 2019 at 09:27:16AM -0700, Alexander Duyck wrote:
> On Mon, 2019-08-05 at 12:00 -0400, Nitesh Narayan Lal wrote:
> > On 8/1/19 6:38 PM, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > 
> > > Add support for the page reporting feature provided by virtio-balloon.
> > > Reporting differs from the regular balloon functionality in that is is
> > > much less durable than a standard memory balloon. Instead of creating a
> > > list of pages that cannot be accessed the pages are only inaccessible
> > > while they are being indicated to the virtio interface. Once the
> > > interface has acknowledged them they are placed back into their respective
> > > free lists and are once again accessible by the guest system.
> > > 
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > ---
> > >  drivers/virtio/Kconfig              |    1 +
> > >  drivers/virtio/virtio_balloon.c     |   56 +++++++++++++++++++++++++++++++++++
> > >  include/uapi/linux/virtio_balloon.h |    1 +
> > >  3 files changed, 58 insertions(+)
> > > 
> > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > index 078615cf2afc..4b2dd8259ff5 100644
> > > --- a/drivers/virtio/Kconfig
> > > +++ b/drivers/virtio/Kconfig
> > > @@ -58,6 +58,7 @@ config VIRTIO_BALLOON
> > >  	tristate "Virtio balloon driver"
> > >  	depends on VIRTIO
> > >  	select MEMORY_BALLOON
> > > +	select PAGE_REPORTING
> > >  	---help---
> > >  	 This driver supports increasing and decreasing the amount
> > >  	 of memory within a KVM guest.
> > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > index 2c19457ab573..971fe924e34f 100644
> > > --- a/drivers/virtio/virtio_balloon.c
> > > +++ b/drivers/virtio/virtio_balloon.c
> > > @@ -19,6 +19,7 @@
> > >  #include <linux/mount.h>
> > >  #include <linux/magic.h>
> > >  #include <linux/pseudo_fs.h>
> > > +#include <linux/page_reporting.h>
> > >  
> > >  /*
> > >   * Balloon device works in 4K page units.  So each page is pointed to by
> > > @@ -37,6 +38,9 @@
> > >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> > >  	(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> > >  
> > > +/*  limit on the number of pages that can be on the reporting vq */
> > > +#define VIRTIO_BALLOON_VRING_HINTS_MAX	16
> > > +
> > >  #ifdef CONFIG_BALLOON_COMPACTION
> > >  static struct vfsmount *balloon_mnt;
> > >  #endif
> > > @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
> > >  	VIRTIO_BALLOON_VQ_DEFLATE,
> > >  	VIRTIO_BALLOON_VQ_STATS,
> > >  	VIRTIO_BALLOON_VQ_FREE_PAGE,
> > > +	VIRTIO_BALLOON_VQ_REPORTING,
> > >  	VIRTIO_BALLOON_VQ_MAX
> > >  };
> > >  
> > > @@ -113,6 +118,10 @@ struct virtio_balloon {
> > >  
> > >  	/* To register a shrinker to shrink memory upon memory pressure */
> > >  	struct shrinker shrinker;
> > > +
> > > +	/* Unused page reporting device */
> > > +	struct virtqueue *reporting_vq;
> > > +	struct page_reporting_dev_info ph_dev_info;
> > >  };
> > >  
> > >  static struct virtio_device_id id_table[] = {
> > > @@ -152,6 +161,23 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> > >  
> > >  }
> > >  
> > > +void virtballoon_unused_page_report(struct page_reporting_dev_info *ph_dev_info,
> > > +				    unsigned int nents)
> > > +{
> > > +	struct virtio_balloon *vb =
> > > +		container_of(ph_dev_info, struct virtio_balloon, ph_dev_info);
> > > +	struct virtqueue *vq = vb->reporting_vq;
> > > +	unsigned int unused;
> > > +
> > > +	/* We should always be able to add these buffers to an empty queue. */
> > > +	virtqueue_add_inbuf(vq, ph_dev_info->sg, nents, vb,
> > > +			    GFP_NOWAIT | __GFP_NOWARN);
> > 
> > I think you should handle allocation failure here. It is a possibility, isn't?
> > Maybe return an error or even disable page hinting/reporting?
> > 
> 
> I don't think it is an issue I have to worry about. Specifically I am
> limiting the size of the scatterlist based on the size of the vq. As such
> I will never exceed the size and should be able to use it to store the
> scatterlist directly.

I agree. But it can't hurt to BUG_ON for good measure.

-- 
MST
