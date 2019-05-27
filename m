Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CD42B462
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfE0MG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbfE0MG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 08:06:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 893513086224;
        Mon, 27 May 2019 12:06:55 +0000 (UTC)
Received: from gondolin (ovpn-204-109.brq.redhat.com [10.40.204.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E88CC5D9DE;
        Mon, 27 May 2019 12:06:47 +0000 (UTC)
Date:   Mon, 27 May 2019 14:06:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v2 2/8] s390/cio: introduce DMA pools to cio
Message-ID: <20190527140644.68022444.cohuck@redhat.com>
In-Reply-To: <20190527134755.4937238c.pasic@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
        <20190523162209.9543-3-mimu@linux.ibm.com>
        <20190527085718.10494ee2.cohuck@redhat.com>
        <20190527134755.4937238c.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 27 May 2019 12:06:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 May 2019 13:47:55 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 27 May 2019 08:57:18 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Thu, 23 May 2019 18:22:03 +0200
> > Michael Mueller <mimu@linux.ibm.com> wrote:
> >   
> > > From: Halil Pasic <pasic@linux.ibm.com>
> > > 
> > > To support protected virtualization cio will need to make sure the
> > > memory used for communication with the hypervisor is DMA memory.
> > > 
> > > Let us introduce one global cio, and some tools for pools seated  
> > 
> > "one global pool for cio"?
> >   
> 
> Nod.
> 
> > > at individual devices.
> > > 
> > > Our DMA pools are implemented as a gen_pool backed with DMA pages. The
> > > idea is to avoid each allocation effectively wasting a page, as we
> > > typically allocate much less than PAGE_SIZE.
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > ---
> > >  arch/s390/Kconfig           |   1 +
> > >  arch/s390/include/asm/cio.h |  11 +++++
> > >  drivers/s390/cio/css.c      | 110 ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 122 insertions(+)
> > >   
> > 
> > (...)
> >   
> > > @@ -1018,6 +1024,109 @@ static struct notifier_block css_power_notifier = {
> > >  	.notifier_call = css_power_event,
> > >  };
> > >  
> > > +#define POOL_INIT_PAGES 1
> > > +static struct gen_pool *cio_dma_pool;
> > > +/* Currently cio supports only a single css */  
> > 
> > This comment looks misplaced.  
> 
> Right! Move to ...
> 
> >   
> > > +#define  CIO_DMA_GFP (GFP_KERNEL | __GFP_ZERO)
> > > +
> > > +  
> 
> ... here?

Yes :)

> 
> > > +struct device *cio_get_dma_css_dev(void)
> > > +{
> > > +	return &channel_subsystems[0]->device;
> > > +}
> > > +
> > > +struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages)
> > > +{
> > > +	struct gen_pool *gp_dma;
> > > +	void *cpu_addr;
> > > +	dma_addr_t dma_addr;
> > > +	int i;
> > > +
> > > +	gp_dma = gen_pool_create(3, -1);
> > > +	if (!gp_dma)
> > > +		return NULL;
> > > +	for (i = 0; i < nr_pages; ++i) {
> > > +		cpu_addr = dma_alloc_coherent(dma_dev, PAGE_SIZE, &dma_addr,
> > > +					      CIO_DMA_GFP);
> > > +		if (!cpu_addr)
> > > +			return gp_dma;  
> > 
> > So, you may return here with no memory added to the pool at all (or
> > less than requested), but for the caller that is indistinguishable from
> > an allocation that went all right. May that be a problem?
> >   
> 
> I do not think it can cause a problem: cio_gp_dma_zalloc() is going to
> try to allocate the memory required and put it in the pool. If that
> fails as well, we return a NULL pointer like kmalloc(). So I think we
> are clean.
> 
> > > +		gen_pool_add_virt(gp_dma, (unsigned long) cpu_addr,
> > > +				  dma_addr, PAGE_SIZE, -1);
> > > +	}
> > > +	return gp_dma;
> > > +}
> > > +  
> > 
> > (...)
> >   
> > > +static void __init cio_dma_pool_init(void)
> > > +{
> > > +	/* No need to free up the resources: compiled in */
> > > +	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);  
> > 
> > Does it make sense to continue if you did not get a pool here? I don't
> > think that should happen unless things were really bad already?
> >   
> 
> I agree, this should not fail under any sane circumstances. I don't
> think it makes sense to continue. Shall we simply call panic()?

Can we continue without the common I/O layer? Probably not. It might
really be an 'oh crap, let's panic' situation.

> 
> > > +}
> > > +
> > > +void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
> > > +			size_t size)
> > > +{
> > > +	dma_addr_t dma_addr;
> > > +	unsigned long addr;
> > > +	size_t chunk_size;
> > > +
> > > +	addr = gen_pool_alloc(gp_dma, size);
> > > +	while (!addr) {
> > > +		chunk_size = round_up(size, PAGE_SIZE);
> > > +		addr = (unsigned long) dma_alloc_coherent(dma_dev,
> > > +					 chunk_size, &dma_addr, CIO_DMA_GFP);
> > > +		if (!addr)
> > > +			return NULL;
> > > +		gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
> > > +		addr = gen_pool_alloc(gp_dma, size);
> > > +	}
> > > +	return (void *) addr;
> > > +}
> > > +
> > > +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
> > > +{
> > > +	if (!cpu_addr)
> > > +		return;
> > > +	memset(cpu_addr, 0, size);
> > > +	gen_pool_free(gp_dma, (unsigned long) cpu_addr, size);
> > > +}
> > > +
> > > +/**
> > > + * Allocate dma memory from the css global pool. Intended for memory not
> > > + * specific to any single device within the css. The allocated memory
> > > + * is not guaranteed to be 31-bit addressable.
> > > + *
> > > + * Caution: Not suitable for early stuff like console.
> > > + *
> > > + */
> > > +void *cio_dma_zalloc(size_t size)
> > > +{
> > > +	return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);  
> > 
> > Ok, that looks like the failure I mentioned above should be
> > accommodated by the code. Still, I think it's a bit odd.
> >   
> 
> I think the behavior is reasonable: if client code wants pre-allocate n
> page sized chunks we pre-allocate as may as we can. If we can't
> pre-allocate all n, it ain't necessarily bad. There is no guarantee we
> will hit a wall in a non-recoverable fashion.

It's not necessarily broken, but there are two things that feel a bit
weird to me:
- The caller doesn't know if the requested pre-allocation worked or not.
- If we can't get memory in this early init phase, is it likely that we
  can get memory later on?

> 
> But if you insist, I can get rid of the pre-allocation or fail create and
> do a rollback if it fails.
> 
> Thanks for having a look!
> 
> Regards,
> Halil
> 
> > > +}  
> >   
> 

