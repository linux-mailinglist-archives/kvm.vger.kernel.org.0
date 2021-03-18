Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A90A340A45
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 17:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhCRQe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 12:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230338AbhCRQew (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 12:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616085291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MY102WFaoHGo6S9XGwJx88QjyNpLXxzZnrwOscvPt/4=;
        b=eF9ogPgMia8BJVyfJBMzgvREs5KpbiV0nhotMOMYzZzivzGn1Npqah0o9p2GgCKLIY3V/J
        2M/u+dDP7HOTRCldJAk01U4RQUF53dDLQeTDhktK0u8YajPB8J4zWmL0vSyciTq8rZjpPR
        asc8D8kKcKtiGTmc2yxEo4adGs53cGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-W8KXxFj9Mj-MweGDGuaXkQ-1; Thu, 18 Mar 2021 12:34:48 -0400
X-MC-Unique: W8KXxFj9Mj-MweGDGuaXkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EEC3107B7C4;
        Thu, 18 Mar 2021 16:34:46 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C5945D9D0;
        Thu, 18 Mar 2021 16:34:31 +0000 (UTC)
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1cd68e26-78a3-79e7-9587-06c770555a24@redhat.com>
Date:   Thu, 18 Mar 2021 17:34:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 3/13/21 1:55 AM, Jason Gunthorpe wrote:
> vfio_pci_probe() is quite complicated, with optional VF and VGA sub
> components. Move these into clear init/uninit functions and have a linear
> flow in probe/remove.
> 
> This fixes a few little buglets:
>  - vfio_pci_remove() is in the wrong order, vga_client_register() removes
>    a notifier and is after kfree(vdev), but the notifier refers to vdev,
>    so it can use after free in a race.
>  - vga_client_register() can fail but was ignored
> 
> Organize things so destruction order is the reverse of creation order.
> 
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
>  1 file changed, 74 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578c2..f95b58376156a0 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1922,6 +1922,68 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  	return 0;
>  }
>  
> +static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +
> +	if (!pdev->is_physfn)
> +		return 0;
> +
> +	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> +	if (!vdev->vf_token)
> +		return -ENOMEM;
> +
> +	mutex_init(&vdev->vf_token->lock);
> +	uuid_gen(&vdev->vf_token->uuid);
> +
> +	vdev->nb.notifier_call = vfio_pci_bus_notifier;
> +	ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
> +	if (ret) {
> +		kfree(vdev->vf_token);> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
> +{
> +	if (!vdev->vf_token)
> +		return;
> +
> +	bus_unregister_notifier(&pci_bus_type, &vdev->nb);
> +	WARN_ON(vdev->vf_token->users);
> +	mutex_destroy(&vdev->vf_token->lock);
> +	kfree(vdev->vf_token);
> +}
> +
> +static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +
> +	if (!vfio_pci_is_vga(pdev))
> +		return 0;
> +
> +	ret = vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
> +	if (ret)
> +		return ret;
> +	vga_set_legacy_decoding(pdev, vfio_pci_set_vga_decode(vdev, false));
> +	return 0;
> +}
> +
> +static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	if (!vfio_pci_is_vga(pdev))
> +		return;
> +	vga_client_register(pdev, NULL, NULL, NULL);
> +	vga_set_legacy_decoding(pdev, VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> +					      VGA_RSRC_LEGACY_IO |
> +					      VGA_RSRC_LEGACY_MEM);
> +}
> +
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct vfio_pci_device *vdev;
> @@ -1975,28 +2037,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	ret = vfio_pci_reflck_attach(vdev);
>  	if (ret)
>  		goto out_del_group_dev;
> -
> -	if (pdev->is_physfn) {
> -		vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> -		if (!vdev->vf_token) {
> -			ret = -ENOMEM;
> -			goto out_reflck;
> -		}
> -
> -		mutex_init(&vdev->vf_token->lock);
> -		uuid_gen(&vdev->vf_token->uuid);
> -
> -		vdev->nb.notifier_call = vfio_pci_bus_notifier;
> -		ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
> -		if (ret)
> -			goto out_vf_token;
> -	}
> -
> -	if (vfio_pci_is_vga(pdev)) {
> -		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
> -		vga_set_legacy_decoding(pdev,
> -					vfio_pci_set_vga_decode(vdev, false));
> -	}
> +	ret = vfio_pci_vf_init(vdev);
> +	if (ret)
> +		goto out_reflck;
> +	ret = vfio_pci_vga_init(vdev);
> +	if (ret)
> +		goto out_vf;
>  
>  	vfio_pci_probe_power_state(vdev);
>  
> @@ -2016,8 +2062,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	return ret;
>  
> -out_vf_token:
> -	kfree(vdev->vf_token);
> +out_vf:
> +	vfio_pci_vf_uninit(vdev);
>  out_reflck:
>  	vfio_pci_reflck_put(vdev->reflck);
>  out_del_group_dev:
> @@ -2039,33 +2085,19 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>  	if (!vdev)
>  		return;
>  
> -	if (vdev->vf_token) {
> -		WARN_ON(vdev->vf_token->users);
> -		mutex_destroy(&vdev->vf_token->lock);
> -		kfree(vdev->vf_token);
> -	}
> -
> -	if (vdev->nb.notifier_call)
> -		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
> -
> +	vfio_pci_vf_uninit(vdev);
>  	vfio_pci_reflck_put(vdev->reflck);
> +	vfio_pci_vga_uninit(vdev);
>  
>  	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
> -	kfree(vdev->region);
> -	mutex_destroy(&vdev->ioeventfds_lock);
>  
>  	if (!disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  
> +	mutex_destroy(&vdev->ioeventfds_lock);
> +	kfree(vdev->region);
>  	kfree(vdev->pm_save);
>  	kfree(vdev);
> -
> -	if (vfio_pci_is_vga(pdev)) {
> -		vga_client_register(pdev, NULL, NULL, NULL);
> -		vga_set_legacy_decoding(pdev,
> -				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> -				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
> -	}
>  }
>  
>  static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
> 

