Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664203A766D
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 07:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhFOFYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 01:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230350AbhFOFYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 01:24:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153BA613F5;
        Tue, 15 Jun 2021 05:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623734521;
        bh=I39eG9DNQO5bFfL3wXseI58XyVG3Y8z2W0Y1TkWzgO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ztK+clL6V3mIt2G9rcTU4SQmhwcUWWdJgQXJNfpGN/uX2Xm3l2XpnaJX/9VD1p64Y
         AdsF/nKGkKgDZbetOFE2tPfxUlK2OD8F3z075wFMJt2TC96YffNyeGoHzWWHS7oKg1
         gyrRenAWkr8N+pEUOqcGjE/GPZsQwhq+Cyi8QdFA=
Date:   Tue, 15 Jun 2021 07:21:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: Allow mdev drivers to directly create the vfio_device (v2 /
 alternative)
Message-ID: <YMg49UF8of2yHWum@kroah.com>
References: <20210614150846.4111871-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614150846.4111871-1-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 05:08:36PM +0200, Christoph Hellwig wrote:
> This is my alternative take on this series from Jason:
> 
> https://lore.kernel.org/dri-devel/87czsszi9i.fsf@redhat.com/T/
> 
> The mdev/vfio parts are exactly the same, but this solves the driver core
> changes for the direct probing without the in/out flag that Greg hated,
> which cause a little more work, but probably make the result better.
> 
> Original decription from Jason below:
> 
> The mdev bus's core part for managing the lifecycle of devices is mostly
> as one would expect for a driver core bus subsystem.
> 
> However instead of having a normal 'struct device_driver' and binding the
> actual mdev drivers through the standard driver core mechanisms it open
> codes this with the struct mdev_parent_ops and provides a single driver
> that shims between the VFIO core's struct vfio_device and the actual
> device driver.
> 
> Instead, allow mdev drivers implement an actual struct mdev_driver and
> directly call vfio_register_group_dev() in the probe() function for the
> mdev. Arrange to bind the created mdev_device to the mdev_driver that is
> provided by the end driver.
> 
> The actual execution flow doesn't change much, eg what was
> parent_ops->create is now device_driver->probe and it is called at almost
> the exact same time - except under the normal control of the driver core.
> 
> Ultimately converting all the drivers unlocks a fair number of additional
> VFIO simplifications and cleanups.

This looks much better as far as the driver core changes go, thank you
for doing this.

I'm guessing there will be at least one more revision of this.  Do you
want this to go through my driver core tree or is there a mdev tree it
should go through?  Either is fine for me.

thanks,

greg k-h
