Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E86425C519
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgICPW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:22:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22174 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729063AbgICPWU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 11:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599146538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0HzlZIPywbFcx466Q8/W+zmFpS4jLc5rFIES8a+z/v4=;
        b=eXzV6ZK/CMYhx5eVt5KC7RuDRk82uqQEkEj70vPD30bpiAtTnLCplhsE3B8xyDJitZHRbr
        ZMwzJipnHPO5/q3pCWyfM7durPOeUoR3lBHy31txx9VD3lUjqo3ht0EMUAFXpg6Kc/brqd
        PCH8RmVPB8b+dnBJsludbg66iyjS23Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-98tZJrasMY29zEJNBUFsDw-1; Thu, 03 Sep 2020 11:22:09 -0400
X-MC-Unique: 98tZJrasMY29zEJNBUFsDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2201425DA;
        Thu,  3 Sep 2020 15:22:07 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7887EEC4;
        Thu,  3 Sep 2020 15:22:03 +0000 (UTC)
Subject: Re: [PATCH v4 04/10] vfio/fsl-mc: Implement
 VFIO_DEVICE_GET_REGION_INFO ioctl call
From:   Auger Eric <eric.auger@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-5-diana.craciun@oss.nxp.com>
 <d17469ad-9041-9b1c-64e4-f406888262b7@redhat.com>
Message-ID: <d22338d0-449b-a3f7-d8e6-be1e4620aa5c@redhat.com>
Date:   Thu, 3 Sep 2020 17:22:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d17469ad-9041-9b1c-64e4-f406888262b7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 9/3/20 5:16 PM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> Expose to userspace information about the memory regions.
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 79 ++++++++++++++++++++++-
>>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h | 19 ++++++
>>  2 files changed, 97 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 5a5460d01f00..093b8d68496c 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -17,16 +17,72 @@
>>  
>>  static struct fsl_mc_driver vfio_fsl_mc_driver;
>>  
>> +static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +	int count = mc_dev->obj_desc.region_count;
>> +	int i;
>> +
>> +	vdev->regions = kcalloc(count, sizeof(struct vfio_fsl_mc_region),
>> +				GFP_KERNEL);
>> +	if (!vdev->regions)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < count; i++) {
>> +		struct resource *res = &mc_dev->regions[i];
>> +
>> +		vdev->regions[i].addr = res->start;
>> +		vdev->regions[i].size = resource_size(res);
>> +		vdev->regions[i].flags = 0;
> why 0? I see in
>> +	}
>> +
>> +	vdev->num_regions = mc_dev->obj_desc.region_count;
> nit: you can use count directly fsl-mc-bus.c that flags can take
> meaningful values
Sorry I missed flags and types. So you may set the type in this patch
instead of in next patch?

vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;

Eric
>> +	return 0;
>> +}
>> +
>> +static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
>> +{
>> +	vdev->num_regions = 0;
>> +	kfree(vdev->regions);
>> +}
>> +
>>  static int vfio_fsl_mc_open(void *device_data)
>>  {
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +	int ret;
>> +
>>  	if (!try_module_get(THIS_MODULE))
>>  		return -ENODEV;
>>  
>> +	mutex_lock(&vdev->driver_lock);
>> +	if (!vdev->refcnt) {
>> +		ret = vfio_fsl_mc_regions_init(vdev);
>> +		if (ret)
>> +			goto err_reg_init;
>> +	}
>> +	vdev->refcnt++;
>> +
>> +	mutex_unlock(&vdev->driver_lock);
>> +
>>  	return 0;
>> +
>> +err_reg_init:
>> +	mutex_unlock(&vdev->driver_lock);
>> +	module_put(THIS_MODULE);
>> +	return ret;
>>  }
>>  
>>  static void vfio_fsl_mc_release(void *device_data)
>>  {
>> +	struct vfio_fsl_mc_device *vdev = device_data;
>> +
>> +	mutex_lock(&vdev->driver_lock);
>> +
>> +	if (!(--vdev->refcnt))
>> +		vfio_fsl_mc_regions_cleanup(vdev);
>> +
>> +	mutex_unlock(&vdev->driver_lock);
>> +
>>  	module_put(THIS_MODULE);
>>  }
>>  
>> @@ -59,7 +115,25 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>  	}
>>  	case VFIO_DEVICE_GET_REGION_INFO:
>>  	{
>> -		return -ENOTTY;
>> +		struct vfio_region_info info;
>> +
>> +		minsz = offsetofend(struct vfio_region_info, offset);
>> +
>> +		if (copy_from_user(&info, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (info.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (info.index >= vdev->num_regions)
>> +			return -EINVAL;
>> +
>> +		/* map offset to the physical address  */
>> +		info.offset = VFIO_FSL_MC_INDEX_TO_OFFSET(info.index);
>> +		info.size = vdev->regions[info.index].size;
>> +		info.flags = vdev->regions[info.index].flags;
>> +
>> +		return copy_to_user((void __user *)arg, &info, minsz);
>>  	}
>>  	case VFIO_DEVICE_GET_IRQ_INFO:
>>  	{
>> @@ -204,6 +278,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>>  		vfio_iommu_group_put(group, dev);
>>  		return ret;
>>  	}
>> +	mutex_init(&vdev->driver_lock);
>>  
>>  	return ret;
>>  }
>> @@ -227,6 +302,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>>  
>>  	mc_dev->mc_io = NULL;
>>  
>> +	mutex_destroy(&vdev->driver_lock);
>> +
>>  	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>>  
>>  	return 0;
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> index 37d61eaa58c8..818dfd3df4db 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -7,9 +7,28 @@
>>  #ifndef VFIO_FSL_MC_PRIVATE_H
>>  #define VFIO_FSL_MC_PRIVATE_H
>>  
>> +#define VFIO_FSL_MC_OFFSET_SHIFT    40
>> +#define VFIO_FSL_MC_OFFSET_MASK (((u64)(1) << VFIO_FSL_MC_OFFSET_SHIFT) - 1)
>> +
>> +#define VFIO_FSL_MC_OFFSET_TO_INDEX(off) ((off) >> VFIO_FSL_MC_OFFSET_SHIFT)
>> +
>> +#define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
>> +	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
>> +
>> +struct vfio_fsl_mc_region {
>> +	u32			flags;
>> +	u32			type;
>> +	u64			addr;
>> +	resource_size_t		size;
>> +};
>> +
>>  struct vfio_fsl_mc_device {
>>  	struct fsl_mc_device		*mc_dev;
>>  	struct notifier_block        nb;
>> +	int				refcnt;
>> +	u32				num_regions;
>> +	struct vfio_fsl_mc_region	*regions;
>> +	struct mutex driver_lock;
>>  };
>>  
>>  #endif /* VFIO_FSL_MC_PRIVATE_H */
>>
> Otherwise looks good to me
> 
> Thanks
> 
> Eric
> 

