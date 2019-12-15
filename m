Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F42411FBB4
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2019 23:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLOWqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 17:46:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726219AbfLOWqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Dec 2019 17:46:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576450006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXF+NOL8cs5KVV01fZgEL5eG/R3TkoDYY4D2F7+iy5Q=;
        b=KgUmGn7bbNfGnUbS5M+gbrrbPrUtnaf3n2nrmmXajbG85VBWEqY6uXCbn8V6AR5sib8zdi
        lcUJ3yAvxICtBlG9HAlcumvGP2YxCYgLkV9ak1VWcxzQ7REykOp5ngoq8ku+X5qMH6E1x4
        xCOUAhBVpVE8cZeORzbOJ9rE4XXom3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-VNPPqdMRO4CqNXF-VSsU_A-1; Sun, 15 Dec 2019 17:46:45 -0500
X-MC-Unique: VNPPqdMRO4CqNXF-VSsU_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE56A1800D7B;
        Sun, 15 Dec 2019 22:46:43 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A6DF6046C;
        Sun, 15 Dec 2019 22:46:43 +0000 (UTC)
Date:   Sun, 15 Dec 2019 15:46:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 03/10] vfio_pci: refine vfio_pci_driver reference in
 vfio_pci.c
Message-ID: <20191215154642.1d4163bf@x1.home>
In-Reply-To: <1574335427-3763-4-git-send-email-yi.l.liu@intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
        <1574335427-3763-4-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 19:23:40 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch replaces the vfio_pci_driver reference in vfio_pci.c with
> pci_dev_driver(vdev->pdev) which is more helpful to make the functions
> be generic to module types.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index b04e43a..2096e66 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1460,24 +1460,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck *reflck)
>  
>  static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
>  {
> -	struct vfio_pci_reflck **preflck = data;
> +	struct vfio_pci_device *vdev = data;
> +	struct vfio_pci_reflck **preflck = &vdev->reflck;
>  	struct vfio_device *device;
> -	struct vfio_pci_device *vdev;
> +	struct vfio_pci_device *tmp;
>  
>  	device = vfio_device_get_from_dev(&pdev->dev);
>  	if (!device)
>  		return 0;
>  
> -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> +	if (pci_dev_driver(pdev) != pci_dev_driver(vdev->pdev)) {
>  		vfio_device_put(device);
>  		return 0;
>  	}
>  
> -	vdev = vfio_device_data(device);
> +	tmp = vfio_device_data(device);
>  
> -	if (vdev->reflck) {
> -		vfio_pci_reflck_get(vdev->reflck);
> -		*preflck = vdev->reflck;
> +	if (tmp->reflck) {
> +		vfio_pci_reflck_get(tmp->reflck);
> +		*preflck = tmp->reflck;
>  		vfio_device_put(device);
>  		return 1;
>  	}
> @@ -1494,7 +1495,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
>  
>  	if (pci_is_root_bus(vdev->pdev->bus) ||
>  	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
> -					  &vdev->reflck, slot) <= 0)
> +					  vdev, slot) <= 0)
>  		vdev->reflck = vfio_pci_reflck_alloc();
>  
>  	mutex_unlock(&reflck_lock);
> @@ -1519,6 +1520,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
>  
>  struct vfio_devices {
>  	struct vfio_device **devices;
> +	struct vfio_pci_device *vdev;
>  	int cur_index;
>  	int max_index;
>  };
> @@ -1527,7 +1529,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_devices *devs = data;
>  	struct vfio_device *device;
> -	struct vfio_pci_device *vdev;
> +	struct vfio_pci_device *tmp;
>  
>  	if (devs->cur_index == devs->max_index)
>  		return -ENOSPC;
> @@ -1536,15 +1538,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
>  	if (!device)
>  		return -EINVAL;
>  
> -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> +	if (pci_dev_driver(pdev) != pci_dev_driver(devs->vdev->pdev)) {
>  		vfio_device_put(device);
>  		return -EBUSY;
>  	}
>  
> -	vdev = vfio_device_data(device);
> +	tmp = vfio_device_data(device);
>  
>  	/* Fault if the device is not unused */
> -	if (vdev->refcnt) {
> +	if (tmp->refcnt) {
>  		vfio_device_put(device);
>  		return -EBUSY;
>  	}
> @@ -1590,6 +1592,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
>  	if (!devs.devices)
>  		return;
>  
> +	devs.vdev = vdev;

This could be added to the declaration initializer:

struct vfio_devices devs = { .vdev = vdev, .cur_index = 0 };

It might seem a little less random then.  Thanks,

Alex


>  	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
>  					  vfio_pci_get_unused_devs,
>  					  &devs, slot))
> @@ -1634,7 +1637,7 @@ static void __exit vfio_pci_cleanup(void)
>  	vfio_pci_uninit_perm_bits();
>  }
>  
> -static void __init vfio_pci_fill_ids(char *ids)
> +static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
>  {
>  	char *p, *id;
>  	int rc;
> @@ -1662,7 +1665,7 @@ static void __init vfio_pci_fill_ids(char *ids)
>  			continue;
>  		}
>  
> -		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
> +		rc = pci_add_dynid(driver, vendor, device,
>  				   subvendor, subdevice, class, class_mask, 0);
>  		if (rc)
>  			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
> @@ -1689,7 +1692,7 @@ static int __init vfio_pci_init(void)
>  	if (ret)
>  		goto out_driver;
>  
> -	vfio_pci_fill_ids(ids);
> +	vfio_pci_fill_ids(ids, &vfio_pci_driver);
>  
>  	return 0;
>  

