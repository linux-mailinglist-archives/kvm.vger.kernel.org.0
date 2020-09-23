Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2326D27571D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 13:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgIWL2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 07:28:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59998 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbgIWL2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 07:28:00 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E9297626864E5F774AE4;
        Wed, 23 Sep 2020 19:27:55 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 23 Sep 2020 19:27:47 +0800
Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <joro@8bytes.org>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@linux.intel.com>, <yi.l.liu@intel.com>,
        <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
Date:   Wed, 23 Sep 2020 19:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200320161911.27494-2-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/21 0:19, Eric Auger wrote:
> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
> 
> This patch adds an VFIO_IOMMU_SET_PASID_TABLE ioctl
> which aims to pass the virtual iommu guest configuration
> to the host. This latter takes the form of the so-called
> PASID table.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a177bf2c6683..bfacbd876ee1 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2172,6 +2172,43 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>   	return ret;
>   }
>   
> +static void
> +vfio_detach_pasid_table(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *d;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		iommu_detach_pasid_table(d->domain);
> +	}
> +	mutex_unlock(&iommu->lock);
> +}
> +
> +static int
> +vfio_attach_pasid_table(struct vfio_iommu *iommu,
> +			struct vfio_iommu_type1_set_pasid_table *ustruct)
> +{
> +	struct vfio_domain *d;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		ret = iommu_attach_pasid_table(d->domain, &ustruct->config);
> +		if (ret)
> +			goto unwind;
> +	}
> +	goto unlock;
> +unwind:
> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
> +		iommu_detach_pasid_table(d->domain);
> +	}
> +unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>   static long vfio_iommu_type1_ioctl(void *iommu_data,
>   				   unsigned int cmd, unsigned long arg)
>   {
> @@ -2276,6 +2313,25 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>   
>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>   			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_SET_PASID_TABLE) {
> +		struct vfio_iommu_type1_set_pasid_table ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table,
> +				    config);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (ustruct.flags & VFIO_PASID_TABLE_FLAG_SET)
> +			return vfio_attach_pasid_table(iommu, &ustruct);
> +		else if (ustruct.flags & VFIO_PASID_TABLE_FLAG_UNSET) {
> +			vfio_detach_pasid_table(iommu);
> +			return 0;
> +		} else
> +			return -EINVAL;

Nit:

What if user-space blindly set both flags? Should we check that only one
flag is allowed to be set at this stage, and return error otherwise?

Besides, before going through the whole series [1][2], I'd like to know
if this is the latest version of your Nested-Stage-Setup work in case I
had missed something.

[1] https://lore.kernel.org/r/20200320161911.27494-1-eric.auger@redhat.com
[2] https://lore.kernel.org/r/20200414150607.28488-1-eric.auger@redhat.com


Thanks,
Zenghui
