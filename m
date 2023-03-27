Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9226CAE8C
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjC0T1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 15:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjC0T1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 15:27:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB72CD
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 12:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679945184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YsJ82OYx+hJHZIpI5yk6abwb8YmFKXJFuVMXDYupmyI=;
        b=gVDElN/Sa2BBm1P5vEjlefuCXrShq3FcFTAt5qmHDGgf6yM/b/uvbeAWWyEskVs7gyfH/3
        wNV7S1E2SF4r1gOeTwk4uMd5PdsOtJmeYPwl+dZ0ew+v6AcSIFZ0MsObkSH954WdSIDaYD
        lJd83rOOsFAJsf/V9OWSYluCtDcsWho=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-T6youR3XNW6WZNUeDw_pog-1; Mon, 27 Mar 2023 15:26:23 -0400
X-MC-Unique: T6youR3XNW6WZNUeDw_pog-1
Received: by mail-il1-f199.google.com with SMTP id a17-20020a921a11000000b00325f9878441so3582940ila.7
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 12:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679945182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsJ82OYx+hJHZIpI5yk6abwb8YmFKXJFuVMXDYupmyI=;
        b=Q2WzntEpAamC/oF13yVy1DR/ZtjNbDFEyMuLyvIHAsywsTrxqmZ3F7dhMpDnMRy8NN
         qFmnoJpcH2VLGXy7t1AEjiiSGsUHGCCvWmaLnm5ir4JZx94vD/lGP4ILIu9lsBGQogup
         hqMTW5PMAH0WpETBfbTEV1HYt1TZySdaeHX+LR6f5/pNjnIs1vqEsH7SQRexH97odzgq
         65vBYvNpq2VG+G9l6GRRySA9oz/hZLkIPbY/9myRTmOxcC1AroVjhgMoNAugcg3+Mr/p
         NljLI9XohUbYBW9NtFqM+YBKA6VhNKa14HKnUZ+EKXSYsKOKFpdPzLplaW+6zYUzelCb
         xsKA==
X-Gm-Message-State: AAQBX9cdJ7IB/21oERVMYaDU6wweF7y5jGbMdPcxM1pBHqHDWqZ+u652
        sKCQeZmRNwLtZmf4j8MIFUkwV9Po+vI1039YOfKHV8mh8eCV8C6vUoz9GtEg4zHHlBCRN8ogN/m
        Udu5CfIZyuPFt
X-Received: by 2002:a92:d40a:0:b0:31f:9b6e:2f49 with SMTP id q10-20020a92d40a000000b0031f9b6e2f49mr10852817ilm.10.1679945182676;
        Mon, 27 Mar 2023 12:26:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y2QNTmEbvdTz9lk9IkQz7nrMs0PzBDjUBGarV1PGA7S1BCrjZKxc1bKrijv1Hfy90uc2/XWg==
X-Received: by 2002:a92:d40a:0:b0:31f:9b6e:2f49 with SMTP id q10-20020a92d40a000000b0031f9b6e2f49mr10852782ilm.10.1679945182317;
        Mon, 27 Mar 2023 12:26:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x10-20020a92300a000000b0030c0dce44b1sm8006694ile.15.2023.03.27.12.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 12:26:21 -0700 (PDT)
Date:   Mon, 27 Mar 2023 13:26:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <20230327132619.5ab15440.alex.williamson@redhat.com>
In-Reply-To: <20230327093458.44939-11-yi.l.liu@intel.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Mar 2023 02:34:58 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This is a preparation for vfio device cdev as cdev gives userspace the
> capability to open device cdev fd and management stack (e.g. libvirt)
> could pass the device fd to the actual user (e.g. QEMU). As a result,
> the actual user has no idea about the device's bus:devfn information.
> This is a problem when user uses VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to
> know the hot reset affected device scope as this ioctl returns bus:devfn
> info. For the fd passing usage, the acutal user cannot map the bus:devfn
> to the devices it has opened via the fd passed from management stack. So
> a new ioctl is required.
> 
> This new ioctl reports the list of iommufd dev_id that is opened by the
> user. If there is affected device that is not bound to vfio driver or
> opened by another user, this command shall fail with -EPERM. For the
> noiommu mode in the vfio device cdev path, this shall fail as no dev_id
> would be generated, hence nothing to report.
> 
> This ioctl is useless to the users that open vfio group as such users
> have no idea about the iommufd dev_id and it can use the existing
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO. The user that uses the traditional
> mode vfio group/container would be failed if invoking this ioctl. But
> the user that uses the iommufd compat mode vfio group/container shall
> succeed. This is harmless as long as user cannot make use of it and
> should use VFIO_DEVICE_GET_PCI_HOT_RESET_INFO.


