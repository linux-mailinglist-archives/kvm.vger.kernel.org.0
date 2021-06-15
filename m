Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB073A7661
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 07:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFOFUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 01:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhFOFUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 01:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E201613F5;
        Tue, 15 Jun 2021 05:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623734299;
        bh=UwqM6muGBCJRYHhL48W9oK25DYg39c7HHC986x5IWY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUI8yOYAp6W5cgy7iXjxOF7pKpzn9F/sKymWLzbnB0wKS+oQdA9ylO+AXLItlY0Xp
         Hlpc32++O9Puc63Q4SA/YjzYJznvxPjcADR4z3jeDFvxJcwYIqQ83pV90Hpa0YgH0R
         sWMJ9rAzXD37AuKs6v1hy4wU+RTf6EhL1J4Tziik=
Date:   Tue, 15 Jun 2021 07:18:15 +0200
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
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <YMg4F99j2nsjGxAz@kroah.com>
References: <20210614150846.4111871-1-hch@lst.de>
 <20210614150846.4111871-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614150846.4111871-4-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 05:08:39PM +0200, Christoph Hellwig wrote:
> Currently really_probe() returns 1 on success and 0 if the probe() call
> fails. This return code arrangement is designed to be useful for
> __device_attach_driver() which is walking the device list and trying every
> driver. 0 means to keep trying.
> 
> However, it is not useful for the other places that call through to
> really_probe() that do actually want to see the probe() return code.
> 
> For instance bind_store() would be better to return the actual error code
> from the driver's probe method, not discarding it and returning -ENODEV.
> 
> Reorganize things so that really_probe() returns the error code from
> ->probe as a (inverted) positive number, and 0 for successful attach.
> 
> With this, __device_attach_driver can ignore the (positive) probe errors,
> return 1 to exit the loop for a successful binding and pass on the
> other negative errors, while device_driver_attach simplify inverts the
> positive errors and returns all errors to the sysfs code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/base/bus.c |  6 +-----
>  drivers/base/dd.c  | 29 ++++++++++++++++++++---------
>  2 files changed, 21 insertions(+), 14 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
