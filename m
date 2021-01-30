Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77C630936F
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 10:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhA3JeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 04:34:21 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11959 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhA3Jcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 04:32:39 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DSTTh07dTzjFGt;
        Sat, 30 Jan 2021 17:30:48 +0800 (CST)
Received: from [10.174.184.214] (10.174.184.214) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Sat, 30 Jan 2021 17:31:41 +0800
Subject: Re: [RFC PATCH v1 3/4] vfio: Try to enable IOPF for VFIO devices
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210125090402.1429-4-lushenming@huawei.com>
 <20210129154200.5cc727a0@omen.home.shazbot.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <30dcb015-af66-3ae3-f65f-52e3d9f0aaaf@huawei.com>
Date:   Sat, 30 Jan 2021 17:31:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210129154200.5cc727a0@omen.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.214]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/30 6:42, Alex Williamson wrote:
> On Mon, 25 Jan 2021 17:04:01 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> If IOMMU_DEV_FEAT_IOPF is set for the VFIO device, which means that
>> the delivering of page faults of this device from the IOMMU is enabled,
>> we register the VFIO page fault handler to complete the whole faulting
>> path (HW+SW). And add a iopf_enabled field in struct vfio_device to
>> record it.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/vfio/vfio.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
>> index ff7797260d0f..fd885d99ee0f 100644
>> --- a/drivers/vfio/vfio.c
>> +++ b/drivers/vfio/vfio.c
>> @@ -97,6 +97,7 @@ struct vfio_device {
>>  	struct vfio_group		*group;
>>  	struct list_head		group_next;
>>  	void				*device_data;
>> +	bool				iopf_enabled;
>>  };
>>  
>>  #ifdef CONFIG_VFIO_NOIOMMU
>> @@ -532,6 +533,21 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
>>  /**
>>   * Device objects - create, release, get, put, search
>>   */
>> +
>> +static void vfio_device_enable_iopf(struct vfio_device *device)
>> +{
>> +	struct device *dev = device->dev;
>> +
>> +	if (!iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_IOPF))
>> +		return;
>> +
>> +	if (WARN_ON(iommu_register_device_fault_handler(dev,
>> +					vfio_iommu_dev_fault_handler, dev)))
> 
> The layering here is wrong, vfio-core doesn't manage the IOMMU, we have
> backend IOMMU drivers for that.  We can't even assume we have IOMMU API
> support here, that's what the type1 backend handles.  Thanks,

Thanks for pointing it out, I will correct it: maybe do the enabling via
the VFIO_IOMMU_ENABLE_IOPF ioctl mentioned in the cover and suggest the
user to call it before VFIO_IOMMU_MAP_DMA, also move the iopf_enabled field
from struct vfio_device to struct vfio_iommu...

Thanks,
Shenming

> 
> Alex
> 
>> +		return;
>> +
>> +	device->iopf_enabled = true;
>> +}
>> +
>>  static
>>  struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>>  					     struct device *dev,
>> @@ -549,6 +565,8 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>>  	device->group = group;
>>  	device->ops = ops;
>>  	device->device_data = device_data;
>> +	/* By default try to enable IOPF */
>> +	vfio_device_enable_iopf(device);
>>  	dev_set_drvdata(dev, device);
>>  
>>  	/* No need to get group_lock, caller has group reference */
>> @@ -573,6 +591,8 @@ static void vfio_device_release(struct kref *kref)
>>  	mutex_unlock(&group->device_lock);
>>  
>>  	dev_set_drvdata(device->dev, NULL);
>> +	if (device->iopf_enabled)
>> +		WARN_ON(iommu_unregister_device_fault_handler(device->dev));
>>  
>>  	kfree(device);
>>  
> 
> .
> 
