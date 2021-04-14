Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8935FAAC
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 20:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhDNSSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 14:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232197AbhDNSSB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 14:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618424259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OYqddHlJXne+BFhqnkmv4/g/hMbPLBDi1f2Aw0G4WA=;
        b=E/doeZDjJDNER7RXS4N53vtOQjDpMbG4vJhpPHqm3offPRmsBFkGAaUP48j5Wwtj477sQ2
        DpUKTArHwrupndEfyNxrvOsr+EmFCbFGFiCq7KIML+ZZsBpiTkqedNuzUbrj04DoVngjtQ
        2XQfZns2EmuD6nZO09hdZLEbOdtnWbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-eHNIH7HTPv-2GGaEQKhsNQ-1; Wed, 14 Apr 2021 14:17:35 -0400
X-MC-Unique: eHNIH7HTPv-2GGaEQKhsNQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 801148030A0;
        Wed, 14 Apr 2021 18:17:30 +0000 (UTC)
Received: from omen (ovpn-117-254.rdu2.redhat.com [10.10.117.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBA3A5D6D7;
        Wed, 14 Apr 2021 18:17:20 +0000 (UTC)
Date:   Wed, 14 Apr 2021 12:17:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 00/18] Make vfio_mdev type safe
Message-ID: <20210414121719.7bdb6867@omen>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Apr 2021 16:40:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> vfio_mdev has a number of different objects: mdev_parent, mdev_type and
> mdev_device.
> 
> Unfortunately the types of these have been erased in various places
> throughout the API, and this makes it very hard to understand this code or
> maintain it by the time it reaches all of the drivers.
> 
> This series puts in all the types and aligns some of the design with the
> driver core standard for a driver core bus driver:
> 
>  - Replace 'struct device *' with 'struct mdev_device *
>  - Replace 'struct device *' with 'struct mdev_type *' and
>    mtype_get_parent_dev()
>  - Replace 'struct kobject *' with 'struct mdev_type *'
> 
> Now that types are clear it is easy to spot a few places that have
> duplicated information.
> 
> More significantly we can now understand how to directly fix the
> obfuscated 'kobj->name' matching by realizing the the kobj is a mdev_type,
> which is linked to the supported_types_list provided by the driver, and
> thus the core code can directly return the array indexes all the drivers
> actually want.
> 
> v2:
>  - Use a mdev_type local in mdev_create_sysfs_files
>  - Rename the goto unwind labels in mdev_device_free()
>  - Reorder patches, annotate reviewed-by's thanks all
> v1: https://lore.kernel.org/r/0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com
> 
> Jason Gunthorpe (18):
>   vfio/mdev: Fix missing static's on MDEV_TYPE_ATTR's
>   vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer
>   vfio/mdev: Add missing typesafety around mdev_device
>   vfio/mdev: Simplify driver registration
>   vfio/mdev: Use struct mdev_type in struct mdev_device
>   vfio/mdev: Expose mdev_get/put_parent to mdev_private.h
>   vfio/mdev: Add missing reference counting to mdev_type
>   vfio/mdev: Reorganize mdev_device_create()
>   vfio/mdev: Add missing error handling to dev_set_name()
>   vfio/mdev: Remove duplicate storage of parent in mdev_device
>   vfio/mdev: Add mdev/mtype_get_type_group_id()
>   vfio/mtty: Use mdev_get_type_group_id()
>   vfio/mdpy: Use mdev_get_type_group_id()
>   vfio/mbochs: Use mdev_get_type_group_id()
>   vfio/gvt: Make DRM_I915_GVT depend on VFIO_MDEV
>   vfio/gvt: Use mdev_get_type_group_id()
>   vfio/mdev: Remove kobj from mdev_parent_ops->create()
>   vfio/mdev: Correct the function signatures for the
>     mdev_type_attributes
> 
>  .../driver-api/vfio-mediated-device.rst       |   9 +-
>  drivers/gpu/drm/i915/Kconfig                  |   1 +
>  drivers/gpu/drm/i915/gvt/gvt.c                |  41 ++---
>  drivers/gpu/drm/i915/gvt/gvt.h                |   4 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |   7 +-
>  drivers/s390/cio/vfio_ccw_ops.c               |  17 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  14 +-
>  drivers/vfio/mdev/mdev_core.c                 | 174 +++++++-----------
>  drivers/vfio/mdev/mdev_driver.c               |  19 +-
>  drivers/vfio/mdev/mdev_private.h              |  40 ++--
>  drivers/vfio/mdev/mdev_sysfs.c                |  59 +++---
>  drivers/vfio/mdev/vfio_mdev.c                 |  29 +--
>  drivers/vfio/vfio_iommu_type1.c               |  25 +--
>  include/linux/mdev.h                          |  80 +++++---
>  samples/vfio-mdev/mbochs.c                    |  55 +++---
>  samples/vfio-mdev/mdpy.c                      |  56 +++---
>  samples/vfio-mdev/mtty.c                      |  66 ++-----
>  17 files changed, 313 insertions(+), 383 deletions(-)

Applied to vfio next branch for v5.13.  Thanks!

Alex

