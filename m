Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2BD3D211
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405563AbfFKQUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 12:20:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405444AbfFKQUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 12:20:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2FC537E8E;
        Tue, 11 Jun 2019 16:19:54 +0000 (UTC)
Received: from gondolin (ovpn-204-147.brq.redhat.com [10.40.204.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 276BD5DD8D;
        Tue, 11 Jun 2019 16:19:47 +0000 (UTC)
Date:   Tue, 11 Jun 2019 18:19:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
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
Message-ID: <20190611181944.5bf2b953.cohuck@redhat.com>
In-Reply-To: <20190611162721.67ca8932.pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
        <20190606115127.55519-5-pasic@linux.ibm.com>
        <20190611121721.61bf09b4.cohuck@redhat.com>
        <20190611162721.67ca8932.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 11 Jun 2019 16:20:03 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 16:27:21 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Tue, 11 Jun 2019 12:17:21 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Thu,  6 Jun 2019 13:51:23 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >   
> > > Protected virtualization guests have to use shared pages for airq
> > > notifier bit vectors, because hypervisor needs to write these bits.
> > > 
> > > Let us make sure we allocate DMA memory for the notifier bit vectors by
> > > replacing the kmem_cache with a dma_cache and kalloc() with
> > > cio_dma_zalloc().
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> > > ---
> > >  arch/s390/include/asm/airq.h |  2 ++
> > >  drivers/s390/cio/airq.c      | 32 ++++++++++++++++++++------------
> > >  drivers/s390/cio/cio.h       |  2 ++
> > >  drivers/s390/cio/css.c       |  1 +
> > >  4 files changed, 25 insertions(+), 12 deletions(-)
> > >   
> > 
> > (...)
> >   
> > > @@ -295,12 +303,12 @@ unsigned long airq_iv_scan(struct airq_iv *iv, unsigned long start,
> > >  }
> > >  EXPORT_SYMBOL(airq_iv_scan);
> > >  
> > > -static int __init airq_init(void)
> > > +int __init airq_init(void)
> > >  {
> > > -	airq_iv_cache = ) "airq_iv_cache", cache_line_size(),
> > > -					  cache_line_size(), 0, NULL);
> > > +	airq_iv_cache = dma_pool_create("airq_iv_cache", cio_get_dma_css_dev(),
> > > +					cache_line_size(),
> > > +					cache_line_size(), PAGE_SIZE);
> > >  	if (!airq_iv_cache)
> > >  		return -ENOMEM;  
> > 
> > Sorry about not noticing that in the last iteration; but you may return
> > an error here if airq_iv_cache could not be allocated...
> >   
> > >  	return 0;
> > >  }
> > > -subsys_initcall(airq_init);  
> > 
> > (...)
> >   
> > > diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> > > index 6fc91d534af1..7901c8ed3597 100644
> > > --- a/drivers/s390/cio/css.c
> > > +++ b/drivers/s390/cio/css.c
> > > @@ -1182,6 +1182,7 @@ static int __init css_bus_init(void)
> > >  	ret = cio_dma_pool_init();
> > >  	if (ret)
> > >  		goto out_unregister_pmn;
> > > +	airq_init();  
> > 
> > ...but don't check the return code here. Probably a pathological case,
> > but shouldn't you handle that error as well?
> >   
> 
> Tricky business... The problem is that the airq stuff ain't 'private' to
> the CIO subsystem (e.g. zPCI). I'm afraid failing to init css won't
> really prevent all usages.

Architecture-wise, there's an unfortunate tie-in of some things like
zPCI with the channel subsystem (most of that seems to come in via chsc
and machine checks; but as you say, airq as well). I'd basically
consider css to be a base system for virtually any I/O on s390...

> 
> My first thought was, that this is more or less analogous to what we
> had before. Namely kmem_cache_create() and dma_pool_create() should fail
> under similar circumstances, and the return value of airq_init() was
> ignored in do_initcall_level(). So I was like ignoring it seems to be
> consistent with previous state.
> 
> But, ouch, there is a big difference! While kmem_cache_zalloc() seems
> to tolerate the first argument (pointer to kmem_cache) being NULL the
> dma_pool_zalloc() does not.

Yeah. While previously continuing with a failed allocation simply was
not very workable, now we actually would end up with crashes :(

> 
> IMHO the cleanest thing to do at this stage is to check if the
> airq_iv_cache is NULL and fail the allocation if it is (to preserve
> previous behavior).

That's probably the least invasive fix for now. Did you check whether
any of the other dma pools this series introduces have a similar
problem due to init not failing?

> 
> I would prefer having a separate discussion on eventually changing
> the behavior (e.g. fail css initialization).

I did a quick check of the common I/O layer code and one place that
looks dangerous is the chsc initialization (where we get two pages that
are later accessed unconditionally by the code).

All of this is related to not being able to fulfill some basic memory
availability requirements early during boot and then discovering that
pulling the emergency break did not actually stop the train. I'd vote
for calling panic() if the common I/O layer cannot perform its setup;
but as this is really a pathological case I also think we should solve
that independently of this patch series.

> 
> Connie, would that work with you? Thanks for spotting this!

Yeah, let's give your approach a try.
