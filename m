Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3EF340AAC
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhCRQvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 12:51:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232252AbhCRQuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 12:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616086239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaZF20iybSS0n6S+DWZ/YEzP0JGngaW3uy7AT+FG30M=;
        b=LE/+yKNlaWFmotv2cQ7YywQOR4fhdCU0TytGW+jFATZNLrikm/vbvDv/AjfV5nSnPZiQ16
        IloyKY978pNRucjW/WVDYRX4an8z82e+NUaFHEMoSEb58m6YMTv2BvuIO1kj3lCyx1mFuQ
        JI/8BvxMNzO+idtCTbQMimSEP06GiEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-9p2IkOtePyyzCgESQUKmVA-1; Thu, 18 Mar 2021 12:50:37 -0400
X-MC-Unique: 9p2IkOtePyyzCgESQUKmVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9436A18C8C02;
        Thu, 18 Mar 2021 16:50:35 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3740D50DD0;
        Thu, 18 Mar 2021 16:50:28 +0000 (UTC)
Subject: Re: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
To:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c68db5c7-873f-595d-19f9-19d6b2bee4a5@redhat.com>
Date:   Thu, 18 Mar 2021 17:50:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 3/13/21 1:56 AM, Jason Gunthorpe wrote:
> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
> 
> For instance vfio_pci_reflck_attach() sets vdev->reflck and
> vfio_pci_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.>
> Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/pci/vfio_pci.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f95b58376156a0..0e7682e7a0b478 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2030,13 +2030,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	INIT_LIST_HEAD(&vdev->vma_list);
>  	init_rwsem(&vdev->memory_lock);
>  
> -	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> -	if (ret)
> -		goto out_free;
> -
>  	ret = vfio_pci_reflck_attach(vdev);
>  	if (ret)
> -		goto out_del_group_dev;
> +		goto out_free;
>  	ret = vfio_pci_vf_init(vdev);
>  	if (ret)
>  		goto out_reflck;
> @@ -2060,15 +2056,20 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  	}
>  
> -	return ret;
> +	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> +	if (ret)
> +		goto out_power;
> +	return 0;
>  
> +out_power:
> +	if (!disable_idle_d3)
> +		vfio_pci_set_power_state(vdev, PCI_D0);
>  out_vf:
>  	vfio_pci_vf_uninit(vdev);
>  out_reflck:
>  	vfio_pci_reflck_put(vdev->reflck);
> -out_del_group_dev:
> -	vfio_del_group_dev(&pdev->dev);
>  out_free:
> +	kfree(vdev->pm_save);
>  	kfree(vdev);
>  out_group_put:
>  	vfio_iommu_group_put(group, &pdev->dev);
> 