So VFIO_DEVICE_GET_PCI_HOT_RESET_INFO reports a group and bdf, but
VFIO_DEVICE_GET_PCI_HOT_RESET_*GROUP*_INFO is meant for the non-group,
cdev use case and returns a dev_id rather than a group???

Additionally, VFIO_DEVICE_GET_PCI_HOT_RESET_INFO has a flags arg that
isn't used, why do we need a new ioctl vs defining
VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID.  In fact, we could define
vfio_dependent_device as:

struct vfio_pci_dependent_device {
	union {
	        __u32   group_id;
		__u32	dev_id;
	}
        __u16   segment;
        __u8    bus;
        __u8    devfn;
};

If the user calls with the above flag, dev_id is valid, otherwise
group_id.  Perhaps segment:buus:devfn could still be filled in with a
NULL/invalid dev_id if the user doesn't have permissions for the device
so that debugging from userspace isn't so opaque.  Thanks,

Alex
 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 98 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h        | 47 +++++++++++++++
>  2 files changed, 145 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 19f5b075d70a..45edf4e9b98b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1181,6 +1181,102 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
>  	return ret;
>  }
>  
> +static struct pci_dev *
> +vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set);
> +
> +static int vfio_pci_ioctl_get_pci_hot_reset_group_info(
> +	struct vfio_pci_core_device *vdev,
> +	struct vfio_pci_hot_reset_group_info __user *arg)
> +{
> +	unsigned long minsz =
> +		offsetofend(struct vfio_pci_hot_reset_group_info, count);
> +	struct vfio_pci_hot_reset_group_info hdr;
> +	struct iommufd_ctx *iommufd, *cur_iommufd;
> +	u32 count = 0, index = 0, *devices = NULL;
> +	struct vfio_pci_core_device *cur;
> +	bool slot = false;
> +	int ret = 0;
> +
> +	if (copy_from_user(&hdr, arg, minsz))
> +		return -EFAULT;
> +
> +	if (hdr.argsz < minsz)
> +		return -EINVAL;
> +
> +	hdr.flags = 0;
> +
> +	/* Can we do a slot or bus reset or neither? */
> +	if (!pci_probe_reset_slot(vdev->pdev->slot))
> +		slot = true;
> +	else if (pci_probe_reset_bus(vdev->pdev->bus))
> +		return -ENODEV;
> +
> +	mutex_lock(&vdev->vdev.dev_set->lock);
> +	if (!vfio_pci_dev_set_resettable(vdev->vdev.dev_set)) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +
> +	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
> +	if (!iommufd) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +
> +	/* How many devices are affected? */
> +	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
> +					    &count, slot);
> +	if (ret)
> +		goto out_unlock;
> +
> +	WARN_ON(!count); /* Should always be at least one */
> +
> +	/*
> +	 * If there's enough space, fill it now, otherwise return -ENOSPC and
> +	 * the number of devices affected.
> +	 */
> +	if (hdr.argsz < sizeof(hdr) + (count * sizeof(*devices))) {
> +		ret = -ENOSPC;
> +		hdr.count = count;
> +		goto reset_info_exit;
> +	}
> +
> +	devices = kcalloc(count, sizeof(*devices), GFP_KERNEL);
> +	if (!devices) {
> +		ret = -ENOMEM;
> +		goto reset_info_exit;
> +	}
> +
> +	list_for_each_entry(cur, &vdev->vdev.dev_set->device_list, vdev.dev_set_list) {
> +		cur_iommufd = vfio_iommufd_physical_ictx(&cur->vdev);
> +		if (cur->vdev.open_count) {
> +			if (cur_iommufd != iommufd) {
> +				ret = -EPERM;
> +				break;
> +			}
> +			ret = vfio_iommufd_physical_devid(&cur->vdev, &devices[index]);
> +			if (ret)
> +				break;
> +			index++;
> +		}
> +	}
> +
> +reset_info_exit:
> +	if (copy_to_user(arg, &hdr, minsz))
> +		ret = -EFAULT;
> +
> +	if (!ret) {
> +		if (copy_to_user(&arg->devices, devices,
> +				 hdr.count * sizeof(*devices)))
> +			ret = -EFAULT;
> +	}
> +
> +	kfree(devices);
> +out_unlock:
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
> +	return ret;
> +}
> +
>  static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	struct vfio_pci_core_device *vdev,
>  	struct vfio_pci_hot_reset_info __user *arg)
> @@ -1404,6 +1500,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		return vfio_pci_ioctl_get_irq_info(vdev, uarg);
>  	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
>  		return vfio_pci_ioctl_get_pci_hot_reset_info(vdev, uarg);
> +	case VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO:
> +		return vfio_pci_ioctl_get_pci_hot_reset_group_info(vdev, uarg);
>  	case VFIO_DEVICE_GET_REGION_INFO:
>  		return vfio_pci_ioctl_get_region_info(vdev, uarg);
>  	case VFIO_DEVICE_IOEVENTFD:
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 25432ef213ee..61b801dfd40b 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -669,6 +669,53 @@ struct vfio_pci_hot_reset_info {
>  
>  #define VFIO_DEVICE_GET_PCI_HOT_RESET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
>  
> +/**
> + * VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
> + *						    struct vfio_pci_hot_reset_group_info)
> + *
> + * This is used in the vfio device cdev mode.  It returns the list of
> + * affected devices (represented by iommufd dev_id) when hot reset is
> + * issued on the current device with which this ioctl is invoked.  It
> + * only includes the devices that are opened by the current user in the
> + * time of this command is invoked.  This list may change when user opens
> + * new device or close opened device, hence user should re-invoke it
> + * after open/close devices.  This command has no guarantee on the result
> + * of VFIO_DEVICE_PCI_HOT_RESET since the not-opened affected device can
> + * be by other users in the window between the two ioctls.  If the affected
> + * devices are opened by multiple users, the VFIO_DEVICE_PCI_HOT_RESET
> + * shall fail, detail can check the description of VFIO_DEVICE_PCI_HOT_RESET.
> + *
> + * For the users that open vfio group/container, this ioctl is useless as
> + * they have no idea about the iommufd dev_id returned by this ioctl.  For
> + * the users of the traditional mode vfio group/container, this ioctl will
> + * fail as this mode does not use iommufd hence no dev_id to report back.
> + * For the users of the iommufd compat mode vfio group/container, this ioctl
> + * would succeed as this mode uses iommufd as container fd.  But such users
> + * still have no idea about the iommufd dev_id as the dev_id is only stored
> + * in kernel in this mode.  For the users of the vfio group/container, the
> + * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO should be used to know the hot reset
> + * affected devices.
> + *
> + * Return: 0 on success, -errno on failure:
> + *	-enospc = insufficient buffer;
> + *	-enodev = unsupported for device;
> + *	-eperm = no permission for device, this error comes:
> + *		 - when there are affected devices that are opened but
> + *		   not bound to the same iommufd with the current device
> + *		   with which this ioctl is invoked,
> + *		 - there are affected devices that are not bound to vfio
> + *		   driver yet.
> + *		 - no valid iommufd is bound (e.g. noiommu mode)
> + */
> +struct vfio_pci_hot_reset_group_info {
> +	__u32	argsz;
> +	__u32	flags;
> +	__u32	count;
> +	__u32	devices[];
> +};
> +
> +#define VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO	_IO(VFIO_TYPE, VFIO_BASE + 18)
> +
>  /**
>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>   *				    struct vfio_pci_hot_reset)

