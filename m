Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EBA340713
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCRNob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:44:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhCRNoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616075056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGlg322XRbcwDqOF7St/3XfP5kAqTzbK8aPd9dO8dIQ=;
        b=SBV9+dJDTQVyZHJ6uZ1v3zK8YJi7CLISNttLh+aPFbQf/eb/jricreEIcmKtJcaeVRwWW2
        ZFBcqsaPFO5xeMrv6Ijg0jEkDU9o3IpHm5IJU2bGPqzPkD+zuaWGeSaTWjrPWYd/Wn+nDJ
        m7vRA0MsUMBO5MactW+Z787p21+k4lA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-NDMPbmYVPom4ZDTQPf4zJQ-1; Thu, 18 Mar 2021 09:44:14 -0400
X-MC-Unique: NDMPbmYVPom4ZDTQPf4zJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50BF219251A4;
        Thu, 18 Mar 2021 13:44:12 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F70160C13;
        Thu, 18 Mar 2021 13:44:00 +0000 (UTC)
Subject: Re: [PATCH v2 09/14] vfio/pci: Use
 vfio_init/register/unregister_group_dev
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
References: <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <3701aa1a-9423-8389-53c2-0eca599cb789@redhat.com>
Date:   Thu, 18 Mar 2021 14:43:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/13/21 1:56 AM, Jason Gunthorpe wrote:
> pci already allocates a struct vfio_pci_device with exactly the same
> lifetime as vfio_device, switch to the new API and embed vfio_device in
> vfio_pci_device.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/pci/vfio_pci.c         | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0e7682e7a0b478..a0ac20a499cf6c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2019,6 +2019,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto out_group_put;
>  	}
>  
> +	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
>  	vdev->pdev = pdev;
>  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
>  	mutex_init(&vdev->igate);
> @@ -2056,9 +2057,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  	}
>  
> -	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> +	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
>  		goto out_power;
> +	dev_set_drvdata(&pdev->dev, vdev);
>  	return 0;
>  
>  out_power:
> @@ -2078,13 +2080,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  static void vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct vfio_pci_device *vdev;
> +	struct vfio_pci_device *vdev = dev_get_drvdata(&pdev->dev);
>  
>  	pci_disable_sriov(pdev);
>  
> -	vdev = vfio_del_group_dev(&pdev->dev);
> -	if (!vdev)
> -		return;
> +	vfio_unregister_group_dev(&vdev->vdev);
>  
>  	vfio_pci_vf_uninit(vdev);
>  	vfio_pci_reflck_put(vdev->reflck);
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 9cd1882a05af69..8755a0febd054a 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -100,6 +100,7 @@ struct vfio_pci_mmap_vma {
>  };
>  
>  struct vfio_pci_device {
> +	struct vfio_device	vdev;
>  	struct pci_dev		*pdev;
>  	void __iomem		*barmap[PCI_STD_NUM_BARS];
>  	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
> 

