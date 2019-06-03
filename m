Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0AF33478
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfFCQDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 12:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfFCQDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 12:03:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0323B356FE;
        Mon,  3 Jun 2019 16:03:47 +0000 (UTC)
Received: from gondolin (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96EDB5C230;
        Mon,  3 Jun 2019 16:03:40 +0000 (UTC)
Date:   Mon, 3 Jun 2019 18:03:37 +0200
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
Subject: Re: [PATCH v3 8/8] virtio/s390: make airq summary indicators DMA
Message-ID: <20190603180337.17723bcf.cohuck@redhat.com>
In-Reply-To: <20190529122657.166148-9-mimu@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-9-mimu@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 03 Jun 2019 16:03:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 May 2019 14:26:57 +0200
Michael Mueller <mimu@linux.ibm.com> wrote:

> From: Halil Pasic <pasic@linux.ibm.com>
> 
> Hypervisor needs to interact with the summary indicators, so these
> need to be DMA memory as well (at least for protected virtualization
> guests).
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)

(...)

> @@ -1501,6 +1508,11 @@ static int __init virtio_ccw_init(void)
>  {
>  	/* parse no_auto string before we do anything further */
>  	no_auto_parse();
> +
> +	summary_indicators = cio_dma_zalloc(MAX_AIRQ_AREAS);
> +	if (!summary_indicators)
> +		return -ENOMEM;
> +
>  	return ccw_driver_register(&virtio_ccw_driver);

Don't you need to free summary_indicators again if registering the
driver fails?

>  }
>  device_initcall(virtio_ccw_init);

