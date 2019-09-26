Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A4CBEAAB
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 04:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391394AbfIZChA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 22:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390741AbfIZChA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 22:37:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B7DD81F0C;
        Thu, 26 Sep 2019 02:36:59 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C05AC60C44;
        Thu, 26 Sep 2019 02:36:58 +0000 (UTC)
Date:   Wed, 25 Sep 2019 20:36:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yan.y.zhao@intel.com, shaopeng.he@intel.com, chenbo.xia@intel.com,
        jun.j.tian@intel.com
Subject: Re: [PATCH v2 11/13] samples/vfio-mdev-pci: call
 vfio_add_group_dev()
Message-ID: <20190925203658.18ea50ab@x1.home>
In-Reply-To: <1567670370-4484-12-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-12-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 26 Sep 2019 02:36:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Sep 2019 15:59:28 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch adds vfio_add_group_dev() calling in probe() to make
> vfio-mdev-pci work well with non-singleton iommu group. User could
> bind devices from a non-singleton iommu group to either vfio-pci
> driver or this sample driver. Existing passthru policy works well
> for this non-singleton group.
> 
> This is actually a policy choice. A device driver can make this call
> if it wants to be vfio viable. And it needs to provide dummy
> vfio_device_ops which is required by vfio framework. To prevent user
> from opening the device from the iommu backed group fd, the open
> callback of the dummy vfio_device_ops should return -ENODEV to fail
> the VFIO_GET_DEVICE_FD request from userspace.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_mdev_pci.c | 91 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 82 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_mdev_pci.c b/drivers/vfio/pci/vfio_mdev_pci.c
> index 09143d3..a61c20d 100644
> --- a/drivers/vfio/pci/vfio_mdev_pci.c
> +++ b/drivers/vfio/pci/vfio_mdev_pci.c
> @@ -107,19 +107,27 @@ struct vfio_mdev_pci {
>  static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device *mdev)
>  {
>  	struct device *pdev;
> +	struct vfio_device *device;
>  	struct vfio_mdev_pci_device *vmdev;
>  	struct vfio_mdev_pci *pmdev;
>  	int ret;
>  
>  	pdev = mdev_parent_dev(mdev);
> -	vmdev = dev_get_drvdata(pdev);
> +	device = vfio_device_get_from_dev(pdev);
> +	vmdev = vfio_device_data(device);
>  
> -	if (atomic_dec_if_positive(&vmdev->avail) < 0)
> -		return -ENOSPC;
> +	if (atomic_dec_if_positive(&vmdev->avail) < 0) {
> +		ret = -ENOSPC;
> +		goto out;
> +	}
>  
> +	pr_info("%s, available instance: %d\n",
> +			__func__, atomic_read(&vmdev->avail));
>  	pmdev = kzalloc(sizeof(struct vfio_mdev_pci), GFP_KERNEL);
> -	if (!pmdev)
> -		return -ENOMEM;
> +	if (!pmdev) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
>  	pmdev->mdev = mdev;
>  	pmdev->vdev = &vmdev->vdev;
> @@ -130,10 +138,11 @@ static int vfio_mdev_pci_create(struct kobject *kobj, struct mdev_device *mdev)
>  			__func__, dev_name(mdev_dev(mdev)), dev_name(pdev));
>  		kfree(pmdev);
>  		atomic_inc(&vmdev->avail);
> -		return ret;
>  	}
>  
> -	return 0;
> +out:
> +	vfio_device_put(device);
> +	return ret;
>  }
>  
>  static int vfio_mdev_pci_remove(struct mdev_device *mdev)
> @@ -145,6 +154,8 @@ static int vfio_mdev_pci_remove(struct mdev_device *mdev)
>  
>  	kfree(pmdev);
>  	atomic_inc(&vmdev->avail);
> +	pr_info("%s, available instance: %d\n",
> +			__func__, atomic_read(&vmdev->avail));
>  	pr_info("%s, succeeded for mdev: %s\n", __func__,
>  		     dev_name(mdev_dev(mdev)));
>  
> @@ -236,12 +247,65 @@ static ssize_t vfio_mdev_pci_write(struct mdev_device *mdev,
>  	return vfio_pci_write(pmdev->vdev, (char __user *)buf, count, ppos);
>  }
>  
> +static int vfio_pci_dummy_open(void *device_data)
> +{
> +	struct vfio_mdev_pci_device *vmdev =
> +		(struct vfio_mdev_pci_device *) device_data;
> +	pr_warn("Device %s is not viable for vfio-pci passthru, please follow"
> +		" vfio-mdev passthru path as it has been wrapped as mdev!!!\n",
> +					dev_name(&vmdev->vdev.pdev->dev));
> +	return -ENODEV;
> +}
> +
> +static void vfio_pci_dummy_release(void *device_data)
> +{
> +}

