Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06FE33E099
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 22:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhCPVeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 17:34:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhCPVeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 17:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615930445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=89oX7AQuApRcUT6Z02580z5sKQ8loxfMTXV7o3/xaeg=;
        b=CGw9tQkPGbAWG1KpEKkHYG2V/tGYbXjboLyQQKoIPjcqvS/ULRt8jyMLBeDQwLMnuFi0z1
        tDVEI2JdkD7cRBUA+FazclA0lDv+jSNnGlXWSNAfndcZzM0Cdu3r5Ux4sBuceyFpekzDci
        wftZs3trp3bNI969NrFgQmr26M1k3n0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-uUnJ0uskN5y0kM4STSLENA-1; Tue, 16 Mar 2021 17:34:01 -0400
X-MC-Unique: uUnJ0uskN5y0kM4STSLENA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B42080D6A9;
        Tue, 16 Mar 2021 21:34:00 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 662185D9D3;
        Tue, 16 Mar 2021 21:33:56 +0000 (UTC)
Date:   Tue, 16 Mar 2021 15:33:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 04/14] vfio/platform: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210316153355.37c61a54@omen.home.shazbot.org>
In-Reply-To: <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:55:56 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> platform already allocates a struct vfio_platform_device with exactly
> the same lifetime as vfio_device, switch to the new API and embed
> vfio_device in vfio_platform_device.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
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
>  }
>  
>  static void vfio_amba_remove(struct amba_device *adev)
>  {
> -	struct vfio_platform_device *vdev =
> -		vfio_platform_remove_common(&adev->dev);
> +	struct vfio_platform_device *vdev = dev_get_drvdata(&adev->dev);
>  
> +	vfio_platform_remove_common(vdev);
>  	kfree(vdev->name);
>  	kfree(vdev);
>  }
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 9fb6818cea12cb..f7b3f64ecc7f6c 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -54,23 +54,22 @@ static int vfio_platform_probe(struct platform_device *pdev)
>  	vdev->reset_required = reset_required;
>  
>  	ret = vfio_platform_probe_common(vdev, &pdev->dev);
> -	if (ret)
> +	if (ret) {
>  		kfree(vdev);
> -
> -	return ret;
> +		return ret;
> +	}
> +	dev_set_drvdata(&pdev->dev, vdev);
> +	return 0;
>  }
>  
>  static int vfio_platform_remove(struct platform_device *pdev)
>  {
> -	struct vfio_platform_device *vdev;
> -
> -	vdev = vfio_platform_remove_common(&pdev->dev);
> -	if (vdev) {
> -		kfree(vdev);
> -		return 0;
> -	}
> +	struct vfio_platform_device *vdev = dev_get_drvdata(&pdev->dev);
>  
> -	return -EINVAL;
> +	vfio_platform_remove_common(vdev);
> +	kfree(vdev->name);


We don't own that to free it, _probe set this via:

        vdev->name = pdev->name;

Thanks,
Alex

