Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04B241218F
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 20:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358403AbhITSGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 14:06:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357381AbhITSEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 14:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632160960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WwlG7m0Pkd8z9L6TGcVmgxQFpqMvFaegkPkOTNgv/sc=;
        b=VeeGQe96y7KXLsToaREdwGYLsFlDOqV/569ewjRs3U5dDJKlHHqT2sQsTP69KI28HJWogp
        mBDQdXDUTagciw3Os0Eb82jJ5R6gkeTonrL3LtcjZwRKuUq5yr37qqH6yGJkXJZYcLAQsR
        O5TMofG9LtSIsT4tqnLiC7nA8IJ3DMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-7Hnru5NkPEWPmrJvytwe_g-1; Mon, 20 Sep 2021 14:02:39 -0400
X-MC-Unique: 7Hnru5NkPEWPmrJvytwe_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAAA51084684;
        Mon, 20 Sep 2021 18:02:35 +0000 (UTC)
Received: from localhost (unknown [10.39.193.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA7BD19D9D;
        Mon, 20 Sep 2021 18:02:30 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
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
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 6/9] vfio/mdev: Add mdev available instance checking
 to the core
In-Reply-To: <6-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <6-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 20 Sep 2021 20:02:29 +0200
Message-ID: <87tuiff7m2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> Many of the mdev drivers use a simple counter for keeping track of the
> available instances. Move this code to the core code and store the counter
> in the mdev_type. Implement it using correct locking, fixing mdpy.
>
> Drivers provide a get_available() callback to set the number of available
> instances for their mtypes which is fixed at registration time. The core
> provides a standard sysfs attribute to return the available_instances.

So, according to the documentation, available_instances is
mandatory. This means that drivers either need to provide get_available
or implement their own version of the attribute. I think we want to
update vfio-mediated-device.rst as well?

>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c       |  1 -
>  drivers/s390/cio/vfio_ccw_ops.c       | 26 ++++++-------------
>  drivers/s390/cio/vfio_ccw_private.h   |  2 --
>  drivers/s390/crypto/vfio_ap_ops.c     | 32 ++++++-----------------
>  drivers/s390/crypto/vfio_ap_private.h |  2 --
>  drivers/vfio/mdev/mdev_core.c         | 11 +++++++-
>  drivers/vfio/mdev/mdev_private.h      |  2 ++
>  drivers/vfio/mdev/mdev_sysfs.c        | 37 +++++++++++++++++++++++++++
>  include/linux/mdev.h                  |  2 ++
>  samples/vfio-mdev/mdpy.c              | 22 +++++-----------
>  10 files changed, 73 insertions(+), 64 deletions(-)

Otherwise, looks good.

