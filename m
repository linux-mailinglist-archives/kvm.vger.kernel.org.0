Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ACC32148C
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 11:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhBVKzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 05:55:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbhBVKzT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 05:55:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613991232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4OT0Rqw5Wl9T/7XHQTc0+4SQvZIZjrveo3V9rnAMoIU=;
        b=BibsbbTY3dl5UJ7jD4bIKTjum36eBtaXs9Pu9FwhgtC+NY0+BDG0QFGVbspevxGH7eb4pZ
        uQSE3XjfWNRGqcuh74h0v/fSj7OW2macCnoIYOP3Te92hQ9ETfd6HjhQQtpZBB58xuzUou
        Opz3gdQ2s7yGzm6yZKWH7xORrWcJNm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-fsHw0bK2OuWq84CK_CtRJA-1; Mon, 22 Feb 2021 05:53:50 -0500
X-MC-Unique: fsHw0bK2OuWq84CK_CtRJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784AD801965;
        Mon, 22 Feb 2021 10:53:48 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A573F10016DB;
        Mon, 22 Feb 2021 10:53:40 +0000 (UTC)
Subject: Re: [PATCH v11 01/13] vfio: VFIO_IOMMU_SET_PASID_TABLE
To:     Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
        nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
        zhangfei.gao@linaro.org
References: <20201116110030.32335-1-eric.auger@redhat.com>
 <20201116110030.32335-2-eric.auger@redhat.com>
 <84a111da-1969-1701-9a6d-cae8d7c285c6@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e476f85d-f49f-f9a6-3232-e99a4cb5a0a2@redhat.com>
Date:   Mon, 22 Feb 2021 11:53:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <84a111da-1969-1701-9a6d-cae8d7c285c6@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On 2/2/21 1:34 PM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2020/11/16 19:00, Eric Auger wrote:
>> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
>>
>> This patch adds an VFIO_IOMMU_SET_PASID_TABLE ioctl
>> which aims to pass the virtual iommu guest configuration
>> to the host. This latter takes the form of the so-called
>> PASID table.
>>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v11 -> v12:
>> - use iommu_uapi_set_pasid_table
>> - check SET and UNSET are not set simultaneously (Zenghui)
>>
>> v8 -> v9:
>> - Merge VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE into a single
>>   VFIO_IOMMU_SET_PASID_TABLE ioctl.
>>
>> v6 -> v7:
>> - add a comment related to VFIO_IOMMU_DETACH_PASID_TABLE
>>
>> v3 -> v4:
>> - restore ATTACH/DETACH
>> - add unwind on failure
>>
>> v2 -> v3:
>> - s/BIND_PASID_TABLE/SET_PASID_TABLE
>>
>> v1 -> v2:
>> - s/BIND_GUEST_STAGE/BIND_PASID_TABLE
>> - remove the struct device arg
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 65 +++++++++++++++++++++++++++++++++
>>  include/uapi/linux/vfio.h       | 19 ++++++++++
>>  2 files changed, 84 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 67e827638995..87ddd9e882dc 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2587,6 +2587,41 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>>  	return ret;
>>  }
>>  
>> +static void
>> +vfio_detach_pasid_table(struct vfio_iommu *iommu)
>> +{
>> +	struct vfio_domain *d;
>> +
>> +	mutex_lock(&iommu->lock);
>> +	list_for_each_entry(d, &iommu->domain_list, next)
>> +		iommu_detach_pasid_table(d->domain);
>> +
>> +	mutex_unlock(&iommu->lock);
>> +}
>> +
>> +static int
>> +vfio_attach_pasid_table(struct vfio_iommu *iommu, unsigned long arg)
>> +{
>> +	struct vfio_domain *d;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&iommu->lock);
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		ret = iommu_uapi_attach_pasid_table(d->domain, (void __user *)arg);
> This design is not very clear to me. This assumes all iommu_domains share the same pasid table.
> 
> As I understand, it's reasonable when there is only one group in the domain, and only one domain in the vfio_iommu.
> If more than one group in the vfio_iommu, the guest may put them into different guest iommu_domain, then they have different pasid table.
> 
> Is this the use scenario?

