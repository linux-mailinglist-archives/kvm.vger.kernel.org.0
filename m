Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC436DDEC
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbhD1RKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 13:10:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241462AbhD1RKr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 13:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619629802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYnNI+8n8SSBVkSqmVJf6WDEsPwRyUVXwFwjsGwmDKc=;
        b=WmP8hRGiJPgy7sivLkRrEZS0/nIfsX/rv53Smve3g+KW7U9oE42Ma7um8qTW+ZKnzyUB4c
        lc1rPFVDE5FAGWv10H/I7p3LZZcKnh6zXN8+3nzwgc7hwiAbgshzS+6dhFqthUvxujOKEn
        xWqYQuARwHCFh+bBF4ONjle/QuZNREE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-wXs0JlgqMC2Z6rj0Cn2nhA-1; Wed, 28 Apr 2021 13:09:58 -0400
X-MC-Unique: wXs0JlgqMC2Z6rj0Cn2nhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10AC1966338;
        Wed, 28 Apr 2021 17:09:55 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7173B6B8D4;
        Wed, 28 Apr 2021 17:09:52 +0000 (UTC)
Date:   Wed, 28 Apr 2021 19:09:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210428190949.4360afb7.cohuck@redhat.com>
In-Reply-To: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Apr 2021 17:00:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is more complicated because vfio_ccw is sharing the vfio_device
> between both the mdev_device and its vfio_device and the css_driver.
> 
> The mdev is a singleton, and the reason for this sharing appears to be to
> allow the extra css_driver function callbacks to be delivered to the
> vfio_device.
> 
> This keeps things as they were, with the css_driver allocating the
> singleton, not the mdev_driver, this is pretty confusing. I'm also
> uncertain how the lifetime model for the mdev works in the css_driver
> callbacks.
> 
> At this point embed the vfio_device in the vfio_ccw_private and
> instantiate it as a vfio_device when the mdev probes. The drvdata of both
> the css_device and the mdev_device point at the private, and container_of
> is used to get it back from the vfio_device.

I've been staring at this for some time, and I'm not sure whether this
is a good approach.

We allow at most one mdev per subchannel (slicing it up does not make
sense), so we can be sure that there's a 1:1 relationship between mdev
and parent device, and we can track it via a single pointer.

The vfio_ccw_private driver data is allocated during probe (same as for
other css_drivers.) Embedding a vfio_device here means that we have a
structure tied into it that is operating with different lifetime rules.

What about creating a second structure instead that can embed the
vfio_device, is allocated during mdev probing, and is linked up with
the vfio_ccw_private structure? That would follow the pattern of other
drivers more closely.

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     |  21 +++--
>  drivers/s390/cio/vfio_ccw_ops.c     | 135 +++++++++++++++-------------
>  drivers/s390/cio/vfio_ccw_private.h |   5 ++
>  3 files changed, 94 insertions(+), 67 deletions(-)

