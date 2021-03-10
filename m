Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDF333667
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 08:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhCJH3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 02:29:20 -0500
Received: from verein.lst.de ([213.95.11.211]:34895 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhCJH2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 02:28:54 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0310968BEB; Wed, 10 Mar 2021 08:28:51 +0100 (CET)
Date:   Wed, 10 Mar 2021 08:28:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 03/10] vfio/platform: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210310072850.GC2659@lst.de>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com> <3-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 05:38:45PM -0400, Jason Gunthorpe wrote:
> platform already allocates a struct vfio_platform_device with exactly
> the same lifetime as vfio_device, switch to the new API and embed
> vfio_device in vfio_platform_device.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/vfio_amba.c             |  8 ++++---
>  drivers/vfio/platform/vfio_platform.c         | 21 ++++++++---------
>  drivers/vfio/platform/vfio_platform_common.c  | 23 +++++++------------
>  drivers/vfio/platform/vfio_platform_private.h |  5 ++--
>  4 files changed, 26 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 3626c21501017e..f970eb2a999f29 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -66,16 +66,18 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>  	if (ret) {
>  		kfree(vdev->name);
>  		kfree(vdev);
> +		return ret;
>  	}
>  
> -	return ret;
> +	dev_set_drvdata(&adev->dev, vdev);
> +	return 0;

Switching to goto based unwind here would be helpful as well..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
