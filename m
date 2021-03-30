Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA234EDDC
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhC3Q34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:29:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231797AbhC3Q3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 12:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617121784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0X96PA+DBZ/FhqBuRCr2t87uXqh8cUcVTzIQTqfSHwc=;
        b=ICHwmrZUJXgamHrqNonmKMgBfdum+9pW+WJnmHef9fjNmCITYAk4PUTqxmB9xLCeaLgN1G
        qjo7fzoT0D197mFV+2ljfYfZ3Mgrp0H5Bt1+4WySRoWfHruKuVpQ8BPycdilQCiGxfJ9Qo
        kO07IKzkxlyQTOd/eRK1P6aSYd3DGYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-KoqYsyN8MU6DFLwHUbRABg-1; Tue, 30 Mar 2021 12:29:38 -0400
X-MC-Unique: KoqYsyN8MU6DFLwHUbRABg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF663185305F;
        Tue, 30 Mar 2021 16:29:35 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5F019CB2;
        Tue, 30 Mar 2021 16:29:25 +0000 (UTC)
Date:   Tue, 30 Mar 2021 18:29:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
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
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 17/18] vfio/mdev: Remove kobj from
 mdev_parent_ops->create()
Message-ID: <20210330182923.74255269.cohuck@redhat.com>
In-Reply-To: <17-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <17-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:34 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The kobj here is a type-erased version of mdev_type, which is already
> stored in the struct mdev_device being passed in. It was only ever used to
> compute the type_group_id, which is now extracted directly from the mdev.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c  | 2 +-
>  drivers/s390/cio/vfio_ccw_ops.c   | 2 +-
>  drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>  drivers/vfio/mdev/mdev_core.c     | 2 +-
>  include/linux/mdev.h              | 3 +--
>  samples/vfio-mdev/mbochs.c        | 2 +-
>  samples/vfio-mdev/mdpy.c          | 2 +-
>  samples/vfio-mdev/mtty.c          | 2 +-
>  8 files changed, 8 insertions(+), 9 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

