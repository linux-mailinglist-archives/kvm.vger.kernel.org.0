Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDEA2B280
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 12:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfE0Kxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 06:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfE0Kxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 06:53:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41B4E307D855;
        Mon, 27 May 2019 10:53:31 +0000 (UTC)
Received: from gondolin (ovpn-204-109.brq.redhat.com [10.40.204.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EFDD5D704;
        Mon, 27 May 2019 10:53:23 +0000 (UTC)
Date:   Mon, 27 May 2019 12:53:20 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
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
Subject: Re: [PATCH v2 4/8] s390/airq: use DMA memory for adapter interrupts
Message-ID: <20190527125320.7540049a.cohuck@redhat.com>
In-Reply-To: <20190523162209.9543-5-mimu@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
        <20190523162209.9543-5-mimu@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 27 May 2019 10:53:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 May 2019 18:22:05 +0200
Michael Mueller <mimu@linux.ibm.com> wrote:

> From: Halil Pasic <pasic@linux.ibm.com>
> 
> Protected virtualization guests have to use shared pages for airq
> notifier bit vectors, because hypervisor needs to write these bits.
> 
> Let us make sure we allocate DMA memory for the notifier bit vectors by
> replacing the kmem_cache with a dma_cache and kalloc() with
> cio_dma_zalloc().
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  arch/s390/include/asm/airq.h |  2 ++
>  drivers/s390/cio/airq.c      | 32 ++++++++++++++++++++------------
>  drivers/s390/cio/cio.h       |  2 ++
>  drivers/s390/cio/css.c       |  1 +
>  4 files changed, 25 insertions(+), 12 deletions(-)

(...)

> diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> index 789f6ecdbbcc..f09521771a32 100644
> --- a/drivers/s390/cio/css.c
> +++ b/drivers/s390/cio/css.c
> @@ -1173,6 +1173,7 @@ static int __init css_bus_init(void)
>  		goto out_unregister;
>  	}
>  	cio_dma_pool_init();
> +	airq_init();
>  	css_init_done = 1;
>  
>  	/* Enable default isc for I/O subchannels. */

Not directly related to this patch (I don't really have any comment
here), but I started looking at the code again and now I'm wondering
about chsc. I think it came up before, but I can't remember if chsc
needed special treatment... Anyway, css_bus_init() uses some chscs
early (before cio_dma_pool_init), so we could not use the pools there,
even if we wanted to. Do chsc commands either work, or else fail
benignly on a protected virt guest?
