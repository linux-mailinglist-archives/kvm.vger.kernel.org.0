Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F235F577A9E
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 07:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiGRFn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 01:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGRFnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 01:43:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775301A9;
        Sun, 17 Jul 2022 22:43:52 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A752B68AFE; Mon, 18 Jul 2022 07:43:48 +0200 (CEST)
Date:   Mon, 18 Jul 2022 07:43:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: simplify the mdev interface v6
Message-ID: <20220718054348.GA22345@lst.de>
References: <20220709045450.609884-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709045450.609884-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex, does this series look good to you now?

On Sat, Jul 09, 2022 at 06:54:36AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series signigicantly simplies the mdev driver interface by following
> the patterns for device model interaction used elsewhere in the kernel.
> 
> Changes since v5:
>  - rebased to the latest vfio/next branch
>  - drop the last patch again
>  - make sure show_available_instances works properly for the internallly
>    tracked case
> 
> Changes since v4:
>  - move the kobject_put later in mdev_device_release 
>  - add a Fixes tag for the first patch
>  - add another patch to remove an extra kobject_get/put
> 
> Changes since v3:
>  - make the sysfs_name and pretty_name fields pointers instead of arrays
>  - add an i915 cleanup to prepare for the above
> 
> Changes since v2:
>  - rebased to vfio/next
>  - fix a pre-existing memory leak in i915 instead of making it worse
>  - never manipulate if ->available_instances if drv->get_available is
>    provided
>  - keep a parent reference for the mdev_type
>  - keep a few of the sysfs.c helper function around
>  - improve the documentation for the parent device lifetime
>  - minor spellig / formatting fixes
> 
> Changes since v1:
>  - embedd the mdev_parent into a different sub-structure in i916
>  - remove headers now inclued by mdev.h from individual source files
>  - pass an array of mdev_types to mdev_register_parent
>  - add additional patches to implement all attributes on the
>    mdev_type in the core code
> 
> Diffstat:
>  Documentation/driver-api/vfio-mediated-device.rst |   26 +-
>  Documentation/s390/vfio-ap.rst                    |    2 
>  Documentation/s390/vfio-ccw.rst                   |    2 
>  drivers/gpu/drm/i915/gvt/aperture_gm.c            |   20 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                    |   42 ++--
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  168 ++++-------------
>  drivers/gpu/drm/i915/gvt/vgpu.c                   |  210 +++++++---------------
>  drivers/s390/cio/cio.h                            |    4 
>  drivers/s390/cio/vfio_ccw_drv.c                   |   12 -
>  drivers/s390/cio/vfio_ccw_ops.c                   |   51 -----
>  drivers/s390/cio/vfio_ccw_private.h               |    2 
>  drivers/s390/crypto/vfio_ap_ops.c                 |   68 +------
>  drivers/s390/crypto/vfio_ap_private.h             |    6 
>  drivers/vfio/mdev/mdev_core.c                     |  190 ++++---------------
>  drivers/vfio/mdev/mdev_driver.c                   |    7 
>  drivers/vfio/mdev/mdev_private.h                  |   32 ---
>  drivers/vfio/mdev/mdev_sysfs.c                    |  189 ++++++++++---------
>  include/linux/mdev.h                              |   77 ++++----
>  samples/vfio-mdev/mbochs.c                        |  103 +++-------
>  samples/vfio-mdev/mdpy.c                          |  115 +++---------
>  samples/vfio-mdev/mtty.c                          |   94 +++------
>  21 files changed, 463 insertions(+), 957 deletions(-)
---end quoted text---
