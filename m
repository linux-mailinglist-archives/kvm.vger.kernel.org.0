Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7FB6AD5B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfGPRGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 13:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbfGPRGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 13:06:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7D6B8553A;
        Tue, 16 Jul 2019 17:06:06 +0000 (UTC)
Received: from [10.36.116.32] (ovpn-116-32.ams2.redhat.com [10.36.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DEB91001B32;
        Tue, 16 Jul 2019 17:05:58 +0000 (UTC)
From:   Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v1 3/4] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
To:     "Liu, Yi L" <yi.l.liu@intel.com>, alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe.brucker@arm.com,
        peterx@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org
References: <1562324772-3084-1-git-send-email-yi.l.liu@intel.com>
 <1562324772-3084-4-git-send-email-yi.l.liu@intel.com>
Message-ID: <50587a14-2c66-e7e9-0896-12917ffca428@redhat.com>
Date:   Tue, 16 Jul 2019 19:05:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1562324772-3084-4-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 16 Jul 2019 17:06:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/5/19 1:06 PM, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims
> to passdown PASID allocation/free request from the virtual
> iommu. This is required to get PASID managed in system-wide.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 125 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  25 ++++++++
>  2 files changed, 150 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6fda4fb..d5e0c01 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1832,6 +1832,94 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
>  	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
>  }
>  
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +					 int min_pasid,
> +					 int max_pasid)
> +{
> +	int ret;
> +	ioasid_t pasid;
> +	struct mm_struct *mm = NULL;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
Is this check really mandated and do you really need to hold the iommu lock?
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	mm = get_task_mm(current);
> +	/* Jacob: track ioasid allocation owner by mm */
> +	pasid = ioasid_alloc((struct ioasid_set *)mm, min_pasid,
> +				max_pasid, NULL);
Shouldn't we have a PASID number limit per mm to prevent a guest from
consuming all PASIDs and induce DoS?
> +	if (pasid == INVALID_IOASID) {
> +		ret = -ENOSPC;
> +		goto out_unlock;
> +	}
> +	ret = pasid;
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	if (mm)
> +		mmput(mm);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu, int pasid)
> +{
> +	struct mm_struct *mm = NULL;
> +	void *pdata;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
same here
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	pr_debug("%s: pasid: %d\n", __func__, pasid);
> +
> +	/**
> +	 * TODO:
> +	 * a) for pasid free, needs to return error if free failed
> +	 * b) Sanity check: check if the pasid is allocated to the
> +	 *                  current process such check may be in
> +	 *                  vendor specific pasid_free callback or
> +	 *                  in generic layer
> +	 * c) clean up device list and free p_alloc structure
> +	 *
> +	 * Jacob:
> +	 * There are two cases free could fail:
> +	 * 1. free pasid by non-owner, we can use ioasid_set to track mm, if
> +	 * the set does not match, caller is not permitted to free.
> +	 * 2. free before unbind all devices, we can check if ioasid private
> +	 * data, if data != NULL, then fail to free.
> +	 */
who is going to do the garbage collection of PASIDs used by the guest in
general as we cannot rely on the userspace to do that in general?
> +
> +	mm = get_task_mm(current);
> +	pdata = ioasid_find((struct ioasid_set *)mm, pasid, NULL);
> +	if (IS_ERR(pdata)) {
> +		if (pdata == ERR_PTR(-ENOENT))
> +			pr_debug("pasid %d is not allocated\n", pasid);
> +		else if (pdata == ERR_PTR(-EACCES))
> +			pr_debug("Not owner of pasid %d,"
> +				 "no pasid free allowed\n", pasid);
> +		else
> +			pr_debug("error happened during searching"
> +				 " pasid: %d\n", pasid);
> +		ret = -EPERM;
return actual pdata error?
> +		goto out_unlock;
> +	}
> +	if (pdata) {
> +		pr_debug("Cannot free pasid %d with private data\n", pasid);
> +		/* Expect PASID has no private data if not bond */> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}
> +	ioasid_free(pasid);
> +
> +out_unlock:
> +	if (mm)
> +		mmput(mm);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -1936,6 +2024,43 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  					    &ustruct);
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> +
> +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> +		struct vfio_iommu_type1_pasid_request req;
> +		int min_pasid, max_pasid, pasid;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_pasid_request,
> +				    flag);
> +
> +		if (copy_from_user(&req, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (req.argsz < minsz)
> +			return -EINVAL;
> +
> +		switch (req.flag) {
> +		/**
> +		 * TODO: min_pasid and max_pasid align with
> +		 * typedef unsigned int ioasid_t
indeed
> +		 */
> +		case VFIO_IOMMU_PASID_ALLOC:
> +			if (copy_from_user(&min_pasid,
> +				(void __user *)arg + minsz, sizeof(min_pasid)))
> +				return -EFAULT;
> +			if (copy_from_user(&max_pasid,
> +				(void __user *)arg + minsz + sizeof(min_pasid),
> +				sizeof(max_pasid)))
> +				return -EFAULT;
> +			return vfio_iommu_type1_pasid_alloc(iommu,
> +						min_pasid, max_pasid);
> +		case VFIO_IOMMU_PASID_FREE:
> +			if (copy_from_user(&pasid,
> +				(void __user *)arg + minsz, sizeof(pasid)))
> +				return -EFAULT;
> +			return vfio_iommu_type1_pasid_free(iommu, pasid);
> +		default:
> +			return -EINVAL;
> +		}
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 055aa9b..af03c9f 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -798,6 +798,31 @@ struct vfio_iommu_type1_cache_invalidate {
>  };
>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
>  
> +/*
> + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @min_pasid and @max_pasid fields
inclusive
> + * @flag=VFIO_IOMMU_PASID_FREE, refer to @pasid field
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
do you want a bitfield or an enum value here?
> +	__u32	flag;
> +	union {
> +		struct {
> +			int min_pasid;
int -> __u32
> +			int max_pasid;
> +		};
> +		int pasid;
> +	};
if you name the union field you can simplify the minsz/copy_from_user
code I think.
> +};
> +
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 27,
> + *				struct vfio_iommu_type1_pasid_request)
> + *
> + */
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 27)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*
> 

Thanks

Eric
