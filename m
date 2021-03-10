Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823DB33364E
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhCJHXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:23:50 -0500
Received: from verein.lst.de ([213.95.11.211]:34870 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCJHXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:23:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8CFD268B05; Wed, 10 Mar 2021 08:23:40 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:23:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 01/10] vfio: Simplify the lifetime logic for vfio_device
Message-ID: <20210310072340.GA2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <1-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 05:38:43PM -0400, Jason Gunthorpe wrote:
> The vfio_device is using a 'sleep until all refs go to zero' pattern for
> its lifetime, but it is indirectly coded by repeatedly scanning the group
> list waiting for the device to be removed on its own.
> 
> Switch this around to be a direct representation, use a refcount to count
> the number of places that are blocking destruction and sleep directly on a
> completion until that counter goes to zero. kfree the device after other
> accesses have been excluded in vfio_del_group_dev(). This is a fairly
> common Linux idiom.
> 
> This simplifies a couple of things:
> 
> - kref_put_mutex() is very rarely used in the kernel. Here it is being
>   used to prevent a zero ref device from being seen in the group
>   list. Instead allow the zero ref device to continue to exist in the
>   device_list and use refcount_inc_not_zero() to exclude it once refs go
>   to zero.
> 
> - get/putting the group while get/putting the device. The device already
>   holds a reference to the group, set during vfio_group_create_device(),
>   there is no need for extra reference traffic. Cleanly have the balancing
>   group put in vfio_del_group_dev() before the kfree().

Might it be worth to split this further up into separate patches for
each of the changes?

The actual changes do look good, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>
