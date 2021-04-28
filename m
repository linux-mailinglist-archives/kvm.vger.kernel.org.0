Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485D436D983
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhD1OZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhD1OZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 10:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D11756142A;
        Wed, 28 Apr 2021 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619619872;
        bh=UKUazvAqaSA3P62RMXBJczStPulFFoevUe1M29vJTt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hrdLGfHuRw86dBtsH1q8UWfYFyLBUyEK6xIGSta5RqkpYqas78w0CpDEegYfsfANV
         GCGTq0Idb51CX7g5+H/yAapHo0uS6xDlJqInjlrMMuckcqjGwEcJ/Gep+ewwToVfSA
         cTTSDZd8WdlRvmH2aDVkZ/SCegIIoqGKG82JjLnOsyLZsXe5N7GKR+6uBbS3Wa+Lcz
         P0oUXL3EM9tiLZgg+9lK9mN+ZPkG8WHP3BOJ9v6CEN3bMDnmWWNSfUCqvDlIZ+wLnv
         ybVEDafoFcxmU1BcROUtAf/sNxUeMGytIVD+cQlQIGxPk6Rd0bA7kG47GLnjQvH7IS
         j4lmqSzzUFUYQ==
Date:   Wed, 28 Apr 2021 17:24:27 +0300
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
Message-ID: <YIlwGwfWi4d4pe1i@unreal>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <YIkENzc+9XAFPcer@unreal>
 <20210428141446.GT1370958@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428141446.GT1370958@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 11:14:46AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 28, 2021 at 09:44:07AM +0300, Leon Romanovsky wrote:
> > On Mon, Apr 26, 2021 at 05:00:04PM -0300, Jason Gunthorpe wrote:
> > > This allows a mdev driver to opt out of using vfio_mdev.c, instead the
> > > driver will provide a 'struct mdev_driver' and register directly with the
> > > driver core.
> > > 
> > > Much of mdev_parent_ops becomes unused in this mode:
> > > - create()/remove() are done via the mdev_driver probe()/remove()
> > > - mdev_attr_groups becomes mdev_driver driver.dev_groups
> > > - Wrapper function callbacks are replaced with the same ones from
> > >   struct vfio_device_ops
> > > 
> > > Following patches convert all the drivers.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/vfio/mdev/mdev_core.c   | 64 ++++++++++++++++++++++++++++-----
> > >  drivers/vfio/mdev/mdev_driver.c | 17 ++++++++-
> > >  include/linux/mdev.h            |  3 ++
> > >  3 files changed, 75 insertions(+), 9 deletions(-)
> > 
> > <...>
> > 
> > > +/*
> > > + * mdev drivers can refuse to bind during probe(), in this case we want to fail
> > > + * the creation of the mdev all the way back to sysfs. This is a weird model
> > > + * that doesn't fit in the driver core well, nor does it seem to appear any
> > > + * place else in the kernel, so use a simple hack.
> > > + */
> > > +static int mdev_bind_driver(struct mdev_device *mdev)
> > > +{
> > > +	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
> > > +	int ret;
> > > +
> > > +	if (!drv)
> > > +		drv = &vfio_mdev_driver;
> > > +
> > > +	while (1) {
> > > +		device_lock(&mdev->dev);
> > > +		if (mdev->dev.driver == &drv->driver) {
> > > +			ret = 0;
> > > +			goto out_unlock;
> > > +		}
> > > +		if (mdev->probe_err) {
> > > +			ret = mdev->probe_err;
> > > +			goto out_unlock;
> > > +		}
> > > +		device_unlock(&mdev->dev);
> > > +		ret = device_attach(&mdev->dev);
> > 
> > The sequence above looks sketchy:
> > 1. lock
> > 2. check for driver
> > 3. unlock
> > 4. device_attach - it takes internally same lock as in step 1.
> > 
> > Why don't you rely on internal to device_attach() driver check?
> 
> This is locking both probe_err and the check that the right driver is
> bound. device_attach() doesn't tell you the same information

device_attach() returns you the information that driver is already
bound, which is the same as you are doing here, because you don't
unbind "the wrong driver".

Thanks

> 
> Jason
