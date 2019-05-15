Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F331F92C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfEORNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 13:13:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbfEORNl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 13:13:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FHC19h042603
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 13:13:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sgp1hb69n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 13:13:39 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 15 May 2019 18:13:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 18:13:33 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FHDVoI19071128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 17:13:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1A3011C054;
        Wed, 15 May 2019 17:13:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF5B711C052;
        Wed, 15 May 2019 17:13:30 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.21.52])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 17:13:30 +0000 (GMT)
Date:   Wed, 15 May 2019 19:12:57 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Sebastian Ott <sebott@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
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
        Eric Farman <farman@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: Re: [PATCH 05/10] s390/cio: introduce DMA pools to cio
In-Reply-To: <20190513152924.1e8e8f5a.cohuck@redhat.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-6-pasic@linux.ibm.com>
        <alpine.LFD.2.21.1905081447280.1773@schleppi>
        <20190508232210.5a555caa.pasic@linux.ibm.com>
        <20190509121106.48aa04db.cohuck@redhat.com>
        <20190510001112.479b2fd7.pasic@linux.ibm.com>
        <20190510161013.7e697337.cohuck@redhat.com>
        <20190512202256.5517592d.pasic@linux.ibm.com>
        <20190513152924.1e8e8f5a.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051517-0008-0000-0000-000002E70917
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051517-0009-0000-0000-00002253A9A1
Message-Id: <20190515191257.31bdc583.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 May 2019 15:29:24 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Sun, 12 May 2019 20:22:56 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Fri, 10 May 2019 16:10:13 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > On Fri, 10 May 2019 00:11:12 +0200
> > > Halil Pasic <pasic@linux.ibm.com> wrote:
> > >   
> > > > On Thu, 9 May 2019 12:11:06 +0200
> > > > Cornelia Huck <cohuck@redhat.com> wrote:
> > > >   
> > > > > On Wed, 8 May 2019 23:22:10 +0200
> > > > > Halil Pasic <pasic@linux.ibm.com> wrote:
> > > > >     
> > > > > > On Wed, 8 May 2019 15:18:10 +0200 (CEST)
> > > > > > Sebastian Ott <sebott@linux.ibm.com> wrote:    
> > > > >     
> > > > > > > > @@ -1063,6 +1163,7 @@ static int __init css_bus_init(void)
> > > > > > > >  		unregister_reboot_notifier(&css_reboot_notifier);
> > > > > > > >  		goto out_unregister;
> > > > > > > >  	}
> > > > > > > > +	cio_dma_pool_init();        
> > > > > > > 
> > > > > > > This is too late for early devices (ccw console!).      
> > > > > > 
> > > > > > You have already raised concern about this last time (thanks). I think,
> > > > > > I've addressed this issue: the cio_dma_pool is only used by the airq
> > > > > > stuff. I don't think the ccw console needs it. Please have an other look
> > > > > > at patch #6, and explain your concern in more detail if it persists.    
> > > > > 
> > > > > What about changing the naming/adding comments here, so that (1) folks
> > > > > aren't confused by the same thing in the future and (2) folks don't try
> > > > > to use that pool for something needed for the early ccw consoles?
> > > > >     
> > > > 
> > > > I'm all for clarity! Suggestions for better names?  
> > > 
> > > css_aiv_dma_pool, maybe? Or is there other cross-device stuff that may
> > > need it?
> > >   
> > 
> > Ouch! I was considering to use cio_dma_zalloc() for the adapter
> > interruption vectors but I ended up between the two chairs in the end.
> > So with this series there are no uses for cio_dma pool.
> > 
> > I don't feel strongly about this going one way the other.
> > 
> > Against getting rid of the cio_dma_pool and sticking with the speaks
> > dma_alloc_coherent() that we waste a DMA page per vector, which is a
> > non obvious side effect.
> 
> That would basically mean one DMA page per virtio-ccw device, right?

Not quite: virtio-ccw shares airq vectors among multiple devices. We
alloc 64 bytes a time and use that as long as we don't run out of bits.
 
> For single queue devices, this seems like quite a bit of overhead.
>

Nod.
 
