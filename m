Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE0D3D2601
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 16:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhGVOB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 10:01:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232396AbhGVOB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 10:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626964950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kw6CRwUqzdaXdrl+GoUqts83hcJHaySlHaJXBWUbRA8=;
        b=ggHsOqYmK6EZn8ITs7DU1KO0Qvyyb1xW5CkcCcu10xsjAYb52QFOhWvK1HFXa54DfEuzk/
        JPCJN6AjayrWckhCLefMluwuZG1ZdkO2H8/AVIwzLDoISLai1wVzUOBCre0Uvf1dVapI+0
        xCjbxEPBbpDRoyZhzJGxRvzSnSk5HSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-h11GFaXVNSK1F2Q3vQ8VlA-1; Thu, 22 Jul 2021 10:42:26 -0400
X-MC-Unique: h11GFaXVNSK1F2Q3vQ8VlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C201107ACF5;
        Thu, 22 Jul 2021 14:42:22 +0000 (UTC)
Received: from localhost (ovpn-112-132.ams2.redhat.com [10.36.112.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E891210016DB;
        Thu, 22 Jul 2021 14:42:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 04/14] vfio: Provide better generic support for
 open/release vfio_device_ops
In-Reply-To: <4-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <4-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 22 Jul 2021 16:42:10 +0200
Message-ID: <87bl6u76m5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> Currently the driver ops have an open/release pair that is called once
> each time a device FD is opened or closed. Add an additional set of
> open/close_device() ops which are called when the device FD is opened for
> the first time and closed for the last time.
>
> An analysis shows that all of the drivers require this semantic. Some are
> open coding it as part of their reflck implementation, and some are just
> buggy and miss it completely.
>
> To retain the current semantics PCI and FSL depend on, introduce the idea
> of a "device set" which is a grouping of vfio_device's that share the same
> lock around opening.
>
> The device set is established by providing a 'set_id' pointer. All
> vfio_device's that provide the same pointer will be joined to the same
> singleton memory and lock across the whole set. This effectively replaces
> the oddly named reflck.
>
> After conversion the set_id will be sourced from:
>  - A struct device from a fsl_mc_device (fsl)
>  - A struct pci_slot (pci)
>  - A struct pci_bus (pci)
>  - The struct vfio_device (everything)
>
> The design ensures that the above pointers are live as long as the
> vfio_device is registered, so they form reliable unique keys to group
> vfio_devices into sets.
>
> This implementation uses xarray instead of searching through the driver
> core structures, which simplifies the somewhat tricky locking in this
> area.
>
> Following patches convert all the drivers.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c |  22 +++++
>  drivers/vfio/vfio.c           | 146 +++++++++++++++++++++++++++++-----
>  include/linux/mdev.h          |   2 +
>  include/linux/vfio.h          |  19 +++++
>  4 files changed, 167 insertions(+), 22 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

