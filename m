Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCAD136373
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgAIWsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:48:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbgAIWsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 17:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578610109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=il5z5hNDqZdHrqEbb26XbJQCZp1DVjyvlZwu0D+QADY=;
        b=Txc6oxknxH4wQ90OhniwPLcFrAOG8XAQDuuc8Sr65CYb5dRRr5JWP5qgaCAY9hI9eIr16Z
        rPilX0mAJd29gzGFs9XS42XyPXFdIuM6wT+3dKX5nTmPCN8IimzOak90hNhER5snVVVXK4
        k668LxPbPFv5PvYuuNOWcweQbBE1yA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-BtuKcgDnNJSvsYoNdNbH0w-1; Thu, 09 Jan 2020 17:48:28 -0500
X-MC-Unique: BtuKcgDnNJSvsYoNdNbH0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DA67800D41;
        Thu,  9 Jan 2020 22:48:24 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C86A60F82;
        Thu,  9 Jan 2020 22:48:21 +0000 (UTC)
Date:   Thu, 9 Jan 2020 15:48:19 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kevin.tian@intel.com, joro@8bytes.org,
        peterx@redhat.com, baolu.lu@linux.intel.com
Subject: Re: [PATCH v4 03/12] vfio_pci: refine vfio_pci_driver reference in
 vfio_pci.c
Message-ID: <20200109154819.455f11d3@w520.home>
In-Reply-To: <1578398509-26453-4-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-4-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jan 2020 20:01:40 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch replaces the vfio_pci_driver reference in vfio_pci.c with
> pci_dev_driver(vdev->pdev) which is more helpful to make the functions
> be generic to module types.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 009d2df..9140f5e5 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1463,24 +1463,25 @@ static void vfio_pci_reflck_get(struct vfio_pci_reflck *reflck)
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

Seems we can do away with preflck entirely with this refactor, this
simply becomes vdev->reflck = tmp->reflck.  Thanks,

Alex

>  		vfio_device_put(device);
>  		return 1;
>  	}
> @@ -1497,7 +1498,7 @@ static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
>  
>  	if (pci_is_root_bus(vdev->pdev->bus) ||
>  	    vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_reflck_find,
> -					  &vdev->reflck, slot) <= 0)
> +					  vdev, slot) <= 0)
>  		vdev->reflck = vfio_pci_reflck_alloc();
>  
>  	mutex_unlock(&reflck_lock);
> @@ -1522,6 +1523,7 @@ static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
>  
>  struct vfio_devices {
>  	struct vfio_device **devices;
> +	struct vfio_pci_device *vdev;
>  	int cur_index;
>  	int max_index;
>  };
> @@ -1530,7 +1532,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_devices *devs = data;
>  	struct vfio_device *device;
> -	struct vfio_pci_device *vdev;
> +	struct vfio_pci_device *tmp;
>  
>  	if (devs->cur_index == devs->max_index)
>  		return -ENOSPC;
> @@ -1539,15 +1541,15 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
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
> @@ -1574,7 +1576,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
>   */
>  static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
>  {
> -	struct vfio_devices devs = { .cur_index = 0 };
> +	struct vfio_devices devs = { .vdev = vdev, .cur_index = 0 };
>  	int i = 0, ret = -EINVAL;
>  	bool slot = false;
>  	struct vfio_pci_device *tmp;
> @@ -1637,7 +1639,7 @@ static void __exit vfio_pci_cleanup(void)
>  	vfio_pci_uninit_perm_bits();
>  }
>  
> -static void __init vfio_pci_fill_ids(char *ids)
> +static void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
>  {
>  	char *p, *id;
>  	int rc;
> @@ -1665,7 +1667,7 @@ static void __init vfio_pci_fill_ids(char *ids)
>  			continue;
>  		}
>  
> -		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
> +		rc = pci_add_dynid(driver, vendor, device,
>  				   subvendor, subdevice, class, class_mask, 0);
>  		if (rc)
>  			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
> @@ -1692,7 +1694,7 @@ static int __init vfio_pci_init(void)
>  	if (ret)
>  		goto out_driver;
>  
> -	vfio_pci_fill_ids(ids);
> +	vfio_pci_fill_ids(ids, &vfio_pci_driver);
>  
>  	return 0;
>  

