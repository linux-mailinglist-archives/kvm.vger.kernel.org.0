Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27426D7C4C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 14:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbjDEMUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 08:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEMUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 08:20:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A837440F9
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 05:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680697181;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5+1kMawBl/nlEIVEg2aneISovUB9kQum85WXbiPdJQ0=;
        b=OrorXx0L++RajPU4BEB1M4OT1dbdT3IZHqDZkct8+Wlh5UvHdGqzuLwrt7jztOKpuLwBET
        aM2lTXTuPmNTv58UmhaNNhK5/56IvYqC6M8HU+2eFSoWuBF7PMeuli7IIlHGEmoUSWCj8Q
        hWEpiOumEcQSwjoowakpvwZxv+RyRlw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-1S-zHOc_NGqauiGnLftjCw-1; Wed, 05 Apr 2023 08:19:39 -0400
X-MC-Unique: 1S-zHOc_NGqauiGnLftjCw-1
Received: by mail-qt1-f200.google.com with SMTP id b11-20020ac87fcb000000b003e37d72d532so24175909qtk.18
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 05:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680697179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5+1kMawBl/nlEIVEg2aneISovUB9kQum85WXbiPdJQ0=;
        b=gZYxFtoVbLX6G63kHrIvEP/ufSF2O3J1r21+U3P1fl8p36dI6SFUjGmvN4eZCru+y0
         G1tEcTqb3UE3QBEsOJr53955ITLLnLW6YZGUw05WfQsD2G6dSnxzTLRkXAd+1XpBaNqc
         hR65otJwiTZUWcWPSy35Paz4LikqO9SVWY8W/vgyd+Je7+uKtniFtPc7L/drw1k9GO5i
         VlBT54d3hdJk4pJ09N+xP1b8QqDzgS2YfhvcLH8jzSF9KQMFmE+UUb2W+6W1k/2nCLII
         7RdJWmkNDaDV6gypaC+znzDe1MXWXS+yKyz+VgnHM4/4B6SQ760MWJjqvd1ST8oPaJcw
         H7dQ==
X-Gm-Message-State: AAQBX9cG5YisVysWwfNd8gA5F3rsbs1GQ5Y0jc8QUduVA9OvWgHQcF9Z
        wu1LOeBwfwWU6dlznBqivZB3X6EMZaM+yNwuD7a1+/zIo10HVvUxBCzALIBN1NRae/EOtWYwfHn
        ezVjUFh4a/EVP
X-Received: by 2002:a05:622a:1c8:b0:3bf:be7d:b3e5 with SMTP id t8-20020a05622a01c800b003bfbe7db3e5mr3790677qtw.41.1680697179169;
        Wed, 05 Apr 2023 05:19:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350avUvH/WbMSaeQqAQpozemW5zr7Ld9TT1U8XoQl98UiacAtCaA1H5xnuVc5+TfWYjgXJtcbdw==
X-Received: by 2002:a05:622a:1c8:b0:3bf:be7d:b3e5 with SMTP id t8-20020a05622a01c800b003bfbe7db3e5mr3790641qtw.41.1680697178838;
        Wed, 05 Apr 2023 05:19:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r206-20020a3744d7000000b0074a0051fcd4sm4389532qka.88.2023.04.05.05.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:19:37 -0700 (PDT)
