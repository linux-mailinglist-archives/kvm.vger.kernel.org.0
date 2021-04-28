Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BDE36D948
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhD1OMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhD1OMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 10:12:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86FA06109E;
        Wed, 28 Apr 2021 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619619099;
        bh=LA2a4qHuypnKtXddJRJVLuUOvha6hhv202krG5iHHOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LmKy/AMmT8tEKQDouDvTYcYiOfjKsL1QUNwjDFRr65ZCq1/LZ5FnbAfiH5ss+x2Vq
         6HjjQLNqL/Wz9dPMq0ca8hJwxiYkB/nf3vYELxGq6J0nzco3+MxVVsbu5LoAF2aTN1
         7XdMSZipz56hW2alduVXyLeKMS1hGbv8r/z+xgWDx1Lan0Y2e1EEMie1u/Sb8iA48U
         bZHPp5TidY+MRXsPLH4nvgc5CCnY8y9vx6pnS3kNISF0aueSwy1xe8Pn072yM8gVmu
         IY3MbjTTnW9zvCC3vbbttdkEpy+xsL70hlKkmt3dAhJ5wyzAASO0wFvMYFEzaJgjin
         u4ZkBadwl23LA==
Date:   Wed, 28 Apr 2021 09:44:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <YIkENzc+9XAFPcer@unreal>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 05:00:04PM -0300, Jason Gunthorpe wrote:
> This allows a mdev driver to opt out of using vfio_mdev.c, instead the
> driver will provide a 'struct mdev_driver' and register directly with the
> driver core.
> 
> Much of mdev_parent_ops becomes unused in this mode:
> - create()/remove() are done via the mdev_driver probe()/remove()
> - mdev_attr_groups becomes mdev_driver driver.dev_groups
> - Wrapper function callbacks are replaced with the same ones from
>   struct vfio_device_ops
> 
> Following patches convert all the drivers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_core.c   | 64 ++++++++++++++++++++++++++++-----
>  drivers/vfio/mdev/mdev_driver.c | 17 ++++++++-
>  include/linux/mdev.h            |  3 ++
>  3 files changed, 75 insertions(+), 9 deletions(-)

<...>

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

The sequence above looks sketchy:
1. lock
2. check for driver
3. unlock
4. device_attach - it takes internally same lock as in step 1.

Why don't you rely on internal to device_attach() driver check?

Thanks
