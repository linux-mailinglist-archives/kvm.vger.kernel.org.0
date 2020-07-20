Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB3225BF0
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgGTJmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 05:42:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728203AbgGTJmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 05:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595238125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WDW4X00PY40xLtN9P1zgfvv+w8tBCqWK1/ojx/SjtYA=;
        b=DYHrncoy7RHGma2VWpd06fmw2G9cuhPASxCSk/O139sGso7mI3BKFKjy8qEjKcdzbKyZfe
        8ZD80EJ2EAzmlRHZXDt4xb7kzJsJ0GVFAHg+Fg8ZM5F9mnhlBuSiujByEZDm+KujbVg5G0
        nR4HMpxTbcAOCNG3WJ6W7onqzjizF3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-0kBE9218NKmVA08xfcG3Xw-1; Mon, 20 Jul 2020 05:42:02 -0400
X-MC-Unique: 0kBE9218NKmVA08xfcG3Xw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58C86100960F;
        Mon, 20 Jul 2020 09:42:00 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1A51619C4;
        Mon, 20 Jul 2020 09:41:48 +0000 (UTC)
Subject: Re: [PATCH v5 11/15] vfio/type1: Allow invalidating first-level/stage
 IOMMU cache
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-12-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <3b44dc59-cd78-2b72-965e-2f169cacdade@redhat.com>
Date:   Mon, 20 Jul 2020 11:41:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-12-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 7/12/20 1:21 PM, Liu Yi L wrote:
> This patch provides an interface allowing the userspace to invalidate
> IOMMU cache for first-level page table. It is required when the first
> level IOMMU page table is not managed by the host kernel in the nested
> translation setup.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v1 -> v2:
> *) rename from "vfio/type1: Flush stage-1 IOMMU cache for nesting type"
> *) rename vfio_cache_inv_fn() to vfio_dev_cache_invalidate_fn()
> *) vfio_dev_cache_inv_fn() always successful
> *) remove VFIO_IOMMU_CACHE_INVALIDATE, and reuse VFIO_IOMMU_NESTING_OP
> ---
>  drivers/vfio/vfio_iommu_type1.c | 50 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  3 +++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index f0f21ff..960cc59 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -3073,6 +3073,53 @@ static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_dev_cache_invalidate_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *)dc->data;
> +
> +	iommu_cache_invalidate(dc->domain, dev, (void __user *)arg);
> +	return 0;
> +}
> +
> +static long vfio_iommu_invalidate_cache(struct vfio_iommu *iommu,
> +					unsigned long arg)
> +{
> +	struct domain_capsule dc = { .data = &arg };
> +	struct vfio_group *group;
> +	struct vfio_domain *domain;
> +	int ret = 0;
> +	struct iommu_nesting_info *info;
> +
> +	mutex_lock(&iommu->lock);
> +	/*
> +	 * Cache invalidation is required for any nesting IOMMU,
> +	 * so no need to check system-wide PASID support.
> +	 */
> +	info = iommu->nesting_info;
> +	if (!info || !(info->features & IOMMU_NESTING_FEAT_CACHE_INVLD)) {
> +		ret = -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
> +
> +	group = vfio_find_nesting_group(iommu);
so I see you reuse it here. But still wondering if you cant't directly
set dc.domain and dc.group group below using list_firt_entry?
> +	if (!group) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	domain = list_first_entry(&iommu->domain_list,
> +				  struct vfio_domain, next);
> +	dc.group = group;
> +	dc.domain = domain->domain;
> +	iommu_group_for_each_dev(group->iommu_group, &dc,
> +				 vfio_dev_cache_invalidate_fn);
> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
>  					unsigned long arg)
>  {
> @@ -3095,6 +3142,9 @@ static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
>  	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
>  		ret = vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
>  		break;
> +	case VFIO_IOMMU_NESTING_OP_CACHE_INVLD:
> +		ret = vfio_iommu_invalidate_cache(iommu, arg + minsz);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index a8ad786..845a5800 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1225,6 +1225,8 @@ struct vfio_iommu_type1_pasid_request {
>   * +-----------------+-----------------------------------------------+
>   * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
>   * +-----------------+-----------------------------------------------+
> + * | CACHE_INVLD     |      struct iommu_cache_invalidate_info       |
> + * +-----------------+-----------------------------------------------+
>   *
>   * returns: 0 on success, -errno on failure.
>   */
> @@ -1237,6 +1239,7 @@ struct vfio_iommu_type1_nesting_op {
>  
>  #define VFIO_IOMMU_NESTING_OP_BIND_PGTBL	(0)
>  #define VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL	(1)
> +#define VFIO_IOMMU_NESTING_OP_CACHE_INVLD	(2)
>  
>  #define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 19)
>  
> 
Otherwise looks good to me

Thanks

Eric