Theoretically .release will never be called.  If we're paranoid, we
could keep it with a pr_warn.

> +
> +long vfio_pci_dummy_ioctl(void *device_data,
> +		   unsigned int cmd, unsigned long arg)
> +{
> +	return 0;
> +}
> +
> +ssize_t vfio_pci_dummy_read(void *device_data, char __user *buf,
> +			     size_t count, loff_t *ppos)
> +{
> +	return 0;
> +}
> +
> +ssize_t vfio_pci_dummy_write(void *device_data, const char __user *buf,
> +			      size_t count, loff_t *ppos)
> +{
> +	return 0;
> +}
> +
> +int vfio_pci_dummy_mmap(void *device_data, struct vm_area_struct *vma)
> +{
> +	return 0;
> +}
> +
> +void vfio_pci_dummy_request(void *device_data, unsigned int count)
> +{
> +}

AFAICT, none of .ioctl, .read, .write, .mmap, or .request need to be
provided, only .open and only .release for paranoia.

> +
> +static const struct vfio_device_ops vfio_pci_dummy_ops = {
> +	.name		= "vfio-pci",

This is impersonating vfio-pci, shouldn't we use something like
"vfio-mdev-pci-dummy".  Thanks,

Alex

> +	.open		= vfio_pci_dummy_open,
> +	.release	= vfio_pci_dummy_release,
> +	.ioctl		= vfio_pci_dummy_ioctl,
> +	.read		= vfio_pci_dummy_read,
> +	.write		= vfio_pci_dummy_write,
> +	.mmap		= vfio_pci_dummy_mmap,
> +	.request	= vfio_pci_dummy_request,
> +};
> +
>  static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
>  				       const struct pci_device_id *id)
>  {
>  	struct vfio_mdev_pci_device *vmdev;
>  	struct vfio_pci_device *vdev;
>  	const struct mdev_parent_ops *ops;
> +	struct iommu_group *group;
>  	int ret;
>  
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
> @@ -260,6 +324,10 @@ static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
>  		return -EBUSY;
>  	}
>  
> +	group = vfio_iommu_group_get(&pdev->dev);
> +	if (!group)
> +		return -EINVAL;
> +
>  	vmdev = kzalloc(sizeof(*vmdev), GFP_KERNEL);
>  	if (!vmdev)
>  		return -ENOMEM;
> @@ -304,7 +372,12 @@ static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev,
>  #endif
>  	vdev->disable_idle_d3 = disable_idle_d3;
>  
> -	pci_set_drvdata(pdev, vmdev);
> +	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_dummy_ops, vmdev);
> +	if (ret) {
> +		vfio_iommu_group_put(group, &pdev->dev);
> +		kfree(vmdev);
> +		return ret;
> +	}
>  
>  	ret = vfio_pci_reflck_attach(vdev);
>  	if (ret) {
> @@ -352,7 +425,7 @@ static void vfio_mdev_pci_driver_remove(struct pci_dev *pdev)
>  
>  	mdev_unregister_device(&pdev->dev);
>  
> -	vmdev = pci_get_drvdata(pdev);
> +	vmdev = vfio_del_group_dev(&pdev->dev);
>  	if (!vmdev)
>  		return;
>  