> Are we expecting many devices in use per guest?

This is affect linux in general, not only guest 2 stuff (i.e. we
also waste in vanilla lpar mode). And zpci seems to do at least one
airq_iv_create() per pci function.

> 
> > 
> > What speaks against cio_dma_pool is that it is slightly more code, and
> > this currently can not be used for very early stuff, which I don't
> > think is relevant. 
> 
> Unless properly documented, it feels like something you can easily trip
> over, however.
> 
> I assume that the "very early stuff" is basically only ccw consoles.
> Not sure if we can use virtio-serial as an early ccw console -- IIRC
> that was only about 3215/3270? While QEMU guests are able to use a 3270
> console, this is experimental and I would not count that as a use case.
> Anyway, 3215/3270 don't use adapter interrupts, and probably not
> anything cross-device, either; so unless early virtio-serial is a
> thing, this restriction is fine if properly documented.
> 

Mimu can you dig into this a bit?

We could also aim for getting rid of this limitation. One idea would be
some sort of lazy initialization (i.e. triggered by first usage).
Another idea would be simply doing the initialization earlier.
Unfortunately I'm not all that familiar with the early stuff. Is there
some doc you can recommend?

Anyway before investing much more into this, I think we should have a
fair idea which option do we prefer...

> > What also used to speak against it is that
> > allocations asking for more than a page would just fail, but I addressed
> > that in the patch I've hacked up on top of the series, and I'm going to
> > paste below. While at it I addressed some other issues as well.
> 
> Hm, which "other issues"?
> 

The kfree() I've forgotten to get rid of, and this 'document does not
work early' (pun intended) business.

> > 
> > I've also got code that deals with AIRQ_IV_CACHELINE by turning the
> > kmem_cache into a dma_pool.
> 
> Isn't that percolating to other airq users again? Or maybe I just don't
> understand what you're proposing here...

Absolutely.

> 
> > 
> > Cornelia, Sebastian which approach do you prefer:
> > 1) get rid of cio_dma_pool and AIRQ_IV_CACHELINE, and waste a page per
> > vector, or
> > 2) go with the approach taken by the patch below?
> 
> I'm not sure that I properly understand this (yeah, you probably
> guessed); so I'm not sure I can make a good call here.
> 

I hope you, I managed to clarify some of the questions. Please keep
asking if stuff remains unclear. I'm not a great communicator, but a
quite tenacious one.

I hope Sebastian will chime in as well.

