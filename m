Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730C836B475
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhDZODm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:03:42 -0400
Received: from verein.lst.de ([213.95.11.211]:41389 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDZODl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:03:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7BADF68C4E; Mon, 26 Apr 2021 16:02:57 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:02:57 +0200
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
Subject: Re: [PATCH 02/12] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210426140257.GA15209@lst.de>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com> <2-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 08:02:59PM -0300, Jason Gunthorpe wrote:
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

This looks strange to me, and I think by open coding
device_attach we could do much better here, something like:

static int mdev_bind_driver(struct mdev_device *mdev)
{
	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
	int ret = -EINVAL;

	if (!drv)
		drv = &vfio_mdev_driver;

	device_lock(&mdev->dev);
	if (WARN_ON_ONCE(device_is_bound(dev)))
		goto out_unlock;
	if (mdev->dev.p->dead)
	 	goto out_unlock;

	mdev->dev.driver = &drv->driver;
	ret = device_bind_driver(&mdev->dev);
	if (ret)
		mdev->dev.driver = NULL;
out_unlock:
	device_unlock(&mdev->dev);
	return ret;
}
