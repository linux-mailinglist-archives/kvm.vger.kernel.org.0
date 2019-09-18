Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05922B5B68
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 07:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfIRFzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 01:55:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfIRFzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 01:55:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82854302C068;
        Wed, 18 Sep 2019 05:55:12 +0000 (UTC)
Received: from [10.72.12.111] (ovpn-12-111.pek2.redhat.com [10.72.12.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38C2160872;
        Wed, 18 Sep 2019 05:54:47 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] mdev: introduce device specific ops
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, freude@linux.ibm.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com
References: <20190912094012.29653-1-jasowang@redhat.com>
 <20190912094012.29653-3-jasowang@redhat.com>
 <20190917144240.6a59b65f.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <48eccb97-5dee-f1cd-5650-59a0bafd3044@redhat.com>
Date:   Wed, 18 Sep 2019 13:54:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917144240.6a59b65f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 18 Sep 2019 05:55:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/9/17 下午8:42, Cornelia Huck wrote:
> On Thu, 12 Sep 2019 17:40:12 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> Currently, except for the crate and remove. The rest fields of
>> mdev_parent_ops is just designed for vfio-mdev driver and may not help
>> for kernel mdev driver. So follow the device id support by previous
>> patch, this patch introduces device specific ops which points to
>> device specific ops (e.g vfio ops). This allows the future drivers
>> like virtio-mdev to implement its own device specific ops.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/gpu/drm/i915/gvt/kvmgt.c  | 14 +++---
>>   drivers/s390/cio/vfio_ccw_ops.c   | 14 +++---
>>   drivers/s390/crypto/vfio_ap_ops.c | 10 +++--
>>   drivers/vfio/mdev/vfio_mdev.c     | 30 +++++++------
>>   include/linux/mdev.h              | 72 ++++++++++++++++++-------------
>>   samples/vfio-mdev/mbochs.c        | 16 ++++---
>>   samples/vfio-mdev/mdpy.c          | 16 ++++---
>>   samples/vfio-mdev/mtty.c          | 14 +++---
>>   8 files changed, 113 insertions(+), 73 deletions(-)
>> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
>> index f85045392120..3b8a76bc69cf 100644
>> --- a/include/linux/mdev.h
>> +++ b/include/linux/mdev.h
>> @@ -27,27 +27,9 @@ int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
>>   struct device *mdev_get_iommu_device(struct device *dev);
>>   
>>   /**
>> - * struct mdev_parent_ops - Structure to be registered for each parent device to
>> - * register the device to mdev module.
>> + * struct vfio_mdev_parent_ops - Structure to be registered for each
>> + * parent device to register the device to vfio-mdev module.
>>    *
>> - * @owner:		The module owner.
>> - * @dev_attr_groups:	Attributes of the parent device.
>> - * @mdev_attr_groups:	Attributes of the mediated device.
>> - * @supported_type_groups: Attributes to define supported types. It is mandatory
>> - *			to provide supported types.
>> - * @create:		Called to allocate basic resources in parent device's
>> - *			driver for a particular mediated device. It is
>> - *			mandatory to provide create ops.
>> - *			@kobj: kobject of type for which 'create' is called.
>> - *			@mdev: mdev_device structure on of mediated device
>> - *			      that is being created
>> - *			Returns integer: success (0) or error (< 0)
>> - * @remove:		Called to free resources in parent device's driver for a
>> - *			a mediated device. It is mandatory to provide 'remove'
>> - *			ops.
>> - *			@mdev: mdev_device device structure which is being
>> - *			       destroyed
>> - *			Returns integer: success (0) or error (< 0)
>>    * @open:		Open mediated device.
>>    *			@mdev: mediated device.
>>    *			Returns integer: success (0) or error (< 0)
>> @@ -72,6 +54,43 @@ struct device *mdev_get_iommu_device(struct device *dev);
>>    * @mmap:		mmap callback
>>    *			@mdev: mediated device structure
>>    *			@vma: vma structure
>> + */
>> +struct vfio_mdev_parent_ops {
>> +	int     (*open)(struct mdev_device *mdev);
>> +	void    (*release)(struct mdev_device *mdev);
>> +	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
>> +			size_t count, loff_t *ppos);
>> +	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
>> +			 size_t count, loff_t *ppos);
>> +	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>> +			 unsigned long arg);
>> +	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
>> +};
>> +
>> +/**
>> + * struct mdev_parent_ops - Structure to be registered for each parent device to
>> + * register the device to mdev module.
>> + *
>> + * @owner:		The module owner.
>> + * @dev_attr_groups:	Attributes of the parent device.
>> + * @mdev_attr_groups:	Attributes of the mediated device.
>> + * @supported_type_groups: Attributes to define supported types. It is mandatory
>> + *			to provide supported types.
>> + * @create:		Called to allocate basic resources in parent device's
>> + *			driver for a particular mediated device. It is
>> + *			mandatory to provide create ops.
>> + *			@kobj: kobject of type for which 'create' is called.
>> + *			@mdev: mdev_device structure on of mediated device
>> + *			      that is being created
>> + *			Returns integer: success (0) or error (< 0)
>> + * @remove:		Called to free resources in parent device's driver for a
>> + *			a mediated device. It is mandatory to provide 'remove'
>> + *			ops.
>> + *			@mdev: mdev_device device structure which is being
>> + *			       destroyed
>> + *			Returns integer: success (0) or error (< 0)
>> + * @device_ops:         Device specific emulation callback.
>> + *
>>    * Parent device that support mediated device should be registered with mdev
>>    * module with mdev_parent_ops structure.
>>    **/
>> @@ -83,15 +102,7 @@ struct mdev_parent_ops {
>>   
>>   	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>>   	int     (*remove)(struct mdev_device *mdev);
>> -	int     (*open)(struct mdev_device *mdev);
>> -	void    (*release)(struct mdev_device *mdev);
>> -	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
>> -			size_t count, loff_t *ppos);
>> -	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
>> -			 size_t count, loff_t *ppos);
>> -	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
>> -			 unsigned long arg);
>> -	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
>> +	const void *device_ops;
>>   };
>>   
>>   /* interface for exporting mdev supported type attributes */
> This basically looks like a split between stuff that is always
> triggered from userspace (create and the like) and stuff that is
> triggered from userspace for vfio mdevs, but not necessarily for other
> mdevs.


Yes.


>   Seems reasonable at a glance.
>
> If we decide to go forward with this, we should also update the
> documentation (split out stuff from driver-api/vfio-mediated-device.rst
> etc.)


Yes, I plan to do that.

Thanks

