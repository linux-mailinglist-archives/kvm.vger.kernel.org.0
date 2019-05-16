Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DE01FF90
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 08:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfEPG3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 02:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbfEPG3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 02:29:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00E99300BCE9;
        Thu, 16 May 2019 06:29:40 +0000 (UTC)
Received: from gondolin (ovpn-204-119.brq.redhat.com [10.40.204.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BCCC6A24F;
        Thu, 16 May 2019 06:29:32 +0000 (UTC)
Date:   Thu, 16 May 2019 08:29:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
Message-ID: <20190516082928.1371696b.cohuck@redhat.com>
In-Reply-To: <20190515225158.301af387.pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-7-pasic@linux.ibm.com>
        <20190513114136.783c851c.cohuck@redhat.com>
        <20190515225158.301af387.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 16 May 2019 06:29:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 May 2019 22:51:58 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 13 May 2019 11:41:36 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Fri, 26 Apr 2019 20:32:41 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> > > As virtio-ccw devices are channel devices, we need to use the dma area
> > > for any communication with the hypervisor.
> > > 
> > > This patch addresses the most basic stuff (mostly what is required for
> > > virtio-ccw), and does take care of QDIO or any devices.  
> > 
> > "does not take care of QDIO", surely?   
> 
> I did not bother making the QDIO library code use dma memory for
> anything that is conceptually dma memory. AFAIK QDIO is out of scope for
> prot virt for now. If one were to do some emulated qdio with prot virt
> guests, one wound need to make a bunch of things shared.

And unless you wanted to support protected virt under z/VM as well, it
would be wasted effort :)

> 
> > (Also, what does "any devices"
> > mean? Do you mean "every arbitrary device", perhaps?)  
> 
> What I mean is: this patch takes care of the core stuff, but any
> particular device is likely to have to do more -- that is it ain't all
> the cio devices support prot virt with this patch. For example
> virtio-ccw needs to make sure that the ccws constituting the channel
> programs, as well as the data pointed by the ccws is shared. If one
> would want to make vfio-ccw DASD pass-through work under prot virt, one
> would need to make sure, that everything that needs to be shared is
> shared (data buffers, channel programs).
> 
> Does is clarify things?

That's what I thought, but the sentence was confusing :) What about

"This patch addresses the most basic stuff (mostly what is required to
support virtio-ccw devices). It handles neither QDIO devices, nor
arbitrary non-virtio-ccw devices." ?

> 
> >   
> > > 
> > > An interesting side effect is that virtio structures are now going to
> > > get allocated in 31 bit addressable storage.  
> > 
> > Hm...
> >   
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > ---
> > >  arch/s390/include/asm/ccwdev.h   |  4 +++
> > >  drivers/s390/cio/ccwreq.c        |  8 ++---
> > >  drivers/s390/cio/device.c        | 65 +++++++++++++++++++++++++++++++++-------
> > >  drivers/s390/cio/device_fsm.c    | 40 ++++++++++++-------------
> > >  drivers/s390/cio/device_id.c     | 18 +++++------
> > >  drivers/s390/cio/device_ops.c    | 21 +++++++++++--
> > >  drivers/s390/cio/device_pgid.c   | 20 ++++++-------
> > >  drivers/s390/cio/device_status.c | 24 +++++++--------
> > >  drivers/s390/cio/io_sch.h        | 21 +++++++++----
> > >  drivers/s390/virtio/virtio_ccw.c | 10 -------
> > >  10 files changed, 148 insertions(+), 83 deletions(-)  
> > 
> > (...)
> >   
> > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > > index 6d989c360f38..bb7a92316fc8 100644
> > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > @@ -66,7 +66,6 @@ struct virtio_ccw_device {
> > >  	bool device_lost;
> > >  	unsigned int config_ready;
> > >  	void *airq_info;
> > > -	u64 dma_mask;
> > >  };
> > >  
> > >  struct vq_info_block_legacy {
> > > @@ -1255,16 +1254,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
> > >  		ret = -ENOMEM;
> > >  		goto out_free;
> > >  	}
> > > -
> > >  	vcdev->vdev.dev.parent = &cdev->dev;
> > > -	cdev->dev.dma_mask = &vcdev->dma_mask;
> > > -	/* we are fine with common virtio infrastructure using 64 bit DMA */
> > > -	ret = dma_set_mask_and_coherent(&cdev->dev, DMA_BIT_MASK(64));
> > > -	if (ret) {
> > > -		dev_warn(&cdev->dev, "Failed to enable 64-bit DMA.\n");
> > > -		goto out_free;
> > > -	}  
> > 
> > This means that vring structures now need to fit into 31 bits as well,
> > I think?  
> 
> Nod.
> 
> > Is there any way to reserve the 31 bit restriction for channel
> > subsystem structures and keep vring in the full 64 bit range? (Or am I
> > fundamentally misunderstanding something?)
> >   
> 
> At the root of this problem is that the DMA API basically says devices
> may have addressing limitations expressed by the dma_mask, while our
> addressing limitations are not coming from the device but from the IO
> arch: e.g. orb.cpa and ccw.cda are 31 bit addresses. In our case it
> depends on how and for what is the device going to use the memory (e.g.
> buffers addressed by MIDA vs IDA vs direct).
> 
> Virtio uses the DMA properties of the parent, that is in our case the
> struct device embedded in struct ccw_device.
> 
> The previous version (RFC) used to allocate all the cio DMA stuff from
> this global cio_dma_pool using the css0.dev for the DMA API
> interactions. And we set *css0.dev.dma_mask == DMA_BIT_MASK(31) so
> e.g. the allocated ccws are 31 bit addressable.
> 
> But I was asked to change this so that when I allocate DMA memory for a
> channel program of particular ccw device, a struct device of that ccw
> device is used as the first argument of dma_alloc_coherent().
> 
> Considering
> 
> void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
>                 gfp_t flag, unsigned long attrs)
> {
>         const struct dma_map_ops *ops = get_dma_ops(dev);
>         void *cpu_addr;
> 
>         WARN_ON_ONCE(dev && !dev->coherent_dma_mask);
> 
>         if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr))
>                 return cpu_addr;
> 
>         /* let the implementation decide on the zone to allocate from: */
>         flag &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
> 
> that is the GFP flags dropped that implies that we really want
> cdev->dev restricted to 31 bit addressable memory because we can't tell
> (with the current common DMA code) hey but this piece of DMA mem you
> are abot to allocate for me must be 31 bit addressable (using GFP_DMA
> as we usually do).
> 
> So, as described in the commit message, the vring stuff being forced
> into ZONE_DMA is an unfortunate consequence of this all.

Yeah. I hope 31 bits are enough for that as well.

> 
> A side note: making the subchannel device 'own' the DMA stuff of a ccw
> device (something that was discussed in the RFC thread) is tricky
> because the ccw device may outlive the subchannel (all that orphan
> stuff).

Yes, that's... eww. Not really a problem for virtio-ccw devices (which
do not support the disconnected state), but can we make DMA and the
subchannel moving play nice with each other at all?

> 
> So the answer is: it is technically possible (e.g. see RFC) but it comes
> at a price, and I see no obviously brilliant solution.
> 
> Regards,
> Halil
> 
> > > -
> > >  	vcdev->config_block = kzalloc(sizeof(*vcdev->config_block),
> > >  				   GFP_DMA | GFP_KERNEL);
> > >  	if (!vcdev->config_block) {  
> >   
> 

