Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398EE3CEA6
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390069AbfFKO1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 10:27:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388676AbfFKO1k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jun 2019 10:27:40 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BEEoeL012105
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 10:27:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2dchtf7w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 10:27:39 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 11 Jun 2019 15:27:37 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 15:27:34 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BERWwL26476688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 14:27:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 257464204C;
        Tue, 11 Jun 2019 14:27:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87C0A42047;
        Tue, 11 Jun 2019 14:27:31 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.168])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 14:27:31 +0000 (GMT)
Date:   Tue, 11 Jun 2019 16:27:21 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: Re: [PATCH v4 4/8] s390/airq: use DMA memory for adapter interrupts
In-Reply-To: <20190611121721.61bf09b4.cohuck@redhat.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
        <20190606115127.55519-5-pasic@linux.ibm.com>
        <20190611121721.61bf09b4.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061114-0008-0000-0000-000002F254B9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061114-0009-0000-0000-0000225F4FF5
Message-Id: <20190611162721.67ca8932.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 12:17:21 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu,  6 Jun 2019 13:51:23 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > Protected virtualization guests have to use shared pages for airq
> > notifier bit vectors, because hypervisor needs to write these bits.
> > 
> > Let us make sure we allocate DMA memory for the notifier bit vectors by
> > replacing the kmem_cache with a dma_cache and kalloc() with
> > cio_dma_zalloc().
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/airq.h |  2 ++
> >  drivers/s390/cio/airq.c      | 32 ++++++++++++++++++++------------
> >  drivers/s390/cio/cio.h       |  2 ++
> >  drivers/s390/cio/css.c       |  1 +
> >  4 files changed, 25 insertions(+), 12 deletions(-)
> > 
> 
> (...)
> 
> > @@ -295,12 +303,12 @@ unsigned long airq_iv_scan(struct airq_iv *iv, unsigned long start,
> >  }
> >  EXPORT_SYMBOL(airq_iv_scan);
> >  
> > -static int __init airq_init(void)
> > +int __init airq_init(void)
> >  {
> > -	airq_iv_cache = ) "airq_iv_cache", cache_line_size(),
> > -					  cache_line_size(), 0, NULL);
> > +	airq_iv_cache = dma_pool_create("airq_iv_cache", cio_get_dma_css_dev(),
> > +					cache_line_size(),
> > +					cache_line_size(), PAGE_SIZE);
> >  	if (!airq_iv_cache)
> >  		return -ENOMEM;
> 
> Sorry about not noticing that in the last iteration; but you may return
> an error here if airq_iv_cache could not be allocated...
> 
> >  	return 0;
> >  }
> > -subsys_initcall(airq_init);
> 
> (...)
> 
> > diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> > index 6fc91d534af1..7901c8ed3597 100644
> > --- a/drivers/s390/cio/css.c
> > +++ b/drivers/s390/cio/css.c
> > @@ -1182,6 +1182,7 @@ static int __init css_bus_init(void)
> >  	ret = cio_dma_pool_init();
> >  	if (ret)
> >  		goto out_unregister_pmn;
> > +	airq_init();
> 
> ...but don't check the return code here. Probably a pathological case,
> but shouldn't you handle that error as well?
> 

Tricky business... The problem is that the airq stuff ain't 'private' to
the CIO subsystem (e.g. zPCI). I'm afraid failing to init css won't
really prevent all usages.

My first thought was, that this is more or less analogous to what we
had before. Namely kmem_cache_create() and dma_pool_create() should fail
under similar circumstances, and the return value of airq_init() was
ignored in do_initcall_level(). So I was like ignoring it seems to be
consistent with previous state.

But, ouch, there is a big difference! While kmem_cache_zalloc() seems
to tolerate the first argument (pointer to kmem_cache) being NULL the
dma_pool_zalloc() does not.

IMHO the cleanest thing to do at this stage is to check if the
airq_iv_cache is NULL and fail the allocation if it is (to preserve
previous behavior).

I would prefer having a separate discussion on eventually changing
the behavior (e.g. fail css initialization).

Connie, would that work with you? Thanks for spotting this!

Regards,
Halil

> >  	css_init_done = 1;
> >  
> >  	/* Enable default isc for I/O subchannels. */
> 

