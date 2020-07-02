Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE070212EBB
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGBVUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 17:20:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726117AbgGBVUO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 17:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593724813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQ4PQ2Cyjs5VmWvYWsDQjP5xJEApm1RSLA8rAcI8JbM=;
        b=S3K5I/BbAT+jLQUq/XV85R+92FAGD/+HcSUgsSFRreCofGrXQkeKI3BRzEaKiCo2Lnaa5U
        8/ent3IYHa9oDUWuJoxmBqWq3eBMXOKhEBzGFd9ljZ3Q20aVUOblKQQR9pvRWCDTa3FvQA
        4x6NqIaJg3s6viG3QW+Y2NHwFPi3sFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-v_uZM9lwPZ2rvQNAS0XeCA-1; Thu, 02 Jul 2020 17:20:11 -0400
X-MC-Unique: v_uZM9lwPZ2rvQNAS0XeCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC3053640D;
        Thu,  2 Jul 2020 21:20:08 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D6655D9CA;
        Thu,  2 Jul 2020 21:19:59 +0000 (UTC)
Date:   Thu, 2 Jul 2020 15:19:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/14] vfio/type1: Allow invalidating
 first-level/stage IOMMU cache
Message-ID: <20200702151958.430a979d@x1.home>
In-Reply-To: <1592988927-48009-11-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-11-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 01:55:23 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

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
>  drivers/vfio/vfio_iommu_type1.c | 52 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  3 +++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5926533..4c21300 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -3080,6 +3080,53 @@ static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_dev_cache_invalidate_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc = (struct domain_capsule *)data;
> +	unsigned long arg = *(unsigned long *) dc->data;
> +
> +	iommu_cache_invalidate(dc->domain, dev, (void __user *) arg);
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
> +		ret = -ENOTSUPP;
> +		goto out_unlock;
> +	}
> +
> +	group = vfio_find_nesting_group(iommu);
> +	if (!group) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	domain = list_first_entry(&iommu->domain_list,
> +				      struct vfio_domain, next);
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
> @@ -3102,6 +3149,11 @@ static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
>  	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
>  		ret = vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
>  		break;
> +	case VFIO_IOMMU_NESTING_OP_CACHE_INVLD:
> +	{
> +		ret = vfio_iommu_invalidate_cache(iommu, arg + minsz);
> +		break;
> +	}


Why the {} brackets?  Thanks,

Alex


>  	default:
>  		ret = -EINVAL;
>  	}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2c9def8..7f8678e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1213,6 +1213,8 @@ struct vfio_iommu_type1_pasid_request {
>   * +-----------------+-----------------------------------------------+
>   * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
>   * +-----------------+-----------------------------------------------+
> + * | CACHE_INVLD     |      struct iommu_cache_invalidate_info       |
> + * +-----------------+-----------------------------------------------+
>   *
>   * returns: 0 on success, -errno on failure.
>   */
> @@ -1225,6 +1227,7 @@ struct vfio_iommu_type1_nesting_op {
>  
>  #define VFIO_IOMMU_NESTING_OP_BIND_PGTBL	(0)
>  #define VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL	(1)
> +#define VFIO_IOMMU_NESTING_OP_CACHE_INVLD	(2)
>  
>  #define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 19)
>  

