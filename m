Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF9036D1F6
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 08:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhD1GDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 02:03:49 -0400
Received: from verein.lst.de ([213.95.11.211]:47899 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234587AbhD1GDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 02:03:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 94A8868B05; Wed, 28 Apr 2021 08:03:00 +0200 (CEST)
Date:   Wed, 28 Apr 2021 08:03:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to
 specify the device driver to bind
Message-ID: <20210428060300.GA4092@lst.de>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 05:00:04PM -0300, Jason Gunthorpe wrote:
> +/*
> + * mdev drivers can refuse to bind during probe(), in this case we want to fail
> + * the creation of the mdev all the way back to sysfs. This is a weird model
> + * that doesn't fit in the driver core well, nor does it seem to appear any
> + * place else in the kernel, so use a simple hack.
> + */
> +static int mdev_bind_driver(struct mdev_device *mdev)
> +{
> +	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
> +	int ret;
> +
> +	if (!drv)
> +		drv = &vfio_mdev_driver;
> +
> +	while (1) {
> +		device_lock(&mdev->dev);
> +		if (mdev->dev.driver == &drv->driver) {
> +			ret = 0;
> +			goto out_unlock;
> +		}
> +		if (mdev->probe_err) {
> +			ret = mdev->probe_err;
> +			goto out_unlock;
> +		}
> +		device_unlock(&mdev->dev);
> +		ret = device_attach(&mdev->dev);
> +		if (ret)
> +			return ret;
> +		mdev->probe_err = -EINVAL;
> +	}
> +	return 0;
> +
> +out_unlock:
> +	device_unlock(&mdev->dev);
> +	return ret;
> +}

> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -49,7 +49,7 @@ static int mdev_probe(struct device *dev)
>  		return ret;
>  
>  	if (drv->probe) {
> -		ret = drv->probe(mdev);
> +		ret = mdev->probe_err = drv->probe(mdev);
>  		if (ret)
>  			mdev_detach_iommu(mdev);
>  	}

>  	return 0;
>  }
>  
> +static int mdev_match(struct device *dev, struct device_driver *drv)
> +{
> +	struct mdev_device *mdev = to_mdev_device(dev);
> +	struct mdev_driver *target = mdev->type->parent->ops->device_driver;
> +
> +	/*
> +	 * The ops specify the device driver to connect, fall back to the old
> +	 * shim driver if the driver hasn't been converted.
> +	 */
> +	if (!target)
> +		target = &vfio_mdev_driver;
> +	return drv == &target->driver;
> +}

I still think this going the wrong way.  Why can't we enhance the core
driver code with a version of device_bind_driver() that does call into
->probe?  That probably seems like a better model for those existing
direct users of device_bind_driver or device_attach with a pre-set
->drv anyway.
