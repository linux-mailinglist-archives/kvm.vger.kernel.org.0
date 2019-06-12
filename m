Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7B441C22
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 08:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbfFLGVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 02:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730975AbfFLGVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 02:21:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7B5330872D9;
        Wed, 12 Jun 2019 06:21:39 +0000 (UTC)
Received: from gondolin (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 254E617586;
        Wed, 12 Jun 2019 06:21:31 +0000 (UTC)
Date:   Wed, 12 Jun 2019 08:21:27 +0200
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
Message-ID: <20190612082127.3fd63091.cohuck@redhat.com>
In-Reply-To: <20190612023231.7da4908c.pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
        <20190606115127.55519-5-pasic@linux.ibm.com>
        <20190611121721.61bf09b4.cohuck@redhat.com>
        <20190611162721.67ca8932.pasic@linux.ibm.com>
        <20190611181944.5bf2b953.cohuck@redhat.com>
        <20190612023231.7da4908c.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 12 Jun 2019 06:21:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 02:32:31 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Tue, 11 Jun 2019 18:19:44 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Tue, 11 Jun 2019 16:27:21 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:

> > > IMHO the cleanest thing to do at this stage is to check if the
> > > airq_iv_cache is NULL and fail the allocation if it is (to preserve
> > > previous behavior).  
> > 
> > That's probably the least invasive fix for now. Did you check whether
> > any of the other dma pools this series introduces have a similar
> > problem due to init not failing?
> >  
> 
> Good question!
> 
> I did a quick check. virtio_ccw_init() should be OK, because we don't
> register the driver if allocation fails, so the thing is going to end
> up dysfunctional as expected.
> 
> If however cio_dma_pool_init() fails, then we end up with the same
> problem with airqs, just on the !AIRQ_IV_CACHELINE code path. It can be
> fixed analogously: make cio_dma_zalloc() fail all allocation if
> cio_dma_pool_init() failed before.

Ok, makes sense.

> 
> The rest should be OK.
> 
> > > 
> > > I would prefer having a separate discussion on eventually changing
> > > the behavior (e.g. fail css initialization).  
> > 
> > I did a quick check of the common I/O layer code and one place that
> > looks dangerous is the chsc initialization (where we get two pages that
> > are later accessed unconditionally by the code).
> > 
> > All of this is related to not being able to fulfill some basic memory
> > availability requirements early during boot and then discovering that
> > pulling the emergency break did not actually stop the train. I'd vote
> > for calling panic() if the common I/O layer cannot perform its setup;
> > but as this is really a pathological case I also think we should solve
> > that independently of this patch series.
> >  
> 
> panic() sounds very reasonable to me. As an user I would like to see a
> message that tells me, I'm trying to boot with insufficient RAM. Is there
> such a message somewhere?

You could add it in the panic() message :) I would not spend overly
much time on this, though, as this really sounds like someone is trying
to run on a system that is way too tiny memory-wise for doing anything
useful.

>  
> > > 
> > > Connie, would that work with you? Thanks for spotting this!  
> > 
> > Yeah, let's give your approach a try.
> >   
> 
> OK. I intend to send out v5 with these changes tomorrow in the
> afternoon:
>  
> diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
> index 89d26e43004d..427b2e24a8ce 100644
> --- a/drivers/s390/cio/airq.c
> +++ b/drivers/s390/cio/airq.c
> @@ -142,7 +142,8 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>         size = iv_size(bits);
>  
>         if (flags & AIRQ_IV_CACHELINE) {
> -               if ((cache_line_size() * BITS_PER_BYTE) < bits)
> +               if ((cache_line_size() * BITS_PER_BYTE) < bits
> +                               || !airq_iv_cache)

It's perhaps a bit more readable if you keep checking for airq_iv_cache
on a separate if statement, but that's a matter of taste, I guess.

>                         goto out_free;
>  
>                 iv->vector = dma_pool_zalloc(airq_iv_cache, GFP_KERNEL,
> @@ -186,7 +187,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>         kfree(iv->ptr);
>         kfree(iv->bitlock);
>         kfree(iv->avail);
> -       if (iv->flags & AIRQ_IV_CACHELINE)
> +       if (iv->flags & AIRQ_IV_CACHELINE && iv->vector)
>                 dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
>         else
>                 cio_dma_free(iv->vector, size);
> diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> index 7901c8ed3597..d709bd8545f2 100644
> --- a/drivers/s390/cio/css.c
> +++ b/drivers/s390/cio/css.c
> @@ -1128,6 +1128,8 @@ void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
>   */
>  void *cio_dma_zalloc(size_t size)
>  {
> +       if (!cio_dma_pool)
> +               return NULL;
>         return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);
>  }
> 

Just looked at patch 2 again, will comment there.
