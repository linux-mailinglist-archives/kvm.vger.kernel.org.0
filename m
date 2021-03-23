Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7911934691E
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 20:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCWTbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 15:31:40 -0400
Received: from verein.lst.de ([213.95.11.211]:34028 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhCWTbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 15:31:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 144AA68C7B; Tue, 23 Mar 2021 20:31:03 +0100 (CET)
Date:   Tue, 23 Mar 2021 20:31:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
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
Subject: Re: [PATCH 18/18] vfio/mdev: Correct the function signatures for
 the mdev_type_attributes
Message-ID: <20210323193103.GP17735@lst.de>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com> <18-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 02:55:35PM -0300, Jason Gunthorpe wrote:
> The driver core standard is to pass in the properly typed object, the
> properly typed attribute and the buffer data. It stems from the root
> kobject method:
> 
>   ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,..)
> 
> Each subclass of kobject should provide their own function with the same
> signature but more specific types, eg struct device uses:
> 
>   ssize_t (*show)(struct device *dev, struct device_attribute *attr,..)
> 
> In this case the existing signature is:
> 
>   ssize_t (*show)(struct kobject *kobj, struct device *dev,..)
> 
> Where kobj is a 'struct mdev_type *' and dev is 'mdev_type->parent->dev'.
> 
> Change the mdev_type related sysfs attribute functions to:
> 
>   ssize_t (*show)(struct mdev_type *mtype, struct mdev_type_attribute *attr,..)
> 
> In order to restore type safety and match the driver core standard
> 
> There are no current users of 'attr', but if it is ever needed it would be
> hard to add in retroactively, so do it now.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gvt/gvt.c    | 21 +++++++++++----------
>  drivers/s390/cio/vfio_ccw_ops.c   | 15 +++++++++------
>  drivers/s390/crypto/vfio_ap_ops.c | 12 +++++++-----
>  drivers/vfio/mdev/mdev_core.c     | 14 ++++++++++++--
>  drivers/vfio/mdev/mdev_sysfs.c    | 11 ++++++-----
>  include/linux/mdev.h              | 11 +++++++----
>  samples/vfio-mdev/mbochs.c        | 26 +++++++++++++++-----------
>  samples/vfio-mdev/mdpy.c          | 24 ++++++++++++++----------
>  samples/vfio-mdev/mtty.c          | 18 +++++++++---------
>  9 files changed, 90 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
> index 4b47a18e9dfa0f..3703814a669b46 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.c
> +++ b/drivers/gpu/drm/i915/gvt/gvt.c
> @@ -54,14 +54,15 @@ intel_gvt_find_vgpu_type(struct intel_gvt *gvt, unsigned int type_group_id)
>  	return &gvt->types[type_group_id];
>  }
>  
> -static ssize_t available_instances_show(struct kobject *kobj,
> -					struct device *dev, char *buf)
> +static ssize_t available_instances_show(struct mdev_type *mtype,
> +					struct mdev_type_attribute *attr,
> +					char *buf)
>  {
>  	struct intel_vgpu_type *type;
>  	unsigned int num = 0;
> -	void *gvt = kdev_to_i915(dev)->gvt;
> +	void *gvt = kdev_to_i915(mtype_get_parent_dev(mtype))->gvt;
>  
> -	type = intel_gvt_find_vgpu_type(gvt, mtype_get_type_group_id(kobj));
> +	type = intel_gvt_find_vgpu_type(gvt, mtype_get_type_group_id(mtype));

Somewhere in this series you should probably
switch intel_gvt_find_vgpu_type to only get the mtype, as it can trivially
deduct the gvt from it (which also seems to have lost its type somewhere..)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
