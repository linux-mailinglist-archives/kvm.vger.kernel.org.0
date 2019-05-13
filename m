Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5B81B68D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfEMM7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfEMM7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 08:59:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BFF030054AB;
        Mon, 13 May 2019 12:59:10 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58F191001E98;
        Mon, 13 May 2019 12:59:05 +0000 (UTC)
Date:   Mon, 13 May 2019 14:59:03 +0200
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
Subject: Re: [PATCH 07/10] s390/airq: use DMA memory for adapter interrupts
Message-ID: <20190513145903.47446b4d.cohuck@redhat.com>
In-Reply-To: <20190426183245.37939-8-pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-8-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 13 May 2019 12:59:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Apr 2019 20:32:42 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> Protected virtualization guests have to use shared pages for airq
> notifier bit vectors, because hypervisor needs to write these bits.
> 
> Let us make sure we allocate DMA memory for the notifier bit vectors.

[Looking at this first, before I can think about your update in patch
5.]

> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  arch/s390/include/asm/airq.h |  2 ++
>  drivers/s390/cio/airq.c      | 18 ++++++++++++++----
>  2 files changed, 16 insertions(+), 4 deletions(-)

(...)

> diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
> index a45011e4529e..7a5c0a08ee09 100644
> --- a/drivers/s390/cio/airq.c
> +++ b/drivers/s390/cio/airq.c
> @@ -19,6 +19,7 @@
>  
>  #include <asm/airq.h>
>  #include <asm/isc.h>
> +#include <asm/cio.h>
>  
>  #include "cio.h"
>  #include "cio_debug.h"
> @@ -113,6 +114,11 @@ void __init init_airq_interrupts(void)
>  	setup_irq(THIN_INTERRUPT, &airq_interrupt);
>  }
>  
> +static inline unsigned long iv_size(unsigned long bits)
> +{
> +	return BITS_TO_LONGS(bits) * sizeof(unsigned long);
> +}
> +
>  /**
>   * airq_iv_create - create an interrupt vector
>   * @bits: number of bits in the interrupt vector
> @@ -123,14 +129,15 @@ void __init init_airq_interrupts(void)
>  struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>  {
>  	struct airq_iv *iv;
> -	unsigned long size;
> +	unsigned long size = 0;

Why do you need to init this to 0?

>  
>  	iv = kzalloc(sizeof(*iv), GFP_KERNEL);
>  	if (!iv)
>  		goto out;
>  	iv->bits = bits;
> -	size = BITS_TO_LONGS(bits) * sizeof(unsigned long);
> -	iv->vector = kzalloc(size, GFP_KERNEL);
> +	size = iv_size(bits);
> +	iv->vector = dma_alloc_coherent(cio_get_dma_css_dev(), size,
> +						 &iv->vector_dma, GFP_KERNEL);

Indent is a bit off.

But more importantly, I'm also a bit vary about ap and pci. IIRC, css
support is mandatory, so that should not be a problem; and unless I
remember incorrectly, ap only uses summary indicators. How does this
interact with pci devices? I suppose any of their dma properties do not
come into play with the interrupt code here? (Just want to be sure.)

>  	if (!iv->vector)
>  		goto out_free;
>  	if (flags & AIRQ_IV_ALLOC) {
> @@ -165,7 +172,8 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>  	kfree(iv->ptr);
>  	kfree(iv->bitlock);
>  	kfree(iv->avail);
> -	kfree(iv->vector);
> +	dma_free_coherent(cio_get_dma_css_dev(), size, iv->vector,
> +			  iv->vector_dma);
>  	kfree(iv);
>  out:
>  	return NULL;
> @@ -182,6 +190,8 @@ void airq_iv_release(struct airq_iv *iv)
>  	kfree(iv->ptr);
>  	kfree(iv->bitlock);
>  	kfree(iv->vector);
> +	dma_free_coherent(cio_get_dma_css_dev(), iv_size(iv->bits),
> +			  iv->vector, iv->vector_dma);
>  	kfree(iv->avail);
>  	kfree(iv);
>  }