the vfio_iommu is attached to a container. all the groups within a
container share the same set of page tables (linux
Documentation/driver-api/vfio.rst). So to me if you want to use
different pasid tables, the groups need to be attached to different
containers. Does that make sense to you?

Thanks

Eric
> 
> Thanks,
> Keqian
> 
>> +		if (ret)
>> +			goto unwind;
>> +	}
>> +	goto unlock;
>> +unwind:
>> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
>> +		iommu_detach_pasid_table(d->domain);
>> +	}
>> +unlock:
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
>> +
>>  static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
>>  					   struct vfio_info_cap *caps)
>>  {
>> @@ -2747,6 +2782,34 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>>  			-EFAULT : 0;
>>  }
>>  
>> +static int vfio_iommu_type1_set_pasid_table(struct vfio_iommu *iommu,
>> +					    unsigned long arg)
>> +{
>> +	struct vfio_iommu_type1_set_pasid_table spt;
>> +	unsigned long minsz;
>> +	int ret = -EINVAL;
>> +
>> +	minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table, flags);
>> +
>> +	if (copy_from_user(&spt, (void __user *)arg, minsz))
>> +		return -EFAULT;
>> +
>> +	if (spt.argsz < minsz)
>> +		return -EINVAL;
>> +
>> +	if (spt.flags & VFIO_PASID_TABLE_FLAG_SET &&
>> +	    spt.flags & VFIO_PASID_TABLE_FLAG_UNSET)
>> +		return -EINVAL;
>> +
>> +	if (spt.flags & VFIO_PASID_TABLE_FLAG_SET)
>> +		ret = vfio_attach_pasid_table(iommu, arg + minsz);
>> +	else if (spt.flags & VFIO_PASID_TABLE_FLAG_UNSET) {
>> +		vfio_detach_pasid_table(iommu);
>> +		ret = 0;
>> +	}
>> +	return ret;
>> +}
>> +
>>  static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>>  					unsigned long arg)
>>  {
>> @@ -2867,6 +2930,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  		return vfio_iommu_type1_unmap_dma(iommu, arg);
>>  	case VFIO_IOMMU_DIRTY_PAGES:
>>  		return vfio_iommu_type1_dirty_pages(iommu, arg);
>> +	case VFIO_IOMMU_SET_PASID_TABLE:
>> +		return vfio_iommu_type1_set_pasid_table(iommu, arg);
>>  	default:
>>  		return -ENOTTY;
>>  	}
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 2f313a238a8f..78ce3ce6c331 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -14,6 +14,7 @@
>>  
>>  #include <linux/types.h>
>>  #include <linux/ioctl.h>
>> +#include <linux/iommu.h>
>>  
>>  #define VFIO_API_VERSION	0
>>  
>> @@ -1180,6 +1181,24 @@ struct vfio_iommu_type1_dirty_bitmap_get {
>>  
>>  #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>>  
>> +/*
>> + * VFIO_IOMMU_SET_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
>> + *			struct vfio_iommu_type1_set_pasid_table)
>> + *
>> + * The SET operation passes a PASID table to the host while the
>> + * UNSET operation detaches the one currently programmed. Setting
>> + * a table while another is already programmed replaces the old table.
>> + */
>> +struct vfio_iommu_type1_set_pasid_table {
>> +	__u32	argsz;
>> +	__u32	flags;
>> +#define VFIO_PASID_TABLE_FLAG_SET	(1 << 0)
>> +#define VFIO_PASID_TABLE_FLAG_UNSET	(1 << 1)
>> +	struct iommu_pasid_table_config config; /* used on SET */
>> +};
>> +
>> +#define VFIO_IOMMU_SET_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
>> +
>>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>  
>>  /*
>>
> 

