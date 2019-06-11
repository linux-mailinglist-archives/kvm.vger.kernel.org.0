Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAEC3C7B9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 11:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391368AbfFKJ4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 05:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbfFKJ4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 05:56:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC61B3092677;
        Tue, 11 Jun 2019 09:56:10 +0000 (UTC)
Received: from gondolin (ovpn-204-147.brq.redhat.com [10.40.204.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78AF8600CC;
        Tue, 11 Jun 2019 09:56:04 +0000 (UTC)
Date:   Tue, 11 Jun 2019 11:55:29 +0200
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
Message-ID: <20190611115529.6e3ae12d.cohuck@redhat.com>
In-Reply-To: <20190606115127.55519-3-pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
        <20190606115127.55519-3-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 11 Jun 2019 09:56:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 13:51:21 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> To support protected virtualization cio will need to make sure the
> memory used for communication with the hypervisor is DMA memory.
> 
> Let us introduce one global pool for cio.
> 
> Our DMA pools are implemented as a gen_pool backed with DMA pages. The
> idea is to avoid each allocation effectively wasting a page, as we
> typically allocate much less than PAGE_SIZE.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> ---
>  arch/s390/Kconfig           |   1 +
>  arch/s390/include/asm/cio.h |  11 +++
>  drivers/s390/cio/css.c      | 131 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 139 insertions(+), 4 deletions(-)

(...)

> +void cio_gp_dma_destroy(struct gen_pool *gp_dma, struct device *dma_dev)
> +{
> +	if (!gp_dma)
> +		return;
> +	/* this is qite ugly but no better idea */

typo: s/qite/quite/

> +	gen_pool_for_each_chunk(gp_dma, __gp_dma_free_dma, dma_dev);
> +	gen_pool_destroy(gp_dma);
> +}

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