Message-ID: <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
Date:   Wed, 5 Apr 2023 14:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-13-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Yi,
On 4/1/23 16:44, Yi Liu wrote:
> for the users that accept device fds passed from management stacks to be
> able to figure out the host reset affected devices among the devices
> opened by the user. This is needed as such users do not have BDF (bus,
> devfn) knowledge about the devices it has opened, hence unable to use
> the information reported by existing VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
> to figure out the affected devices.
>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 58 ++++++++++++++++++++++++++++----
>  include/uapi/linux/vfio.h        | 24 ++++++++++++-
>  2 files changed, 74 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 19f5b075d70a..a5a7e148dce1 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -30,6 +30,7 @@
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> +#include <uapi/linux/iommufd.h>
>  
>  #include "vfio_pci_priv.h"
>  
> @@ -767,6 +768,20 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>  	return 0;
>  }
>  
> +static struct vfio_device *
> +vfio_pci_find_device_in_devset(struct vfio_device_set *dev_set,
> +			       struct pci_dev *pdev)
> +{
> +	struct vfio_device *cur;
> +
> +	lockdep_assert_held(&dev_set->lock);
> +
> +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> +		if (cur->dev == &pdev->dev)
> +			return cur;
> +	return NULL;
> +}
> +
>  static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
>  {
>  	(*(int *)data)++;
> @@ -776,13 +791,20 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
>  struct vfio_pci_fill_info {
>  	int max;
>  	int cur;
> +	bool require_devid;
> +	struct iommufd_ctx *iommufd;
> +	struct vfio_device_set *dev_set;
>  	struct vfio_pci_dependent_device *devices;
>  };
>  
>  static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_pci_fill_info *fill = data;
> +	struct vfio_device_set *dev_set = fill->dev_set;
>  	struct iommu_group *iommu_group;
> +	struct vfio_device *vdev;
> +
> +	lockdep_assert_held(&dev_set->lock);
>  
>  	if (fill->cur == fill->max)
>  		return -EAGAIN; /* Something changed, try again */
> @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
>  	if (!iommu_group)
>  		return -EPERM; /* Cannot reset non-isolated devices */
>  
> -	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
> +	if (fill->require_devid) {
> +		/*
> +		 * Report dev_id of the devices that are opened as cdev
> +		 * and have the same iommufd with the fill->iommufd.
> +		 * Otherwise, just fill IOMMUFD_INVALID_ID.
> +		 */
> +		vdev = vfio_pci_find_device_in_devset(dev_set, pdev);
> +		if (vdev && vfio_device_cdev_opened(vdev) &&
> +		    fill->iommufd == vfio_iommufd_physical_ictx(vdev))
> +			vfio_iommufd_physical_devid(vdev, &fill->devices[fill->cur].dev_id);
> +		else
> +			fill->devices[fill->cur].dev_id = IOMMUFD_INVALID_ID;
> +	} else {
> +		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
> +	}
>  	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
>  	fill->devices[fill->cur].bus = pdev->bus->number;
>  	fill->devices[fill->cur].devfn = pdev->devfn;
> @@ -1230,17 +1266,27 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  		return -ENOMEM;
>  
>  	fill.devices = devices;
> +	fill.dev_set = vdev->vdev.dev_set;
>  
> +	mutex_lock(&vdev->vdev.dev_set->lock);
> +	if (vfio_device_cdev_opened(&vdev->vdev)) {
> +		fill.require_devid = true;
> +		fill.iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
> +	}
>  	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
>  					    &fill, slot);
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
>  
>  	/*
>  	 * If a device was removed between counting and filling, we may come up
>  	 * short of fill.max.  If a device was added, we'll have a return of
>  	 * -EAGAIN above.
>  	 */
> -	if (!ret)
> +	if (!ret) {
>  		hdr.count = fill.cur;
> +		if (fill.require_devid)
> +			hdr.flags = VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID;
> +	}
>  
>  reset_info_exit:
>  	if (copy_to_user(arg, &hdr, minsz))
> @@ -2346,12 +2392,10 @@ static bool vfio_dev_in_files(struct vfio_pci_core_device *vdev,
>  static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_device_set *dev_set = data;
> -	struct vfio_device *cur;
>  
> -	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> -		if (cur->dev == &pdev->dev)
> -			return 0;
> -	return -EBUSY;
> +	lockdep_assert_held(&dev_set->lock);
> +
> +	return vfio_pci_find_device_in_devset(dev_set, pdev) ? 0 : -EBUSY;
>  }
>  
>  /*
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 25432ef213ee..5a34364e3b94 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -650,11 +650,32 @@ enum {
>   * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
>   *					      struct vfio_pci_hot_reset_info)
>   *
> + * This command is used to query the affected devices in the hot reset for
> + * a given device.  User could use the information reported by this command
> + * to figure out the affected devices among the devices it has opened.
> + * This command always reports the segment, bus and devfn information for
> + * each affected device, and selectively report the group_id or the dev_id
> + * per the way how the device being queried is opened.
> + *	- If the device is opened via the traditional group/container manner,
> + *	  this command reports the group_id for each affected device.
> + *
> + *	- If the device is opened as a cdev, this command needs to report
s/needs to report/reports
> + *	  dev_id for each affected device and set the
> + *	  VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID flag.  For the affected
> + *	  devices that are not opened as cdev or bound to different iommufds
> + *	  with the device that is queried, report an invalid dev_id to avoid
s/bound to different iommufds with the device that is queried/bound to
iommufds different from the reset device one?
> + *	  potential dev_id conflict as dev_id is local to iommufd.  For such
> + *	  affected devices, user shall fall back to use the segment, bus and
> + *	  devfn info to map it to opened device.
> + *
>   * Return: 0 on success, -errno on failure:
>   *	-enospc = insufficient buffer, -enodev = unsupported for device.
>   */
>  struct vfio_pci_dependent_device {
> -	__u32	group_id;
> +	union {
> +		__u32   group_id;
> +		__u32	dev_id;
> +	};
>  	__u16	segment;
>  	__u8	bus;
>  	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
> @@ -663,6 +684,7 @@ struct vfio_pci_dependent_device {
>  struct vfio_pci_hot_reset_info {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID	(1 << 0)
>  	__u32	count;
>  	struct vfio_pci_dependent_device	devices[];
>  };
Eric

