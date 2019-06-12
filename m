Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D01141C3C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 08:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbfFLGa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 02:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfFLGa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 02:30:29 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D94333082E71;
        Wed, 12 Jun 2019 06:30:28 +0000 (UTC)
Received: from gondolin (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B89948CFB;
        Wed, 12 Jun 2019 06:30:21 +0000 (UTC)
Date:   Wed, 12 Jun 2019 08:30:17 +0200
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
Subject: Re: [PATCH v4 2/8] s390/cio: introduce DMA pools to cio
Message-ID: <20190612083017.0cbbe17b.cohuck@redhat.com>
In-Reply-To: <20190606115127.55519-3-pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
        <20190606115127.55519-3-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 12 Jun 2019 06:30:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 13:51:21 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

[just looked at it in the context of failed init]

> +static void __gp_dma_free_dma(struct gen_pool *pool,
> +			      struct gen_pool_chunk *chunk, void *data)

Just to note: the 'pool' is mandated by the api for this callback.

> +{
> +	size_t chunk_size = chunk->end_addr - chunk->start_addr + 1;
> +
> +	dma_free_coherent((struct device *) data, chunk_size,
> +			 (void *) chunk->start_addr,
> +			 (dma_addr_t) chunk->phys_addr);
> +}
> +
> +void cio_gp_dma_destroy(struct gen_pool *gp_dma, struct device *dma_dev)
> +{
> +	if (!gp_dma)
> +		return;

So this seems fine.

> +	/* this is qite ugly but no better idea */
> +	gen_pool_for_each_chunk(gp_dma, __gp_dma_free_dma, dma_dev);
> +	gen_pool_destroy(gp_dma);
> +}
> +
> +static int cio_dma_pool_init(void)
> +{
> +	/* No need to free up the resources: compiled in */
> +	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);
> +	if (!cio_dma_pool)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
> +			size_t size)
> +{
> +	dma_addr_t dma_addr;
> +	unsigned long addr;
> +	size_t chunk_size;
> +

I'd probably do a quick exit for !gp_dma here as well (just to be on
the safe side).

> +	addr = gen_pool_alloc(gp_dma, size);
> +	while (!addr) {
> +		chunk_size = round_up(size, PAGE_SIZE);
> +		addr = (unsigned long) dma_alloc_coherent(dma_dev,
> +					 chunk_size, &dma_addr, CIO_DMA_GFP);
> +		if (!addr)
> +			return NULL;
> +		gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
> +		addr = gen_pool_alloc(gp_dma, size);
> +	}
> +	return (void *) addr;
> +}
> +
> +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
> +{
> +	if (!cpu_addr)
> +		return;

This already makes it safe enough.

> +	memset(cpu_addr, 0, size);
> +	gen_pool_free(gp_dma, (unsigned long) cpu_addr, size);
> +}
> +
> +/*
> + * Allocate dma memory from the css global pool. Intended for memory not
> + * specific to any single device within the css. The allocated memory
> + * is not guaranteed to be 31-bit addressable.
> + *
> + * Caution: Not suitable for early stuff like console.
> + */
> +void *cio_dma_zalloc(size_t size)
> +{

If you check in the called function, you do not need to check here.
Probably a matter of taste.

> +	return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);
> +}
> +
> +void cio_dma_free(void *cpu_addr, size_t size)
> +{

This one should be safe due to the check in the called function.

> +	cio_gp_dma_free(cio_dma_pool, cpu_addr, size);
> +}
> +
>  /*
>   * Now that the driver core is running, we can setup our channel subsystem.
>   * The struct subchannel's are created during probing.