> > 
> > 
> > Regards,
> > Halil
> > -----------------------8<---------------------------------------------
> > From: Halil Pasic <pasic@linux.ibm.com>
> > Date: Sun, 12 May 2019 18:08:05 +0200
> > Subject: [PATCH] WIP: use cio dma pool for airqs
> > 
> > Let's not waste a DMA page per adapter interrupt bit vector.
> > ---
> > Lightly tested...
> > ---
> >  arch/s390/include/asm/airq.h |  1 -
> >  drivers/s390/cio/airq.c      | 10 +++-------
> >  drivers/s390/cio/css.c       | 18 +++++++++++++++---
> >  3 files changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/airq.h b/arch/s390/include/asm/airq.h
> > index 1492d48..981a3eb 100644
> > --- a/arch/s390/include/asm/airq.h
> > +++ b/arch/s390/include/asm/airq.h
> > @@ -30,7 +30,6 @@ void unregister_adapter_interrupt(struct airq_struct *airq);
> >  /* Adapter interrupt bit vector */
> >  struct airq_iv {
> >  	unsigned long *vector;	/* Adapter interrupt bit vector */
> > -	dma_addr_t vector_dma; /* Adapter interrupt bit vector dma */
> >  	unsigned long *avail;	/* Allocation bit mask for the bit vector */
> >  	unsigned long *bitlock;	/* Lock bit mask for the bit vector */
> >  	unsigned long *ptr;	/* Pointer associated with each bit */
> > diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
> > index 7a5c0a0..f11f437 100644
> > --- a/drivers/s390/cio/airq.c
> > +++ b/drivers/s390/cio/airq.c
> > @@ -136,8 +136,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
> >  		goto out;
> >  	iv->bits = bits;
> >  	size = iv_size(bits);
> > -	iv->vector = dma_alloc_coherent(cio_get_dma_css_dev(), size,
> > -						 &iv->vector_dma, GFP_KERNEL);
> > +	iv->vector = cio_dma_zalloc(size);
> >  	if (!iv->vector)
> >  		goto out_free;
> >  	if (flags & AIRQ_IV_ALLOC) {
> > @@ -172,8 +171,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
> >  	kfree(iv->ptr);
> >  	kfree(iv->bitlock);
> >  	kfree(iv->avail);
> > -	dma_free_coherent(cio_get_dma_css_dev(), size, iv->vector,
> > -			  iv->vector_dma);
> > +	cio_dma_free(iv->vector, size);
> >  	kfree(iv);
> >  out:
> >  	return NULL;
> > @@ -189,9 +187,7 @@ void airq_iv_release(struct airq_iv *iv)
> >  	kfree(iv->data);
> >  	kfree(iv->ptr);
> >  	kfree(iv->bitlock);
> > -	kfree(iv->vector);
> > -	dma_free_coherent(cio_get_dma_css_dev(), iv_size(iv->bits),
> > -			  iv->vector, iv->vector_dma);
> > +	cio_dma_free(iv->vector, iv_size(iv->bits));
> >  	kfree(iv->avail);
> >  	kfree(iv);
> >  }
> > diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> > index 7087cc3..88d9c92 100644
> > --- a/drivers/s390/cio/css.c
> > +++ b/drivers/s390/cio/css.c
> > @@ -1063,7 +1063,10 @@ struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages)
> >  static void __gp_dma_free_dma(struct gen_pool *pool,
> >  			      struct gen_pool_chunk *chunk, void *data)
> >  {
> > -	dma_free_coherent((struct device *) data, PAGE_SIZE,
> > +
> > +	size_t chunk_size = chunk->end_addr - chunk->start_addr + 1;
> > +
> > +	dma_free_coherent((struct device *) data, chunk_size,
> >  			 (void *) chunk->start_addr,
> >  			 (dma_addr_t) chunk->phys_addr);
> >  }
> > @@ -1088,13 +1091,15 @@ void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
> >  {
> >  	dma_addr_t dma_addr;
> >  	unsigned long addr = gen_pool_alloc(gp_dma, size);
> > +	size_t chunk_size;
> >  
> >  	if (!addr) {
> > +		chunk_size = round_up(size, PAGE_SIZE);
> 
> Doesn't that mean that we still go up to chunks of at least PAGE_SIZE?
> Or can vectors now share the same chunk?

Exactly! We put the allocated dma mem into the genpool. So if the next
request can be served from what is already in the genpool we don't end
up in this fallback path where we grow the pool. 

> 
> >  		addr = (unsigned long) dma_alloc_coherent(dma_dev,
> > -					PAGE_SIZE, &dma_addr, CIO_DMA_GFP);
> > +					 chunk_size, &dma_addr, CIO_DMA_GFP);
> >  		if (!addr)
> >  			return NULL;
> > -		gen_pool_add_virt(gp_dma, addr, dma_addr, PAGE_SIZE, -1);
> > +		gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
> >  		addr = gen_pool_alloc(gp_dma, size);

BTW I think it would be good to recover from this alloc failing due to a
race (qute unlikely with small allocations thogh...).

> >  	}
> >  	return (void *) addr;
> > @@ -1108,6 +1113,13 @@ void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
> >  	gen_pool_free(gp_dma, (unsigned long) cpu_addr, size);
> >  }
> >  
> > +/**
> > + * Allocate dma memory from the css global pool. Intended for memory not
> > + * specific to any single device within the css.
> > + *
> > + * Caution: Not suitable for early stuff like console.
> 
> Maybe add "Do not use prior to <point in startup>"?
> 

I'm not awfully familiar with the well known 'points in startup'. Can
you recommend me some documentation on this topic?


Regards,
Halil

> > + *
> > + */
> >  void *cio_dma_zalloc(size_t size)
> >  {
> >  	return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);
> 

