Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBBC2B372
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 13:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfE0LsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 07:48:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbfE0LsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 May 2019 07:48:07 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4RBkJdZ062173
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:48:06 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2srfafr1a8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 07:48:05 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 27 May 2019 12:48:03 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 12:48:00 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RBlwsp37617850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 11:47:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4755C42047;
        Mon, 27 May 2019 11:47:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DA8D42045;
        Mon, 27 May 2019 11:47:57 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.72.200])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 May 2019 11:47:57 +0000 (GMT)
Date:   Mon, 27 May 2019 13:47:55 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
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
In-Reply-To: <20190527085718.10494ee2.cohuck@redhat.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
        <20190523162209.9543-3-mimu@linux.ibm.com>
        <20190527085718.10494ee2.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052711-0028-0000-0000-00000371E62D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052711-0029-0000-0000-00002431A286
Message-Id: <20190527134755.4937238c.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 May 2019 08:57:18 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 23 May 2019 18:22:03 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
> > From: Halil Pasic <pasic@linux.ibm.com>
> > 
> > To support protected virtualization cio will need to make sure the
> > memory used for communication with the hypervisor is DMA memory.
> > 
> > Let us introduce one global cio, and some tools for pools seated
> 
> "one global pool for cio"?
> 

Nod.

> > at individual devices.
> > 
> > Our DMA pools are implemented as a gen_pool backed with DMA pages. The
> > idea is to avoid each allocation effectively wasting a page, as we
> > typically allocate much less than PAGE_SIZE.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > ---
> >  arch/s390/Kconfig           |   1 +
> >  arch/s390/include/asm/cio.h |  11 +++++
> >  drivers/s390/cio/css.c      | 110 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 122 insertions(+)
> > 
> 
> (...)
> 
> > @@ -1018,6 +1024,109 @@ static struct notifier_block css_power_notifier = {
> >  	.notifier_call = css_power_event,
> >  };
> >  
> > +#define POOL_INIT_PAGES 1
> > +static struct gen_pool *cio_dma_pool;
> > +/* Currently cio supports only a single css */
> 
> This comment looks misplaced.

Right! Move to ...

> 
> > +#define  CIO_DMA_GFP (GFP_KERNEL | __GFP_ZERO)
> > +
> > +

... here?

> > +struct device *cio_get_dma_css_dev(void)
> > +{
> > +	return &channel_subsystems[0]->device;
> > +}
> > +
> > +struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages)
> > +{
> > +	struct gen_pool *gp_dma;
> > +	void *cpu_addr;
> > +	dma_addr_t dma_addr;
> > +	int i;
> > +
> > +	gp_dma = gen_pool_create(3, -1);
> > +	if (!gp_dma)
> > +		return NULL;
> > +	for (i = 0; i < nr_pages; ++i) {
> > +		cpu_addr = dma_alloc_coherent(dma_dev, PAGE_SIZE, &dma_addr,
> > +					      CIO_DMA_GFP);
> > +		if (!cpu_addr)
> > +			return gp_dma;
> 
> So, you may return here with no memory added to the pool at all (or
> less than requested), but for the caller that is indistinguishable from
> an allocation that went all right. May that be a problem?
> 

I do not think it can cause a problem: cio_gp_dma_zalloc() is going to
try to allocate the memory required and put it in the pool. If that
fails as well, we return a NULL pointer like kmalloc(). So I think we
are clean.

> > +		gen_pool_add_virt(gp_dma, (unsigned long) cpu_addr,
> > +				  dma_addr, PAGE_SIZE, -1);
> > +	}
> > +	return gp_dma;
> > +}
> > +
> 
> (...)
> 
> > +static void __init cio_dma_pool_init(void)
> > +{
> > +	/* No need to free up the resources: compiled in */
> > +	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);
> 
> Does it make sense to continue if you did not get a pool here? I don't
> think that should happen unless things were really bad already?
> 

I agree, this should not fail under any sane circumstances. I don't
think it makes sense to continue. Shall we simply call panic()?

> > +}
> > +
> > +void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
> > +			size_t size)
> > +{
> > +	dma_addr_t dma_addr;
> > +	unsigned long addr;
> > +	size_t chunk_size;
> > +
> > +	addr = gen_pool_alloc(gp_dma, size);
> > +	while (!addr) {
> > +		chunk_size = round_up(size, PAGE_SIZE);
> > +		addr = (unsigned long) dma_alloc_coherent(dma_dev,
> > +					 chunk_size, &dma_addr, CIO_DMA_GFP);
> > +		if (!addr)
> > +			return NULL;
> > +		gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
> > +		addr = gen_pool_alloc(gp_dma, size);
> > +	}
> > +	return (void *) addr;
> > +}
> > +
> > +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
> > +{
> > +	if (!cpu_addr)
> > +		return;
> > +	memset(cpu_addr, 0, size);
> > +	gen_pool_free(gp_dma, (unsigned long) cpu_addr, size);
> > +}
> > +
> > +/**
> > + * Allocate dma memory from the css global pool. Intended for memory not
> > + * specific to any single device within the css. The allocated memory
> > + * is not guaranteed to be 31-bit addressable.
> > + *
> > + * Caution: Not suitable for early stuff like console.
> > + *
> > + */
> > +void *cio_dma_zalloc(size_t size)
> > +{
> > +	return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);
> 
> Ok, that looks like the failure I mentioned above should be
> accommodated by the code. Still, I think it's a bit odd.
> 

I think the behavior is reasonable: if client code wants pre-allocate n
page sized chunks we pre-allocate as may as we can. If we can't
pre-allocate all n, it ain't necessarily bad. There is no guarantee we
will hit a wall in a non-recoverable fashion.

But if you insist, I can get rid of the pre-allocation or fail create and
do a rollback if it fails.

Thanks for having a look!

Regards,
Halil

> > +}
> 

